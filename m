From: akpm@linux-foundation.org
Subject: - autofs4-reinstate-negatitive-timeout-of-mount-fails.patch removed from -mm tree
Date: Tue, 05 Feb 2008 23:40:58 -0800
Message-ID: <200802060740.m167edkZ032199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57070 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759961AbYBFHkq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 02:40:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: reinstate negatitive timeout if mount fails
has been removed from the -mm tree.  Its filename was
     autofs4-reinstate-negatitive-timeout-of-mount-fails.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: reinstate negatitive timeout if mount fails
From: Ian Kent <raven@themaw.net>

Due to a change to fs/dcache.c:d_lookup() in the 2.6 kernel whereby only
hashed dentrys are returned the negative caching of mount failures stopped
working in the autofs4 module for nobrowse mount (ie.  directory created at
mount time and removed at umount or following a mount failure).

This patch keeps track of the dentrys from mount fails in order to be
able check the timeout since the last fail and return the appropriate
status. In addition the timeout value is settable at load time as a
module option and via sysfs using the module
parameter /sys/module/autofs4/parameters/negative_timeout.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h |   16 ++
 fs/autofs4/init.c     |    4 
 fs/autofs4/inode.c    |   14 ++
 fs/autofs4/root.c     |  230 ++++++++++++++++++++++++++++++++++++----
 4 files changed, 240 insertions(+), 24 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-reinstate-negatitive-timeout-of-mount-fails fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-reinstate-negatitive-timeout-of-mount-fails
+++ a/fs/autofs4/autofs_i.h
@@ -40,6 +40,14 @@
 #define DPRINTK(fmt,args...) do {} while(0)
 #endif
 
+/*
+ * If the daemon returns a negative response (AUTOFS_IOC_FAIL) then we keep
+ * the negative response cached for up to the time given here, although
+ * the time can be shorter if the kernel throws the dcache entry away.
+ */
+#define AUTOFS_NEGATIVE_TIMEOUT	60	/* default 1 minute */
+extern unsigned int negative_timeout;
+
 /* Unified info structure.  This is pointed to by both the dentry and
    inode structures.  Each file in the filesystem has an instance of this
    structure.  It holds a reference to the dentry, so dentries are never
@@ -52,8 +60,16 @@ struct autofs_info {
 
 	int		flags;
 
+	/*
+	 * Two types of unhashed dentry can exist on this list.
+	 * Negative dentrys from failed mounts and positive dentrys
+	 * resulting from a race between expire and mount. This
+	 * fact is used when looking for dentrys in the list.
+	 */
 	struct list_head rehash;
 
+	unsigned int negative_timeout;
+
 	struct autofs_sb_info *sbi;
 	unsigned long last_used;
 	atomic_t count;
diff -puN fs/autofs4/init.c~autofs4-reinstate-negatitive-timeout-of-mount-fails fs/autofs4/init.c
--- a/fs/autofs4/init.c~autofs4-reinstate-negatitive-timeout-of-mount-fails
+++ a/fs/autofs4/init.c
@@ -14,6 +14,10 @@
 #include <linux/init.h>
 #include "autofs_i.h"
 
+unsigned int negative_timeout = AUTOFS_NEGATIVE_TIMEOUT;
+module_param(negative_timeout, uint, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(negative_timeout, "Cache mount fails negatively for this many seconds");
+
 static int autofs_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
 {
diff -puN fs/autofs4/inode.c~autofs4-reinstate-negatitive-timeout-of-mount-fails fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs4-reinstate-negatitive-timeout-of-mount-fails
+++ a/fs/autofs4/inode.c
@@ -46,6 +46,7 @@ struct autofs_info *autofs4_init_ino(str
 	ino->inode = NULL;
 	ino->dentry = NULL;
 	ino->size = 0;
+	ino->negative_timeout = negative_timeout;
 
 	INIT_LIST_HEAD(&ino->rehash);
 
@@ -98,11 +99,22 @@ void autofs4_free_ino(struct autofs_info
 static void autofs4_force_release(struct autofs_sb_info *sbi)
 {
 	struct dentry *this_parent = sbi->sb->s_root;
-	struct list_head *next;
+	struct list_head *p, *next;
 
 	if (!sbi->sb->s_root)
 		return;
 
+	/* Cleanup the negative dentry cache */
+	spin_lock(&sbi->rehash_lock);
+	list_for_each_safe(p, next, &sbi->rehash_list) {
+		struct autofs_info *ino;
+		ino = list_entry(p, struct autofs_info, rehash);
+		spin_unlock(&sbi->rehash_lock);
+		dput(ino->dentry);
+		spin_lock(&sbi->rehash_lock);
+	}
+	spin_unlock(&sbi->rehash_lock);
+
 	spin_lock(&dcache_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
diff -puN fs/autofs4/root.c~autofs4-reinstate-negatitive-timeout-of-mount-fails fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-reinstate-negatitive-timeout-of-mount-fails
+++ a/fs/autofs4/root.c
@@ -238,6 +238,125 @@ out:
 	return dcache_readdir(file, dirent, filldir);
 }
 
+static int autofs4_compare_dentry(struct dentry *parent, struct dentry *dentry, struct qstr *name)
+{
+	unsigned int len = name->len;
+	unsigned int hash = name->hash;
+	const unsigned char *str = name->name;
+	struct qstr *qstr = &dentry->d_name;
+
+	if (dentry->d_name.hash != hash)
+		return 0;
+	if (dentry->d_parent != parent)
+		return 0;
+
+	if (qstr->len != len)
+		return 0;
+	if (memcmp(qstr->name, str, len))
+		return 0;
+
+	return 1;
+}
+
+static struct dentry *autofs4_lookup_dentry(struct autofs_sb_info *sbi, struct dentry *dentry)
+{
+	struct dentry *parent = dentry->d_parent;
+	struct qstr *name = &dentry->d_name;
+	struct list_head *p, *head;
+
+	head = &sbi->rehash_list;
+	list_for_each(p, head) {
+		struct autofs_info *ino;
+		struct dentry *this;
+
+		ino = list_entry(p, struct autofs_info, rehash);
+		this = ino->dentry;
+
+		spin_lock(&this->d_lock);
+
+		if (!autofs4_compare_dentry(parent, this, name))
+			goto next;
+
+		if (d_unhashed(this)) {
+			spin_unlock(&this->d_lock);
+			return this;
+		}
+next:
+		spin_unlock(&this->d_lock);
+	}
+
+	return NULL;
+}
+
+static struct dentry *autofs4_lookup_negative(struct autofs_sb_info *sbi, struct dentry *dentry)
+{
+	struct dentry *parent = dentry->d_parent;
+	struct qstr *name = &dentry->d_name;
+	struct list_head *p, *head;
+
+	spin_lock(&sbi->rehash_lock);
+	head = &sbi->rehash_list;
+	list_for_each(p, head) {
+		struct autofs_info *ino;
+		struct dentry *this;
+
+		ino = list_entry(p, struct autofs_info, rehash);
+		this = ino->dentry;
+
+		spin_lock(&this->d_lock);
+
+		if (this->d_inode)
+			goto next;
+
+		if (!autofs4_compare_dentry(parent, this, name))
+			goto next;
+
+		if (d_unhashed(this)) {
+			if (autofs4_oz_mode(sbi)) {
+				spin_unlock(&this->d_lock);
+				spin_unlock(&sbi->rehash_lock);
+				return this;
+			}
+			/*
+			 * If d_time is non-zero we've had a mount fail.
+			 * Check if it's time to forget about it, return
+			 * fail if not.
+			 */
+			if (this->d_time) {
+				struct autofs_info *p_ino;
+				unsigned long neg_timeout;
+
+				neg_timeout = this->d_time - get_seconds();
+				if (neg_timeout <= ino->negative_timeout) {
+					spin_unlock(&this->d_lock);
+					spin_unlock(&sbi->rehash_lock);
+					return ERR_PTR(-ENOENT);
+				}
+				/* Negative cache timeout */
+				this->d_time = 0;
+				list_del_init(&ino->rehash);
+				spin_unlock(&this->d_lock);
+				spin_unlock(&sbi->rehash_lock);
+				if (atomic_dec_and_test(&ino->count)) {
+					p_ino = autofs4_dentry_ino(this->d_parent);
+					if (p_ino && this->d_parent != this)
+						atomic_dec(&p_ino->count);
+				}
+				dput(this);
+				return NULL;
+			}
+			spin_unlock(&this->d_lock);
+			spin_unlock(&sbi->rehash_lock);
+			return this;
+		}
+next:
+		spin_unlock(&this->d_lock);
+	}
+	spin_unlock(&sbi->rehash_lock);
+
+	return NULL;
+}
+
 static int try_to_fill_dentry(struct dentry *dentry, int flags)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
@@ -282,7 +401,27 @@ static int try_to_fill_dentry(struct den
 
 		/* Turn this into a real negative dentry? */
 		if (status == -ENOENT) {
+			if (!ino) {
+				ino = autofs4_init_ino(ino, sbi, S_IFDIR | 0555);
+				if (ino == NULL)
+					return -ENOSPC;
+				dentry->d_fsdata = ino;
+			}
+			spin_lock(&sbi->rehash_lock);
+			if (!autofs4_lookup_dentry(sbi, dentry)) {
+				struct autofs_info *p_ino;
+				ino->dentry = dget(dentry);
+				atomic_inc(&ino->count);
+				p_ino = autofs4_dentry_ino(dentry->d_parent);
+				if (p_ino && dentry->d_parent != dentry)
+					atomic_inc(&p_ino->count);
+				list_add(&ino->rehash, &sbi->rehash_list);
+			}
+			spin_unlock(&sbi->rehash_lock);
+			/* Set time at which we forget about this mount fial */
 			spin_lock(&dentry->d_lock);
+			ino->negative_timeout = negative_timeout;
+			dentry->d_time = get_seconds() + negative_timeout;
 			dentry->d_flags &= ~DCACHE_AUTOFS_PENDING;
 			spin_unlock(&dentry->d_lock);
 			return status;
@@ -305,6 +444,11 @@ static int try_to_fill_dentry(struct den
 
 		if (status) {
 			spin_lock(&dentry->d_lock);
+			/* Set time at which we forget about this mount fial */
+			if (status == -ENOENT) {
+				ino->negative_timeout = negative_timeout;
+				dentry->d_time = get_seconds() + negative_timeout;
+			}
 			dentry->d_flags &= ~DCACHE_AUTOFS_PENDING;
 			spin_unlock(&dentry->d_lock);
 			return status;
@@ -316,6 +460,7 @@ static int try_to_fill_dentry(struct den
 		ino->last_used = jiffies;
 
 	spin_lock(&dentry->d_lock);
+	dentry->d_time = 0;
 	dentry->d_flags &= ~DCACHE_AUTOFS_PENDING;
 	spin_unlock(&dentry->d_lock);
 	return status;
@@ -339,6 +484,19 @@ static void *autofs4_follow_link(struct 
 	if (oz_mode || !lookup_type)
 		goto done;
 
+	/* Check for cached mount fail, reset d_time if timed out */
+	spin_lock(&dentry->d_lock);
+	if (dentry->d_time) {
+		unsigned long neg_timeout = dentry->d_time - get_seconds();
+		if (neg_timeout <= ino->negative_timeout) {
+			spin_unlock(&dentry->d_lock);
+			status = -ENOENT;
+			goto out_error;
+		}
+		dentry->d_time = 0;
+	}
+	spin_unlock(&dentry->d_lock);
+
 	/* If an expire request is pending wait for it. */
 	if (ino && (ino->flags & AUTOFS_INF_EXPIRING)) {
 		DPRINTK("waiting for active request %p name=%.*s",
@@ -426,9 +584,28 @@ static int autofs4_revalidate(struct den
 		return status;
 	}
 
-	/* Negative dentry.. invalidate if "old" */
-	if (dentry->d_inode == NULL)
-		return 0;
+	/* Check for cached mount fail, reset d_time if timed out */
+	spin_lock(&dentry->d_lock);
+	if (!dentry->d_inode || dentry->d_time) {
+		struct autofs_info *ino = autofs4_dentry_ino(dentry);
+		unsigned long neg_timeout = dentry->d_time - get_seconds();
+		/*
+		 * If d_time is non-zero we've had a mount fail. Check if
+		 * it's time to forget about it, return fail if not.
+		 */
+		if (dentry->d_time && (neg_timeout <= ino->negative_timeout)) {
+			spin_unlock(&dentry->d_lock);
+			return 1;
+		}
+		/* Negative timeout has expired */
+		dentry->d_time = 0;
+
+		if (!dentry->d_inode) {
+			spin_unlock(&dentry->d_lock);
+			return 0;
+		}
+	}
+	spin_unlock(&dentry->d_lock);
 
 	/* Check for a non-mountpoint directory with no contents */
 	spin_lock(&dcache_lock);
@@ -497,9 +674,6 @@ static struct dentry_operations autofs4_
 
 static struct dentry *autofs4_lookup_unhashed(struct autofs_sb_info *sbi, struct dentry *parent, struct qstr *name)
 {
-	unsigned int len = name->len;
-	unsigned int hash = name->hash;
-	const unsigned char *str = name->name;
 	struct list_head *p, *head;
 
 	spin_lock(&dcache_lock);
@@ -508,7 +682,6 @@ static struct dentry *autofs4_lookup_unh
 	list_for_each(p, head) {
 		struct autofs_info *ino;
 		struct dentry *dentry;
-		struct qstr *qstr;
 
 		ino = list_entry(p, struct autofs_info, rehash);
 		dentry = ino->dentry;
@@ -519,20 +692,10 @@ static struct dentry *autofs4_lookup_unh
 		if (!dentry->d_inode)
 			goto next;
 
-		qstr = &dentry->d_name;
-
-		if (dentry->d_name.hash != hash)
-			goto next;
-		if (dentry->d_parent != parent)
-			goto next;
-
-		if (qstr->len != len)
-			goto next;
-		if (memcmp(qstr->name, str, len))
+		if (!autofs4_compare_dentry(parent, dentry, name))
 			goto next;
 
 		if (d_unhashed(dentry)) {
-			struct autofs_info *ino = autofs4_dentry_ino(dentry);
 			struct inode *inode = dentry->d_inode;
 
 			list_del_init(&ino->rehash);
@@ -568,7 +731,7 @@ next:
 static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 {
 	struct autofs_sb_info *sbi;
-	struct dentry *unhashed;
+	struct dentry *unhashed, *negative = NULL;
 	int oz_mode;
 
 	DPRINTK("name = %.*s",
@@ -587,6 +750,22 @@ static struct dentry *autofs4_lookup(str
 	unhashed = autofs4_lookup_unhashed(sbi, dentry->d_parent, &dentry->d_name);
 	if (!unhashed) {
 		/*
+		 * Negative caching of failed "nobrowse" autofs mounts
+		 * require that we keep the unhashed, negative dentrys
+		 * around so we can use them to check failure status. We
+		 * use the rehash_list list in the super bloxk for this
+		 * purpose. This isn't needed for "browse" or direct mounts
+		 * as the dentrys are always positive so the info is always
+		 * available.
+		 */
+		negative = autofs4_lookup_negative(sbi, dentry);
+		if (negative) {
+			if (IS_ERR(negative))
+				return negative;
+			dentry = negative;
+			goto found;
+		}
+		/*
 		 * Mark the dentry incomplete but don't hash it. We do this
 		 * to serialize our inode creation operations (symlink and
 		 * mkdir) which prevents deadlock during the callback to
@@ -599,6 +778,7 @@ static struct dentry *autofs4_lookup(str
 		 */
 		dentry->d_op = &autofs4_root_dentry_operations;
 
+		dentry->d_time = 0;
 		dentry->d_fsdata = NULL;
 		d_instantiate(dentry, NULL);
 	} else {
@@ -621,7 +801,7 @@ static struct dentry *autofs4_lookup(str
 		}
 		dentry = unhashed;
 	}
-
+found:
 	if (!oz_mode) {
 		spin_lock(&dentry->d_lock);
 		dentry->d_flags |= DCACHE_AUTOFS_PENDING;
@@ -682,7 +862,7 @@ static struct dentry *autofs4_lookup(str
 		return dentry;
 	}
 
-	if (unhashed)
+	if (unhashed || negative)
 		return dentry;
 
 	return NULL;
@@ -779,7 +959,9 @@ static int autofs4_dir_unlink(struct ino
 
 	spin_lock(&dcache_lock);
 	spin_lock(&sbi->rehash_lock);
-	list_add(&ino->rehash, &sbi->rehash_list);
+	dentry->d_time = 0;
+	if (!autofs4_lookup_dentry(sbi, dentry))
+		list_add(&ino->rehash, &sbi->rehash_list);
 	spin_unlock(&sbi->rehash_lock);
 	spin_lock(&dentry->d_lock);
 	__d_drop(dentry);
@@ -807,7 +989,9 @@ static int autofs4_dir_rmdir(struct inod
 		return -ENOTEMPTY;
 	}
 	spin_lock(&sbi->rehash_lock);
-	list_add(&ino->rehash, &sbi->rehash_list);
+	dentry->d_time = 0;
+	if (!autofs4_lookup_dentry(sbi, dentry))
+		list_add(&ino->rehash, &sbi->rehash_list);
 	spin_unlock(&sbi->rehash_lock);
 	spin_lock(&dentry->d_lock);
 	__d_drop(dentry);
_

Patches currently in -mm which might be from raven@themaw.net are

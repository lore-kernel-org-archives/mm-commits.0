From: akpm@linux-foundation.org
Subject: - security-prevent-permission-checking-of-file-removal-via-sysfs_remove_group.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:51:10 -0700
Message-ID: <200704281051.l3SApA7k019971@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965662AbXD1Kvt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:51:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmorris@namei.org, eparis@redhat.com, greg@kroah.com, hch@lst.de, htejun@gmail.com, nagendra_tomar@adaptec.com, sds@tycho.nsa.gov, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     security: prevent permission checking of file removal via sysfs_remove_group()
has been removed from the -mm tree.  Its filename was
     security-prevent-permission-checking-of-file-removal-via-sysfs_remove_group.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: security: prevent permission checking of file removal via sysfs_remove_group()
From: James Morris <jmorris@namei.org>

Prevent permission checking from being performed when the kernel wants to
unconditionally remove a sysfs group, by introducing an kernel-only variant
of lookup_one_len(), lookup_one_len_kern().

Additionally, as sysfs_remove_group() does not check the return value of
the lookup before using it, a BUG_ON has been added to pinpoint the cause
of any problems potentially caused by this (and as a form of annotation).

Signed-off-by: James Morris <jmorris@namei.org>
Cc: Nagendra Singh Tomar <nagendra_tomar@adaptec.com>
Cc: Greg KH <greg@kroah.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c            |   72 ++++++++++++++++++++++++++++------------
 fs/sysfs/group.c      |    6 ++-
 include/linux/namei.h |    1 
 3 files changed, 57 insertions(+), 22 deletions(-)

diff -puN fs/namei.c~security-prevent-permission-checking-of-file-removal-via-sysfs_remove_group fs/namei.c
--- a/fs/namei.c~security-prevent-permission-checking-of-file-removal-via-sysfs_remove_group
+++ a/fs/namei.c
@@ -1243,22 +1243,13 @@ int __user_path_lookup_open(const char _
 	return err;
 }
 
-/*
- * Restricted form of lookup. Doesn't follow links, single-component only,
- * needs parent already locked. Doesn't follow mounts.
- * SMP-safe.
- */
-static struct dentry * __lookup_hash(struct qstr *name, struct dentry * base, struct nameidata *nd)
+static inline struct dentry *__lookup_hash_kern(struct qstr *name, struct dentry *base, struct nameidata *nd)
 {
-	struct dentry * dentry;
+	struct dentry *dentry;
 	struct inode *inode;
 	int err;
 
 	inode = base->d_inode;
-	err = permission(inode, MAY_EXEC, nd);
-	dentry = ERR_PTR(err);
-	if (err)
-		goto out;
 
 	/*
 	 * See if the low-level filesystem might want
@@ -1287,35 +1278,76 @@ out:
 	return dentry;
 }
 
+/*
+ * Restricted form of lookup. Doesn't follow links, single-component only,
+ * needs parent already locked. Doesn't follow mounts.
+ * SMP-safe.
+ */
+static inline struct dentry * __lookup_hash(struct qstr *name, struct dentry *base, struct nameidata *nd)
+{
+	struct dentry *dentry;
+	struct inode *inode;
+	int err;
+
+	inode = base->d_inode;
+
+	err = permission(inode, MAY_EXEC, nd);
+	dentry = ERR_PTR(err);
+	if (err)
+		goto out;
+
+	dentry = __lookup_hash_kern(name, base, nd);
+out:
+	return dentry;
+}
+
 static struct dentry *lookup_hash(struct nameidata *nd)
 {
 	return __lookup_hash(&nd->last, nd->dentry, nd);
 }
 
 /* SMP-safe */
-struct dentry * lookup_one_len(const char * name, struct dentry * base, int len)
+static inline int __lookup_one_len(const char *name, struct qstr *this, struct dentry *base, int len)
 {
 	unsigned long hash;
-	struct qstr this;
 	unsigned int c;
 
-	this.name = name;
-	this.len = len;
+	this->name = name;
+	this->len = len;
 	if (!len)
-		goto access;
+		return -EACCES;
 
 	hash = init_name_hash();
 	while (len--) {
 		c = *(const unsigned char *)name++;
 		if (c == '/' || c == '\0')
-			goto access;
+			return -EACCES;
 		hash = partial_name_hash(c, hash);
 	}
-	this.hash = end_name_hash(hash);
+	this->hash = end_name_hash(hash);
+	return 0;
+}
 
+struct dentry *lookup_one_len(const char *name, struct dentry *base, int len)
+{
+	int err;
+	struct qstr this;
+
+	err = __lookup_one_len(name, &this, base, len);
+	if (err)
+		return ERR_PTR(err);
 	return __lookup_hash(&this, base, NULL);
-access:
-	return ERR_PTR(-EACCES);
+}
+
+struct dentry *lookup_one_len_kern(const char *name, struct dentry *base, int len)
+{
+	int err;
+	struct qstr this;
+
+	err = __lookup_one_len(name, &this, base, len);
+	if (err)
+		return ERR_PTR(err);
+	return __lookup_hash_kern(&this, base, NULL);
 }
 
 /*
diff -puN fs/sysfs/group.c~security-prevent-permission-checking-of-file-removal-via-sysfs_remove_group fs/sysfs/group.c
--- a/fs/sysfs/group.c~security-prevent-permission-checking-of-file-removal-via-sysfs_remove_group
+++ a/fs/sysfs/group.c
@@ -70,9 +70,11 @@ void sysfs_remove_group(struct kobject *
 {
 	struct dentry * dir;
 
-	if (grp->name)
-		dir = lookup_one_len(grp->name, kobj->dentry,
+	if (grp->name) {
+		dir = lookup_one_len_kern(grp->name, kobj->dentry,
 				strlen(grp->name));
+		BUG_ON(IS_ERR(dir));
+	}
 	else
 		dir = dget(kobj->dentry);
 
diff -puN include/linux/namei.h~security-prevent-permission-checking-of-file-removal-via-sysfs_remove_group include/linux/namei.h
--- a/include/linux/namei.h~security-prevent-permission-checking-of-file-removal-via-sysfs_remove_group
+++ a/include/linux/namei.h
@@ -82,6 +82,7 @@ extern struct file *nameidata_to_filp(st
 extern void release_open_intent(struct nameidata *);
 
 extern struct dentry * lookup_one_len(const char *, struct dentry *, int);
+extern struct dentry *lookup_one_len_kern(const char *, struct dentry *, int);
 
 extern int follow_down(struct vfsmount **, struct dentry **);
 extern int follow_up(struct vfsmount **, struct dentry **);
_

Patches currently in -mm which might be from jmorris@namei.org are

origin.patch
git-selinux.patch
implement-file-posix-capabilities.patch
file-capabilities-accomodate-future-64-bit-caps.patch
return-eperm-not-echild-on-security_task_wait-failure.patch
return-eperm-not-echild-on-security_task_wait-failure-fix.patch
allow-access-to-proc-pid-fd-after-setuid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
remove-redundant-check-from-proc_setattr.patch
remove-redundant-check-from-proc_sys_setattr.patch
lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
slim-secfs-patch.patch
slim-make-and-config-stuff.patch
slim-debug-output.patch
slim-documentation.patch

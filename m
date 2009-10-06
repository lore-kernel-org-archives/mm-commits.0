From: akpm@linux-foundation.org
Subject: + autofs4-use-helper-functions-for-active-list-handling.patch added to -mm tree
Date: Tue, 06 Oct 2009 13:50:23 -0700
Message-ID: <200910062050.n96KoNES009422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933334AbZJFUv2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 16:51:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, adilger@sun.com, hch@infradead.org, sage@newdream.net, viro@ZenIV.linux.org.uk, yehuda@newdream.net


The patch titled
     autofs4: use helper functions for active list handling
has been added to the -mm tree.  Its filename is
     autofs4-use-helper-functions-for-active-list-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: use helper functions for active list handling
From: Ian Kent <raven@themaw.net>

Define some simple helper functions for adding and deleting entries on the
active (and unhashed) dentry list.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Sage Weil <sage@newdream.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Yehuda Saheh <yehuda@newdream.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h |    2 +
 fs/autofs4/inode.c    |    1 
 fs/autofs4/root.c     |   46 ++++++++++++++++++++++++++++++----------
 3 files changed, 38 insertions(+), 11 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-use-helper-functions-for-active-list-handling fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-use-helper-functions-for-active-list-handling
+++ a/fs/autofs4/autofs_i.h
@@ -75,6 +75,8 @@ struct autofs_info {
 	struct completion expire_complete;
 
 	struct list_head active;
+	int active_count;
+
 	struct list_head expiring;
 
 	struct autofs_sb_info *sbi;
diff -puN fs/autofs4/inode.c~autofs4-use-helper-functions-for-active-list-handling fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs4-use-helper-functions-for-active-list-handling
+++ a/fs/autofs4/inode.c
@@ -49,6 +49,7 @@ struct autofs_info *autofs4_init_ino(str
 		ino->dentry = NULL;
 		ino->size = 0;
 		INIT_LIST_HEAD(&ino->active);
+		ino->active_count = 0;
 		INIT_LIST_HEAD(&ino->expiring);
 		atomic_set(&ino->count, 0);
 	}
diff -puN fs/autofs4/root.c~autofs4-use-helper-functions-for-active-list-handling fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-use-helper-functions-for-active-list-handling
+++ a/fs/autofs4/root.c
@@ -72,6 +72,38 @@ const struct inode_operations autofs4_di
 	.rmdir		= autofs4_dir_rmdir,
 };
 
+static void autofs4_add_active(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	if (ino) {
+		spin_lock(&sbi->lookup_lock);
+		if (!ino->active_count) {
+			if (list_empty(&ino->active))
+				list_add(&ino->active, &sbi->active_list);
+		}
+		ino->active_count++;
+		spin_unlock(&sbi->lookup_lock);
+	}
+	return;
+}
+
+static void autofs4_del_active(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	if (ino) {
+		spin_lock(&sbi->lookup_lock);
+		ino->active_count--;
+		if (!ino->active_count) {
+			if (!list_empty(&ino->active))
+				list_del_init(&ino->active);
+		}
+		spin_unlock(&sbi->lookup_lock);
+	}
+	return;
+}
+
 static int autofs4_dir_open(struct inode *inode, struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
@@ -513,9 +545,7 @@ static struct dentry *autofs4_lookup(str
 		dentry->d_fsdata = ino;
 		ino->dentry = dentry;
 
-		spin_lock(&sbi->lookup_lock);
-		list_add(&ino->active, &sbi->active_list);
-		spin_unlock(&sbi->lookup_lock);
+		autofs4_add_active(dentry);
 
 		d_instantiate(dentry, NULL);
 	}
@@ -624,10 +654,7 @@ static int autofs4_dir_symlink(struct in
 	if (!ino)
 		return -ENOMEM;
 
-	spin_lock(&sbi->lookup_lock);
-	if (!list_empty(&ino->active))
-		list_del_init(&ino->active);
-	spin_unlock(&sbi->lookup_lock);
+	autofs4_del_active(dentry);
 
 	ino->size = strlen(symname);
 	cp = kmalloc(ino->size + 1, GFP_KERNEL);
@@ -775,10 +802,7 @@ static int autofs4_dir_mkdir(struct inod
 	if (!ino)
 		return -ENOMEM;
 
-	spin_lock(&sbi->lookup_lock);
-	if (!list_empty(&ino->active))
-		list_del_init(&ino->active);
-	spin_unlock(&sbi->lookup_lock);
+	autofs4_del_active(dentry);
 
 	inode = autofs4_get_inode(dir->i_sb, ino);
 	if (!inode) {
_

Patches currently in -mm which might be from raven@themaw.net are

vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held.patch
vfs-clean-up-real_lookup.patch
autofs4-use-helper-functions-for-active-list-handling.patch
autofs4-use-helper-functions-for-expiring-list.patch
autofs4-use-helper-function-for-need-mount-check.patch
autofs4-use-autofs_info-for-pending-flag.patch
autofs4-renamer-unhashed-to-active-in-autofs4_lookup.patch
autofs4-cleanup-active-and-expire-lookup.patch
autofs4-eliminate-d_unhashed-in-path-walk-checks.patch
autofs4-rename-dentry-to-active-in-autofs4_lookup_active.patch
autofs4-rename-dentry-to-expiring-in-autofs4_lookup_expiring.patch
autofs4-always-use-lookup-for-lookup.patch


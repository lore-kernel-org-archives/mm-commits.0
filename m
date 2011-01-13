From: akpm@linux-foundation.org
Subject: [merged] proc-low_ino-cleanup.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:08:35 -0800
Message-ID: <201101132011.p0DKBG5h030159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933690Ab1AMULq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:11:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: ->low_ino cleanup
has been removed from the -mm tree.  Its filename was
     proc-low_ino-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: ->low_ino cleanup
From: Alexey Dobriyan <adobriyan@gmail.com>

- ->low_ino is write-once field -- reading it under locks is unnecessary.

- /proc/$PID stuff never reaches pde_put()/free_proc_entry() --
   PROC_DYNAMIC_FIRST check never triggers.

- in proc_get_inode(), inode number always matches proc dir entry, so
  save one parameter.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c  |   12 ++----------
 fs/proc/inode.c    |    7 +++----
 fs/proc/internal.h |    2 +-
 3 files changed, 6 insertions(+), 15 deletions(-)

diff -puN fs/proc/generic.c~proc-low_ino-cleanup fs/proc/generic.c
--- a/fs/proc/generic.c~proc-low_ino-cleanup
+++ a/fs/proc/generic.c
@@ -425,13 +425,10 @@ struct dentry *proc_lookup_de(struct pro
 		if (de->namelen != dentry->d_name.len)
 			continue;
 		if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
-			unsigned int ino;
-
-			ino = de->low_ino;
 			pde_get(de);
 			spin_unlock(&proc_subdir_lock);
 			error = -EINVAL;
-			inode = proc_get_inode(dir->i_sb, ino, de);
+			inode = proc_get_inode(dir->i_sb, de);
 			goto out_unlock;
 		}
 	}
@@ -768,12 +765,7 @@ EXPORT_SYMBOL(proc_create_data);
 
 static void free_proc_entry(struct proc_dir_entry *de)
 {
-	unsigned int ino = de->low_ino;
-
-	if (ino < PROC_DYNAMIC_FIRST)
-		return;
-
-	release_inode_number(ino);
+	release_inode_number(de->low_ino);
 
 	if (S_ISLNK(de->mode))
 		kfree(de->data);
diff -puN fs/proc/inode.c~proc-low_ino-cleanup fs/proc/inode.c
--- a/fs/proc/inode.c~proc-low_ino-cleanup
+++ a/fs/proc/inode.c
@@ -416,12 +416,11 @@ static const struct file_operations proc
 };
 #endif
 
-struct inode *proc_get_inode(struct super_block *sb, unsigned int ino,
-				struct proc_dir_entry *de)
+struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 {
 	struct inode * inode;
 
-	inode = iget_locked(sb, ino);
+	inode = iget_locked(sb, de->low_ino);
 	if (!inode)
 		return NULL;
 	if (inode->i_state & I_NEW) {
@@ -471,7 +470,7 @@ int proc_fill_super(struct super_block *
 	s->s_time_gran = 1;
 	
 	pde_get(&proc_root);
-	root_inode = proc_get_inode(s, PROC_ROOT_INO, &proc_root);
+	root_inode = proc_get_inode(s, &proc_root);
 	if (!root_inode)
 		goto out_no_root;
 	root_inode->i_uid = 0;
diff -puN fs/proc/internal.h~proc-low_ino-cleanup fs/proc/internal.h
--- a/fs/proc/internal.h~proc-low_ino-cleanup
+++ a/fs/proc/internal.h
@@ -109,7 +109,7 @@ void pde_put(struct proc_dir_entry *pde)
 
 extern struct vfsmount *proc_mnt;
 int proc_fill_super(struct super_block *);
-struct inode *proc_get_inode(struct super_block *, unsigned int, struct proc_dir_entry *);
+struct inode *proc_get_inode(struct super_block *, struct proc_dir_entry *);
 
 /*
  * These are generic /proc routines that use the internal
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch


From: akpm@linux-foundation.org
Subject: + proc-low_ino-cleanup.patch added to -mm tree
Date: Tue, 07 Dec 2010 14:26:30 -0800
Message-ID: <201012072226.oB7MQUkp011759@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754065Ab0LGW1D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2010 17:27:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     proc: ->low_ino cleanup
has been added to the -mm tree.  Its filename is
     proc-low_ino-cleanup.patch

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
@@ -409,12 +409,11 @@ static const struct file_operations proc
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
@@ -464,7 +463,7 @@ int proc_fill_super(struct super_block *
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

linux-next.patch
proc-use-unsigned-long-inside-proc-statm.patch
proc-use-seq_puts-seq_putc-where-possible.patch
proc-low_ino-cleanup.patch


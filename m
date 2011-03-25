From: akpm@linux-foundation.org
Subject: [merged] procfs-kill-the-global-proc_mnt-variable.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:26:40 -0700
Message-ID: <201103250726.p2P7QYlg026156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933986Ab1CYH0t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:26:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, adobriyan@gmail.com, daniel.lezcano@free.fr, ebiederm@xmission.com, serge@hallyn.com, mm-commits@vger.kernel.org


The patch titled
     procfs: kill the global proc_mnt variable
has been removed from the -mm tree.  Its filename was
     procfs-kill-the-global-proc_mnt-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: procfs: kill the global proc_mnt variable
From: Oleg Nesterov <oleg@redhat.com>

After the previous cleanup in proc_get_sb() the global proc_mnt has no
reasons to exists, kill it.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Serge E. Hallyn <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c    |    2 --
 fs/proc/internal.h |    1 -
 fs/proc/root.c     |    7 ++++---
 3 files changed, 4 insertions(+), 6 deletions(-)

diff -puN fs/proc/inode.c~procfs-kill-the-global-proc_mnt-variable fs/proc/inode.c
--- a/fs/proc/inode.c~procfs-kill-the-global-proc_mnt-variable
+++ a/fs/proc/inode.c
@@ -46,8 +46,6 @@ static void proc_evict_inode(struct inod
 	}
 }
 
-struct vfsmount *proc_mnt;
-
 static struct kmem_cache * proc_inode_cachep;
 
 static struct inode *proc_alloc_inode(struct super_block *sb)
diff -puN fs/proc/internal.h~procfs-kill-the-global-proc_mnt-variable fs/proc/internal.h
--- a/fs/proc/internal.h~procfs-kill-the-global-proc_mnt-variable
+++ a/fs/proc/internal.h
@@ -107,7 +107,6 @@ static inline struct proc_dir_entry *pde
 }
 void pde_put(struct proc_dir_entry *pde);
 
-extern struct vfsmount *proc_mnt;
 int proc_fill_super(struct super_block *);
 struct inode *proc_get_inode(struct super_block *, struct proc_dir_entry *);
 
diff -puN fs/proc/root.c~procfs-kill-the-global-proc_mnt-variable fs/proc/root.c
--- a/fs/proc/root.c~procfs-kill-the-global-proc_mnt-variable
+++ a/fs/proc/root.c
@@ -90,19 +90,20 @@ static struct file_system_type proc_fs_t
 
 void __init proc_root_init(void)
 {
+	struct vfsmount *mnt;
 	int err;
 
 	proc_init_inodecache();
 	err = register_filesystem(&proc_fs_type);
 	if (err)
 		return;
-	proc_mnt = kern_mount_data(&proc_fs_type, &init_pid_ns);
-	if (IS_ERR(proc_mnt)) {
+	mnt = kern_mount_data(&proc_fs_type, &init_pid_ns);
+	if (IS_ERR(mnt)) {
 		unregister_filesystem(&proc_fs_type);
 		return;
 	}
 
-	init_pid_ns.proc_mnt = proc_mnt;
+	init_pid_ns.proc_mnt = mnt;
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	proc_net_init();
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch


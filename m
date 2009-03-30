From: akpm@linux-foundation.org
Subject: [merged] vfs-simple_set_mnt-should-return-void.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:06:34 -0700
Message-ID: <200903301906.n2UJ6YrY019106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758147AbZC3ThF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:37:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@linux.vnet.ibm.com, hch@lst.de, serue@us.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: simple_set_mnt() should return void
has been removed from the -mm tree.  Its filename was
     vfs-simple_set_mnt-should-return-void.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: simple_set_mnt() should return void
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

simple_set_mnt() is defined as returning 'int' but always returns 0. 
Callers assume simple_set_mnt() never fails and don't properly cleanup if
it were to _ever_ fail.  For instance, get_sb_single() and get_sb_nodev()
should:

        up_write(sb->s_unmount);
        deactivate_super(sb);

if simple_set_mnt() fails.

Since simple_set_mnt() never fails, would be cleaner if it did not
return anything.

[akpm@linux-foundation.org: fix build]
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdsuper.c |    7 +++++--
 fs/9p/vfs_super.c      |    5 +++--
 fs/cifs/cifsfs.c       |    3 ++-
 fs/devpts/inode.c      |    3 ++-
 fs/libfs.c             |    3 ++-
 fs/namespace.c         |    3 +--
 fs/proc/proc_net.c     |    3 ++-
 fs/proc/root.c         |    3 ++-
 fs/super.c             |    9 ++++++---
 fs/ubifs/super.c       |    3 ++-
 include/linux/fs.h     |    2 +-
 kernel/cgroup.c        |    3 ++-
 12 files changed, 30 insertions(+), 17 deletions(-)

diff -puN drivers/mtd/mtdsuper.c~vfs-simple_set_mnt-should-return-void drivers/mtd/mtdsuper.c
--- a/drivers/mtd/mtdsuper.c~vfs-simple_set_mnt-should-return-void
+++ a/drivers/mtd/mtdsuper.c
@@ -81,13 +81,16 @@ static int get_sb_mtd_aux(struct file_sy
 
 	/* go */
 	sb->s_flags |= MS_ACTIVE;
-	return simple_set_mnt(mnt, sb);
+	simple_set_mnt(mnt, sb);
+
+	return 0;
 
 	/* new mountpoint for an already mounted superblock */
 already_mounted:
 	DEBUG(1, "MTDSB: Device %d (\"%s\") is already mounted\n",
 	      mtd->index, mtd->name);
-	ret = simple_set_mnt(mnt, sb);
+	simple_set_mnt(mnt, sb);
+	ret = 0;
 	goto out_put;
 
 out_error:
diff -puN fs/9p/vfs_super.c~vfs-simple_set_mnt-should-return-void fs/9p/vfs_super.c
--- a/fs/9p/vfs_super.c~vfs-simple_set_mnt-should-return-void
+++ a/fs/9p/vfs_super.c
@@ -168,8 +168,9 @@ static int v9fs_get_sb(struct file_syste
 	p9stat_free(st);
 	kfree(st);
 
-P9_DPRINTK(P9_DEBUG_VFS, " return simple set mount\n");
-	return simple_set_mnt(mnt, sb);
+P9_DPRINTK(P9_DEBUG_VFS, " simple set mount, return 0\n");
+	simple_set_mnt(mnt, sb);
+	return 0;
 
 release_sb:
 	if (sb) {
diff -puN fs/cifs/cifsfs.c~vfs-simple_set_mnt-should-return-void fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~vfs-simple_set_mnt-should-return-void
+++ a/fs/cifs/cifsfs.c
@@ -606,7 +606,8 @@ cifs_get_sb(struct file_system_type *fs_
 		return rc;
 	}
 	sb->s_flags |= MS_ACTIVE;
-	return simple_set_mnt(mnt, sb);
+	simple_set_mnt(mnt, sb);
+	return 0;
 }
 
 static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
diff -puN fs/devpts/inode.c~vfs-simple_set_mnt-should-return-void fs/devpts/inode.c
--- a/fs/devpts/inode.c~vfs-simple_set_mnt-should-return-void
+++ a/fs/devpts/inode.c
@@ -459,7 +459,8 @@ static int get_init_pts_sb(struct file_s
 		s->s_flags |= MS_ACTIVE;
 	}
 	do_remount_sb(s, flags, data, 0);
-	return simple_set_mnt(mnt, s);
+	simple_set_mnt(mnt, s);
+	return 0;
 }
 
 /*
diff -puN fs/libfs.c~vfs-simple_set_mnt-should-return-void fs/libfs.c
--- a/fs/libfs.c~vfs-simple_set_mnt-should-return-void
+++ a/fs/libfs.c
@@ -242,7 +242,8 @@ int get_sb_pseudo(struct file_system_typ
 	d_instantiate(dentry, root);
 	s->s_root = dentry;
 	s->s_flags |= MS_ACTIVE;
-	return simple_set_mnt(mnt, s);
+	simple_set_mnt(mnt, s);
+	return 0;
 
 Enomem:
 	up_write(&s->s_umount);
diff -puN fs/namespace.c~vfs-simple_set_mnt-should-return-void fs/namespace.c
--- a/fs/namespace.c~vfs-simple_set_mnt-should-return-void
+++ a/fs/namespace.c
@@ -397,11 +397,10 @@ static void __mnt_unmake_readonly(struct
 	spin_unlock(&vfsmount_lock);
 }
 
-int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
+void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
 {
 	mnt->mnt_sb = sb;
 	mnt->mnt_root = dget(sb->s_root);
-	return 0;
 }
 
 EXPORT_SYMBOL(simple_set_mnt);
diff -puN fs/proc/proc_net.c~vfs-simple_set_mnt-should-return-void fs/proc/proc_net.c
--- a/fs/proc/proc_net.c~vfs-simple_set_mnt-should-return-void
+++ a/fs/proc/proc_net.c
@@ -293,7 +293,8 @@ static int proc_net_get_sb(struct file_s
 		sb->s_flags |= MS_ACTIVE;
 	}
 
-	return simple_set_mnt(mnt, sb);
+	simple_set_mnt(mnt, sb);
+	return 0;
 }
 
 static struct file_system_type proc_net_fs_type = {
diff -puN fs/proc/root.c~vfs-simple_set_mnt-should-return-void fs/proc/root.c
--- a/fs/proc/root.c~vfs-simple_set_mnt-should-return-void
+++ a/fs/proc/root.c
@@ -83,7 +83,8 @@ static int proc_get_sb(struct file_syste
 		ns->proc_mnt = mnt;
 	}
 
-	return simple_set_mnt(mnt, sb);
+	simple_set_mnt(mnt, sb);
+	return 0;
 }
 
 static void proc_kill_sb(struct super_block *sb)
diff -puN fs/super.c~vfs-simple_set_mnt-should-return-void fs/super.c
--- a/fs/super.c~vfs-simple_set_mnt-should-return-void
+++ a/fs/super.c
@@ -829,7 +829,8 @@ int get_sb_bdev(struct file_system_type 
 		bdev->bd_super = s;
 	}
 
-	return simple_set_mnt(mnt, s);
+	simple_set_mnt(mnt, s);
+	return 0;
 
 error_s:
 	error = PTR_ERR(s);
@@ -875,7 +876,8 @@ int get_sb_nodev(struct file_system_type
 		return error;
 	}
 	s->s_flags |= MS_ACTIVE;
-	return simple_set_mnt(mnt, s);
+	simple_set_mnt(mnt, s);
+	return 0;
 }
 
 EXPORT_SYMBOL(get_sb_nodev);
@@ -907,7 +909,8 @@ int get_sb_single(struct file_system_typ
 		s->s_flags |= MS_ACTIVE;
 	}
 	do_remount_sb(s, flags, data, 0);
-	return simple_set_mnt(mnt, s);
+	simple_set_mnt(mnt, s);
+	return 0;
 }
 
 EXPORT_SYMBOL(get_sb_single);
diff -puN fs/ubifs/super.c~vfs-simple_set_mnt-should-return-void fs/ubifs/super.c
--- a/fs/ubifs/super.c~vfs-simple_set_mnt-should-return-void
+++ a/fs/ubifs/super.c
@@ -2034,7 +2034,8 @@ static int ubifs_get_sb(struct file_syst
 	/* 'fill_super()' opens ubi again so we must close it here */
 	ubi_close_volume(ubi);
 
-	return simple_set_mnt(mnt, sb);
+	simple_set_mnt(mnt, sb);
+	return 0;
 
 out_deact:
 	up_write(&sb->s_umount);
diff -puN include/linux/fs.h~vfs-simple_set_mnt-should-return-void include/linux/fs.h
--- a/include/linux/fs.h~vfs-simple_set_mnt-should-return-void
+++ a/include/linux/fs.h
@@ -1724,7 +1724,7 @@ struct super_block *sget(struct file_sys
 extern int get_sb_pseudo(struct file_system_type *, char *,
 	const struct super_operations *ops, unsigned long,
 	struct vfsmount *mnt);
-extern int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
+extern void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
 int __put_super_and_need_restart(struct super_block *sb);
 
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
diff -puN kernel/cgroup.c~vfs-simple_set_mnt-should-return-void kernel/cgroup.c
--- a/kernel/cgroup.c~vfs-simple_set_mnt-should-return-void
+++ a/kernel/cgroup.c
@@ -1071,7 +1071,8 @@ static int cgroup_get_sb(struct file_sys
 		mutex_unlock(&cgroup_mutex);
 	}
 
-	return simple_set_mnt(mnt, sb);
+	simple_set_mnt(mnt, sb);
+	return 0;
 
  free_cg_links:
 	free_cg_links(&tmp_cg_links);
_

Patches currently in -mm which might be from sukadev@linux.vnet.ibm.com are

origin.patch
linux-next.patch
signals-remove-handler-parameter-to-tracehook-functions.patch
signals-protect-init-from-unwanted-signals-more.patch
signals-add-from_ancestor_ns-parameter-to-send_signal.patch
signals-protect-cinit-from-unblocked-sig_dfl-signals.patch
signals-zap_pid_ns_process-should-use-force_sig.patch
signals-protect-cinit-from-blocked-fatal-signals.patch
signals-si_user-masquerade-si_pid-when-crossing-pid-ns-boundary.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch


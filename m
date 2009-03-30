From: akpm@linux-foundation.org
Subject: [merged] devpts-merge-code-for-single-and-multiple-instance-mounts.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:07:31 -0700
Message-ID: <200903301907.n2UJ7Vrt019376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759460AbZC3TMA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:12:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk, hch@lst.de, hpa@zytor.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     devpts: merge code for single and multiple-instance mounts
has been removed from the -mm tree.  Its filename was
     devpts-merge-code-for-single-and-multiple-instance-mounts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devpts: merge code for single and multiple-instance mounts
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

new_pts_mount() (including the get_sb_nodev()), shares a lot of code with
init_pts_mount().  The only difference between them is the 'test-super'
function passed into sget().

Move all common code into devpts_get_sb() and remove the new_pts_mount() and
init_pts_mount() functions,

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Tested-by: Serge Hallyn <serue@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |  113 +++++++++++++++-----------------------------
 1 file changed, 40 insertions(+), 73 deletions(-)

diff -puN fs/devpts/inode.c~devpts-merge-code-for-single-and-multiple-instance-mounts fs/devpts/inode.c
--- a/fs/devpts/inode.c~devpts-merge-code-for-single-and-multiple-instance-mounts
+++ a/fs/devpts/inode.c
@@ -322,85 +322,38 @@ static int compare_init_pts_sb(struct su
 }
 
 /*
- * Mount a new (private) instance of devpts.  PTYs created in this
- * instance are independent of the PTYs in other devpts instances.
- */
-static int new_pts_mount(struct file_system_type *fs_type, int flags,
-		void *data, struct pts_mount_opts *opts, struct vfsmount *mnt)
-{
-	int err;
-	struct pts_fs_info *fsi;
-
-	err = get_sb_nodev(fs_type, flags, data, devpts_fill_super, mnt);
-	if (err)
-		return err;
-
-	fsi = DEVPTS_SB(mnt->mnt_sb);
-	memcpy(&fsi->mount_opts, opts, sizeof(opts));
-
-	return 0;
-}
-
-/*
- * init_pts_mount()
+ * devpts_get_sb()
  *
- *     Mount or remount the initial kernel mount of devpts. This type of
- *     mount maintains the legacy, single-instance semantics, while the
- *     kernel still allows multiple-instances.
+ *     If the '-o newinstance' mount option was specified, mount a new
+ *     (private) instance of devpts.  PTYs created in this instance are
+ *     independent of the PTYs in other devpts instances.
  *
- *     This interface is needed to support multiple namespace semantics in
- *     devpts while preserving backward compatibility of the current 'single-
- *     namespace' semantics. i.e all mounts of devpts without the 'newinstance'
- *     mount option should bind to the initial kernel mount, like
- *     get_sb_single().
+ *     If the '-o newinstance' option was not specified, mount/remount the
+ *     initial kernel mount of devpts.  This type of mount gives the
+ *     legacy, single-instance semantics.
  *
- *     Mounts with 'newinstance' option create a new private namespace.
+ *     The 'newinstance' option is needed to support multiple namespace
+ *     semantics in devpts while preserving backward compatibility of the
+ *     current 'single-namespace' semantics. i.e all mounts of devpts
+ *     without the 'newinstance' mount option should bind to the initial
+ *     kernel mount, like get_sb_single().
  *
- *     But for single-mount semantics, devpts cannot use get_sb_single(),
+ *     Mounts with 'newinstance' option create a new, private namespace.
+ *
+ *     NOTE:
+ *
+ *     For single-mount semantics, devpts cannot use get_sb_single(),
  *     because get_sb_single()/sget() find and use the super-block from
  *     the most recent mount of devpts. But that recent mount may be a
  *     'newinstance' mount and get_sb_single() would pick the newinstance
  *     super-block instead of the initial super-block.
- *
- *     This interface is identical to get_sb_single() except that it
- *     consistently selects the 'single-namespace' superblock even in the
- *     presence of the private namespace (i.e 'newinstance') super-blocks.
  */
-static int init_pts_mount(struct file_system_type *fs_type, int flags,
-		void *data, struct pts_mount_opts *opts, struct vfsmount *mnt)
-{
-	struct super_block *s;
-	struct pts_fs_info *fsi;
-	int error;
-
-	s = sget(fs_type, compare_init_pts_sb, set_anon_super, NULL);
-	if (IS_ERR(s))
-		return PTR_ERR(s);
-
-	if (!s->s_root) {
-		s->s_flags = flags;
-		error = devpts_fill_super(s, data, flags & MS_SILENT ? 1 : 0);
-		if (error) {
-			up_write(&s->s_umount);
-			deactivate_super(s);
-			return error;
-		}
-		s->s_flags |= MS_ACTIVE;
-	}
-
-	simple_set_mnt(mnt, s);
-
-	fsi = DEVPTS_SB(mnt->mnt_sb);
-	memcpy(&fsi->mount_opts, opts, sizeof(opts));
-
-	return 0;
-}
-
 static int devpts_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
 {
 	int error;
 	struct pts_mount_opts opts;
+	struct super_block *s;
 
 	memset(&opts, 0, sizeof(opts));
 	if (data) {
@@ -410,23 +363,37 @@ static int devpts_get_sb(struct file_sys
 	}
 
 	if (opts.newinstance)
-		error = new_pts_mount(fs_type, flags, data, &opts, mnt);
+		s = sget(fs_type, NULL, set_anon_super, NULL);
 	else
-		error = init_pts_mount(fs_type, flags, data, &opts, mnt);
+		s = sget(fs_type, compare_init_pts_sb, set_anon_super, NULL);
 
-	if (error)
-		return error;
+	if (IS_ERR(s))
+		return PTR_ERR(s);
 
-	error = mknod_ptmx(mnt->mnt_sb);
+	if (!s->s_root) {
+		s->s_flags = flags;
+		error = devpts_fill_super(s, data, flags & MS_SILENT ? 1 : 0);
+		if (error)
+			goto out_undo_sget;
+		s->s_flags |= MS_ACTIVE;
+	}
+
+	simple_set_mnt(mnt, s);
+
+	memcpy(&(DEVPTS_SB(s))->mount_opts, &opts, sizeof(opts));
+
+	error = mknod_ptmx(s);
 	if (error)
 		goto out_dput;
 
 	return 0;
 
 out_dput:
-	dput(mnt->mnt_sb->s_root);
-	up_write(&mnt->mnt_sb->s_umount);
-	deactivate_super(mnt->mnt_sb);
+	dput(s->s_root);
+
+out_undo_sget:
+	up_write(&s->s_umount);
+	deactivate_super(s);
 	return error;
 }
 
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


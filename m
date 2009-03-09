From: akpm@linux-foundation.org
Subject: + devpts-remove-get_init_pts_sb.patch added to -mm tree
Date: Mon, 09 Mar 2009 13:05:31 -0700
Message-ID: <200903092005.n29K5WH2001099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751922AbZCIUGW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Mar 2009 16:06:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk, hch@lst.de, hpa@zytor.com, serue@us.ibm.com


The patch titled
     devpts: remove get_init_pts_sb()
has been added to the -mm tree.  Its filename is
     devpts-remove-get_init_pts_sb.patch

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
Subject: devpts: remove get_init_pts_sb()
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

With mknod_ptmx() moved to devpts_get_sb(), init_pts_mount() becomes a
wrapper around get_init_pts_sb().  Remove get_init_pts_sb() and fold code
into init_pts_mount().

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |   25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff -puN fs/devpts/inode.c~devpts-remove-get_init_pts_sb fs/devpts/inode.c
--- a/fs/devpts/inode.c~devpts-remove-get_init_pts_sb
+++ a/fs/devpts/inode.c
@@ -342,7 +342,11 @@ static int new_pts_mount(struct file_sys
 }
 
 /*
- * get_init_pts_sb()
+ * init_pts_mount()
+ *
+ *     Mount or remount the initial kernel mount of devpts. This type of
+ *     mount maintains the legacy, single-instance semantics, while the
+ *     kernel still allows multiple-instances.
  *
  *     This interface is needed to support multiple namespace semantics in
  *     devpts while preserving backward compatibility of the current 'single-
@@ -362,7 +366,7 @@ static int new_pts_mount(struct file_sys
  *     consistently selects the 'single-namespace' superblock even in the
  *     presence of the private namespace (i.e 'newinstance') super-blocks.
  */
-static int get_init_pts_sb(struct file_system_type *fs_type, int flags,
+static int init_pts_mount(struct file_system_type *fs_type, int flags,
 		void *data, struct pts_mount_opts *opts, struct vfsmount *mnt)
 {
 	struct super_block *s;
@@ -392,23 +396,6 @@ static int get_init_pts_sb(struct file_s
 	return 0;
 }
 
-/*
- * Mount or remount the initial kernel mount of devpts. This type of
- * mount maintains the legacy, single-instance semantics, while the
- * kernel still allows multiple-instances.
- */
-static int init_pts_mount(struct file_system_type *fs_type, int flags,
-		void *data, struct pts_mount_opts *opts, struct vfsmount *mnt)
-{
-	int err;
-
-	err = get_init_pts_sb(fs_type, flags, data, opts, mnt);
-	if (err)
-		return err;
-
-	return err;
-}
-
 static int devpts_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
 {
_

Patches currently in -mm which might be from sukadev@linux.vnet.ibm.com are

linux-next.patch
vfs-simple_set_mnt-should-return-void.patch
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
devpts-unroll-essentials-of-do_remount_sb-into-devpts.patch
devpts-parse-mount-options-just-once-and-copy-them-to-super-block.patch
devpts-move-common-mknod_ptmx-calls-into-caller.patch
devpts-remove-get_init_pts_sb.patch
devpts-merge-code-for-single-and-multiple-instance-mounts.patch


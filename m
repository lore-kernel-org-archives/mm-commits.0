From: akpm@linux-foundation.org
Subject: [merged] devpts-must-release-s_umount-on-error.patch removed from -mm tree
Date: Fri, 27 Feb 2009 10:39:18 -0800
Message-ID: <200902271839.n1RIdIN2022731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758758AbZB0SkH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Feb 2009 13:40:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk, hch@lst.de, hpa@zytor.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     devpts: must release s_umount on error
has been removed from the -mm tree.  Its filename was
     devpts-must-release-s_umount-on-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devpts: must release s_umount on error
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

We should drop the ->s_umount mutex if an error occurs after the
sget()/grab_super() call. This was introduced when adding support
for multiple instances of devpts and noticed during a code review/reorg.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/devpts/inode.c~devpts-must-release-s_umount-on-error fs/devpts/inode.c
--- a/fs/devpts/inode.c~devpts-must-release-s_umount-on-error
+++ a/fs/devpts/inode.c
@@ -390,6 +390,7 @@ static int new_pts_mount(struct file_sys
 
 fail:
 	dput(mnt->mnt_sb->s_root);
+	up_write(&mnt->mnt_sb->s_umount);
 	deactivate_super(mnt->mnt_sb);
 	return err;
 }
@@ -479,6 +480,7 @@ static int init_pts_mount(struct file_sy
 	err = mknod_ptmx(mnt->mnt_sb);
 	if (err) {
 		dput(mnt->mnt_sb->s_root);
+		up_write(&mnt->mnt_sb->s_umount);
 		deactivate_super(mnt->mnt_sb);
 	}
 
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


From: akpm@linux-foundation.org
Subject: [merged] devpts-move-common-mknod_ptmx-calls-into-caller.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:07:27 -0700
Message-ID: <200903301907.n2UJ7RU9019370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759451AbZC3TLz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:11:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk, hch@lst.de, hpa@zytor.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     devpts: move common mknod_ptmx() calls into caller
has been removed from the -mm tree.  Its filename was
     devpts-move-common-mknod_ptmx-calls-into-caller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devpts: move common mknod_ptmx() calls into caller
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

We create 'ptmx' node in both single-instance and multiple-instance
mounts.  So devpts_get_sb() can call mknod_ptmx() once rather than have
both modes calling mknod_ptmx() separately.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |   36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff -puN fs/devpts/inode.c~devpts-move-common-mknod_ptmx-calls-into-caller fs/devpts/inode.c
--- a/fs/devpts/inode.c~devpts-move-common-mknod_ptmx-calls-into-caller
+++ a/fs/devpts/inode.c
@@ -338,17 +338,7 @@ static int new_pts_mount(struct file_sys
 	fsi = DEVPTS_SB(mnt->mnt_sb);
 	memcpy(&fsi->mount_opts, opts, sizeof(opts));
 
-	err = mknod_ptmx(mnt->mnt_sb);
-	if (err)
-		goto fail;
-
 	return 0;
-
-fail:
-	dput(mnt->mnt_sb->s_root);
-	up_write(&mnt->mnt_sb->s_umount);
-	deactivate_super(mnt->mnt_sb);
-	return err;
 }
 
 /*
@@ -416,13 +406,6 @@ static int init_pts_mount(struct file_sy
 	if (err)
 		return err;
 
-	err = mknod_ptmx(mnt->mnt_sb);
-	if (err) {
-		dput(mnt->mnt_sb->s_root);
-		up_write(&mnt->mnt_sb->s_umount);
-		deactivate_super(mnt->mnt_sb);
-	}
-
 	return err;
 }
 
@@ -440,9 +423,24 @@ static int devpts_get_sb(struct file_sys
 	}
 
 	if (opts.newinstance)
-		return new_pts_mount(fs_type, flags, data, &opts, mnt);
+		error = new_pts_mount(fs_type, flags, data, &opts, mnt);
 	else
-		return init_pts_mount(fs_type, flags, data, &opts, mnt);
+		error = init_pts_mount(fs_type, flags, data, &opts, mnt);
+
+	if (error)
+		return error;
+
+	error = mknod_ptmx(mnt->mnt_sb);
+	if (error)
+		goto out_dput;
+
+	return 0;
+
+out_dput:
+	dput(mnt->mnt_sb->s_root);
+	up_write(&mnt->mnt_sb->s_umount);
+	deactivate_super(mnt->mnt_sb);
+	return error;
 }
 
 #else
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


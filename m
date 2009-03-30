From: akpm@linux-foundation.org
Subject: [merged] devpts-unroll-essentials-of-do_remount_sb-into-devpts.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:07:23 -0700
Message-ID: <200903301907.n2UJ7NB9019364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759451AbZC3TLx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:11:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk, hch@lst.de, hpa@zytor.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     devpts: unroll essentials of do_remount_sb() into devpts
has been removed from the -mm tree.  Its filename was
     devpts-unroll-essentials-of-do_remount_sb-into-devpts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devpts: unroll essentials of do_remount_sb() into devpts
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

On remount, devpts fs only needs to parse the mount options.  Users cannot
directly create/dirty files in /dev/pts so the MS_RDONLY flag and
shrinking the dcache does not really apply to devpts.

So effectively on remount, devpts only parses the mount options and
updates these options in its super block.  As such, we could replace
do_remount_sb() call with a direct parse_mount_options().

Doing so enables subsequent patches to avoid parsing the mount options
twice and simplify the code.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/devpts/inode.c~devpts-unroll-essentials-of-do_remount_sb-into-devpts fs/devpts/inode.c
--- a/fs/devpts/inode.c~devpts-unroll-essentials-of-do_remount_sb-into-devpts
+++ a/fs/devpts/inode.c
@@ -437,6 +437,8 @@ static int get_init_pts_sb(struct file_s
 		void *data, struct vfsmount *mnt)
 {
 	struct super_block *s;
+	struct pts_mount_opts *opts;
+	struct pts_fs_info *fsi;
 	int error;
 
 	s = sget(fs_type, compare_init_pts_sb, set_anon_super, NULL);
@@ -453,7 +455,10 @@ static int get_init_pts_sb(struct file_s
 		}
 		s->s_flags |= MS_ACTIVE;
 	}
-	do_remount_sb(s, flags, data, 0);
+	fsi = DEVPTS_SB(s);
+	opts = &fsi->mount_opts;
+	parse_mount_options(data, PARSE_REMOUNT, opts);
+
 	simple_set_mnt(mnt, s);
 	return 0;
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


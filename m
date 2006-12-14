From: akpm@osdl.org
Subject: - ncpfs-use-struct-pid-to-track-the-userspace-watchdog-process.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:13:30 -0800
Message-ID: <200612140613.kBE6DUm7002125@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52336 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbWLNGNq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:13:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, VANDROVE@vc.cvut.cz, mm-commits@vger.kernel.org


The patch titled
     ncpfs: Use struct pid to track the userspace watchdog process
has been removed from the -mm tree.  Its filename was
     ncpfs-use-struct-pid-to-track-the-userspace-watchdog-process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ncpfs: Use struct pid to track the userspace watchdog process
From: Eric W. Biederman <ebiederm@xmission.com>

This patch converts the tracking of the user space watchdog process from using
a pid_t to use struct pid.  This makes us safe from pid wrap around issues and
prepares the way for the pid namespace.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Petr Vandrovec <VANDROVE@vc.cvut.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ncpfs/inode.c          |   11 ++++++-----
 include/linux/ncp_mount.h |    2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/ncpfs/inode.c~ncpfs-use-struct-pid-to-track-the-userspace-watchdog-process fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~ncpfs-use-struct-pid-to-track-the-userspace-watchdog-process
+++ a/fs/ncpfs/inode.c
@@ -331,7 +331,7 @@ static int ncp_parse_options(struct ncp_
 	data->flags = 0;
 	data->int_flags = 0;
 	data->mounted_uid = 0;
-	data->wdog_pid = -1;
+	data->wdog_pid = NULL;
 	data->ncp_fd = ~0;
 	data->time_out = 10;
 	data->retry_count = 20;
@@ -371,7 +371,7 @@ static int ncp_parse_options(struct ncp_
 				data->flags = optint;
 				break;
 			case 'w':
-				data->wdog_pid = optint;
+				data->wdog_pid = find_get_pid(optint);
 				break;
 			case 'n':
 				data->ncp_fd = optint;
@@ -425,7 +425,7 @@ static int ncp_fill_super(struct super_b
 				data.flags = md->flags;
 				data.int_flags = NCP_IMOUNT_LOGGEDIN_POSSIBLE;
 				data.mounted_uid = md->mounted_uid;
-				data.wdog_pid = md->wdog_pid;
+				data.wdog_pid = find_get_pid(md->wdog_pid);
 				data.ncp_fd = md->ncp_fd;
 				data.time_out = md->time_out;
 				data.retry_count = md->retry_count;
@@ -445,7 +445,7 @@ static int ncp_fill_super(struct super_b
 				data.flags = md->flags;
 				data.int_flags = 0;
 				data.mounted_uid = md->mounted_uid;
-				data.wdog_pid = md->wdog_pid;
+				data.wdog_pid = find_get_pid(md->wdog_pid);
 				data.ncp_fd = md->ncp_fd;
 				data.time_out = md->time_out;
 				data.retry_count = md->retry_count;
@@ -711,7 +711,8 @@ static void ncp_put_super(struct super_b
 	if (server->info_filp)
 		fput(server->info_filp);
 	fput(server->ncp_filp);
-	kill_proc(server->m.wdog_pid, SIGTERM, 1);
+	kill_pid(server->m.wdog_pid, SIGTERM, 1);
+	put_pid(server->m.wdog_pid);
 
 	kfree(server->priv.data);
 	kfree(server->auth.object_name);
diff -puN include/linux/ncp_mount.h~ncpfs-use-struct-pid-to-track-the-userspace-watchdog-process include/linux/ncp_mount.h
--- a/include/linux/ncp_mount.h~ncpfs-use-struct-pid-to-track-the-userspace-watchdog-process
+++ a/include/linux/ncp_mount.h
@@ -75,7 +75,7 @@ struct ncp_mount_data_kernel {
 	unsigned int	 int_flags;	/* internal flags */
 #define NCP_IMOUNT_LOGGEDIN_POSSIBLE	0x0001
 	__kernel_uid32_t mounted_uid;	/* Who may umount() this filesystem? */
-	__kernel_pid_t   wdog_pid;		/* Who cares for our watchdog packets? */
+	struct pid      *wdog_pid;	/* Who cares for our watchdog packets? */
 	unsigned int     ncp_fd;	/* The socket to the ncp port */
 	unsigned int     time_out;	/* How long should I wait after
 					   sending a NCP request? */
_

Patches currently in -mm which might be from ebiederm@xmission.com are

kthread-api-conversion-for-dvb_frontend-and-av7110.patch
usbatm-update-to-use-the-kthread-api.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
vt-refactor-console-sak-processing.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
i386-apic-clean-up-the-apic-code.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
dynticks-i386-prepare-nmi-watchdog.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
pidhash-temporary-debug-checks.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch


From: akpm@osdl.org
Subject: + ncpfs-use-struct-pid-to-track-the-userspace-watchdog-process.patch added to -mm tree
Date: Mon, 11 Dec 2006 13:26:29 -0800
Message-ID: <200612112126.kBBLQTbx008049@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38182 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763119AbWLKV0d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 16:26:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, VANDROVE@vc.cvut.cz


The patch titled
     ncpfs: Use struct pid to track the userspace watchdog process.
has been added to the -mm tree.  Its filename is
     ncpfs-use-struct-pid-to-track-the-userspace-watchdog-process.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ncpfs: Use struct pid to track the userspace watchdog process.
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

origin.patch
revert-identifier-to-nsproxy.patch
vt-fix-comments-to-not-refer-to-kill_proc.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
n_r3964-use-struct-pid-to-track-user-space-clients.patch
smbfs-make-conn_pid-a-struct-pid.patch
ncpfs-use-struct-pid-to-track-the-userspace-watchdog-process.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
updated-i386-cleanup-apic-code.patch
updated-i386-rework-local-apic-calibration.patch
updated-dynticks-fix-nmi-watchdog.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch
pidhash-temporary-debug-checks.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch


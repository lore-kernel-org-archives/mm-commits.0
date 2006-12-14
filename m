From: akpm@osdl.org
Subject: - ncpfs-ensure-we-free-wdog_pid-on-parse_option-or-fill_inode-failure.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:13:41 -0800
Message-ID: <200612140613.kBE6DfZh002129@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52348 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbWLNGNz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:13:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, vandrove@vc.cvut.cz, mm-commits@vger.kernel.org


The patch titled
     ncpfs: ensure we free wdog_pid on parse_option or fill_inode failure
has been removed from the -mm tree.  Its filename was
     ncpfs-ensure-we-free-wdog_pid-on-parse_option-or-fill_inode-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ncpfs: ensure we free wdog_pid on parse_option or fill_inode failure
From: Eric W. Biederman <ebiederm@xmission.com>

This took a little refactoring but now errors are handled cleanly.  When
this code used pid_t values this wasn't necessary because you can't
leak a pid_t.

Thanks to Peter Vandrovec for spotting this.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Peter Vandrovec <vandrove@vc.cvut.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ncpfs/inode.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff -puN fs/ncpfs/inode.c~ncpfs-ensure-we-free-wdog_pid-on-parse_option-or-fill_inode-failure fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~ncpfs-ensure-we-free-wdog_pid-on-parse_option-or-fill_inode-failure
+++ a/fs/ncpfs/inode.c
@@ -327,6 +327,7 @@ static int ncp_parse_options(struct ncp_
 	char *optarg;
 	unsigned long optint;
 	int version = 0;
+	int ret;
 
 	data->flags = 0;
 	data->int_flags = 0;
@@ -343,8 +344,9 @@ static int ncp_parse_options(struct ncp_
 	data->mounted_vol[0] = 0;
 	
 	while ((optval = ncp_getopt("ncpfs", &options, ncp_opts, NULL, &optarg, &optint)) != 0) {
-		if (optval < 0)
-			return optval;
+		ret = optval;
+		if (ret < 0)
+			goto err;
 		switch (optval) {
 			case 'u':
 				data->uid = optint;
@@ -380,18 +382,21 @@ static int ncp_parse_options(struct ncp_
 				data->info_fd = optint;
 				break;
 			case 'v':
-				if (optint < NCP_MOUNT_VERSION_V4) {
-					return -ECHRNG;
-				}
-				if (optint > NCP_MOUNT_VERSION_V5) {
-					return -ECHRNG;
-				}
+				ret = -ECHRNG;
+				if (optint < NCP_MOUNT_VERSION_V4)
+					goto err;
+				if (optint > NCP_MOUNT_VERSION_V5)
+					goto err;
 				version = optint;
 				break;
 			
 		}
 	}
 	return 0;
+err:
+	put_pid(data->wdog_pid);
+	data->wdog_pid = NULL;
+	return ret;
 }
 
 static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
@@ -409,6 +414,7 @@ static int ncp_fill_super(struct super_b
 #endif
 	struct ncp_entry_info finfo;
 
+	data.wdog_pid = NULL;
 	server = kzalloc(sizeof(struct ncp_server), GFP_KERNEL);
 	if (!server)
 		return -ENOMEM;
@@ -679,6 +685,7 @@ out_fput:
 	 */
 	fput(ncp_filp);
 out:
+	put_pid(data.wdog_pid);
 	sb->s_fs_info = NULL;
 	kfree(server);
 	return error;
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


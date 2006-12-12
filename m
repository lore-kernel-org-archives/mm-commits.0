From: akpm@osdl.org
Subject: + ncpfs-ensure-we-free-wdog_pid-on-parse_option-or-fill_inode-failure.patch added to -mm tree
Date: Tue, 12 Dec 2006 12:49:42 -0800
Message-ID: <200612122049.kBCKngSu015360@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40282 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbWLLUtr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 15:49:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, vandrove@vc.cvut.cz


The patch titled
     ncpfs: ensure we free wdog_pid on parse_option or fill_inode failure
has been added to the -mm tree.  Its filename is
     ncpfs-ensure-we-free-wdog_pid-on-parse_option-or-fill_inode-failure.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 15 insertions(+), 8 deletions(-)

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
ncpfs-ensure-we-free-wdog_pid-on-parse_option-or-fill_inode-failure.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
updated-i386-cleanup-apic-code.patch
updated-i386-rework-local-apic-calibration.patch
updated-dynticks-fix-nmi-watchdog.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch
pidhash-temporary-debug-checks.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch


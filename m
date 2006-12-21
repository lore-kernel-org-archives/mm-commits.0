From: akpm@osdl.org
Subject: - fs-dlm-lowcomms-tcpc-remove-2-functions.patch removed from -mm tree
Date: Wed, 20 Dec 2006 16:36:50 -0800
Message-ID: <200612210036.kBL0aoVc011230@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53601 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161125AbWLUAkD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:40:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     fs/dlm/lowcomms-tcp.c: remove 2 functions
has been removed from the -mm tree.  Its filename was
     fs-dlm-lowcomms-tcpc-remove-2-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs/dlm/lowcomms-tcp.c: remove 2 functions
From: Adrian Bunk <bunk@stusta.de>

Remove the following unused functions:

- lowcomms_send_message()
- lowcomms_max_buffer_size()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/dlm/lowcomms-tcp.c |   24 ------------------------
 1 file changed, 24 deletions(-)

diff -puN fs/dlm/lowcomms-tcp.c~fs-dlm-lowcomms-tcpc-remove-2-functions fs/dlm/lowcomms-tcp.c
--- a/fs/dlm/lowcomms-tcp.c~fs-dlm-lowcomms-tcpc-remove-2-functions
+++ a/fs/dlm/lowcomms-tcp.c
@@ -913,22 +913,6 @@ int dlm_lowcomms_close(int nodeid)
 	return -1;
 }
 
-/* API send message call, may queue the request */
-/* N.B. This is the old interface - use the new one for new calls */
-int lowcomms_send_message(int nodeid, char *buf, int len, gfp_t allocation)
-{
-	struct writequeue_entry *e;
-	char *b;
-
-	e = dlm_lowcomms_get_buffer(nodeid, len, allocation, &b);
-	if (e) {
-		memcpy(b, buf, len);
-		dlm_lowcomms_commit_buffer(e);
-		return 0;
-	}
-	return -ENOBUFS;
-}
-
 /* Look for activity on active sockets */
 static void process_sockets(void)
 {
@@ -1129,14 +1113,6 @@ static int daemons_start(void)
 	return 0;
 }
 
-/*
- * Return the largest buffer size we can cope with.
- */
-int lowcomms_max_buffer_size(void)
-{
-	return PAGE_CACHE_SIZE;
-}
-
 void dlm_lowcomms_stop(void)
 {
 	int i;
_

Patches currently in -mm which might be from bunk@stusta.de are

make-kernel-printkcignore_loglevel_setup-static.patch
fs-sysv-proper-prototypes-for-2-functions.patch
git-acpi.patch
git-alsa.patch
usbvision-possible-cleanups.patch
git-gfs2-nmw.patch
git-mtd.patch
remove-the-broken-skmc-driver.patch
git-net.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
arch-i386-kernel-e820c-should-include-asm-setuph.patch
lumpy-reclaim-cleanup.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
remove-include-linux-byteorder-pdp_endianh.patch
toshiba-tc86c001-ide-driver-take-2-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i386-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
fbdev-driver-for-s3-trio-virge-cleanups.patch
remove-broken-video-drivers-v4.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch


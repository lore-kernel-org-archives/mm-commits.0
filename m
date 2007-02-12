From: akpm@linux-foundation.org
Subject: - remove-bogus-con_is_present-prototypes.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:49:33 -0800
Message-ID: <200702122249.l1CMnXCC014134@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45939 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030434AbXBLWwx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:52:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     remove bogus con_is_present() prototypes
has been removed from the -mm tree.  Its filename was
     remove-bogus-con_is_present-prototypes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove bogus con_is_present() prototypes
From: Adrian Bunk <bunk@stusta.de>

Although gcc seems to accept "extern" prototypes after it has seen the
"static inline" function, that's not really correct.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb_base.c |    2 --
 drivers/video/igafb.c          |    1 -
 2 files changed, 3 deletions(-)

diff -puN drivers/video/aty/atyfb_base.c~remove-bogus-con_is_present-prototypes drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~remove-bogus-con_is_present-prototypes
+++ a/drivers/video/aty/atyfb_base.c
@@ -2957,8 +2957,6 @@ extern void (*prom_palette) (int);
 static int __devinit atyfb_setup_sparc(struct pci_dev *pdev,
 			struct fb_info *info, unsigned long addr)
 {
-	extern int con_is_present(void);
-
 	struct atyfb_par *par = info->par;
 	struct pcidev_cookie *pcp;
 	char prop[128];
diff -puN drivers/video/igafb.c~remove-bogus-con_is_present-prototypes drivers/video/igafb.c
--- a/drivers/video/igafb.c~remove-bogus-con_is_present-prototypes
+++ a/drivers/video/igafb.c
@@ -370,7 +370,6 @@ static int __init iga_init(struct fb_inf
 
 int __init igafb_init(void)
 {
-        extern int con_is_present(void);
         struct fb_info *info;
         struct pci_dev *pdev;
         struct iga_par *par;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
ifdef-acpi_future_usage-acpi_os_readable.patch
git-cpufreq.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
mips-remove-smp_tune_scheduling.patch
git-mtd.patch
git-ubi.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
git-unionfs.patch
usb_rtl8150-must-select-mii.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
lumpy-reclaim-cleanup.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i383-drivers.patch
add-debugging-feature-proc-timer_stat-cleanup.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
sysctl-reimplement-the-sysctl-proc-support-fix-3.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

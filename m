From: akpm@osdl.org
Subject: - drivers-acpi-oslc-fix-a-null-check.patch removed from -mm tree
Date: Wed, 20 Dec 2006 16:36:17 -0800
Message-ID: <200612210036.kBL0aHpP011180@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53579 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161124AbWLUAja (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:39:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     drivers/acpi/osl.c: fix a NULL check
has been removed from the -mm tree.  Its filename was
     drivers-acpi-oslc-fix-a-null-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/acpi/osl.c: fix a NULL check
From: Adrian Bunk <bunk@stusta.de>

This patch fixes a non-working NULL check introduced by commit
b229cf92eee616c7cb5ad8cdb35a19b119f00bc8.

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/osl.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/osl.c~drivers-acpi-oslc-fix-a-null-check drivers/acpi/osl.c
--- a/drivers/acpi/osl.c~drivers-acpi-oslc-fix-a-null-check
+++ a/drivers/acpi/osl.c
@@ -1032,7 +1032,7 @@ acpi_status
 acpi_os_create_cache(char *name, u16 size, u16 depth, acpi_cache_t ** cache)
 {
 	*cache = kmem_cache_create(name, size, 0, 0, NULL, NULL);
-	if (cache == NULL)
+	if (*cache == NULL)
 		return AE_ERROR;
 	else
 		return AE_OK;
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


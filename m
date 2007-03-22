From: akpm@linux-foundation.org
Subject: - drivers-usb-input-gtcoc-fix-a-use-before-check.patch removed from -mm tree
Date: Thu, 22 Mar 2007 12:21:29 -0800
Message-ID: <200703222021.l2MKLTPD029464@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50106 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934224AbXCVUYt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 16:24:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, gregkh@suse.de, jroberson@gtcocalcomp.com, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/input/gtco.c: fix a use-before-check
has been removed from the -mm tree.  Its filename was
     drivers-usb-input-gtcoc-fix-a-use-before-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/usb/input/gtco.c: fix a use-before-check
From: Adrian Bunk <bunk@stusta.de>

NULL checks should be before the first dereference.

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: "Jeremy A. Roberson" <jroberson@gtcocalcomp.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/input/gtco.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/usb/input/gtco.c~drivers-usb-input-gtcoc-fix-a-use-before-check drivers/usb/input/gtco.c
--- a/drivers/usb/input/gtco.c~drivers-usb-input-gtcoc-fix-a-use-before-check
+++ a/drivers/usb/input/gtco.c
@@ -1047,13 +1047,10 @@ static void gtco_disconnect(struct usb_i
 
 	/* Grab private device ptr */
 	struct gtco    *device = usb_get_intfdata (interface);
-	struct input_dev *inputdev;
-
-	inputdev = device->inputdevice;
 
 	/* Now reverse all the registration stuff */
 	if (device) {
-		input_unregister_device(inputdev);
+		input_unregister_device(device->inputdevice);
 		usb_kill_urb(device->urbinfo);
 		usb_free_urb(device->urbinfo);
 		usb_buffer_free(device->usbdev, REPORT_MAX_SIZE,
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
drivers-video-s3fbc-fix-a-use-before-check.patch
fix-extra-bios-invocation-during-resume.patch
net-sunrpc-svcsockc-fix-a-check.patch
git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-mmc_deselect_cards.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-net-vioc-possible-cleanups.patch
drivers-net-bonding-bond_maincmake-3-functions-static.patch
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
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
i386-x86_64-early_printkc-make-simnow_init-static.patch
make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch
lguest-kconfig-and-headers.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
drivers-mfd-sm501c-fix-an-off-by-one.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

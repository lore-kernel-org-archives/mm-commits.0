From: akpm@linux-foundation.org
Subject: + git-alsa-fixup.patch added to -mm tree
Date: Fri, 11 May 2007 22:26:55 -0700
Message-ID: <200705120526.l4C5QsmK001945@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760AbXELF06 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:26:58 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l4C5QtfH024351
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 11 May 2007 22:26:56 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     git-alsa-fixup
has been added to the -mm tree.  Its filename is
     git-alsa-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-alsa-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/hda/hda_codec.c |    8 --------
 sound/usb/usbquirks.h     |   26 --------------------------
 2 files changed, 34 deletions(-)

diff -puN sound/pci/hda/hda_codec.c~git-alsa-fixup sound/pci/hda/hda_codec.c
--- a/sound/pci/hda/hda_codec.c~git-alsa-fixup
+++ a/sound/pci/hda/hda_codec.c
@@ -703,20 +703,12 @@ static u32 query_amp_caps(struct hda_cod
 	if (!(info->status & INFO_AMP_CAPS)) {
 		if (!(get_wcaps(codec, nid) & AC_WCAP_AMP_OVRD))
 			nid = codec->afg;
-<<<<<<< HEAD/sound/pci/hda/hda_codec.c
-		info->amp_caps = snd_hda_param_read(codec, nid,
-						    direction == HDA_OUTPUT ?
-						    AC_PAR_AMP_OUT_CAP :
-						    AC_PAR_AMP_IN_CAP);
-		info->status |= INFO_AMP_CAPS;
-=======
 		info->amp_caps = snd_hda_param_read(codec, nid,
 						    direction == HDA_OUTPUT ?
 						    AC_PAR_AMP_OUT_CAP :
 						    AC_PAR_AMP_IN_CAP);
 		if (info->amp_caps)
 			info->status |= INFO_AMP_CAPS;
->>>>>>> /sound/pci/hda/hda_codec.c
 	}
 	return info->amp_caps;
 }
diff -puN sound/usb/usbquirks.h~git-alsa-fixup sound/usb/usbquirks.h
--- a/sound/usb/usbquirks.h~git-alsa-fixup
+++ a/sound/usb/usbquirks.h
@@ -40,31 +40,6 @@
 	.bInterfaceClass = USB_CLASS_VENDOR_SPEC
 
 /*
-<<<<<<< HEAD/sound/usb/usbquirks.h
- * Logitech QuickCam: bDeviceClass is vendor-specific, so generic interface
- * class matches do not take effect without an explicit ID match.
- */
-{
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
-		       USB_DEVICE_ID_MATCH_INT_CLASS |
-		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
-	.idVendor = 0x046d,
-	.idProduct = 0x08f0,
-	.bInterfaceClass = USB_CLASS_AUDIO,
-	.bInterfaceSubClass = USB_SUBCLASS_AUDIO_CONTROL
-},
-{
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
-		       USB_DEVICE_ID_MATCH_INT_CLASS |
-		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
-	.idVendor = 0x046d,
-	.idProduct = 0x08f6,
-	.bInterfaceClass = USB_CLASS_AUDIO,
-	.bInterfaceSubClass = USB_SUBCLASS_AUDIO_CONTROL
-},
-
-/*
-=======
  * Logitech QuickCam: bDeviceClass is vendor-specific, so generic interface
  * class matches do not take effect without an explicit ID match.
  */
@@ -97,7 +72,6 @@
 },
 
 /*
->>>>>>> /sound/usb/usbquirks.h
  * Yamaha devices
  */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ntfs-use-zero_user_page.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-arm.patch
git-avr32.patch
cinergyt2-fix-file-release-handler.patch
i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder.patch
git-gfs2-nmw.patch
git-hid-fixup.patch
git-ieee1394.patch
git-leds.patch
git-leds-fixup.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-e1000.patch
fix-race-condition-about-network-device-name-fix.patch
git-battery.patch
git-ocfs2.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-wireless.patch
git-wireless-fixup.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
xfs-clean-up-shrinker-games.patch
remove-slab_ctor_constructor-fix.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
crc7-support-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
w1-build-fix.patch
check_dirty_inode_list.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch

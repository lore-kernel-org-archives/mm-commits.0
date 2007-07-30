From: akpm@linux-foundation.org
Subject: + drivers-usb-serial-sierrac-make-3-functions-static.patch added to -mm tree
Date: Mon, 30 Jul 2007 15:09:57 -0700
Message-ID: <200707302209.l6UM9v1J000584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53397 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968749AbXG3WKN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 18:10:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, greg@kroah.com


The patch titled
     drivers/usb/serial/sierra.c: make 3 functions static
has been added to the -mm tree.  Its filename is
     drivers-usb-serial-sierrac-make-3-functions-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/usb/serial/sierra.c: make 3 functions static
From: Adrian Bunk <bunk@stusta.de>

This patch makes three needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/sierra.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/usb/serial/sierra.c~drivers-usb-serial-sierrac-make-3-functions-static drivers/usb/serial/sierra.c
--- a/drivers/usb/serial/sierra.c~drivers-usb-serial-sierrac-make-3-functions-static
+++ a/drivers/usb/serial/sierra.c
@@ -45,7 +45,7 @@ enum devicetype {
 	DEVICE_INSTALLER =	2,
 };
 
-int sierra_set_power_state(struct usb_device *udev, __u16 swiState)
+static int sierra_set_power_state(struct usb_device *udev, __u16 swiState)
 {
 	int result;
 	dev_dbg(&udev->dev, "%s", "SET POWER STATE");
@@ -60,7 +60,7 @@ int sierra_set_power_state(struct usb_de
 	return result;
 }
 
-int sierra_set_ms_mode(struct usb_device *udev, __u16 eSocMode)
+static int sierra_set_ms_mode(struct usb_device *udev, __u16 eSocMode)
 {
 	int result;
 	dev_dbg(&udev->dev, "%s", "DEVICE MODE SWITCH");
@@ -75,7 +75,8 @@ int sierra_set_ms_mode(struct usb_device
 	return result;
 }
 
-int sierra_probe(struct usb_interface *iface, const struct usb_device_id *id)
+static int sierra_probe(struct usb_interface *iface,
+			const struct usb_device_id *id)
 {
 	int result;
 	struct usb_device *udev;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
make-drivers-acpi-eventcacpi_event_seqnum-static.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
drivers-base-power-make-2-functions-static.patch
git-drm.patch
git-dvb.patch
drivers-i2c-i2c-corec-make-code-static.patch
git-hwmon.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
git-mtd.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
fore200e_param_bs_queue-must-be-__devinit.patch
git-ocfs2.patch
cpqphp_ctrlc-remove-dead-code.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
usb_serial_suspend-buggy-code.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
radeon_driver_vblank_do_wait-static.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
kernel-rtmutex-debugc-cleanups.patch
fs-nfsd-exportc-make-3-functions-static.patch
mm-page_allocc-make-code-static.patch
make-struct-sony_nc_ids-static.patch
make-pktgencget_ipsec_sa-static-and-non-inline.patch
make-nf_ct_ipv6_skip_exthdr-static.patch
net-unix-af_unixc-make-code-static.patch
drivers-usb-serial-sierrac-make-3-functions-static.patch
backlight-make-2-structs-static.patch
unexport-pm_power_off_prepare.patch
unexport-fb_prepare_logo.patch

From: akpm@linux-foundation.org
Subject: - amd-5536-udc-remove-unneeded-memset.patch removed from -mm tree
Date: Wed, 19 Sep 2007 15:30:54 -0700
Message-ID: <200709192230.l8JMUshl014474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42960 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653AbXISWa5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Sep 2007 18:30:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     AMD 5536 UDC - Remove unneeded memset()
has been removed from the -mm tree.  Its filename was
     amd-5536-udc-remove-unneeded-memset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: AMD 5536 UDC - Remove unneeded memset()
From: Jesper Juhl <jesper.juhl@gmail.com>

In drivers/usb/gadget/amd5536udc.c::udc_pci_probe() - We allocate storage
for 'dev' with kzalloc(), so it is already zero, no need for an extra
memset().

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/amd5536udc.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/usb/gadget/amd5536udc.c~amd-5536-udc-remove-unneeded-memset drivers/usb/gadget/amd5536udc.c
--- a/drivers/usb/gadget/amd5536udc.c~amd-5536-udc-remove-unneeded-memset
+++ a/drivers/usb/gadget/amd5536udc.c
@@ -3244,7 +3244,6 @@ static int udc_pci_probe(
 		retval = -ENOMEM;
 		goto finished;
 	}
-	memset(dev, 0, sizeof(struct udc));
 
 	/* pci setup */
 	if (pci_enable_device(pdev) < 0) {
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

git-alsa.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-cifs.patch
git-powerpc.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-dvb.patch
git-gfs2-nmw.patch
git-kbuild.patch
git-mtd.patch
git-ubi.patch
git-net.patch
eepro100-avoid-potential-null-pointer-deref-in-speedo_init_rx_ring.patch
avoid-possible-null-pointer-deref-in-3c359-driver.patch
git-backlight.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
git-scsi-misc.patch
fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch
amd-5536-udc-remove-unneeded-memset.patch
git-xfs.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
mm-no-need-to-cast-vmalloc-return-value-in-zone_wait_table_init.patch
uml-remove-unneeded-void-cast.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
docs-ramdisk-initrd-initramfs-corrections.patch
clean-up-duplicate-includes-in-drivers-spi.patch
fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch
isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer.patch
fbdev-update-documentation-fb-00-index.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
add-a-missing-00-index-file-for-documentation-vm.patch
add-a-00-index-file-to-documentation-mips.patch
add-a-00-index-file-to-documentation-sysctl.patch
add-a-00-index-file-to-documentation-telephony.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch

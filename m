From: akpm@linux-foundation.org
Subject: - mpt-fusion-fix-two-potential-mem-leaks.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:27:38 -0700
Message-ID: <200709160927.l8G9Rc0W009274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50559 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751970AbXIPJiW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:38:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, Eric.Moore@lsil.com, mm-commits@vger.kernel.org


The patch titled
     mpt-fusion: fix two potential mem leaks
has been removed from the -mm tree.  Its filename was
     mpt-fusion-fix-two-potential-mem-leaks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mpt-fusion: fix two potential mem leaks
From: Jesper Juhl <jesper.juhl@gmail.com>

The Coverity checker spotted two potential memory leaks in
drivers/message/fusion/mptbase.c::mpt_attach().

There are two returns that may leak the storage allocated for 'ioc'
(sizeof(MPT_ADAPTER) bytes).

A simple fix would be to simply add two kfree() calls before the return
statements, but a better fix (that this patch implements) is to reorder the
code so that if we hit the first return condition we don't have to do the
allocation at all and then just add a kfree() call for the second case.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~mpt-fusion-fix-two-potential-mem-leaks drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~mpt-fusion-fix-two-potential-mem-leaks
+++ a/drivers/message/fusion/mptbase.c
@@ -1458,18 +1458,18 @@ mpt_attach(struct pci_dev *pdev, const s
 	struct proc_dir_entry *dent, *ent;
 #endif
 
+	if (mpt_debug_level)
+		printk(KERN_INFO MYNAM ": mpt_debug_level=%xh\n", mpt_debug_level);
+
+	if (pci_enable_device(pdev))
+		return r;
+
 	ioc = kzalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
 	if (ioc == NULL) {
 		printk(KERN_ERR MYNAM ": ERROR - Insufficient memory to add adapter!\n");
 		return -ENOMEM;
 	}
-
 	ioc->debug_level = mpt_debug_level;
-	if (mpt_debug_level)
-		printk(KERN_INFO MYNAM ": mpt_debug_level=%xh\n", mpt_debug_level);
-
-	if (pci_enable_device(pdev))
-		return r;
 
 	dinitprintk(ioc, printk(KERN_WARNING MYNAM ": mpt_adapter_install\n"));
 
@@ -1478,6 +1478,7 @@ mpt_attach(struct pci_dev *pdev, const s
 			": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n"));
 	} else if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
 		printk(KERN_WARNING MYNAM ": 32 BIT PCI BUS DMA ADDRESSING NOT SUPPORTED\n");
+		kfree(ioc);
 		return r;
 	}
 
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

git-alsa.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
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

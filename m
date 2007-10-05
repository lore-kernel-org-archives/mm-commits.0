From: akpm@linux-foundation.org
Subject: - avoid-possible-null-pointer-deref-in-3c359-driver.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:57:32 -0700
Message-ID: <200710051957.l95JvWAu022473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42501 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762564AbXJEUBD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Avoid possible NULL pointer deref in 3c359 driver
has been removed from the -mm tree.  Its filename was
     avoid-possible-null-pointer-deref-in-3c359-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Avoid possible NULL pointer deref in 3c359 driver
From: Jesper Juhl <jesper.juhl@gmail.com>

In xl_freemem(), if dev_if is NULL, the line

  struct xl_private *xl_priv =(struct xl_private *)dev->priv;

will cause a NULL pointer dereference.

(akpm: don't try to fix it: just delete the pointless test-for-null)

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tokenring/3c359.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/net/tokenring/3c359.c~avoid-possible-null-pointer-deref-in-3c359-driver drivers/net/tokenring/3c359.c
--- a/drivers/net/tokenring/3c359.c~avoid-possible-null-pointer-deref-in-3c359-driver
+++ a/drivers/net/tokenring/3c359.c
@@ -1045,11 +1045,6 @@ static irqreturn_t xl_interrupt(int irq,
 	u8 __iomem * xl_mmio = xl_priv->xl_mmio ; 
 	u16 intstatus, macstatus  ;
 
-	if (!dev) { 
-		printk(KERN_WARNING "Device structure dead, aaahhhh !\n") ;
-		return IRQ_NONE; 
-	}
-
 	intstatus = readw(xl_mmio + MMIO_INTSTATUS) ;  
 
 	if (!(intstatus & 1)) /* We didn't generate the interrupt */
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
git-backlight.patch
git-nfs.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
git-scsi-misc.patch
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
add-a-missing-00-index-file-for-documentation-vm-fix.patch
add-a-00-index-file-to-documentation-mips.patch
add-a-00-index-file-to-documentation-sysctl.patch
add-a-00-index-file-to-documentation-telephony.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch

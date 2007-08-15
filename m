From: akpm@linux-foundation.org
Subject: + avoid-possible-null-pointer-deref-in-3c359-driver.patch added to -mm tree
Date: Wed, 15 Aug 2007 15:04:07 -0700
Message-ID: <200708152204.l7FM47BN017301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59113 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758386AbXHOWFB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 18:05:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com


The patch titled
     Avoid possible NULL pointer deref in 3c359 driver
has been added to the -mm tree.  Its filename is
     avoid-possible-null-pointer-deref-in-3c359-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Avoid possible NULL pointer deref in 3c359 driver
From: Jesper Juhl <jesper.juhl@gmail.com>

In xl_freemem(), if dev_if is NULL, the line

  struct xl_private *xl_priv =(struct xl_private *)dev->priv;

will cause a NULL pointer dereference.  However, if we move that assignment
below the 'if' statement that tests for a NULL 'dev', then that NULL deref can
never happen.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tokenring/3c359.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/net/tokenring/3c359.c~avoid-possible-null-pointer-deref-in-3c359-driver drivers/net/tokenring/3c359.c
--- a/drivers/net/tokenring/3c359.c~avoid-possible-null-pointer-deref-in-3c359-driver
+++ a/drivers/net/tokenring/3c359.c
@@ -1042,15 +1042,17 @@ static void xl_freemem(struct net_device
 static irqreturn_t xl_interrupt(int irq, void *dev_id) 
 {
 	struct net_device *dev = (struct net_device *)dev_id;
- 	struct xl_private *xl_priv =netdev_priv(dev);
-	u8 __iomem * xl_mmio = xl_priv->xl_mmio ; 
-	u16 intstatus, macstatus  ;
+ 	struct xl_private *xl_priv;
+	u8 __iomem * xl_mmio;
+	u16 intstatus, macstatus;
 
 	if (!dev) { 
-		printk(KERN_WARNING "Device structure dead, aaahhhh !\n") ;
+		printk(KERN_WARNING "3c359: Device structure dead, aaahhhh!\n");
 		return IRQ_NONE; 
 	}
 
+	xl_priv = netdev_priv(dev);
+	xl_mmio = xl_priv->xl_mmio;
 	intstatus = readw(xl_mmio + MMIO_INTSTATUS) ;  
 
 	if (!(intstatus & 1)) /* We didn't generate the interrupt */
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-alsa.patch
git-agpgart.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
powerpc-clean-out-a-bunch-of-duplicate-includes.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-dvb.patch
fix-a-memory-leak-in-em28xx_usb_probe.patch
git-gfs2-nmw.patch
clean-up-duplicate-includes-in-drivers-input.patch
scripts-ver_linux-correct-printing-of-binutils-version.patch
improve-scripts-gcc-versionsh-output-a-bit-when-called-without-args.patch
git-mtd.patch
git-ubi.patch
git-netdev-all.patch
git-backlight.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
sh64-arch-sh64-kernel-signalh-duplicate-include-removal.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
mpt-fusion-fix-two-potential-mem-leaks.patch
fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch
emulex-fc-hba-driver-fix-overflow-of-statically-allocated-array.patch
git-xfs.patch
fix-a-potential-null-pointer-deref-in-xfs-on-failed-mount.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
clean-up-duplicate-includes-in-drivers-spi.patch
fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch
isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
eepro100-avoid-potential-null-pointer-deref-in-speedo_init_rx_ring.patch
avoid-possible-null-pointer-deref-in-3c359-driver.patch

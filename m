From: akpm@linux-foundation.org
Subject: - fix-a-memory-leak-in-em28xx_usb_probe.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:12:15 -0700
Message-ID: <200708201912.l7KJCFA6018337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34842 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758462AbXHTTVQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Fix a memory leak in em28xx_usb_probe()
has been removed from the -mm tree.  Its filename was
     fix-a-memory-leak-in-em28xx_usb_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix a memory leak in em28xx_usb_probe()
From: Jesper Juhl <jesper.juhl@gmail.com>

If, in em28xx_usb_probe() the memory allocation
	dev->alt_max_pkt_size = kmalloc(32*
						dev->num_alt,GFP_KERNEL);
fails, then we'll bail out and return -ENOMEM.
The problem is that in that case we don't free the storage allocated
to 'dev', thus causing a memory leak.

This patch fixes the leak by freeing 'dev' before we return -ENOMEM.
This fixes Coverity bug #647.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/em28xx/em28xx-video.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/media/video/em28xx/em28xx-video.c~fix-a-memory-leak-in-em28xx_usb_probe drivers/media/video/em28xx/em28xx-video.c
--- a/drivers/media/video/em28xx/em28xx-video.c~fix-a-memory-leak-in-em28xx_usb_probe
+++ a/drivers/media/video/em28xx/em28xx-video.c
@@ -1770,6 +1770,7 @@ static int em28xx_usb_probe(struct usb_i
 	if (dev->alt_max_pkt_size == NULL) {
 		em28xx_errdev("out of memory!\n");
 		em28xx_devused&=~(1<<nr);
+		kfree(dev);
 		return -ENOMEM;
 	}
 
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-alsa.patch
git-agpgart.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-powerpc.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-dvb.patch
git-gfs2-nmw.patch
clean-up-duplicate-includes-in-drivers-input.patch
scripts-ver_linux-correct-printing-of-binutils-version.patch
improve-scripts-gcc-versionsh-output-a-bit-when-called-without-args.patch
git-mtd.patch
git-ubi.patch
git-netdev-all.patch
eepro100-avoid-potential-null-pointer-deref-in-speedo_init_rx_ring.patch
avoid-possible-null-pointer-deref-in-3c359-driver.patch
git-backlight.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
git-scsi-misc.patch
mpt-fusion-fix-two-potential-mem-leaks.patch
fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch
git-watchdog.patch
git-xfs.patch
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

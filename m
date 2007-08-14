From: akpm@linux-foundation.org
Subject: + fix-a-memory-leak-in-em28xx_usb_probe.patch added to -mm tree
Date: Tue, 14 Aug 2007 12:34:39 -0700
Message-ID: <200708141934.l7EJYd7D017438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39383 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753765AbXHNTew (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:34:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, mchehab@infradead.org


The patch titled
     Fix a memory leak in em28xx_usb_probe()
has been added to the -mm tree.  Its filename is
     fix-a-memory-leak-in-em28xx_usb_probe.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

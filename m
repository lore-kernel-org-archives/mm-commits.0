From: akpm@linux-foundation.org
Subject: - uml-remove-unneeded-void-cast.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:38:30 -0700
Message-ID: <200710162038.l9GKcUXv015454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40857 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935994AbXJPVHh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: remove unneeded void * cast
has been removed from the -mm tree.  Its filename was
     uml-remove-unneeded-void-cast.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: remove unneeded void * cast
From: Jesper Juhl <jesper.juhl@gmail.com>

vmalloc() returns a void pointer, so casting to (void *) is pretty pointless.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ubd_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/drivers/ubd_kern.c~uml-remove-unneeded-void-cast arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-remove-unneeded-void-cast
+++ a/arch/um/drivers/ubd_kern.c
@@ -615,7 +615,7 @@ static int ubd_open_dev(struct ubd *ubd_
 		blk_queue_max_sectors(ubd_dev->queue, 8 * sizeof(long));
 
 		err = -ENOMEM;
-		ubd_dev->cow.bitmap = (void *) vmalloc(ubd_dev->cow.bitmap_len);
+		ubd_dev->cow.bitmap = vmalloc(ubd_dev->cow.bitmap_len);
 		if(ubd_dev->cow.bitmap == NULL){
 			printk(KERN_ERR "Failed to vmalloc COW bitmap\n");
 			goto error;
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-alsa.patch
git-cifs.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-xfs.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
docs-ramdisk-initrd-initramfs-corrections.patch
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

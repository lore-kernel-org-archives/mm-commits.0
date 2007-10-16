From: akpm@linux-foundation.org
Subject: - mm-no-need-to-cast-vmalloc-return-value-in-zone_wait_table_init.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:31:44 -0700
Message-ID: <200710162031.l9GKViEp014527@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45947 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933879AbXJPVim (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:38:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: no need to cast vmalloc() return value in zone_wait_table_init()
has been removed from the -mm tree.  Its filename was
     mm-no-need-to-cast-vmalloc-return-value-in-zone_wait_table_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: no need to cast vmalloc() return value in zone_wait_table_init()
From: Jesper Juhl <jesper.juhl@gmail.com>

vmalloc() returns a void pointer, so there's no need to cast its
return value in mm/page_alloc.c::zone_wait_table_init().

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-no-need-to-cast-vmalloc-return-value-in-zone_wait_table_init mm/page_alloc.c
--- a/mm/page_alloc.c~mm-no-need-to-cast-vmalloc-return-value-in-zone_wait_table_init
+++ a/mm/page_alloc.c
@@ -2444,7 +2444,7 @@ int zone_wait_table_init(struct zone *zo
 		 * To use this new node's memory, further consideration will be
 		 * necessary.
 		 */
-		zone->wait_table = (wait_queue_head_t *)vmalloc(alloc_size);
+		zone->wait_table = vmalloc(alloc_size);
 	}
 	if (!zone->wait_table)
 		return -ENOMEM;
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

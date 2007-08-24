From: akpm@linux-foundation.org
Subject: + mm-no-need-to-cast-vmalloc-return-value-in-zone_wait_table_init.patch added to -mm tree
Date: Thu, 23 Aug 2007 18:08:01 -0700
Message-ID: <200708240108.l7O181Fc003566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38064 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765446AbXHXBId (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 21:08:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com


The patch titled
     mm: no need to cast vmalloc() return value in zone_wait_table_init()
has been added to the -mm tree.  Its filename is
     mm-no-need-to-cast-vmalloc-return-value-in-zone_wait_table_init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: no need to cast vmalloc() return value in zone_wait_table_init()
From: Jesper Juhl <jesper.juhl@gmail.com>

vmalloc() returns a void pointer, so there's no need to cast its
return value in mm/page_alloc.c::zone_wait_table_init().

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-no-need-to-cast-vmalloc-return-value-in-zone_wait_table_init mm/page_alloc.c
--- a/mm/page_alloc.c~mm-no-need-to-cast-vmalloc-return-value-in-zone_wait_table_init
+++ a/mm/page_alloc.c
@@ -2456,7 +2456,7 @@ int zone_wait_table_init(struct zone *zo
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
fix-ver_linux-glibc-version-printing.patch
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
mm-no-need-to-cast-vmalloc-return-value-in-zone_wait_table_init.patch
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

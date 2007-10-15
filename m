From: akpm@linux-foundation.org
Subject: - fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:17:06 -0700
Message-ID: <200710150917.l9F9H6uv027245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53013 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755101AbXJOJSQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:18:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, airlied@linux.ie, davej@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Fix "use after free" / "double free" bug in amd_create_gatt_pages / amd_free_gatt_pages
has been removed from the -mm tree.  Its filename was
     fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix "use after free" / "double free" bug in amd_create_gatt_pages / amd_free_gatt_pages
From: Jesper Juhl <jesper.juhl@gmail.com>

Coverity spotted a "use after free" bug in
drivers/char/agp/amd-k7-agp.c::amd_create_gatt_pages().

The problem is this:
	If "entry = kzalloc(sizeof(struct amd_page_map), GFP_KERNEL);"
fails, then there's a loop in the function to free all entries
allocated so far and break out of the allocation loop. That in itself
is pretty sane, but then the (now freed) 'tables' is assigned to
amd_irongate_private.gatt_pages and 'retval' is set to -ENOMEM which
causes amd_free_gatt_pages(); to be called at the end of the function.
The problem with this is that amd_free_gatt_pages() will then loop
'amd_irongate_private.num_tables' times and try to free each entry in
tables[] - this is bad since tables has already been freed and
furthermore it will call kfree(tables) at the end - a double free.

This patch removes the freeing loop in amd_create_gatt_pages() and
instead relies entirely on the call to amd_free_gatt_pages() to free
everything we allocated in case of an error. It also sets
amd_irongate_private.num_tables to the actual number of entries
allocated instead of just using the value passed in from the caller -
this ensures that amd_free_gatt_pages() will only attempt to free
stuff that was actually allocated.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/amd-k7-agp.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/char/agp/amd-k7-agp.c~fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages drivers/char/agp/amd-k7-agp.c
--- a/drivers/char/agp/amd-k7-agp.c~fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages
+++ a/drivers/char/agp/amd-k7-agp.c
@@ -100,21 +100,16 @@ static int amd_create_gatt_pages(int nr_
 
 	for (i = 0; i < nr_tables; i++) {
 		entry = kzalloc(sizeof(struct amd_page_map), GFP_KERNEL);
+		tables[i] = entry;
 		if (entry == NULL) {
-			while (i > 0) {
-				kfree(tables[i-1]);
-				i--;
-			}
-			kfree(tables);
 			retval = -ENOMEM;
 			break;
 		}
-		tables[i] = entry;
 		retval = amd_create_page_map(entry);
 		if (retval != 0)
 			break;
 	}
-	amd_irongate_private.num_tables = nr_tables;
+	amd_irongate_private.num_tables = i;
 	amd_irongate_private.gatt_pages = tables;
 
 	if (retval != 0)
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-alsa.patch
git-agpgart.patch
git-cifs.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-kbuild.patch
git-nfs.patch
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

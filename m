From: akpm@linux-foundation.org
Subject: + fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch added to -mm tree
Date: Thu, 19 Jul 2007 23:29:41 -0700
Message-ID: <200707200629.l6K6TfQU011536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35906 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754237AbXGTGaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 02:30:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, airlied@linux.ie


The patch titled
     Fix "use after free" / "double free" bug in amd_create_gatt_pages / amd_free_gatt_pages
has been added to the -mm tree.  Its filename is
     fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
cr_backlight_probe-allocates-too-little-storage-for-struct-cr_panel.patch
memory-leak-in-tpm_ascii_bios_measurements_open-fix.patch
fix-acpi_ev_pci_config_region_setup-to-avoid-memory-leak.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-gfs2-nmw.patch
git-mtd.patch
git-xfs.patch
ipmi-fix-mem-leak-in-try_init_dmi.patch
fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch

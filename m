From: akpm@linux-foundation.org
Subject: + fix-use-after-free--double-free-bug-in-ati_create_gatt_pages--ati_free_gatt_pages.patch added to -mm tree
Date: Mon, 23 Jul 2007 16:01:36 -0700
Message-ID: <200707232301.l6NN1asd016523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40150 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751472AbXGWXB4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 19:01:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, airlied@linux.ie, davej@codemonkey.org.uk


The patch titled
     Fix "use after free" / "double free" bug in ati_create_gatt_pages / ati_free_gatt_pages
has been added to the -mm tree.  Its filename is
     fix-use-after-free--double-free-bug-in-ati_create_gatt_pages--ati_free_gatt_pages.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix "use after free" / "double free" bug in ati_create_gatt_pages / ati_free_gatt_pages
From: Jesper Juhl <jesper.juhl@gmail.com>

Coverity spotted a "use after free" bug in
drivers/char/agp/ati-agp.c::ati_create_gatt_pages().

The same one that was in
  drivers/char/agp/amd-k7-agp.c::amd_create_gatt_pages()

The problem is this:
       If "entry = kzalloc(sizeof(struct ati_page_map), GFP_KERNEL);"
fails, then there's a loop in the function to free all entries
allocated so far and break out of the allocation loop. That in itself
is pretty sane, but then the (now freed) 'tables' is assigned to
ati_generic_private.gatt_pages and 'retval' is set to -ENOMEM which
causes ati_free_gatt_pages(); to be called at the end of the function.
The problem with this is that ati_free_gatt_pages() will then loop
'ati_generic_private.num_tables' times and try to free each entry in
tables[] - this is bad since tables has already been freed and
furthermore it will call kfree(tables) at the end - a double free.

This patch removes the freeing loop in ati_create_gatt_pages() and
instead relies entirely on the call to ati_free_gatt_pages() to free
everything we allocated in case of an error. It also sets
ati_generic_private.num_tables to the actual number of entries
allocated instead of just using the value passed in from the caller -
this ensures that ati_free_gatt_pages() will only attempt to free
stuff that was actually allocated.

Note: I'm in no way intimate with this code and I have no way to
actually test this patch (besides compile test it), so while I've
tried to be careful in reading the code and make sure the patch
does the right thing an ACK from someone who actually knows the
code in-depth would be very much appreciated.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/ati-agp.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/char/agp/ati-agp.c~fix-use-after-free--double-free-bug-in-ati_create_gatt_pages--ati_free_gatt_pages drivers/char/agp/ati-agp.c
--- a/drivers/char/agp/ati-agp.c~fix-use-after-free--double-free-bug-in-ati_create_gatt_pages--ati_free_gatt_pages
+++ a/drivers/char/agp/ati-agp.c
@@ -123,21 +123,16 @@ static int ati_create_gatt_pages(int nr_
 
 	for (i = 0; i < nr_tables; i++) {
 		entry = kzalloc(sizeof(struct ati_page_map), GFP_KERNEL);
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
 		retval = ati_create_page_map(entry);
 		if (retval != 0)
 			break;
 	}
-	ati_generic_private.num_tables = nr_tables;
+	ati_generic_private.num_tables = i;
 	ati_generic_private.gatt_pages = tables;
 
 	if (retval != 0)
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
fix-use-after-free--double-free-bug-in-ati_create_gatt_pages--ati_free_gatt_pages.patch
git-gfs2-nmw.patch
hid-fix-a-null-pointer-dereference-when-we-fail-to-allocate-memory.patch
git-kbuild.patch
git-mtd.patch
git-selinux.patch
git-xfs.patch
ipmi-fix-mem-leak-in-try_init_dmi.patch
fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch

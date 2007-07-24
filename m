From: akpm@linux-foundation.org
Subject: - fix-use-after-free--double-free-bug-in-ati_create_gatt_pages--ati_free_gatt_pages.patch removed from -mm tree
Date: Mon, 23 Jul 2007 23:04:43 -0700
Message-ID: <200707240604.l6O64h6G031435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60478 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753441AbXGXGFA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 02:05:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, airlied@linux.ie, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     Fix "use after free" / "double free" bug in ati_create_gatt_pages / ati_free_gatt_pages
has been removed from the -mm tree.  Its filename was
     fix-use-after-free--double-free-bug-in-ati_create_gatt_pages--ati_free_gatt_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-alsa.patch
clean-up-duplicate-includes-in-sound-ppc.patch
git-agpgart.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-dvb.patch
clean-up-duplicate-includes-in-drivers-hwmon.patch
git-gfs2-nmw.patch
hid-fix-a-null-pointer-dereference-when-we-fail-to-allocate-memory.patch
clean-up-duplicate-includes-in-drivers-input.patch
git-kbuild.patch
git-mtd.patch
clean-up-duplicate-includes-in-drivers-net.patch
clean-up-duplicate-includes-in-drivers-atm.patch
clean-up-duplicate-includes-in-net-atm.patch
clean-up-duplicate-includes-in-net-bridge.patch
clean-up-duplicate-includes-in-net-ipv4.patch
clean-up-duplicate-includes-in-net-ipv6.patch
clean-up-duplicate-includes-in-net-netfilter.patch
clean-up-duplicate-includes-in-net-sched.patch
clean-up-duplicate-includes-in-net-sunrpc.patch
clean-up-duplicate-includes-in-net-tipc.patch
clean-up-duplicate-includes-in-net-xfrm.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
git-selinux.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
clean-up-duplicate-includes-in-drivers-block.patch
clean-up-duplicate-includes-in-drivers-usb.patch
clean-up-duplicate-includes-in-arch-i386-xen.patch
git-xfs.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
ipmi-fix-mem-leak-in-try_init_dmi.patch
fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
cciss-fix-memory-leak.patch
clean-up-duplicate-includes-in-drivers-spi.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch

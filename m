From: akpm@linux-foundation.org
Subject: - get_unmapped_area-handles-map_fixed-in-generic-code.patch removed from -mm tree
Date: Mon, 07 May 2007 17:04:15 -0700
Message-ID: <200705080004.l4804Fqi009000@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967482AbXEHAN5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:13:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, agl@us.ibm.com, ak@suse.de, bill.irwin@oracle.com, davem@davemloft.net, david@gibson.dropbear.id.au, dhowells@redhat.com, grundler@parisc-linux.org, ink@jurassic.park.msu.ru, kyle@mcmartin.ca, paulus@samba.org, rmk+kernel@arm.linux.org.uk, rth@twiddle.net, tony.luck@intel.com, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     get_unmapped_area handles MAP_FIXED in generic code
has been removed from the -mm tree.  Its filename was
     get_unmapped_area-handles-map_fixed-in-generic-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: get_unmapped_area handles MAP_FIXED in generic code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

generic arch_get_unmapped_area() now handles MAP_FIXED.  Now that all
implementations have been fixed, change the toplevel get_unmapped_area() to
call into arch or drivers for the MAP_FIXED case.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <willy@debian.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: William Irwin <bill.irwin@oracle.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff -puN mm/mmap.c~get_unmapped_area-handles-map_fixed-in-generic-code mm/mmap.c
--- a/mm/mmap.c~get_unmapped_area-handles-map_fixed-in-generic-code
+++ a/mm/mmap.c
@@ -1200,6 +1200,9 @@ arch_get_unmapped_area(struct file *filp
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
+	if (flags & MAP_FIXED)
+		return addr;
+
 	if (addr) {
 		addr = PAGE_ALIGN(addr);
 		vma = find_vma(mm, addr);
@@ -1273,6 +1276,9 @@ arch_get_unmapped_area_topdown(struct fi
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
+	if (flags & MAP_FIXED)
+		return addr;
+
 	/* requesting a specific address */
 	if (addr) {
 		addr = PAGE_ALIGN(addr);
@@ -1361,22 +1367,21 @@ get_unmapped_area(struct file *file, uns
 		unsigned long pgoff, unsigned long flags)
 {
 	unsigned long ret;
+	unsigned long (*get_area)(struct file *, unsigned long,
+				  unsigned long, unsigned long, unsigned long);
 
-	if (!(flags & MAP_FIXED)) {
-		unsigned long (*get_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
-
-		get_area = current->mm->get_unmapped_area;
-		if (file && file->f_op && file->f_op->get_unmapped_area)
-			get_area = file->f_op->get_unmapped_area;
-		addr = get_area(file, addr, len, pgoff, flags);
-		if (IS_ERR_VALUE(addr))
-			return addr;
-	}
+	get_area = current->mm->get_unmapped_area;
+	if (file && file->f_op && file->f_op->get_unmapped_area)
+		get_area = file->f_op->get_unmapped_area;
+	addr = get_area(file, addr, len, pgoff, flags);
+	if (IS_ERR_VALUE(addr))
+		return addr;
 
 	if (addr > TASK_SIZE - len)
 		return -ENOMEM;
 	if (addr & ~PAGE_MASK)
 		return -EINVAL;
+
 	if (file && is_file_hugepages(file))  {
 		/*
 		 * Check if the given range is hugepage aligned, and
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
git-powerpc.patch
gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed-powerpc-fixes.patch
use-slab_panic-flag-cleanup.patch
the-scheduled-removal-of-obsolete_oss-options.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
parport-dev-driver-model-support.patch
introduce-freezer-flags-rev-2.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-powerpc-optimization.patch
aty128fb-fix-blanking.patch
radeonfb-add-support-for-radeon-xpress-200m.patch

From: akpm@linux-foundation.org
Subject: + get_unmapped_area-handles-map_fixed-in-generic-code.patch added to -mm tree
Date: Sat, 28 Apr 2007 01:34:20 -0700
Message-ID: <200704280834.l3S8YKSX018116@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030413AbXD1IgQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 04:36:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, agl@us.ibm.com, ak@suse.de, bill.irwin@oracle.com, davem@davemloft.net, david@gibson.dropbear.id.au, dhowells@redhat.com, grundler@parisc-linux.org, ink@jurassic.park.msu.ru, kyle@mcmartin.ca, paulus@samba.org, rmk+kernel@arm.linux.org.uk, rth@twiddle.net, tony.luck@intel.com, willy@debian.org


The patch titled
     get_unmapped_area handles MAP_FIXED in generic code
has been added to the -mm tree.  Its filename is
     get_unmapped_area-handles-map_fixed-in-generic-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1209,6 +1209,9 @@ arch_get_unmapped_area(struct file *filp
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
+	if (flags & MAP_FIXED)
+		return addr;
+
 	if (addr) {
 		addr = PAGE_ALIGN(addr);
 		vma = find_vma(mm, addr);
@@ -1282,6 +1285,9 @@ arch_get_unmapped_area_topdown(struct fi
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
+	if (flags & MAP_FIXED)
+		return addr;
+
 	/* requesting a specific address */
 	if (addr) {
 		addr = PAGE_ALIGN(addr);
@@ -1370,22 +1376,21 @@ get_unmapped_area(struct file *file, uns
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

git-powerpc.patch
git-powerpc-arch-powerpc-sysdev-timerc-build-fix.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
powerpc-rtas-msi-support.patch
spin_lock_unlocked-cleanup-in-arch-powerpc.patch
macintosh-mediabay-convert-to-kthread-api.patch
macintosh-adb-convert-to-the-kthread-api.patch
macintosh-therm_pm72c-partially-convert-to-kthread-api.patch
s2ram-add-arch-irq-disable-enable-hooks.patch
fix-jdelvare-i2c-i2c-del-driver-returns-void-on-powerpc.patch
slub-core.patch
use-slab_panic-flag-cleanup.patch
get_unmapped_area-handles-map_fixed-on-powerpc.patch
get_unmapped_area-handles-map_fixed-on-alpha.patch
get_unmapped_area-handles-map_fixed-on-arm.patch
get_unmapped_area-handles-map_fixed-on-frv.patch
get_unmapped_area-handles-map_fixed-on-i386.patch
get_unmapped_area-handles-map_fixed-on-ia64.patch
get_unmapped_area-handles-map_fixed-on-parisc.patch
get_unmapped_area-handles-map_fixed-on-sparc64.patch
get_unmapped_area-handles-map_fixed-on-x86_64.patch
get_unmapped_area-handles-map_fixed-in-hugetlbfs.patch
get_unmapped_area-handles-map_fixed-in-generic-code.patch
get_unmapped_area-doesnt-need-hugetlbfs-hacks-anymore.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
parport-dev-driver-model-support-powerpc-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc-fix.patch
local_t-powerpc-extension.patch
linux-kernel-markers-powerpc-optimization.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3av-misc-updates.patch
aty128fb-fix-blanking.patch
radeonfb-add-support-for-radeon-xpress-200m.patch

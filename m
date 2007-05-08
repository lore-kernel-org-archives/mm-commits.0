From: akpm@linux-foundation.org
Subject: - get_unmapped_area-handles-map_fixed-on-powerpc.patch removed from -mm tree
Date: Mon, 07 May 2007 17:03:39 -0700
Message-ID: <200705080003.l4803dxw008967@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967378AbXEHAGd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, agl@us.ibm.com, ak@suse.de, bill.irwin@oracle.com, davem@davemloft.net, david@gibson.dropbear.id.au, dhowells@redhat.com, grundler@parisc-linux.org, ink@jurassic.park.msu.ru, kyle@mcmartin.ca, paulus@samba.org, rmk+kernel@arm.linux.org.uk, rth@twiddle.net, tony.luck@intel.com, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     get_unmapped_area handles MAP_FIXED on powerpc
has been removed from the -mm tree.  Its filename was
     get_unmapped_area-handles-map_fixed-on-powerpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: get_unmapped_area handles MAP_FIXED on powerpc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

The current get_unmapped_area code calls the f_ops->get_unmapped_area or the
arch one (via the mm) only when MAP_FIXED is not passed.  That makes it
impossible for archs to impose proper constraints on regions of the virtual
address space.  To work around that, get_unmapped_area() then calls some
hugetlbfs specific hacks.

This cause several problems, among others:

- It makes it impossible for a driver or filesystem to do the same thing
  that hugetlbfs does (for example, to allow a driver to use larger page sizes
  to map external hardware) if that requires applying a constraint on the
  addresses (constraining that mapping in certain regions and other mappings
  out of those regions).

- Some archs like arm, mips, sparc, sparc64, sh and sh64 already want
  MAP_FIXED to be passed down in order to deal with aliasing issues.  The code
  is there to handle it...  but is never called.

This series of patches moves the logic to handle MAP_FIXED down to the various
arch/driver get_unmapped_area() implementations, and then changes the generic
code to always call them.  The hugetlbfs hacks then disappear from the generic
code.

Since I need to do some special 64K pages mappings for SPEs on cell, I need to
work around the first problem at least.  I have further patches thus
implementing a "slices" layer that handles multiple page sizes through slices
of the address space for use by hugetlbfs, the SPE code, and possibly others,
but it requires that serie of patches first/

There is still a potential (but not practical) issue due to the fact that
filesystems/drivers implemeting g_u_a will effectively bypass all arch checks.
 This is not an issue in practice as the only filesystems/drivers using that
hook are doing so for arch specific purposes in the first place.

There is also a problem with mremap that will completely bypass all arch
checks.  I'll try to address that separately, I'm not 100% certain yet how,
possibly by making it not work when the vma has a file whose f_ops has a
get_unmapped_area callback, and by making it use is_hugepage_only_range()
before expanding into a new area.

Also, I want to turn is_hugepage_only_range() into a more generic
is_normal_page_range() as that's really what it will end up meaning when used
in stack grow, brk grow and mremap.

None of the above "issues" however are introduced by this patch, they are
already there, so I think the patch can go ini for 2.6.22.



This patch:

Handle MAP_FIXED in powerpc's arch_get_unmapped_area() in all 3
implementations of it.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: William Irwin <bill.irwin@oracle.com>
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
Cc: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/hugetlbpage.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN arch/powerpc/mm/hugetlbpage.c~get_unmapped_area-handles-map_fixed-on-powerpc arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~get_unmapped_area-handles-map_fixed-on-powerpc
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -566,6 +566,13 @@ unsigned long arch_get_unmapped_area(str
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
+	/* handle fixed mapping: prevent overlap with huge pages */
+	if (flags & MAP_FIXED) {
+		if (is_hugepage_only_range(mm, addr, len))
+			return -EINVAL;
+		return addr;
+	}
+
 	if (addr) {
 		addr = PAGE_ALIGN(addr);
 		vma = find_vma(mm, addr);
@@ -641,6 +648,13 @@ arch_get_unmapped_area_topdown(struct fi
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
+	/* handle fixed mapping: prevent overlap with huge pages */
+	if (flags & MAP_FIXED) {
+		if (is_hugepage_only_range(mm, addr, len))
+			return -EINVAL;
+		return addr;
+	}
+
 	/* dont allow allocations above current base */
 	if (mm->free_area_cache > base)
 		mm->free_area_cache = base;
@@ -823,6 +837,13 @@ unsigned long hugetlb_get_unmapped_area(
 	/* Paranoia, caller should have dealt with this */
 	BUG_ON((addr + len)  < addr);
 
+	/* Handle MAP_FIXED */
+	if (flags & MAP_FIXED) {
+		if (prepare_hugepage_range(addr, len, pgoff))
+			return -EINVAL;
+		return addr;
+	}
+
 	if (test_thread_flag(TIF_32BIT)) {
 		curareas = current->mm->context.low_htlb_areas;
 
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

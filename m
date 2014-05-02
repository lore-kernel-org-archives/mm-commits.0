From: akpm@linux-foundation.org
Subject: + mm-call-kmemleak-directly-from-memblock_allocfree.patch added
 to -mm tree
Date: Fri, 02 May 2014 15:49:17 -0700
Message-ID: <536420ed.8oLz/bTtmqr5LCYc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaEBWtS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2014 18:49:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org, catalin.marinas@arm.com

Subject: + mm-call-kmemleak-directly-from-memblock_allocfree.patch added to -mm tree
To: catalin.marinas@arm.com,akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Fri, 02 May 2014 15:49:17 -0700


The patch titled
     Subject: mm/memblock.c: call kmemleak directly from memblock_(alloc|free)
has been added to the -mm tree.  Its filename is
     mm-call-kmemleak-directly-from-memblock_allocfree.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-call-kmemleak-directly-from-memblock_allocfree.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-call-kmemleak-directly-from-memblock_allocfree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm/memblock.c: call kmemleak directly from memblock_(alloc|free)

Kmemleak could ignore memory blocks allocated via memblock_alloc() leading
to false positives during scanning.  This patch adds the corresponding
callbacks and removes kmemleak_free_* calls in mm/nobootmem.c to avoid
duplication.  The kmemleak_alloc() in mm/nobootmem.c is kept since
__alloc_memory_core_early() does not use memblock_alloc() directly.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c  |   10 ++++++++--
 mm/nobootmem.c |    2 --
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/memblock.c~mm-call-kmemleak-directly-from-memblock_allocfree mm/memblock.c
--- a/mm/memblock.c~mm-call-kmemleak-directly-from-memblock_allocfree
+++ a/mm/memblock.c
@@ -681,6 +681,7 @@ int __init_memblock memblock_free(phys_a
 		     (unsigned long long)base + size - 1,
 		     (void *)_RET_IP_);
 
+	kmemleak_free_part(__va(base), size);
 	return __memblock_remove(&memblock.reserved, base, size);
 }
 
@@ -985,9 +986,14 @@ static phys_addr_t __init memblock_alloc
 		align = SMP_CACHE_BYTES;
 
 	found = memblock_find_in_range_node(size, align, start, end, nid);
-	if (found && !memblock_reserve(found, size))
+	if (found && !memblock_reserve(found, size)) {
+		/*
+		 * The min_count is set to 0 so that memblock allocations are
+		 * never reported as leaks.
+		 */
+		kmemleak_alloc(__va(found), size, 0, 0);
 		return found;
-
+	}
 	return 0;
 }
 
diff -puN mm/nobootmem.c~mm-call-kmemleak-directly-from-memblock_allocfree mm/nobootmem.c
--- a/mm/nobootmem.c~mm-call-kmemleak-directly-from-memblock_allocfree
+++ a/mm/nobootmem.c
@@ -197,7 +197,6 @@ unsigned long __init free_all_bootmem(vo
 void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 			      unsigned long size)
 {
-	kmemleak_free_part(__va(physaddr), size);
 	memblock_free(physaddr, size);
 }
 
@@ -212,7 +211,6 @@ void __init free_bootmem_node(pg_data_t
  */
 void __init free_bootmem(unsigned long addr, unsigned long size)
 {
-	kmemleak_free_part(__va(addr), size);
 	memblock_free(addr, size);
 }
 
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
mm-kmemleakc-use-%u-to-print-checksum.patch
mm-introduce-kmemleak_update_trace.patch
lib-update-the-kmemleak-stack-trace-for-radix-tree-allocations.patch
mm-update-the-kmemleak-stack-trace-for-mempool-allocations.patch
mm-call-kmemleak-directly-from-memblock_allocfree.patch
mm-postpone-the-disabling-of-kmemleak-early-logging.patch
documentation-devicetree-bindings-add-documentation-for-the-apm-x-gene-soc-rtc-dts-binding.patch
drivers-rtc-add-apm-x-gene-soc-rtc-driver.patch
arm64-add-apm-x-gene-soc-rtc-dts-entry.patch
linux-next.patch


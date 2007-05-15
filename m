From: akpm@linux-foundation.org
Subject: - ia64-race-flushing-icache-in-do_no_page-path.patch removed from -mm tree
Date: Mon, 14 May 2007 17:41:57 -0700
Message-ID: <200705150041.l4F0fv1n030309@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752443AbXEOAng (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 20:43:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.stroyan@hp.com, hugh@veritas.com, nickpiggin@yahoo.com.au, riel@redhat.com, stable@kernel.org, tony.luck@intel.com, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     ia64: race flushing icache in do_no_page path
has been removed from the -mm tree.  Its filename was
     ia64-race-flushing-icache-in-do_no_page-path.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: ia64: race flushing icache in do_no_page path
From: Mike Stroyan <mike.stroyan@hp.com>

This is a very similar problem to a copy-on-write cache flushing problem
that Tony Luck fixed in July 2006.  In this case the do_no_page function
handles a fault in an executable or library that is mmapped from an NFS
file system.  The code is copied into a newly reallocated page.  The
lazy_mmu_prot_update() function should be used to flush old entries from
the icache for that page on ia64 processors.  But that call is made after a
set_pte_at call that makes the page accessible to other threads executing
the same code.  This was seen to cause application crashes when an OpenMP
application ran many threads calling same functions at the same time.  The
first thread to reach a page starts to fault in the new code.  One of the
other threads overtakes the first and executes old data from the icache. 
That could result in bad instructions.  It is more obvious when an old
cache line contains prefetched non-instruction bits that result in an
illegal instruction trap.

The problem has only been seen on montecito processors which have separate
level 2 icache and dcache.  This dcache to icache coherency problem is more
likely to occur there because of the much larger level 2 icache.  I suspect
that the non-NFS case is working because direct DMA into the new page is
making the instruction cache coherent.  Any file system that uses a non-DMA
copy into the text page could show the same problem.

Signed-off-by: Mike Stroyan <mike.stroyan@hp.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@kernel.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~ia64-race-flushing-icache-in-do_no_page-path mm/memory.c
--- a/mm/memory.c~ia64-race-flushing-icache-in-do_no_page-path
+++ a/mm/memory.c
@@ -2385,6 +2385,7 @@ retry:
 		entry = mk_pte(new_page, vma->vm_page_prot);
 		if (write_access)
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+		lazy_mmu_prot_update(entry);
 		set_pte_at(mm, address, page_table, entry);
 		if (anon) {
 			inc_mm_counter(mm, anon_rss);
@@ -2406,7 +2407,6 @@ retry:
 
 	/* no need to invalidate: a not-present page shouldn't be cached */
 	update_mmu_cache(vma, address, entry);
-	lazy_mmu_prot_update(entry);
 unlock:
 	pte_unmap_unlock(page_table, ptl);
 	if (dirty_page) {
_

Patches currently in -mm which might be from mike.stroyan@hp.com are

ia64-race-flushing-icache-in-do_no_page-path.patch

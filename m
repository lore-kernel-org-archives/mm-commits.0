From: akpm@linux-foundation.org
Subject: + madv_free-lazytlb-fix.patch added to -mm tree
Date: Wed, 25 Apr 2007 18:26:26 -0700
Message-ID: <200704260126.l3Q1QQb9017953@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932344AbXDZB0k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 21:26:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, a.p.zijlstra@chello.nl, hugh@veritas.com, nickpiggin@yahoo.com.au


The patch titled
     madv_free lazytlb fix
has been added to the -mm tree.  Its filename is
     madv_free-lazytlb-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: madv_free lazytlb fix
From: Rik van Riel <riel@redhat.com>

Jakub found a potential bug, in that I did not use an atomic
operation to clear the page table entries.  I've attached a
new patch which simply uses ptep_test_and_clear_dirty/young
to get rid of the dirty and accessed bits.

It uses the same atomic accesses we use elsewhere in the VM
and the code is a line shorter than before.

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~madv_free-lazytlb-fix mm/memory.c
--- a/mm/memory.c~madv_free-lazytlb-fix
+++ a/mm/memory.c
@@ -677,11 +677,14 @@ static unsigned long zap_pte_range(struc
 						remove_exclusive_swap_page(page);
 						unlock_page(page);
 					}
-					ptep_clear_flush_dirty(vma, addr, pte);
-					ptep_clear_flush_young(vma, addr, pte);
+					ptep_test_and_clear_dirty(vma, addr, pte);
+					ptep_test_and_clear_young(vma, addr, pte);
 					SetPageLazyFree(page);
 					if (PageActive(page))
 						deactivate_tail_page(page);
+					/* tlb_remove_page frees it again */
+					get_page(page);
+					tlb_remove_page(tlb, page);
 					continue;
 				}
 			}
_

Patches currently in -mm which might be from riel@redhat.com are

mm-madvise-avoid-exclusive-mmap_sem.patch
lazy-freeing-of-memory-through-madv_free.patch
lazy-freeing-of-memory-through-madv_free-fix.patch
lazy-freeing-of-memory-through-madv_free-sparc-fix.patch
madv_free-lazytlb-fix.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch

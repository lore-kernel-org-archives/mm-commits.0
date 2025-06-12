Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB4A15C158;
	Thu, 12 Jun 2025 05:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749706986; cv=none; b=mJBrBOnueGxdgZZFoX8NJPRiN5IeQ591/nYWTxiNHHQQ+jqIapl92fXSm5qMcRfdrZ1UEGpakCGdB/5KfwPg78I1pxKP7U58m/DyJ5zlevNVWgwuHjIe/gVBZPMrqVNCiLDT1g9gGRW0SbXdsX/QwmDmVHR//g+YCMvGVITBZHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749706986; c=relaxed/simple;
	bh=5o4A/U+LGdiXkh5Q+B0sPQnfiEs00mFUje+7+RL6obw=;
	h=Date:To:From:Subject:Message-Id; b=IZ2ViBfIo1eLP25PNslE517RyZngGaCEQki7dXnd73ggSn+EAhAK4NmFrIJLMxgRoZpdy+MlShfry59LrWYS+F5EXNsFXzTqo/khviLNpWHAk0YgSGP3J++we0JF+Fng91IJOcHRG1qCehCQxyXOlFE7XlOUktnMTtL/Psm0s8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cdRK7zCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cdRK7zCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C4BC4CEF0;
	Thu, 12 Jun 2025 05:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749706986;
	bh=5o4A/U+LGdiXkh5Q+B0sPQnfiEs00mFUje+7+RL6obw=;
	h=Date:To:From:Subject:From;
	b=cdRK7zCEHNNvkfsHEvdD2UaIebYomTlYM0eEr5kF3JxduOM5X7k+odkvJ8ULLRyJM
	 qT6orfmno/0Pn7y1ka7RfS10xBIOfZd6xPlz7xu24rDdmpTbJcY5quAoOqgw2RQPDO
	 Kvh1XrYdkqR+zB1VBWNRPdWWB2f1hSX2NcjC2uzI=
Date: Wed, 11 Jun 2025 22:43:05 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,mgorman@suse.de,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-close-theoretical-race-where-stale-tlb-entries-could-linger.patch removed from -mm tree
Message-Id: <20250612054306.00C4BC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: close theoretical race where stale TLB entries could linger
has been removed from the -mm tree.  Its filename was
     mm-close-theoretical-race-where-stale-tlb-entries-could-linger.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: close theoretical race where stale TLB entries could linger
Date: Fri, 6 Jun 2025 10:28:07 +0100

Commit 3ea277194daa ("mm, mprotect: flush TLB if potentially racing with a
parallel reclaim leaving stale TLB entries") described a theoretical race
as such:


"""
Nadav Amit identified a theoretical race between page reclaim and mprotect
due to TLB flushes being batched outside of the PTL being held.

He described the race as follows:

	CPU0                            CPU1
	----                            ----
					user accesses memory using RW PTE
					[PTE now cached in TLB]
	try_to_unmap_one()
	==> ptep_get_and_clear()
	==> set_tlb_ubc_flush_pending()
					mprotect(addr, PROT_READ)
					==> change_pte_range()
					==> [ PTE non-present - no flush ]

					user writes using cached RW PTE
	...

	try_to_unmap_flush()

The same type of race exists for reads when protecting for PROT_NONE and
also exists for operations that can leave an old TLB entry behind such as
munmap, mremap and madvise.
"""

The solution was to introduce flush_tlb_batched_pending() and call it
under the PTL from mprotect/madvise/munmap/mremap to complete any pending
tlb flushes.

However, while madvise_free_pte_range() and
madvise_cold_or_pageout_pte_range() were both retro-fitted to call
flush_tlb_batched_pending() immediately after initially acquiring the PTL,
they both temporarily release the PTL to split a large folio if they
stumble upon one.  In this case, where re-acquiring the PTL
flush_tlb_batched_pending() must be called again, but it previously was
not.  Let's fix that.

There are 2 Fixes: tags here: the first is the commit that fixed
madvise_free_pte_range().  The second is the commit that added
madvise_cold_or_pageout_pte_range(), which looks like it copy/pasted the
faulty pattern from madvise_free_pte_range().

This is a theoretical bug discovered during code review.

Link: https://lkml.kernel.org/r/20250606092809.4194056-1-ryan.roberts@arm.com
Fixes: 3ea277194daa ("mm, mprotect: flush TLB if potentially racing with a parallel reclaim leaving stale TLB entries")
Fixes: 9c276cc65a58 ("mm: introduce MADV_COLD")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Jann Horn <jannh@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/madvise.c~mm-close-theoretical-race-where-stale-tlb-entries-could-linger
+++ a/mm/madvise.c
@@ -508,6 +508,7 @@ restart:
 					pte_offset_map_lock(mm, pmd, addr, &ptl);
 				if (!start_pte)
 					break;
+				flush_tlb_batched_pending(mm);
 				arch_enter_lazy_mmu_mode();
 				if (!err)
 					nr = 0;
@@ -741,6 +742,7 @@ static int madvise_free_pte_range(pmd_t
 				start_pte = pte;
 				if (!start_pte)
 					break;
+				flush_tlb_batched_pending(mm);
 				arch_enter_lazy_mmu_mode();
 				if (!err)
 					nr = 0;
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-readahead-honour-new_order-in-page_cache_ra_order.patch
mm-readahead-terminate-async-readahead-on-natural-boundary.patch
mm-readahead-make-space-in-struct-file_ra_state.patch
mm-readahead-store-folio-order-in-struct-file_ra_state.patch
mm-filemap-allow-arch-to-request-folio-size-for-exec-memory.patch
mm-remove-arch_flush_tlb_batched_pending-arch-helper.patch


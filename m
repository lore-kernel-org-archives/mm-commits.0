Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0337118412C
	for <mm-commits@vger.kernel.org>; Thu, 18 Apr 2024 19:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469750; cv=none; b=CQIcyv977i2OBwAL/cxWuVG2MO3OssRbzaTLEvmPTAjC+cNX5ZvDo2fveUeY8nuPdgegztAyh5YaCUZw4nY6JamEvnYNGmkPXkhepOk5gGBjvJfnNf36pg5ncGEtpWzkm8RHk8RNftQTqfQ5ILocrox7fhc3DYC1E9BNLglpQeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469750; c=relaxed/simple;
	bh=aJl5oceZagccITdt0Fn+cbSYLI6L+uhW0FE0rm59FUY=;
	h=Date:To:From:Subject:Message-Id; b=aUFZKE95UiRTP11PsxLgl2wq+TG9qlCf6B0HB2cqP4z0u5db64kUKsD7Lys8I+pB2IONN+RxdIc/vqbwtvsxHC+wxNaxzTGY/Nb5bM3XSVb4SjbFveNtRkAOS/aoB/Mqxj+rEJZcujgi2MyfEUuFtx8VUntQuhglBf2Tm24mXkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s+vDv8gS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s+vDv8gS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2104C116B1;
	Thu, 18 Apr 2024 19:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713469749;
	bh=aJl5oceZagccITdt0Fn+cbSYLI6L+uhW0FE0rm59FUY=;
	h=Date:To:From:Subject:From;
	b=s+vDv8gSv/UixfvJ4xc3StWngsukep5aTmd4c/OqyE7hOUB2DPdURb/U+xTL8FspN
	 A0F2TlW18XcC0+Z4PAEdw/SM0dxdYNSQGaOgiL6a5LXZe7IoXcfoMmyzXm6HJuT+Nz
	 e95VYSJqgLKb69Gz+Dq9Ig33dEqyhmPLqQhOxH+8=
Date: Thu, 18 Apr 2024 12:49:09 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,xiehuan09@gmail.com,wangkefeng.wang@huawei.com,songmuchun@bytedance.com,shy828301@gmail.com,ryan.roberts@arm.com,peterx@redhat.com,minchan@kernel.org,mhocko@suse.com,fengwei.yin@intel.com,david@redhat.com,21cnbao@gmail.com,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-optimize-lazyfreeing-with-mthp-in-madvise_free.patch added to mm-unstable branch
Message-Id: <20240418194909.C2104C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: optimize lazyfreeing with mTHP in madvise_free
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-optimize-lazyfreeing-with-mthp-in-madvise_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-optimize-lazyfreeing-with-mthp-in-madvise_free.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: mm/madvise: optimize lazyfreeing with mTHP in madvise_free
Date: Thu, 18 Apr 2024 21:44:35 +0800

This patch optimizes lazyfreeing with PTE-mapped mTHP[1] (Inspired by
David Hildenbrand[2]).  We aim to avoid unnecessary folio splitting if the
large folio is fully mapped within the target range.

If a large folio is locked or shared, or if we fail to split it, we just
leave it in place and advance to the next PTE in the range.  But note that
the behavior is changed; previously, any failure of this sort would cause
the entire operation to give up.  As large folios become more common,
sticking to the old way could result in wasted opportunities.

On an Intel I5 CPU, lazyfreeing a 1GiB VMA backed by PTE-mapped folios of
the same size results in the following runtimes for madvise(MADV_FREE) in
seconds (shorter is better):

Folio Size |   Old    |   New    | Change
------------------------------------------
      4KiB | 0.590251 | 0.590259 |    0%
     16KiB | 2.990447 | 0.185655 |  -94%
     32KiB | 2.547831 | 0.104870 |  -95%
     64KiB | 2.457796 | 0.052812 |  -97%
    128KiB | 2.281034 | 0.032777 |  -99%
    256KiB | 2.230387 | 0.017496 |  -99%
    512KiB | 2.189106 | 0.010781 |  -99%
   1024KiB | 2.183949 | 0.007753 |  -99%
   2048KiB | 0.002799 | 0.002804 |    0%

[1] https://lkml.kernel.org/r/20231207161211.2374093-5-ryan.roberts@arm.com
[2] https://lore.kernel.org/linux-mm/20240214204435.167852-1-david@redhat.com

Link: https://lkml.kernel.org/r/20240418134435.6092-5-ioworker0@gmail.com
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Jeff Xie <xiehuan09@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   85 +++++++++++++++++++++++++------------------------
 1 file changed, 44 insertions(+), 41 deletions(-)

--- a/mm/madvise.c~mm-madvise-optimize-lazyfreeing-with-mthp-in-madvise_free
+++ a/mm/madvise.c
@@ -643,6 +643,7 @@ static int madvise_free_pte_range(pmd_t
 				unsigned long end, struct mm_walk *walk)
 
 {
+	const cydp_t cydp_flags = CYDP_CLEAR_YOUNG | CYDP_CLEAR_DIRTY;
 	struct mmu_gather *tlb = walk->private;
 	struct mm_struct *mm = tlb->mm;
 	struct vm_area_struct *vma = walk->vma;
@@ -697,44 +698,57 @@ static int madvise_free_pte_range(pmd_t
 			continue;
 
 		/*
-		 * If pmd isn't transhuge but the folio is large and
-		 * is owned by only this process, split it and
-		 * deactivate all pages.
+		 * If we encounter a large folio, only split it if it is not
+		 * fully mapped within the range we are operating on. Otherwise
+		 * leave it as is so that it can be marked as lazyfree. If we
+		 * fail to split a folio, leave it in place and advance to the
+		 * next pte in the range.
 		 */
 		if (folio_test_large(folio)) {
-			int err;
+			bool any_young, any_dirty;
 
-			if (folio_likely_mapped_shared(folio))
-				break;
-			if (!folio_trylock(folio))
-				break;
-			folio_get(folio);
-			arch_leave_lazy_mmu_mode();
-			pte_unmap_unlock(start_pte, ptl);
-			start_pte = NULL;
-			err = split_folio(folio);
-			folio_unlock(folio);
-			folio_put(folio);
-			if (err)
-				break;
-			start_pte = pte =
-				pte_offset_map_lock(mm, pmd, addr, &ptl);
-			if (!start_pte)
-				break;
-			arch_enter_lazy_mmu_mode();
-			pte--;
-			addr -= PAGE_SIZE;
-			continue;
+			nr = madvise_folio_pte_batch(addr, end, folio, pte,
+						     ptent, &any_young, &any_dirty);
+
+			if (nr < folio_nr_pages(folio)) {
+				int err;
+
+				if (folio_likely_mapped_shared(folio))
+					continue;
+				if (!folio_trylock(folio))
+					continue;
+				folio_get(folio);
+				arch_leave_lazy_mmu_mode();
+				pte_unmap_unlock(start_pte, ptl);
+				start_pte = NULL;
+				err = split_folio(folio);
+				folio_unlock(folio);
+				folio_put(folio);
+				pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+				start_pte = pte;
+				if (!start_pte)
+					break;
+				arch_enter_lazy_mmu_mode();
+				if (!err)
+					nr = 0;
+				continue;
+			}
+
+			if (any_young)
+				ptent = pte_mkyoung(ptent);
+			if (any_dirty)
+				ptent = pte_mkdirty(ptent);
 		}
 
 		if (folio_test_swapcache(folio) || folio_test_dirty(folio)) {
 			if (!folio_trylock(folio))
 				continue;
 			/*
-			 * If folio is shared with others, we mustn't clear
-			 * the folio's dirty flag.
+			 * If we have a large folio at this point, we know it is
+			 * fully mapped so if its mapcount is the same as its
+			 * number of pages, it must be exclusive.
 			 */
-			if (folio_mapcount(folio) != 1) {
+			if (folio_mapcount(folio) != folio_nr_pages(folio)) {
 				folio_unlock(folio);
 				continue;
 			}
@@ -750,19 +764,8 @@ static int madvise_free_pte_range(pmd_t
 		}
 
 		if (pte_young(ptent) || pte_dirty(ptent)) {
-			/*
-			 * Some of architecture(ex, PPC) don't update TLB
-			 * with set_pte_at and tlb_remove_tlb_entry so for
-			 * the portability, remap the pte with old|clean
-			 * after pte clearing.
-			 */
-			ptent = ptep_get_and_clear_full(mm, addr, pte,
-							tlb->fullmm);
-
-			ptent = pte_mkold(ptent);
-			ptent = pte_mkclean(ptent);
-			set_pte_at(mm, addr, pte, ptent);
-			tlb_remove_tlb_entry(tlb, pte, addr);
+			clear_young_dirty_ptes(vma, addr, pte, nr, cydp_flags);
+			tlb_remove_tlb_entries(tlb, pte, nr, addr);
 		}
 		folio_mark_lazyfree(folio);
 	}
_

Patches currently in -mm which might be from ioworker0@gmail.com are

mm-madvise-introduce-clear_young_dirty_ptes-batch-helper.patch
mm-arm64-override-clear_young_dirty_ptes-batch-helper.patch
mm-memory-add-any_dirty-optional-pointer-to-folio_pte_batch.patch
mm-madvise-optimize-lazyfreeing-with-mthp-in-madvise_free.patch


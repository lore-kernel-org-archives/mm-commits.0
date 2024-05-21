Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFE836134
	for <mm-commits@vger.kernel.org>; Tue, 21 May 2024 23:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716333554; cv=none; b=E4geFnNSquaXGzKhQqiP6txMTLWY8v4suQgKpGkXY5iMo8VOGWi26hicnGMnQ1SG7Xc94Ma1O7OAey+fvmgHB7jHUxvRNWk8zoRCvSZ0CoV+PDdSGqqC9LmSwnyNI5wvXYT8e979+HhqXxtiGw28ikL9vGCuKP6om1kMnTvy+DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716333554; c=relaxed/simple;
	bh=H+dT+L7+esQ62b9+gAYH/sWchBYTKof0cZRJcYZeHE0=;
	h=Date:To:From:Subject:Message-Id; b=NyTO/tn/Gopw2ghR2HVUrK3rx7/jdcsWAQqbJ88Pb8+v/LEOGLfvVwwrE9AFbXNl2lJrJCJbZdGRSmzLA93csiRyXvjSJE9/Q9Q5TJV6ovrBM2QTPMJaBjuDHPqwGqiHt3yuD+3Zr3FWJfy4WonM0VFUDn0SmVU51GMeFDDiU38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rmhx7wKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rmhx7wKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8252C2BD11;
	Tue, 21 May 2024 23:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716333553;
	bh=H+dT+L7+esQ62b9+gAYH/sWchBYTKof0cZRJcYZeHE0=;
	h=Date:To:From:Subject:From;
	b=Rmhx7wKRJLMgyo66Ed+i9f8L/5yWOVkT1HEtH+tLpz7aL2P17X11ytbAa03Y1oNqX
	 ABE8hcZsCvZ21JuzmjQOuP/kIjbf1VTV9TX1rlQe1yQE5cojFrh3t/IPholSCblPvv
	 DbaTOjCvj++nFZmLGP+ND4P9eWdJCyQJku4w3sL8=
Date: Tue, 21 May 2024 16:19:13 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,xiehuan09@gmail.com,willy@infradead.org,wangkefeng.wang@huawei.com,songmuchun@bytedance.com,shy828301@gmail.com,ryan.roberts@arm.com,peterx@redhat.com,minchan@kernel.org,mhocko@suse.com,maskray@google.com,fengwei.yin@intel.com,david@redhat.com,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-remove-duplicated-exit-code-in-pagewalk-loop.patch added to mm-unstable branch
Message-Id: <20240521231913.A8252C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: remove duplicated exit code in pagewalk loop
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-remove-duplicated-exit-code-in-pagewalk-loop.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-remove-duplicated-exit-code-in-pagewalk-loop.patch

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
Subject: mm/rmap: remove duplicated exit code in pagewalk loop
Date: Tue, 21 May 2024 12:02:42 +0800

Patch series "Reclaim lazyfree THP without splitting", v6.

This series adds support for reclaiming PMD-mapped THP marked as lazyfree
without needing to first split the large folio via
split_huge_pmd_address().

When the user no longer requires the pages, they would use
madvise(MADV_FREE) to mark the pages as lazy free.  Subsequently, they
typically would not re-write to that memory again.

During memory reclaim, if we detect that the large folio and its PMD are
both still marked as clean and there are no unexpected references(such as
GUP), so we can just discard the memory lazily, improving the efficiency
of memory reclamation in this case.

Performance Testing
===================

On an Intel i5 CPU, reclaiming 1GiB of lazyfree THPs using
mem_cgroup_force_empty() results in the following runtimes in seconds
(shorter is better):

--------------------------------------------
|     Old       |      New       |  Change  |
--------------------------------------------
|   0.683426    |    0.049197    |  -92.80% |
--------------------------------------------


This patch (of 3):

Introduce the labels walk_done and walk_done_err as exit points to
eliminate duplicated exit code in the pagewalk loop.

Link: https://lkml.kernel.org/r/20240521040244.48760-1-ioworker0@gmail.com
Link: https://lkml.kernel.org/r/20240521040244.48760-2-ioworker0@gmail.com
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Jeff Xie <xiehuan09@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   40 +++++++++++++++-------------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

--- a/mm/rmap.c~mm-rmap-remove-duplicated-exit-code-in-pagewalk-loop
+++ a/mm/rmap.c
@@ -1679,9 +1679,7 @@ static bool try_to_unmap_one(struct foli
 			/* Restore the mlock which got missed */
 			if (!folio_test_large(folio))
 				mlock_vma_folio(folio, vma);
-			page_vma_mapped_walk_done(&pvmw);
-			ret = false;
-			break;
+			goto walk_done_err;
 		}
 
 		pfn = pte_pfn(ptep_get(pvmw.pte));
@@ -1719,11 +1717,8 @@ static bool try_to_unmap_one(struct foli
 			 */
 			if (!anon) {
 				VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
-				if (!hugetlb_vma_trylock_write(vma)) {
-					page_vma_mapped_walk_done(&pvmw);
-					ret = false;
-					break;
-				}
+				if (!hugetlb_vma_trylock_write(vma))
+					goto walk_done_err;
 				if (huge_pmd_unshare(mm, vma, address, pvmw.pte)) {
 					hugetlb_vma_unlock_write(vma);
 					flush_tlb_range(vma,
@@ -1738,8 +1733,7 @@ static bool try_to_unmap_one(struct foli
 					 * actual page and drop map count
 					 * to zero.
 					 */
-					page_vma_mapped_walk_done(&pvmw);
-					break;
+					goto walk_done;
 				}
 				hugetlb_vma_unlock_write(vma);
 			}
@@ -1811,9 +1805,7 @@ static bool try_to_unmap_one(struct foli
 			if (unlikely(folio_test_swapbacked(folio) !=
 					folio_test_swapcache(folio))) {
 				WARN_ON_ONCE(1);
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+				goto walk_done_err;
 			}
 
 			/* MADV_FREE page check */
@@ -1852,23 +1844,17 @@ static bool try_to_unmap_one(struct foli
 				 */
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				folio_set_swapbacked(folio);
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+				goto walk_done_err;
 			}
 
 			if (swap_duplicate(entry) < 0) {
 				set_pte_at(mm, address, pvmw.pte, pteval);
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+				goto walk_done_err;
 			}
 			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
 				swap_free(entry);
 				set_pte_at(mm, address, pvmw.pte, pteval);
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+				goto walk_done_err;
 			}
 
 			/* See folio_try_share_anon_rmap(): clear PTE first. */
@@ -1876,9 +1862,7 @@ static bool try_to_unmap_one(struct foli
 			    folio_try_share_anon_rmap_pte(folio, subpage)) {
 				swap_free(entry);
 				set_pte_at(mm, address, pvmw.pte, pteval);
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+				goto walk_done_err;
 			}
 			if (list_empty(&mm->mmlist)) {
 				spin_lock(&mmlist_lock);
@@ -1918,6 +1902,12 @@ discard:
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
 		folio_put(folio);
+		continue;
+walk_done_err:
+		ret = false;
+walk_done:
+		page_vma_mapped_walk_done(&pvmw);
+		break;
 	}
 
 	mmu_notifier_invalidate_range_end(&range);
_

Patches currently in -mm which might be from ioworker0@gmail.com are

mm-rmap-remove-duplicated-exit-code-in-pagewalk-loop.patch
mm-rmap-integrate-pmd-mapped-folio-splitting-into-pagewalk-loop.patch
mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list.patch


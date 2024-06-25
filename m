Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A700E143C6F
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291679; cv=none; b=URUGpLH38fh9ATogeolzAjlAHCEihWSYYSL0B0SV6tE5bRIY4jgmABG6Wn0F8mtaScD5rUswoxL4RLILaVcAMRY7S3oH8VrLgtTIYaeFWq81y9NCaYfKOPrzOCzCK2il/FXNIn9czJLYlzSfTy90LC42qCBuaa7+1cpzjWccmTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291679; c=relaxed/simple;
	bh=DF2jozRiMWaRfJ++tvAjIVBd6xddNj5Z6uh6mrP4NMU=;
	h=Date:To:From:Subject:Message-Id; b=tXJl1sNysdZuEMrzzXwaqJwfAriG5NWy9B72ChB9rMKDKSyHySoZaoTST7AQGh1eIonC8b0BC3rcFKlrX4YaJrqRY4uPeReKoiaXzRahoixGzGgSqrJRTki4qsP5BNaU5hihXr/S/e3paP9lQ8smVpmpjcFByMz2+YtDEyX48dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=opXlqFDl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="opXlqFDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB81C32782;
	Tue, 25 Jun 2024 05:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291679;
	bh=DF2jozRiMWaRfJ++tvAjIVBd6xddNj5Z6uh6mrP4NMU=;
	h=Date:To:From:Subject:From;
	b=opXlqFDlxvh9561pj40rO0VzARCmMn0VDRnBLkuFzCROJeLAvH+Cs4VVfDj0QCjpG
	 0O+NJ/hKh3ofAdvIEla0QpwCXKZ8HplvHAOLLCa9tWzN67IntYql9NwQJ3CvdzMJty
	 WCAlJ2MZmAf4Ibyz51+N90W7gwYoY9TQHZdSalZY=
Date: Mon, 24 Jun 2024 22:01:19 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,xiehuan09@gmail.com,willy@infradead.org,wangkefeng.wang@huawei.com,songmuchun@bytedance.com,sj@kernel.org,shy828301@gmail.com,ryan.roberts@arm.com,peterx@redhat.com,minchan@kernel.org,mhocko@suse.com,maskray@google.com,libang.li@antgroup.com,fengwei.yin@intel.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-remove-duplicated-exit-code-in-pagewalk-loop.patch removed from -mm tree
Message-Id: <20240625050119.7CB81C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: remove duplicated exit code in pagewalk loop
has been removed from the -mm tree.  Its filename was
     mm-rmap-remove-duplicated-exit-code-in-pagewalk-loop.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: mm/rmap: remove duplicated exit code in pagewalk loop
Date: Fri, 14 Jun 2024 09:51:36 +0800

Patch series "Reclaim lazyfree THP without splitting", v8.

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


This patch (of 8):

Introduce the labels walk_done and walk_abort as exit points to eliminate
duplicated exit code in the pagewalk loop.

Link: https://lkml.kernel.org/r/20240614015138.31461-1-ioworker0@gmail.com
Link: https://lkml.kernel.org/r/20240614015138.31461-2-ioworker0@gmail.com
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Bang Li <libang.li@antgroup.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Jeff Xie <xiehuan09@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   40 +++++++++++++++-------------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

--- a/mm/rmap.c~mm-rmap-remove-duplicated-exit-code-in-pagewalk-loop
+++ a/mm/rmap.c
@@ -1681,9 +1681,7 @@ static bool try_to_unmap_one(struct foli
 			/* Restore the mlock which got missed */
 			if (!folio_test_large(folio))
 				mlock_vma_folio(folio, vma);
-			page_vma_mapped_walk_done(&pvmw);
-			ret = false;
-			break;
+			goto walk_abort;
 		}
 
 		pfn = pte_pfn(ptep_get(pvmw.pte));
@@ -1721,11 +1719,8 @@ static bool try_to_unmap_one(struct foli
 			 */
 			if (!anon) {
 				VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
-				if (!hugetlb_vma_trylock_write(vma)) {
-					page_vma_mapped_walk_done(&pvmw);
-					ret = false;
-					break;
-				}
+				if (!hugetlb_vma_trylock_write(vma))
+					goto walk_abort;
 				if (huge_pmd_unshare(mm, vma, address, pvmw.pte)) {
 					hugetlb_vma_unlock_write(vma);
 					flush_tlb_range(vma,
@@ -1740,8 +1735,7 @@ static bool try_to_unmap_one(struct foli
 					 * actual page and drop map count
 					 * to zero.
 					 */
-					page_vma_mapped_walk_done(&pvmw);
-					break;
+					goto walk_done;
 				}
 				hugetlb_vma_unlock_write(vma);
 			}
@@ -1813,9 +1807,7 @@ static bool try_to_unmap_one(struct foli
 			if (unlikely(folio_test_swapbacked(folio) !=
 					folio_test_swapcache(folio))) {
 				WARN_ON_ONCE(1);
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+				goto walk_abort;
 			}
 
 			/* MADV_FREE page check */
@@ -1854,23 +1846,17 @@ static bool try_to_unmap_one(struct foli
 				 */
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				folio_set_swapbacked(folio);
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+				goto walk_abort;
 			}
 
 			if (swap_duplicate(entry) < 0) {
 				set_pte_at(mm, address, pvmw.pte, pteval);
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+				goto walk_abort;
 			}
 			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
 				swap_free(entry);
 				set_pte_at(mm, address, pvmw.pte, pteval);
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+				goto walk_abort;
 			}
 
 			/* See folio_try_share_anon_rmap(): clear PTE first. */
@@ -1878,9 +1864,7 @@ static bool try_to_unmap_one(struct foli
 			    folio_try_share_anon_rmap_pte(folio, subpage)) {
 				swap_free(entry);
 				set_pte_at(mm, address, pvmw.pte, pteval);
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+				goto walk_abort;
 			}
 			if (list_empty(&mm->mmlist)) {
 				spin_lock(&mmlist_lock);
@@ -1920,6 +1904,12 @@ discard:
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
 		folio_put(folio);
+		continue;
+walk_abort:
+		ret = false;
+walk_done:
+		page_vma_mapped_walk_done(&pvmw);
+		break;
 	}
 
 	mmu_notifier_invalidate_range_end(&range);
_

Patches currently in -mm which might be from ioworker0@gmail.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0507F38DF9
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957141; cv=none; b=MjEQ0+voWvj4sOIitujva6rm+AVAJfPUp9UOvB4jYSR4mcqTAfwJFKBygdUnKQIIqfYU0O5wblgdLN0AzFj4CNtBbtEqDXx7uDepa3Oh8YvzlPnlX7cYFQaWcAHOFtJvYpFRbydUH7GQRSvEyzAo1cSWn/DxVvrBPpfBYAntqw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957141; c=relaxed/simple;
	bh=aQta1wc+XeTl3F+nU66Sql2N2Yy6WF2SSIVl3tLmyh0=;
	h=Date:To:From:Subject:Message-Id; b=EoIrclb8hdC6ghMl5ANLHDQO/33fiY+ZT4CcOpw/1YYI9TUu6A/52awTsCJvrH/6SyBW0xPnPaafnA6shw76H0Orq38HwDYmR18qm32Lv3uYolbvj5P6T98vD96B1NsSoWhZpK34wG27KfcvfMv+2fi01Y2BCli/zYqIanuQ0IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f8lR+BoA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f8lR+BoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA04C113CC;
	Mon,  6 May 2024 00:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957140;
	bh=aQta1wc+XeTl3F+nU66Sql2N2Yy6WF2SSIVl3tLmyh0=;
	h=Date:To:From:Subject:From;
	b=f8lR+BoACLTNlZJHduZI3rBva+nMxxZNjevndSeZZ2OF3HJVBqczk0m4/C7nUzX7q
	 EqzYqcrGCT6RCvX7qrpBykLRD8FLQALaJltrOoub9bL+3yAscsM38I2YgxFVObS5z4
	 7DUnbROR7DYZMpKtPFnMn1mp36t2DE/qrx58ZUmM=
Date: Sun, 05 May 2024 17:59:00 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,xiehuan09@gmail.com,willy@infradead.org,wangkefeng.wang@huawei.com,songmuchun@bytedance.com,sj@kernel.org,shy828301@gmail.com,ryan.roberts@arm.com,peterx@redhat.com,minchan@kernel.org,mhocko@suse.com,maskray@google.com,fengwei.yin@intel.com,david@redhat.com,21cnbao@gmail.com,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-remove-duplicated-exit-code-in-pagewalk-loop.patch removed from -mm tree
Message-Id: <20240506005900.CDA04C113CC@smtp.kernel.org>
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
Date: Wed, 1 May 2024 12:26:58 +0800

Patch series "Reclaim lazyfree THP without splitting", v4.

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

Link: https://lkml.kernel.org/r/20240501042700.83974-1-ioworker0@gmail.com
Link: https://lkml.kernel.org/r/20240501042700.83974-2-ioworker0@gmail.com
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Tested-by: SeongJae Park <sj@kernel.org>
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
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   40 +++++++++++++++-------------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

--- a/mm/rmap.c~mm-rmap-remove-duplicated-exit-code-in-pagewalk-loop
+++ a/mm/rmap.c
@@ -1676,9 +1676,7 @@ static bool try_to_unmap_one(struct foli
 			/* Restore the mlock which got missed */
 			if (!folio_test_large(folio))
 				mlock_vma_folio(folio, vma);
-			page_vma_mapped_walk_done(&pvmw);
-			ret = false;
-			break;
+			goto walk_done_err;
 		}
 
 		pfn = pte_pfn(ptep_get(pvmw.pte));
@@ -1716,11 +1714,8 @@ static bool try_to_unmap_one(struct foli
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
@@ -1735,8 +1730,7 @@ static bool try_to_unmap_one(struct foli
 					 * actual page and drop map count
 					 * to zero.
 					 */
-					page_vma_mapped_walk_done(&pvmw);
-					break;
+					goto walk_done;
 				}
 				hugetlb_vma_unlock_write(vma);
 			}
@@ -1808,9 +1802,7 @@ static bool try_to_unmap_one(struct foli
 			if (unlikely(folio_test_swapbacked(folio) !=
 					folio_test_swapcache(folio))) {
 				WARN_ON_ONCE(1);
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+				goto walk_done_err;
 			}
 
 			/* MADV_FREE page check */
@@ -1849,23 +1841,17 @@ static bool try_to_unmap_one(struct foli
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
@@ -1873,9 +1859,7 @@ static bool try_to_unmap_one(struct foli
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
@@ -1915,6 +1899,12 @@ discard:
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



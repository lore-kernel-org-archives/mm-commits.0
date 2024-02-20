Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50B441AAC
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 22:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708467389; cv=none; b=tDNjoFK9Ii23r0xY/WXgotJK+CrBbZbKyVLMEuB0gK365uSL+cCaH5BIBb9cMHSyqLJMM5bW92HpCxlD7f6CDLfWlS4/ckI7EaJiEYiqHOAh82xqla/YMT8M7fk1MoKtTlPQQ+dGXyckrKtstLVk5t6PBC7F78z/3yObbBl3u6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708467389; c=relaxed/simple;
	bh=KkQztvjYebsP/5U8rJskVkPrHiyavyxofOQHW0RRRZg=;
	h=Date:To:From:Subject:Message-Id; b=Rd0OJCvTslmtJZcuEtfhFDXa7vOUc+FDSfzl4+oN+sCdGtN8n5AGJ/VURziGHn0JezooO69reIc8HzWUVmTaRl3ncvBLbsUFZWfY59DLnfjXnRTYRbU1ZQecLRSkRAmcrgZWBXzk+5enLOFezfLUsMJtRWGoC1NKtvm3Gw0Cq5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WT3RQI6s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WT3RQI6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7BEC433C7;
	Tue, 20 Feb 2024 22:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708467389;
	bh=KkQztvjYebsP/5U8rJskVkPrHiyavyxofOQHW0RRRZg=;
	h=Date:To:From:Subject:From;
	b=WT3RQI6sfMvncA8hROQwfCy9MWTCd7he7P/gBSt484kSDJmdzdr7X9pXHtZRr56it
	 7luTUoLDX54s1nH4jspZZAEtEkdlxue5jBBCrlv3Mih176PzM/AmTvC9GShBqD18fH
	 oLUb/RJOIRHGvcUz01R/73B4F1VsU999Eqc7JhOo=
Date: Tue, 20 Feb 2024 14:16:29 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,sj@kernel.org,minchan@kernel.org,mhocko@suse.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,21cnbao@gmail.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-fix-race-when-skipping-swapcache-v4.patch removed from -mm tree
Message-Id: <20240220221629.9E7BEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-swap-fix-race-when-skipping-swapcache-v4
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-race-when-skipping-swapcache-v4.patch

This patch was dropped because it was folded into mm-swap-fix-race-when-skipping-swapcache.patch

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm-swap-fix-race-when-skipping-swapcache-v4
Date: Mon, 19 Feb 2024 16:20:40 +0800

Add a schedule() if raced to prevent repeated page faults wasting CPU and
add noise to perf statistics.

Use a bool to state the special case instead of reusing existing variables
fixing error handling [Minchan Kim].

Use schedule_timeout_uninterruptible(1) for now instead of schedule() to
prevent the busy faulting task holds CPU and livelocks [Huang, Ying].

Link: https://lkml.kernel.org/r/20240219082040.7495-1-ryncsn@gmail.com
Fixes: 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous device")
Link: https://github.com/ryncsn/emm-test-project/tree/master/swap-stress-race [1]
Reported-by: "Huang, Ying" <ying.huang@intel.com>
Closes: https://lore.kernel.org/lkml/87bk92gqpx.fsf_-_@yhuang6-desk2.ccr.corp.intel.com/
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/mm/memory.c~mm-swap-fix-race-when-skipping-swapcache-v4
+++ a/mm/memory.c
@@ -3799,6 +3799,7 @@ vm_fault_t do_swap_page(struct vm_fault
 	struct page *page;
 	struct swap_info_struct *si = NULL;
 	rmap_t rmap_flags = RMAP_NONE;
+	bool need_clear_cache = false;
 	bool exclusive = false;
 	swp_entry_t entry;
 	pte_t pte;
@@ -3874,8 +3875,12 @@ vm_fault_t do_swap_page(struct vm_fault
 			 * reusing the same entry. It's undetectable as
 			 * pte_same() returns true due to entry reuse.
 			 */
-			if (swapcache_prepare(entry))
+			if (swapcache_prepare(entry)) {
+				/* Relax a bit to prevent rapid repeated page faults */
+				schedule_timeout_uninterruptible(1);
 				goto out;
+			}
+			need_clear_cache = true;
 
 			/* skip swapcache */
 			folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0,
@@ -4126,10 +4131,10 @@ vm_fault_t do_swap_page(struct vm_fault
 unlock:
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
+out:
 	/* Clear the swap cache pin for direct swapin after PTL unlock */
-	if (folio && !swapcache)
+	if (need_clear_cache)
 		swapcache_clear(si, entry);
-out:
 	if (si)
 		put_swap_device(si);
 	return ret;
@@ -4137,8 +4142,6 @@ out_nomap:
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 out_page:
-	if (!swapcache)
-		swapcache_clear(si, entry);
 	folio_unlock(folio);
 out_release:
 	folio_put(folio);
@@ -4146,6 +4149,8 @@ out_release:
 		folio_unlock(swapcache);
 		folio_put(swapcache);
 	}
+	if (need_clear_cache)
+		swapcache_clear(si, entry);
 	if (si)
 		put_swap_device(si);
 	return ret;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-fix-race-when-skipping-swapcache.patch


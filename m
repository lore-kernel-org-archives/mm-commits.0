Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907F011CA1
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 02:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708394963; cv=none; b=rjocUqcuXaHhKKZoGfWfJ1PJdGbDLqawYYr3PPT1HceDTh1kMEdCeqXDDIO7kkoy20tyBkvC8q/v6Y5n52uNoRYLt27QdxTqZHbJToAbQNupnbrGE+ngHzlrH+2i20ae5Ax5CRFjvsiXejhJo3uNSSkz3M/suEW378rTgRYcyEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708394963; c=relaxed/simple;
	bh=8Lc3Y8W1EalzOz8xsTnknOWescTtpTU93d6RHZljiHU=;
	h=Date:To:From:Subject:Message-Id; b=F5MKpeYQIlknAZ/ezdK35+pLKzEjrrIhFXUzQQ/IM/7OV1YFQGWdsSwn9Nl+095/LMavAIIZf3h6j+ph6B3ohN14Z2GInwHumdLn+2Lg96zVsprWOMut9OsM4FJaxlS59Pj8gvdy2lzMB+X/z0W80kbEHt9Zg8RIM44McpVcL+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bx1n1yq5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bx1n1yq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15477C433C7;
	Tue, 20 Feb 2024 02:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708394963;
	bh=8Lc3Y8W1EalzOz8xsTnknOWescTtpTU93d6RHZljiHU=;
	h=Date:To:From:Subject:From;
	b=Bx1n1yq5kmBTr736aC5mGmlwpB31E9IerVxE3+fxdTxj9QNojCLlc1zUrQ/Q5Kt2c
	 hxuW3UGYxYo3ejcN0DUCBs1KX1Bt1bWbx1FRqcAv15lwL05qmwDD/ga87evwUtk1tC
	 B7Vx4YP+v7XFbl72UwKSY4fmpUZ59C11JeS1KMMA=
Date: Mon, 19 Feb 2024 18:09:22 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,sj@kernel.org,minchan@kernel.org,mhocko@suse.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,21cnbao@gmail.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-race-when-skipping-swapcache-v4.patch added to mm-hotfixes-unstable branch
Message-Id: <20240220020923.15477C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swap-fix-race-when-skipping-swapcache-v4
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap-fix-race-when-skipping-swapcache-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-fix-race-when-skipping-swapcache-v4.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
mm-swap-fix-race-when-skipping-swapcache-v4.patch


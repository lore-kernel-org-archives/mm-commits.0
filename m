Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4FC5ECAAA1
	for <mm-commits@archiver.kernel.org>; Fri, 16 Sep 2022 21:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiIPV4y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Sep 2022 17:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiIPV4w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2022 17:56:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274B7BB6B4
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 14:56:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4143B82690
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 21:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A40C433C1;
        Fri, 16 Sep 2022 21:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663365408;
        bh=b1w3Kbj3nQk+zomBIOfS5bNEQdsxiT5M3OTGLZGBuAg=;
        h=Date:To:From:Subject:From;
        b=e79o2UmdTEssXSA3aVnB6DZjvICWkTMKJxC2e22Pe2YYrIG/gR+zqmvQbIBu3eAGz
         nn0I0bqHp5JlRgFuDDmBE+6nNo1/euBP7JRQ1O4xVit3saMbSAAOp7Dj3gypzE6mSi
         MZUfyjrRrtxGEv7d3O9hXTT04ixg4pAaZyTp+B6k=
Date:   Fri, 16 Sep 2022 14:56:47 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, peterx@redhat.com, mhocko@suse.com,
        linmiaohe@huawei.com, joao.m.martins@oracle.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages.patch added to mm-unstable branch
Message-Id: <20220916215648.35A40C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: freeze allocated pages before creating hugetlb pages
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages.patch

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
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: freeze allocated pages before creating hugetlb pages
Date: Fri, 16 Sep 2022 14:46:38 -0700

When creating hugetlb pages, the hugetlb code must first allocate
contiguous pages from a low level allocator such as buddy, cma or
memblock.  The pages returned from these low level allocators are ref
counted.  This creates potential issues with other code taking speculative
references on these pages before they can be transformed to a hugetlb
page.  This issue has been addressed with methods and code such as that
provided in [1].

Recent discussions about vmemmap freeing [2] have indicated that it would
be beneficial to freeze all sub pages, including the head page of pages
returned from low level allocators before converting to a hugetlb page. 
This helps avoid races if we want to replace the page containing vmemmap
for the head page.

There have been proposals to change at least the buddy allocator to return
frozen pages as described at [3].  If such a change is made, it can be
employed by the hugetlb code.  However, as mentioned above hugetlb uses
several low level allocators so each would need to be modified to return
frozen pages.  For now, we can manually freeze the returned pages.  This
is done in two places:

1) alloc_buddy_huge_page, only the returned head page is ref counted. 
   We freeze the head page, retrying once in the VERY rare case where
   there may be an inflated ref count.

2) prep_compound_gigantic_page, for gigantic pages the current code
   freezes all pages except the head page.  New code will simply freeze
   the head page as well.

In a few other places, code checks for inflated ref counts on newly
allocated hugetlb pages.  With the modifications to freeze after
allocating, this code can be removed.

After hugetlb pages are freshly allocated, they are often added to the
hugetlb free lists.  Since these pages were previously ref counted, this
was done via put_page() which would end up calling the hugetlb destructor:
free_huge_page.  With changes to freeze pages, we simply call
free_huge_page directly to add the pages to the free list.

In a few other places, freshly allocated hugetlb pages were immediately
put into use, and the expectation was they were already ref counted.  In
these cases, we must manually ref count the page.

[1] https://lore.kernel.org/linux-mm/20210622021423.154662-3-mike.kravetz@oracle.com/
[2] https://lore.kernel.org/linux-mm/20220802180309.19340-1-joao.m.martins@oracle.com/
[3] https://lore.kernel.org/linux-mm/20220809171854.3725722-1-willy@infradead.org/

Link: https://lkml.kernel.org/r/20220916214638.155744-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |  102 ++++++++++++++++++-------------------------------
 1 file changed, 38 insertions(+), 64 deletions(-)

--- a/mm/hugetlb.c~hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages
+++ a/mm/hugetlb.c
@@ -1787,9 +1787,8 @@ static bool __prep_compound_gigantic_pag
 
 	/* we rely on prep_new_huge_page to set the destructor */
 	set_compound_order(page, order);
-	__ClearPageReserved(page);
 	__SetPageHead(page);
-	for (i = 1; i < nr_pages; i++) {
+	for (i = 0; i < nr_pages; i++) {
 		p = nth_page(page, i);
 
 		/*
@@ -1830,17 +1829,19 @@ static bool __prep_compound_gigantic_pag
 		} else {
 			VM_BUG_ON_PAGE(page_count(p), p);
 		}
-		set_compound_head(p, page);
+		if (i != 0)
+			set_compound_head(p, page);
 	}
 	atomic_set(compound_mapcount_ptr(page), -1);
 	atomic_set(compound_pincount_ptr(page), 0);
 	return true;
 
 out_error:
-	/* undo tail page modifications made above */
-	for (j = 1; j < i; j++) {
+	/* undo page modifications made above */
+	for (j = 0; j < i; j++) {
 		p = nth_page(page, j);
-		clear_compound_head(p);
+		if (j != 0)
+			clear_compound_head(p);
 		set_page_refcounted(p);
 	}
 	/* need to clear PG_reserved on remaining tail pages  */
@@ -1936,6 +1937,7 @@ static struct page *alloc_buddy_huge_pag
 	int order = huge_page_order(h);
 	struct page *page;
 	bool alloc_try_hard = true;
+	bool retry = true;
 
 	/*
 	 * By default we always try hard to allocate the page with
@@ -1951,7 +1953,21 @@ static struct page *alloc_buddy_huge_pag
 		gfp_mask |= __GFP_RETRY_MAYFAIL;
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
+retry:
 	page = __alloc_pages(gfp_mask, order, nid, nmask);
+
+	/* Freeze head page */
+	if (!page_ref_freeze(page, 1)) {
+		__free_pages(page, order);
+		if (retry) {	/* retry once */
+			retry = false;
+			goto retry;
+		}
+		/* WOW!  twice in a row. */
+		pr_warn("HugeTLB head page unexpected inflated ref count\n");
+		page = NULL;
+	}
+
 	if (page)
 		__count_vm_event(HTLB_BUDDY_PGALLOC);
 	else
@@ -1979,6 +1995,9 @@ static struct page *alloc_buddy_huge_pag
 /*
  * Common helper to allocate a fresh hugetlb page. All specific allocators
  * should use this function to get new hugetlb pages
+ *
+ * Note that returned page is 'frozen':  ref count of head page and all tail
+ * pages is zero.
  */
 static struct page *alloc_fresh_huge_page(struct hstate *h,
 		gfp_t gfp_mask, int nid, nodemask_t *nmask,
@@ -2036,7 +2055,7 @@ static int alloc_pool_huge_page(struct h
 	if (!page)
 		return 0;
 
-	put_page(page); /* free it into the hugepage allocator */
+	free_huge_page(page); /* free it into the hugepage allocator */
 
 	return 1;
 }
@@ -2193,10 +2212,9 @@ int dissolve_free_huge_pages(unsigned lo
  * Allocates a fresh surplus page from the page allocator.
  */
 static struct page *alloc_surplus_huge_page(struct hstate *h, gfp_t gfp_mask,
-		int nid, nodemask_t *nmask, bool zero_ref)
+						int nid, nodemask_t *nmask)
 {
 	struct page *page = NULL;
-	bool retry = false;
 
 	if (hstate_is_gigantic(h))
 		return NULL;
@@ -2206,7 +2224,6 @@ static struct page *alloc_surplus_huge_p
 		goto out_unlock;
 	spin_unlock_irq(&hugetlb_lock);
 
-retry:
 	page = alloc_fresh_huge_page(h, gfp_mask, nid, nmask, NULL);
 	if (!page)
 		return NULL;
@@ -2222,34 +2239,10 @@ retry:
 	if (h->surplus_huge_pages >= h->nr_overcommit_huge_pages) {
 		SetHPageTemporary(page);
 		spin_unlock_irq(&hugetlb_lock);
-		put_page(page);
+		free_huge_page(page);
 		return NULL;
 	}
 
-	if (zero_ref) {
-		/*
-		 * Caller requires a page with zero ref count.
-		 * We will drop ref count here.  If someone else is holding
-		 * a ref, the page will be freed when they drop it.  Abuse
-		 * temporary page flag to accomplish this.
-		 */
-		SetHPageTemporary(page);
-		if (!put_page_testzero(page)) {
-			/*
-			 * Unexpected inflated ref count on freshly allocated
-			 * huge.  Retry once.
-			 */
-			pr_info("HugeTLB unexpected inflated ref count on freshly allocated page\n");
-			spin_unlock_irq(&hugetlb_lock);
-			if (retry)
-				return NULL;
-
-			retry = true;
-			goto retry;
-		}
-		ClearHPageTemporary(page);
-	}
-
 	h->surplus_huge_pages++;
 	h->surplus_huge_pages_node[page_to_nid(page)]++;
 
@@ -2271,6 +2264,9 @@ static struct page *alloc_migrate_huge_p
 	if (!page)
 		return NULL;
 
+	/* fresh huge pages are frozen */
+	set_page_refcounted(page);
+
 	/*
 	 * We do not account these pages as surplus because they are only
 	 * temporary and will be released properly on the last reference
@@ -2298,14 +2294,14 @@ struct page *alloc_buddy_huge_page_with_
 		gfp_t gfp = gfp_mask | __GFP_NOWARN;
 
 		gfp &=  ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
-		page = alloc_surplus_huge_page(h, gfp, nid, nodemask, false);
+		page = alloc_surplus_huge_page(h, gfp, nid, nodemask);
 
 		/* Fallback to all nodes if page==NULL */
 		nodemask = NULL;
 	}
 
 	if (!page)
-		page = alloc_surplus_huge_page(h, gfp_mask, nid, nodemask, false);
+		page = alloc_surplus_huge_page(h, gfp_mask, nid, nodemask);
 	mpol_cond_put(mpol);
 	return page;
 }
@@ -2375,7 +2371,7 @@ retry:
 	spin_unlock_irq(&hugetlb_lock);
 	for (i = 0; i < needed; i++) {
 		page = alloc_surplus_huge_page(h, htlb_alloc_mask(h),
-				NUMA_NO_NODE, NULL, true);
+				NUMA_NO_NODE, NULL);
 		if (!page) {
 			alloc_ok = false;
 			break;
@@ -2737,7 +2733,6 @@ static int alloc_and_dissolve_huge_page(
 {
 	gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 	int nid = page_to_nid(old_page);
-	bool alloc_retry = false;
 	struct page *new_page;
 	int ret = 0;
 
@@ -2748,30 +2743,9 @@ static int alloc_and_dissolve_huge_page(
 	 * the pool.  This simplifies and let us do most of the processing
 	 * under the lock.
 	 */
-alloc_retry:
 	new_page = alloc_buddy_huge_page(h, gfp_mask, nid, NULL, NULL);
 	if (!new_page)
 		return -ENOMEM;
-	/*
-	 * If all goes well, this page will be directly added to the free
-	 * list in the pool.  For this the ref count needs to be zero.
-	 * Attempt to drop now, and retry once if needed.  It is VERY
-	 * unlikely there is another ref on the page.
-	 *
-	 * If someone else has a reference to the page, it will be freed
-	 * when they drop their ref.  Abuse temporary page flag to accomplish
-	 * this.  Retry once if there is an inflated ref count.
-	 */
-	SetHPageTemporary(new_page);
-	if (!put_page_testzero(new_page)) {
-		if (alloc_retry)
-			return -EBUSY;
-
-		alloc_retry = true;
-		goto alloc_retry;
-	}
-	ClearHPageTemporary(new_page);
-
 	__prep_new_huge_page(h, new_page);
 
 retry:
@@ -2951,6 +2925,7 @@ struct page *alloc_huge_page(struct vm_a
 		}
 		spin_lock_irq(&hugetlb_lock);
 		list_add(&page->lru, &h->hugepage_activelist);
+		set_page_refcounted(page);
 		/* Fall through */
 	}
 	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page);
@@ -3055,7 +3030,7 @@ static void __init gather_bootmem_preall
 		if (prep_compound_gigantic_page(page, huge_page_order(h))) {
 			WARN_ON(PageReserved(page));
 			prep_new_huge_page(h, page, page_to_nid(page));
-			put_page(page); /* add to the hugepage allocator */
+			free_huge_page(page); /* add to the hugepage allocator */
 		} else {
 			/* VERY unlikely inflated ref count on a tail page */
 			free_gigantic_page(page, huge_page_order(h));
@@ -3087,7 +3062,7 @@ static void __init hugetlb_hstate_alloc_
 					&node_states[N_MEMORY], NULL);
 			if (!page)
 				break;
-			put_page(page); /* free it into the hugepage allocator */
+			free_huge_page(page); /* free it into the hugepage allocator */
 		}
 		cond_resched();
 	}
@@ -3478,9 +3453,8 @@ static int demote_free_huge_page(struct
 		else
 			prep_compound_page(subpage, target_hstate->order);
 		set_page_private(subpage, 0);
-		set_page_refcounted(subpage);
 		prep_new_huge_page(target_hstate, subpage, nid);
-		put_page(subpage);
+		free_huge_page(subpage);
 	}
 	mutex_unlock(&target_hstate->resize_lock);
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlbfs-revert-use-i_mmap_rwsem-to-address-page-fault-truncate-race.patch
hugetlbfs-revert-use-i_mmap_rwsem-for-more-pmd-sharing-synchronization.patch
hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache.patch
hugetlb-create-remove_inode_single_folio-to-remove-single-file-folio.patch
hugetlb-rename-vma_shareable-and-refactor-code.patch
hugetlb-add-vma-based-lock-for-pmd-sharing.patch
hugetlb-add-vma-based-lock-for-pmd-sharing-fix.patch
hugetlb-create-hugetlb_unmap_file_folio-to-unmap-single-file-folio.patch
hugetlb-use-new-vma_lock-for-pmd-sharing-synchronization.patch
hugetlb-clean-up-code-checking-for-fault-truncation-races.patch
hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages.patch


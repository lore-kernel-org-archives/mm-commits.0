Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70FBEC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357244AbiCYBQA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357218AbiCYBPS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:15:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302D76AA76
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:13:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF7AD618CD
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16096C340EE;
        Fri, 25 Mar 2022 01:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170821;
        bh=mMrsxC879YTtVqjXQLPWUCdFOjPmdNVKwsa7pvDgE0A=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=FfHRtfvpeQWydNzNxJZV65CDffInUzK/LFcU2UaK0YCWav18N7oat8uTj9mk9YS/T
         PoC8cg9ezXXQZplS3ce1lFxZc36Ekwkyg1xyuy3IBSc4+FIoM9Et2w0lZod9rQc1B7
         eoAy8fW/VRrBvJlAPjTPL+75l1/yESkeUcNTxtmk=
Date:   Thu, 24 Mar 2022 18:13:40 -0700
To:     zhangliang5@huawei.com, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, shakeelb@google.com, rppt@linux.ibm.com,
        roman.gushchin@linux.dev, rientjes@google.com, riel@surriel.com,
        peterx@redhat.com, oleg@redhat.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, mhocko@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        jgg@nvidia.com, jannh@google.com, jack@suse.cz, hughd@google.com,
        hch@lst.de, ddutile@redhat.com, aarcange@redhat.com,
        david@redhat.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 102/114] mm: streamline COW logic in do_swap_page()
Message-Id: <20220325011341.16096C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm: streamline COW logic in do_swap_page()

Currently we have a different COW logic when:
* triggering a read-fault to swapin first and then trigger a write-fault
  -> do_swap_page() + do_wp_page()
* triggering a write-fault to swapin
  -> do_swap_page() + do_wp_page() only if we fail reuse in do_swap_page()

The COW logic in do_swap_page() is different than our reuse logic in
do_wp_page().  The COW logic in do_wp_page() -- page_count() == 1 -- makes
currently sure that we certainly don't have a remaining reference, e.g.,
via GUP, on the target page we want to reuse: if there is any unexpected
reference, we have to copy to avoid information leaks.

As do_swap_page() behaves differently, in environments with swap enabled
we can currently have an unintended information leak from the parent to
the child, similar as known from CVE-2020-29374:

	1. Parent writes to anonymous page
	-> Page is mapped writable and modified
	2. Page is swapped out
	-> Page is unmapped and replaced by swap entry
	3. fork()
	-> Swap entries are copied to child
	4. Child pins page R/O
	-> Page is mapped R/O into child
	5. Child unmaps page
	-> Child still holds GUP reference
	6. Parent writes to page
	-> Page is reused in do_swap_page()
	-> Child can observe changes

Exchanging 2. and 3. should have the same effect.

Let's apply the same COW logic as in do_wp_page(), conditionally trying to
remove the page from the swapcache after freeing the swap entry, however,
before actually mapping our page.  We can change the order now that we use
try_to_free_swap(), which doesn't care about the mapcount, instead of
reuse_swap_page().

To handle references from the LRU pagevecs, conditionally drain the local
LRU pagevecs when required, however, don't consider the page_count() when
deciding whether to drain to keep it simple for now.

Link: https://lkml.kernel.org/r/20220131162940.210846-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Liang Zhang <zhangliang5@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   55 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 43 insertions(+), 12 deletions(-)

--- a/mm/memory.c~mm-streamline-cow-logic-in-do_swap_page
+++ a/mm/memory.c
@@ -3489,6 +3489,25 @@ static vm_fault_t remove_device_exclusiv
 	return 0;
 }
 
+static inline bool should_try_to_free_swap(struct page *page,
+					   struct vm_area_struct *vma,
+					   unsigned int fault_flags)
+{
+	if (!PageSwapCache(page))
+		return false;
+	if (mem_cgroup_swap_full(page) || (vma->vm_flags & VM_LOCKED) ||
+	    PageMlocked(page))
+		return true;
+	/*
+	 * If we want to map a page that's in the swapcache writable, we
+	 * have to detect via the refcount if we're really the exclusive
+	 * user. Try freeing the swapcache to get rid of the swapcache
+	 * reference only in case it's likely that we'll be the exlusive user.
+	 */
+	return (fault_flags & FAULT_FLAG_WRITE) && !PageKsm(page) &&
+		page_count(page) == 2;
+}
+
 /*
  * We enter with non-exclusive mmap_lock (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
@@ -3630,6 +3649,16 @@ vm_fault_t do_swap_page(struct vm_fault
 			page = swapcache;
 			goto out_page;
 		}
+
+		/*
+		 * If we want to map a page that's in the swapcache writable, we
+		 * have to detect via the refcount if we're really the exclusive
+		 * owner. Try removing the extra reference from the local LRU
+		 * pagevecs if required.
+		 */
+		if ((vmf->flags & FAULT_FLAG_WRITE) && page == swapcache &&
+		    !PageKsm(page) && !PageLRU(page))
+			lru_add_drain();
 	}
 
 	cgroup_throttle_swaprate(page, GFP_KERNEL);
@@ -3648,19 +3677,25 @@ vm_fault_t do_swap_page(struct vm_fault
 	}
 
 	/*
-	 * The page isn't present yet, go ahead with the fault.
-	 *
-	 * Be careful about the sequence of operations here.
-	 * To get its accounting right, reuse_swap_page() must be called
-	 * while the page is counted on swap but not yet in mapcount i.e.
-	 * before page_add_anon_rmap() and swap_free(); try_to_free_swap()
-	 * must be called after the swap_free(), or it will never succeed.
+	 * Remove the swap entry and conditionally try to free up the swapcache.
+	 * We're already holding a reference on the page but haven't mapped it
+	 * yet.
 	 */
+	swap_free(entry);
+	if (should_try_to_free_swap(page, vma, vmf->flags))
+		try_to_free_swap(page);
 
 	inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
 	dec_mm_counter_fast(vma->vm_mm, MM_SWAPENTS);
 	pte = mk_pte(page, vma->vm_page_prot);
-	if ((vmf->flags & FAULT_FLAG_WRITE) && reuse_swap_page(page)) {
+
+	/*
+	 * Same logic as in do_wp_page(); however, optimize for fresh pages
+	 * that are certainly not shared because we just allocated them without
+	 * exposing them to the swapcache.
+	 */
+	if ((vmf->flags & FAULT_FLAG_WRITE) && !PageKsm(page) &&
+	    (page != swapcache || page_count(page) == 1)) {
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
 		vmf->flags &= ~FAULT_FLAG_WRITE;
 		ret |= VM_FAULT_WRITE;
@@ -3686,10 +3721,6 @@ vm_fault_t do_swap_page(struct vm_fault
 	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
 	arch_do_swap_page(vma->vm_mm, vma, vmf->address, pte, vmf->orig_pte);
 
-	swap_free(entry);
-	if (mem_cgroup_swap_full(page) ||
-	    (vma->vm_flags & VM_LOCKED) || PageMlocked(page))
-		try_to_free_swap(page);
 	unlock_page(page);
 	if (page != swapcache && swapcache) {
 		/*
_

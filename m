Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC78CC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355658AbiCYBQD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357212AbiCYBP7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:15:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2146BDF1
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:13:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3EF361857
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C16C340F1;
        Fri, 25 Mar 2022 01:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170824;
        bh=uoCr6V0TVVbZ0uHrHskWFi27gYIYn3ASCtRu/xgQZj8=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=G3D9pqiGTFLTI86KJJwPJyEQob1AERqiNwPMpVr+MtUJANHrEh399axcYpYWLagGB
         Yl+A4h1Ufz9Hn35ADcun/vjJ3d+4I+iwylYN3lmAGKgZY+DeQuKT8j2zaWS9bP/hit
         3l8366bhjtLFD/USV/Ri0mUdiP1b4i+2Bnme7CoA=
Date:   Thu, 24 Mar 2022 18:13:43 -0700
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
Subject: [patch 103/114] mm/huge_memory: streamline COW logic in do_huge_pmd_wp_page()
Message-Id: <20220325011344.52C16C340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: streamline COW logic in do_huge_pmd_wp_page()

We currently have a different COW logic for anon THP than we have for
ordinary anon pages in do_wp_page(): the effect is that the issue reported
in CVE-2020-29374 is currently still possible for anon THP: an unintended
information leak from the parent to the child.

Let's apply the same logic (page_count() == 1), with similar optimizations
to remove additional references first as we really want to avoid
PTE-mapping the THP and copying individual pages best we can.

If we end up with a page that has page_count() != 1, we'll have to PTE-map
the THP and fallback to do_wp_page(), which will always copy the page.

Note that KSM does not apply to THP.

I. Interaction with the swapcache and writeback

While a THP is in the swapcache, the swapcache holds one reference on each
subpage of the THP.  So with PageSwapCache() set, we expect as many
additional references as we have subpages.  If we manage to remove the THP
from the swapcache, all these references will be gone.

Usually, a THP is not split when entered into the swapcache and stays a
compound page.  However, try_to_unmap() will PTE-map the THP and use PTE
swap entries.  There are no PMD swap entries for that purpose,
consequently, we always only swapin subpages into PTEs.

Removing a page from the swapcache can fail either when there are
remaining swap entries (in which case COW is the right thing to do) or if
the page is currently under writeback.

Having a locked, R/O PMD-mapped THP that is in the swapcache seems to be
possible only in corner cases, for example, if try_to_unmap() failed after
adding the page to the swapcache.  However, it's comparatively easy to
handle.

As we have to fully unmap a THP before starting writeback, and swapin is
always done on the PTE level, we shouldn't find a R/O PMD-mapped THP in
the swapcache that is under writeback.  This should at least leave
writeback out of the picture.

II. Interaction with GUP references

Having a R/O PMD-mapped THP with GUP references (i.e., R/O references)
will result in PTE-mapping the THP on a write fault.  Similar to ordinary
anon pages, do_wp_page() will have to copy sub-pages and result in a
disconnect between the GUP references and the pages actually mapped into
the page tables.  To improve the situation in the future, we'll need
additional handling to mark anonymous pages as definitely exclusive to a
single process, only allow GUP pins on exclusive anon pages, and disallow
sharing of exclusive anon pages with GUP pins e.g., during fork().

III. Interaction with references from LRU pagevecs

There is no need to try draining the (local) LRU pagevecs in case we would
stumble over a !PageLRU() page: folio_add_lru() and friends will always
flush the affected pagevec after adding a compound page to it immediately
-- pagevec_add_and_need_flush() always returns "true" for them.  Note that
the LRU pagevecs will hold a reference on the compound page for a very
short time, between adding the page to the pagevec and draining it
immediately afterwards.

IV. Interaction with speculative/temporary references

Similar to ordinary anon pages, other speculative/temporary references on
the THP, for example, from the pagecache or page migration code, will
disallow exclusive reuse of the page.  We'll have to PTE-map the THP.

Link: https://lkml.kernel.org/r/20220131162940.210846-6-david@redhat.com
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

 mm/huge_memory.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-streamline-cow-logic-in-do_huge_pmd_wp_page
+++ a/mm/huge_memory.c
@@ -1303,7 +1303,6 @@ vm_fault_t do_huge_pmd_wp_page(struct vm
 	page = pmd_page(orig_pmd);
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 
-	/* Lock page for reuse_swap_page() */
 	if (!trylock_page(page)) {
 		get_page(page);
 		spin_unlock(vmf->ptl);
@@ -1319,10 +1318,15 @@ vm_fault_t do_huge_pmd_wp_page(struct vm
 	}
 
 	/*
-	 * We can only reuse the page if nobody else maps the huge page or it's
-	 * part.
+	 * See do_wp_page(): we can only map the page writable if there are
+	 * no additional references. Note that we always drain the LRU
+	 * pagevecs immediately after adding a THP.
 	 */
-	if (reuse_swap_page(page)) {
+	if (page_count(page) > 1 + PageSwapCache(page) * thp_nr_pages(page))
+		goto unlock_fallback;
+	if (PageSwapCache(page))
+		try_to_free_swap(page);
+	if (page_count(page) == 1) {
 		pmd_t entry;
 		entry = pmd_mkyoung(orig_pmd);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
@@ -1333,6 +1337,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm
 		return VM_FAULT_WRITE;
 	}
 
+unlock_fallback:
 	unlock_page(page);
 	spin_unlock(vmf->ptl);
 fallback:
_

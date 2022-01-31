Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB223C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 19:43:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377367AbiAaTnu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 14:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377539AbiAaTnr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 14:43:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FFAC061744
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 11:43:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E519E6145B
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 19:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F3BC340ED;
        Mon, 31 Jan 2022 19:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643658224;
        bh=d7Y17lD4RyTPWQI5ZjV/NWnbUr6dndx9PCGBjwyBgeY=;
        h=Date:From:To:Subject:From;
        b=pyXb6ZQLj/bwI/PcegGUvofrjLEFtRsuTMoNTVRf0fKUeMAdNNBCdtYCTDuznZcDI
         JxNFO7dG44DFIGOeQKVoclBkbiYxEIkiBuhT4oR9tgTJqfha/UpfcDf7gJGCoG7u57
         HOwZnb4F/TR0rgQdct3elOTw1onCV4merY0FZ1zY=
Date:   Mon, 31 Jan 2022 11:43:42 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, david@redhat.com, ddutile@redhat.com,
        guro@fb.com, hch@lst.de, hughd@google.com, jack@suse.cz,
        jannh@google.com, jgg@nvidia.com, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        nadav.amit@gmail.com, oleg@redhat.com, peterx@redhat.com,
        riel@surriel.com, rientjes@google.com, rppt@linux.ibm.com,
        shakeelb@google.com, shy828301@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org,
        zhangliang5@huawei.com
Subject:  +
 mm-huge_memory-streamline-cow-logic-in-do_huge_pmd_wp_page.patch added to
 -mm tree
Message-ID: <20220131194342.PhWzJF_HS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: streamline COW logic in do_huge_pmd_wp_page()
has been added to the -mm tree.  Its filename is
     mm-huge_memory-streamline-cow-logic-in-do_huge_pmd_wp_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memory-streamline-cow-logic-in-do_huge_pmd_wp_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memory-streamline-cow-logic-in-do_huge_pmd_wp_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

Patches currently in -mm which might be from david@redhat.com are

mm-optimize-do_wp_page-for-exclusive-pages-in-the-swapcache.patch
mm-optimize-do_wp_page-for-fresh-pages-in-local-lru-pagevecs.patch
mm-slightly-clarify-ksm-logic-in-do_swap_page.patch
mm-streamline-cow-logic-in-do_swap_page.patch
mm-huge_memory-streamline-cow-logic-in-do_huge_pmd_wp_page.patch
mm-khugepaged-remove-reuse_swap_page-usage.patch
mm-swapfile-remove-stale-reuse_swap_page.patch
mm-huge_memory-remove-stale-page_trans_huge_mapcount.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd.patch
proc-vmcore-fix-possible-deadlock-on-concurrent-mmap-and-read.patch


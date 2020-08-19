Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF85C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAD192078B
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597809055;
	bh=tPVEsWYE/oGKT4h8PhsxBMvEfRlyRQLihL/LccB8RY8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=HfHAXAKh86boOmFcCb2GFkIyq5zB8Zz6sO8AKBwQdVzce974cNscj7oDki3dQswSz
	 Bhee8SR3ONDd70AeRG5NTs9xsAoHesoqR2iemMf/sjeLitspXRVmLHEmOnZ4UUh13C
	 D1X/78tHoSbR9U8kI1SXIQpzkq6T4bBm5xLCluTA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgHSDuy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 23:50:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbgHSDuy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 23:50:54 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05A0F207BB;
        Wed, 19 Aug 2020 03:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597809053;
        bh=tPVEsWYE/oGKT4h8PhsxBMvEfRlyRQLihL/LccB8RY8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=P2JOdFQCzok95/C3oeKakTbBlRqPyiTkPiyoVpy361xA8BAQjxcKHxX31NbiK7Rm9
         +AS18PzfarX7DQGFjSpRCpUPeKxiACbsf92cyf7O+MUDGzqD7iBwooRMyq+s9tMGWe
         p9my+QRb/Bm22hEPIv8Nfd5kdXO5V1BKk/WikAZI=
Date:   Tue, 18 Aug 2020 20:50:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, alex.shi@linux.alibaba.com, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, mhocko@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, vdavydov.dev@gmail.com,
        willy@infradead.org
Subject:  + mm-thp-narrow-lru-locking.patch added to -mm tree
Message-ID: <20200819035052.vE0CvFmqd%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: narrow lru locking
has been added to the -mm tree.  Its filename is
     mm-thp-narrow-lru-locking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-narrow-lru-locking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-narrow-lru-locking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/thp: narrow lru locking

lru_lock and page cache xa_lock have no reason with current sequence, put
them together isn't necessary.  let's narrow the lru locking, but left the
local_irq_disable to block interrupt re-entry and statistic update.

Hugh Dickins point: split_huge_page_to_list() was already silly,to be
using the _irqsave variant: it's just been taking sleeping locks, so would
already be broken if entered with interrupts enabled.  so we can save
passing flags argument down to __split_huge_page().

Link: http://lkml.kernel.org/r/1597144232-11370-6-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/mm/huge_memory.c~mm-thp-narrow-lru-locking
+++ a/mm/huge_memory.c
@@ -2397,7 +2397,7 @@ static void __split_huge_page_tail(struc
 }
 
 static void __split_huge_page(struct page *page, struct list_head *list,
-		pgoff_t end, unsigned long flags)
+			      pgoff_t end)
 {
 	struct page *head = compound_head(page);
 	pg_data_t *pgdat = page_pgdat(head);
@@ -2406,8 +2406,6 @@ static void __split_huge_page(struct pag
 	unsigned long offset = 0;
 	int i;
 
-	lruvec = mem_cgroup_page_lruvec(head, pgdat);
-
 	/* complete memcg works before add pages to LRU */
 	mem_cgroup_split_huge_fixup(head);
 
@@ -2419,6 +2417,11 @@ static void __split_huge_page(struct pag
 		xa_lock(&swap_cache->i_pages);
 	}
 
+	/* prevent PageLRU to go away from under us, and freeze lru stats */
+	spin_lock(&pgdat->lru_lock);
+
+	lruvec = mem_cgroup_page_lruvec(head, pgdat);
+
 	for (i = HPAGE_PMD_NR - 1; i >= 1; i--) {
 		__split_huge_page_tail(head, i, lruvec, list);
 		/* Some pages can be beyond i_size: drop them from page cache */
@@ -2438,6 +2441,8 @@ static void __split_huge_page(struct pag
 	}
 
 	ClearPageCompound(head);
+	spin_unlock(&pgdat->lru_lock);
+	/* Caller disabled irqs, so they are still disabled here */
 
 	split_page_owner(head, HPAGE_PMD_ORDER);
 
@@ -2455,8 +2460,7 @@ static void __split_huge_page(struct pag
 		page_ref_add(head, 2);
 		xa_unlock(&head->mapping->i_pages);
 	}
-
-	spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+	local_irq_enable();
 
 	remap_page(head);
 
@@ -2595,12 +2599,10 @@ bool can_split_huge_page(struct page *pa
 int split_huge_page_to_list(struct page *page, struct list_head *list)
 {
 	struct page *head = compound_head(page);
-	struct pglist_data *pgdata = NODE_DATA(page_to_nid(head));
 	struct deferred_split *ds_queue = get_deferred_split_queue(head);
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
 	int count, mapcount, extra_pins, ret;
-	unsigned long flags;
 	pgoff_t end;
 
 	VM_BUG_ON_PAGE(is_huge_zero_page(head), head);
@@ -2661,9 +2663,8 @@ int split_huge_page_to_list(struct page
 	unmap_page(head);
 	VM_BUG_ON_PAGE(compound_mapcount(head), head);
 
-	/* prevent PageLRU to go away from under us, and freeze lru stats */
-	spin_lock_irqsave(&pgdata->lru_lock, flags);
-
+	/* block interrupt reentry in xa_lock and spinlock */
+	local_irq_disable();
 	if (mapping) {
 		XA_STATE(xas, &mapping->i_pages, page_index(head));
 
@@ -2693,7 +2694,7 @@ int split_huge_page_to_list(struct page
 				__dec_node_page_state(head, NR_FILE_THPS);
 		}
 
-		__split_huge_page(page, list, end, flags);
+		__split_huge_page(page, list, end);
 		if (PageSwapCache(head)) {
 			swp_entry_t entry = { .val = page_private(head) };
 
@@ -2712,7 +2713,7 @@ int split_huge_page_to_list(struct page
 		spin_unlock(&ds_queue->split_queue_lock);
 fail:		if (mapping)
 			xa_unlock(&mapping->i_pages);
-		spin_unlock_irqrestore(&pgdata->lru_lock, flags);
+		local_irq_enable();
 		remap_page(head);
 		ret = -EBUSY;
 	}
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
mm-memcg-remove-useless-check-on-page-mem_cgroup.patch
mm-thp-move-lru_add_page_tail-func-to-huge_memoryc.patch
mm-thp-clean-up-lru_add_page_tail.patch
mm-thp-remove-code-path-which-never-got-into.patch
mm-thp-narrow-lru-locking.patch


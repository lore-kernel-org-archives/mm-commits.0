Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE84BC433E6
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 18:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF59F208DB
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 18:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598898595;
	bh=sQn3XVCc8ymtFDtNg+F8QW2sdMI7gjEIYyWAwU0AAdo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=2Nd8nV85QL+JHoFTuvS7SLKUjGdPbquIz26JPOa3aAp5nwEi4Ri8m197tmi3qEDUB
	 wFQO68mVXFo85ME/Pa/VuOQJhAAVXm7q4lMe+je2JEyD9UsSGhydZ4vbTve7VrZSwk
	 ygU41uyXUikINJ3vlXdo5Ccj/JJrFstu3pfdX6r8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgHaS3z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Aug 2020 14:29:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgHaS3y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 Aug 2020 14:29:54 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8F7D206E3;
        Mon, 31 Aug 2020 18:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598898594;
        bh=sQn3XVCc8ymtFDtNg+F8QW2sdMI7gjEIYyWAwU0AAdo=;
        h=Date:From:To:Subject:From;
        b=TH2eCYz8WU1uO4Rd0W5ezfZdcOpthD0OK5m4zGfECXmTjUNHOrBEsFYwf0C066NK8
         mIhl8iKmD/THLmoimP+GQB+AeCkZJUb6Fm5AVhU76Pp9wEXmbQQQcJurHBNJzTrXLi
         VmVr9lBW7XTp+IQo+PW6TGyzB6F0ljR/PHhq3qhM=
Date:   Mon, 31 Aug 2020 11:29:52 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, alex.shi@linux.alibaba.com,
        yuzhao@google.com
Subject:  + mm-use-add_page_to_lru_list-page_lru-page_off_lru.patch
 added to -mm tree
Message-ID: <20200831182952.g30mt%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use add_page_to_lru_list()/page_lru()/page_off_lru()
has been added to the -mm tree.  Its filename is
     mm-use-add_page_to_lru_list-page_lru-page_off_lru.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-add_page_to_lru_list-page_lru-page_off_lru.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-add_page_to_lru_list-page_lru-page_off_lru.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: use add_page_to_lru_list()/page_lru()/page_off_lru()

This is a trivial but worth having clean-up patch.  There should be no
side effects except page->lru is temporarily poisoned after it's deleted
but before it's added to the new list in move_pages_to_lru() (which is not
a problem).

Link: http://lkml.kernel.org/r/20200831175042.3527153-1-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c   |    4 +---
 mm/vmscan.c |   13 ++++---------
 2 files changed, 5 insertions(+), 12 deletions(-)

--- a/mm/swap.c~mm-use-add_page_to_lru_list-page_lru-page_off_lru
+++ a/mm/swap.c
@@ -598,11 +598,9 @@ static void lru_lazyfree_fn(struct page
 {
 	if (PageLRU(page) && PageAnon(page) && PageSwapBacked(page) &&
 	    !PageSwapCache(page) && !PageUnevictable(page)) {
-		bool active = PageActive(page);
 		int nr_pages = thp_nr_pages(page);
 
-		del_page_from_lru_list(page, lruvec,
-				       LRU_INACTIVE_ANON + active);
+		del_page_from_lru_list(page, lruvec, page_lru(page));
 		ClearPageActive(page);
 		ClearPageReferenced(page);
 		/*
--- a/mm/vmscan.c~mm-use-add_page_to_lru_list-page_lru-page_off_lru
+++ a/mm/vmscan.c
@@ -1845,13 +1845,12 @@ static unsigned noinline_for_stack move_
 	int nr_pages, nr_moved = 0;
 	LIST_HEAD(pages_to_free);
 	struct page *page;
-	enum lru_list lru;
 
 	while (!list_empty(list)) {
 		page = lru_to_page(list);
 		VM_BUG_ON_PAGE(PageLRU(page), page);
+		list_del(&page->lru);
 		if (unlikely(!page_evictable(page))) {
-			list_del(&page->lru);
 			spin_unlock_irq(&pgdat->lru_lock);
 			putback_lru_page(page);
 			spin_lock_irq(&pgdat->lru_lock);
@@ -1860,16 +1859,11 @@ static unsigned noinline_for_stack move_
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
 
 		SetPageLRU(page);
-		lru = page_lru(page);
-
-		nr_pages = thp_nr_pages(page);
-		update_lru_size(lruvec, lru, page_zonenum(page), nr_pages);
-		list_move(&page->lru, &lruvec->lists[lru]);
+		add_page_to_lru_list(page, lruvec, page_lru(page));
 
 		if (put_page_testzero(page)) {
 			__ClearPageLRU(page);
-			__ClearPageActive(page);
-			del_page_from_lru_list(page, lruvec, lru);
+			del_page_from_lru_list(page, lruvec, page_off_lru(page));
 
 			if (unlikely(PageCompound(page))) {
 				spin_unlock_irq(&pgdat->lru_lock);
@@ -1878,6 +1872,7 @@ static unsigned noinline_for_stack move_
 			} else
 				list_add(&page->lru, &pages_to_free);
 		} else {
+			nr_pages = thp_nr_pages(page);
 			nr_moved += nr_pages;
 			if (PageActive(page))
 				workingset_age_nonresident(lruvec, nr_pages);
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-remove-activate_page-from-unuse_pte.patch
mm-remove-superfluous-__clearpageactive.patch
mm-use-add_page_to_lru_list-page_lru-page_off_lru.patch
mm-use-self-explanatory-macros-rather-than-2.patch


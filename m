Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EBE8C433E0
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0844122D2C
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbhAXBW3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:22:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:46872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbhAXBW2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:22:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41C7322CB9;
        Sun, 24 Jan 2021 01:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611451307;
        bh=wNXRZkxKtItS2UlaPM1ScYqdYT2fm8xJ/gorR0+Pnio=;
        h=Date:From:To:Subject:From;
        b=cyNwFj8u88QGIz5eMdrQWDMeaY0bqnv6vQg6qQi+kaREgOqNlFjY/GVBcZh1SkF/R
         14FaPE35JE196yXvodt9ZUAuSznMNXxQuEgJHlt8BKFO2R3AifzAwEJHfo5FYrJqoE
         6SzvvpIpUJINlzCxHng6YjhEEtLkY/4Uo8kjVnSY=
Date:   Sat, 23 Jan 2021 17:21:46 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, guro@fb.com, hannes@cmpxchg.org,
        hughd@google.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com, willy@infradead.org,
        yuzhao@google.com
Subject:  + mm-use-add_page_to_lru_list.patch added to -mm tree
Message-ID: <20210124012146.Kn37xrGtY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: use add_page_to_lru_list()
has been added to the -mm tree.  Its filename is
     mm-use-add_page_to_lru_list.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-use-add_page_to_lru_list.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-use-add_page_to_lru_list.patch

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
Subject: mm/vmscan.c: use add_page_to_lru_list()

Patch series "mm: lru related cleanups", v2.

The cleanups are intended to reduce the verbosity in lru list operations
and make them less error-prone.  A typical example would be how the
patches change __activate_page():

 static void __activate_page(struct page *page, struct lruvec *lruvec)
 {
 	if (!PageActive(page) && !PageUnevictable(page)) {
-		int lru = page_lru_base_type(page);
 		int nr_pages = thp_nr_pages(page);
 
-		del_page_from_lru_list(page, lruvec, lru);
+		del_page_from_lru_list(page, lruvec);
 		SetPageActive(page);
-		lru += LRU_ACTIVE;
-		add_page_to_lru_list(page, lruvec, lru);
+		add_page_to_lru_list(page, lruvec);
 		trace_mm_lru_activate(page);

There are a few more places like __activate_page() and they are
unnecessarily repetitive in terms of figuring out which list a page should
be added onto or deleted from.  And with the duplicated code removed, they
are easier to read, IMO.

Patch 1 to 5 basically cover the above.  Patch 6 and 7 make code more
robust by improving bug reporting.  Patch 8, 9 and 10 take care of some
dangling helpers left in header files.


This patch (of 10):

There is add_page_to_lru_list(), and move_pages_to_lru() should reuse it,
not duplicate it.

Link: https://lkml.kernel.org/r/20210122220600.906146-1-yuzhao@google.com
Link: https://lore.kernel.org/linux-mm/20201207220949.830352-2-yuzhao@google.com/
Link: https://lkml.kernel.org/r/20210122220600.906146-2-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/vmscan.c~mm-use-add_page_to_lru_list
+++ a/mm/vmscan.c
@@ -1823,7 +1823,6 @@ static unsigned noinline_for_stack move_
 	int nr_pages, nr_moved = 0;
 	LIST_HEAD(pages_to_free);
 	struct page *page;
-	enum lru_list lru;
 
 	while (!list_empty(list)) {
 		page = lru_to_page(list);
@@ -1868,11 +1867,8 @@ static unsigned noinline_for_stack move_
 		 * inhibits memcg migration).
 		 */
 		VM_BUG_ON_PAGE(!lruvec_holds_page_lru_lock(page, lruvec), page);
-		lru = page_lru(page);
+		add_page_to_lru_list(page, lruvec, page_lru(page));
 		nr_pages = thp_nr_pages(page);
-
-		update_lru_size(lruvec, lru, page_zonenum(page), nr_pages);
-		list_add(&page->lru, &lruvec->lists[lru]);
 		nr_moved += nr_pages;
 		if (PageActive(page))
 			workingset_age_nonresident(lruvec, nr_pages);
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-swap-dont-setpageworkingset-unconditionally-during-swapin.patch
mm-use-add_page_to_lru_list.patch
mm-shuffle-lru-list-addition-and-deletion-functions.patch
mm-dont-pass-enum-lru_list-to-lru-list-addition-functions.patch
mm-dont-pass-enum-lru_list-to-trace_mm_lru_insertion.patch
mm-dont-pass-enum-lru_list-to-del_page_from_lru_list.patch
mm-add-__clear_page_lru_flags-to-replace-page_off_lru.patch
mm-vm_bug_on-lru-page-flags.patch
mm-fold-page_lru_base_type-into-its-sole-caller.patch
mm-fold-__update_lru_size-into-its-sole-caller.patch
mm-make-lruvec_lru_size-static.patch


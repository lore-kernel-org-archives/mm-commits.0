Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA57C433E1
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 23:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 670812074D
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 23:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598312180;
	bh=UPxWT3XT6CyCow28+RPWoUeUcSDSUgxotcn/iFa+JxQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=tXIyB+0Sd5tkaorj7Zr2XGwPijQQ2mauBNVe+T+O9inFI5FczZNyY3oN2nB6sYCax
	 RrH+tAa5GHEtPtXTzJ/zsgXwgbDM18madWBk+RLuXBS7iRD/qNe8nYdOOH+yceY3D6
	 0jUAclswtOhQsAEYyPVCgffnZf0C9QFEO/NQGjJw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbgHXXgU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 19:36:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgHXXgS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 19:36:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A47BC2078D;
        Mon, 24 Aug 2020 23:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598312178;
        bh=UPxWT3XT6CyCow28+RPWoUeUcSDSUgxotcn/iFa+JxQ=;
        h=Date:From:To:Subject:From;
        b=TMlmh+7lNVNyINCNEpKXhrPbWyU91KpoFAL20jRoB2RkOI4FtjL6IVP0FctodlRy6
         Z1gHEh1d82COttMjVktuWiGqRrGQz6lxabW7h/4JoXHOZmIfjpulZZlQIvoHysgJDN
         y2fx0pt48a27f2MWIwIygF2Lo+1Et6AoxbO5XVsU=
Date:   Mon, 24 Aug 2020 16:36:17 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, alex.shi@linux.alibaba.com, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, mhocko@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, sfr@canb.auug.org.au,
        vdavydov.dev@gmail.com, willy@infradead.org
Subject:  [to-be-updated] mm-thp-clean-up-lru_add_page_tail.patch
 removed from -mm tree
Message-ID: <20200824233617.WMEEq3vL2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: clean up lru_add_page_tail
has been removed from the -mm tree.  Its filename was
     mm-thp-clean-up-lru_add_page_tail.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/thp: clean up lru_add_page_tail

Since the first parameter is only used by head page, it's better to make
it explicit.

Link: http://lkml.kernel.org/r/1597144232-11370-4-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-thp-clean-up-lru_add_page_tail
+++ a/mm/huge_memory.c
@@ -2313,19 +2313,19 @@ static void remap_page(struct page *page
 	}
 }
 
-static void lru_add_page_tail(struct page *page, struct page *page_tail,
+static void lru_add_page_tail(struct page *head, struct page *page_tail,
 				struct lruvec *lruvec, struct list_head *list)
 {
-	VM_BUG_ON_PAGE(!PageHead(page), page);
-	VM_BUG_ON_PAGE(PageCompound(page_tail), page);
-	VM_BUG_ON_PAGE(PageLRU(page_tail), page);
+	VM_BUG_ON_PAGE(!PageHead(head), head);
+	VM_BUG_ON_PAGE(PageCompound(page_tail), head);
+	VM_BUG_ON_PAGE(PageLRU(page_tail), head);
 	lockdep_assert_held(&lruvec_pgdat(lruvec)->lru_lock);
 
 	if (!list)
 		SetPageLRU(page_tail);
 
-	if (likely(PageLRU(page)))
-		list_add_tail(&page_tail->lru, &page->lru);
+	if (likely(PageLRU(head)))
+		list_add_tail(&page_tail->lru, &head->lru);
 	else if (list) {
 		/* page reclaim is reclaiming a huge page */
 		get_page(page_tail);
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-thp-remove-code-path-which-never-got-into.patch
mm-thp-narrow-lru-locking.patch


Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DAAFC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DFE52078B
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597809049;
	bh=hyOejXuX451cHoMUNgJ7mZFlISgu+RxY6IPWEcd7P88=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=lOkJJjIOaWZaZJ3Rn+faAIQLszDJRRUWx5wF5SpXHdxJ6QMF7Nvukrj7g7kjwY46T
	 NrgylW/KueGVTKrq/ieRKUCCYYMPFgIxgZHJ+W+zTCKdIlNz+tUrMcONqYaJH6TE2f
	 uAz2Hrxl3RBLd8II1WGZDMh3LNFFaJqrqVjmXC3M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgHSDut (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 23:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbgHSDur (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 23:50:47 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE93D20829;
        Wed, 19 Aug 2020 03:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597809047;
        bh=hyOejXuX451cHoMUNgJ7mZFlISgu+RxY6IPWEcd7P88=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=s1B5IFmwJs0zc93Rck3z3c73SIAZ8eI/MA/pEF9LQrOPe5zajy9+T1JnDdh2hVGH7
         fw620NRR5S7DqFrj0PynPOmLlWEN6PB71vdmGpakBxuJH8IQhTSmb6i9LL8y8cc+ei
         KgPv9BGYY5f2o+s0NvAyA3s9UeafJDeVF6tLSkoM=
Date:   Tue, 18 Aug 2020 20:50:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, alex.shi@linux.alibaba.com, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, mhocko@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, vdavydov.dev@gmail.com,
        willy@infradead.org
Subject:  + mm-thp-clean-up-lru_add_page_tail.patch added to -mm
 tree
Message-ID: <20200819035046.QyqhAnhPC%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: clean up lru_add_page_tail
has been added to the -mm tree.  Its filename is
     mm-thp-clean-up-lru_add_page_tail.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-clean-up-lru_add_page_tail.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-clean-up-lru_add_page_tail.patch

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

mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
mm-memcg-remove-useless-check-on-page-mem_cgroup.patch
mm-thp-move-lru_add_page_tail-func-to-huge_memoryc.patch
mm-thp-clean-up-lru_add_page_tail.patch
mm-thp-remove-code-path-which-never-got-into.patch
mm-thp-narrow-lru-locking.patch


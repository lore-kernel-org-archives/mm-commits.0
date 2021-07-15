Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CAEEC636C9
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 21:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DFFD613DA
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 21:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhGOVxp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 17:53:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229597AbhGOVxo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 17:53:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62BBC613D2;
        Thu, 15 Jul 2021 21:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626385849;
        bh=k+0fuYjgclcUK/ggj3OnXzSqta5BnFL08aea/IaQ/ak=;
        h=Date:From:To:Subject:From;
        b=T9M6hYl/95ReAYaJSf1eEBp66zFg+j6aEyH5AaGmQBY7YUHq0JB562C9vPaD2DmVn
         rMa361n5l11RiK+XqVBiIT5PMDnvgTohVKzUY9b5lvvTReeR5ra3vkn7uGzCxoPyZK
         /B+7SwkAa82dpao7xVO+rsv8rT4QGkQvwoz8dKcA=
Date:   Thu, 15 Jul 2021 14:50:48 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, apopple@nvidia.com, axboe@kernel.dk,
        david@redhat.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com,
        iamjoonsoo.kim@lge.com, linmiaohe@huawei.com, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, shli@fb.com,
        vbabka@suse.cz, willy@infradead.org
Subject:  [withdrawn]
 mm-vmscan-fix-misleading-comment-in-isolate_lru_pages.patch removed from
 -mm tree
Message-ID: <20210715215048.G16-GyTDK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: fix misleading comment in isolate_lru_pages()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-misleading-comment-in-isolate_lru_pages.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmscan: fix misleading comment in isolate_lru_pages()

We couldn't know whether the page is being freed elsewhere until we failed
to increase the page count.

Link: https://lkml.kernel.org/r/20210710100329.49174-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shaohua Li <shli@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-fix-misleading-comment-in-isolate_lru_pages
+++ a/mm/vmscan.c
@@ -1891,7 +1891,6 @@ static unsigned long isolate_lru_pages(u
 		 */
 		scan += nr_pages;
 		if (!__isolate_lru_page_prepare(page, mode)) {
-			/* It is being freed elsewhere */
 			list_move(&page->lru, src);
 			continue;
 		}
@@ -1901,6 +1900,7 @@ static unsigned long isolate_lru_pages(u
 		 * page release code relies on it.
 		 */
 		if (unlikely(!get_page_unless_zero(page))) {
+			/* It is being freed elsewhere. */
 			list_move(&page->lru, src);
 			continue;
 		}
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmscan-put-the-redirtied-madv_free-pages-back-to-anonymous-lru-list.patch
mm-vmscan-remove-misleading-setting-to-sc-priority.patch
mm-vmscan-remove-unneeded-return-value-of-kswapd_run.patch
mm-vmscan-add-else-to-remove-check_pending-label.patch
mm-vmstat-correct-some-wrong-comments.patch
mm-vmstat-simplify-the-array-size-calculation.patch
mm-vmstat-remove-unneeded-return-value.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch


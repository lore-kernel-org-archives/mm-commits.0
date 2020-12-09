Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C216EC433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Dec 2020 22:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87B4C239D1
	for <mm-commits@archiver.kernel.org>; Wed,  9 Dec 2020 22:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387976AbgLIWzt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Dec 2020 17:55:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgLIWzs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 9 Dec 2020 17:55:48 -0500
Date:   Wed, 09 Dec 2020 14:55:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607554529;
        bh=ivqxATAe3n4ZSyxiXdK0quA4MYcPec9xTwocJ6w8F8Y=;
        h=From:To:Subject:From;
        b=Unw04x8ZeHtKMkb+cyoxqFFkDFYElx0cf/TjklQRQRRZMD42L1BWK8i2E3ezhgkK5
         UQof0dF1RNS0s6qvY8wgOpYg2YBr5+KfuZIriZEiKQ377KZHGhq7IqSFgdBH9Tx2Il
         Ddmn6rQIGne8Yde0LoCbwH1fmjsrBucWjdqAuDmE=
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, mm-commits@vger.kernel.org,
        zou_wei@huawei.com
Subject:  [withdrawn]
 mm-swapc-reduce-lock-contention-in-lru_cache_add-fix.patch removed from -mm
 tree
Message-ID: <20201209225528.uN1YNEKQZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap.c: mark sort_page_lruvec with static keyword
has been removed from the -mm tree.  Its filename was
     mm-swapc-reduce-lock-contention-in-lru_cache_add-fix.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Zou Wei <zou_wei@huawei.com>
Subject: mm/swap.c: mark sort_page_lruvec with static keyword

Fix the following sparse warning:

mm/swap.c:1018:5: warning: symbol 'sort_page_lruvec' was not declared. Should it be static?

Link: https://lkml.kernel.org/r/1606218425-3874-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap.c~mm-swapc-reduce-lock-contention-in-lru_cache_add-fix
+++ a/mm/swap.c
@@ -1015,7 +1015,7 @@ struct lruvecs {
 };
 
 /* Sort pvec pages on their lruvec */
-int sort_page_lruvec(struct lruvecs *lruvecs, struct pagevec *pvec)
+static int sort_page_lruvec(struct lruvecs *lruvecs, struct pagevec *pvec)
 {
 	int i, j, nr_lruvec;
 	struct page *page;
_

Patches currently in -mm which might be from zou_wei@huawei.com are

mm-page_alloc-mark-some-symbols-with-static-keyword.patch


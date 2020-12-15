Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE50BC2BBCD
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB97A22475
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgLODGt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:06:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:34636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgLODGj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:06:39 -0500
Date:   Mon, 14 Dec 2020 19:05:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001559;
        bh=2RAqT9POMCHt17O2bAUp5dOA00aXaz3AiePwHKcoX/o=;
        h=From:To:Subject:In-Reply-To:From;
        b=OpdSPscDQ8BRi26l7U+8wdauKcv5wFcrz0ogbIKI9KbQv22zPnRsiss7w/W93tsJc
         1KcxuXWYEq8XPmZ1QgLiCTHiRvyDKaSkO1Qn01jWalLqbSLksZRN9S4k2wjDcymhU0
         ApEOqiDZkEdX3Ks2AVlrPRtsux7FXXNNXNRuUpRM=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 048/200] mm/swapfile.c: use helper function
 swap_count() in add_swap_count_continuation()
Message-ID: <20201215030558.tj5dZkWDL%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swapfile.c: use helper function swap_count() in add_swap_count_continuation()

Commit 570a335b8e22 ("swap_info: swap count continuations") introduced the
func add_swap_count_continuation() but forgot to use the helper function
swap_count() introduced by commit 355cfa73ddff ("mm: modify swap_map and
add SWAP_HAS_CACHE flag").

Link: https://lkml.kernel.org/r/20201009134306.18033-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swapfilec-use-helper-function-swap_count-in-add_swap_count_continuation
+++ a/mm/swapfile.c
@@ -3613,7 +3613,7 @@ int add_swap_count_continuation(swp_entr
 
 	ci = lock_cluster(si, offset);
 
-	count = si->swap_map[offset] & ~SWAP_HAS_CACHE;
+	count = swap_count(si->swap_map[offset]);
 
 	if ((count & ~COUNT_CONTINUED) != SWAP_MAP_MAX) {
 		/*
_

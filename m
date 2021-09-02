Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20239C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AF7F60FA0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347799AbhIBWAk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:00:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347671AbhIBWAj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:00:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 452F160F21;
        Thu,  2 Sep 2021 21:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619980;
        bh=LYLMCOtM4Maol3QNvkCW2AL3LnaxOg9c1h1HG4qGKKY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SQ8ftEmGTbL2aVAvOXuNrSOTE6cO9ZRTw4j2JCOOr6a3Z2zzzm62CjTFNtIAr0y/A
         kulqucb9EGBOzyDkhdEwJMA8W91k2UXqrtVj3BBJkuRk5JydsQxbJUVJvKm/4LzWka
         2Ln6oidOi5czW/68D6bJBiyHvTBejIgeVgIUChkU=
Date:   Thu, 02 Sep 2021 14:59:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexs@kernel.org, apopple@nvidia.com,
        axboe@kernel.dk, david@redhat.com, hannes@cmpxchg.org,
        hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com,
        jhubbard@nvidia.com, linmiaohe@huawei.com, linux-mm@kvack.org,
        mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        shli@fb.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        willy@infradead.org, yuzhao@google.com
Subject:  [patch 183/212] mm/vmscan: remove the PageDirty check
 after MADV_FREE pages are page_ref_freezed
Message-ID: <20210902215939.vLQjnWg9C%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmscan: remove the PageDirty check after MADV_FREE pages are page_ref_freezed

Patch series "Cleanups for vmscan", v2.

This series contains cleanups to remove unneeded return value, misleading
setting and so on.  Also this remove the PageDirty check after MADV_FREE
pages are page_ref_freezed.  More details can be found in the respective
changelogs.


This patch (of 4):

If the MADV_FREE pages are redirtied before they could be reclaimed, put
the pages back to anonymous LRU list by setting SwapBacked flag and the
pages will be reclaimed in normal swapout way.  But as Yu Zhao pointed
out, "The page has only one reference left, which is from the isolation. 
After the caller puts the page back on lru and drops the reference, the
page will be freed anyway.  It doesn't matter which lru it goes." So we
don't bother checking PageDirty here.

[Yu Zhao's comment is also quoted in the code.]

Link: https://lkml.kernel.org/r/20210717065911.61497-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210717065911.61497-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Yu Zhao <yuzhao@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-the-pagedirty-check-after-madv_free-pages-are-page_ref_freezed
+++ a/mm/vmscan.c
@@ -1732,11 +1732,14 @@ retry:
 			/* follow __remove_mapping for reference */
 			if (!page_ref_freeze(page, 1))
 				goto keep_locked;
-			if (PageDirty(page)) {
-				page_ref_unfreeze(page, 1);
-				goto keep_locked;
-			}
-
+			/*
+			 * The page has only one reference left, which is
+			 * from the isolation. After the caller puts the
+			 * page back on lru and drops the reference, the
+			 * page will be freed anyway. It doesn't matter
+			 * which lru it goes. So we don't bother checking
+			 * PageDirty here.
+			 */
 			count_vm_event(PGLAZYFREED);
 			count_memcg_page_event(page, PGLAZYFREED);
 		} else if (!mapping || !__remove_mapping(mapping, page, true,
_

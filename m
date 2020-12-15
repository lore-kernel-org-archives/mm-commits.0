Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E73C2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C663D2247F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbgLODNg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:13:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727458AbgLODNL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:13:11 -0500
Date:   Mon, 14 Dec 2020 19:12:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001948;
        bh=a5Xv83E8yXI9oL4JOqoWdgqZ9ouWLbksgjYKL6O+Avg=;
        h=From:To:Subject:In-Reply-To:From;
        b=nTqPq3Od/lIwEe7ucvZ+1wUNCryXLb6w9XjNA3v4TAZzpiBK/JaIVP/lM+7L/HWnM
         4mXAUm36LSy7YQS4rAOJMG1vgAruE5MFFHDGvUBIfunlf4mtnqGfbDARWyu6PoQZJy
         h/2lHer2eh/iLfXgV2jIjUkx6Gwg4ih1owWSHZGo=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        vbabka@suse.cz, willy@infradead.org
Subject:  [patch 155/200] mm/page_isolation: do not isolate the max
 order page
Message-ID: <20201215031227.I96WFUqIx%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/page_isolation: do not isolate the max order page

A max order page has no buddy page and never merges to another order.  So
isolating and then freeing it is pointless.

Link: https://lkml.kernel.org/r/20201202122114.75316-1-songmuchun@bytedance.com
Fixes: 3c605096d315 ("mm/page_alloc: restrict max order of merging on isolated pageblock")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_isolation.c~mm-page_isolation-do-not-isolate-the-max-order-page
+++ a/mm/page_isolation.c
@@ -88,7 +88,7 @@ static void unset_migratetype_isolate(st
 	 */
 	if (PageBuddy(page)) {
 		order = buddy_order(page);
-		if (order >= pageblock_order) {
+		if (order >= pageblock_order && order < MAX_ORDER - 1) {
 			pfn = page_to_pfn(page);
 			buddy_pfn = __find_buddy_pfn(pfn, order);
 			buddy = page + (buddy_pfn - pfn);
_

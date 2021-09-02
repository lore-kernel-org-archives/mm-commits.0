Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9E4CC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2CA760F12
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347646AbhIBV6U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:58:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243139AbhIBV6T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:58:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 376946056B;
        Thu,  2 Sep 2021 21:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619840;
        bh=wrwYkgJyKBW5b8FoZgowfDhV+/yS9/8sFQIHKZ3dvd8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Q5aeDAessxoorDmvHi1wEKfkuMq89W/222fOQ9dO3aqXx1XvZ+W48EMyft6QPGCHr
         JVJmuQyPex5FpWbrn+3zuIP7GZPFjVnscNw1I0PDZfiIK7+Chccgm0K7agusIrxIV3
         i5sSpod3VuYX7HAmQh4rsWReDxAMnM+LMBZDCzLk=
Date:   Thu, 02 Sep 2021 14:57:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@infradead.org, hdanton@sina.com,
        linux-mm@kvack.org, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        torvalds@linux-foundation.org, urezki@gmail.com,
        willy@infradead.org
Subject:  [patch 138/212] mm/vmalloc: remove
 gfpflags_allow_blocking() check
Message-ID: <20210902215719.5lBoJiky2%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: remove gfpflags_allow_blocking() check

Get rid of gfpflags_allow_blocking() check from the vmalloc() path as it
is supposed to be sleepable anyway.  Thus remove it from the
alloc_vmap_area() as well as from the vm_area_alloc_pages().

Link: https://lkml.kernel.org/r/20210707182639.31282-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-remove-gfpflags_allow_blocking-check
+++ a/mm/vmalloc.c
@@ -1479,6 +1479,7 @@ static struct vmap_area *alloc_vmap_area
 				int node, gfp_t gfp_mask)
 {
 	struct vmap_area *va;
+	unsigned long freed;
 	unsigned long addr;
 	int purged = 0;
 	int ret;
@@ -1542,13 +1543,12 @@ overflow:
 		goto retry;
 	}
 
-	if (gfpflags_allow_blocking(gfp_mask)) {
-		unsigned long freed = 0;
-		blocking_notifier_call_chain(&vmap_notify_list, 0, &freed);
-		if (freed > 0) {
-			purged = 0;
-			goto retry;
-		}
+	freed = 0;
+	blocking_notifier_call_chain(&vmap_notify_list, 0, &freed);
+
+	if (freed > 0) {
+		purged = 0;
+		goto retry;
 	}
 
 	if (!(gfp_mask & __GFP_NOWARN) && printk_ratelimit())
@@ -2838,9 +2838,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		for (i = 0; i < (1U << order); i++)
 			pages[nr_allocated + i] = page + i;
 
-		if (gfpflags_allow_blocking(gfp))
-			cond_resched();
-
+		cond_resched();
 		nr_allocated += 1U << order;
 	}
 
_

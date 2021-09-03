Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 459FCC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2991A6113D
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbhICVAG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350144AbhICVAD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:00:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 995E76112F;
        Fri,  3 Sep 2021 20:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702742;
        bh=F7eUr9Px+fpqwsSVuC7zc3TWEoeFE8pwaA6+aBMJhto=;
        h=Date:From:To:Subject:From;
        b=buTgH7EAhneuNPFmUMRwCNCzuWCKjkpABRYojBBThCqxFjTsElKLFB0LKUJhQzqo7
         qVNWU+uhskcTvAquDzDCkC0H9rjMd9che25YXnUaxdv27DVNiBNSvQVAgLlTPzq1GT
         Xssbg3+ruIJar4NSAaTluCrIarXUIX0jfm7YLD88=
Date:   Fri, 03 Sep 2021 13:59:02 -0700
From:   akpm@linux-foundation.org
To:     hch@infradead.org, hdanton@sina.com, mgorman@suse.de,
        mhocko@suse.com, mm-commits@vger.kernel.org, npiggin@gmail.com,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        urezki@gmail.com, willy@infradead.org
Subject:  [merged]
 mm-vmalloc-remove-gfpflags_allow_blocking-check.patch removed from -mm tree
Message-ID: <20210903205902.KJKV8vH9G%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: remove gfpflags_allow_blocking() check
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-remove-gfpflags_allow_blocking-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from urezki@gmail.com are



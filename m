Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 827DFC07E9B
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 23:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6868E613C2
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 23:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhGIXca (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 19:32:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229854AbhGIXc3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 19:32:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D04B613B2;
        Fri,  9 Jul 2021 23:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625873384;
        bh=MCHlN+hazDWv6ul/P54W9iTkMRIN+NcXiuWxsgosPCI=;
        h=Date:From:To:Subject:From;
        b=OQUdaqiHmBfeAqKEIYAOKRS2eMMzLf1M5xe9JH8XycH3nVtb9oETcFCI7VrHp+EgP
         vElHK/FikPFikHTHd5/cNez0Wt5quUoWN72RNvSz6VEmvqhSBwP+LnzxnZcuAmTupl
         TsveOic/SGKqBCs/cTQHTNztpRrRma+MtJJgwsgs=
Date:   Fri, 09 Jul 2021 16:29:44 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rostedt@goodmis.org, oleksiy.avramchenko@sonymobile.com,
        npiggin@gmail.com, mhocko@suse.com, mgorman@suse.de,
        hdanton@sina.com, hch@infradead.org, urezki@gmail.com
Subject:  + mm-vmalloc-remove-gfpflags_allow_blocking-check.patch
 added to -mm tree
Message-ID: <20210709232944.LwwLO%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: remove gfpflags_allow_blocking() check
has been added to the -mm tree.  Its filename is
     mm-vmalloc-remove-gfpflags_allow_blocking-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-remove-gfpflags_allow_blocking-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-remove-gfpflags_allow_blocking-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmalloc-use-batched-page-requests-in-bulk-allocator.patch
mm-vmalloc-remove-gfpflags_allow_blocking-check.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8A07C47436
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C82D22CF7
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgLOX7H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:59814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727692AbgLOXW0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:22:26 -0500
Date:   Tue, 15 Dec 2020 15:20:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074425;
        bh=mLxaQjof+UtafEOYsAe7LZecFWaaKCTIsEJ95CUl4zg=;
        h=From:To:Subject:From;
        b=PZDqeBQYSXQw02QAPe2vu19PDivhmD1p8iu7beZcQMCCg6TDFSCTinc7P3iWLS6lD
         iSeisL3vOCDZM9PtiKyzBI5VOD0hQ/OYw3QP4gtpWuojarP+pdwz7OIE9uyFRFxwPT
         j6lErZTz/Tdj6O1vzwq51quQ84r+HFa2aJgCJAqw=
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, corbet@lwn.net,
        dvyukov@google.com, elver@google.com, glider@google.com,
        jiangshanlai@gmail.com, matthias.bgg@gmail.com,
        mm-commits@vger.kernel.org, tj@kernel.org,
        walter-zh.wu@mediatek.com
Subject:  [merged] kasan-print-workqueue-stack.patch removed from
 -mm tree
Message-ID: <20201215232024.c_eJyfxT3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: print workqueue stack
has been removed from the -mm tree.  Its filename was
     kasan-print-workqueue-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Walter Wu <walter-zh.wu@mediatek.com>
Subject: kasan: print workqueue stack

The aux_stack[2] is reused to record the call_rcu() call stack and
enqueuing work call stacks.  So that we need to change the auxiliary stack
title for common title, print them in KASAN report.

Link: https://lkml.kernel.org/r/20201203022715.30635-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Suggested-by: Marco Elver <elver@google.com>
Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/generic.c |    3 ---
 mm/kasan/report.c  |    4 ++--
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/mm/kasan/generic.c~kasan-print-workqueue-stack
+++ a/mm/kasan/generic.c
@@ -339,9 +339,6 @@ void kasan_record_aux_stack(void *addr)
 	object = nearest_obj(cache, page, addr);
 	alloc_info = get_alloc_info(cache, object);
 
-	/*
-	 * record the last two call_rcu() call stacks.
-	 */
 	alloc_info->aux_stack[1] = alloc_info->aux_stack[0];
 	alloc_info->aux_stack[0] = kasan_save_stack(GFP_NOWAIT);
 }
--- a/mm/kasan/report.c~kasan-print-workqueue-stack
+++ a/mm/kasan/report.c
@@ -185,12 +185,12 @@ static void describe_object(struct kmem_
 
 #ifdef CONFIG_KASAN_GENERIC
 		if (alloc_info->aux_stack[0]) {
-			pr_err("Last call_rcu():\n");
+			pr_err("Last potentially related work creation:\n");
 			print_stack(alloc_info->aux_stack[0]);
 			pr_err("\n");
 		}
 		if (alloc_info->aux_stack[1]) {
-			pr_err("Second to last call_rcu():\n");
+			pr_err("Second to last potentially related work creation:\n");
 			print_stack(alloc_info->aux_stack[1]);
 			pr_err("\n");
 		}
_

Patches currently in -mm which might be from walter-zh.wu@mediatek.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 752FBC4361A
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 00:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 284FD224B1
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 00:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgLCX74 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Dec 2020 18:59:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:51960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbgLCX7z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Dec 2020 18:59:55 -0500
Date:   Thu, 03 Dec 2020 15:59:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607039951;
        bh=bOTlSyaivugRV09k8WR60fCqa6eDgtumagsijqnPaJs=;
        h=From:To:Subject:From;
        b=HIou+cQ2F6sVjSx+X5rK4uegDuaowQrLJjkzLJDdgQNEbdrKIYDgb3fGJoVubZ2D3
         Ae8xnsazEjj3TPSMq89LGgn9pRsqErM0KzPNxQ6uoY7wcsSSTKMUbT2ynfl8l2LYl0
         9pDc+tFxU75d4f4ZbBsGFChi3DbXqv23ds8kG7fc=
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, corbet@lwn.net,
        dvyukov@google.com, elver@google.com, glider@google.com,
        jiangshanlai@gmail.com, matthias.bgg@gmail.com,
        mm-commits@vger.kernel.org, tj@kernel.org,
        walter-zh.wu@mediatek.com
Subject:  + kasan-print-workqueue-stack.patch added to -mm tree
Message-ID: <20201203235909.rFWJMHzzT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: print workqueue stack
has been added to the -mm tree.  Its filename is
     kasan-print-workqueue-stack.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-print-workqueue-stack.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-print-workqueue-stack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

workqueue-kasan-record-workqueue-stack.patch
kasan-print-workqueue-stack.patch
lib-test_kasanc-add-workqueue-test-case.patch
kasan-update-documentation-for-generic-kasan.patch


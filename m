Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E04C2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:12:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A5F522CB1
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbgLODMI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:12:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:36678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727555AbgLODMB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:01 -0500
Date:   Mon, 14 Dec 2020 19:09:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001754;
        bh=sbq9mQUEpR6MhmY1Fd4WXobXpITHSo9HpMai8ptaVPc=;
        h=From:To:Subject:In-Reply-To:From;
        b=zDDvQh1v1Mzaa0AgFCJj5zq5L/W6wmWdNKJCRiDMCNPas0MjvUGy9oTidx+CtCwSF
         oMl4q/yHG3P/eeVsBi7sudotzDAr0xlAwCPkdIM9zXeQhWqg6fcO/GsRUJZXdv4Rrc
         G4V4WXmJkdGehKg9vI4lHfdZhEO+3lX1u3AlUS3s=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, corbet@lwn.net, dvyukov@google.com,
        elver@google.com, glider@google.com, jiangshanlai@gmail.com,
        linux-mm@kvack.org, matthias.bgg@gmail.com,
        mm-commits@vger.kernel.org, tj@kernel.org,
        torvalds@linux-foundation.org, walter-zh.wu@mediatek.com
Subject:  [patch 102/200] kasan: print workqueue stack
Message-ID: <20201215030913.LUqQZ_Wf1%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

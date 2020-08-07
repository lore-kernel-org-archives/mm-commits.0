Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 613CDC433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 332D0221E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781500;
	bh=Akj9TznAPFn9H7V3OZSpI9Z9g20j0XMLIiMYF6UzH6o=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=EXgdg0QVraS7NUeO/8/4UB1eXRD13auMVutphAWRU1zWfn6fSpF5lP6KpFJemvkjG
	 +q4lRxvo5GxcxefNU5u/jjoaKVI3Qw7ArZ2D0KJkdn7xsJN+ji9/HAOirulgsC8nqw
	 KvogTiM9osuygnZnz0fIseoZslMyo5WV7SbjagYk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgHGGY7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGY7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:24:59 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B3B422CB3;
        Fri,  7 Aug 2020 06:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781499;
        bh=Akj9TznAPFn9H7V3OZSpI9Z9g20j0XMLIiMYF6UzH6o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pRaMB8eiftmaZgNKgmVV5+sB7eMSqohulQ48u2/QlZoHN6rNQssYMp35O53AsZAGL
         n8QRaEHzlLsV5K6iTY5avdsklzN+a5S3t7c8Qm9AUgql/bfDv+XN8ql/2KJrEyXJl1
         eMzPQE2r3MgRNBbc3opQi7npICMphsVnTTt1tt+Q=
Date:   Thu, 06 Aug 2020 23:24:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com, ardb@kernel.org,
        aryabinin@virtuozzo.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        lenaptr@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vincenzo.frascino@arm.com,
        walter-zh.wu@mediatek.com
Subject:  [patch 136/163] kasan: don't tag stacks allocated with
 pagealloc
Message-ID: <20200807062457.PNGMqcze5%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: don't tag stacks allocated with pagealloc

Patch series "kasan: support stack instrumentation for tag-based mode", v2.

This patch (of 5):

Prepare Software Tag-Based KASAN for stack tagging support.

With Tag-Based KASAN when kernel stacks are allocated via pagealloc (which
happens when CONFIG_VMAP_STACK is not enabled), they get tagged.  KASAN
instrumentation doesn't expect the sp register to be tagged, and this
leads to false-positive reports.

Fix by resetting the tag of kernel stack pointers after allocation.

Link: http://lkml.kernel.org/r/cover.1596199677.git.andreyknvl@google.com
Link: http://lkml.kernel.org/r/cover.1596544734.git.andreyknvl@google.com
Link: http://lkml.kernel.org/r/12d8c678869268dd0884b01271ab592f30792abf.1596544734.git.andreyknvl@google.com
Link: http://lkml.kernel.org/r/01c678b877755bcf29009176592402cdf6f2cb15.1596199677.git.andreyknvl@google.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=203497
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Walter Wu <walter-zh.wu@mediatek.com>
Cc: Elena Petrova <lenaptr@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/fork.c~kasan-dont-tag-stacks-allocated-with-pagealloc
+++ a/kernel/fork.c
@@ -261,7 +261,7 @@ static unsigned long *alloc_thread_stack
 					     THREAD_SIZE_ORDER);
 
 	if (likely(page)) {
-		tsk->stack = page_address(page);
+		tsk->stack = kasan_reset_tag(page_address(page));
 		return tsk->stack;
 	}
 	return NULL;
@@ -302,6 +302,7 @@ static unsigned long *alloc_thread_stack
 {
 	unsigned long *stack;
 	stack = kmem_cache_alloc_node(thread_stack_cache, THREADINFO_GFP, node);
+	stack = kasan_reset_tag(stack);
 	tsk->stack = stack;
 	return stack;
 }
_

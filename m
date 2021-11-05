Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD5B7C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 991A661262
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhKEUiT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:38:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232269AbhKEUiR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:38:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0434561252;
        Fri,  5 Nov 2021 20:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144537;
        bh=+7UKRVqmEaOgoDhdjdGy+rjCLEa9T0ZjVP5xXx9RZW8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=muLXTV2y+UG2iY78yME2yAXMk3GrnhRaq6tGbHHdpZJ7W56/L/bAaBVJtjScgTfbU
         HeTN9CbxoFikxH0AMig1xxTNx8PoTaOIEtlF2Lq2sILHl83V00bVCC5IzJrd+GNR8C
         2qbAtD7/7+b+qPaAqeTGp5MxTlRrtIQp+v8vCdTA=
Date:   Fri, 05 Nov 2021 13:35:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        bigeasy@linutronix.de, dvyukov@google.com, elver@google.com,
        glider@google.com, gustavoars@kernel.org, jiangshanlai@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com, skhan@linuxfoundation.org,
        tarasmadan@google.com, tglx@linutronix.de, tj@kernel.org,
        torvalds@linux-foundation.org, vinmenon@codeaurora.org,
        vjitta@codeaurora.org, walter-zh.wu@mediatek.com
Subject:  [patch 020/262] lib/stackdepot: remove unused function
 argument
Message-ID: <20211105203536.z6Oj6ZDrj%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: lib/stackdepot: remove unused function argument

alloc_flags in depot_alloc_stack() is no longer used; remove it.

Link: https://lkml.kernel.org/r/20210913112609.2651084-3-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Tested-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Taras Madan <tarasmadan@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Walter Wu <walter-zh.wu@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-remove-unused-function-argument
+++ a/lib/stackdepot.c
@@ -102,8 +102,8 @@ static bool init_stack_slab(void **preal
 }
 
 /* Allocation of a new stack in raw storage */
-static struct stack_record *depot_alloc_stack(unsigned long *entries, int size,
-		u32 hash, void **prealloc, gfp_t alloc_flags)
+static struct stack_record *
+depot_alloc_stack(unsigned long *entries, int size, u32 hash, void **prealloc)
 {
 	struct stack_record *stack;
 	size_t required_size = struct_size(stack, entries, size);
@@ -309,9 +309,8 @@ depot_stack_handle_t stack_depot_save(un
 
 	found = find_stack(*bucket, entries, nr_entries, hash);
 	if (!found) {
-		struct stack_record *new =
-			depot_alloc_stack(entries, nr_entries,
-					  hash, &prealloc, alloc_flags);
+		struct stack_record *new = depot_alloc_stack(entries, nr_entries, hash, &prealloc);
+
 		if (new) {
 			new->next = *bucket;
 			/*
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BBCEC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:40:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1502061284
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbhKKCnB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:43:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:48680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233061AbhKKCnB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:43:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8956E61260;
        Thu, 11 Nov 2021 02:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598413;
        bh=qyn8Oy6xXa31aiP9PkIs4TawGYMjcxcI90dAa7+yh3o=;
        h=Date:From:To:Subject:From;
        b=bMyUrPaJTivtjCDvO4XGBSywiTknmIDVAGw67lD3si4Tl4q2Aq87kUnbQMRmHsBpK
         4yrTcEALD6ita1AP+aRWLHnGVlXJ5yK5qoLCmklHBMh2oAOEWYFCF7IXpcBvWbUacU
         S7FUuxVUaTvPTo2O3RG+mlBFYp4GT8+UXV9Xdj3E=
Date:   Wed, 10 Nov 2021 18:40:12 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bigeasy@linutronix.de, dvyukov@google.com,
        elver@google.com, glider@google.com, gustavoars@kernel.org,
        jiangshanlai@gmail.com, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com, skhan@linuxfoundation.org,
        tarasmadan@google.com, tglx@linutronix.de, tj@kernel.org,
        vinmenon@codeaurora.org, vjitta@codeaurora.org,
        walter-zh.wu@mediatek.com
Subject:  [merged]
 lib-stackdepot-remove-unused-function-argument.patch removed from -mm tree
Message-ID: <20211111024012.9Gk2ZlJgl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: remove unused function argument
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-remove-unused-function-argument.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from elver@google.com are



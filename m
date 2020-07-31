Return-Path: <SRS0=f579=BK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE96C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 19:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B273D22B3F
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 19:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596223463;
	bh=OuokYXghXnedYsbMbu8Y8OxZYONTvjdAC2ideUd5lGo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=CBww24KDAi1APzFzIc5+iXrpLm68dwoiOjYmAUriRIFROiBCb4GIetGTrTE/0LmnG
	 CYbIXery95zsJ9y2s3hFU2oY9wjnjvgchqsiDK4WFSwsc+skrd9qUBZBImSQ0nN9oa
	 sWpuwxYZ49rk6s/bnwA3qNUTxRz1KfHRIvvDUtwY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgGaTYX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Jul 2020 15:24:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726726AbgGaTYX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jul 2020 15:24:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AA96208E4;
        Fri, 31 Jul 2020 19:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596223462;
        bh=OuokYXghXnedYsbMbu8Y8OxZYONTvjdAC2ideUd5lGo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=00aHOyRndC+MLczlBDQ/AHwfuPEGK4QZfMNImkZTptkfuzgZQcxkCoZRL/TUxLkK7
         WfoOl8dvam5QDeKKnLXmLTTTNnbGhduFmpvQmTXVmq4A5pW3EiWQgImCju700jZA/H
         98Yd1qfhMON/oC2jdSfpcN33eykPgB5gPWqrkUPQ=
Date:   Fri, 31 Jul 2020 12:24:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        glider@google.com, lenaptr@google.com, mm-commits@vger.kernel.org,
        vincenzo.frascino@arm.com, walter-zh.wu@mediatek.com
Subject:  + kasan-dont-tag-stacks-allocated-with-pagealloc.patch
 added to -mm tree
Message-ID: <20200731192421.ZCtfmgNsb%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: don't tag stacks allocated with pagealloc
has been added to the -mm tree.  Its filename is
     kasan-dont-tag-stacks-allocated-with-pagealloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-dont-tag-stacks-allocated-with-pagealloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-dont-tag-stacks-allocated-with-pagealloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: don't tag stacks allocated with pagealloc

Patch series "kasan: support stack instrumentation for tag-based mode".

This patch (of 4):

Prepare Software Tag-Based KASAN for stack tagging support.

With Tag-Based KASAN when kernel stacks are allocated via pagealloc (which
happens when CONFIG_VMAP_STACK is not enabled), they get tagged.  KASAN
instrumentation doesn't expect the sp register to be tagged, and this
leads to false-positive reports.

Fix by resetting the tag of kernel stack pointers after allocation.

Link: http://lkml.kernel.org/r/cover.1596199677.git.andreyknvl@google.com
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

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-dont-tag-stacks-allocated-with-pagealloc.patch
kasan-arm64-dont-instrument-functions-that-enable-kasan.patch
kasan-allow-enabling-stack-tagging-for-tag-based-mode.patch
kasan-adjust-kasan_stack_oob-for-tag-based-mode.patch


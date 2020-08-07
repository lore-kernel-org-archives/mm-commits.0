Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E267C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0CF422CAF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781492;
	bh=UJhOeokpcD8E1PIuYr696yPLttJrC28HxriLitMJYaY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Cu1S8m0iqI+WeRS7sdk6xCsEU33QFoLYNFaj+qkk2zlaFpEd8XPaxyVigd5hPsrpc
	 ZVqsszbWBqMQysvwFSUDzaGAKlwrX5eYknRrnJqEfcSJEZv0e44dlceMCr12gxrvEB
	 S39vu3+N21CTDl1Veoq3uFLCciqeiqkWx7euu+uo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgHGGYw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:24:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGYw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:24:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 052D1221E5;
        Fri,  7 Aug 2020 06:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781491;
        bh=UJhOeokpcD8E1PIuYr696yPLttJrC28HxriLitMJYaY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XIaPWrgb0OWxJfGfGHGf4BgTN+J2KVJeNtJoJcnqUE8Measl7yqA9hmkscnl26+jS
         OeX7fv39lc5DRK73bnoQJRCHsT6muGF+UUSCs61+Y3vYC8w2lqxH8yvGslX3/zPo+N
         17p2llDC1PVxpE7B64Dvbc3EYVkizIhG+imlU+y8=
Date:   Thu, 06 Aug 2020 23:24:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com,
        linux-mm@kvack.org, mark.rutland@arm.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com
Subject:  [patch 134/163] kasan: remove
 kasan_unpoison_stack_above_sp_to()
Message-ID: <20200807062450.adgHWSVZG%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: kasan: remove kasan_unpoison_stack_above_sp_to()

kasan_unpoison_stack_above_sp_to() is defined in kasan code but never
used.  The function was introduced as part of the commit:

   commit 9f7d416c36124667 ("kprobes: Unpoison stack in jprobe_return() for KASAN")

... where it was necessary because x86's jprobe_return() would leave
stale shadow on the stack, and was an oddity in that regard.

Since then, jprobes were removed entirely, and as of commit:

  commit 80006dbee674f9fa ("kprobes/x86: Remove jprobe implementation")

... there have been no callers of this function.

Remove the declaration and the implementation.

Link: http://lkml.kernel.org/r/20200706143505.23299-1-vincenzo.frascino@arm.com
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    2 --
 mm/kasan/common.c     |   15 ---------------
 2 files changed, 17 deletions(-)

--- a/include/linux/kasan.h~kasan-remove-kasan_unpoison_stack_above_sp_to
+++ a/include/linux/kasan.h
@@ -38,7 +38,6 @@ extern void kasan_disable_current(void);
 void kasan_unpoison_shadow(const void *address, size_t size);
 
 void kasan_unpoison_task_stack(struct task_struct *task);
-void kasan_unpoison_stack_above_sp_to(const void *watermark);
 
 void kasan_alloc_pages(struct page *page, unsigned int order);
 void kasan_free_pages(struct page *page, unsigned int order);
@@ -101,7 +100,6 @@ void kasan_restore_multi_shot(bool enabl
 static inline void kasan_unpoison_shadow(const void *address, size_t size) {}
 
 static inline void kasan_unpoison_task_stack(struct task_struct *task) {}
-static inline void kasan_unpoison_stack_above_sp_to(const void *watermark) {}
 
 static inline void kasan_enable_current(void) {}
 static inline void kasan_disable_current(void) {}
--- a/mm/kasan/common.c~kasan-remove-kasan_unpoison_stack_above_sp_to
+++ a/mm/kasan/common.c
@@ -180,21 +180,6 @@ asmlinkage void kasan_unpoison_task_stac
 	kasan_unpoison_shadow(base, watermark - base);
 }
 
-/*
- * Clear all poison for the region between the current SP and a provided
- * watermark value, as is sometimes required prior to hand-crafted asm function
- * returns in the middle of functions.
- */
-void kasan_unpoison_stack_above_sp_to(const void *watermark)
-{
-	const void *sp = __builtin_frame_address(0);
-	size_t size = watermark - sp;
-
-	if (WARN_ON(sp > watermark))
-		return;
-	kasan_unpoison_shadow(sp, size);
-}
-
 void kasan_alloc_pages(struct page *page, unsigned int order)
 {
 	u8 tag;
_

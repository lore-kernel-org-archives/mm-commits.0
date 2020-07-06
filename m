Return-Path: <SRS0=vc0r=AR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC01C433DF
	for <mm-commits@archiver.kernel.org>; Mon,  6 Jul 2020 22:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3442A20739
	for <mm-commits@archiver.kernel.org>; Mon,  6 Jul 2020 22:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594075296;
	bh=kFEF9btai+HvsfiIwXq210y8RM7XAudeQdVYYuVoXxY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=CfmzoouGkMU4nTnSSA1sFf7v+gLTBJe493yHJxfLkc/XLtV7FaGd7xPP9s8Fq/VP8
	 8xQPkRgoubJ5wMa10ILNjWo8+6/YwlAwrQuth4QqT7291QNGrwVYON2T7e2yKKhY1T
	 cxPtx525W2MjL8ymSZ8TrlzTu6V3VchQalGrOWwU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgGFWlf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Jul 2020 18:41:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726681AbgGFWlf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Jul 2020 18:41:35 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A36F520723;
        Mon,  6 Jul 2020 22:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594075294;
        bh=kFEF9btai+HvsfiIwXq210y8RM7XAudeQdVYYuVoXxY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=In+1QjH8YnGyiFh5rBQACI174d0otuBNF3sGtX8Pa6yTeUZrU6xYmjCREGMRHJgm6
         gnSOiFtQ+NyoWUU56Shl7JU0du4K38iys0JMxw6DaM/hI0vNXHOpW3S0Suj5HnG8CQ
         PXU9hk5z3ysNtZJm8awuaPiiOos3tT374/fxhijg=
Date:   Mon, 06 Jul 2020 15:41:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com,
        mark.rutland@arm.com, mm-commits@vger.kernel.org,
        vincenzo.frascino@arm.com
Subject:  + kasan-remove-kasan_unpoison_stack_above_sp_to.patch
 added to -mm tree
Message-ID: <20200706224134.H6Cn3T8Ik%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
Message-ID: <20200706224134.6ye6H31Y3b6UPpmHZVBgesdZqRrRq3FD8FQPZTvDdDE@z>


The patch titled
     Subject: kasan: remove kasan_unpoison_stack_above_sp_to()
has been added to the -mm tree.  Its filename is
     kasan-remove-kasan_unpoison_stack_above_sp_to.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-remove-kasan_unpoison_stack_above_sp_to.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-remove-kasan_unpoison_stack_above_sp_to.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from vincenzo.frascino@arm.com are

kasan-remove-kasan_unpoison_stack_above_sp_to.patch


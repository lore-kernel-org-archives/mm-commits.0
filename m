From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-remove-kasan_unpoison_stack_above_sp_to.patch
 added to -mm tree
Date: Mon, 06 Jul 2020 15:41:34 -0700
Message-ID: <20200706224134.H6Cn3T8Ik%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726681AbgGFWlf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Jul 2020 18:41:35 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mark.rutland@arm.com, mm-commits@vger.kernel.org, vincenzo.frascino@arm.com


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

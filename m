Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 342CCC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DFB161262
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbhKEUiV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:38:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232269AbhKEUiU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:38:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 554EB611EE;
        Fri,  5 Nov 2021 20:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144540;
        bh=54yLhZ4FdY7G6NZnyqkmhy/fP815gr1eOuvYTayGcj0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xcxsLCinNDloHvX78B7ljRsDROIdTyfgdarYFJbjheybPVbWbD9yVVLM+iVSLU2Zw
         VFX2KNKu07LoJQjF2ZHn2q2sxCwlcOyMIT0C3sf7i8dGkmIAk4K387J4iwH9laeU4S
         QC2dAIkCsszqekWhb1wbYNgUmeke9EfJfH+Ikqy4=
Date:   Fri, 05 Nov 2021 13:35:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        bigeasy@linutronix.de, dvyukov@google.com, elver@google.com,
        glider@google.com, gustavoars@kernel.org, jiangshanlai@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com, skhan@linuxfoundation.org,
        tarasmadan@google.com, tglx@linutronix.de, tj@kernel.org,
        torvalds@linux-foundation.org, vinmenon@codeaurora.org,
        vjitta@codeaurora.org, walter-zh.wu@mediatek.com
Subject:  [patch 021/262] lib/stackdepot: introduce
 __stack_depot_save()
Message-ID: <20211105203539.x75nvkjw2%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: lib/stackdepot: introduce __stack_depot_save()

Add __stack_depot_save(), which provides more fine-grained control over
stackdepot's memory allocation behaviour, in case stackdepot runs out of
"stack slabs".

Normally stackdepot uses alloc_pages() in case it runs out of space;
passing can_alloc==false to __stack_depot_save() prohibits this, at the
cost of more likely failure to record a stack trace.

Link: https://lkml.kernel.org/r/20210913112609.2651084-4-elver@google.com
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

 include/linux/stackdepot.h |    4 +++
 lib/stackdepot.c           |   43 ++++++++++++++++++++++++++++++-----
 2 files changed, 41 insertions(+), 6 deletions(-)

--- a/include/linux/stackdepot.h~lib-stackdepot-introduce-__stack_depot_save
+++ a/include/linux/stackdepot.h
@@ -15,6 +15,10 @@
 
 typedef u32 depot_stack_handle_t;
 
+depot_stack_handle_t __stack_depot_save(unsigned long *entries,
+					unsigned int nr_entries,
+					gfp_t gfp_flags, bool can_alloc);
+
 depot_stack_handle_t stack_depot_save(unsigned long *entries,
 				      unsigned int nr_entries, gfp_t gfp_flags);
 
--- a/lib/stackdepot.c~lib-stackdepot-introduce-__stack_depot_save
+++ a/lib/stackdepot.c
@@ -248,17 +248,28 @@ unsigned int stack_depot_fetch(depot_sta
 EXPORT_SYMBOL_GPL(stack_depot_fetch);
 
 /**
- * stack_depot_save - Save a stack trace from an array
+ * __stack_depot_save - Save a stack trace from an array
  *
  * @entries:		Pointer to storage array
  * @nr_entries:		Size of the storage array
  * @alloc_flags:	Allocation gfp flags
+ * @can_alloc:		Allocate stack slabs (increased chance of failure if false)
+ *
+ * Saves a stack trace from @entries array of size @nr_entries. If @can_alloc is
+ * %true, is allowed to replenish the stack slab pool in case no space is left
+ * (allocates using GFP flags of @alloc_flags). If @can_alloc is %false, avoids
+ * any allocations and will fail if no space is left to store the stack trace.
+ *
+ * Context: Any context, but setting @can_alloc to %false is required if
+ *          alloc_pages() cannot be used from the current context. Currently
+ *          this is the case from contexts where neither %GFP_ATOMIC nor
+ *          %GFP_NOWAIT can be used (NMI, raw_spin_lock).
  *
- * Return: The handle of the stack struct stored in depot
+ * Return: The handle of the stack struct stored in depot, 0 on failure.
  */
-depot_stack_handle_t stack_depot_save(unsigned long *entries,
-				      unsigned int nr_entries,
-				      gfp_t alloc_flags)
+depot_stack_handle_t __stack_depot_save(unsigned long *entries,
+					unsigned int nr_entries,
+					gfp_t alloc_flags, bool can_alloc)
 {
 	struct stack_record *found = NULL, **bucket;
 	depot_stack_handle_t retval = 0;
@@ -291,7 +302,7 @@ depot_stack_handle_t stack_depot_save(un
 	 * The smp_load_acquire() here pairs with smp_store_release() to
 	 * |next_slab_inited| in depot_alloc_stack() and init_stack_slab().
 	 */
-	if (unlikely(!smp_load_acquire(&next_slab_inited))) {
+	if (unlikely(can_alloc && !smp_load_acquire(&next_slab_inited))) {
 		/*
 		 * Zero out zone modifiers, as we don't have specific zone
 		 * requirements. Keep the flags related to allocation in atomic
@@ -339,6 +350,26 @@ exit:
 fast_exit:
 	return retval;
 }
+EXPORT_SYMBOL_GPL(__stack_depot_save);
+
+/**
+ * stack_depot_save - Save a stack trace from an array
+ *
+ * @entries:		Pointer to storage array
+ * @nr_entries:		Size of the storage array
+ * @alloc_flags:	Allocation gfp flags
+ *
+ * Context: Contexts where allocations via alloc_pages() are allowed.
+ *          See __stack_depot_save() for more details.
+ *
+ * Return: The handle of the stack struct stored in depot, 0 on failure.
+ */
+depot_stack_handle_t stack_depot_save(unsigned long *entries,
+				      unsigned int nr_entries,
+				      gfp_t alloc_flags)
+{
+	return __stack_depot_save(entries, nr_entries, alloc_flags, true);
+}
 EXPORT_SYMBOL_GPL(stack_depot_save);
 
 static inline int in_irqentry_text(unsigned long ptr)
_

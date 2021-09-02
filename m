Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E757DC43219
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:52:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D533A610F7
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347640AbhIBVxL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:53:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347659AbhIBVxF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:53:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1788C61107;
        Thu,  2 Sep 2021 21:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619526;
        bh=a0SQdmMFG84rm9BY87zGWxnAQhMoU/lki5fV6r/2mv4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wu8WHzCfNpU6rf3mqwQret3oQlgBSdeCkMYqbm+gvRsQM29vuniZHWsNSI5rkbvFx
         KrGPJpM2pTVLrV3cs+0yDubdX1EU6GIhtT7BOG3Oi5myHOnEbdS0pWX+ybVwmUONZ8
         VLLRH1rvcsGcuCLofY5ablafGeFhs8vbfwWpO1VY=
Date:   Thu, 02 Sep 2021 14:52:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 040/212] mm, slub: make slab_lock() disable irqs
 with PREEMPT_RT
Message-ID: <20210902215205.cEty-ni0y%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: make slab_lock() disable irqs with PREEMPT_RT

We need to disable irqs around slab_lock() (a bit spinlock) to make it
irq-safe.  The calls to slab_lock() are nested under spin_lock_irqsave()
which doesn't disable irqs on PREEMPT_RT, so add explicit disabling with
PREEMPT_RT.

We also distinguish cmpxchg_double_slab() where we do the disabling
explicitly and __cmpxchg_double_slab() for contexts with already disabled
irqs.  However these context are also typically spin_lock_irqsave() thus
insufficient on PREEMPT_RT.  Thus, change __cmpxchg_double_slab() to be
same as cmpxchg_double_slab() on PREEMPT_RT.

Link: https://lkml.kernel.org/r/20210805152000.12817-33-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/slub.c~mm-slub-make-slab_lock-disable-irqs-with-preempt_rt
+++ a/mm/slub.c
@@ -380,12 +380,12 @@ __slab_unlock(struct page *page, unsigne
 static __always_inline void
 slab_lock(struct page *page, unsigned long *flags)
 {
-	__slab_lock(page, flags, false);
+	__slab_lock(page, flags, IS_ENABLED(CONFIG_PREEMPT_RT));
 }
 
 static __always_inline void slab_unlock(struct page *page, unsigned long *flags)
 {
-	__slab_unlock(page, flags, false);
+	__slab_unlock(page, flags, IS_ENABLED(CONFIG_PREEMPT_RT));
 }
 
 static inline bool ___cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
@@ -429,14 +429,19 @@ static inline bool ___cmpxchg_double_sla
 	return false;
 }
 
-/* Interrupts must be disabled (for the fallback code to work right) */
+/*
+ * Interrupts must be disabled (for the fallback code to work right), typically
+ * by an _irqsave() lock variant. Except on PREEMPT_RT where locks are different
+ * so we disable interrupts explicitly here.
+ */
 static inline bool __cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
 		void *freelist_old, unsigned long counters_old,
 		void *freelist_new, unsigned long counters_new,
 		const char *n)
 {
 	return ___cmpxchg_double_slab(s, page, freelist_old, counters_old,
-				      freelist_new, counters_new, n, false);
+				      freelist_new, counters_new, n,
+				      IS_ENABLED(CONFIG_PREEMPT_RT));
 }
 
 static inline bool cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
_

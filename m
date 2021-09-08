Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC1A2C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B141761102
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347291AbhIHCzn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:55:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345895AbhIHCzl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:55:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 926E260EE6;
        Wed,  8 Sep 2021 02:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069674;
        bh=MUdtpURXc3ZjBPlUwjvkBeBt7GMMx/SEA/8yp/c25hI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=csIyYx2OWRxKpd6FXruZ/A6+lABydWc5nHdmF4M/lTUWfzHkimm/QVbFl6Kbm2N/N
         fKRZeBKQjUXgrSnrBzYCHL/55bnDR+TgFBJpzX3vgDaei6lExUfac+2z5OLwKWtrDz
         iApQA30Yz8D8RNMpWOyg2fWjqNg2xuMuCPaMDy6g=
Date:   Tue, 07 Sep 2021 19:54:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 030/147] mm, slub: make slab_lock() disable irqs
 with PREEMPT_RT
Message-ID: <20210908025433.tX78963wn%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: make slab_lock() disable irqs with PREEMPT_RT

We need to disable irqs around slab_lock() (a bit spinlock) to make it
irq-safe.  Most calls to slab_lock() are nested under spin_lock_irqsave()
which doesn't disable irqs on PREEMPT_RT, so add explicit disabling with
PREEMPT_RT.  The exception is cmpxchg_double_slab() which already disables
irqs, so use a __slab_[un]lock() variant without irq disable there.

slab_[un]lock() thus needs a flags pointer parameter, which is unused on
!RT.  free_debug_processing() now has two flags variables, which looks
odd, but only one is actually used - the one used in spin_lock_irqsave()
on !RT and the one used in slab_lock() on RT.

As a result, __cmpxchg_double_slab() and cmpxchg_double_slab() become
effectively identical on RT, as both will disable irqs, which is necessary
on RT as most callers of this function also rely on irqsaving lock
operations.  Thus, assert that irqs are already disabled in
__cmpxchg_double_slab() only on !RT and also change the VM_BUG_ON
assertion to the more standard lockdep_assert one.

Link: https://lkml.kernel.org/r/20210904105003.11688-31-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Qian Cai <quic_qiancai@quicinc.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   58 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 41 insertions(+), 17 deletions(-)

--- a/mm/slub.c~mm-slub-make-slab_lock-disable-irqs-with-preempt_rt
+++ a/mm/slub.c
@@ -359,25 +359,44 @@ static inline unsigned int oo_objects(st
 /*
  * Per slab locking using the pagelock
  */
-static __always_inline void slab_lock(struct page *page)
+static __always_inline void __slab_lock(struct page *page)
 {
 	VM_BUG_ON_PAGE(PageTail(page), page);
 	bit_spin_lock(PG_locked, &page->flags);
 }
 
-static __always_inline void slab_unlock(struct page *page)
+static __always_inline void __slab_unlock(struct page *page)
 {
 	VM_BUG_ON_PAGE(PageTail(page), page);
 	__bit_spin_unlock(PG_locked, &page->flags);
 }
 
-/* Interrupts must be disabled (for the fallback code to work right) */
+static __always_inline void slab_lock(struct page *page, unsigned long *flags)
+{
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		local_irq_save(*flags);
+	__slab_lock(page);
+}
+
+static __always_inline void slab_unlock(struct page *page, unsigned long *flags)
+{
+	__slab_unlock(page);
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		local_irq_restore(*flags);
+}
+
+/*
+ * Interrupts must be disabled (for the fallback code to work right), typically
+ * by an _irqsave() lock variant. Except on PREEMPT_RT where locks are different
+ * so we disable interrupts as part of slab_[un]lock().
+ */
 static inline bool __cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
 		void *freelist_old, unsigned long counters_old,
 		void *freelist_new, unsigned long counters_new,
 		const char *n)
 {
-	VM_BUG_ON(!irqs_disabled());
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		lockdep_assert_irqs_disabled();
 #if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
     defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 	if (s->flags & __CMPXCHG_DOUBLE) {
@@ -388,15 +407,18 @@ static inline bool __cmpxchg_double_slab
 	} else
 #endif
 	{
-		slab_lock(page);
+		/* init to 0 to prevent spurious warnings */
+		unsigned long flags = 0;
+
+		slab_lock(page, &flags);
 		if (page->freelist == freelist_old &&
 					page->counters == counters_old) {
 			page->freelist = freelist_new;
 			page->counters = counters_new;
-			slab_unlock(page);
+			slab_unlock(page, &flags);
 			return true;
 		}
-		slab_unlock(page);
+		slab_unlock(page, &flags);
 	}
 
 	cpu_relax();
@@ -427,16 +449,16 @@ static inline bool cmpxchg_double_slab(s
 		unsigned long flags;
 
 		local_irq_save(flags);
-		slab_lock(page);
+		__slab_lock(page);
 		if (page->freelist == freelist_old &&
 					page->counters == counters_old) {
 			page->freelist = freelist_new;
 			page->counters = counters_new;
-			slab_unlock(page);
+			__slab_unlock(page);
 			local_irq_restore(flags);
 			return true;
 		}
-		slab_unlock(page);
+		__slab_unlock(page);
 		local_irq_restore(flags);
 	}
 
@@ -1269,11 +1291,11 @@ static noinline int free_debug_processin
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
 	void *object = head;
 	int cnt = 0;
-	unsigned long flags;
+	unsigned long flags, flags2;
 	int ret = 0;
 
 	spin_lock_irqsave(&n->list_lock, flags);
-	slab_lock(page);
+	slab_lock(page, &flags2);
 
 	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
 		if (!check_slab(s, page))
@@ -1306,7 +1328,7 @@ out:
 		slab_err(s, page, "Bulk freelist count(%d) invalid(%d)\n",
 			 bulk_cnt, cnt);
 
-	slab_unlock(page);
+	slab_unlock(page, &flags2);
 	spin_unlock_irqrestore(&n->list_lock, flags);
 	if (!ret)
 		slab_fix(s, "Object at 0x%p not freed", object);
@@ -4087,11 +4109,12 @@ static void list_slab_objects(struct kme
 {
 #ifdef CONFIG_SLUB_DEBUG
 	void *addr = page_address(page);
+	unsigned long flags;
 	unsigned long *map;
 	void *p;
 
 	slab_err(s, page, text, s->name);
-	slab_lock(page);
+	slab_lock(page, &flags);
 
 	map = get_map(s, page);
 	for_each_object(p, s, addr, page->objects) {
@@ -4102,7 +4125,7 @@ static void list_slab_objects(struct kme
 		}
 	}
 	put_map(map);
-	slab_unlock(page);
+	slab_unlock(page, &flags);
 #endif
 }
 
@@ -4834,8 +4857,9 @@ static void validate_slab(struct kmem_ca
 {
 	void *p;
 	void *addr = page_address(page);
+	unsigned long flags;
 
-	slab_lock(page);
+	slab_lock(page, &flags);
 
 	if (!check_slab(s, page) || !on_freelist(s, page, NULL))
 		goto unlock;
@@ -4850,7 +4874,7 @@ static void validate_slab(struct kmem_ca
 			break;
 	}
 unlock:
-	slab_unlock(page);
+	slab_unlock(page, &flags);
 }
 
 static int validate_slab_node(struct kmem_cache *s,
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D05BBC04E82
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB3CE61102
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347649AbhIBVxE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:53:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347659AbhIBVxC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:53:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C261E610A2;
        Thu,  2 Sep 2021 21:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619523;
        bh=WFwdwXaahaN3Q9fJnA79II4vQkMvdADhFtMkdNVTzb0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BntYaSrED3sWosWVpNLJKHls65t2G7VhNlGAK9A2FIdyccdJRZLTTiaySde36v/1e
         gbbh4kfYe+/M+wjRNKIJKPcIJKiTSWwdoN8waNiOWUgT4B4O/fe3vSD4ckDp+u2SU2
         7PQKUkbxcAuEY5iPvI09tINjvSH6hus9wvcYVuk4=
Date:   Thu, 02 Sep 2021 14:52:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 039/212] mm, slub: optionally save/restore irqs in
 slab_[un]lock()/
Message-ID: <20210902215202.DDxcqTWRO%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: optionally save/restore irqs in slab_[un]lock()/

For PREEMPT_RT we will need to disable irqs for this bit spinlock.  As a
preparation, add a flags parameter, and an internal version that takes
additional bool parameter to control irq saving/restoring (the flags
parameter is compile-time unused if the bool is a constant false).

Convert ___cmpxchg_double_slab(), which also comes with the same bool
parameter, to use the internal version.

Link: https://lkml.kernel.org/r/20210805152000.12817-32-vbabka@suse.cz
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

 mm/slub.c |   52 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 19 deletions(-)

--- a/mm/slub.c~mm-slub-optionally-save-restore-irqs-in-slab_lock
+++ a/mm/slub.c
@@ -359,16 +359,33 @@ static inline unsigned int oo_objects(st
 /*
  * Per slab locking using the pagelock
  */
-static __always_inline void slab_lock(struct page *page)
+static __always_inline void
+__slab_lock(struct page *page, unsigned long *flags, bool disable_irqs)
 {
 	VM_BUG_ON_PAGE(PageTail(page), page);
+	if (disable_irqs)
+		local_irq_save(*flags);
 	bit_spin_lock(PG_locked, &page->flags);
 }
 
-static __always_inline void slab_unlock(struct page *page)
+static __always_inline void
+__slab_unlock(struct page *page, unsigned long *flags, bool disable_irqs)
 {
 	VM_BUG_ON_PAGE(PageTail(page), page);
 	__bit_spin_unlock(PG_locked, &page->flags);
+	if (disable_irqs)
+		local_irq_restore(*flags);
+}
+
+static __always_inline void
+slab_lock(struct page *page, unsigned long *flags)
+{
+	__slab_lock(page, flags, false);
+}
+
+static __always_inline void slab_unlock(struct page *page, unsigned long *flags)
+{
+	__slab_unlock(page, flags, false);
 }
 
 static inline bool ___cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
@@ -388,23 +405,18 @@ static inline bool ___cmpxchg_double_sla
 	} else
 #endif
 	{
-		unsigned long flags;
+		/* init to 0 to prevent spurious warnings */
+		unsigned long flags = 0;
 
-		if (disable_irqs)
-			local_irq_save(flags);
-		slab_lock(page);
+		__slab_lock(page, &flags, disable_irqs);
 		if (page->freelist == freelist_old &&
 					page->counters == counters_old) {
 			page->freelist = freelist_new;
 			page->counters = counters_new;
-			slab_unlock(page);
-			if (disable_irqs)
-				local_irq_restore(flags);
+			__slab_unlock(page, &flags, disable_irqs);
 			return true;
 		}
-		slab_unlock(page);
-		if (disable_irqs)
-			local_irq_restore(flags);
+		__slab_unlock(page, &flags, disable_irqs);
 	}
 
 	cpu_relax();
@@ -1255,11 +1267,11 @@ static noinline int free_debug_processin
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
@@ -1292,7 +1304,7 @@ out:
 		slab_err(s, page, "Bulk freelist count(%d) invalid(%d)\n",
 			 bulk_cnt, cnt);
 
-	slab_unlock(page);
+	slab_unlock(page, &flags2);
 	spin_unlock_irqrestore(&n->list_lock, flags);
 	if (!ret)
 		slab_fix(s, "Object at 0x%p not freed", object);
@@ -4070,9 +4082,10 @@ static void list_slab_objects(struct kme
 	void *addr = page_address(page);
 	unsigned long *map;
 	void *p;
+	unsigned long flags;
 
 	slab_err(s, page, text, s->name);
-	slab_lock(page);
+	slab_lock(page, &flags);
 
 	map = get_map(s, page);
 	for_each_object(p, s, addr, page->objects) {
@@ -4083,7 +4096,7 @@ static void list_slab_objects(struct kme
 		}
 	}
 	put_map(map);
-	slab_unlock(page);
+	slab_unlock(page, &flags);
 #endif
 }
 
@@ -4815,8 +4828,9 @@ static void validate_slab(struct kmem_ca
 {
 	void *p;
 	void *addr = page_address(page);
+	unsigned long flags;
 
-	slab_lock(page);
+	slab_lock(page, &flags);
 
 	if (!check_slab(s, page) || !on_freelist(s, page, NULL))
 		goto unlock;
@@ -4831,7 +4845,7 @@ static void validate_slab(struct kmem_ca
 			break;
 	}
 unlock:
-	slab_unlock(page);
+	slab_unlock(page, &flags);
 }
 
 static int validate_slab_node(struct kmem_cache *s,
_

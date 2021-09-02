Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD5C6C43219
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9114D610F7
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347621AbhIBVww (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347600AbhIBVww (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:52:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA62160724;
        Thu,  2 Sep 2021 21:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619513;
        bh=qDOpjSDLqojEPlRwfb8AnPFecXiVE1YM5G61SRkqn3o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MxckI9kEDSyjj/JmKhFeSABMBA2u4t17Cuj/IyPCwZzwCtPyfOmeBD+XVCqaH0K32
         AKD49wM6lopEjkfjbM5M7iExQu3S2oSyfet9yz3dS7eCIEVslma/f58JmHbeDOLf3Q
         /qXY1xHmC4ra7e6nTig2pnpLb1JkgSvNry6LE8NM=
Date:   Thu, 02 Sep 2021 14:51:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 036/212] mm, slab: make flush_slab() possible to
 call with irqs enabled
Message-ID: <20210902215152.ibWfL_bvd%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slab: make flush_slab() possible to call with irqs enabled

Currently flush_slab() is always called with disabled IRQs if it's needed,
but the following patches will change that, so add a parameter to control
IRQ disabling within the function, which only protects the kmem_cache_cpu
manipulation and not the call to deactivate_slab() which doesn't need it.

Link: https://lkml.kernel.org/r/20210805152000.12817-29-vbabka@suse.cz
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

 mm/slub.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/mm/slub.c~mm-slab-make-flush_slab-possible-to-call-with-irqs-enabled
+++ a/mm/slub.c
@@ -2480,16 +2480,28 @@ static void put_cpu_partial(struct kmem_
 #endif	/* CONFIG_SLUB_CPU_PARTIAL */
 }
 
-static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
+static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c,
+			      bool lock)
 {
-	void *freelist = c->freelist;
-	struct page *page = c->page;
+	unsigned long flags;
+	void *freelist;
+	struct page *page;
+
+	if (lock)
+		local_irq_save(flags);
+
+	freelist = c->freelist;
+	page = c->page;
 
 	c->page = NULL;
 	c->freelist = NULL;
 	c->tid = next_tid(c->tid);
 
-	deactivate_slab(s, page, freelist);
+	if (lock)
+		local_irq_restore(flags);
+
+	if (page)
+		deactivate_slab(s, page, freelist);
 
 	stat(s, CPUSLAB_FLUSH);
 }
@@ -2499,7 +2511,7 @@ static inline void __flush_cpu_slab(stru
 	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
 
 	if (c->page)
-		flush_slab(s, c);
+		flush_slab(s, c, false);
 
 	unfreeze_partials_cpu(s, c);
 }
@@ -2515,7 +2527,7 @@ static void flush_cpu_slab(void *d)
 	struct kmem_cache_cpu *c = this_cpu_ptr(s->cpu_slab);
 
 	if (c->page)
-		flush_slab(s, c);
+		flush_slab(s, c, false);
 
 	unfreeze_partials(s);
 }
_

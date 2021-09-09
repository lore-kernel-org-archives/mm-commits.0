Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26385C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11A94611AF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345733AbhIIVCF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345513AbhIIVCE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:02:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7FC361026;
        Thu,  9 Sep 2021 21:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221255;
        bh=ZrqA9oWv2KwaUv/wvv191OWWqzJEBwaIZ55/tQ+vqbo=;
        h=Date:From:To:Subject:From;
        b=pRaHMKqDWG9FjGEI5YJmm33VIbSXgt9Zl0NJjXm/HBfx6C0y/ppcI8ZZucGeZmxIh
         lvkzKVvteAaC3768tAAsIMxztauogAp2ub9a+muh5BOh3dofTSphpDUZGn6lJhR1Bv
         LD9yhY3dem6MTZ+0748Hen99a/QuHEHlZuJYZ/PI=
Date:   Thu, 09 Sep 2021 14:00:54 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, cl@linux.com,
        efault@gmx.de, iamjoonsoo.kim@lge.com, jannh@google.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged]
 mm-slub-move-irq-control-into-unfreeze_partials.patch removed from -mm tree
Message-ID: <20210909210054.VBsTYQXBo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: move irq control into unfreeze_partials()
has been removed from the -mm tree.  Its filename was
     mm-slub-move-irq-control-into-unfreeze_partials.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: move irq control into unfreeze_partials()

unfreeze_partials() can be optimized so that it doesn't need irqs disabled
for the whole time.  As the first step, move irq control into the function
and remove it from the put_cpu_partial() caller.

Link: https://lkml.kernel.org/r/20210904105003.11688-22-vbabka@suse.cz
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

 mm/slub.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/slub.c~mm-slub-move-irq-control-into-unfreeze_partials
+++ a/mm/slub.c
@@ -2350,9 +2350,8 @@ redo:
 /*
  * Unfreeze all the cpu partial slabs.
  *
- * This function must be called with interrupts disabled
- * for the cpu using c (or some other guarantee must be there
- * to guarantee no concurrent accesses).
+ * This function must be called with preemption or migration
+ * disabled with c local to the cpu.
  */
 static void unfreeze_partials(struct kmem_cache *s,
 		struct kmem_cache_cpu *c)
@@ -2360,6 +2359,9 @@ static void unfreeze_partials(struct kme
 #ifdef CONFIG_SLUB_CPU_PARTIAL
 	struct kmem_cache_node *n = NULL, *n2 = NULL;
 	struct page *page, *discard_page = NULL;
+	unsigned long flags;
+
+	local_irq_save(flags);
 
 	while ((page = slub_percpu_partial(c))) {
 		struct page new;
@@ -2412,6 +2414,8 @@ static void unfreeze_partials(struct kme
 		discard_slab(s, page);
 		stat(s, FREE_SLAB);
 	}
+
+	local_irq_restore(flags);
 #endif	/* CONFIG_SLUB_CPU_PARTIAL */
 }
 
@@ -2439,14 +2443,11 @@ static void put_cpu_partial(struct kmem_
 			pobjects = oldpage->pobjects;
 			pages = oldpage->pages;
 			if (drain && pobjects > slub_cpu_partial(s)) {
-				unsigned long flags;
 				/*
 				 * partial array is full. Move the existing
 				 * set to the per node partial list.
 				 */
-				local_irq_save(flags);
 				unfreeze_partials(s, this_cpu_ptr(s->cpu_slab));
-				local_irq_restore(flags);
 				oldpage = NULL;
 				pobjects = 0;
 				pages = 0;
_

Patches currently in -mm which might be from vbabka@suse.cz are



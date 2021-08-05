Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F96C4320A
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0745360E53
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhHEXiU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Aug 2021 19:38:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238926AbhHEXiT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Aug 2021 19:38:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4E06610FF;
        Thu,  5 Aug 2021 23:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628206684;
        bh=9XGl3fp6PN0drgBTiYWRljvsozWRIiOteEgcYI2QbC8=;
        h=Date:From:To:Subject:From;
        b=Lg6EfqjdxdGseNKP3gqkP/I0fF/cxi70izReqY5ss2KI7XLzhIdpcvsKh5HT/SLEZ
         jeLX8j3gsQmnYN+P1FpwsTcM4edBu0gDhsAhPxRuo/zsqsfK81Q7AX9u/pk123buTW
         0z2CA7hrRTRtsA6cvXHQPOYQH4dimnbWB41Jz3qQ=
Date:   Thu, 05 Aug 2021 16:38:04 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, tglx@linutronix.de,
        rientjes@google.com, penberg@kernel.org,
        mgorman@techsingularity.net, jannh@google.com,
        iamjoonsoo.kim@lge.com, efault@gmx.de, cl@linux.com,
        brouer@redhat.com, bigeasy@linutronix.de
Subject:  +
 =?us-ascii?Q?mm-slub-move-flush=5Fcpu=5Fslab-invocations-=5F=5Ffree=5Fs?=
 =?us-ascii?Q?lab-invocations-out-of-irq-context.patch?= added to -mm tree
Message-ID: <20210805233804.DQO-v%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slub: move flush_cpu_slab() invocations __free_slab() invocations out of IRQ context
has been added to the -mm tree.  Its filename is
     mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm: slub: move flush_cpu_slab() invocations __free_slab() invocations out of IRQ context

flush_all() flushes a specific SLAB cache on each CPU (where the cache is
present).  The deactivate_slab()/__free_slab() invocation happens within
IPI handler and is problematic for PREEMPT_RT.

The flush operation is not a frequent operation or a hot path.  The
per-CPU flush operation can be moved to within a workqueue.

[vbabka@suse.cz: adapt to new SLUB changes]
Link: https://lkml.kernel.org/r/20210805152000.12817-30-vbabka@suse.cz
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   56 ++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 48 insertions(+), 8 deletions(-)

--- a/mm/slub.c~mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context
+++ a/mm/slub.c
@@ -2516,33 +2516,73 @@ static inline void __flush_cpu_slab(stru
 	unfreeze_partials_cpu(s, c);
 }
 
+struct slub_flush_work {
+	struct work_struct work;
+	struct kmem_cache *s;
+	bool skip;
+};
+
 /*
  * Flush cpu slab.
  *
- * Called from IPI handler with interrupts disabled.
+ * Called from CPU work handler with migration disabled.
  */
-static void flush_cpu_slab(void *d)
+static void flush_cpu_slab(struct work_struct *w)
 {
-	struct kmem_cache *s = d;
-	struct kmem_cache_cpu *c = this_cpu_ptr(s->cpu_slab);
+	struct kmem_cache *s;
+	struct kmem_cache_cpu *c;
+	struct slub_flush_work *sfw;
+
+	sfw = container_of(w, struct slub_flush_work, work);
+
+	s = sfw->s;
+	c = this_cpu_ptr(s->cpu_slab);
 
 	if (c->page)
-		flush_slab(s, c, false);
+		flush_slab(s, c, true);
 
 	unfreeze_partials(s);
 }
 
-static bool has_cpu_slab(int cpu, void *info)
+static bool has_cpu_slab(int cpu, struct kmem_cache *s)
 {
-	struct kmem_cache *s = info;
 	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
 
 	return c->page || slub_percpu_partial(c);
 }
 
+static DEFINE_MUTEX(flush_lock);
+static DEFINE_PER_CPU(struct slub_flush_work, slub_flush);
+
 static void flush_all(struct kmem_cache *s)
 {
-	on_each_cpu_cond(has_cpu_slab, flush_cpu_slab, s, 1);
+	struct slub_flush_work *sfw;
+	unsigned int cpu;
+
+	mutex_lock(&flush_lock);
+	cpus_read_lock();
+
+	for_each_online_cpu(cpu) {
+		sfw = &per_cpu(slub_flush, cpu);
+		if (!has_cpu_slab(cpu, s)) {
+			sfw->skip = true;
+			continue;
+		}
+		INIT_WORK(&sfw->work, flush_cpu_slab);
+		sfw->skip = false;
+		sfw->s = s;
+		schedule_work_on(cpu, &sfw->work);
+	}
+
+	for_each_online_cpu(cpu) {
+		sfw = &per_cpu(slub_flush, cpu);
+		if (sfw->skip)
+			continue;
+		flush_work(&sfw->work);
+	}
+
+	cpus_read_unlock();
+	mutex_unlock(&flush_lock);
 }
 
 /*
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context.patch
mm-slub-make-object_map_lock-a-raw_spinlock_t.patch


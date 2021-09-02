Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B406C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B2E16112E
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347646AbhIBVw4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:52:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347639AbhIBVwz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:52:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 307B761100;
        Thu,  2 Sep 2021 21:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619516;
        bh=flgnQuIxQIGJ0p3xJ/osHdIXE/jEAiU80A58JgRLrlk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zqO7jUbxlZK8jj+kNScpZ3HVe5IHF1k80vhY7/iXOFpF3U0jxykhtGqTUFGhrQfoh
         vqmrZ5tfJy6aDGTBP76VAK/II0JlDyuFV1TlGBs5hhaynHZJcyA6Cb+IbEamtvaKxG
         0TVzC1LV2zD+6TgNVf7r8tnzJSzTy9QQWHyF25lA=
Date:   Thu, 02 Sep 2021 14:51:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 037/212] mm: slub: move flush_cpu_slab()
 invocations __free_slab() invocations out of IRQ context
Message-ID: <20210902215155.g84iWYhbd%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm: slub: move flush_cpu_slab() invocations __free_slab() invocations out of IRQ context

flush_all() flushes a specific SLAB cache on each CPU (where the cache is
present).  The deactivate_slab()/__free_slab() invocation happens within
IPI handler and is problematic for PREEMPT_RT.

The flush operation is not a frequent operation or a hot path.  The
per-CPU flush operation can be moved to within a workqueue.

[vbabka@suse.cz: adapt to new SLUB changes]
[vbabka@suse.cz: fix memory and cpu hotplug related lock ordering issues]
  Link: https://lkml.kernel.org/r/50fe26ba-450b-af57-506d-438f67cfbce3@suse.cz
[vbabka@suse.cz: make __kmem_cache_do_shrink static]
  Link: https://lkml.kernel.org/r/60e50d8c-ccfa-1036-5a03-2b1a9d25f958@suse.cz
Link: https://lkml.kernel.org/r/20210805152000.12817-30-vbabka@suse.cz
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Qian Cai <quic_qiancai@quicinc.com>
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

 mm/slab_common.c |    2 +
 mm/slub.c        |   79 +++++++++++++++++++++++++++++++++++++--------
 2 files changed, 68 insertions(+), 13 deletions(-)

--- a/mm/slab_common.c~mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context
+++ a/mm/slab_common.c
@@ -502,6 +502,7 @@ void kmem_cache_destroy(struct kmem_cach
 	if (unlikely(!s))
 		return;
 
+	cpus_read_lock();
 	mutex_lock(&slab_mutex);
 
 	s->refcount--;
@@ -516,6 +517,7 @@ void kmem_cache_destroy(struct kmem_cach
 	}
 out_unlock:
 	mutex_unlock(&slab_mutex);
+	cpus_read_unlock();
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
 
--- a/mm/slub.c~mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context
+++ a/mm/slub.c
@@ -2516,33 +2516,79 @@ static inline void __flush_cpu_slab(stru
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
+static void flush_all_cpus_locked(struct kmem_cache *s)
+{
+	struct slub_flush_work *sfw;
+	unsigned int cpu;
+
+	lockdep_assert_cpus_held();
+	mutex_lock(&flush_lock);
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
+	mutex_unlock(&flush_lock);
+}
+
 static void flush_all(struct kmem_cache *s)
 {
-	on_each_cpu_cond(has_cpu_slab, flush_cpu_slab, s, 1);
+	cpus_read_lock();
+	flush_all_cpus_locked(s);
+	cpus_read_unlock();
 }
 
 /*
@@ -4087,7 +4133,7 @@ int __kmem_cache_shutdown(struct kmem_ca
 	int node;
 	struct kmem_cache_node *n;
 
-	flush_all(s);
+	flush_all_cpus_locked(s);
 	/* Attempt to free all objects */
 	for_each_kmem_cache_node(s, node, n) {
 		free_partial(s, n);
@@ -4363,7 +4409,7 @@ EXPORT_SYMBOL(kfree);
  * being allocated from last increasing the chance that the last objects
  * are freed in them.
  */
-int __kmem_cache_shrink(struct kmem_cache *s)
+static int __kmem_cache_do_shrink(struct kmem_cache *s)
 {
 	int node;
 	int i;
@@ -4375,7 +4421,6 @@ int __kmem_cache_shrink(struct kmem_cach
 	unsigned long flags;
 	int ret = 0;
 
-	flush_all(s);
 	for_each_kmem_cache_node(s, node, n) {
 		INIT_LIST_HEAD(&discard);
 		for (i = 0; i < SHRINK_PROMOTE_MAX; i++)
@@ -4425,13 +4470,21 @@ int __kmem_cache_shrink(struct kmem_cach
 	return ret;
 }
 
+int __kmem_cache_shrink(struct kmem_cache *s)
+{
+	flush_all(s);
+	return __kmem_cache_do_shrink(s);
+}
+
 static int slab_mem_going_offline_callback(void *arg)
 {
 	struct kmem_cache *s;
 
 	mutex_lock(&slab_mutex);
-	list_for_each_entry(s, &slab_caches, list)
-		__kmem_cache_shrink(s);
+	list_for_each_entry(s, &slab_caches, list) {
+		flush_all_cpus_locked(s);
+		__kmem_cache_do_shrink(s);
+	}
 	mutex_unlock(&slab_mutex);
 
 	return 0;
_

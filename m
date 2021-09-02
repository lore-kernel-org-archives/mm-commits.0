Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94A7C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90445610A0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236182AbhIBVKc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232087AbhIBVKc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:10:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57ADA60FC4;
        Thu,  2 Sep 2021 21:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630616973;
        bh=/PqBaWCTjr16hA7iFrRpgSLePE6HD4rL950W6zFwuN4=;
        h=Date:From:To:Subject:From;
        b=AOXzzylgHz0vTNzDaU+ppCFwtKaEnZeI9/Qkhys6JzJ4qTwg6hn2nvENVquLuce/i
         d+FvxyCK72SCZy2jyWrZi+4OEl/juT5nSBZtbLqoClywnkebQ3OHw0VkC0seJr1UYg
         iQUBwvtMXFe7EqbbtBdR6Ld4PnB++gJVteehhxWY=
Date:   Thu, 02 Sep 2021 14:09:32 -0700
From:   akpm@linux-foundation.org
To:     efault@gmx.de, mm-commits@vger.kernel.org,
        quic_qiancai@quicinc.com, vbabka@suse.cz
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-slub-move-flush=5Fcpu=5Fslab-invocations-=5F=5Ffree=5Fs?=
 =?US-ASCII?Q?lab-invocations-out-of-irq-context-fix.patch?= removed from
 -mm tree
Message-ID: <20210902210932.UfQnTqXgb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: fix memory and cpu hotplug related lock ordering issues
has been removed from the -mm tree.  Its filename was
     mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context-fix.patch

This patch was dropped because it was folded into mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: fix memory and cpu hotplug related lock ordering issues

Qian Cai reported [1] a lockdep splat on memory offline.

[   91.374541] WARNING: possible circular locking dependency detected
[   91.381411] 5.14.0-rc5-next-20210809+ #84 Not tainted
[   91.387149] ------------------------------------------------------
[   91.394016] lsbug/1523 is trying to acquire lock:
[   91.399406] ffff800018e76530 (flush_lock){+.+.}-{3:3}, at: flush_all+0x50/0x1c8
[   91.407425] but task is already holding lock:
[   91.414638] ffff800018e48468 (slab_mutex){+.+.}-{3:3}, at: slab_memory_callback+0x44/0x280
[   91.423603] which lock already depends on the new lock.

To fix it, we need to change the order in flush_all() so that
cpus_read_lock() is first and mutex_lock(&flush_lock) second.

Also when called from slab_mem_going_offline_callback() we are already
under cpus_read_lock() and cannot take it again, so create a
flush_all_cpus_locked() variant and decouple flushing from actual
shrinking for this call path.

Additionally, Mike Galbraith reported [2] wrong order of cpus_read_lock()
and slab_mutex in kmem_cache_destroy() path and proposed a fix to reverse
it.

This patch is a fixup for the mmotm patch
mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context.patch

[1] https://lore.kernel.org/lkml/0b36128c-3e12-77df-85fe-a153a714569b@quicinc.com/
[2] https://lore.kernel.org/lkml/2eb3cf340716c40f03a0a342ab40219b3d1de195.camel@gmx.de/

Link: https://lkml.kernel.org/r/50fe26ba-450b-af57-506d-438f67cfbce3@suse.cz
Reported-by: Qian Cai <quic_qiancai@quicinc.com>
Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    2 ++
 mm/slub.c        |   29 +++++++++++++++++++++--------
 2 files changed, 23 insertions(+), 8 deletions(-)

--- a/mm/slab_common.c~mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context-fix
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
 
--- a/mm/slub.c~mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context-fix
+++ a/mm/slub.c
@@ -2554,13 +2554,13 @@ static bool has_cpu_slab(int cpu, struct
 static DEFINE_MUTEX(flush_lock);
 static DEFINE_PER_CPU(struct slub_flush_work, slub_flush);
 
-static void flush_all(struct kmem_cache *s)
+static void flush_all_cpus_locked(struct kmem_cache *s)
 {
 	struct slub_flush_work *sfw;
 	unsigned int cpu;
 
+	lockdep_assert_cpus_held();
 	mutex_lock(&flush_lock);
-	cpus_read_lock();
 
 	for_each_online_cpu(cpu) {
 		sfw = &per_cpu(slub_flush, cpu);
@@ -2581,10 +2581,16 @@ static void flush_all(struct kmem_cache
 		flush_work(&sfw->work);
 	}
 
-	cpus_read_unlock();
 	mutex_unlock(&flush_lock);
 }
 
+static void flush_all(struct kmem_cache *s)
+{
+	cpus_read_lock();
+	flush_all_cpus_locked(s);
+	cpus_read_unlock();
+}
+
 /*
  * Use the cpu notifier to insure that the cpu slabs are flushed when
  * necessary.
@@ -4127,7 +4133,7 @@ int __kmem_cache_shutdown(struct kmem_ca
 	int node;
 	struct kmem_cache_node *n;
 
-	flush_all(s);
+	flush_all_cpus_locked(s);
 	/* Attempt to free all objects */
 	for_each_kmem_cache_node(s, node, n) {
 		free_partial(s, n);
@@ -4403,7 +4409,7 @@ EXPORT_SYMBOL(kfree);
  * being allocated from last increasing the chance that the last objects
  * are freed in them.
  */
-int __kmem_cache_shrink(struct kmem_cache *s)
+int __kmem_cache_do_shrink(struct kmem_cache *s)
 {
 	int node;
 	int i;
@@ -4415,7 +4421,6 @@ int __kmem_cache_shrink(struct kmem_cach
 	unsigned long flags;
 	int ret = 0;
 
-	flush_all(s);
 	for_each_kmem_cache_node(s, node, n) {
 		INIT_LIST_HEAD(&discard);
 		for (i = 0; i < SHRINK_PROMOTE_MAX; i++)
@@ -4465,13 +4470,21 @@ int __kmem_cache_shrink(struct kmem_cach
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

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-dont-call-flush_all-from-slab_debug_trace_open.patch
mm-slub-allocate-private-object-map-for-debugfs-listings.patch
mm-slub-allocate-private-object-map-for-validate_slab_cache.patch
mm-slub-dont-disable-irq-for-debug_check_no_locks_freed.patch
mm-slub-remove-redundant-unfreeze_partials-from-put_cpu_partial.patch
mm-slub-unify-cmpxchg_double_slab-and-__cmpxchg_double_slab.patch
mm-slub-extract-get_partial-from-new_slab_objects.patch
mm-slub-dissolve-new_slab_objects-into-___slab_alloc.patch
mm-slub-return-slab-page-from-get_partial-and-set-c-page-afterwards.patch
mm-slub-restructure-new-page-checks-in-___slab_alloc.patch
mm-slub-simplify-kmem_cache_cpu-and-tid-setup.patch
mm-slub-move-disabling-enabling-irqs-to-___slab_alloc.patch
mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled.patch
mm-slub-move-disabling-irqs-closer-to-get_partial-in-___slab_alloc.patch
mm-slub-restore-irqs-around-calling-new_slab.patch
mm-slub-validate-slab-from-partial-list-or-page-allocator-before-making-it-cpu-slab.patch
mm-slub-check-new-pages-with-restored-irqs.patch
mm-slub-stop-disabling-irqs-around-get_partial.patch
mm-slub-move-reset-of-c-page-and-freelist-out-of-deactivate_slab.patch
mm-slub-make-locking-in-deactivate_slab-irq-safe.patch
mm-slub-call-deactivate_slab-without-disabling-irqs.patch
mm-slub-move-irq-control-into-unfreeze_partials.patch
mm-slub-discard-slabs-in-unfreeze_partials-without-irqs-disabled.patch
mm-slub-detach-whole-partial-list-at-once-in-unfreeze_partials.patch
mm-slub-separate-detaching-of-partial-list-in-unfreeze_partials-from-unfreezing.patch
mm-slub-only-disable-irq-with-spin_lock-in-__unfreeze_partials.patch
mm-slub-dont-disable-irqs-in-slub_cpu_dead.patch
mm-slab-make-flush_slab-possible-to-call-with-irqs-enabled.patch
mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context.patch
mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context-fix-2.patch
mm-slub-optionally-save-restore-irqs-in-slab_lock.patch
mm-slub-make-slab_lock-disable-irqs-with-preempt_rt.patch
mm-slub-protect-put_cpu_partial-with-disabled-irqs-instead-of-cmpxchg.patch
mm-slub-use-migrate_disable-on-preempt_rt.patch
mm-slub-convert-kmem_cpu_slab-protection-to-local_lock.patch
mm-slub-convert-kmem_cpu_slab-protection-to-local_lock-fix.patch
mm-slub-convert-kmem_cpu_slab-protection-to-local_lock-fix-2.patch
mm-vmscan-guarantee-drop_slab_node-termination.patch
mm-vmscan-guarantee-drop_slab_node-termination-fix.patch


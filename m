From: akpm@linux-foundation.org
Subject: + blk-mq-use-__smp_call_function_single-directly.patch added to
 -mm tree
Date: Fri, 01 Nov 2013 14:58:22 -0700
Message-ID: <527423fe.ESzrlx2NzFQ8wbnQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54843 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab3KAV6X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Nov 2013 17:58:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de, axboe@kernel.dk, hch@infradead.org

Subject: + blk-mq-use-__smp_call_function_single-directly.patch added to -mm tree
To: hch@infradead.org,axboe@kernel.dk,hch@lst.de,jack@suse.cz
From: akpm@linux-foundation.org
Date: Fri, 01 Nov 2013 14:58:22 -0700


The patch titled
     Subject: blk-mq: use __smp_call_function_single directly
has been added to the -mm tree.  Its filename is
     blk-mq-use-__smp_call_function_single-directly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/blk-mq-use-__smp_call_function_single-directly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/blk-mq-use-__smp_call_function_single-directly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@infradead.org>
Subject: blk-mq: use __smp_call_function_single directly

Now that __smp_call_function_single is available for all builds and uses
llists to queue up items without taking a lock or disabling interrupts
there is no need to wrap around it in the block code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-mq-cpu.c |   31 -------------------
 block/blk-mq.c     |   68 ++++++-------------------------------------
 block/blk-mq.h     |    1 
 3 files changed, 11 insertions(+), 89 deletions(-)

diff -puN block/blk-mq-cpu.c~blk-mq-use-__smp_call_function_single-directly block/blk-mq-cpu.c
--- a/block/blk-mq-cpu.c~blk-mq-use-__smp_call_function_single-directly
+++ a/block/blk-mq-cpu.c
@@ -28,32 +28,6 @@ static int __cpuinit blk_mq_main_cpu_not
 	return NOTIFY_OK;
 }
 
-static void __cpuinit blk_mq_cpu_notify(void *data, unsigned long action,
-					unsigned int cpu)
-{
-	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
-		/*
-		 * If the CPU goes away, ensure that we run any pending
-		 * completions.
-		 */
-		struct llist_node *node;
-		struct request *rq;
-
-		local_irq_disable();
-
-		node = llist_del_all(&per_cpu(ipi_lists, cpu));
-		while (node) {
-			struct llist_node *next = node->next;
-
-			rq = llist_entry(node, struct request, ll_list);
-			__blk_mq_end_io(rq, rq->errors);
-			node = next;
-		}
-
-		local_irq_enable();
-	}
-}
-
 static struct notifier_block __cpuinitdata blk_mq_main_cpu_notifier = {
 	.notifier_call	= blk_mq_main_cpu_notify,
 };
@@ -82,12 +56,7 @@ void blk_mq_init_cpu_notifier(struct blk
 	notifier->data = data;
 }
 
-static struct blk_mq_cpu_notifier __cpuinitdata cpu_notifier = {
-	.notify = blk_mq_cpu_notify,
-};
-
 void __init blk_mq_cpu_init(void)
 {
 	register_hotcpu_notifier(&blk_mq_main_cpu_notifier);
-	blk_mq_register_cpu_notifier(&cpu_notifier);
 }
diff -puN block/blk-mq.c~blk-mq-use-__smp_call_function_single-directly block/blk-mq.c
--- a/block/blk-mq.c~blk-mq-use-__smp_call_function_single-directly
+++ a/block/blk-mq.c
@@ -27,8 +27,6 @@ static LIST_HEAD(all_q_list);
 
 static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx);
 
-DEFINE_PER_CPU(struct llist_head, ipi_lists);
-
 static struct blk_mq_ctx *__blk_mq_get_ctx(struct request_queue *q,
 					   unsigned int cpu)
 {
@@ -319,55 +317,12 @@ void __blk_mq_end_io(struct request *rq,
 		blk_mq_complete_request(rq, error);
 }
 
-#if defined(CONFIG_SMP)
-
-/*
- * Called with interrupts disabled.
- */
-static void ipi_end_io(void *data)
+static void blk_mq_end_io_remote(void *data)
 {
-	struct llist_head *list = &per_cpu(ipi_lists, smp_processor_id());
-	struct llist_node *entry, *next;
-	struct request *rq;
-
-	entry = llist_del_all(list);
-
-	while (entry) {
-		next = entry->next;
-		rq = llist_entry(entry, struct request, ll_list);
-		__blk_mq_end_io(rq, rq->errors);
-		entry = next;
-	}
-}
-
-static int ipi_remote_cpu(struct blk_mq_ctx *ctx, const int cpu,
-			  struct request *rq, const int error)
-{
-	struct call_single_data *data = &rq->csd;
-
-	rq->errors = error;
-	rq->ll_list.next = NULL;
-
-	/*
-	 * If the list is non-empty, an existing IPI must already
-	 * be "in flight". If that is the case, we need not schedule
-	 * a new one.
-	 */
-	if (llist_add(&rq->ll_list, &per_cpu(ipi_lists, ctx->cpu))) {
-		data->func = ipi_end_io;
-		data->flags = 0;
-		__smp_call_function_single(ctx->cpu, data, 0);
-	}
+	struct request *rq = data;
 
-	return true;
+	__blk_mq_end_io(rq, rq->errors);
 }
-#else /* CONFIG_SMP */
-static int ipi_remote_cpu(struct blk_mq_ctx *ctx, const int cpu,
-			  struct request *rq, const int error)
-{
-	return false;
-}
-#endif
 
 /*
  * End IO on this request on a multiqueue enabled driver. We'll either do
@@ -383,11 +338,15 @@ void blk_mq_end_io(struct request *rq, i
 		return __blk_mq_end_io(rq, error);
 
 	cpu = get_cpu();
-
-	if (cpu == ctx->cpu || !cpu_online(ctx->cpu) ||
-	    !ipi_remote_cpu(ctx, cpu, rq, error))
+	if (cpu != ctx->cpu && cpu_online(ctx->cpu)) {
+		rq->errors = error;
+		rq->csd.func = blk_mq_end_io_remote;
+		rq->csd.info = rq;
+		rq->csd.flags = 0;
+		__smp_call_function_single(ctx->cpu, &rq->csd, 0);
+	} else {
 		__blk_mq_end_io(rq, error);
-
+	}
 	put_cpu();
 }
 EXPORT_SYMBOL(blk_mq_end_io);
@@ -1485,11 +1444,6 @@ static int __cpuinit blk_mq_queue_reinit
 
 static int __init blk_mq_init(void)
 {
-	unsigned int i;
-
-	for_each_possible_cpu(i)
-		init_llist_head(&per_cpu(ipi_lists, i));
-
 	blk_mq_cpu_init();
 
 	/* Must be called after percpu_counter_hotcpu_callback() */
diff -puN block/blk-mq.h~blk-mq-use-__smp_call_function_single-directly block/blk-mq.h
--- a/block/blk-mq.h~blk-mq-use-__smp_call_function_single-directly
+++ a/block/blk-mq.h
@@ -38,7 +38,6 @@ void blk_mq_init_cpu_notifier(struct blk
 void blk_mq_register_cpu_notifier(struct blk_mq_cpu_notifier *notifier);
 void blk_mq_unregister_cpu_notifier(struct blk_mq_cpu_notifier *notifier);
 void blk_mq_cpu_init(void);
-DECLARE_PER_CPU(struct llist_head, ipi_lists);
 
 /*
  * CPU -> queue mappings
_

Patches currently in -mm which might be from hch@infradead.org are

hfsplus-add-metadata-files-clump-size-calculation-functionality.patch
hfsplus-implement-attributes-files-header-node-initialization-code.patch
hfsplus-implement-attributes-files-header-node-initialization-code-v2.patch
hfsplus-implement-attributes-file-creation-functionality.patch
hfsplus-implement-attributes-file-creation-functionality-v2.patch
linux-next.patch
revert-softirq-add-support-for-triggering-softirq-work-on-softirqs.patch
kernel-remove-config_use_generic_smp_helpers.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp.patch
kernel-fix-generic_exec_single-indication.patch
llists-move-llist_reverse_order-from-raid5-to-llistc.patch
kernel-use-lockless-list-for-smp_call_function_single.patch
blk-mq-use-__smp_call_function_single-directly.patch


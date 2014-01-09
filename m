From: akpm@linux-foundation.org
Subject: [merged] blk-mq-use-__smp_call_function_single-directly.patch
 removed from -mm tree
Date: Thu, 09 Jan 2014 14:26:40 -0800
Message-ID: <52cf2220./zC9Avner0QgcAl7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaAIW0l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jan 2014 17:26:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de, axboe@kernel.dk, hch@infradead.org

Subject: [merged] blk-mq-use-__smp_call_function_single-directly.patch removed from -mm tree
To: hch@infradead.org,axboe@kernel.dk,hch@lst.de,jack@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 09 Jan 2014 14:26:40 -0800


The patch titled
     Subject: blk-mq: use __smp_call_function_single directly
has been removed from the -mm tree.  Its filename was
     blk-mq-use-__smp_call_function_single-directly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -28,32 +28,6 @@ static int blk_mq_main_cpu_notify(struct
 	return NOTIFY_OK;
 }
 
-static void blk_mq_cpu_notify(void *data, unsigned long action,
-			      unsigned int cpu)
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
@@ -326,55 +324,12 @@ void __blk_mq_end_io(struct request *rq,
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
@@ -390,11 +345,15 @@ void blk_mq_end_io(struct request *rq, i
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
@@ -1495,11 +1454,6 @@ static int blk_mq_queue_reinit_notify(st
 
 static int __init blk_mq_init(void)
 {
-	unsigned int i;
-
-	for_each_possible_cpu(i)
-		init_llist_head(&per_cpu(ipi_lists, i));

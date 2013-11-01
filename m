From: akpm@linux-foundation.org
Subject: + kernel-use-lockless-list-for-smp_call_function_single.patch
 added to -mm tree
Date: Fri, 01 Nov 2013 14:58:21 -0700
Message-ID: <527423fd.cIUJkYgGd8ca9ntL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab3KAV6W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Nov 2013 17:58:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de, axboe@kernel.dk, hch@infradead.org

Subject: + kernel-use-lockless-list-for-smp_call_function_single.patch added to -mm tree
To: hch@infradead.org,axboe@kernel.dk,hch@lst.de,jack@suse.cz
From: akpm@linux-foundation.org
Date: Fri, 01 Nov 2013 14:58:21 -0700


The patch titled
     Subject: kernel: use lockless list for smp_call_function_single
has been added to the -mm tree.  Its filename is
     kernel-use-lockless-list-for-smp_call_function_single.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-use-lockless-list-for-smp_call_function_single.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-use-lockless-list-for-smp_call_function_single.patch

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
Subject: kernel: use lockless list for smp_call_function_single

Make smp_call_function_single and friends more efficient by using
a lockless list.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/blkdev.h |    5 ---
 include/linux/smp.h    |    6 +++-
 kernel/smp.c           |   51 +++++++++------------------------------
 3 files changed, 19 insertions(+), 43 deletions(-)

diff -puN include/linux/blkdev.h~kernel-use-lockless-list-for-smp_call_function_single include/linux/blkdev.h
--- a/include/linux/blkdev.h~kernel-use-lockless-list-for-smp_call_function_single
+++ a/include/linux/blkdev.h
@@ -95,10 +95,7 @@ enum rq_cmd_type_bits {
  * as well!
  */
 struct request {
-	union {
-		struct list_head queuelist;
-		struct llist_node ll_list;
-	};
+	struct list_head queuelist;
 	union {
 		struct call_single_data csd;
 		struct work_struct mq_flush_data;
diff -puN include/linux/smp.h~kernel-use-lockless-list-for-smp_call_function_single include/linux/smp.h
--- a/include/linux/smp.h~kernel-use-lockless-list-for-smp_call_function_single
+++ a/include/linux/smp.h
@@ -11,12 +11,16 @@
 #include <linux/list.h>
 #include <linux/cpumask.h>
 #include <linux/init.h>
+#include <linux/llist.h>
 
 extern void cpu_idle(void);
 
 typedef void (*smp_call_func_t)(void *info);
 struct call_single_data {
-	struct list_head list;
+	union {
+		struct list_head list;
+		struct llist_node llist;
+	};
 	smp_call_func_t func;
 	void *info;
 	u16 flags;
diff -puN kernel/smp.c~kernel-use-lockless-list-for-smp_call_function_single kernel/smp.c
--- a/kernel/smp.c~kernel-use-lockless-list-for-smp_call_function_single
+++ a/kernel/smp.c
@@ -28,12 +28,7 @@ struct call_function_data {
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_function_data, cfd_data);
 
-struct call_single_queue {
-	struct list_head	list;
-	raw_spinlock_t		lock;
-};
-
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_single_queue, call_single_queue);
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct llist_head, call_single_queue);
 
 static int
 hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
@@ -85,12 +80,8 @@ void __init call_function_init(void)
 	void *cpu = (void *)(long)smp_processor_id();
 	int i;
 
-	for_each_possible_cpu(i) {
-		struct call_single_queue *q = &per_cpu(call_single_queue, i);
-
-		raw_spin_lock_init(&q->lock);
-		INIT_LIST_HEAD(&q->list);
-	}
+	for_each_possible_cpu(i)
+		init_llist_head(&per_cpu(call_single_queue, i));
 
 	hotplug_cfd(&hotplug_cfd_notifier, CPU_UP_PREPARE, cpu);
 	register_cpu_notifier(&hotplug_cfd_notifier);
@@ -141,18 +132,9 @@ static void csd_unlock(struct call_singl
  */
 static void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
 {
-	struct call_single_queue *dst = &per_cpu(call_single_queue, cpu);
-	unsigned long flags;
-	int ipi;
-
 	if (wait)
 		csd->flags |= CSD_FLAG_WAIT;
 
-	raw_spin_lock_irqsave(&dst->lock, flags);
-	ipi = list_empty(&dst->list);
-	list_add_tail(&csd->list, &dst->list);
-	raw_spin_unlock_irqrestore(&dst->lock, flags);
-
 	/*
 	 * The list addition should be visible before sending the IPI
 	 * handler locks the list to pull the entry off it because of
@@ -164,7 +146,7 @@ static void generic_exec_single(int cpu,
 	 * locking and barrier primitives. Generic code isn't really
 	 * equipped to do the right thing...
 	 */
-	if (ipi)
+	if (llist_add(&csd->llist, &per_cpu(call_single_queue, cpu)))
 		arch_send_call_function_single_ipi(cpu);
 
 	if (wait)
@@ -177,27 +159,26 @@ static void generic_exec_single(int cpu,
  */
 void generic_smp_call_function_single_interrupt(void)
 {
-	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
-	LIST_HEAD(list);
+	struct llist_node *entry, *next;
 
 	/*
 	 * Shouldn't receive this interrupt on a cpu that is not yet online.
 	 */
 	WARN_ON_ONCE(!cpu_online(smp_processor_id()));
 
-	raw_spin_lock(&q->lock);
-	list_replace_init(&q->list, &list);
-	raw_spin_unlock(&q->lock);
+	entry = llist_del_all(&__get_cpu_var(call_single_queue));
+	entry = llist_reverse_order(entry);
 
-	while (!list_empty(&list)) {
+	while (entry) {
 		struct call_single_data *csd;
 
-		csd = list_entry(list.next, struct call_single_data, list);
-		list_del(&csd->list);
+		next = entry->next;
 
+		csd = llist_entry(entry, struct call_single_data, llist);
 		csd->func(csd->info);
-
 		csd_unlock(csd);
+
+		entry = next;
 	}
 }
 
@@ -411,17 +392,11 @@ void smp_call_function_many(const struct
 
 	for_each_cpu(cpu, cfd->cpumask) {
 		struct call_single_data *csd = per_cpu_ptr(cfd->csd, cpu);
-		struct call_single_queue *dst =
-					&per_cpu(call_single_queue, cpu);
-		unsigned long flags;
 
 		csd_lock(csd);
 		csd->func = func;
 		csd->info = info;
-
-		raw_spin_lock_irqsave(&dst->lock, flags);
-		list_add_tail(&csd->list, &dst->list);
-		raw_spin_unlock_irqrestore(&dst->lock, flags);
+		llist_add(&csd->llist, &per_cpu(call_single_queue, cpu));
 	}
 
 	/* Send a message to all CPUs in the map */
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


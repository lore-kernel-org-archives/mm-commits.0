From: akpm@linux-foundation.org
Subject: - percpu_counter-fbc_batch-should-be-a-variable.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:15:56 -0800
Message-ID: <200901072215.n07MFuDw015661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757121AbZAGWQM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, a.p.zijlstra@chello.nl, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     percpu_counter: FBC_BATCH should be a variable
has been removed from the -mm tree.  Its filename was
     percpu_counter-fbc_batch-should-be-a-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: percpu_counter: FBC_BATCH should be a variable
From: Eric Dumazet <dada1@cosmosbay.com>

For NR_CPUS >= 16 values, FBC_BATCH is 2*NR_CPUS

Considering more and more distros are using high NR_CPUS values, it makes
sense to use a more sensible value for FBC_BATCH, and get rid of NR_CPUS.

A sensible value is 2*num_online_cpus(), with a minimum value of 32 (This
minimum value helps branch prediction in __percpu_counter_add())

We already have a hotcpu notifier, so we can adjust FBC_BATCH dynamically.

We rename FBC_BATCH to percpu_counter_batch since its not a constant
anymore.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/ext4.h                 |    6 +++---
 fs/ext4/inode.c                |    2 +-
 include/linux/percpu_counter.h |    8 ++------
 lib/percpu_counter.c           |   18 ++++++++++++++----
 4 files changed, 20 insertions(+), 14 deletions(-)

diff -puN fs/ext4/ext4.h~percpu_counter-fbc_batch-should-be-a-variable fs/ext4/ext4.h
--- a/fs/ext4/ext4.h~percpu_counter-fbc_batch-should-be-a-variable
+++ a/fs/ext4/ext4.h
@@ -1225,11 +1225,11 @@ do {								\
 } while (0)
 
 #ifdef CONFIG_SMP
-/* Each CPU can accumulate FBC_BATCH blocks in their local
+/* Each CPU can accumulate percpu_counter_batch blocks in their local
  * counters. So we need to make sure we have free blocks more
- * than FBC_BATCH  * nr_cpu_ids. Also add a window of 4 times.
+ * than percpu_counter_batch  * nr_cpu_ids. Also add a window of 4 times.
  */
-#define EXT4_FREEBLOCKS_WATERMARK (4 * (FBC_BATCH * nr_cpu_ids))
+#define EXT4_FREEBLOCKS_WATERMARK (4 * (percpu_counter_batch * nr_cpu_ids))
 #else
 #define EXT4_FREEBLOCKS_WATERMARK 0
 #endif
diff -puN fs/ext4/inode.c~percpu_counter-fbc_batch-should-be-a-variable fs/ext4/inode.c
--- a/fs/ext4/inode.c~percpu_counter-fbc_batch-should-be-a-variable
+++ a/fs/ext4/inode.c
@@ -2498,7 +2498,7 @@ static int ext4_nonda_switch(struct supe
 	/*
 	 * switch to non delalloc mode if we are running low
 	 * on free block. The free block accounting via percpu
-	 * counters can get slightly wrong with FBC_BATCH getting
+	 * counters can get slightly wrong with percpu_counter_batch getting
 	 * accumulated on each CPU without updating global counters
 	 * Delalloc need an accurate free block accounting. So switch
 	 * to non delalloc when we are near to error range.
diff -puN include/linux/percpu_counter.h~percpu_counter-fbc_batch-should-be-a-variable include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~percpu_counter-fbc_batch-should-be-a-variable
+++ a/include/linux/percpu_counter.h
@@ -24,11 +24,7 @@ struct percpu_counter {
 	s32 *counters;
 };
 
-#if NR_CPUS >= 16
-#define FBC_BATCH	(NR_CPUS*2)
-#else
-#define FBC_BATCH	(NR_CPUS*4)
-#endif
+extern int percpu_counter_batch;
 
 int percpu_counter_init(struct percpu_counter *fbc, s64 amount);
 int percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount);
@@ -39,7 +35,7 @@ s64 __percpu_counter_sum(struct percpu_c
 
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
-	__percpu_counter_add(fbc, amount, FBC_BATCH);
+	__percpu_counter_add(fbc, amount, percpu_counter_batch);
 }
 
 static inline s64 percpu_counter_sum_positive(struct percpu_counter *fbc)
diff -puN lib/percpu_counter.c~percpu_counter-fbc_batch-should-be-a-variable lib/percpu_counter.c
--- a/lib/percpu_counter.c~percpu_counter-fbc_batch-should-be-a-variable
+++ a/lib/percpu_counter.c
@@ -9,10 +9,8 @@
 #include <linux/cpu.h>
 #include <linux/module.h>
 
-#ifdef CONFIG_HOTPLUG_CPU
 static LIST_HEAD(percpu_counters);
 static DEFINE_MUTEX(percpu_counters_lock);
-#endif
 
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 {
@@ -111,13 +109,24 @@ void percpu_counter_destroy(struct percp
 }
 EXPORT_SYMBOL(percpu_counter_destroy);
 
-#ifdef CONFIG_HOTPLUG_CPU
+int percpu_counter_batch __read_mostly = 32;
+EXPORT_SYMBOL(percpu_counter_batch);
+
+static void compute_batch_value(void)
+{
+	int nr = num_online_cpus();
+
+	percpu_counter_batch = max(32, nr*2);
+}
+
 static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
 					unsigned long action, void *hcpu)
 {
+#ifdef CONFIG_HOTPLUG_CPU
 	unsigned int cpu;
 	struct percpu_counter *fbc;
 
+	compute_batch_value();
 	if (action != CPU_DEAD)
 		return NOTIFY_OK;
 
@@ -134,13 +143,14 @@ static int __cpuinit percpu_counter_hotc
 		spin_unlock_irqrestore(&fbc->lock, flags);
 	}
 	mutex_unlock(&percpu_counters_lock);
+#endif
 	return NOTIFY_OK;
 }
 
 static int __init percpu_counter_startup(void)
 {
+	compute_batch_value();
 	hotcpu_notifier(percpu_counter_hotcpu_callback, 0);
 	return 0;
 }
 module_init(percpu_counter_startup);
-#endif
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch


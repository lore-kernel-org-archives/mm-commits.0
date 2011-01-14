From: akpm@linux-foundation.org
Subject: [merged] irq-use-per_cpu-kstat_irqs.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:44:11 -0800
Message-ID: <201101142247.p0EMl1RW004948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525Ab1ANWrc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:47:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.dumazet@gmail.com, andi@firstfloor.org, cl@linux.com, mingo@elte.hu, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     irq: use per_cpu kstat_irqs
has been removed from the -mm tree.  Its filename was
     irq-use-per_cpu-kstat_irqs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: irq: use per_cpu kstat_irqs
From: Eric Dumazet <eric.dumazet@gmail.com>

Use modern per_cpu API to increment {soft|hard}irq counters, and use
per_cpu allocation for (struct irq_desc)->kstats_irq instead of an array.

This gives better SMP/NUMA locality and saves few instructions per irq.

With small nr_cpuids values (8 for example), kstats_irq was a small array
(less than L1_CACHE_BYTES), potentially source of false sharing.

In the !CONFIG_SPARSE_IRQ case, remove the huge, NUMA/cache unfriendly
kstat_irqs_all[NR_IRQS][NR_CPUS] array.

Note: we still populate kstats_irq for all possible irqs in
early_irq_init().  We probably could use on-demand allocations.  (Code
included in alloc_descs()).  Problem is not all IRQS are used with a prior
alloc_descs() call.

kstat_irqs_this_cpu() is not used anymore, remove it.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irqdesc.h     |    2 -
 include/linux/kernel_stat.h |   19 +++++++---------
 kernel/irq/irqdesc.c        |   40 +++++++++++++++++++++++++---------
 3 files changed, 40 insertions(+), 21 deletions(-)

diff -puN include/linux/irqdesc.h~irq-use-per_cpu-kstat_irqs include/linux/irqdesc.h
--- a/include/linux/irqdesc.h~irq-use-per_cpu-kstat_irqs
+++ a/include/linux/irqdesc.h
@@ -57,7 +57,7 @@ struct irq_desc {
 #endif
 
 	struct timer_rand_state *timer_rand_state;
-	unsigned int		*kstat_irqs;
+	unsigned int __percpu	*kstat_irqs;
 	irq_flow_handler_t	handle_irq;
 	struct irqaction	*action;	/* IRQ action list */
 	unsigned int		status;		/* IRQ status */
diff -puN include/linux/kernel_stat.h~irq-use-per_cpu-kstat_irqs include/linux/kernel_stat.h
--- a/include/linux/kernel_stat.h~irq-use-per_cpu-kstat_irqs
+++ a/include/linux/kernel_stat.h
@@ -46,16 +46,14 @@ DECLARE_PER_CPU(struct kernel_stat, ksta
 extern unsigned long long nr_context_switches(void);
 
 #ifndef CONFIG_GENERIC_HARDIRQS
-#define kstat_irqs_this_cpu(irq) \
-	(this_cpu_read(kstat.irqs[irq])
 
 struct irq_desc;
 
 static inline void kstat_incr_irqs_this_cpu(unsigned int irq,
 					    struct irq_desc *desc)
 {
-	kstat_this_cpu.irqs[irq]++;
-	kstat_this_cpu.irqs_sum++;
+	__this_cpu_inc(kstat.irqs[irq]);
+	__this_cpu_inc(kstat.irqs_sum);
 }
 
 static inline unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
@@ -65,17 +63,18 @@ static inline unsigned int kstat_irqs_cp
 #else
 #include <linux/irq.h>
 extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
-#define kstat_irqs_this_cpu(DESC) \
-	((DESC)->kstat_irqs[smp_processor_id()])
-#define kstat_incr_irqs_this_cpu(irqno, DESC) do {\
-	((DESC)->kstat_irqs[smp_processor_id()]++);\
-	kstat_this_cpu.irqs_sum++; } while (0)
+
+#define kstat_incr_irqs_this_cpu(irqno, DESC)		\
+do {							\
+	__this_cpu_inc(*(DESC)->kstat_irqs);		\
+	__this_cpu_inc(kstat.irqs_sum);			\
+} while (0)
 
 #endif
 
 static inline void kstat_incr_softirqs_this_cpu(unsigned int irq)
 {
-	kstat_this_cpu.softirqs[irq]++;
+	__this_cpu_inc(kstat.softirqs[irq]);
 }
 
 static inline unsigned int kstat_softirqs_cpu(unsigned int irq, int cpu)
diff -puN kernel/irq/irqdesc.c~irq-use-per_cpu-kstat_irqs kernel/irq/irqdesc.c
--- a/kernel/irq/irqdesc.c~irq-use-per_cpu-kstat_irqs
+++ a/kernel/irq/irqdesc.c
@@ -72,6 +72,8 @@ static inline int desc_node(struct irq_d
 
 static void desc_set_defaults(unsigned int irq, struct irq_desc *desc, int node)
 {
+	int cpu;
+
 	desc->irq_data.irq = irq;
 	desc->irq_data.chip = &no_irq_chip;
 	desc->irq_data.chip_data = NULL;
@@ -83,7 +85,8 @@ static void desc_set_defaults(unsigned i
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
 	desc->name = NULL;
-	memset(desc->kstat_irqs, 0, nr_cpu_ids * sizeof(*(desc->kstat_irqs)));
+	for_each_possible_cpu(cpu)
+		*per_cpu_ptr(desc->kstat_irqs, cpu) = 0;
 	desc_smp_init(desc, node);
 }
 
@@ -133,8 +136,7 @@ static struct irq_desc *alloc_desc(int i
 	if (!desc)
 		return NULL;
 	/* allocate based on nr_cpu_ids */
-	desc->kstat_irqs = kzalloc_node(nr_cpu_ids * sizeof(*desc->kstat_irqs),
-					 gfp, node);
+	desc->kstat_irqs = alloc_percpu(unsigned int);
 	if (!desc->kstat_irqs)
 		goto err_desc;
 
@@ -149,7 +151,7 @@ static struct irq_desc *alloc_desc(int i
 	return desc;
 
 err_kstat:
-	kfree(desc->kstat_irqs);
+	free_percpu(desc->kstat_irqs);
 err_desc:
 	kfree(desc);
 	return NULL;
@@ -166,7 +168,7 @@ static void free_desc(unsigned int irq)
 	mutex_unlock(&sparse_irq_lock);
 
 	free_masks(desc);
-	kfree(desc->kstat_irqs);
+	free_percpu(desc->kstat_irqs);
 	kfree(desc);
 }
 
@@ -234,7 +236,6 @@ struct irq_desc irq_desc[NR_IRQS] __cach
 	}
 };
 
-static unsigned int kstat_irqs_all[NR_IRQS][NR_CPUS];
 int __init early_irq_init(void)
 {
 	int count, i, node = first_online_node;
@@ -250,7 +251,8 @@ int __init early_irq_init(void)
 	for (i = 0; i < count; i++) {
 		desc[i].irq_data.irq = i;
 		desc[i].irq_data.chip = &no_irq_chip;
-		desc[i].kstat_irqs = kstat_irqs_all[i];
+		/* TODO : do this allocation on-demand ... */
+		desc[i].kstat_irqs = alloc_percpu(unsigned int);
 		alloc_masks(desc + i, GFP_KERNEL, node);
 		desc_smp_init(desc + i, node);
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
@@ -275,6 +277,22 @@ static void free_desc(unsigned int irq)
 
 static inline int alloc_descs(unsigned int start, unsigned int cnt, int node)
 {
+#if defined(CONFIG_KSTAT_IRQS_ONDEMAND)
+	struct irq_desc *desc;
+	unsigned int i;
+
+	for (i = 0; i < cnt; i++) {
+		desc = irq_to_desc(start + i);
+		if (desc && !desc->kstat_irqs) {
+			unsigned int __percpu *stats = alloc_percpu(unsigned int);
+
+			if (!stats)
+				return -1;
+			if (cmpxchg(&desc->kstat_irqs, NULL, stats) != NULL)
+				free_percpu(stats);
+		}
+	}
+#endif
 	return start;
 }
 #endif /* !CONFIG_SPARSE_IRQ */
@@ -391,7 +409,9 @@ void dynamic_irq_cleanup(unsigned int ir
 unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	return desc ? desc->kstat_irqs[cpu] : 0;
+
+	return desc && desc->kstat_irqs ?
+			*per_cpu_ptr(desc->kstat_irqs, cpu) : 0;
 }
 
 #ifdef CONFIG_GENERIC_HARDIRQS
@@ -401,10 +421,10 @@ unsigned int kstat_irqs(unsigned int irq
 	int cpu;
 	int sum = 0;
 
-	if (!desc)
+	if (!desc || !desc->kstat_irqs)
 		return 0;
 	for_each_possible_cpu(cpu)
-		sum += desc->kstat_irqs[cpu];
+		sum += *per_cpu_ptr(desc->kstat_irqs, cpu);
 	return sum;
 }
 #endif /* CONFIG_GENERIC_HARDIRQS */
_

Patches currently in -mm which might be from eric.dumazet@gmail.com are

origin.patch
mm-numa-aware-alloc_task_struct_node.patch
mm-numa-aware-alloc_thread_info_node.patch
kthread-numa-aware-kthread_create_on_cpu.patch
kthread-use-kthread_create_on_cpu.patch
net-convert-%p-usage-to-%pk.patch


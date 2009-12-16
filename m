From: akpm@linux-foundation.org
Subject: [merged] gru-update-irq-infrastructure.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:40:42 -0800
Message-ID: <200912162040.nBGKegeA013664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965017AbZLPUkp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:40:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: update irq infrastructure
has been removed from the -mm tree.  Its filename was
     gru-update-irq-infrastructure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: update irq infrastructure
From: Jack Steiner <steiner@sgi.com>

Update the GRU irq allocate/free functions to use the latest upstream
infrastructure.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c  |   49 +++--
 drivers/misc/sgi-gru/grufile.c   |  258 +++++++++++++++++++++++------
 drivers/misc/sgi-gru/grumain.c   |    9 -
 drivers/misc/sgi-gru/grutables.h |   14 +
 4 files changed, 260 insertions(+), 70 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-update-irq-infrastructure drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-update-irq-infrastructure
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -134,19 +134,6 @@ static void gru_cb_set_istatus_active(st
 }
 
 /*
- * Convert a interrupt IRQ to a pointer to the GRU GTS that caused the
- * interrupt. Interrupts are always sent to a cpu on the blade that contains the
- * GRU (except for headless blades which are not currently supported). A blade
- * has N grus; a block of N consecutive IRQs is assigned to the GRUs. The IRQ
- * number uniquely identifies the GRU chiplet on the local blade that caused the
- * interrupt. Always called in interrupt context.
- */
-static inline struct gru_state *irq_to_gru(int irq)
-{
-	return &gru_base[uv_numa_blade_id()]->bs_grus[irq - IRQ_GRU];
-}
-
-/*
  * Read & clear a TFM
  *
  * The GRU has an array of fault maps. A map is private to a cpu
@@ -449,7 +436,7 @@ failactive:
  * Note that this is the interrupt handler that is registered with linux
  * interrupt handlers.
  */
-irqreturn_t gru_intr(int irq, void *dev_id)
+static irqreturn_t gru_intr(int chiplet, int blade)
 {
 	struct gru_state *gru;
 	struct gru_tlb_fault_map imap, dmap;
@@ -459,13 +446,18 @@ irqreturn_t gru_intr(int irq, void *dev_
 
 	STAT(intr);
 
-	gru = irq_to_gru(irq);
+	gru = &gru_base[blade]->bs_grus[chiplet];
 	if (!gru) {
-		dev_err(grudev, "GRU: invalid interrupt: cpu %d, irq %d\n",
-			raw_smp_processor_id(), irq);
+		dev_err(grudev, "GRU: invalid interrupt: cpu %d, chiplet %d\n",
+			raw_smp_processor_id(), chiplet);
 		return IRQ_NONE;
 	}
 	get_clear_fault_map(gru, &imap, &dmap);
+	gru_dbg(grudev,
+		"cpu %d, chiplet %d, gid %d, imap %016lx %016lx, dmap %016lx %016lx\n",
+		smp_processor_id(), chiplet, gru->gs_gid,
+		imap.fault_bits[0], imap.fault_bits[1],
+		dmap.fault_bits[0], dmap.fault_bits[1]);
 
 	for_each_cbr_in_tfm(cbrnum, dmap.fault_bits) {
 		complete(gru->gs_blade->bs_async_wq);
@@ -503,6 +495,29 @@ irqreturn_t gru_intr(int irq, void *dev_
 	return IRQ_HANDLED;
 }
 
+irqreturn_t gru0_intr(int irq, void *dev_id)
+{
+	return gru_intr(0, uv_numa_blade_id());
+}
+
+irqreturn_t gru1_intr(int irq, void *dev_id)
+{
+	return gru_intr(1, uv_numa_blade_id());
+}
+
+irqreturn_t gru_intr_mblade(int irq, void *dev_id)
+{
+	int blade;
+
+	for_each_possible_blade(blade) {
+		if (uv_blade_nr_possible_cpus(blade))
+			continue;
+		 gru_intr(0, blade);
+		 gru_intr(1, blade);
+	}
+	return IRQ_HANDLED;
+}
+
 
 static int gru_user_dropin(struct gru_thread_state *gts,
 			   struct gru_tlb_fault_handle *tfh,
diff -puN drivers/misc/sgi-gru/grufile.c~gru-update-irq-infrastructure drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~gru-update-irq-infrastructure
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -35,6 +35,9 @@
 #include <linux/interrupt.h>
 #include <linux/proc_fs.h>
 #include <linux/uaccess.h>
+#ifdef CONFIG_X86_64
+#include <asm/uv/uv_irq.h>
+#endif
 #include <asm/uv/uv.h>
 #include "gru.h"
 #include "grulib.h"
@@ -130,7 +133,6 @@ static int gru_create_new_context(unsign
 	struct gru_vma_data *vdata;
 	int ret = -EINVAL;
 
-
 	if (copy_from_user(&req, (void __user *)arg, sizeof(req)))
 		return -EFAULT;
 
@@ -302,34 +304,210 @@ fail:
 	return -ENOMEM;
 }
 
-#ifdef CONFIG_IA64
+static void gru_free_tables(void)
+{
+	int bid;
+	int order = get_order(sizeof(struct gru_state) *
+			      GRU_CHIPLETS_PER_BLADE);
+
+	for (bid = 0; bid < GRU_MAX_BLADES; bid++)
+		free_pages((unsigned long)gru_base[bid], order);
+}
 
-static int get_base_irq(void)
+static unsigned long gru_chiplet_cpu_to_mmr(int chiplet, int cpu, int *corep)
 {
-	return IRQ_GRU;
+	unsigned long mmr = 0;
+	int core;
+
+	/*
+	 * We target the cores of a blade and not the hyperthreads themselves.
+	 * There is a max of 8 cores per socket and 2 sockets per blade,
+	 * making for a max total of 16 cores (i.e., 16 CPUs without
+	 * hyperthreading and 32 CPUs with hyperthreading).
+	 */
+	core = uv_cpu_core_number(cpu) + UV_MAX_INT_CORES * uv_cpu_socket_number(cpu);
+	if (core >= GRU_NUM_TFM || uv_cpu_ht_number(cpu))
+		return 0;
+
+	if (chiplet == 0) {
+		mmr = UVH_GR0_TLB_INT0_CONFIG +
+		    core * (UVH_GR0_TLB_INT1_CONFIG - UVH_GR0_TLB_INT0_CONFIG);
+	} else if (chiplet == 1) {
+		mmr = UVH_GR1_TLB_INT0_CONFIG +
+		    core * (UVH_GR1_TLB_INT1_CONFIG - UVH_GR1_TLB_INT0_CONFIG);
+	} else {
+		BUG();
+	}
+
+	*corep = core;
+	return mmr;
 }
 
-#elif defined CONFIG_X86_64
+#ifdef CONFIG_IA64
+
+static int gru_irq_count[GRU_CHIPLETS_PER_BLADE];
 
-static void noop(unsigned int irq)
+static void gru_noop(unsigned int irq)
 {
 }
 
-static struct irq_chip gru_chip = {
-	.name		= "gru",
-	.mask		= noop,
-	.unmask		= noop,
-	.ack		= noop,
+static struct irq_chip gru_chip[GRU_CHIPLETS_PER_BLADE] = {
+	[0 ... GRU_CHIPLETS_PER_BLADE - 1] {
+		.mask		= gru_noop,
+		.unmask		= gru_noop,
+		.ack		= gru_noop
+	}
 };
 
-static int get_base_irq(void)
+static int gru_chiplet_setup_tlb_irq(int chiplet, char *irq_name,
+			irq_handler_t irq_handler, int cpu, int blade)
+{
+	unsigned long mmr;
+	int irq = IRQ_GRU + chiplet;
+	int ret, core;
+
+	mmr = gru_chiplet_cpu_to_mmr(chiplet, cpu, &core);
+	if (mmr == 0)
+		return 0;
+
+	if (gru_irq_count[chiplet] == 0) {
+		gru_chip[chiplet].name = irq_name;
+		ret = set_irq_chip(irq, &gru_chip[chiplet]);
+		if (ret) {
+			printk(KERN_ERR "%s: set_irq_chip failed, errno=%d\n",
+			       GRU_DRIVER_ID_STR, -ret);
+			return ret;
+		}
+
+		ret = request_irq(irq, irq_handler, 0, irq_name, NULL);
+		if (ret) {
+			printk(KERN_ERR "%s: request_irq failed, errno=%d\n",
+			       GRU_DRIVER_ID_STR, -ret);
+			return ret;
+		}
+	}
+	gru_irq_count[chiplet]++;
+
+	return 0;
+}
+
+static void gru_chiplet_teardown_tlb_irq(int chiplet, int cpu, int blade)
+{
+	unsigned long mmr;
+	int core, irq = IRQ_GRU + chiplet;
+
+	if (gru_irq_count[chiplet] == 0)
+		return;
+
+	mmr = gru_chiplet_cpu_to_mmr(chiplet, cpu, &core);
+	if (mmr == 0)
+		return;
+
+	if (--gru_irq_count[chiplet] == 0)
+		free_irq(irq, NULL);
+}
+
+#elif defined CONFIG_X86_64
+
+static int gru_chiplet_setup_tlb_irq(int chiplet, char *irq_name,
+			irq_handler_t irq_handler, int cpu, int blade)
+{
+	unsigned long mmr;
+	int irq, core;
+	int ret;
+
+	mmr = gru_chiplet_cpu_to_mmr(chiplet, cpu, &core);
+	if (mmr == 0)
+		return 0;
+
+	irq = uv_setup_irq(irq_name, cpu, blade, mmr, UV_AFFINITY_CPU);
+	if (irq < 0) {
+		printk(KERN_ERR "%s: uv_setup_irq failed, errno=%d\n",
+		       GRU_DRIVER_ID_STR, -irq);
+		return irq;
+	}
+
+	ret = request_irq(irq, irq_handler, 0, irq_name, NULL);
+	if (ret) {
+		uv_teardown_irq(irq);
+		printk(KERN_ERR "%s: request_irq failed, errno=%d\n",
+		       GRU_DRIVER_ID_STR, -ret);
+		return ret;
+	}
+	gru_base[blade]->bs_grus[chiplet].gs_irq[core] = irq;
+	return 0;
+}
+
+static void gru_chiplet_teardown_tlb_irq(int chiplet, int cpu, int blade)
 {
-	set_irq_chip(IRQ_GRU, &gru_chip);
-	set_irq_chip(IRQ_GRU + 1, &gru_chip);
-	return IRQ_GRU;
+	int irq, core;
+	unsigned long mmr;
+
+	mmr = gru_chiplet_cpu_to_mmr(chiplet, cpu, &core);
+	if (mmr) {
+		irq = gru_base[blade]->bs_grus[chiplet].gs_irq[core];
+		if (irq) {
+			free_irq(irq, NULL);
+			uv_teardown_irq(irq);
+		}
+	}
 }
+
 #endif
 
+static void gru_teardown_tlb_irqs(void)
+{
+	int blade;
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		blade = uv_cpu_to_blade_id(cpu);
+		gru_chiplet_teardown_tlb_irq(0, cpu, blade);
+		gru_chiplet_teardown_tlb_irq(1, cpu, blade);
+	}
+	for_each_possible_blade(blade) {
+		if (uv_blade_nr_possible_cpus(blade))
+			continue;
+		gru_chiplet_teardown_tlb_irq(0, 0, blade);
+		gru_chiplet_teardown_tlb_irq(1, 0, blade);
+	}
+}
+
+static int gru_setup_tlb_irqs(void)
+{
+	int blade;
+	int cpu;
+	int ret;
+
+	for_each_online_cpu(cpu) {
+		blade = uv_cpu_to_blade_id(cpu);
+		ret = gru_chiplet_setup_tlb_irq(0, "GRU0_TLB", gru0_intr, cpu, blade);
+		if (ret != 0)
+			goto exit1;
+
+		ret = gru_chiplet_setup_tlb_irq(1, "GRU1_TLB", gru1_intr, cpu, blade);
+		if (ret != 0)
+			goto exit1;
+	}
+	for_each_possible_blade(blade) {
+		if (uv_blade_nr_possible_cpus(blade))
+			continue;
+		ret = gru_chiplet_setup_tlb_irq(0, "GRU0_TLB", gru_intr_mblade, 0, blade);
+		if (ret != 0)
+			goto exit1;
+
+		ret = gru_chiplet_setup_tlb_irq(1, "GRU1_TLB", gru_intr_mblade, 0, blade);
+		if (ret != 0)
+			goto exit1;
+	}
+
+	return 0;
+
+exit1:
+	gru_teardown_tlb_irqs();
+	return ret;
+}
+
 /*
  * gru_init
  *
@@ -337,8 +515,7 @@ static int get_base_irq(void)
  */
 static int __init gru_init(void)
 {
-	int ret, irq, chip;
-	char id[10];
+	int ret;
 
 	if (!is_uv_system())
 		return 0;
@@ -353,41 +530,29 @@ static int __init gru_init(void)
 	gru_end_paddr = gru_start_paddr + GRU_MAX_BLADES * GRU_SIZE;
 	printk(KERN_INFO "GRU space: 0x%lx - 0x%lx\n",
 	       gru_start_paddr, gru_end_paddr);
-	irq = get_base_irq();
-	for (chip = 0; chip < GRU_CHIPLETS_PER_BLADE; chip++) {
-		ret = request_irq(irq + chip, gru_intr, 0, id, NULL);
-		/* TODO: fix irq handling on x86. For now ignore failure because
-		 * interrupts are not required & not yet fully supported */
-		if (ret) {
-			printk(KERN_WARNING
-			       "!!!WARNING: GRU ignoring request failure!!!\n");
-			ret = 0;
-		}
-		if (ret) {
-			printk(KERN_ERR "%s: request_irq failed\n",
-			       GRU_DRIVER_ID_STR);
-			goto exit1;
-		}
-	}
-
 	ret = misc_register(&gru_miscdev);
 	if (ret) {
 		printk(KERN_ERR "%s: misc_register failed\n",
 		       GRU_DRIVER_ID_STR);
-		goto exit1;
+		goto exit0;
 	}
 
 	ret = gru_proc_init();
 	if (ret) {
 		printk(KERN_ERR "%s: proc init failed\n", GRU_DRIVER_ID_STR);
-		goto exit2;
+		goto exit1;
 	}
 
 	ret = gru_init_tables(gru_start_paddr, gru_start_vaddr);
 	if (ret) {
 		printk(KERN_ERR "%s: init tables failed\n", GRU_DRIVER_ID_STR);
-		goto exit3;
+		goto exit2;
 	}
+
+	ret = gru_setup_tlb_irqs();
+	if (ret != 0)
+		goto exit3;
+
 	gru_kservices_init();
 
 	printk(KERN_INFO "%s: v%s\n", GRU_DRIVER_ID_STR,
@@ -395,31 +560,24 @@ static int __init gru_init(void)
 	return 0;
 
 exit3:
-	gru_proc_exit();
+	gru_free_tables();
 exit2:
-	misc_deregister(&gru_miscdev);
+	gru_proc_exit();
 exit1:
-	for (--chip; chip >= 0; chip--)
-		free_irq(irq + chip, NULL);
+	misc_deregister(&gru_miscdev);
+exit0:
 	return ret;
 
 }
 
 static void __exit gru_exit(void)
 {
-	int i, bid;
-	int order = get_order(sizeof(struct gru_state) *
-			      GRU_CHIPLETS_PER_BLADE);
-
 	if (!is_uv_system())
 		return;
 
-	for (i = 0; i < GRU_CHIPLETS_PER_BLADE; i++)
-		free_irq(IRQ_GRU + i, NULL);
+	gru_teardown_tlb_irqs();
 	gru_kservices_exit();
-	for (bid = 0; bid < GRU_MAX_BLADES; bid++)
-		free_pages((unsigned long)gru_base[bid], order);
-
+	gru_free_tables();
 	misc_deregister(&gru_miscdev);
 	gru_proc_exit();
 }
diff -puN drivers/misc/sgi-gru/grumain.c~gru-update-irq-infrastructure drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~gru-update-irq-infrastructure
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -49,12 +49,16 @@ struct device *grudev = &gru_device;
 /*
  * Select a gru fault map to be used by the current cpu. Note that
  * multiple cpus may be using the same map.
- *	ZZZ should "shift" be used?? Depends on HT cpu numbering
  *	ZZZ should be inline but did not work on emulator
  */
 int gru_cpu_fault_map_id(void)
 {
-	return uv_blade_processor_id() % GRU_NUM_TFM;
+	int cpu = smp_processor_id();
+	int id, core;
+
+	core = uv_cpu_core_number(cpu);
+	id = core + UV_MAX_INT_CORES * uv_cpu_socket_number(cpu);
+	return id;
 }
 
 /*--------- ASID Management -------------------------------------------
@@ -605,6 +609,7 @@ void gru_load_context(struct gru_thread_
 		cch->unmap_enable = 1;
 		cch->tfm_done_bit_enable = 1;
 		cch->cb_int_enable = 1;
+		cch->tlb_int_select = 0;	/* For now, ints go to cpu 0 */
 	} else {
 		cch->unmap_enable = 0;
 		cch->tfm_done_bit_enable = 0;
diff -puN drivers/misc/sgi-gru/grutables.h~gru-update-irq-infrastructure drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~gru-update-irq-infrastructure
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -444,6 +444,7 @@ struct gru_state {
 							   in use */
 	struct gru_thread_state	*gs_gts[GRU_NUM_CCH];	/* GTS currently using
 							   the context */
+	int			gs_irq[GRU_NUM_TFM];	/* Interrupt irqs */
 };
 
 /*
@@ -610,6 +611,15 @@ static inline int is_kernel_context(stru
 	return !gts->ts_mm;
 }
 
+/*
+ * The following are for Nehelem-EX. A more general scheme is needed for
+ * future processors.
+ */
+#define UV_MAX_INT_CORES		8
+#define uv_cpu_socket_number(p)		((cpu_physical_id(p) >> 5) & 1)
+#define uv_cpu_ht_number(p)		(cpu_physical_id(p) & 1)
+#define uv_cpu_core_number(p)		(((cpu_physical_id(p) >> 2) & 4) |	\
+					((cpu_physical_id(p) >> 1) & 3))
 /*-----------------------------------------------------------------------------
  * Function prototypes & externs
  */
@@ -633,9 +643,11 @@ extern void gts_drop(struct gru_thread_s
 extern void gru_tgh_flush_init(struct gru_state *gru);
 extern int gru_kservices_init(void);
 extern void gru_kservices_exit(void);
+extern irqreturn_t gru0_intr(int irq, void *dev_id);
+extern irqreturn_t gru1_intr(int irq, void *dev_id);
+extern irqreturn_t gru_intr_mblade(int irq, void *dev_id);
 extern int gru_dump_chiplet_request(unsigned long arg);
 extern long gru_get_gseg_statistics(unsigned long arg);
-extern irqreturn_t gru_intr(int irq, void *dev_id);
 extern int gru_handle_user_call_os(unsigned long address);
 extern int gru_user_flush_tlb(unsigned long arg);
 extern int gru_user_unload_context(unsigned long arg);
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch


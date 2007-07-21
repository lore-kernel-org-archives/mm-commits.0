From: akpm@linux-foundation.org
Subject: - oprofile-add-support-to-oprofile-for-profiling-cell-be-update.patch removed from -mm tree
Date: Sat, 21 Jul 2007 03:25:18 -0700
Message-ID: <200707211025.l6LAPI3H011983@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60099 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932917AbXGUK0A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Jul 2007 06:26:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpjohn@us.ibm.com, arnd.bergmann@de.ibm.com, carll@us.ibm.com, paulus@samba.org, rrnelson@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     OProfile: add support to OProfile for profiling CELL BE (update)
has been removed from the -mm tree.  Its filename was
     oprofile-add-support-to-oprofile-for-profiling-cell-be-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: OProfile: add support to OProfile for profiling CELL BE (update)
From: Maynard Johnson <mpjohn@us.ibm.com>

Moved number_of_online_nodes() from pr_util.h to spu_task_sync.c
and dropped the inline as it is too big.
Fixed a number of style issues.
Added some comments for structs and memory barriers.
Changed set_profiling_frequency() to set_spu_profiling_frequency().
Aquire mmap_sem around vma walk.

Cc: Carl Love <carll@us.ibm.com>
Cc: Maynard Johnson <mpjohn@us.ibm.com>
Cc: Bob Nelson <rrnelson@us.ibm.com>
Cc: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/oprofile/cell/pr_util.h       |   55 ++++++++++---------
 arch/powerpc/oprofile/cell/spu_profiler.c  |   12 +---
 arch/powerpc/oprofile/cell/spu_task_sync.c |   21 ++++++-
 arch/powerpc/oprofile/op_model_cell.c      |   14 ++--
 4 files changed, 62 insertions(+), 40 deletions(-)

diff -puN arch/powerpc/oprofile/cell/pr_util.h~oprofile-add-support-to-oprofile-for-profiling-cell-be-update arch/powerpc/oprofile/cell/pr_util.h
--- a/arch/powerpc/oprofile/cell/pr_util.h~oprofile-add-support-to-oprofile-for-profiling-cell-be-update
+++ a/arch/powerpc/oprofile/cell/pr_util.h
@@ -21,39 +21,46 @@
 
 #include "../../platforms/cell/cbe_regs.h"
 
-static inline int number_of_online_nodes(void)
-{
-	u32 cpu; u32 tmp;
-	int nodes = 0;
-	for_each_online_cpu(cpu) {
-		tmp = cbe_cpu_to_node(cpu) + 1;
-		if (tmp > nodes)
-			nodes++;
-	}
-	return nodes;
-}
-
 /* Defines used for sync_start */
 #define SKIP_GENERIC_SYNC 0
 #define SYNC_START_ERROR -1
 #define DO_GENERIC_SYNC 1
 
-struct	spu_overlay_info
-{
-	unsigned int vma;
-	unsigned int size;
-	unsigned int offset;
+struct spu_overlay_info {	/* map of sections within an SPU overlay */
+	unsigned int vma;	/* SPU virtual memory address from elf */
+	unsigned int size;	/* size of section from elf */
+	unsigned int offset;	/* offset of section into elf file */
 	unsigned int buf;
 };
 
-struct vma_to_fileoffset_map
-{
-	struct vma_to_fileoffset_map *next;
-	unsigned int vma;
-	unsigned int size;
-	unsigned int offset;
+struct vma_to_fileoffset_map {	/* map of sections within an SPU program */
+	struct vma_to_fileoffset_map *next;	/* list pointer */
+	unsigned int vma;	/* SPU virtual memory address from elf */
+	unsigned int size;	/* size of section from elf */
+	unsigned int offset;	/* offset of section into elf file */
 	unsigned int guard_ptr;
 	unsigned int guard_val;
+        /*
+	 * The guard pointer is an entry in the _ovly_buf_table,
+	 * computed using ovly.buf as the index into the table.  Since
+	 * ovly.buf values begin at '1' to reference the first (or 0th)
+	 * entry in the _ovly_buf_table, the computation subtracts 1
+	 * from ovly.buf.
+	 * The guard value is stored in the _ovly_buf_table entry and
+	 * is an index (starting at 1) back to the _ovly_table entry
+	 * that is pointing at this _ovly_buf_table entry.  So, for
+	 * example, for an overlay scenario with one overlay segment
+	 * and two overlay sections:
+	 *      - Section 1 points to the first entry of the
+	 *        _ovly_buf_table, which contains a guard value
+	 *        of '1', referencing the first (index=0) entry of
+	 *        _ovly_table.
+	 *      - Section 2 points to the second entry of the
+	 *        _ovly_buf_table, which contains a guard value
+	 *        of '2', referencing the second (index=1) entry of
+	 *        _ovly_table.
+	 */
+
 };
 
 /* The three functions below are for maintaining and accessing
@@ -85,6 +92,6 @@ int spu_sync_stop(void);
 void spu_sync_buffer(int spu_num, unsigned int *samples,
 		     int num_samples);
 
-void set_profiling_frequency(unsigned int freq_khz, unsigned int cycles_reset);
+void set_spu_profiling_frequency(unsigned int freq_khz, unsigned int cycles_reset);
 
 #endif	  /* PR_UTIL_H */
diff -puN arch/powerpc/oprofile/cell/spu_profiler.c~oprofile-add-support-to-oprofile-for-profiling-cell-be-update arch/powerpc/oprofile/cell/spu_profiler.c
--- a/arch/powerpc/oprofile/cell/spu_profiler.c~oprofile-add-support-to-oprofile-for-profiling-cell-be-update
+++ a/arch/powerpc/oprofile/cell/spu_profiler.c
@@ -16,7 +16,6 @@
 #include <linux/smp.h>
 #include <linux/slab.h>
 #include <asm/cell-pmu.h>
-/*#include <linux/time.h>*/
 #include "pr_util.h"
 
 #define TRACE_ARRAY_SIZE 1024
@@ -27,9 +26,6 @@ static u32 *samples;
 static int spu_prof_running;
 static unsigned int profiling_interval;
 
-extern int spu_prof_num_nodes;
-
-
 #define NUM_SPU_BITS_TRBUF 16
 #define SPUS_PER_TB_ENTRY   4
 #define SPUS_PER_NODE	     8
@@ -39,9 +35,10 @@ extern int spu_prof_num_nodes;
 static DEFINE_SPINLOCK(sample_array_lock);
 unsigned long sample_array_lock_flags;
 
-void set_profiling_frequency(unsigned int freq_khz, unsigned int cycles_reset)
+void set_spu_profiling_frequency(unsigned int freq_khz, unsigned int cycles_reset)
 {
 	unsigned long ns_per_cyc;
+
 	if (!freq_khz)
 		freq_khz = ppc_proc_freq/1000;
 
@@ -123,7 +120,7 @@ static int cell_spu_pc_collection(int cp
 		trace_addr = cbe_read_pm(cpu, trace_address);
 	}
 
-	return(entry);
+	return entry;
 }
 
 
@@ -170,7 +167,8 @@ static enum hrtimer_restart profile_spus
 				       sample_array_lock_flags);
 
 	}
-	smp_wmb();
+	smp_wmb();	/* insure spu event buffer updates are written */
+			/* don't want events intermingled... */
 
 	kt = ktime_set(0, profiling_interval);
 	if (!spu_prof_running)
diff -puN arch/powerpc/oprofile/cell/spu_task_sync.c~oprofile-add-support-to-oprofile-for-profiling-cell-be-update arch/powerpc/oprofile/cell/spu_task_sync.c
--- a/arch/powerpc/oprofile/cell/spu_task_sync.c~oprofile-add-support-to-oprofile-for-profiling-cell-be-update
+++ a/arch/powerpc/oprofile/cell/spu_task_sync.c
@@ -232,6 +232,8 @@ get_exec_dcookie_and_offset(struct spu *
 	if (!mm)
 		goto out;
 
+	down_read(&mm->mmap_sem);
+
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		if (!vma->vm_file)
 			continue;
@@ -263,10 +265,14 @@ get_exec_dcookie_and_offset(struct spu *
 						 vma->vm_file->f_vfsmnt);
 	pr_debug("got dcookie for %s\n", vma->vm_file->f_dentry->d_name.name);
 
+	up_read(&mm->mmap_sem);
+
 out:
 	return app_cookie;
 
 fail_no_image_cookie:
+	up_read(&mm->mmap_sem);
+
 	printk(KERN_ERR "SPU_PROF: "
 		"%s, line %d: Cannot find dcookie for SPU binary\n",
 		__FUNCTION__, __LINE__);
@@ -310,7 +316,8 @@ static int process_context_switch(struct
 	add_event_entry(spu_cookie);
 	add_event_entry(offset);
 	spin_unlock_irqrestore(&buffer_lock, flags);
-	smp_wmb();
+	smp_wmb();	/* insure spu event buffer updates are written */
+			/* don't want entries intermingled... */
 out:
 	return retval;
 }
@@ -343,6 +350,18 @@ static struct notifier_block spu_active 
 	.notifier_call = spu_active_notify,
 };
 
+static int number_of_online_nodes(void)
+{
+        u32 cpu; u32 tmp;
+        int nodes = 0;
+        for_each_online_cpu(cpu) {
+                tmp = cbe_cpu_to_node(cpu) + 1;
+                if (tmp > nodes)
+                        nodes++;
+        }
+        return nodes;
+}
+
 /* The main purpose of this function is to synchronize
  * OProfile with SPUFS by registering to be notified of
  * SPU task switches.
diff -puN arch/powerpc/oprofile/op_model_cell.c~oprofile-add-support-to-oprofile-for-profiling-cell-be-update arch/powerpc/oprofile/op_model_cell.c
--- a/arch/powerpc/oprofile/op_model_cell.c~oprofile-add-support-to-oprofile-for-profiling-cell-be-update
+++ a/arch/powerpc/oprofile/op_model_cell.c
@@ -867,7 +867,7 @@ oprof_cpufreq_notify(struct notifier_blo
 	if ((val == CPUFREQ_PRECHANGE && frq->old < frq->new) ||
 	    (val == CPUFREQ_POSTCHANGE && frq->old > frq->new) ||
 	    (val == CPUFREQ_RESUMECHANGE || val == CPUFREQ_SUSPENDCHANGE))
-		set_profiling_frequency(frq->new, spu_cycle_reset);
+		set_spu_profiling_frequency(frq->new, spu_cycle_reset);
 	return ret;
 }
 
@@ -902,7 +902,7 @@ static int cell_global_start_spu(struct 
 		cpu_khzfreq = cpufreq_quick_get(smp_processor_id());
 #endif
 
-	set_profiling_frequency(cpu_khzfreq, spu_cycle_reset);
+	set_spu_profiling_frequency(cpu_khzfreq, spu_cycle_reset);
 
 	for_each_online_cpu(cpu) {
 		if (cbe_get_hw_thread_id(cpu))
@@ -1015,11 +1015,10 @@ static int cell_global_start_ppu(struct 
 
 static int cell_global_start(struct op_counter_config *ctr)
 {
-	if (spu_cycle_reset) {
+	if (spu_cycle_reset)
 		return cell_global_start_spu(ctr);
-	} else {
+	else
 		return cell_global_start_ppu(ctr);
-	}
 }
 
 /*
@@ -1101,11 +1100,10 @@ static void cell_global_stop_ppu(void)
 
 static void cell_global_stop(void)
 {
-	if (spu_cycle_reset) {
+	if (spu_cycle_reset)
 		cell_global_stop_spu();
-	} else {
+	else
 		cell_global_stop_ppu();
-	}
 }
 
 static void cell_handle_interrupt(struct pt_regs *regs,
_

Patches currently in -mm which might be from mpjohn@us.ibm.com are

origin.patch

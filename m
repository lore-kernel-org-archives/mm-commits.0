From: akpm@linux-foundation.org
Subject: - oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:55:44 -0700
Message-ID: <200804282155.m3SLtifN018127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935193AbYD1Vzr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:55:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, phil.el@wanadoo.fr, mm-commits@vger.kernel.org


The patch titled
     oprofile: change cpu_buffer from array to per_cpu variable
has been removed from the -mm tree.  Its filename was
     oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oprofile: change cpu_buffer from array to per_cpu variable
From: Mike Travis <travis@sgi.com>

Change cpu_buffer from array to per_cpu variable in oprofile functions.

[akpm@linux-foundation.org: coding-style fixes]
Cc: Philippe Elie <phil.el@wanadoo.fr>
Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/oprofile/buffer_sync.c    |    2 +-
 drivers/oprofile/cpu_buffer.c     |   16 ++++++++--------
 drivers/oprofile/cpu_buffer.h     |    3 ++-
 drivers/oprofile/oprofile_stats.c |    4 ++--
 4 files changed, 13 insertions(+), 12 deletions(-)

diff -puN drivers/oprofile/buffer_sync.c~oprofile-change-cpu_buffer-from-array-to-per_cpu-variable drivers/oprofile/buffer_sync.c
--- a/drivers/oprofile/buffer_sync.c~oprofile-change-cpu_buffer-from-array-to-per_cpu-variable
+++ a/drivers/oprofile/buffer_sync.c
@@ -491,7 +491,7 @@ typedef enum {
  */
 void sync_buffer(int cpu)
 {
-	struct oprofile_cpu_buffer * cpu_buf = &cpu_buffer[cpu];
+	struct oprofile_cpu_buffer *cpu_buf = &per_cpu(cpu_buffer, cpu);
 	struct mm_struct *mm = NULL;
 	struct task_struct * new;
 	unsigned long cookie = 0;
diff -puN drivers/oprofile/cpu_buffer.c~oprofile-change-cpu_buffer-from-array-to-per_cpu-variable drivers/oprofile/cpu_buffer.c
--- a/drivers/oprofile/cpu_buffer.c~oprofile-change-cpu_buffer-from-array-to-per_cpu-variable
+++ a/drivers/oprofile/cpu_buffer.c
@@ -27,7 +27,7 @@
 #include "buffer_sync.h"
 #include "oprof.h"
 
-struct oprofile_cpu_buffer cpu_buffer[NR_CPUS] __cacheline_aligned;
+DEFINE_PER_CPU_SHARED_ALIGNED(struct oprofile_cpu_buffer, cpu_buffer);
 
 static void wq_sync_buffer(struct work_struct *work);
 
@@ -39,7 +39,7 @@ void free_cpu_buffers(void)
 	int i;
  
 	for_each_online_cpu(i)
-		vfree(cpu_buffer[i].buffer);
+		vfree(per_cpu(cpu_buffer, i).buffer);
 }
 
 int alloc_cpu_buffers(void)
@@ -49,7 +49,7 @@ int alloc_cpu_buffers(void)
 	unsigned long buffer_size = fs_cpu_buffer_size;
  
 	for_each_online_cpu(i) {
-		struct oprofile_cpu_buffer * b = &cpu_buffer[i];
+		struct oprofile_cpu_buffer *b = &per_cpu(cpu_buffer, i);
  
 		b->buffer = vmalloc_node(sizeof(struct op_sample) * buffer_size,
 			cpu_to_node(i));
@@ -83,7 +83,7 @@ void start_cpu_work(void)
 	work_enabled = 1;
 
 	for_each_online_cpu(i) {
-		struct oprofile_cpu_buffer * b = &cpu_buffer[i];
+		struct oprofile_cpu_buffer *b = &per_cpu(cpu_buffer, i);
 
 		/*
 		 * Spread the work by 1 jiffy per cpu so they dont all
@@ -100,7 +100,7 @@ void end_cpu_work(void)
 	work_enabled = 0;
 
 	for_each_online_cpu(i) {
-		struct oprofile_cpu_buffer * b = &cpu_buffer[i];
+		struct oprofile_cpu_buffer *b = &per_cpu(cpu_buffer, i);
 
 		cancel_delayed_work(&b->work);
 	}
@@ -227,7 +227,7 @@ static void oprofile_end_trace(struct op
 void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 				unsigned long event, int is_kernel)
 {
-	struct oprofile_cpu_buffer * cpu_buf = &cpu_buffer[smp_processor_id()];
+	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
 
 	if (!backtrace_depth) {
 		log_sample(cpu_buf, pc, is_kernel, event);
@@ -254,13 +254,13 @@ void oprofile_add_sample(struct pt_regs 
 
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event)
 {
-	struct oprofile_cpu_buffer * cpu_buf = &cpu_buffer[smp_processor_id()];
+	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
 	log_sample(cpu_buf, pc, is_kernel, event);
 }
 
 void oprofile_add_trace(unsigned long pc)
 {
-	struct oprofile_cpu_buffer * cpu_buf = &cpu_buffer[smp_processor_id()];
+	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
 
 	if (!cpu_buf->tracing)
 		return;
diff -puN drivers/oprofile/cpu_buffer.h~oprofile-change-cpu_buffer-from-array-to-per_cpu-variable drivers/oprofile/cpu_buffer.h
--- a/drivers/oprofile/cpu_buffer.h~oprofile-change-cpu_buffer-from-array-to-per_cpu-variable
+++ a/drivers/oprofile/cpu_buffer.h
@@ -14,6 +14,7 @@
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/cache.h>
+#include <linux/sched.h>
  
 struct task_struct;
  
@@ -47,7 +48,7 @@ struct oprofile_cpu_buffer {
 	struct delayed_work work;
 } ____cacheline_aligned;
 
-extern struct oprofile_cpu_buffer cpu_buffer[];
+DECLARE_PER_CPU(struct oprofile_cpu_buffer, cpu_buffer);
 
 void cpu_buffer_reset(struct oprofile_cpu_buffer * cpu_buf);
 
diff -puN drivers/oprofile/oprofile_stats.c~oprofile-change-cpu_buffer-from-array-to-per_cpu-variable drivers/oprofile/oprofile_stats.c
--- a/drivers/oprofile/oprofile_stats.c~oprofile-change-cpu_buffer-from-array-to-per_cpu-variable
+++ a/drivers/oprofile/oprofile_stats.c
@@ -23,7 +23,7 @@ void oprofile_reset_stats(void)
 	int i;
  
 	for_each_possible_cpu(i) {
-		cpu_buf = &cpu_buffer[i]; 
+		cpu_buf = &per_cpu(cpu_buffer, i);
 		cpu_buf->sample_received = 0;
 		cpu_buf->sample_lost_overflow = 0;
 		cpu_buf->backtrace_aborted = 0;
@@ -49,7 +49,7 @@ void oprofile_create_stats_files(struct 
 		return;
 
 	for_each_possible_cpu(i) {
-		cpu_buf = &cpu_buffer[i]; 
+		cpu_buf = &per_cpu(cpu_buffer, i);
 		snprintf(buf, 10, "cpu%d", i);
 		cpudir = oprofilefs_mkdir(sb, dir, buf);
  
_

Patches currently in -mm which might be from travis@sgi.com are

origin.patch
git-cpufreq.patch
show_schedstat-fix-memleak.patch
cpufreq-change-cpu-freq-arrays-to-per_cpu-variables.patch
acpi-change-processors-from-array-to-per_cpu-variable.patch
cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch
net-remove-nr_cpus-arrays-in-net-core-devc-v2.patch


From: akpm@linux-foundation.org
Subject: - smp-uninline-num_online_cpus-num_possible_cpus.patch removed from -mm tree
Date: Tue, 09 Dec 2008 00:47:36 -0800
Message-ID: <200812090847.mB98la7H000892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751466AbYLIIsN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Dec 2008 03:48:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, mingo@elte.hu, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     smp: uninline num_online_cpus() & num_possible_cpus()
has been removed from the -mm tree.  Its filename was
     smp-uninline-num_online_cpus-num_possible_cpus.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smp: uninline num_online_cpus() & num_possible_cpus()
From: Eric Dumazet <dada1@cosmosbay.com>

num_online_cpus() and num_possible_cpus() are not performance
critical and are quite large.

Unlining them shrinks kernel text size by 7523 bytes on x86,
if NR_CPUS>32

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |    4 ++--
 init/main.c             |   12 ++++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff -puN include/linux/cpumask.h~smp-uninline-num_online_cpus-num_possible_cpus include/linux/cpumask.h
--- a/include/linux/cpumask.h~smp-uninline-num_online_cpus-num_possible_cpus
+++ a/include/linux/cpumask.h
@@ -466,8 +466,8 @@ extern const struct cpumask *const cpu_a
 #define cpu_active_map		(*(cpumask_t *)cpu_active_mask)
 
 #if NR_CPUS > 1
-#define num_online_cpus()	cpus_weight_nr(cpu_online_map)
-#define num_possible_cpus()	cpus_weight_nr(cpu_possible_map)
+extern int num_online_cpus(void);
+extern int num_possible_cpus(void);
 #define num_present_cpus()	cpus_weight_nr(cpu_present_map)
 #define cpu_online(cpu)		cpu_isset((cpu), cpu_online_map)
 #define cpu_possible(cpu)	cpu_isset((cpu), cpu_possible_map)
diff -puN init/main.c~smp-uninline-num_online_cpus-num_possible_cpus init/main.c
--- a/init/main.c~smp-uninline-num_online_cpus-num_possible_cpus
+++ a/init/main.c
@@ -379,6 +379,18 @@ EXPORT_SYMBOL(cpu_mask_all);
 int nr_cpu_ids __read_mostly = NR_CPUS;
 EXPORT_SYMBOL(nr_cpu_ids);
 
+int num_online_cpus(void)
+{
+	return cpus_weight_nr(cpu_online_map);
+}
+EXPORT_SYMBOL(num_online_cpus);
+
+int num_possible_cpus(void)
+{
+	return cpus_weight_nr(cpu_possible_map);
+}
+EXPORT_SYMBOL(num_possible_cpus);
+
 /* An arch may set nr_cpu_ids earlier if needed, so this would be redundant */
 static void __init setup_nr_cpu_ids(void)
 {
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
percpu_counter-fix-cpu-unplug-race-in-percpu_counter_destroy.patch
revert-percpu-counter-clean-up-percpu_counter_sum_and_set.patch
revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch
atomic-fix-a-typo-in-atomic_long_xchg.patch
linux-next.patch
percpu_counter-fbc_batch-should-be-a-variable.patch
smp-uninline-num_online_cpus-num_possible_cpus.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch


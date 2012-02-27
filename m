From: akpm@linux-foundation.org
Subject: [failures] cpumask-avoid-mask-based-num_possible_cpus-and-num_online_cpus.patch removed from -mm tree
Date: Mon, 27 Feb 2012 14:07:53 -0800
Message-ID: <20120227220755.095CCA02DD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:43136 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab2B0WH7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2012 17:07:59 -0500
Received: by faaa19 with SMTP id a19so75592faa.1
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2012 14:07:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venki@google.com, kosaki.motohiro@jp.fujitsu.com, rusty@rustcorp.com.au, srivatsa.bhat@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cpumask: avoid mask based num_possible_cpus() and num_online_cpus()
has been removed from the -mm tree.  Its filename was
     cpumask-avoid-mask-based-num_possible_cpus-and-num_online_cpus.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Venkatesh Pallipadi <venki@google.com>
Subject: cpumask: avoid mask based num_possible_cpus() and num_online_cpus()

The kernel's notion of possible cpus (from include/linux/cpumask.h) is

 *     cpu_possible_mask- has bit 'cpu' set iff cpu is populatable
 *  The cpu_possible_mask is fixed at boot time, as the set of CPU id's
 *  that it is possible might ever be plugged in at anytime during the
 *  life of that system boot.

 #define num_possible_cpus()     cpumask_weight(cpu_possible_mask)

and on x86 cpumask_weight() calls hweight64 and hweight64 (on older
kernels and systems with !X86_FEATURE_POPCNT) or a popcnt based
alternative.

i.e, We needlessly go through this mask based calculation everytime
num_possible_cpus() is called.

The problem is there with cpu_online_mask() as well, which is a fixed
value at boot time in !CONFIG_HOTPLUG_CPU case and should not change that
often even in HOTPLUG case.

Though most of the callers of these two routines are at init time (with
only a few runtime calls), it is cleaner to use variables and not go
through this repeated mask based calculation.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |    9 +++++++--
 kernel/cpu.c            |   13 +++++++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff -puN include/linux/cpumask.h~cpumask-avoid-mask-based-num_possible_cpus-and-num_online_cpus include/linux/cpumask.h
--- a/include/linux/cpumask.h~cpumask-avoid-mask-based-num_possible_cpus-and-num_online_cpus
+++ a/include/linux/cpumask.h
@@ -27,6 +27,9 @@ typedef struct cpumask { DECLARE_BITMAP(
 extern int nr_cpu_ids;
 #endif
 
+extern unsigned int nr_online_cpus;
+extern unsigned int nr_possible_cpus;
+
 #ifdef CONFIG_CPUMASK_OFFSTACK
 /* Assuming NR_CPUS is huge, a runtime limit is more efficient.  Also,
  * not all bits may be allocated. */
@@ -81,8 +84,10 @@ extern const struct cpumask *const cpu_p
 extern const struct cpumask *const cpu_active_mask;
 
 #if NR_CPUS > 1
-#define num_online_cpus()	cpumask_weight(cpu_online_mask)
-#define num_possible_cpus()	cpumask_weight(cpu_possible_mask)
+
+#define num_online_cpus()	(nr_online_cpus)
+#define num_possible_cpus()	(nr_possible_cpus)
+
 #define num_present_cpus()	cpumask_weight(cpu_present_mask)
 #define num_active_cpus()	cpumask_weight(cpu_active_mask)
 #define cpu_online(cpu)		cpumask_test_cpu((cpu), cpu_online_mask)
diff -puN kernel/cpu.c~cpumask-avoid-mask-based-num_possible_cpus-and-num_online_cpus kernel/cpu.c
--- a/kernel/cpu.c~cpumask-avoid-mask-based-num_possible_cpus-and-num_online_cpus
+++ a/kernel/cpu.c
@@ -604,9 +604,13 @@ EXPORT_SYMBOL(cpu_all_bits);
 #ifdef CONFIG_INIT_ALL_POSSIBLE
 static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly
 	= CPU_BITS_ALL;
+unsigned int nr_possible_cpus __read_mostly = CONFIG_NR_CPUS;
 #else
 static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly;
+unsigned int nr_possible_cpus __read_mostly;
 #endif
+EXPORT_SYMBOL(nr_possible_cpus);
+
 const struct cpumask *const cpu_possible_mask = to_cpumask(cpu_possible_bits);
 EXPORT_SYMBOL(cpu_possible_mask);
 
@@ -614,6 +618,9 @@ static DECLARE_BITMAP(cpu_online_bits, C
 const struct cpumask *const cpu_online_mask = to_cpumask(cpu_online_bits);
 EXPORT_SYMBOL(cpu_online_mask);
 
+unsigned int nr_online_cpus __read_mostly;
+EXPORT_SYMBOL(nr_online_cpus);
+
 static DECLARE_BITMAP(cpu_present_bits, CONFIG_NR_CPUS) __read_mostly;
 const struct cpumask *const cpu_present_mask = to_cpumask(cpu_present_bits);
 EXPORT_SYMBOL(cpu_present_mask);
@@ -628,6 +635,8 @@ void set_cpu_possible(unsigned int cpu, 
 		cpumask_set_cpu(cpu, to_cpumask(cpu_possible_bits));
 	else
 		cpumask_clear_cpu(cpu, to_cpumask(cpu_possible_bits));
+
+	nr_possible_cpus = cpumask_weight(cpu_possible_mask);
 }
 
 void set_cpu_present(unsigned int cpu, bool present)
@@ -644,6 +653,8 @@ void set_cpu_online(unsigned int cpu, bo
 		cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
 	else
 		cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
+
+	nr_online_cpus = cpumask_weight(cpu_online_mask);
 }
 
 void set_cpu_active(unsigned int cpu, bool active)
@@ -662,9 +673,11 @@ void init_cpu_present(const struct cpuma
 void init_cpu_possible(const struct cpumask *src)
 {
 	cpumask_copy(to_cpumask(cpu_possible_bits), src);
+	nr_possible_cpus = cpumask_weight(cpu_possible_mask);
 }
 
 void init_cpu_online(const struct cpumask *src)
 {
 	cpumask_copy(to_cpumask(cpu_online_bits), src);
+	nr_online_cpus = cpumask_weight(cpu_online_mask);
 }
_

Patches currently in -mm which might be from venki@google.com are

linux-next.patch
lib-cpumaskc-remove-__any_online_cpu.patch


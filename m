From: akpm@linux-foundation.org
Subject: [merged] kernel-cpuc-eliminate-cpu__mask.patch removed from -mm
 tree
Date: Thu, 21 Jan 2016 15:00:09 -0800
Message-ID: <56a162f9.A151iNkJORSlRjtf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbcAUXAK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:00:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, gregkh@linuxfoundation.org, mpe@ellerman.id.au, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/cpu.c: eliminate cpu_*_mask
has been removed from the -mm tree.  Its filename was
     kernel-cpuc-eliminate-cpu__mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: kernel/cpu.c: eliminate cpu_*_mask

Replace the variables cpu_possible_mask, cpu_online_mask, cpu_present_mask
and cpu_active_mask with macros expanding to expressions of the same type
and value, eliminating some indirection.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |    8 ++++----
 kernel/cpu.c            |    8 --------
 2 files changed, 4 insertions(+), 12 deletions(-)

diff -puN include/linux/cpumask.h~kernel-cpuc-eliminate-cpu__mask include/linux/cpumask.h
--- a/include/linux/cpumask.h~kernel-cpuc-eliminate-cpu__mask
+++ a/include/linux/cpumask.h
@@ -85,14 +85,14 @@ extern int nr_cpu_ids;
  *    only one CPU.
  */
 
-extern const struct cpumask *const cpu_possible_mask;
-extern const struct cpumask *const cpu_online_mask;
-extern const struct cpumask *const cpu_present_mask;
-extern const struct cpumask *const cpu_active_mask;
 extern struct cpumask __cpu_possible_mask;
 extern struct cpumask __cpu_online_mask;
 extern struct cpumask __cpu_present_mask;
 extern struct cpumask __cpu_active_mask;
+#define cpu_possible_mask ((const struct cpumask *)&__cpu_possible_mask)
+#define cpu_online_mask   ((const struct cpumask *)&__cpu_online_mask)
+#define cpu_present_mask  ((const struct cpumask *)&__cpu_present_mask)
+#define cpu_active_mask   ((const struct cpumask *)&__cpu_active_mask)
 
 #if NR_CPUS > 1
 #define num_online_cpus()	cpumask_weight(cpu_online_mask)
diff -puN kernel/cpu.c~kernel-cpuc-eliminate-cpu__mask kernel/cpu.c
--- a/kernel/cpu.c~kernel-cpuc-eliminate-cpu__mask
+++ a/kernel/cpu.c
@@ -765,23 +765,15 @@ struct cpumask __cpu_possible_mask __rea
 struct cpumask __cpu_possible_mask __read_mostly;
 #endif
 EXPORT_SYMBOL(__cpu_possible_mask);
-const struct cpumask *const cpu_possible_mask = &__cpu_possible_mask;
-EXPORT_SYMBOL(cpu_possible_mask);
 
 struct cpumask __cpu_online_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_online_mask);
-const struct cpumask *const cpu_online_mask = &__cpu_online_mask;
-EXPORT_SYMBOL(cpu_online_mask);
 
 struct cpumask __cpu_present_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_present_mask);
-const struct cpumask *const cpu_present_mask = &__cpu_present_mask;
-EXPORT_SYMBOL(cpu_present_mask);
 
 struct cpumask __cpu_active_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_active_mask);
-const struct cpumask *const cpu_active_mask = &__cpu_active_mask;
-EXPORT_SYMBOL(cpu_active_mask);
 
 void set_cpu_possible(unsigned int cpu, bool possible)
 {
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are



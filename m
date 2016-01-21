From: akpm@linux-foundation.org
Subject: [merged]
 kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch removed from -mm tree
Date: Thu, 21 Jan 2016 15:00:03 -0800
Message-ID: <56a162f3.W6UJnp7/vOLgFBlN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbcAUXAD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:00:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, gregkh@linuxfoundation.org, mpe@ellerman.id.au, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/cpu.c: change type of cpu_possible_bits and friends
has been removed from the -mm tree.  Its filename was
     kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: kernel/cpu.c: change type of cpu_possible_bits and friends

Change cpu_possible_bits and friends (online, present, active) from being
bitmaps that happen to have the right size to actually being struct
cpumasks.  Also rename them to __cpu_xyz_mask.  This is mostly a small
cleanup in preparation for exporting them and, eventually, eliminating the
extra indirection through the cpu_xyz_mask variables.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |   44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff -puN kernel/cpu.c~kernel-cpuc-change-type-of-cpu_possible_bits-and-friends kernel/cpu.c
--- a/kernel/cpu.c~kernel-cpuc-change-type-of-cpu_possible_bits-and-friends
+++ a/kernel/cpu.c
@@ -759,71 +759,71 @@ const DECLARE_BITMAP(cpu_all_bits, NR_CP
 EXPORT_SYMBOL(cpu_all_bits);
 
 #ifdef CONFIG_INIT_ALL_POSSIBLE
-static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly
-	= CPU_BITS_ALL;
+static struct cpumask __cpu_possible_mask __read_mostly
+	= {CPU_BITS_ALL};
 #else
-static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly;
+static struct cpumask __cpu_possible_mask __read_mostly;
 #endif
-const struct cpumask *const cpu_possible_mask = to_cpumask(cpu_possible_bits);
+const struct cpumask *const cpu_possible_mask = &__cpu_possible_mask;
 EXPORT_SYMBOL(cpu_possible_mask);
 
-static DECLARE_BITMAP(cpu_online_bits, CONFIG_NR_CPUS) __read_mostly;
-const struct cpumask *const cpu_online_mask = to_cpumask(cpu_online_bits);
+static struct cpumask __cpu_online_mask __read_mostly;
+const struct cpumask *const cpu_online_mask = &__cpu_online_mask;
 EXPORT_SYMBOL(cpu_online_mask);
 
-static DECLARE_BITMAP(cpu_present_bits, CONFIG_NR_CPUS) __read_mostly;
-const struct cpumask *const cpu_present_mask = to_cpumask(cpu_present_bits);
+static struct cpumask __cpu_present_mask __read_mostly;
+const struct cpumask *const cpu_present_mask = &__cpu_present_mask;
 EXPORT_SYMBOL(cpu_present_mask);
 
-static DECLARE_BITMAP(cpu_active_bits, CONFIG_NR_CPUS) __read_mostly;
-const struct cpumask *const cpu_active_mask = to_cpumask(cpu_active_bits);
+static struct cpumask __cpu_active_mask __read_mostly;
+const struct cpumask *const cpu_active_mask = &__cpu_active_mask;
 EXPORT_SYMBOL(cpu_active_mask);
 
 void set_cpu_possible(unsigned int cpu, bool possible)
 {
 	if (possible)
-		cpumask_set_cpu(cpu, to_cpumask(cpu_possible_bits));
+		cpumask_set_cpu(cpu, &__cpu_possible_mask);
 	else
-		cpumask_clear_cpu(cpu, to_cpumask(cpu_possible_bits));
+		cpumask_clear_cpu(cpu, &__cpu_possible_mask);
 }
 
 void set_cpu_present(unsigned int cpu, bool present)
 {
 	if (present)
-		cpumask_set_cpu(cpu, to_cpumask(cpu_present_bits));
+		cpumask_set_cpu(cpu, &__cpu_present_mask);
 	else
-		cpumask_clear_cpu(cpu, to_cpumask(cpu_present_bits));
+		cpumask_clear_cpu(cpu, &__cpu_present_mask);
 }
 
 void set_cpu_online(unsigned int cpu, bool online)
 {
 	if (online) {
-		cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
-		cpumask_set_cpu(cpu, to_cpumask(cpu_active_bits));
+		cpumask_set_cpu(cpu, &__cpu_online_mask);
+		cpumask_set_cpu(cpu, &__cpu_active_mask);
 	} else {
-		cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
+		cpumask_clear_cpu(cpu, &__cpu_online_mask);
 	}
 }
 
 void set_cpu_active(unsigned int cpu, bool active)
 {
 	if (active)
-		cpumask_set_cpu(cpu, to_cpumask(cpu_active_bits));
+		cpumask_set_cpu(cpu, &__cpu_active_mask);
 	else
-		cpumask_clear_cpu(cpu, to_cpumask(cpu_active_bits));
+		cpumask_clear_cpu(cpu, &__cpu_active_mask);
 }
 
 void init_cpu_present(const struct cpumask *src)
 {
-	cpumask_copy(to_cpumask(cpu_present_bits), src);
+	cpumask_copy(&__cpu_present_mask, src);
 }
 
 void init_cpu_possible(const struct cpumask *src)
 {
-	cpumask_copy(to_cpumask(cpu_possible_bits), src);
+	cpumask_copy(&__cpu_possible_mask, src);
 }
 
 void init_cpu_online(const struct cpumask *src)
 {
-	cpumask_copy(to_cpumask(cpu_online_bits), src);
+	cpumask_copy(&__cpu_online_mask, src);
 }
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are



From: akpm@linux-foundation.org
Subject: + kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
 added to -mm tree
Date: Mon, 23 Nov 2015 15:56:23 -0800
Message-ID: <5653a7a7.73asOqOSF9sVk7uT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbbKWX4Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 18:56:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, gregkh@linuxfoundation.org, mpe@ellerman.id.au, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/cpu.c: change type of cpu_possible_bits and friends
has been added to the -mm tree.  Its filename is
     kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch
kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
kernel-cpuc-export-__cpu__mask.patch
drivers-base-cpuc-use-__cpu__mask-directly.patch
kernel-cpuc-eliminate-cpu__mask.patch
kernel-cpuc-make-set_cpu_-static-inlines.patch


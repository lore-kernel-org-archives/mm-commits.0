From: akpm@linux-foundation.org
Subject: + kernel-cpuc-make-set_cpu_-static-inlines.patch added to -mm
 tree
Date: Mon, 23 Nov 2015 15:56:31 -0800
Message-ID: <5653a7af.VXCpmVeM2sjRqagi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57176 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbbKWX4c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 18:56:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, gregkh@linuxfoundation.org, mpe@ellerman.id.au, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/cpu.c: make set_cpu_* static inlines
has been added to the -mm tree.  Its filename is
     kernel-cpuc-make-set_cpu_-static-inlines.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-cpuc-make-set_cpu_-static-inlines.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-cpuc-make-set_cpu_-static-inlines.patch

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
Subject: kernel/cpu.c: make set_cpu_* static inlines

Almost all callers of the set_cpu_* functions pass an explicit true or
false.  Making them static inline thus replaces the function calls with a
simple set_bit/clear_bit, saving some .text.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |   43 ++++++++++++++++++++++++++++++++++----
 kernel/cpu.c            |   34 ------------------------------
 2 files changed, 39 insertions(+), 38 deletions(-)

diff -puN include/linux/cpumask.h~kernel-cpuc-make-set_cpu_-static-inlines include/linux/cpumask.h
--- a/include/linux/cpumask.h~kernel-cpuc-make-set_cpu_-static-inlines
+++ a/include/linux/cpumask.h
@@ -720,14 +720,49 @@ extern const DECLARE_BITMAP(cpu_all_bits
 #define for_each_present_cpu(cpu)  for_each_cpu((cpu), cpu_present_mask)
 
 /* Wrappers for arch boot code to manipulate normally-constant masks */
-void set_cpu_possible(unsigned int cpu, bool possible);
-void set_cpu_present(unsigned int cpu, bool present);
-void set_cpu_online(unsigned int cpu, bool online);
-void set_cpu_active(unsigned int cpu, bool active);
 void init_cpu_present(const struct cpumask *src);
 void init_cpu_possible(const struct cpumask *src);
 void init_cpu_online(const struct cpumask *src);
 
+static inline void
+set_cpu_possible(unsigned int cpu, bool possible)
+{
+	if (possible)
+		cpumask_set_cpu(cpu, &__cpu_possible_mask);
+	else
+		cpumask_clear_cpu(cpu, &__cpu_possible_mask);
+}
+
+static inline void
+set_cpu_present(unsigned int cpu, bool present)
+{
+	if (present)
+		cpumask_set_cpu(cpu, &__cpu_present_mask);
+	else
+		cpumask_clear_cpu(cpu, &__cpu_present_mask);
+}
+
+static inline void
+set_cpu_online(unsigned int cpu, bool online)
+{
+	if (online) {
+		cpumask_set_cpu(cpu, &__cpu_online_mask);
+		cpumask_set_cpu(cpu, &__cpu_active_mask);
+	} else {
+		cpumask_clear_cpu(cpu, &__cpu_online_mask);
+	}
+}
+
+static inline void
+set_cpu_active(unsigned int cpu, bool active)
+{
+	if (active)
+		cpumask_set_cpu(cpu, &__cpu_active_mask);
+	else
+		cpumask_clear_cpu(cpu, &__cpu_active_mask);
+}
+
+
 /**
  * to_cpumask - convert an NR_CPUS bitmap to a struct cpumask *
  * @bitmap: the bitmap
diff -puN kernel/cpu.c~kernel-cpuc-make-set_cpu_-static-inlines kernel/cpu.c
--- a/kernel/cpu.c~kernel-cpuc-make-set_cpu_-static-inlines
+++ a/kernel/cpu.c
@@ -775,40 +775,6 @@ EXPORT_SYMBOL(__cpu_present_mask);
 struct cpumask __cpu_active_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_active_mask);
 
-void set_cpu_possible(unsigned int cpu, bool possible)
-{
-	if (possible)
-		cpumask_set_cpu(cpu, &__cpu_possible_mask);
-	else
-		cpumask_clear_cpu(cpu, &__cpu_possible_mask);
-}
-
-void set_cpu_present(unsigned int cpu, bool present)
-{
-	if (present)
-		cpumask_set_cpu(cpu, &__cpu_present_mask);
-	else
-		cpumask_clear_cpu(cpu, &__cpu_present_mask);
-}
-
-void set_cpu_online(unsigned int cpu, bool online)
-{
-	if (online) {
-		cpumask_set_cpu(cpu, &__cpu_online_mask);
-		cpumask_set_cpu(cpu, &__cpu_active_mask);
-	} else {
-		cpumask_clear_cpu(cpu, &__cpu_online_mask);
-	}
-}
-
-void set_cpu_active(unsigned int cpu, bool active)
-{
-	if (active)
-		cpumask_set_cpu(cpu, &__cpu_active_mask);
-	else
-		cpumask_clear_cpu(cpu, &__cpu_active_mask);
-}

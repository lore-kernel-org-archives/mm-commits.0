From: akpm@linux-foundation.org
Subject: + tile-move-tile-to-use-generic-on_each_cpu_mask.patch added to -mm tree
Date: Fri, 27 Jan 2012 16:15:41 -0800
Message-ID: <20120128001541.D8FB0A043A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:52838 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab2A1APm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jan 2012 19:15:42 -0500
Received: by yenr8 with SMTP id r8so218726yen.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2012 16:15:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gilad@benyossef.com, a.p.zijlstra@chello.nl, cmetcalf@tilera.com


The patch titled
     Subject: tile: move tile to use generic on_each_cpu_mask
has been added to the -mm tree.  Its filename is
     tile-move-tile-to-use-generic-on_each_cpu_mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: tile: move tile to use generic on_each_cpu_mask

The API is the same as the tile private one, but the generic version
also calls the function on the with interrupts disabled in UP case

This is OK since the function is called on the other CPUs
with interrupts disabled.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/include/asm/smp.h |    7 -------
 arch/tile/kernel/smp.c      |   19 -------------------
 2 files changed, 26 deletions(-)

diff -puN arch/tile/include/asm/smp.h~tile-move-tile-to-use-generic-on_each_cpu_mask arch/tile/include/asm/smp.h
--- a/arch/tile/include/asm/smp.h~tile-move-tile-to-use-generic-on_each_cpu_mask
+++ a/arch/tile/include/asm/smp.h
@@ -43,10 +43,6 @@ void evaluate_message(int tag);
 /* Boot a secondary cpu */
 void online_secondary(void);
 
-/* Call a function on a specified set of CPUs (may include this one). */
-extern void on_each_cpu_mask(const struct cpumask *mask,
-			     void (*func)(void *), void *info, bool wait);
-
 /* Topology of the supervisor tile grid, and coordinates of boot processor */
 extern HV_Topology smp_topology;
 
@@ -91,9 +87,6 @@ void print_disabled_cpus(void);
 
 #else /* !CONFIG_SMP */
 
-#define on_each_cpu_mask(mask, func, info, wait)		\
-  do { if (cpumask_test_cpu(0, (mask))) func(info); } while (0)
-
 #define smp_master_cpu		0
 #define smp_height		1
 #define smp_width		1
diff -puN arch/tile/kernel/smp.c~tile-move-tile-to-use-generic-on_each_cpu_mask arch/tile/kernel/smp.c
--- a/arch/tile/kernel/smp.c~tile-move-tile-to-use-generic-on_each_cpu_mask
+++ a/arch/tile/kernel/smp.c
@@ -87,25 +87,6 @@ void send_IPI_allbutself(int tag)
 	send_IPI_many(&mask, tag);
 }
 
-
-/*
- * Provide smp_call_function_mask, but also run function locally
- * if specified in the mask.
- */
-void on_each_cpu_mask(const struct cpumask *mask, void (*func)(void *),
-		      void *info, bool wait)
-{
-	int cpu = get_cpu();
-	smp_call_function_many(mask, func, info, wait);
-	if (cpumask_test_cpu(cpu, mask)) {
-		local_irq_disable();
-		func(info);
-		local_irq_enable();
-	}
-	put_cpu();
-}
-

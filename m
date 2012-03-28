From: akpm@linux-foundation.org
Subject: [folded] tile-move-tile-to-use-generic-on_each_cpu_mask.patch removed from -mm tree
Date: Wed, 28 Mar 2012 14:28:26 -0700
Message-ID: <20120328212826.3C891A0443@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:55272 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932969Ab2C1V22 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Mar 2012 17:28:28 -0400
Received: by wibhj13 with SMTP id hj13so81400wib.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 14:28:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gilad@benyossef.com, a.p.zijlstra@chello.nl, cmetcalf@tilera.com, mina86@mina86.org, mm-commits@vger.kernel.org


The patch titled
     Subject: tile: move tile to use generic on_each_cpu_mask
has been removed from the -mm tree.  Its filename was
     tile-move-tile-to-use-generic-on_each_cpu_mask.patch

This patch was dropped because it was folded into smp-introduce-a-generic-on_each_cpu_mask-function.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
Acked-by: Michal Nazarewicz <mina86@mina86.org>

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

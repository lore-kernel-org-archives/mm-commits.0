From: akpm@linux-foundation.org
Subject: - cell-fix-cbe_cpufreq-for-legacy-slof-tree.patch removed from -mm tree
Date: Wed, 18 Jul 2007 17:23:41 -0700
Message-ID: <200707190023.l6J0Nftn004735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44146 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932329AbXGSAYm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 20:24:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jcd@tribudubois.net, arnd.bergmann@de.ibm.com, krafft@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cell: fix cbe_cpufreq for legacy SLOF tree.
has been removed from the -mm tree.  Its filename was
     cell-fix-cbe_cpufreq-for-legacy-slof-tree.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: cell: fix cbe_cpufreq for legacy SLOF tree.
From: Jean-Christophe DUBOIS <jcd@tribudubois.net>

Previous patch changed based on Christian Krafft's comment.

On some legacy SLOF tree the generic code is unable to ioremap some Cell BE
registers.  Therefore the "generic" functions are returning a NULL pointer,
triggering a crash on such platforms.

Let's handle this more gracefully.

Signed-off-by: Jean-Christophe DUBOIS <jcd@tribudubois.net>
Acked-by: Christian Kraff <krafft@de.ibm.com>
Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/cbe_cpufreq.c |   10 ++++++++++
 1 files changed, 10 insertions(+)

diff -puN arch/powerpc/platforms/cell/cbe_cpufreq.c~cell-fix-cbe_cpufreq-for-legacy-slof-tree arch/powerpc/platforms/cell/cbe_cpufreq.c
--- a/arch/powerpc/platforms/cell/cbe_cpufreq.c~cell-fix-cbe_cpufreq-for-legacy-slof-tree
+++ a/arch/powerpc/platforms/cell/cbe_cpufreq.c
@@ -24,6 +24,7 @@
 #include <asm/machdep.h>
 #include <asm/of_platform.h>
 #include <asm/prom.h>
+#include "cbe_regs.h"
 #include "cbe_cpufreq.h"
 
 static DEFINE_MUTEX(cbe_switch_mutex);
@@ -78,6 +79,15 @@ static int cbe_cpufreq_cpu_init(struct c
 
 	pr_debug("init cpufreq on CPU %d\n", policy->cpu);
 
+	/*
+	 * Let's check we can actually get to the CELL regs
+	 */
+	if (!cbe_get_cpu_pmd_regs(policy->cpu) ||
+	    !cbe_get_cpu_mic_tm_regs(policy->cpu)) {
+		pr_info("invalid CBE regs pointers for cpufreq\n");
+		return -EINVAL;
+	}
+
 	max_freqp = of_get_property(cpu, "clock-frequency", NULL);
 
 	of_node_put(cpu);
_

Patches currently in -mm which might be from jcd@tribudubois.net are

cell-fix-cbe_cpufreq-for-legacy-slof-tree.patch
cell-fix-cbe_regc-for-legacy-slof-tree.patch
cell-fix-cbe_thermal-for-legacy-slof-tree.patch
cell-allow-linux-to-map-cell-regs-on-legacy-slof-tree.patch

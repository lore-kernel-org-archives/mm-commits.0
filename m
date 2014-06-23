From: akpm@linux-foundation.org
Subject: [folded-merged]
 cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v3.patch removed from -mm tree
Date: Mon, 23 Jun 2014 13:08:44 -0700
Message-ID: <53a8894c.K0UEl9DL5QX5dppq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaFWUIp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 16:08:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sachin.kamat@samsung.com, srivatsa.bhat@linux.vnet.ibm.com


The patch titled
     Subject: cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v3
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v3.patch

This patch was dropped because it was folded into cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch

------------------------------------------------------
From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v3

Update: Move the switch-case handling for CPU_DYING such that
CPU_UP_CANCELED falls-through to CPU_DEAD (instead of CPU_DYING).  Also,
add an explicit comment mentioning this.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Tested-by: Sachin Kamat <sachin.kamat@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN kernel/smp.c~cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v3 kernel/smp.c
--- a/kernel/smp.c~cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v3
+++ a/kernel/smp.c
@@ -53,6 +53,13 @@ hotplug_cfd(struct notifier_block *nfb,
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
+		/* Fall-through to the CPU_DEAD[_FROZEN] case. */
+
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		free_cpumask_var(cfd->cpumask);
+		free_percpu(cfd->csd);
+		break;
 
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
@@ -67,12 +74,6 @@ hotplug_cfd(struct notifier_block *nfb,
 		 */
 		flush_smp_call_function_queue(false);
 		break;

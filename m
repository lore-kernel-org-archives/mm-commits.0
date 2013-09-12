From: akpm@linux-foundation.org
Subject: [merged]
 kernel-smpc-free-related-resources-when-failure-occurs-in-hotplug_cfd.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:46:13 -0700
Message-ID: <52321a05.CW+YwE4GSu87h+gV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab3ILTqO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:46:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, udknight@gmail.com, gang.chen@asianux.com

Subject: [merged] kernel-smpc-free-related-resources-when-failure-occurs-in-hotplug_cfd.patch removed from -mm tree
To: gang.chen@asianux.com,udknight@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:46:13 -0700


The patch titled
     Subject: kernel/smp.c: free related resources when failure occurs in hotplug_cfd()
has been removed from the -mm tree.  Its filename was
     kernel-smpc-free-related-resources-when-failure-occurs-in-hotplug_cfd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: kernel/smp.c: free related resources when failure occurs in hotplug_cfd()

When failure occurs in hotplug_cfd(), need release related resources, or
will cause memory leak.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Acked-by: Wang YanQing <udknight@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/smp.c~kernel-smpc-free-related-resources-when-failure-occurs-in-hotplug_cfd kernel/smp.c
--- a/kernel/smp.c~kernel-smpc-free-related-resources-when-failure-occurs-in-hotplug_cfd
+++ a/kernel/smp.c
@@ -48,10 +48,13 @@ hotplug_cfd(struct notifier_block *nfb,
 				cpu_to_node(cpu)))
 			return notifier_from_errno(-ENOMEM);
 		if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi, GFP_KERNEL,
-				cpu_to_node(cpu)))
+				cpu_to_node(cpu))) {
+			free_cpumask_var(cfd->cpumask);
 			return notifier_from_errno(-ENOMEM);
+		}
 		cfd->csd = alloc_percpu(struct call_single_data);
 		if (!cfd->csd) {
+			free_cpumask_var(cfd->cpumask_ipi);
 			free_cpumask_var(cfd->cpumask);
 			return notifier_from_errno(-ENOMEM);
 		}
_

Patches currently in -mm which might be from gang.chen@asianux.com are

origin.patch
sh64-kernel-use-usp-instead-of-fn.patch
sh64-kernel-remove-useless-variable-regs.patch
include-linux-interrupth-add-dummy-irq_set_irq_wake-for-generic_hardirqs.patch
h8300-kernel-timer-timer8c-add-missing-semicolon.patch
mm-kconfig-add-mmu-dependency-for-migration.patch


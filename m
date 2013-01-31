From: akpm@linux-foundation.org
Subject: [merged] smp-fix-use-un-initialized-cpumask_ipi.patch removed from -mm tree
Date: Thu, 31 Jan 2013 12:06:36 -0800
Message-ID: <20130131200637.978D431C107@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:58300 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab3AaUGi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Jan 2013 15:06:38 -0500
Received: by mail-qe0-f73.google.com with SMTP id 7so285386qeb.2
        for <mm-commits@vger.kernel.org>; Thu, 31 Jan 2013 12:06:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: udknight@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: smp: Fix use un-initialized cpumask_ipi
has been removed from the -mm tree.  Its filename was
     smp-fix-use-un-initialized-cpumask_ipi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang YanQing <udknight@gmail.com>
Subject: smp: Fix use un-initialized cpumask_ipi

c7b798525b502 ("smp: Fix SMP function call empty cpu mask race") use the
un-initialized variable cpumask_ipi when enable CONFIG_CPUMASK_OFFSTACK.

Signed-off-by: Wang YanQing <udknight@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/smp.c~smp-fix-use-un-initialized-cpumask_ipi kernel/smp.c
--- a/kernel/smp.c~smp-fix-use-un-initialized-cpumask_ipi
+++ a/kernel/smp.c
@@ -57,6 +57,9 @@ hotplug_cfd(struct notifier_block *nfb, 
 		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
 				cpu_to_node(cpu)))
 			return notifier_from_errno(-ENOMEM);
+		if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi, GFP_KERNEL,
+				cpu_to_node(cpu)))
+			return notifier_from_errno(-ENOMEM);
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -66,6 +69,7 @@ hotplug_cfd(struct notifier_block *nfb, 
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		free_cpumask_var(cfd->cpumask);
+		free_cpumask_var(cfd->cpumask_ipi);
 		break;
 #endif
 	};
_

Patches currently in -mm which might be from udknight@gmail.com are

origin.patch
linux-next.patch


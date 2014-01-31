From: akpm@linux-foundation.org
Subject: [merged] kernel-smpc-remove-cpumask_ipi.patch removed from -mm
 tree
Date: Fri, 31 Jan 2014 11:16:05 -0800
Message-ID: <52ebf675.BfBy7ES4pjTyk/WO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412AbaAaTQG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 14:16:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xiexiuqi@huawei.com, udknight@gmail.com, shli@fusionio.com, mingo@kernel.org, hch@lst.de, a.p.zijlstra@chello.nl, klamm@yandex-team.ru

Subject: [merged] kernel-smpc-remove-cpumask_ipi.patch removed from -mm tree
To: klamm@yandex-team.ru,a.p.zijlstra@chello.nl,hch@lst.de,mingo@kernel.org,shli@fusionio.com,udknight@gmail.com,xiexiuqi@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 11:16:05 -0800


The patch titled
     Subject: kernel/smp.c: remove cpumask_ipi
has been removed from the -mm tree.  Its filename was
     kernel-smpc-remove-cpumask_ipi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <klamm@yandex-team.ru>
Subject: kernel/smp.c: remove cpumask_ipi

After 9a46ad6 ("smp: make smp_call_function_many() use logic similar to
smp_call_function_single()"), cfd->cpumask is accessed only in
smp_call_function_many().  So there is no more need to copy it into
cfd->cpumask_ipi before putting csd into the list.  The cpumask_ipi field
is obsolete and can be removed.

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Wang YanQing <udknight@gmail.com>
Cc: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff -puN kernel/smp.c~kernel-smpc-remove-cpumask_ipi kernel/smp.c
--- a/kernel/smp.c~kernel-smpc-remove-cpumask_ipi
+++ a/kernel/smp.c
@@ -23,7 +23,6 @@ enum {
 struct call_function_data {
 	struct call_single_data	__percpu *csd;
 	cpumask_var_t		cpumask;
-	cpumask_var_t		cpumask_ipi;
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_function_data, cfd_data);
@@ -42,14 +41,8 @@ hotplug_cfd(struct notifier_block *nfb,
 		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
 				cpu_to_node(cpu)))
 			return notifier_from_errno(-ENOMEM);
-		if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi, GFP_KERNEL,
-				cpu_to_node(cpu))) {
-			free_cpumask_var(cfd->cpumask);
-			return notifier_from_errno(-ENOMEM);
-		}
 		cfd->csd = alloc_percpu(struct call_single_data);
 		if (!cfd->csd) {
-			free_cpumask_var(cfd->cpumask_ipi);
 			free_cpumask_var(cfd->cpumask);
 			return notifier_from_errno(-ENOMEM);
 		}
@@ -62,7 +55,6 @@ hotplug_cfd(struct notifier_block *nfb,
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		free_cpumask_var(cfd->cpumask);
-		free_cpumask_var(cfd->cpumask_ipi);
 		free_percpu(cfd->csd);
 		break;
 #endif
@@ -383,13 +375,6 @@ void smp_call_function_many(const struct
 	if (unlikely(!cpumask_weight(cfd->cpumask)))
 		return;
 
-	/*
-	 * After we put an entry into the list, cfd->cpumask may be cleared
-	 * again when another CPU sends another IPI for a SMP function call, so
-	 * cfd->cpumask will be zero.
-	 */
-	cpumask_copy(cfd->cpumask_ipi, cfd->cpumask);

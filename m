From: akpm@osdl.org
Subject: - ehca-avoid-crash-on-kthread_create-failure.patch removed from -mm tree
Date: Sun, 28 Jan 2007 11:02:15 -0800
Message-ID: <200701281902.l0SJ2Ffd001410@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35016 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbXA1TC2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Jan 2007 14:02:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, heiko.carstens@de.ibm.com, hnguyen@de.ibm.com, muli@il.ibm.com, raisch@de.ibm.com, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     ehca: avoid crash on kthread_create() failure
has been removed from the -mm tree.  Its filename was
     ehca-avoid-crash-on-kthread_create-failure.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: ehca: avoid crash on kthread_create() failure
From: Akinobu Mita <akinobu.mita@gmail.com>

This patch disallows invalid task_struct pointer returned by
kthread_create() to be written to percpu data to avoid crash.

Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/infiniband/hw/ehca/ehca_irq.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN drivers/infiniband/hw/ehca/ehca_irq.c~ehca-avoid-crash-on-kthread_create-failure drivers/infiniband/hw/ehca/ehca_irq.c
--- a/drivers/infiniband/hw/ehca/ehca_irq.c~ehca-avoid-crash-on-kthread_create-failure
+++ a/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -607,15 +607,20 @@ static int comp_task(void *__cct)
 static struct task_struct *create_comp_task(struct ehca_comp_pool *pool,
 					    int cpu)
 {
+	struct task_struct *task;
 	struct ehca_cpu_comp_task *cct;
 
 	cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
 	spin_lock_init(&cct->task_lock);
 	INIT_LIST_HEAD(&cct->cq_list);
 	init_waitqueue_head(&cct->wait_queue);
-	cct->task = kthread_create(comp_task, cct, "ehca_comp/%d", cpu);
+	task = kthread_create(comp_task, cct, "ehca_comp/%d", cpu);
+	if (!IS_ERR(task))
+		cct->task = task;
+	else
+		cct->task = NULL;
 
-	return cct->task;
+	return task;
 }
 
 static void destroy_comp_task(struct ehca_comp_pool *pool,
@@ -683,8 +688,10 @@ static int comp_pool_callback(struct not
 	case CPU_UP_CANCELED:
 		ehca_gen_dbg("CPU: %x (CPU_CANCELED)", cpu);
 		cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
-		kthread_bind(cct->task, any_online_cpu(cpu_online_map));
-		destroy_comp_task(pool, cpu);
+		if (cct->task) {
+			kthread_bind(cct->task, any_online_cpu(cpu_online_map));
+			destroy_comp_task(pool, cpu);
+		}
 		break;
 	case CPU_ONLINE:
 		ehca_gen_dbg("CPU: %x (CPU_ONLINE)", cpu);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

git-powerpc.patch
ehca-avoid-crash-on-kthread_create-failure.patch
ehca-fix-memleak-on-module-unloading.patch
git-input.patch
git-netdev-all.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
git-s390.patch
git-watchdog.patch
simplify-the-stacktrace-code.patch

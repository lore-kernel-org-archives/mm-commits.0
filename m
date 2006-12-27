From: akpm@osdl.org
Subject: + return-error-on-create_comp_task-failure.patch added to -mm tree
Date: Wed, 27 Dec 2006 00:05:37 -0800
Message-ID: <200612270805.kBR85bDB005141@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38485 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932970AbWL0IGE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 03:06:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, heiko.carstens@de.ibm.com, hnguyen@de.ibm.com, raisch@de.ibm.com, rolandd@cisco.com


The patch titled
     Return error on create_comp_task() failure
has been added to the -mm tree.  Its filename is
     return-error-on-create_comp_task-failure.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Return error on create_comp_task() failure
From: Akinobu Mita <akinobu.mita@gmail.com>

Free allocated data and returns error to avoid module loading if
create_comp_task() failed.

Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/infiniband/hw/ehca/ehca_irq.c |   37 ++++++++++++++++++------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff -puN drivers/infiniband/hw/ehca/ehca_irq.c~return-error-on-create_comp_task-failure drivers/infiniband/hw/ehca/ehca_irq.c
--- a/drivers/infiniband/hw/ehca/ehca_irq.c~return-error-on-create_comp_task-failure
+++ a/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -718,11 +718,12 @@ static int comp_pool_callback(struct not
 
 #endif
 
+#ifdef CONFIG_INFINIBAND_EHCA_SCALING
+
 int ehca_create_comp_pool(void)
 {
-#ifdef CONFIG_INFINIBAND_EHCA_SCALING
 	int cpu;
-	struct task_struct *task;
+	int err;
 
 	pool = kzalloc(sizeof(struct ehca_comp_pool), GFP_KERNEL);
 	if (pool == NULL)
@@ -738,21 +739,41 @@ int ehca_create_comp_pool(void)
 	}
 
 	for_each_online_cpu(cpu) {
-		task = create_comp_task(pool, cpu);
-		if (!IS_ERR(task)) {
-			kthread_bind(task, cpu);
-			wake_up_process(task);
+		struct task_struct *task = create_comp_task(pool, cpu);
+
+		if (IS_ERR(task)) {
+			err = PTR_ERR(task);
+			goto err_comp_task;
 		}
+		kthread_bind(task, cpu);
+		wake_up_process(task);
 	}
 
 	comp_pool_callback_nb.notifier_call = comp_pool_callback;
-	comp_pool_callback_nb.priority =0;
+	comp_pool_callback_nb.priority = 0;
 	register_cpu_notifier(&comp_pool_callback_nb);
-#endif
 
 	return 0;
+
+err_comp_task:
+	for_each_online_cpu(cpu)
+		destroy_comp_task(pool, cpu);
+
+	free_percpu(pool->cpu_comp_tasks);
+	kfree(pool);
+
+	return err;
+}
+
+#else
+
+int ehca_create_comp_pool(void)
+{
+	return 0;
 }
 
+#endif
+
 void ehca_destroy_comp_pool(void)
 {
 #ifdef CONFIG_INFINIBAND_EHCA_SCALING
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

powerpc-use-is_init.patch
git-dvb.patch
ehca-fix-kthread_create-error-check.patch
ehca-fix-do_mmap-error-check.patch
ehca-avoid-crash-on-kthread_create-failure.patch
return-error-on-create_comp_task-failure.patch
git-input.patch
git-mtd.patch
net-use-bitrev8.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
iscsi-fix-crypto_alloc_hash-error-check.patch
git-watchdog.patch


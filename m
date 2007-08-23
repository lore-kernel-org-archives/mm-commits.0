From: akpm@linux-foundation.org
Subject: + ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch added to -mm tree
Date: Thu, 23 Aug 2007 15:55:47 -0700
Message-ID: <200708232255.l7NMtlpg031256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49800 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759703AbXHWWzz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 18:55:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, rolandd@cisco.com


The patch titled
     ehca_irq: misc cpuinit section annotations and #ifdef cleanups
has been added to the -mm tree.  Its filename is
     ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ehca_irq: misc cpuinit section annotations and #ifdef cleanups
From: Satyam Sharma <satyam@infradead.org>

* Replace {un}register_cpu_notifier with {un}register_hotcpu_notifier
  thereby losing a couple of #ifdef HOTPLUG_CPU pairs.
* Move comp_pool_callback_nb declaration to below that of callback
  function so that initialization of .notifier_call and .priority can
  occur at build time itself and not runtime.
* Mark the notifier_block (and callback function, and another static
  function used by it) as __cpuinit{data} for the sake of consistency
  and remove enclosing #ifdef. (This may increase size for modular
  build of this module, however, because these are no longer dropped
  unconditionally now.)

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/ehca/ehca_irq.c |   29 +++++++++---------------
 1 files changed, 11 insertions(+), 18 deletions(-)

diff -puN drivers/infiniband/hw/ehca/ehca_irq.c~ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups drivers/infiniband/hw/ehca/ehca_irq.c
--- a/drivers/infiniband/hw/ehca/ehca_irq.c~ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups
+++ a/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -69,9 +69,6 @@
 static void queue_comp_task(struct ehca_cq *__cq);
 
 static struct ehca_comp_pool *pool;
-#ifdef CONFIG_HOTPLUG_CPU
-static struct notifier_block comp_pool_callback_nb;
-#endif
 
 static inline void comp_event_callback(struct ehca_cq *cq)
 {
@@ -746,9 +743,7 @@ static void destroy_comp_task(struct ehc
 		kthread_stop(task);
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-static void take_over_work(struct ehca_comp_pool *pool,
-			   int cpu)
+static void __cpuinit take_over_work(struct ehca_comp_pool *pool, int cpu)
 {
 	struct ehca_cpu_comp_task *cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
 	LIST_HEAD(list);
@@ -771,9 +766,9 @@ static void take_over_work(struct ehca_c
 
 }
 
-static int comp_pool_callback(struct notifier_block *nfb,
-			      unsigned long action,
-			      void *hcpu)
+static int __cpuinit comp_pool_callback(struct notifier_block *nfb,
+					unsigned long action,
+					void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
 	struct ehca_cpu_comp_task *cct;
@@ -819,7 +814,11 @@ static int comp_pool_callback(struct not
 
 	return NOTIFY_OK;
 }
-#endif
+
+static struct notifier_block comp_pool_callback_nb __cpuinitdata = {
+	.notifier_call	= comp_pool_callback,
+	.priority	= 0,
+};
 
 int ehca_create_comp_pool(void)
 {
@@ -850,11 +849,7 @@ int ehca_create_comp_pool(void)
 		}
 	}
 
-#ifdef CONFIG_HOTPLUG_CPU
-	comp_pool_callback_nb.notifier_call = comp_pool_callback;
-	comp_pool_callback_nb.priority = 0;
-	register_cpu_notifier(&comp_pool_callback_nb);
-#endif
+	register_hotcpu_notifier(&comp_pool_callback_nb);
 
 	printk(KERN_INFO "eHCA scaling code enabled\n");
 
@@ -868,9 +863,7 @@ void ehca_destroy_comp_pool(void)
 	if (!ehca_scaling_code)
 		return;
 
-#ifdef CONFIG_HOTPLUG_CPU
-	unregister_cpu_notifier(&comp_pool_callback_nb);
-#endif
+	unregister_hotcpu_notifier(&comp_pool_callback_nb);
 
 	for (i = 0; i < NR_CPUS; i++) {
 		if (cpu_online(i))
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
git-ieee1394.patch
ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch
git-netdev-all.patch
git-net.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
therm_throtc-fix-section-mismatch.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu.patch

From: akpm@linux-foundation.org
Subject: [merged] isdn-capi-make-kcapi-use-a-separate-workqueue.patch removed from -mm tree
Date: Tue, 28 Dec 2010 12:19:45 -0800
Message-ID: <201012282020.oBSKKE6M015711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751903Ab0L1UUr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Dec 2010 15:20:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, isdn@linux-pingi.de, jan.kiszka@web.de, mac@melware.de, mm-commits@vger.kernel.org


The patch titled
     isdn/capi: make kcapi use a separate workqueue
has been removed from the -mm tree.  Its filename was
     isdn-capi-make-kcapi-use-a-separate-workqueue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn/capi: make kcapi use a separate workqueue
From: Tejun Heo <tj@kernel.org>

flush_scheduled_work() is deprecated and will be removed.  Because kcapi
uses fire-and-forget type works, it's impossible to flush each work
explicitly.  Create and use a dedicated workqueue instead.

Please note that with recent workqueue changes, each workqueue doesn't
reserve a lot of resources and using it as a flush domain is fine.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: Armin Schindler <mac@melware.de>
Cc: Jan Kiszka <jan.kiszka@web.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/kcapi.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff -puN drivers/isdn/capi/kcapi.c~isdn-capi-make-kcapi-use-a-separate-workqueue drivers/isdn/capi/kcapi.c
--- a/drivers/isdn/capi/kcapi.c~isdn-capi-make-kcapi-use-a-separate-workqueue
+++ a/drivers/isdn/capi/kcapi.c
@@ -38,6 +38,7 @@
 #include <linux/rcupdate.h>
 
 static int showcapimsgs = 0;
+static struct workqueue_struct *kcapi_wq;
 
 MODULE_DESCRIPTION("CAPI4Linux: kernel CAPI layer");
 MODULE_AUTHOR("Carsten Paeth");
@@ -291,7 +292,7 @@ static int notify_push(unsigned int even
 	event->type = event_type;
 	event->controller = controller;
 
-	schedule_work(&event->work);
+	queue_work(kcapi_wq, &event->work);
 	return 0;
 }
 
@@ -408,7 +409,7 @@ void capi_ctr_handle_message(struct capi
 		goto error;
 	}
 	skb_queue_tail(&ap->recv_queue, skb);
-	schedule_work(&ap->recv_work);
+	queue_work(kcapi_wq, &ap->recv_work);
 	rcu_read_unlock();
 
 	return;
@@ -743,7 +744,7 @@ u16 capi20_release(struct capi20_appl *a
 
 	mutex_unlock(&capi_controller_lock);
 
-	flush_scheduled_work();
+	flush_workqueue(kcapi_wq);
 	skb_queue_purge(&ap->recv_queue);
 
 	if (showcapimsgs & 1) {
@@ -1285,21 +1286,30 @@ static int __init kcapi_init(void)
 {
 	int err;
 
+	kcapi_wq = alloc_workqueue("kcapi", 0, 0);
+	if (!kcapi_wq)
+		return -ENOMEM;
+
 	register_capictr_notifier(&capictr_nb);
 
 	err = cdebug_init();
-	if (!err)
-		kcapi_proc_init();
-	return err;
+	if (err) {
+		unregister_capictr_notifier(&capictr_nb);
+		destroy_workqueue(kcapi_wq);
+		return err;
+	}
+
+	kcapi_proc_init();
+	return 0;
 }
 
 static void __exit kcapi_exit(void)
 {
         kcapi_proc_exit();
 
-	/* make sure all notifiers are finished */
-	flush_scheduled_work();
+	unregister_capictr_notifier(&capictr_nb);
 	cdebug_exit();
+	destroy_workqueue(kcapi_wq);
 }
 
 module_init(kcapi_init);
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
irq-use-per_cpu-kstat_irqs.patch
drivers-video-backlight-l4f00242t03c-full-implement-fb-power-states-for-this-lcd.patch
drivers-video-backlight-l4f00242t03c-prevent-unbalanced-calls-to-regulator-enable-disable.patch
mm-remove-gfp-mask-from-pcpu_get_vm_areas.patch
mm-numa-aware-alloc_task_struct_node.patch
mm-numa-aware-alloc_thread_info_node.patch
kthread-numa-aware-kthread_create_on_cpu.patch
kthread-use-kthread_create_on_cpu.patch
include-asm-generic-vmlinuxldsh-make-readmostly-section-correctly-align.patch
percpu-add-new-macros-to-make-percpu-readmostly-section-correctly-align.patch


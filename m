From: akpm@linux-foundation.org
Subject: + isdn-capi-make-kcapi-use-a-separate-workqueue.patch added to -mm tree
Date: Fri, 22 Oct 2010 13:05:59 -0700
Message-ID: <201010222005.o9MK5xp6004949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754186Ab0JVUGi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Oct 2010 16:06:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, isdn@linux-pingi.de, jan.kiszka@web.de, mac@melware.de


The patch titled
     isdn/capi: make kcapi use a separate workqueue
has been added to the -mm tree.  Its filename is
     isdn-capi-make-kcapi-use-a-separate-workqueue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
percpu-fix-list_head-init-bug-in-__percpu_counter_init.patch
linux-next.patch
isdn-capi-unregister-capictr-notifier-after-init-failure.patch
isdn-capi-make-kcapi-use-a-separate-workqueue.patch
stop_machine-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
percpu_counter-add-debugobj-support.patch
percpu_counter-use-this_cpu_ptr-instead-of-per_cpu_ptr.patch
pps-trivial-fixes.patch
pps-declare-variables-where-they-are-used-in-switch.patch
pps-fix-race-in-pps_fetch-handler.patch
pps-unify-timestamp-gathering.patch
pps-access-pps-device-by-direct-pointer.patch
pps-convert-printk-pr_-to-dev_.patch
pps-move-idr-stuff-to-ppsc.patch
pps-add-async-pps-event-handler.patch
pps-add-async-pps-event-handler-fix.patch
pps-dont-disable-interrupts-when-using-spin-locks.patch
pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
ntp-add-hardpps-implementation.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-signal-generator.patch


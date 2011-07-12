From: akpm@linux-foundation.org
Subject: + vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue.patch added to -mm tree
Date: Tue, 12 Jul 2011 15:21:18 -0700
Message-ID: <201107122221.p6CMLJdX007234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755990Ab1GLWVk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jul 2011 18:21:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dtor@vmware.com, tj@kernel.org


The patch titled
     Vmware balloon: switch to using sysem-wide freezable workqueue
has been added to the -mm tree.  Its filename is
     vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue.patch

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
Subject: Vmware balloon: switch to using sysem-wide freezable workqueue
From: Dmitry Torokhov <dtor@vmware.com>

With the arrival of concurrency-managed workqueues there is no need for
our driver to use dedicated workqueue; system-wide one should suffice just
fine.

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/vmw_balloon.c |   31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff -puN drivers/misc/vmw_balloon.c~vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue drivers/misc/vmw_balloon.c
--- a/drivers/misc/vmw_balloon.c~vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue
+++ a/drivers/misc/vmw_balloon.c
@@ -45,7 +45,7 @@
 
 MODULE_AUTHOR("VMware, Inc.");
 MODULE_DESCRIPTION("VMware Memory Control (Balloon) Driver");
-MODULE_VERSION("1.2.1.2-k");
+MODULE_VERSION("1.2.1.3-k");
 MODULE_ALIAS("dmi:*:svnVMware*:*");
 MODULE_ALIAS("vmware_vmmemctl");
 MODULE_LICENSE("GPL");
@@ -215,7 +215,6 @@ struct vmballoon {
 };
 
 static struct vmballoon balloon;
-static struct workqueue_struct *vmballoon_wq;
 
 /*
  * Send "start" command to the host, communicating supported version
@@ -674,7 +673,12 @@ static void vmballoon_work(struct work_s
 			vmballoon_deflate(b);
 	}
 
-	queue_delayed_work(vmballoon_wq, dwork, round_jiffies_relative(HZ));
+	/*
+	 * We are using freezable workqueue so that balloon operations are
+	 * stopped while system transitions to/from sleep/hibernation.
+	*/
+	queue_delayed_work(system_freezable_wq,
+			   dwork, round_jiffies_relative(HZ));
 }
 
 /*
@@ -785,12 +789,6 @@ static int __init vmballoon_init(void)
 	if (x86_hyper != &x86_hyper_vmware)
 		return -ENODEV;
 
-	vmballoon_wq = create_freezable_workqueue("vmmemctl");
-	if (!vmballoon_wq) {
-		pr_err("failed to create workqueue\n");
-		return -ENOMEM;
-	}
-
 	INIT_LIST_HEAD(&balloon.pages);
 	INIT_LIST_HEAD(&balloon.refused_pages);
 
@@ -805,34 +803,27 @@ static int __init vmballoon_init(void)
 	 */
 	if (!vmballoon_send_start(&balloon)) {
 		pr_err("failed to send start command to the host\n");
-		error = -EIO;
-		goto fail;
+		return -EIO;
 	}
 
 	if (!vmballoon_send_guest_id(&balloon)) {
 		pr_err("failed to send guest ID to the host\n");
-		error = -EIO;
-		goto fail;
+		return -EIO;
 	}
 
 	error = vmballoon_debugfs_init(&balloon);
 	if (error)
-		goto fail;
+		return error;
 
-	queue_delayed_work(vmballoon_wq, &balloon.dwork, 0);
+	queue_delayed_work(system_freezable_wq, &balloon.dwork, 0);
 
 	return 0;

From: akpm@linux-foundation.org
Subject: + net-ehea-ehea_fw_handles-semaphore-to-mutex.patch added to -mm tree
Date: Thu, 20 Mar 2008 14:49:14 -0700
Message-ID: <200803202149.m2KLnEjG025767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757382AbYCTVxH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Mar 2008 17:53:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, jeff@garzik.org, raisch@de.ibm.com, themann@de.ibm.com, tklein@de.ibm.com


The patch titled
     netdev: ehea: ehea_fw_handles semaphore to mutex
has been added to the -mm tree.  Its filename is
     net-ehea-ehea_fw_handles-semaphore-to-mutex.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: netdev: ehea: ehea_fw_handles semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>

Converted the ehea_fw_handles.lock to a mutex.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Raisch <raisch@de.ibm.com>
Cc: Jan-Bernd Themann <themann@de.ibm.com>
Cc: Thomas Klein <tklein@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ehea/ehea.h      |    2 +-
 drivers/net/ehea/ehea_main.c |   18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/net/ehea/ehea.h~net-ehea-ehea_fw_handles-semaphore-to-mutex drivers/net/ehea/ehea.h
--- a/drivers/net/ehea/ehea.h~net-ehea-ehea_fw_handles-semaphore-to-mutex
+++ a/drivers/net/ehea/ehea.h
@@ -421,7 +421,7 @@ struct ehea_fw_handle_entry {
 struct ehea_fw_handle_array {
 	struct ehea_fw_handle_entry *arr;
 	int num_entries;
-	struct semaphore lock;
+	struct mutex lock;
 };
 
 struct ehea_bcmc_reg_entry {
diff -puN drivers/net/ehea/ehea_main.c~net-ehea-ehea_fw_handles-semaphore-to-mutex drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~net-ehea-ehea_fw_handles-semaphore-to-mutex
+++ a/drivers/net/ehea/ehea_main.c
@@ -2453,7 +2453,7 @@ static int ehea_up(struct net_device *de
 	if (port->state == EHEA_PORT_UP)
 		return 0;
 
-	down(&ehea_fw_handles.lock);
+	mutex_lock(&ehea_fw_handles.lock);
 
 	ret = ehea_port_res_setup(port, port->num_def_qps,
 				  port->num_add_tx_qps);
@@ -2517,7 +2517,7 @@ out:
 	up(&ehea_bcmc_regs.lock);
 
 	ehea_update_firmware_handles();
-	up(&ehea_fw_handles.lock);
+	mutex_unlock(&ehea_fw_handles.lock);
 
 	return ret;
 }
@@ -2573,7 +2573,7 @@ static int ehea_down(struct net_device *
 
 	ehea_free_interrupts(dev);
 
-	down(&ehea_fw_handles.lock);
+	mutex_lock(&ehea_fw_handles.lock);
 
 	port->state = EHEA_PORT_DOWN;
 
@@ -2586,7 +2586,7 @@ static int ehea_down(struct net_device *
 			  dev->name, ret);
 
 	ehea_update_firmware_handles();
-	up(&ehea_fw_handles.lock);
+	mutex_unlock(&ehea_fw_handles.lock);
 
 	return ret;
 }
@@ -3343,7 +3343,7 @@ static int __devinit ehea_probe_adapter(
 		ehea_error("Invalid ibmebus device probed");
 		return -EINVAL;
 	}
-	down(&ehea_fw_handles.lock);
+	mutex_lock(&ehea_fw_handles.lock);
 
 	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
 	if (!adapter) {
@@ -3427,7 +3427,7 @@ out_free_ad:
 
 out:
 	ehea_update_firmware_handles();
-	up(&ehea_fw_handles.lock);
+	mutex_unlock(&ehea_fw_handles.lock);
 	return ret;
 }
 
@@ -3446,7 +3446,7 @@ static int __devexit ehea_remove(struct 
 
 	flush_scheduled_work();
 
-	down(&ehea_fw_handles.lock);
+	mutex_lock(&ehea_fw_handles.lock);
 
 	ibmebus_free_irq(adapter->neq->attr.ist1, adapter);
 	tasklet_kill(&adapter->neq_tasklet);
@@ -3457,7 +3457,7 @@ static int __devexit ehea_remove(struct 
 	kfree(adapter);
 
 	ehea_update_firmware_handles();
-	up(&ehea_fw_handles.lock);
+	mutex_unlock(&ehea_fw_handles.lock);
 
 	return 0;
 }
@@ -3544,7 +3544,7 @@ int __init ehea_module_init(void)
 	memset(&ehea_fw_handles, 0, sizeof(ehea_fw_handles));
 	memset(&ehea_bcmc_regs, 0, sizeof(ehea_bcmc_regs));
 
-	sema_init(&ehea_fw_handles.lock, 1);
+	mutex_init(&ehea_fw_handles.lock);
 	sema_init(&ehea_bcmc_regs.lock, 1);
 
 	ret = check_module_parm();
_

Patches currently in -mm which might be from dwalker@mvista.com are

net-ehea-semaphore-to-mutex.patch
net-ehea-ehea_fw_handles-semaphore-to-mutex.patch
net-ehea-locking-order-correction.patch
net-ehea-bcmc_regs-semaphore-to-mutex.patch
net-ehea-port_lock-semaphore-to-mutex.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch


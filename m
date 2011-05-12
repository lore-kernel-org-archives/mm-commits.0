From: akpm@linux-foundation.org
Subject: + edacrcu-use-synchronize_rcu-instead-of-call_rcurcu_barrier.patch added to -mm tree
Date: Thu, 12 May 2011 12:33:31 -0700
Message-ID: <201105121933.p4CJXVSF028809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756975Ab1ELTeU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 May 2011 15:34:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, dougthompson@xmission.com, mchehab@infradead.org, paulmck@linux.vnet.ibm.com


The patch titled
     edac,rcu: use synchronize_rcu() instead of call_rcu()+rcu_barrier()
has been added to the -mm tree.  Its filename is
     edacrcu-use-synchronize_rcu-instead-of-call_rcurcu_barrier.patch

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
Subject: edac,rcu: use synchronize_rcu() instead of call_rcu()+rcu_barrier()
From: Lai Jiangshan <laijs@cn.fujitsu.com>

synchronize_rcu() does the stuff as needed.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h   |   12 ------------
 drivers/edac/edac_device.c |   24 ++++++------------------
 drivers/edac/edac_mc.c     |   16 ++++++----------
 drivers/edac/edac_pci.c    |   21 ++++++---------------
 4 files changed, 18 insertions(+), 55 deletions(-)

diff -puN drivers/edac/edac_core.h~edacrcu-use-synchronize_rcu-instead-of-call_rcurcu_barrier drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~edacrcu-use-synchronize_rcu-instead-of-call_rcurcu_barrier
+++ a/drivers/edac/edac_core.h
@@ -421,10 +421,6 @@ struct mem_ctl_info {
 	u32 ce_count;		/* Total Correctable Errors for this MC */
 	unsigned long start_time;	/* mci load start time (in jiffies) */
 
-	/* this stuff is for safe removal of mc devices from global list while
-	 * NMI handlers may be traversing list
-	 */
-	struct rcu_head rcu;
 	struct completion complete;
 
 	/* edac sysfs device control */
@@ -620,10 +616,6 @@ struct edac_device_ctl_info {
 
 	unsigned long start_time;	/* edac_device load start time (jiffies) */
 
-	/* these are for safe removal of mc devices from global list while
-	 * NMI handlers may be traversing list
-	 */
-	struct rcu_head rcu;
 	struct completion removal_complete;
 
 	/* sysfs top name under 'edac' directory
@@ -722,10 +714,6 @@ struct edac_pci_ctl_info {
 
 	unsigned long start_time;	/* edac_pci load start time (jiffies) */
 
-	/* these are for safe removal of devices from global list while
-	 * NMI handlers may be traversing list
-	 */
-	struct rcu_head rcu;
 	struct completion complete;
 
 	/* sysfs top name under 'edac' directory
diff -puN drivers/edac/edac_device.c~edacrcu-use-synchronize_rcu-instead-of-call_rcurcu_barrier drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~edacrcu-use-synchronize_rcu-instead-of-call_rcurcu_barrier
+++ a/drivers/edac/edac_device.c
@@ -346,30 +346,18 @@ fail1:
 }
 
 /*
- * complete_edac_device_list_del
- *
- *	callback function when reference count is zero
- */
-static void complete_edac_device_list_del(struct rcu_head *head)
-{
-	struct edac_device_ctl_info *edac_dev;
-
-	edac_dev = container_of(head, struct edac_device_ctl_info, rcu);
-	INIT_LIST_HEAD(&edac_dev->link);
-}
-
-/*
  * del_edac_device_from_global_list
- *
- *	remove the RCU, setup for a callback call,
- *	then wait for the callback to occur
  */
 static void del_edac_device_from_global_list(struct edac_device_ctl_info
 						*edac_device)
 {
 	list_del_rcu(&edac_device->link);
-	call_rcu(&edac_device->rcu, complete_edac_device_list_del);
-	rcu_barrier();
+
+	/* these are for safe removal of devices from global list while
+	 * NMI handlers may be traversing list
+	 */
+	synchronize_rcu();
+	INIT_LIST_HEAD(&edac_device->link);
 }
 
 /*
diff -puN drivers/edac/edac_mc.c~edacrcu-use-synchronize_rcu-instead-of-call_rcurcu_barrier drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~edacrcu-use-synchronize_rcu-instead-of-call_rcurcu_barrier
+++ a/drivers/edac/edac_mc.c
@@ -447,20 +447,16 @@ fail1:
 	return 1;
 }
 
-static void complete_mc_list_del(struct rcu_head *head)
-{
-	struct mem_ctl_info *mci;
-
-	mci = container_of(head, struct mem_ctl_info, rcu);
-	INIT_LIST_HEAD(&mci->link);
-}
-
 static void del_mc_from_global_list(struct mem_ctl_info *mci)
 {
 	atomic_dec(&edac_handlers);
 	list_del_rcu(&mci->link);
-	call_rcu(&mci->rcu, complete_mc_list_del);
-	rcu_barrier();
+
+	/* these are for safe removal of devices from global list while
+	 * NMI handlers may be traversing list
+	 */
+	synchronize_rcu();
+	INIT_LIST_HEAD(&mci->link);
 }
 
 /**
diff -puN drivers/edac/edac_pci.c~edacrcu-use-synchronize_rcu-instead-of-call_rcurcu_barrier drivers/edac/edac_pci.c
--- a/drivers/edac/edac_pci.c~edacrcu-use-synchronize_rcu-instead-of-call_rcurcu_barrier
+++ a/drivers/edac/edac_pci.c
@@ -164,19 +164,6 @@ fail1:
 }
 
 /*
- * complete_edac_pci_list_del
- *
- *	RCU completion callback to indicate item is deleted
- */
-static void complete_edac_pci_list_del(struct rcu_head *head)
-{
-	struct edac_pci_ctl_info *pci;
-
-	pci = container_of(head, struct edac_pci_ctl_info, rcu);
-	INIT_LIST_HEAD(&pci->link);
-}
-
-/*
  * del_edac_pci_from_global_list
  *
  *	remove the PCI control struct from the global list
@@ -184,8 +171,12 @@ static void complete_edac_pci_list_del(s
 static void del_edac_pci_from_global_list(struct edac_pci_ctl_info *pci)
 {
 	list_del_rcu(&pci->link);
-	call_rcu(&pci->rcu, complete_edac_pci_list_del);
-	rcu_barrier();
+
+	/* these are for safe removal of devices from global list while
+	 * NMI handlers may be traversing list
+	 */
+	synchronize_rcu();
+	INIT_LIST_HEAD(&pci->link);
 }
 
 #if 0
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

linux-next.patch
edacrcu-use-synchronize_rcu-instead-of-call_rcurcu_barrier.patch


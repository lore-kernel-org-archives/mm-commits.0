From: akpm@linux-foundation.org
Subject: + edac-core-remove-completion-wait-for-complete-with-rcu_barrier.patch added to -mm tree
Date: Wed, 26 Aug 2009 14:25:32 -0700
Message-ID: <200908262125.n7QLPXNe028617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753469AbZHZV0H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Aug 2009 17:26:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hawk@comx.dk, dougthompson@xmission.com


The patch titled
     edac: core: remove completion-wait for complete with rcu_barrier
has been added to the -mm tree.  Its filename is
     edac-core-remove-completion-wait-for-complete-with-rcu_barrier.patch

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
Subject: edac: core: remove completion-wait for complete with rcu_barrier
From: Jesper Dangaard Brouer <hawk@comx.dk>

Module edac_core.ko uses call_rcu() callbacks in edac_device.c, edac_mc.c
and edac_pci.c.

They all use a wait_for_completion() scheme, but this scheme it not 100%
safe on multiple CPUs.  See the _rcu_barrier() implementation which
explains why extra precausion is needed.

The patch adds a comment about rcu_barrier() and as a precausion calls
rcu_barrier().  A maintainer needs to look at removing the
wait_for_completion code.

[dougthompson@xmission.com: remove the wait_for_completion code]
Signed-off-by Jesper Dangaard Brouer <hawk@comx.dk>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_device.c |    5 +----
 drivers/edac/edac_mc.c     |    4 +---
 drivers/edac/edac_pci.c    |    4 +---
 3 files changed, 3 insertions(+), 10 deletions(-)

diff -puN drivers/edac/edac_device.c~edac-core-remove-completion-wait-for-complete-with-rcu_barrier drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~edac-core-remove-completion-wait-for-complete-with-rcu_barrier
+++ a/drivers/edac/edac_device.c
@@ -356,7 +356,6 @@ static void complete_edac_device_list_de
 
 	edac_dev = container_of(head, struct edac_device_ctl_info, rcu);
 	INIT_LIST_HEAD(&edac_dev->link);
-	complete(&edac_dev->removal_complete);
 }
 
 /*
@@ -369,10 +368,8 @@ static void del_edac_device_from_global_
 						*edac_device)
 {
 	list_del_rcu(&edac_device->link);
-
-	init_completion(&edac_device->removal_complete);
 	call_rcu(&edac_device->rcu, complete_edac_device_list_del);
-	wait_for_completion(&edac_device->removal_complete);
+	rcu_barrier();
 }
 
 /*
diff -puN drivers/edac/edac_mc.c~edac-core-remove-completion-wait-for-complete-with-rcu_barrier drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~edac-core-remove-completion-wait-for-complete-with-rcu_barrier
+++ a/drivers/edac/edac_mc.c
@@ -418,16 +418,14 @@ static void complete_mc_list_del(struct 
 
 	mci = container_of(head, struct mem_ctl_info, rcu);
 	INIT_LIST_HEAD(&mci->link);
-	complete(&mci->complete);
 }
 
 static void del_mc_from_global_list(struct mem_ctl_info *mci)
 {
 	atomic_dec(&edac_handlers);
 	list_del_rcu(&mci->link);
-	init_completion(&mci->complete);
 	call_rcu(&mci->rcu, complete_mc_list_del);
-	wait_for_completion(&mci->complete);
+	rcu_barrier();
 }
 
 /**
diff -puN drivers/edac/edac_pci.c~edac-core-remove-completion-wait-for-complete-with-rcu_barrier drivers/edac/edac_pci.c
--- a/drivers/edac/edac_pci.c~edac-core-remove-completion-wait-for-complete-with-rcu_barrier
+++ a/drivers/edac/edac_pci.c
@@ -174,7 +174,6 @@ static void complete_edac_pci_list_del(s
 
 	pci = container_of(head, struct edac_pci_ctl_info, rcu);
 	INIT_LIST_HEAD(&pci->link);
-	complete(&pci->complete);
 }
 
 /*
@@ -185,9 +184,8 @@ static void complete_edac_pci_list_del(s
 static void del_edac_pci_from_global_list(struct edac_pci_ctl_info *pci)
 {
 	list_del_rcu(&pci->link);
-	init_completion(&pci->complete);
 	call_rcu(&pci->rcu, complete_edac_pci_list_del);
-	wait_for_completion(&pci->complete);
+	rcu_barrier();
 }
 
 #if 0
_

Patches currently in -mm which might be from hawk@comx.dk are

linux-next.patch
edac-core-remove-completion-wait-for-complete-with-rcu_barrier.patch


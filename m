From: akpm@linux-foundation.org
Subject: + prism54-convert-mgmt_sem-to-the-mutex-api.patch added to -mm tree
Date: Mon, 05 Nov 2007 18:25:54 -0800
Message-ID: <200711060225.lA62Psjc031706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33608 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753891AbXKFC06 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 21:26:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, linville@tuxdriver.com, mb@bu3sch.de


The patch titled
     Prism54: convert mgmt_sem to the mutex API
has been added to the -mm tree.  Its filename is
     prism54-convert-mgmt_sem-to-the-mutex-api.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Prism54: convert mgmt_sem to the mutex API
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/prism54/islpci_dev.c |    2 +-
 drivers/net/wireless/prism54/islpci_dev.h |    3 ++-
 drivers/net/wireless/prism54/islpci_mgt.c |    4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/net/wireless/prism54/islpci_dev.c~prism54-convert-mgmt_sem-to-the-mutex-api drivers/net/wireless/prism54/islpci_dev.c
--- a/drivers/net/wireless/prism54/islpci_dev.c~prism54-convert-mgmt_sem-to-the-mutex-api
+++ a/drivers/net/wireless/prism54/islpci_dev.c
@@ -861,7 +861,7 @@ islpci_setup(struct pci_dev *pdev)
 	init_waitqueue_head(&priv->reset_done);
 
 	/* init the queue read locks, process wait counter */
-	sema_init(&priv->mgmt_sem, 1);
+	mutex_init(&priv->mgmt_lock);
 	priv->mgmt_received = NULL;
 	init_waitqueue_head(&priv->mgmt_wqueue);
 	sema_init(&priv->stats_sem, 1);
diff -puN drivers/net/wireless/prism54/islpci_dev.h~prism54-convert-mgmt_sem-to-the-mutex-api drivers/net/wireless/prism54/islpci_dev.h
--- a/drivers/net/wireless/prism54/islpci_dev.h~prism54-convert-mgmt_sem-to-the-mutex-api
+++ a/drivers/net/wireless/prism54/islpci_dev.h
@@ -26,6 +26,7 @@
 #include <linux/wireless.h>
 #include <net/iw_handler.h>
 #include <linux/list.h>
+#include <linux/mutex.h>
 
 #include "isl_38xx.h"
 #include "isl_oid.h"
@@ -164,7 +165,7 @@ typedef struct {
 	wait_queue_head_t reset_done;
 
 	/* used by islpci_mgt_transaction */
-	struct semaphore mgmt_sem; /* serialize access to mailbox and wqueue */
+	struct mutex mgmt_lock; /* serialize access to mailbox and wqueue */
 	struct islpci_mgmtframe *mgmt_received;	  /* mbox for incoming frame */
 	wait_queue_head_t mgmt_wqueue;            /* waitqueue for mbox */
 
diff -puN drivers/net/wireless/prism54/islpci_mgt.c~prism54-convert-mgmt_sem-to-the-mutex-api drivers/net/wireless/prism54/islpci_mgt.c
--- a/drivers/net/wireless/prism54/islpci_mgt.c~prism54-convert-mgmt_sem-to-the-mutex-api
+++ a/drivers/net/wireless/prism54/islpci_mgt.c
@@ -460,7 +460,7 @@ islpci_mgt_transaction(struct net_device
 
 	*recvframe = NULL;
 
-	if (down_interruptible(&priv->mgmt_sem))
+	if (mutex_lock_interruptible(&priv->mgmt_lock))
 		return -ERESTARTSYS;
 
 	prepare_to_wait(&priv->mgmt_wqueue, &wait, TASK_UNINTERRUPTIBLE);
@@ -504,7 +504,7 @@ islpci_mgt_transaction(struct net_device
 	/* TODO: we should reset the device here */
  out:
 	finish_wait(&priv->mgmt_wqueue, &wait);
-	up(&priv->mgmt_sem);
+	mutex_unlock(&priv->mgmt_lock);
 	return err;
 }
 
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch
git-dvb.patch
git-hwmon.patch
megaraid-sas-convert-aen_mutex-to-the-mutex-api.patch
prism54-convert-mgmt_sem-to-the-mutex-api.patch
parallel-port-convert-port_mutex-to-the-mutex-api.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
mbcs-convert-algolock-to-mutex.patch
mbcs-convert-dmawritelock-to-mutex.patch
mbcs-convert-dmareadlock-to-mutex.patch

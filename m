From: akpm@linux-foundation.org
Subject: + convert-stats_sem-in-a-mutex.patch added to -mm tree
Date: Fri, 15 Feb 2008 13:24:30 -0800
Message-ID: <200802152124.m1FLOUoh024703@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42814 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760808AbYBOV03 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 16:26:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias@kaehlcke.net, flamingice@sourmilk.net, linville@tuxdriver.com


The patch titled
     prism54: convert stats_sem in a mutex
has been added to the -mm tree.  Its filename is
     convert-stats_sem-in-a-mutex.patch

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
Subject: prism54: convert stats_sem in a mutex
From: Matthias Kaehlcke <matthias@kaehlcke.net>

The semaphore stats_sem is used as mutex, convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Michael Wu <flamingice@sourmilk.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/prism54/isl_ioctl.c  |    8 ++++----
 drivers/net/wireless/prism54/islpci_dev.c |    2 +-
 drivers/net/wireless/prism54/islpci_dev.h |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/net/wireless/prism54/isl_ioctl.c~convert-stats_sem-in-a-mutex drivers/net/wireless/prism54/isl_ioctl.c
--- a/drivers/net/wireless/prism54/isl_ioctl.c~convert-stats_sem-in-a-mutex
+++ a/drivers/net/wireless/prism54/isl_ioctl.c
@@ -165,7 +165,7 @@ prism54_update_stats(struct work_struct 
 	struct obj_bss bss, *bss2;
 	union oid_res_t r;
 
-	down(&priv->stats_sem);
+	mutex_lock(&priv->stats_lock);
 
 /* Noise floor.
  * I'm not sure if the unit is dBm.
@@ -207,7 +207,7 @@ prism54_update_stats(struct work_struct 
 	mgt_get_request(priv, DOT11_OID_MPDUTXFAILED, 0, NULL, &r);
 	priv->local_iwstatistics.discard.retries = r.u;
 
-	up(&priv->stats_sem);
+	mutex_unlock(&priv->stats_lock);
 
 	return;
 }
@@ -218,12 +218,12 @@ prism54_get_wireless_stats(struct net_de
 	islpci_private *priv = netdev_priv(ndev);
 
 	/* If the stats are being updated return old data */
-	if (down_trylock(&priv->stats_sem) == 0) {
+	if (mutex_trylock(&priv->stats_lock) == 0) {
 		memcpy(&priv->iwstatistics, &priv->local_iwstatistics,
 		       sizeof (struct iw_statistics));
 		/* They won't be marked updated for the next time */
 		priv->local_iwstatistics.qual.updated = 0;
-		up(&priv->stats_sem);
+		mutex_unlock(&priv->stats_lock);
 	} else
 		priv->iwstatistics.qual.updated = 0;
 
diff -puN drivers/net/wireless/prism54/islpci_dev.c~convert-stats_sem-in-a-mutex drivers/net/wireless/prism54/islpci_dev.c
--- a/drivers/net/wireless/prism54/islpci_dev.c~convert-stats_sem-in-a-mutex
+++ a/drivers/net/wireless/prism54/islpci_dev.c
@@ -864,7 +864,7 @@ islpci_setup(struct pci_dev *pdev)
 	mutex_init(&priv->mgmt_lock);
 	priv->mgmt_received = NULL;
 	init_waitqueue_head(&priv->mgmt_wqueue);
-	sema_init(&priv->stats_sem, 1);
+	mutex_init(&priv->stats_lock);
 	spin_lock_init(&priv->slock);
 
 	/* init state machine with off#1 state */
diff -puN drivers/net/wireless/prism54/islpci_dev.h~convert-stats_sem-in-a-mutex drivers/net/wireless/prism54/islpci_dev.h
--- a/drivers/net/wireless/prism54/islpci_dev.h~convert-stats_sem-in-a-mutex
+++ a/drivers/net/wireless/prism54/islpci_dev.h
@@ -88,7 +88,7 @@ typedef struct {
 
 	/* Take care of the wireless stats */
 	struct work_struct stats_work;
-	struct semaphore stats_sem;
+	struct mutex stats_lock;
 	/* remember when we last updated the stats */
 	unsigned long stats_timestamp;
 	/* The first is accessed under semaphore locking.
_

Patches currently in -mm which might be from matthias@kaehlcke.net are

convert-acl-sem-in-a-mutex.patch
convert-stats_sem-in-a-mutex.patch
convert-wpa_sem-in-a-mutex.patch

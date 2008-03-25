From: akpm@linux-foundation.org
Subject: - convert-stats_sem-in-a-mutex.patch removed from -mm tree
Date: Mon, 24 Mar 2008 17:19:39 -0700
Message-ID: <200803250019.m2P0JdR2032702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753995AbYCYAVR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 20:21:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias@kaehlcke.net, flamingice@sourmilk.net, linville@tuxdriver.com, mcgrof@winlab.rutgers.edu, mm-commits@vger.kernel.org


The patch titled
     prism54: convert stats_sem in a mutex
has been removed from the -mm tree.  Its filename was
     convert-stats_sem-in-a-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-net.patch
alchemy-semi-au1000-pcmcia-driver-convert-pcmcia_sockets_lock-in-a-mutex.patch
git-scsi-misc.patch
fs-inodec-use-hlist_for_each_entry.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch


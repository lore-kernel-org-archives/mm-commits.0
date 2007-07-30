From: akpm@linux-foundation.org
Subject: + use-mutex-instead-of-semaphore-in-the-host-ap-driver.patch added to -mm tree
Date: Mon, 30 Jul 2007 16:46:31 -0700
Message-ID: <200707302346.l6UNkVtf004631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60994 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763705AbXG3XrZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 19:47:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, linville@tuxdriver.com, satyam@infradead.org


The patch titled
     Use mutex instead of semaphore in the Host AP driver
has been added to the -mm tree.  Its filename is
     use-mutex-instead-of-semaphore-in-the-host-ap-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use mutex instead of semaphore in the Host AP driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The Host AP driver uses a semaphore as mutex. Use the mutex API
instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Reviewed-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/hostap/hostap_hw.c   |   14 +++++++-------
 drivers/net/wireless/hostap/hostap_wlan.h |    3 ++-
 2 files changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/net/wireless/hostap/hostap_hw.c~use-mutex-instead-of-semaphore-in-the-host-ap-driver drivers/net/wireless/hostap/hostap_hw.c
--- a/drivers/net/wireless/hostap/hostap_hw.c~use-mutex-instead-of-semaphore-in-the-host-ap-driver
+++ a/drivers/net/wireless/hostap/hostap_hw.c
@@ -825,7 +825,7 @@ static int hfa384x_get_rid(struct net_de
 	    local->hw_downloading)
 		return -ENODEV;
 
-	res = down_interruptible(&local->rid_bap_sem);
+	res = mutex_lock_interruptible(&local->rid_bap_mtx);
 	if (res)
 		return res;
 
@@ -834,7 +834,7 @@ static int hfa384x_get_rid(struct net_de
 		printk(KERN_DEBUG "%s: hfa384x_get_rid: CMDCODE_ACCESS failed "
 		       "(res=%d, rid=%04x, len=%d)\n",
 		       dev->name, res, rid, len);
-		up(&local->rid_bap_sem);
+		mutex_unlock(&local->rid_bap_mtx);
 		return res;
 	}
 
@@ -861,7 +861,7 @@ static int hfa384x_get_rid(struct net_de
 		res = hfa384x_from_bap(dev, BAP0, buf, len);
 
 	spin_unlock_bh(&local->baplock);
-	up(&local->rid_bap_sem);
+	mutex_unlock(&local->rid_bap_mtx);
 
 	if (res) {
 		if (res != -ENODATA)
@@ -902,7 +902,7 @@ static int hfa384x_set_rid(struct net_de
 	/* RID len in words and +1 for rec.rid */
 	rec.len = cpu_to_le16(len / 2 + len % 2 + 1);
 
-	res = down_interruptible(&local->rid_bap_sem);
+	res = mutex_lock_interruptible(&local->rid_bap_mtx);
 	if (res)
 		return res;
 
@@ -917,12 +917,12 @@ static int hfa384x_set_rid(struct net_de
 	if (res) {
 		printk(KERN_DEBUG "%s: hfa384x_set_rid (rid=%04x, len=%d) - "
 		       "failed - res=%d\n", dev->name, rid, len, res);
-		up(&local->rid_bap_sem);
+		mutex_unlock(&local->rid_bap_mtx);
 		return res;
 	}
 
 	res = hfa384x_cmd(dev, HFA384X_CMDCODE_ACCESS_WRITE, rid, NULL, NULL);
-	up(&local->rid_bap_sem);
+	mutex_unlock(&local->rid_bap_mtx);
 
 	if (res) {
 		printk(KERN_DEBUG "%s: hfa384x_set_rid: CMDCODE_ACCESS_WRITE "
@@ -3171,7 +3171,7 @@ prism2_init_local_data(struct prism2_hel
 	spin_lock_init(&local->cmdlock);
 	spin_lock_init(&local->baplock);
 	spin_lock_init(&local->lock);
-	init_MUTEX(&local->rid_bap_sem);
+	mutex_init(&local->rid_bap_mtx);
 
 	if (card_idx < 0 || card_idx >= MAX_PARM_DEVICES)
 		card_idx = 0;
diff -puN drivers/net/wireless/hostap/hostap_wlan.h~use-mutex-instead-of-semaphore-in-the-host-ap-driver drivers/net/wireless/hostap/hostap_wlan.h
--- a/drivers/net/wireless/hostap/hostap_wlan.h~use-mutex-instead-of-semaphore-in-the-host-ap-driver
+++ a/drivers/net/wireless/hostap/hostap_wlan.h
@@ -3,6 +3,7 @@
 
 #include <linux/wireless.h>
 #include <linux/netdevice.h>
+#include <linux/mutex.h>
 #include <net/iw_handler.h>
 
 #include "hostap_config.h"
@@ -641,7 +642,7 @@ struct local_info {
 			      * when removing entries from the list.
 			      * TX and RX paths can use read lock. */
 	spinlock_t cmdlock, baplock, lock;
-	struct semaphore rid_bap_sem;
+	struct mutex rid_bap_mtx;
 	u16 infofid; /* MAC buffer id for info frame */
 	/* txfid, intransmitfid, next_txtid, and next_alloc are protected by
 	 * txfidlock */
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

kcopyd-use-mutex-instead-of-semaphore.patch
git-mtd.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch
fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
fs-locksc-use-list_for_each_entry-instead-of-list_for_each.patch
kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each.patch
kernel-userc-use-list_for_each_entry-instead-of-list_for_each.patch
use-mutex-instead-of-semaphore-in-the-host-ap-driver.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
use-mutex-instead-of-semaphore-in-the-scsi-tape-driver.patch
use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions.patch
use-mutex-instead-of-semaphore-in-the-dvb-frontend-tuning-interface.patch

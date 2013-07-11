From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 11 Jul 2013 13:16:10 -0700
Message-ID: <51df128a.H7Gq6MqK9z+iy5h/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab3GKUQL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Jul 2013 16:16:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 11 Jul 2013 13:16:10 -0700


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/networking/netlink_mmap.txt |    4 ----
 drivers/net/wireless/ath/ath9k/xmit.c     |   18 ------------------
 net/bluetooth/hci_core.c                  |    4 ----
 3 files changed, 26 deletions(-)

diff -puN Documentation/networking/netlink_mmap.txt~linux-next-git-rejects Documentation/networking/netlink_mmap.txt
--- a/Documentation/networking/netlink_mmap.txt~linux-next-git-rejects
+++ a/Documentation/networking/netlink_mmap.txt
@@ -113,11 +113,7 @@ Some parameters are constrained, specifi
 
 - nm_frame_nr must equal the actual number of frames as specified above.
 
-<<<<<<< HEAD
-When the kernel can't allocate physically continuous memory for a ring block,
-=======
 When the kernel can't allocate phsyically continuous memory for a ring block,
->>>>>>> linux-next/akpm-base
 it will fall back to use physically discontinuous memory. This might affect
 performance negatively, in order to avoid this the nm_frame_size parameter
 should be chosen to be as small as possible for the required frame size and
diff -puN drivers/net/wireless/ath/ath9k/xmit.c~linux-next-git-rejects drivers/net/wireless/ath/ath9k/xmit.c
--- a/drivers/net/wireless/ath/ath9k/xmit.c~linux-next-git-rejects
+++ a/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2251,25 +2251,7 @@ static void ath_tx_complete(struct ath_s
 	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 
 	__skb_queue_tail(&txq->complete_q, skb);
-<<<<<<< HEAD
-
-	q = skb_get_queue_mapping(skb);
-	if (txq == sc->tx.uapsdq)
-		txq = sc->tx.txq_map[q];
-
-	if (txq == sc->tx.txq_map[q]) {
-		if (WARN_ON(--txq->pending_frames < 0))
-			txq->pending_frames = 0;
-
-		if (txq->stopped &&
-		    txq->pending_frames < sc->tx.txq_max_pending[q]) {
-			ieee80211_wake_queue(sc->hw, q);
-			txq->stopped = false;
-		}
-	}
-=======
 	ath_txq_skb_done(sc, txq, skb);
->>>>>>> linux-next/akpm-base
 }
 
 static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
diff -puN net/bluetooth/hci_core.c~linux-next-git-rejects net/bluetooth/hci_core.c
--- a/net/bluetooth/hci_core.c~linux-next-git-rejects
+++ a/net/bluetooth/hci_core.c
@@ -605,11 +605,7 @@ static void hci_init3_req(struct hci_req
 	 * as supported send it. If not supported assume that the controller
 	 * does not have actual support for stored link keys which makes this
 	 * command redundant anyway.
-<<<<<<< HEAD
-         */
-=======
 	 */
->>>>>>> linux-next/akpm-base
 	if (hdev->commands[6] & 0x80) {
 		struct hci_cp_delete_stored_link_key cp;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
mm.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


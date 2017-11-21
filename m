From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 21 Nov 2017 12:04:15 -0800
Message-ID: <20171121200415.zK-SAcXRt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53724 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdKUUER (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2017 15:04:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN net/mac80211/agg-rx.c~linux-next-git-rejects net/mac80211/agg-rx.c
--- a/net/mac80211/agg-rx.c~linux-next-git-rejects
+++ a/net/mac80211/agg-rx.c
@@ -153,28 +153,11 @@ EXPORT_SYMBOL(ieee80211_stop_rx_ba_sessi
  */
 static void sta_rx_agg_session_timer_expired(struct timer_list *t)
 {
-<<<<<<< HEAD
-	struct tid_ampdu_rx *tid_rx_timer =
-		from_timer(tid_rx_timer, t, session_timer);
-	struct sta_info *sta = tid_rx_timer->sta;
-	u8 tid = tid_rx_timer->tid;
-	struct tid_ampdu_rx *tid_rx;
-	unsigned long timeout;
-
-	rcu_read_lock();
-	tid_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[tid]);
-	if (!tid_rx) {
-		rcu_read_unlock();
-		return;
-	}
-
-=======
 	struct tid_ampdu_rx *tid_rx = from_timer(tid_rx, t, session_timer);
 	struct sta_info *sta = tid_rx->sta;
 	u8 tid = tid_rx->tid;
 	unsigned long timeout;
 
->>>>>>> linux-next/akpm-base
 	timeout = tid_rx->last_rx + TU_TO_JIFFIES(tid_rx->timeout);
 	if (time_is_after_jiffies(timeout)) {
 		mod_timer(&tid_rx->session_timer, timeout);
diff -puN net/mac80211/agg-tx.c~linux-next-git-rejects net/mac80211/agg-tx.c
--- a/net/mac80211/agg-tx.c~linux-next-git-rejects
+++ a/net/mac80211/agg-tx.c
@@ -429,17 +429,9 @@ int ___ieee80211_stop_tx_ba_session(stru
  */
 static void sta_addba_resp_timer_expired(struct timer_list *t)
 {
-<<<<<<< HEAD
-	struct tid_ampdu_tx *tid_tx_timer =
-		from_timer(tid_tx_timer, t, addba_resp_timer);
-	struct sta_info *sta = tid_tx_timer->sta;
-	u8 tid = tid_tx_timer->tid;
-	struct tid_ampdu_tx *tid_tx;
-=======
 	struct tid_ampdu_tx *tid_tx = from_timer(tid_tx, t, addba_resp_timer);
 	struct sta_info *sta = tid_tx->sta;
 	u8 tid = tid_tx->tid;
->>>>>>> linux-next/akpm-base
 
 	/* check if the TID waits for addBA response */
 	if (test_bit(HT_AGG_STATE_RESPONSE_RECEIVED, &tid_tx->state)) {
@@ -530,26 +522,12 @@ void ieee80211_tx_ba_session_handle_star
  */
 static void sta_tx_agg_session_timer_expired(struct timer_list *t)
 {
-<<<<<<< HEAD
-	struct tid_ampdu_tx *tid_tx_timer =
-		from_timer(tid_tx_timer, t, session_timer);
-	struct sta_info *sta = tid_tx_timer->sta;
-	u8 tid = tid_tx_timer->tid;
-	struct tid_ampdu_tx *tid_tx;
-	unsigned long timeout;
-
-	rcu_read_lock();
-	tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
-	if (!tid_tx || test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
-		rcu_read_unlock();
-=======
 	struct tid_ampdu_tx *tid_tx = from_timer(tid_tx, t, session_timer);
 	struct sta_info *sta = tid_tx->sta;
 	u8 tid = tid_tx->tid;
 	unsigned long timeout;
 
 	if (test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
->>>>>>> linux-next/akpm-base
 		return;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch


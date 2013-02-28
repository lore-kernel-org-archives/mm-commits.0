From: akpm@linux-foundation.org
Subject: [merged] mac80211-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:15:55 -0800
Message-ID: <20130228201555.9928831C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:56591 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758441Ab3B1UP4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:15:56 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so245119ggi.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:15:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, johannes@sipsolutions.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mac80211: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     mac80211-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: mac80211: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/main.c |    2 --
 net/mac80211/tx.c   |   18 ++++--------------
 2 files changed, 4 insertions(+), 16 deletions(-)

diff -puN net/mac80211/main.c~mac80211-convert-to-idr_alloc net/mac80211/main.c
--- a/net/mac80211/main.c~mac80211-convert-to-idr_alloc
+++ a/net/mac80211/main.c
@@ -647,8 +647,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 
 	spin_lock_init(&local->ack_status_lock);
 	idr_init(&local->ack_status_frames);
-	/* preallocate at least one entry */
-	idr_pre_get(&local->ack_status_frames, GFP_KERNEL);
 
 	sta_info_init(local);
 
diff -puN net/mac80211/tx.c~mac80211-convert-to-idr_alloc net/mac80211/tx.c
--- a/net/mac80211/tx.c~mac80211-convert-to-idr_alloc
+++ a/net/mac80211/tx.c
@@ -2017,24 +2017,14 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 		skb = skb_clone(skb, GFP_ATOMIC);
 		if (skb) {
 			unsigned long flags;
-			int id, r;
+			int id;
 
 			spin_lock_irqsave(&local->ack_status_lock, flags);
-			r = idr_get_new_above(&local->ack_status_frames,
-					      orig_skb, 1, &id);
-			if (r == -EAGAIN) {
-				idr_pre_get(&local->ack_status_frames,
-					    GFP_ATOMIC);
-				r = idr_get_new_above(&local->ack_status_frames,
-						      orig_skb, 1, &id);
-			}
-			if (WARN_ON(!id) || id > 0xffff) {
-				idr_remove(&local->ack_status_frames, id);
-				r = -ERANGE;
-			}
+			id = idr_alloc(&local->ack_status_frames, orig_skb,
+				       1, 0x10000, GFP_ATOMIC);
 			spin_unlock_irqrestore(&local->ack_status_lock, flags);
 
-			if (!r) {
+			if (id >= 0) {
 				info_id = id;
 				info_flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
 			} else if (skb_shared(skb)) {
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch


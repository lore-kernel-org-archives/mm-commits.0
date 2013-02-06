From: akpm@linux-foundation.org
Subject: + mac80211-convert-to-idr_alloc.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:39:49 -0800
Message-ID: <20130206223950.3105031C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:38778 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789Ab3BFWjv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:39:51 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so210036vch.0
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:39:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, johannes@sipsolutions.net


The patch titled
     Subject: mac80211: convert to idr_alloc()
has been added to the -mm tree.  Its filename is
     mac80211-convert-to-idr_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: mac80211: convert to idr_alloc()

Convert to the much saner new idr interface.

Only compile tested.

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
@@ -1999,24 +1999,14 @@ netdev_tx_t ieee80211_subif_start_xmit(s
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

linux-next.patch
cfq-fix-lock-imbalance-with-failed-allocations.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch
memcg-clean-up-swap-accounting-initialization-code.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
idr-fix-a-subtle-bug-in-idr_get_next.patch
idr-make-idr_destroy-imply-idr_remove_all.patch
atm-nicstar-dont-use-idr_remove_all.patch
block-loop-dont-use-idr_remove_all.patch
firewire-dont-use-idr_remove_all.patch
drm-dont-use-idr_remove_all.patch
dm-dont-use-idr_remove_all.patch
remoteproc-dont-use-idr_remove_all.patch
rpmsg-dont-use-idr_remove_all.patch
dlm-use-idr_for_each_entry-in-recover_idr_clear-error-path.patch
dlm-dont-use-idr_remove_all.patch
nfs-idr_destroy-no-longer-needs-idr_remove_all.patch
inotify-dont-use-idr_remove_all.patch
cgroup-dont-use-idr_remove_all.patch
idr-deprecate-idr_remove_all.patch
idr-cosmetic-updates-to-struct-initializer-definitions.patch
idr-relocate-idr_for_each_entry-and-reorganize-id_get_new.patch
idr-remove-_idr_rc_to_errno-hack.patch
idr-refactor-idr_get_new_above.patch
idr-implement-idr_preload-and-idr_alloc.patch
block-fix-synchronization-and-limit-check-in-blk_alloc_devt.patch
block-convert-to-idr_alloc.patch
block-loop-convert-to-idr_alloc.patch
atm-nicstar-convert-to-idr_alloc.patch
drbd-convert-to-idr_alloc.patch
dca-convert-to-idr_alloc.patch
dmaengine-convert-to-idr_alloc.patch
firewire-add-minor-number-range-check-to-fw_device_init.patch
firewire-convert-to-idr_alloc.patch
gpio-convert-to-idr_alloc.patch
drm-convert-to-idr_alloc.patch
drm-exynos-convert-to-idr_alloc.patch
drm-i915-convert-to-idr_alloc.patch
drm-sis-convert-to-idr_alloc.patch
drm-via-convert-to-idr_alloc.patch
drm-vmwgfx-convert-to-idr_alloc.patch
i2c-convert-to-idr_alloc.patch
ib-core-convert-to-idr_alloc.patch
ib-amso1100-convert-to-idr_alloc.patch
ib-cxgb3-convert-to-idr_alloc.patch
ib-cxgb4-convert-to-idr_alloc.patch
ib-ehca-convert-to-idr_alloc.patch
ib-ipath-convert-to-idr_alloc.patch
ib-mlx4-convert-to-idr_alloc.patch
ib-ocrdma-convert-to-idr_alloc.patch
ib-qib-convert-to-idr_alloc.patch
dm-convert-to-idr_alloc.patch
memstick-convert-to-idr_alloc.patch
mfd-convert-to-idr_alloc.patch
misc-c2port-convert-to-idr_alloc.patch
misc-tifm_core-convert-to-idr_alloc.patch
mmc-convert-to-idr_alloc.patch
mtd-convert-to-idr_alloc.patch
macvtap-convert-to-idr_alloc.patch
ppp-convert-to-idr_alloc.patch
power-convert-to-idr_alloc.patch
pps-convert-to-idr_alloc.patch
remoteproc-convert-to-idr_alloc.patch
rpmsg-convert-to-idr_alloc.patch
scsi-bfa-convert-to-idr_alloc.patch
scsi-convert-to-idr_alloc.patch
target-iscsi-convert-to-idr_alloc.patch
scsi-lpfc-convert-to-idr_alloc.patch
thermal-convert-to-idr_alloc.patch
uio-convert-to-idr_alloc.patch
vfio-convert-to-idr_alloc.patch
dlm-convert-to-idr_alloc.patch
inotify-convert-to-idr_alloc.patch
ocfs2-convert-to-idr_alloc.patch
ipc-convert-to-idr_alloc.patch
cgroup-convert-to-idr_alloc.patch
events-convert-to-idr_alloc.patch
posix-timers-convert-to-idr_alloc.patch
net-9p-convert-to-idr_alloc.patch
mac80211-convert-to-idr_alloc.patch
sctp-convert-to-idr_alloc.patch
nfs4client-convert-to-idr_alloc.patch


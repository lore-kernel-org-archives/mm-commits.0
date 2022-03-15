Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7557C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 15 Mar 2022 22:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbiCOWbR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Mar 2022 18:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237247AbiCOWbQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2022 18:31:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7DF49F8B
        for <mm-commits@vger.kernel.org>; Tue, 15 Mar 2022 15:30:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B51F661365
        for <mm-commits@vger.kernel.org>; Tue, 15 Mar 2022 22:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10093C340E8;
        Tue, 15 Mar 2022 22:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647383401;
        bh=z+BAP/7PcdxYnWKGTHInKHfGKLvNCzRJ70CJkb6Q+90=;
        h=Date:To:From:Subject:From;
        b=JRDsMv/y0sIAQd68NNeyU99RbSqYBtbKgPVRHdl72Bo6BdW5qMIBp7mYQ8tOIIPaz
         7/sLNhXV24Nqz/XxUKVsDBR6xf9cKpsf6aFdFDTD0oPBzqu6RjSsVqeBlpwRJL8UPV
         j7tGh9r783uvUb1+KxVKKM5Sc6TFCUJacGxZ5Yeg=
Date:   Tue, 15 Mar 2022 15:30:00 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Message-Id: <20220315223001.10093C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>
Subject: a

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c |   16 --------------
 drivers/net/ethernet/intel/ice/ice.h            |    3 --
 drivers/net/ethernet/intel/ice/ice_main.c       |   14 ------------
 drivers/net/phy/meson-gxl.c                     |   10 --------
 drivers/staging/gdm724x/gdm_lte.c               |    4 ---
 net/bluetooth/hci_sync.c                        |    7 ------
 net/dsa/dsa2.c                                  |    3 --
 7 files changed, 1 insertion(+), 56 deletions(-)

--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -1845,22 +1845,6 @@ static void iavf_netdev_features_vlan_st
 }
 
 /**
- * iavf_netdev_features_vlan_strip_set - update vlan strip status
- * @netdev: ptr to netdev being adjusted
- * @enable: enable or disable vlan strip
- *
- * Helper function to change vlan strip status in netdev->features.
- */
-static void iavf_netdev_features_vlan_strip_set(struct net_device *netdev,
-						const bool enable)
-{
-	if (enable)
-		netdev->features |= NETIF_F_HW_VLAN_CTAG_RX;
-	else
-		netdev->features &= ~NETIF_F_HW_VLAN_CTAG_RX;
-}
-
-/**
  * iavf_virtchnl_completion
  * @adapter: adapter structure
  * @v_opcode: opcode sent by PF
--- a/drivers/net/ethernet/intel/ice/ice.h~linux-next-git-rejects
+++ a/drivers/net/ethernet/intel/ice/ice.h
@@ -488,10 +488,7 @@ enum ice_pf_flags {
 	ICE_FLAG_LINK_LENIENT_MODE_ENA,
 	ICE_FLAG_PLUG_AUX_DEV,
 	ICE_FLAG_MTU_CHANGED,
-<<<<<<< HEAD
-=======
 	ICE_FLAG_GNSS,			/* GNSS successfully initialized */
->>>>>>> linux-next/akpm-base
 	ICE_PF_FLAGS_NBITS		/* must be last */
 };
 
--- a/drivers/net/ethernet/intel/ice/ice_main.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2265,22 +2265,10 @@ static void ice_service_task(struct work
 		return;
 	}
 
-	if (test_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags)) {
+	if (test_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
 		/* Plug aux device per request */
 		ice_plug_aux_dev(pf);
 
-<<<<<<< HEAD
-		/* Mark plugging as done but check whether unplug was
-		 * requested during ice_plug_aux_dev() call
-		 * (e.g. from ice_clear_rdma_cap()) and if so then
-		 * plug aux device.
-		 */
-		if (!test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
-			ice_unplug_aux_dev(pf);
-	}
-
-=======
->>>>>>> linux-next/akpm-base
 	if (test_and_clear_bit(ICE_FLAG_MTU_CHANGED, pf->flags)) {
 		struct iidc_event *event;
 
--- a/drivers/net/phy/meson-gxl.c~linux-next-git-rejects
+++ a/drivers/net/phy/meson-gxl.c
@@ -243,17 +243,7 @@ static irqreturn_t meson_gxl_handle_inte
 	    irq_status == INTSRC_ENERGY_DETECT)
 		return IRQ_HANDLED;
 
-<<<<<<< HEAD
-	/* Give PHY some time before MAC starts sending data. This works
-	 * around an issue where network doesn't come up properly.
-	 */
-	if (!(irq_status & INTSRC_LINK_DOWN))
-		phy_queue_state_machine(phydev, msecs_to_jiffies(100));
-	else
-		phy_trigger_machine(phydev);
-=======
 	phy_trigger_machine(phydev);
->>>>>>> linux-next/akpm-base
 
 	return IRQ_HANDLED;
 }
--- a/drivers/staging/gdm724x/gdm_lte.c~linux-next-git-rejects
+++ a/drivers/staging/gdm724x/gdm_lte.c
@@ -79,11 +79,7 @@ static int gdm_lte_rx(struct sk_buff *sk
 	int ret, len;
 
 	len = skb->len + ETH_HLEN;
-<<<<<<< HEAD
-	ret = netif_rx_ni(skb);
-=======
 	ret = netif_rx(skb);
->>>>>>> linux-next/akpm-base
 	if (ret == NET_RX_DROP) {
 		nic->stats.rx_dropped++;
 	} else {
--- a/net/bluetooth/hci_sync.c~linux-next-git-rejects
+++ a/net/bluetooth/hci_sync.c
@@ -290,17 +290,10 @@ static void hci_cmd_sync_work(struct wor
 		if (entry)
 			list_del(&entry->list);
 		mutex_unlock(&hdev->cmd_sync_work_lock);
-<<<<<<< HEAD
 
 		if (!entry)
 			break;
 
-=======
-
-		if (!entry)
-			break;
-
->>>>>>> linux-next/akpm-base
 		bt_dev_dbg(hdev, "entry %p", entry);
 
 		if (entry->func) {
--- a/net/dsa/dsa2.c~linux-next-git-rejects
+++ a/net/dsa/dsa2.c
@@ -1062,14 +1062,11 @@ static int dsa_tree_setup_master(struct
 			err = dsa_master_setup(master, dp);
 			if (err)
 				break;
-<<<<<<< HEAD
-=======
 
 			/* Replay master state event */
 			dsa_tree_master_admin_state_change(dst, master, admin_up);
 			dsa_tree_master_oper_state_change(dst, master,
 							  netif_oper_up(master));
->>>>>>> linux-next/akpm-base
 		}
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch
remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-list_lru-replace-linear-array-with-xarray-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-memory-failurec-fix-race-with-changing-page-compound-again-fix.patch
mm-export-pageheadhuge-fix.patch
userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-typesh-remove-unnecessary-__bitwise__-fix.patch
taskstats-remove-unneeded-dead-assignment-fix.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mm-slightly-clarify-ksm-logic-in-do_swap_page-fix.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


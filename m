Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0DABC4338F
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC3A66103B
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242015AbhHEXEL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Aug 2021 19:04:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242210AbhHEXEL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Aug 2021 19:04:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29A366105A;
        Thu,  5 Aug 2021 23:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628204636;
        bh=X7xHk9g+e6slg0y/0U8obiOo/iiQ5K1xQSnBiONBS8Q=;
        h=Date:From:To:Subject:From;
        b=apMkPitqvCeicX1qD97+Gg5DZ55KzaQsNWI/YoBHShXCmcRyE+rafS1F1tc8Iy1l/
         ujk1SDRpiIsNJjeEHBZVsZ41kzJaGxHqlMNHXEClR/ReLcZp6jzSIX4+JMACfwGLtJ
         /2OOyMfNylILpeyvlZFdWlFCzgYdOLQEu9GswQTw=
Date:   Thu, 05 Aug 2021 16:03:55 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210805230355.MRFYkCumD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bus/mhi/core/main.c                      |    5 -----
 drivers/net/dsa/sja1105/sja1105_dynamic_config.c |    6 ------
 drivers/net/dsa/sja1105/sja1105_main.c           |    8 --------
 include/net/bluetooth/hci_core.h                 |    4 ----
 net/bluetooth/hci_core.c                         |   13 -------------
 net/bluetooth/hci_sysfs.c                        |    7 -------
 net/qrtr/mhi.c                                   |    4 ----
 7 files changed, 47 deletions(-)

--- a/drivers/bus/mhi/core/main.c~linux-next-git-rejects
+++ a/drivers/bus/mhi/core/main.c
@@ -1457,11 +1457,6 @@ int mhi_prepare_channel(struct mhi_contr
 
 	if (mhi_chan->dir == DMA_FROM_DEVICE)
 		mhi_chan->pre_alloc = !!(flags & MHI_CH_INBOUND_ALLOC_BUFS);
-<<<<<<< HEAD
-	
-=======
-
->>>>>>> linux-next/akpm-base
 	/* Pre-allocate buffer for xfer ring */
 	if (mhi_chan->pre_alloc) {
 		int nr_el = get_nr_avail_ring_elements(mhi_cntrl,
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c~linux-next-git-rejects
+++ a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -330,15 +330,9 @@ sja1110_l2_lookup_cmd_packing(void *buf,
 			      enum packing_op op)
 {
 	int entry_size = SJA1110_SIZE_L2_LOOKUP_ENTRY;
-<<<<<<< HEAD
 
 	sja1105pqrs_common_l2_lookup_cmd_packing(buf, cmd, op, entry_size);
 
-=======
-
-	sja1105pqrs_common_l2_lookup_cmd_packing(buf, cmd, op, entry_size);
-
->>>>>>> linux-next/akpm-base
 	sja1105_packing(buf, &cmd->index, 10, 1, entry_size, op);
 }
 
--- a/drivers/net/dsa/sja1105/sja1105_main.c~linux-next-git-rejects
+++ a/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1500,9 +1500,6 @@ int sja1105pqrs_fdb_add(struct dsa_switc
 	l2_lookup.macaddr = ether_addr_to_u64(addr);
 	l2_lookup.vlanid = vid;
 	l2_lookup.mask_macaddr = GENMASK_ULL(ETH_ALEN * 8 - 1, 0);
-<<<<<<< HEAD
-	l2_lookup.mask_vlanid = VLAN_VID_MASK;
-=======
 	if (priv->vlan_aware) {
 		l2_lookup.mask_vlanid = VLAN_VID_MASK;
 		l2_lookup.mask_iotag = BIT(0);
@@ -1510,7 +1507,6 @@ int sja1105pqrs_fdb_add(struct dsa_switc
 		l2_lookup.mask_vlanid = 0;
 		l2_lookup.mask_iotag = 0;
 	}
->>>>>>> linux-next/akpm-base
 	l2_lookup.destports = BIT(port);
 
 	tmp = l2_lookup;
@@ -1601,9 +1597,6 @@ int sja1105pqrs_fdb_del(struct dsa_switc
 	l2_lookup.macaddr = ether_addr_to_u64(addr);
 	l2_lookup.vlanid = vid;
 	l2_lookup.mask_macaddr = GENMASK_ULL(ETH_ALEN * 8 - 1, 0);
-<<<<<<< HEAD
-	l2_lookup.mask_vlanid = VLAN_VID_MASK;
-=======
 	if (priv->vlan_aware) {
 		l2_lookup.mask_vlanid = VLAN_VID_MASK;
 		l2_lookup.mask_iotag = BIT(0);
@@ -1611,7 +1604,6 @@ int sja1105pqrs_fdb_del(struct dsa_switc
 		l2_lookup.mask_vlanid = 0;
 		l2_lookup.mask_iotag = 0;
 	}
->>>>>>> linux-next/akpm-base
 	l2_lookup.destports = BIT(port);
 
 	rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
--- a/include/net/bluetooth/hci_core.h~linux-next-git-rejects
+++ a/include/net/bluetooth/hci_core.h
@@ -1231,11 +1231,7 @@ struct hci_dev *hci_alloc_dev(void);
 void hci_free_dev(struct hci_dev *hdev);
 int hci_register_dev(struct hci_dev *hdev);
 void hci_unregister_dev(struct hci_dev *hdev);
-<<<<<<< HEAD
-void hci_cleanup_dev(struct hci_dev *hdev);
-=======
 void hci_release_dev(struct hci_dev *hdev);
->>>>>>> linux-next/akpm-base
 int hci_suspend_dev(struct hci_dev *hdev);
 int hci_resume_dev(struct hci_dev *hdev);
 int hci_reset_dev(struct hci_dev *hdev);
--- a/net/bluetooth/hci_core.c~linux-next-git-rejects
+++ a/net/bluetooth/hci_core.c
@@ -4034,21 +4034,12 @@ void hci_unregister_dev(struct hci_dev *
 	}
 
 	device_del(&hdev->dev);
-<<<<<<< HEAD
-	/* Actual cleanup is deferred until hci_cleanup_dev(). */
-=======
->>>>>>> linux-next/akpm-base
 	hci_dev_put(hdev);
 }
 EXPORT_SYMBOL(hci_unregister_dev);
 
-<<<<<<< HEAD
-/* Cleanup HCI device */
-void hci_cleanup_dev(struct hci_dev *hdev)
-=======
 /* Release HCI device */
 void hci_release_dev(struct hci_dev *hdev)
->>>>>>> linux-next/akpm-base
 {
 	debugfs_remove_recursive(hdev->debugfs);
 	kfree_const(hdev->hw_info);
@@ -4075,13 +4066,9 @@ void hci_release_dev(struct hci_dev *hde
 	hci_dev_unlock(hdev);
 
 	ida_simple_remove(&hci_index_ida, hdev->id);
-<<<<<<< HEAD
-}
-=======
 	kfree(hdev);
 }
 EXPORT_SYMBOL(hci_release_dev);
->>>>>>> linux-next/akpm-base
 
 /* Suspend HCI device */
 int hci_suspend_dev(struct hci_dev *hdev)
--- a/net/bluetooth/hci_sysfs.c~linux-next-git-rejects
+++ a/net/bluetooth/hci_sysfs.c
@@ -83,14 +83,7 @@ void hci_conn_del_sysfs(struct hci_conn
 static void bt_host_release(struct device *dev)
 {
 	struct hci_dev *hdev = to_hci_dev(dev);
-<<<<<<< HEAD
-
-	if (hci_dev_test_flag(hdev, HCI_UNREGISTER))
-		hci_cleanup_dev(hdev);
-	kfree(hdev);
-=======
 	hci_release_dev(hdev);
->>>>>>> linux-next/akpm-base
 	module_put(THIS_MODULE);
 }
 
--- a/net/qrtr/mhi.c~linux-next-git-rejects
+++ a/net/qrtr/mhi.c
@@ -84,11 +84,7 @@ static int qcom_mhi_qrtr_probe(struct mh
 	int rc;
 
 	/* start channels */
-<<<<<<< HEAD
-	rc = mhi_prepare_for_transfer(mhi_dev, 0);
-=======
 	rc = mhi_prepare_for_transfer(mhi_dev, MHI_CH_INBOUND_ALLOC_BUFS);
->>>>>>> linux-next/akpm-base
 	if (rc)
 		return rc;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-compaction-optimize-proactive-compaction-deferrals-fix.patch
mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch


Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB2D9C54F4D
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 18:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC7EC206B7
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 18:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599242730;
	bh=yumMNElZvLQ5w7B3rg7wiliAmq4jbYKcQqhRYlzY4Is=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Xc04pug/+gTorb6j47/nSaf/KN9jvt2/CECx2OeKXxdTqjAbki69UZhiUIe1VbdZY
	 cps16gRcmOmhc1o0grzidIdpePl+P74BhM1tWg37VGLEv1R62fT5CVLxN1579DluuT
	 BuOvzPSJHsPzhVoTcSFeIy+zg/Jixdm3r/hWGiiQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgIDSF3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 14:05:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725984AbgIDSF2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 14:05:28 -0400
Received: from localhost.localdomain (unknown [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D55021775;
        Fri,  4 Sep 2020 17:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599241543;
        bh=yumMNElZvLQ5w7B3rg7wiliAmq4jbYKcQqhRYlzY4Is=;
        h=Date:From:To:Subject:From;
        b=s2x5zy9q/XyiMkDabBtVe29SzRe2fXfBfhq0fKfNFATx09k4Q1P7UlXJevVazTwsq
         hFCUgHKWM8ePGuCq0HOU6okFllYWenYSPc8kru9El34OXP7BQ30ubxsPSZVlouYkNg
         Prfwr5VZ7DCVekFvE5tV+0Nv6gyzrMEALMC3c6Vg=
Date:   Fri, 04 Sep 2020 10:45:40 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20200904174540.2gGYRhSMD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


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

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/ibm/ibmvnic.c |   10 ----------
 net/ipv4/raw.c                     |    5 -----
 2 files changed, 15 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmvnic.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/ibm/ibmvnic.c
@@ -473,12 +473,6 @@ static int reset_rx_pools(struct ibmvnic
 
 	if (!adapter->rx_pool)
 		return -1;
-<<<<<<< HEAD
-
-	size_array = (u64 *)((u8 *)(adapter->login_rsp_buf) +
-		be32_to_cpu(adapter->login_rsp_buf->off_rxadd_buff_size));
-=======
->>>>>>> linux-next/akpm-base
 
 	buff_size = adapter->cur_rx_buf_sz;
 	rx_scrqs = adapter->num_active_rx_pools;
@@ -649,11 +643,7 @@ static int reset_tx_pools(struct ibmvnic
 	if (!adapter->tx_pool)
 		return -1;
 
-<<<<<<< HEAD
-	tx_scrqs = be32_to_cpu(adapter->login_rsp_buf->num_txsubm_subcrqs);
-=======
 	tx_scrqs = adapter->num_active_tx_pools;
->>>>>>> linux-next/akpm-base
 	for (i = 0; i < tx_scrqs; i++) {
 		rc = reset_one_tx_pool(adapter, &adapter->tso_pool[i]);
 		if (rc)
--- a/net/ipv4/raw.c~linux-next-git-rejects
+++ a/net/ipv4/raw.c
@@ -611,13 +611,8 @@ static int raw_sendmsg(struct sock *sk,
 	} else if (!ipc.oif) {
 		ipc.oif = inet->uc_index;
 	} else if (ipv4_is_lbcast(daddr) && inet->uc_index) {
-<<<<<<< HEAD
-		/* oif is set, packet is to local broadcast
-		 * and uc_index is set. oif is most likely set
-=======
 		/* oif is set, packet is to local broadcast and
 		 * uc_index is set. oif is most likely set
->>>>>>> linux-next/akpm-base
 		 * by sk_bound_dev_if. If uc_index != oif check if the
 		 * oif is an L3 master and uc_index is an L3 slave.
 		 * If so, we want to allow the send using the uc_index.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix.patch
mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
device-dax-make-align-a-per-device-property-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
mmhwpoison-drop-unneeded-pcplist-draining-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
arch-x86-makefile-use-config_shell.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch


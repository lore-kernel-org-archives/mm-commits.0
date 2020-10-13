Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5F8C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 00:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 218CF20BED
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 00:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602547600;
	bh=GQaeExkMBaDIG2n0JuUmUn+tCKeS45yyoU6F9eKimpg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ZUxCz0cVNbN4NuU0WTVpzlc2CyCdII/KRlHBA54Wu7U/JsK7/r03eWUDybB6wiujo
	 gYv4AhQUYuRPLafkJjlerYS9eFkKVMZXtTivtYgjMM4KuuNG3mzo0t06LdanLdALDa
	 RaqFoBpK7dna+2GWlkKRYz01xPZLYcIXLEtXAdqM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgJMAGj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Oct 2020 20:06:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbgJMAGj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 12 Oct 2020 20:06:39 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE23B20878;
        Tue, 13 Oct 2020 00:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602547599;
        bh=GQaeExkMBaDIG2n0JuUmUn+tCKeS45yyoU6F9eKimpg=;
        h=Date:From:To:Subject:From;
        b=mFHMNTfxe1KXxeq50nsMq7F3r8ISEYYGgnRoQ9n7n8ld4VadWrn8ql/g8i1XsC1y/
         szSFj+XPGtRVyoRcXjLUbt7RAW8RDfM2BK9rw5Rqe+wqFcLnS2xnWebHE6x8tdS1BM
         1GoslDzHJfAWIcLLOLE64qtQsgnVs5Hv2v+LHNuc=
Date:   Mon, 12 Oct 2020 17:06:38 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20201013000638.wDohPQwwu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
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

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/kernel/vmlinux.lds.S |    3 ---
 drivers/net/usb/rtl8150.c       |    6 ------
 net/rxrpc/conn_event.c          |    4 ----
 3 files changed, 13 deletions(-)

--- a/arch/riscv/kernel/vmlinux.lds.S~linux-next-git-rejects
+++ a/arch/riscv/kernel/vmlinux.lds.S
@@ -70,14 +70,11 @@ SECTIONS
 		_etext = .;
 	}
 
-<<<<<<< HEAD
-=======
 #ifdef CONFIG_EFI
 	. = ALIGN(PECOFF_SECTION_ALIGNMENT);
 	__pecoff_text_end = .;
 #endif
 
->>>>>>> linux-next/akpm-base
 	INIT_DATA_SECTION(16)
 
 	/* Start of data section */
--- a/drivers/net/usb/rtl8150.c~linux-next-git-rejects
+++ a/drivers/net/usb/rtl8150.c
@@ -258,15 +258,9 @@ static void set_ethernet_addr(rtl8150_t
 {
 	u8 node_id[ETH_ALEN];
 	int ret;
-<<<<<<< HEAD
 
 	ret = get_registers(dev, IDR, sizeof(node_id), node_id);
 
-=======
-
-	ret = get_registers(dev, IDR, sizeof(node_id), node_id);
-
->>>>>>> linux-next/akpm-base
 	if (ret == sizeof(node_id)) {
 		ether_addr_copy(dev->netdev->dev_addr, node_id);
 	} else {
--- a/net/rxrpc/conn_event.c~linux-next-git-rejects
+++ a/net/rxrpc/conn_event.c
@@ -341,11 +341,7 @@ static int rxrpc_process_event(struct rx
 		if (ret < 0)
 			return ret;
 
-<<<<<<< HEAD
-		spin_lock(&conn->channel_lock);
-=======
 		spin_lock(&conn->bundle->channel_lock);
->>>>>>> linux-next/akpm-base
 		spin_lock_bh(&conn->state_lock);
 
 		if (conn->state == RXRPC_CONN_SERVICE_CHALLENGING) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch
mm-mempool-add-else-to-split-mutually-exclusive-case-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
checkpatch-emit-a-warning-on-embedded-filenames-fix.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
fs-fuse-virtio_fsc-fix-for-mm-memremap_pages-convert-to-struct-range.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


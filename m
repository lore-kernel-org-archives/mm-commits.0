Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEFB0C3DA6F
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240484AbjHXXIl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244047AbjHXXIa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:08:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8081BE5
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:08:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04ED1639F6
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D62DC433C8;
        Thu, 24 Aug 2023 23:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692918501;
        bh=9pH2ryowgWbR7cHdykkZEf4QcFgxSD/M/Lc34P8xJKw=;
        h=Date:To:From:Subject:From;
        b=qi3IQhmF421HoaW1XTWY7ww7fQIqRIjx8i0bRpFHVNfgDCQtteuXI1fhXwL5tnQQ9
         A3b6r1dzVxY3tzUlvxa15g128GnFGM35BQRaE2VYQjjL/q3gWy8SiEttReRSPZTmfG
         BovvcA0CXH+E5X9szakTulCNGFokw+8o7vCVG0tU=
Date:   Thu, 24 Aug 2023 16:08:20 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, rppt@kernel.org,
        linux@armlinux.org.uk, m.szyprowski@samsung.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] arm-implement-the-new-page-table-range-api-fix.patch removed from -mm tree
Message-Id: <20230824230821.5D62DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm: dma-mapping: fix potential endless loop in __dma_page_dev_to_cpu()
has been removed from the -mm tree.  Its filename was
     arm-implement-the-new-page-table-range-api-fix.patch

This patch was dropped because it was folded into arm-implement-the-new-page-table-range-api.patch

------------------------------------------------------
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: arm: dma-mapping: fix potential endless loop in __dma_page_dev_to_cpu()
Date: Wed, 9 Aug 2023 19:27:37 +0200

The D-cache cleaning loop should not call folio_next() beyond the
requested region and rely on its parameters.  Simply stop looping if left
counter reaches zero.

This fixes the following endless loop observed by RCU stall on the ARM
32bit Exynos5422-based Odroid-XU3lite board:

--->8---
rcu: INFO: rcu_sched self-detected stall on CPU
rcu:     0-....: (27320 ticks this GP) idle=e414/1/0x40000002 softirq=36/36 fqs=13044
rcu:     (t=27385 jiffies g=-1067 q=34 ncpus=8)
CPU: 0 PID: 93 Comm: kworker/0:1H Not tainted 6.5.0-rc5-next-20230807 #6981
Hardware name: Samsung Exynos (Flattened Device Tree)
Workqueue: mmc_complete mmc_blk_mq_complete_work
PC is at _set_bit+0x28/0x44
LR is at __dma_page_dev_to_cpu+0xdc/0x170
..
 _set_bit from __dma_page_dev_to_cpu+0xdc/0x170
 __dma_page_dev_to_cpu from dma_direct_unmap_sg+0x100/0x130
 dma_direct_unmap_sg from dw_mci_post_req+0x68/0x6c
 dw_mci_post_req from mmc_blk_mq_post_req+0x34/0x100
 mmc_blk_mq_post_req from mmc_blk_mq_complete_work+0x50/0x60
 mmc_blk_mq_complete_work from process_one_work+0x20c/0x4d8
 process_one_work from worker_thread+0x58/0x54c
 worker_thread from kthread+0xe0/0xfc
 kthread from ret_from_fork+0x14/0x2c
--->8---

While touching this code, move the set_bit() operation, which deals with
atomics, a bit up in the call chain. The new order helps a bit compiler
to produce code computing folio_size() only once.

Link: https://lkml.kernel.org/r/20230809172737.3574190-1-m.szyprowski@samsung.com
Fixes: cc24e9c0895c ("arm: implement the new page table range API")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/dma-mapping.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm/mm/dma-mapping.c~arm-implement-the-new-page-table-range-api-fix
+++ a/arch/arm/mm/dma-mapping.c
@@ -719,8 +719,10 @@ static void __dma_page_dev_to_cpu(struct
 		}
 
 		while (left >= (ssize_t)folio_size(folio)) {
-			set_bit(PG_dcache_clean, &folio->flags);
 			left -= folio_size(folio);
+			set_bit(PG_dcache_clean, &folio->flags);
+			if (!left)
+				break;
 			folio = folio_next(folio);
 		}
 	}
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

arm-implement-the-new-page-table-range-api.patch


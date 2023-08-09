Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C2DC001B0
	for <mm-commits@archiver.kernel.org>; Wed,  9 Aug 2023 18:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjHISzY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Aug 2023 14:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjHISzW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Aug 2023 14:55:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB20E64
        for <mm-commits@vger.kernel.org>; Wed,  9 Aug 2023 11:55:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FEA56426B
        for <mm-commits@vger.kernel.org>; Wed,  9 Aug 2023 18:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C392C433C8;
        Wed,  9 Aug 2023 18:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691607320;
        bh=3IgR/Q/GIiV4EU3g+qBa5fjhrM/oWG5B0PlunQxHEGI=;
        h=Date:To:From:Subject:From;
        b=Hz344zJpe8xaMULX4LVXXmk4Oz14arWzdpXQdowBNSJUIh/EHaeVNVoV9mgkh63tB
         d+vUc4OHiqS0EiXKHBglGKYnr6amTBt8MAZ6JVV/1Iz3RWgMYMUYN7cJ74t8SOHzg/
         fauQH3A9kmS9eroxhHE73LMNKFWJ+xL6bYHc5BLo=
Date:   Wed, 09 Aug 2023 11:55:19 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, rppt@kernel.org,
        linux@armlinux.org.uk, m.szyprowski@samsung.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm-implement-the-new-page-table-range-api-fix.patch added to mm-unstable branch
Message-Id: <20230809185520.8C392C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm: dma-mapping: fix potential endless loop in __dma_page_dev_to_cpu()
has been added to the -mm mm-unstable branch.  Its filename is
     arm-implement-the-new-page-table-range-api-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm-implement-the-new-page-table-range-api-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

arm-implement-the-new-page-table-range-api-fix.patch


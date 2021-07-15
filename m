Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 441FBC636C9
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 22:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24578613D8
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 22:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhGOWhK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 18:37:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232021AbhGOWhI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 18:37:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED8E760E0B;
        Thu, 15 Jul 2021 22:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626388454;
        bh=0veftMkZggUDL8i7c4nQw2SgIT57+Uoq3tgmi0huMF0=;
        h=Date:From:To:Subject:From;
        b=WZdiMB9LrG5otvBNDZT2Hny2IC0knpAU0d9lhMAiBNQSQ3tI8dK+HoTvKn/ucPddI
         Ri6d2vzLaOop5GB6COVfJ3dI968ppnRFvkGqn/wrWkYqfK14pNJHW4EvvgtYPF5AGS
         8bKUAm0I+D6YgHtOltnmvwi9zLvBmQupeuF7vZuQ=
Date:   Thu, 15 Jul 2021 15:34:13 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, dalias@libc.org, deanbo422@gmail.com,
        deller@gmx.de, geoff@infradead.org, green.hu@gmail.com,
        guoren@kernel.org, hch@lst.de,
        James.Bottomley@HansenPartnership.com, linux@armlinux.org.uk,
        mm-commits@vger.kernel.org, nickhu@andestech.com,
        paul@crapouillou.net, torvalds@linux-foundation.org,
        tsbogend@alpha.franken.de, ulf.hansson@linaro.org,
        ysato@users.osdn.me
Subject:  +
 ps3disk-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch added
 to -mm tree
Message-ID: <20210715223413.-WhITXNa2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ps3disk: replace flush_kernel_dcache_page with flush_dcache_page
has been added to the -mm tree.  Its filename is
     ps3disk-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ps3disk-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ps3disk-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: ps3disk: replace flush_kernel_dcache_page with flush_dcache_page

Pages passed to block drivers can be mapped page cache pages, so we must
use flush_dcache_page here instead of the more limited
flush_kernel_dcache_page that is intended for highmem pages only.

Link: https://lkml.kernel.org/r/20210712060928.4161649-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Paul Cercueil <paul@crapouillou.net>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/ps3disk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/ps3disk.c~ps3disk-replace-flush_kernel_dcache_page-with-flush_dcache_page
+++ a/drivers/block/ps3disk.c
@@ -100,7 +100,7 @@ static void ps3disk_scatter_gather(struc
 		else
 			memcpy(buf, dev->bounce_buf+offset, size);
 		offset += size;
-		flush_kernel_dcache_page(bvec.bv_page);
+		flush_dcache_page(bvec.bv_page);
 		bvec_kunmap_irq(buf, &flags);
 		i++;
 	}
_

Patches currently in -mm which might be from hch@lst.de are

mm-fix-the-try_to_unmap-prototype-for-config_mmu.patch
mm-call-flush_dcache_page-in-memcpy_to_page-and-memzero_page.patch
mm-use-kmap_local_page-in-memzero_page.patch
mmc-jz4740-remove-the-flush_kernel_dcache_page-call-in-jz4740_mmc_read_data.patch
mmc-mmc_spi-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
ps3disk-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
scatterlist-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
aacraid-remove-an-unused-include.patch
mm-remove-flush_kernel_dcache_page.patch


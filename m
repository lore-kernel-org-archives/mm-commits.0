Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C7AC433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4270E610A1
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347865AbhIBV5i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:57:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347902AbhIBV50 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:57:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDDF5603E9;
        Thu,  2 Sep 2021 21:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619787;
        bh=71JLXr1/MwNuL+BGYFCmVcS0u+kTqhsa6mapkMlasbs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WlyjoCrFbNyL7AU5Egj/m6WB++Zk/xzJmDOnsiSIcUMgH0sCfpQ0onX0uAobsS6Tg
         CniMBJUEff0Ck/SXw1wuqKPs6q7PTTko1PSNwasPBCP0Dg/DpAPi23WTIqp9rfD7d2
         /u7pHAHr5Od9t/v7/w4+Q0TbXFsX88oTXipHJ/5Y=
Date:   Thu, 02 Sep 2021 14:56:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexs@kernel.org, dalias@libc.org,
        deanbo422@gmail.com, deller@gmx.de, geoff@infradead.org,
        green.hu@gmail.com, guoren@kernel.org, hch@lst.de,
        James.Bottomley@HansenPartnership.com, linux-mm@kvack.org,
        linux@armlinux.org.uk, mm-commits@vger.kernel.org,
        nickhu@andestech.com, paul@crapouillou.net,
        torvalds@linux-foundation.org, tsbogend@alpha.franken.de,
        ulf.hansson@linaro.org, ysato@users.osdn.me
Subject:  [patch 121/212] mmc: JZ4740: remove the
 flush_kernel_dcache_page call in jz4740_mmc_read_data
Message-ID: <20210902215626.XuZ8S-pvO%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: mmc: JZ4740: remove the flush_kernel_dcache_page call in jz4740_mmc_read_data

Patch series "_kernel_dcache_page fixes and removal".

While looking to convert the block layer away from kmap_atomic towards
kmap_local_page and prefeably the helpers that abstract it away I noticed
that a few block drivers directly or implicitly call
flush_kernel_dcache_page before kunmapping a page that has been written
to.

flush_kernel_dcache_page is documented to to be used in such cases, but
flush_dcache_page is actually required when the page could be in the page
cache and mapped to userspace, which is pretty much always the case when
kmapping an arbitrary page.  Unfortunately the documentation doesn't
exactly make that clear, which lead to this misused.  And it turns out
that only the copy_strings / copy_string_kernel in the exec code were
actually correct users of flush_kernel_dcache_page, which is why I think
we should just remove it and eat the very minor overhead in exec rather
than confusing poor driver writers.


This patch (of 6):

MIPS now implements flush_kernel_dcache_page (as an alias to
flush_dcache_page).

Link: https://lkml.kernel.org/r/20210712060928.4161649-1-hch@lst.de
Link: https://lkml.kernel.org/r/20210712060928.4161649-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Guo Ren <guoren@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Cc: Rich Felker <dalias@libc.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Paul Cercueil <paul@crapouillou.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Alex Shi <alexs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/jz4740_mmc.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/mmc/host/jz4740_mmc.c~mmc-jz4740-remove-the-flush_kernel_dcache_page-call-in-jz4740_mmc_read_data
+++ a/drivers/mmc/host/jz4740_mmc.c
@@ -578,10 +578,6 @@ static bool jz4740_mmc_read_data(struct
 			}
 		}
 		data->bytes_xfered += miter->length;
-
-		/* This can go away once MIPS implements
-		 * flush_kernel_dcache_page */
-		flush_dcache_page(miter->page);
 	}
 	sg_miter_stop(miter);
 
_

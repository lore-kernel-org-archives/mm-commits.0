Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB89AC07E95
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 20:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D15B36044F
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 20:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhGTTbo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jul 2021 15:31:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230030AbhGTT2M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Jul 2021 15:28:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4A346100C;
        Tue, 20 Jul 2021 20:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626811695;
        bh=bdiG+ojY9JW2vQirNOFO83K7owGO/8DR4bpQlqmmFLw=;
        h=Date:From:To:Subject:From;
        b=Ou1SRcBi2ymsyKBCuuWN48QLDpd9NVLxsFYRj1GI3SZoQbKW/9qlyl7X0vhkz74ux
         kdwmthdntH9FqvcqcSBAQqrQes3XuAe+riyhXzHDH+j8fZbrQuksLa2ogAD2sjilHv
         s3B9gdmggybd/plq/c5abO0wt395qw/aiiF6L6TE=
Date:   Tue, 20 Jul 2021 13:08:14 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, dalias@libc.org, deanbo422@gmail.com,
        deller@gmx.de, geoff@infradead.org, green.hu@gmail.com,
        guoren@kernel.org, hch@lst.de,
        James.Bottomley@HansenPartnership.com, linux@armlinux.org.uk,
        mm-commits@vger.kernel.org, nickhu@andestech.com,
        paul@crapouillou.net, torvalds@linux-foundation.org,
        tsbogend@alpha.franken.de, ulf.hansson@linaro.org,
        ysato@users.osdn.me
Subject:  [merged] aacraid-remove-an-unused-include.patch removed
 from -mm tree
Message-ID: <20210720200814.eKSEjGl3U%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: aacraid: remove an unused include
has been removed from the -mm tree.  Its filename was
     aacraid-remove-an-unused-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: aacraid: remove an unused include

flush_kernel_dcache_page is not used by aacraid, and this header already
comes in through the scatterlist/block headers anyway.

Link: https://lkml.kernel.org/r/20210712060928.4161649-6-hch@lst.de
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

 drivers/scsi/aacraid/aachba.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/scsi/aacraid/aachba.c~aacraid-remove-an-unused-include
+++ a/drivers/scsi/aacraid/aachba.c
@@ -25,7 +25,6 @@
 #include <linux/completion.h>
 #include <linux/blkdev.h>
 #include <linux/uaccess.h>
-#include <linux/highmem.h> /* For flush_kernel_dcache_page */
 #include <linux/module.h>
 
 #include <asm/unaligned.h>
_

Patches currently in -mm which might be from hch@lst.de are

mm-call-flush_dcache_page-in-memcpy_to_page-and-memzero_page.patch
mm-use-kmap_local_page-in-memzero_page.patch
mmc-jz4740-remove-the-flush_kernel_dcache_page-call-in-jz4740_mmc_read_data.patch
mmc-mmc_spi-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
ps3disk-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
scatterlist-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
mm-remove-flush_kernel_dcache_page.patch


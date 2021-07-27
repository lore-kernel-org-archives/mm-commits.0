Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B119C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 19:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3394860FC0
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 19:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbhG0TfR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 15:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230454AbhG0TfR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 15:35:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8861460C51;
        Tue, 27 Jul 2021 19:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627414516;
        bh=UqC7iVpZRZO2v9qZ5jIUYt85EscXGKaZLeB8rwhLa5o=;
        h=Date:From:To:Subject:From;
        b=uHXbdU28tALnHTtt9E+xBPtXpkb2K6r2oUvYS3q8V7BAbSFi7OCxiKiSVdsdo7a5O
         aXW6hZOgjZXXVivfAdE+VEkUxl6wmH/uAjgXeE2mXREzPFYhlOkoRLZhzceWSNca4c
         SooyOcFeDX887vF+V6a+BdEnkF9cdxHy2zl1DxUw=
Date:   Tue, 27 Jul 2021 12:35:16 -0700
From:   akpm@linux-foundation.org
To:     chaitanya.kulkarni@wdc.com, hch@lst.de, ira.weiny@intel.com,
        mm-commits@vger.kernel.org
Subject:  [merged] mm-use-kmap_local_page-in-memzero_page.patch
 removed from -mm tree
Message-ID: <20210727193516.g1yQ-CueV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use kmap_local_page in memzero_page
has been removed from the -mm tree.  Its filename was
     mm-use-kmap_local_page-in-memzero_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: use kmap_local_page in memzero_page

The commit message introducing the global memzero_page explicitly mentions
switching to kmap_local_page in the commit log but doesn't actually do
that.

Link: https://lkml.kernel.org/r/20210713055231.137602-3-hch@lst.de
Fixes: 28961998f858 ("iov_iter: lift memzero_page() to highmem.h")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/highmem.h~mm-use-kmap_local_page-in-memzero_page
+++ a/include/linux/highmem.h
@@ -324,10 +324,10 @@ static inline void memcpy_to_page(struct
 
 static inline void memzero_page(struct page *page, size_t offset, size_t len)
 {
-	char *addr = kmap_atomic(page);
+	char *addr = kmap_local_page(page);
 	memset(addr + offset, 0, len);
 	flush_dcache_page(page);
-	kunmap_atomic(addr);
+	kunmap_local(addr);
 }
 
 #endif /* _LINUX_HIGHMEM_H */
_

Patches currently in -mm which might be from hch@lst.de are

mmc-jz4740-remove-the-flush_kernel_dcache_page-call-in-jz4740_mmc_read_data.patch
mmc-mmc_spi-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
ps3disk-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
scatterlist-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
mm-remove-flush_kernel_dcache_page.patch


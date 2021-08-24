Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A123CC432BE
	for <mm-commits@archiver.kernel.org>; Tue, 24 Aug 2021 20:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88CE66121E
	for <mm-commits@archiver.kernel.org>; Tue, 24 Aug 2021 20:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbhHXUpV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 Aug 2021 16:45:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233289AbhHXUpV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 24 Aug 2021 16:45:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FC1661181;
        Tue, 24 Aug 2021 20:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629837876;
        bh=SJd7q+jrtKviKMpTV4FQCV8fju1Yf1y7yDT5cHyvqm4=;
        h=Date:From:To:Subject:From;
        b=niEg60Vp/2FjS/fLw457qAKr3N0W1nPhPOlfDIfTjdAS4LFD5Q9Yjuwsjbzzk6YoE
         9ao29UqRI7h93BFEAVC1bw2DnnSh+6TbbMBwbhKwLIuIA04pS8gIkJMtYq4LOfrFcc
         g9pj2sTPgr4QfItmg2UZFiHEnyza3BxIaGr0dp+c=
Date:   Tue, 24 Aug 2021 13:44:36 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, peterz@infradead.org,
        npiggin@gmail.com, hch@lst.de
Subject:  + mm-dont-allow-executable-ioremap-mappings.patch added to
 -mm tree
Message-ID: <20210824204436.B7gsj%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't allow executable ioremap mappings
has been added to the -mm tree.  Its filename is
     mm-dont-allow-executable-ioremap-mappings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-dont-allow-executable-ioremap-mappings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-allow-executable-ioremap-mappings.patch

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
Subject: mm: don't allow executable ioremap mappings

There is no need to execute from iomem (and most platforms it is
impossible anyway), so add the pgprot_nx() call similar to vmap.

Link: https://lkml.kernel.org/r/20210824091259.1324527-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-dont-allow-executable-ioremap-mappings
+++ a/mm/vmalloc.c
@@ -316,7 +316,7 @@ int ioremap_page_range(unsigned long add
 {
 	int err;
 
-	err = vmap_range_noflush(addr, end, phys_addr, prot,
+	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
 				 ioremap_max_page_shift);
 	flush_cache_vmap(addr, end);
 	return err;
_

Patches currently in -mm which might be from hch@lst.de are

mmc-jz4740-remove-the-flush_kernel_dcache_page-call-in-jz4740_mmc_read_data.patch
mmc-mmc_spi-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
scatterlist-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
mm-remove-flush_kernel_dcache_page.patch
mm-move-ioremap_page_range-to-vmallocc.patch
mm-dont-allow-executable-ioremap-mappings.patch
proc-stop-using-seq_get_buf-in-proc_task_name.patch
kernel-unexport-get_mmtask_exe_file.patch
mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch


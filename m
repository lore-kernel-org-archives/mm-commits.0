Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684E1C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 525836112E
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349821AbhICU71 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:59:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349516AbhICU70 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:59:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 945D761107;
        Fri,  3 Sep 2021 20:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702706;
        bh=tzXsn90UmYTajBsk0tkZs1joYnLzwCEtZFKBUPgVZ2g=;
        h=Date:From:To:Subject:From;
        b=Bs5akRdOzsqr8QKfxUmsc5VXJLdqTSd8KfzAC9OUw+opsmRgSEelnZd6/KhPwkk8Z
         hkW06TgoGX08RA5lSpmEmrTl4cfFeG6KG/6HIxziFpMQ2Dl9ClqmG33Zn4B5rRYHDa
         Z4u5O7sCmzcHF2Xj6FYv/CEOPc5tKQMDCk3cINpQ=
Date:   Fri, 03 Sep 2021 13:58:25 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, dalias@libc.org, deanbo422@gmail.com,
        deller@gmx.de, geoff@infradead.org, green.hu@gmail.com,
        guoren@kernel.org, hch@lst.de,
        James.Bottomley@HansenPartnership.com, linux@armlinux.org.uk,
        mm-commits@vger.kernel.org, nickhu@andestech.com,
        paul@crapouillou.net, torvalds@linux-foundation.org,
        tsbogend@alpha.franken.de, ulf.hansson@linaro.org,
        ysato@users.osdn.me
Subject:  [merged]
 scatterlist-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
 removed from -mm tree
Message-ID: <20210903205825.tcoELWTvp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scatterlist: replace flush_kernel_dcache_page with flush_dcache_page
has been removed from the -mm tree.  Its filename was
     scatterlist-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: scatterlist: replace flush_kernel_dcache_page with flush_dcache_page

Pages used in scatterlist can be mapped page cache pages (and often are),
so we must use flush_dcache_page here instead of the more limited
flush_kernel_dcache_page that is intended for highmem pages only.

Also remove the PageSlab check given that page_mapping_file as used by the
flush_dcache_page implementations already contains that check.

Link: https://lkml.kernel.org/r/20210712060928.4161649-5-hch@lst.de
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

 lib/scatterlist.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/lib/scatterlist.c~scatterlist-replace-flush_kernel_dcache_page-with-flush_dcache_page
+++ a/lib/scatterlist.c
@@ -887,9 +887,8 @@ void sg_miter_stop(struct sg_mapping_ite
 		miter->__offset += miter->consumed;
 		miter->__remaining -= miter->consumed;
 
-		if ((miter->__flags & SG_MITER_TO_SG) &&
-		    !PageSlab(miter->page))
-			flush_kernel_dcache_page(miter->page);
+		if (miter->__flags & SG_MITER_TO_SG)
+			flush_dcache_page(miter->page);
 
 		if (miter->__flags & SG_MITER_ATOMIC) {
 			WARN_ON_ONCE(preemptible());
_

Patches currently in -mm which might be from hch@lst.de are

riscv-only-select-generic_ioremap-if-mmu-support-is-enabled.patch
mm-move-ioremap_page_range-to-vmallocc.patch
mm-dont-allow-executable-ioremap-mappings.patch
proc-stop-using-seq_get_buf-in-proc_task_name.patch
kernel-unexport-get_mmtask_exe_file.patch
mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch


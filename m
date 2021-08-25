Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 713E8C4338F
	for <mm-commits@archiver.kernel.org>; Wed, 25 Aug 2021 07:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5590460F91
	for <mm-commits@archiver.kernel.org>; Wed, 25 Aug 2021 07:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238589AbhHYHVY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Aug 2021 03:21:24 -0400
Received: from verein.lst.de ([213.95.11.211]:55072 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236402AbhHYHVY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Aug 2021 03:21:24 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E46C267357; Wed, 25 Aug 2021 09:20:36 +0200 (CEST)
Date:   Wed, 25 Aug 2021 09:20:36 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, peterz@infradead.org,
        npiggin@gmail.com, linux-riscv@lists.infradead.org
Subject: Re: + mm-move-ioremap_page_range-to-vmallocc.patch added to -mm
 tree
Message-ID: <20210825072036.GA29161@lst.de>
References: <20210824204433.qwSJf%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824204433.qwSJf%akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

To fix the riscv-nommu build this patch should be queued up before
th move:

---
From f454cd71930eff395f8be8674bef0ccd53bd1b62 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Wed, 25 Aug 2021 09:18:21 +0200
Subject: riscv: only select GENERIC_IOREMAP if MMU support is enabled

nommu ioremap is an inline stub in asm-generic/io.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/riscv/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 4f7b70ae7c31..8598e3d103a3 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -48,7 +48,7 @@ config RISCV
 	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
 	select GENERIC_EARLY_IOREMAP
 	select GENERIC_GETTIMEOFDAY if HAVE_GENERIC_VDSO
-	select GENERIC_IOREMAP
+	select GENERIC_IOREMAP if MMU
 	select GENERIC_IRQ_MULTI_HANDLER
 	select GENERIC_IRQ_SHOW
 	select GENERIC_LIB_DEVMEM_IS_ALLOWED
-- 
2.30.2


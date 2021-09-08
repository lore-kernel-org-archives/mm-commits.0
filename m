Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 713DCC43217
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E3E461100
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347291AbhIHC5G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345895AbhIHC5G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:57:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B464B60555;
        Wed,  8 Sep 2021 02:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069759;
        bh=RU8Dw0Kd+GW4mhvH5fgaICMHylZ5tb/00N5+4ZKKnpg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PF0Bbi9FysVGUOPXk2SkYYT5T/z55lMTQ9SWVXjv+FRD1ELUY8eDmGUyQAAD/OXX6
         UedqMwoSDmPIeXe7Ip+kTNobGZFLdm725bNTO2185DDmfiA5N+kIE05Qq2xDRQRTLa
         VCIAV1uX+HrCgUDsB4yB7K+9Xh7t5K0LRvXVOMrg=
Date:   Tue, 07 Sep 2021 19:55:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        peterz@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 053/147] riscv: only select GENERIC_IOREMAP if MMU
 support is enabled
Message-ID: <20210908025558.JdulXucpn%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: riscv: only select GENERIC_IOREMAP if MMU support is enabled

nommu ioremap is an inline stub in asm-generic/io.h.

Link: https://lkml.kernel.org/r/20210825072036.GA29161@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/Kconfig~riscv-only-select-generic_ioremap-if-mmu-support-is-enabled
+++ a/arch/riscv/Kconfig
@@ -48,7 +48,7 @@ config RISCV
 	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
 	select GENERIC_EARLY_IOREMAP
 	select GENERIC_GETTIMEOFDAY if HAVE_GENERIC_VDSO
-	select GENERIC_IOREMAP
+	select GENERIC_IOREMAP if MMU
 	select GENERIC_IRQ_MULTI_HANDLER
 	select GENERIC_IRQ_SHOW
 	select GENERIC_LIB_DEVMEM_IS_ALLOWED
_

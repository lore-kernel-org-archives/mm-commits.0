Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2785BC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CA0A61459
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhD3F7p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:59:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230132AbhD3F7p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:59:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55A6B61482;
        Fri, 30 Apr 2021 05:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762336;
        bh=aAmLc48gFEaPXkLdU25LHj1RML1v05ZZGkfJuD3w7gU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zefc4ry29ZBldAjMA0LY1350Ry5pLTRvB441l3ZKaLtXentqwH5y1tuL85XBEpRl9
         Nvme1YUdeqz5HuDGNM5Jcb0SNKyPZkdLMNxHXBnesKxoumHsGPwew8avxsiUJoeumS
         5DBbXVC1K5Mhr2OSn5LqV6fHao1FvdanqIJKKYwc=
Date:   Thu, 29 Apr 2021 22:58:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, clg@kaod.org, hch@lst.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, npiggin@gmail.com,
        torvalds@linux-foundation.org, urezki@gmail.com
Subject:  [patch 111/178] kernel/dma: remove unnecessary
 unmap_kernel_range
Message-ID: <20210430055855.0q2vqIi8N%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Nicholas Piggin <npiggin@gmail.com>
Subject: kernel/dma: remove unnecessary unmap_kernel_range

vunmap will remove ptes.

Link: https://lkml.kernel.org/r/20210322021806.892164-3-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: C=C3=A9dric Le Goater <clg@kaod.org>
Cc: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma/remap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/dma/remap.c~kernel-dma-remove-unnecessary-unmap_kernel_range
+++ a/kernel/dma/remap.c
@@ -66,6 +66,5 @@ void dma_common_free_remap(void *cpu_add
 		return;
 	}
=20
-	unmap_kernel_range((unsigned long)cpu_addr, PAGE_ALIGN(size));
 	vunmap(cpu_addr);
 }
_

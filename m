Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45160C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E8946113C
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347323AbhIHC5T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:57:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347433AbhIHC5L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:57:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7951661100;
        Wed,  8 Sep 2021 02:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069764;
        bh=XNahHEED0dv6D5JHiqZXWfyh6iSLlm+nqYHpDiwzbDA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SiCIdy0P+jl/WLClD+IevWFwbfi1+1KWXSv3SaBEChlYZ94XKj1vrXA9EwsIqIVCE
         ++GjYM1ASPejpA9wtsSxmP/P7YFbjVj+hH8K4n5hO9cRxuN+mKQ/v8bhfSQHy102cH
         ACdKvvlWMW/QrQjJJqm7OlATBlo8i7kDLLeQ7uLo=
Date:   Tue, 07 Sep 2021 19:56:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        peterz@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 055/147] mm: don't allow executable ioremap
 mappings
Message-ID: <20210908025604.WeTOgRzRO%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A71C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:48:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA3B42313B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgLPEsB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:48:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:52992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbgLPEsB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:48:01 -0500
Date:   Tue, 15 Dec 2020 20:47:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608094041;
        bh=2qDQ1ke+trJbpIb3uHtn+DvG/3zErgqzIqreuIgmPJ0=;
        h=From:To:Subject:In-Reply-To:From;
        b=vDjFfSw3UIAHse108dWPZpXvbs3pW98lYeHdMf9ftd1u8HF1CboTRL8Gs4t74PLWI
         BrTriRg11I2Zf9iirChqzOPN2lW03x4l4OzK34bBcbbRKFCFogplmjP2gk9KQt9sGq
         DeY2aJeH9e32hmckv1DmKTy1yGi+wro+rRi/ImAU=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        daniel@ffwll.ch, hch@lst.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 91/95] mm: unexport follow_pte_pmd
Message-ID: <20201216044720.lWaAFUo2S%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: mm: unexport follow_pte_pmd

Patch series "simplify follow_pte a bit".

This small series drops the not needed follow_pte_pmd exports, and
simplifies the follow_pte family of functions a bit.


This patch (of 2):

follow_pte_pmd() is only used by the DAX code, which can't be modular.

Link: https://lkml.kernel.org/r/20201029101432.47011-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memory.c~mm-unexport-follow_pte_pmd
+++ a/mm/memory.c
@@ -4798,7 +4798,6 @@ int follow_pte_pmd(struct mm_struct *mm,
 						    ptepp, pmdpp, ptlp)));
 	return res;
 }
-EXPORT_SYMBOL(follow_pte_pmd);
 
 /**
  * follow_pfn - look up PFN at a user virtual address
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC32C1B08C
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 04:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BA2F6136E
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 04:26:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236353AbhGOE3t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 00:29:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236350AbhGOE3s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 00:29:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B27A6128C;
        Thu, 15 Jul 2021 04:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626323216;
        bh=dmCJejRnUY2wFaFILR5RtwcF3EX/YHO/GYcUOohB8yM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=omsg4VG7ifQQP+AmVIEcCGfhfveekNoHIXJruRbBTFft13pVFtknJv1H9NnG5L3J4
         Ci27CCvbje7kWAnRduUaoxWNvkMNzMmaJbPrGWeZWADUfRYz609oW+hKoytkueiiof
         KTujBix2m602BFiTLWW7Wt2vNxoMWSbUXW7dJQms=
Date:   Wed, 14 Jul 2021 21:26:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 08/13] mm: fix the try_to_unmap prototype for
 !CONFIG_MMU
Message-ID: <20210715042655.ljTZkSkdp%akpm@linux-foundation.org>
In-Reply-To: <20210714212609.fad116e584ba1194981a6294@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: mm: fix the try_to_unmap prototype for !CONFIG_MMU

Adjust the nommu stub of try_to_unmap to match the changed protype for the
full version.  Turn it into an inline instead of a macro to generally
improve the type checking.

Link: https://lkml.kernel.org/r/20210705053944.885828-1-hch@lst.de
Fixes: 1fb08ac63bee ("mm: rmap: make try_to_unmap() void function")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/rmap.h~mm-fix-the-try_to_unmap-prototype-for-config_mmu
+++ a/include/linux/rmap.h
@@ -291,7 +291,9 @@ static inline int page_referenced(struct
 	return 0;
 }
 
-#define try_to_unmap(page, refs) false
+static inline void try_to_unmap(struct page *page, enum ttu_flags flags)
+{
+}
 
 static inline int page_mkclean(struct page *page)
 {
_

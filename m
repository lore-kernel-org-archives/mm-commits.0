Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9D7C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:58:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C160761459
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhD3F6x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230215AbhD3F6x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:58:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85E186147E;
        Fri, 30 Apr 2021 05:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762284;
        bh=0YFXjKzucIxCepiWhlKIX/t+edfkExTQoUMESXsTAJw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nFofpQ183nxnqvo0uLItquGqm5idghMw1CsJkYkPTm9PuTzig4dH1t2rW+kkriNFn
         6gR2svZWVzjQbqwwW5FlNYcNAI/2jpUCLMW9BJM9x4ASE8LLWVE95B4N0IFoEqI5fB
         SpsKD0BmaVmX5N6mqARfWs0FmgSMuifKDEnpLQ0M=
Date:   Thu, 29 Apr 2021 22:58:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, kwankhede@nvidia.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 095/178] mm: unexport remap_vmalloc_range_partial
Message-ID: <20210430055804.byPAP2I8d%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: mm: unexport remap_vmalloc_range_partial

remap_vmalloc_range_partial is only used to implement remap_vmalloc_range
and by procfs.  Unexport it.

Link: https://lkml.kernel.org/r/20210301082235.932968-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Kirti Wankhede <kwankhede@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmalloc.c~mm-unexport-remap_vmalloc_range_partial
+++ a/mm/vmalloc.c
@@ -3072,7 +3072,6 @@ int remap_vmalloc_range_partial(struct v
 
 	return 0;
 }
-EXPORT_SYMBOL(remap_vmalloc_range_partial);
 
 /**
  * remap_vmalloc_range - map vmalloc pages to userspace
_

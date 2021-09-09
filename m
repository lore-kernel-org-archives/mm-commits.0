Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DABFAC433FE
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:03:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFC4C611C2
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346787AbhIIVEW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347756AbhIIVDa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:03:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A8EF611C3;
        Thu,  9 Sep 2021 21:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221332;
        bh=c4qoy8odPrSbDkW6TnCEWvwV7sOAPCgWy8hDuOKYHRI=;
        h=Date:From:To:Subject:From;
        b=ERcHnBE9msGnLnmvCrlARHk2OTOTHsndxXrkuitMc0ozF1w62+fOxTo86c30EhsxT
         KyYELyhNnorkwUsQ0HGmJQpuRu5spC5wYGURdS73L2jjVcw3DzrjFJX+0w5+eR0q9U
         p7NxhAqtAsep+XV52U0kvVrcPGarVhpiI3HSmXy4=
Date:   Thu, 09 Sep 2021 14:02:12 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org, npiggin@gmail.com,
        peterz@infradead.org
Subject:  [merged] mm-dont-allow-executable-ioremap-mappings.patch
 removed from -mm tree
Message-ID: <20210909210212.zwtyXEOY9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't allow executable ioremap mappings
has been removed from the -mm tree.  Its filename was
     mm-dont-allow-executable-ioremap-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11110C001DE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Aug 2023 19:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbjHITOt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Aug 2023 15:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233152AbjHITON (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Aug 2023 15:14:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435E635A1
        for <mm-commits@vger.kernel.org>; Wed,  9 Aug 2023 12:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=j1IsFKQC925Ol/+Sh6O5QWGhdtlRk9FPXioIQvKQ8Ic=; b=O3jy5gEfH8fdOU0AC9YnFiSzrR
        xXRnQJz5PjZnydBDyZ5axiKQP7CJXs9xUBWYi2S5rKa/KuAF1C8F5KGYiHZ8jRhb/pSyYJ2SzHFrV
        9A5Nbc9QEuUjoS+/ujoMTDht05Ua2DK/JshOB66aQzOtACJd99M9G6JDwKIlF4Vz+MwSaCvOcvO9O
        8TfkMaMHLhBV06dGkNI14T3CgJMkQ6TL1gQ6BNuec5x1csyzoUDAA0E0PPZyuAorv39ZLd5IqIhbz
        XH9QIewPAaBqozQ8teUs+vkVI2SyhV0UFUHTcRxypzHVbQie4F/j6V4tFgp6U2tb4oIrW8yUnU/7E
        SHCfEAxQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qToc4-007wiF-7Z; Wed, 09 Aug 2023 19:12:56 +0000
Date:   Wed, 9 Aug 2023 20:12:56 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, rppt@kernel.org, linux@armlinux.org.uk,
        m.szyprowski@samsung.com
Subject: Re: + arm-implement-the-new-page-table-range-api-fix.patch added to
 mm-unstable branch
Message-ID: <ZNPlOCe8F+nrzPxr@casper.infradead.org>
References: <20230809185520.8C392C433C8@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809185520.8C392C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Aug 09, 2023 at 11:55:19AM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: arm: dma-mapping: fix potential endless loop in __dma_page_dev_to_cpu()
> has been added to the -mm mm-unstable branch.  Its filename is
>      arm-implement-the-new-page-table-range-api-fix.patch

Thanks.  Can you add ia64-implement-the-new-page-table-range-api-fix.patch
as well, please?  (Debian no longer ships the compilers, so not even
compile tested)

diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 48d475f10003..c4d477e8bcd4 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -811,12 +811,16 @@ static void mark_clean(void *addr, size_t size)
 
 	if (offset) {
 		left -= folio_size(folio) - offset;
+		if (left <= 0)
+			return;
 		folio = folio_next(folio);
 	}
 
 	while (left >= folio_size(folio)) {
-		set_bit(PG_arch_1, &folio->flags);
 		left -= folio_size(folio);
+		set_bit(PG_arch_1, &folio->flags);
+		if (!left)
+			break;
 		folio = folio_next(folio);
 	}
 }
diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index b95debabdc2a..05b0f2f0c073 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -76,12 +76,16 @@ void arch_dma_mark_clean(phys_addr_t paddr, size_t size)
 
 	if (offset) {
 		left -= folio_size(folio) - offset;
+		if (left <= 0)
+			return;
 		folio = folio_next(folio);
 	}
 
 	while (left >= (ssize_t)folio_size(folio)) {
-		set_bit(PG_arch_1, &pfn_to_page(pfn)->flags);
 		left -= folio_size(folio);
+		set_bit(PG_arch_1, &pfn_to_page(pfn)->flags);
+		if (!left)
+			break;
 		folio = folio_next(folio);
 	}
 }

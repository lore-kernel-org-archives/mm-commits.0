Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 003CAC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  8 Apr 2022 20:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239440AbiDHUMX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Apr 2022 16:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbiDHUMT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Apr 2022 16:12:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DEBF353AAA
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 13:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7HoX5pHevUIv6UZaOmmC+F7e/fvQ9ySUHLztBp6e4Q4=; b=Yu3/6LCeG1rNtuc8x7kV8msuUc
        r8G+Rj0sgFgTe8Hb1W77g5vmfTxfE/SACjUnqJix64gTK2asQtot7IYPTlylrak4L3KbcLm7hGkBW
        l/5zV0VfmLPKNi7wb10iKDQQD4FP+FptUp4jTzi+bgYaEPKowfPQQ4ZWtfEzGSp+uQA9lipu022gy
        LH0L3orBf5nchhk1YCkPoC9nBrcv5A0XmhRcxK7WmnYpnEmjQMsP10z6RHFxI2CZGdTgFg3YASzzr
        yE86elhYrFwWlXE1GeFQcqHoukXBER1DoxKF6YL+e2/c1Wxvy+9K+otHkzcfixSikUIfmFT44nOhL
        rrgtiaWw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ncuvi-00A7hE-Cg; Fri, 08 Apr 2022 20:10:02 +0000
Date:   Fri, 8 Apr 2022 21:10:02 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     naoya.horiguchi@linux.dev, mhocko@kernel.org, ziy@nvidia.com,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [patch 1/9] mm: migrate: use thp_order instead of
 HPAGE_PMD_ORDER for new page allocation.
Message-ID: <YlCWmi7zs8zZ0s2e@casper.infradead.org>
References: <20220408130819.a89195e527ce58dfbe0700b9@linux-foundation.org>
 <20220408200853.40FD9C385A3@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408200853.40FD9C385A3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Apr 08, 2022 at 01:08:52PM -0700, Andrew Morton wrote:
> From: Zi Yan <ziy@nvidia.com>
> Subject: mm: migrate: use thp_order instead of HPAGE_PMD_ORDER for new page allocation.
> 
> Fix a VM_BUG_ON_FOLIO(folio_nr_pages(old) != nr_pages) crash.
> 
> With folios support, it is possible to have other than HPAGE_PMD_ORDER
> THPs, in the form of folios, in the system.  Use thp_order() to correctly
> determine the source page order during migration.

This one's now obsolete after the folio pull request Linus merged
earlier today.

> Link: https://lkml.kernel.org/r/20220404165325.1883267-1-zi.yan@sent.com
> Link: https://lore.kernel.org/linux-mm/20220404132908.GA785673@u2004/
> Fixes: d68eccad3706 ("mm/filemap: Allow large folios to be added to the page cache")
> Reported-by: Naoya Horiguchi <naoya.horiguchi@linux.dev>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/mempolicy.c |    2 +-
>  mm/migrate.c   |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/mm/mempolicy.c~mm-migrate-use-thp_order-instead-of-hpage_pmd_order-for-new-page-allocation
> +++ a/mm/mempolicy.c
> @@ -1209,7 +1209,7 @@ static struct page *new_page(struct page
>  		struct page *thp;
>  
>  		thp = alloc_hugepage_vma(GFP_TRANSHUGE, vma, address,
> -					 HPAGE_PMD_ORDER);
> +					 thp_order(page));
>  		if (!thp)
>  			return NULL;
>  		prep_transhuge_page(thp);
> --- a/mm/migrate.c~mm-migrate-use-thp_order-instead-of-hpage_pmd_order-for-new-page-allocation
> +++ a/mm/migrate.c
> @@ -1547,7 +1547,7 @@ struct page *alloc_migration_target(stru
>  		 */
>  		gfp_mask &= ~__GFP_RECLAIM;
>  		gfp_mask |= GFP_TRANSHUGE;
> -		order = HPAGE_PMD_ORDER;
> +		order = thp_order(page);
>  	}
>  	zidx = zone_idx(page_zone(page));
>  	if (is_highmem_idx(zidx) || zidx == ZONE_MOVABLE)
> _
> 

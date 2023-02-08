Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65070C636D3
	for <mm-commits@archiver.kernel.org>; Wed,  8 Feb 2023 22:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbjBHWHk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Feb 2023 17:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbjBHWHj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2023 17:07:39 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3332D141
        for <mm-commits@vger.kernel.org>; Wed,  8 Feb 2023 14:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HlvR3d/6n/F587Rd5qM29kAwyzm+92Ti0VB36bENoZI=; b=mbCJ/juuRXUhePBQukWRHHwoE/
        0ZQBBPyYgc0sHOQ/ulRO6piRc8cQMlQCw4NdFFFZ2McPqpZSWBBweu2wOyScUiF1JmOKuz7TlzHtM
        D1se+rqKTsLGh2tag4JwO3SHTBWjFl4Qy+MB2WEaesknQHVlY44N5uNyrzJ6y71TA/tJTcYXmctvs
        BxI3OEjI2BlQeenp9SbDnpNQ8GwRgFRMVnnMM3HzlFPR41HELpHU65jBRnRIDDST0L1Xx0vsABMNU
        B/s6n8ZaZf74+laQt3b5ZfNBgXGkUHsSS0RCyj5+cWOkARZBoNRD7Te070QAKniWU4jCX3c5qBLt/
        0l2/8wVA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pPsbF-001aDN-DN; Wed, 08 Feb 2023 22:07:33 +0000
Date:   Wed, 8 Feb 2023 22:07:33 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, vbabka@suse.cz, surenb@google.com,
        shakeelb@google.com, rientjes@google.com,
        quic_pkondeti@quicinc.com, quic_charante@quicinc.com,
        mhocko@suse.com, markhemm@googlemail.com, hughd@google.com
Subject: Re: + shmem-add-shmem_read_folio-and-shmem_read_folio_gfp.patch
 added to mm-unstable branch
Message-ID: <Y+QdJTuzxeBYejw2@casper.infradead.org>
References: <20230207010408.34435C433EF@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207010408.34435C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Feb 06, 2023 at 05:04:07PM -0800, Andrew Morton wrote:
> +struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
> +					 pgoff_t index, gfp_t gfp)
> +{
> +	struct folio *folio = shmem_read_folio_gfp(mapping, index, gfp);
> +	struct page *page = folio_file_page(folio, index);
> +

Ugh, insufficiently cautious.

This should have been

	struct folio *folio = shmem_read_folio_gfp(mapping, index, gfp);
	struct page *page;

	if (IS_ERR(folio))
		return &folio->page;
	page = folio_file_page(folio, index);

Unfortunately I have to go out now, but that's the solution to the
latest syzbot splat I saw.  I'll do you a proper -fix patch later
if you don't get to it first.

>  	if (PageHWPoison(page)) {
>  		folio_put(folio);
>  		return ERR_PTR(-EIO);
>  	}
>  
>  	return page;
> -#else
> -	/*
> -	 * The tiny !SHMEM case uses ramfs without swap
> -	 */
> -	return read_cache_page_gfp(mapping, index, gfp);
> -#endif
>  }
>  EXPORT_SYMBOL_GPL(shmem_read_mapping_page_gfp);
> _
> 
> Patches currently in -mm which might be from willy@infradead.org are
> 
> mm-add-memcpy_from_file_folio.patch
> filemap-add-mapping_read_folio_gfp.patch
> shmem-add-shmem_read_folio-and-shmem_read_folio_gfp.patch
> shmem-fix-w=1-build-warnings-with-config_shmem=n.patch
> 

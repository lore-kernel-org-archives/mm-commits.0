Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA99C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 15:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346597AbiEJPwj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 11:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347193AbiEJPwE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 11:52:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B0E28AB90
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 08:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vNk+JXG6jDXFMFQJslsc7ZZEpVqFxXOCzCsxW4Shybk=; b=a9aUHllAugXn7pEv09yaFnTFdN
        /vaEy4gAvGzpDD+0U7zU2c38IsAGQO+6ZkzCpw2tXjnb5BTB8x+8k9b+EsRgaeZ5zKe1at8fHAXg8
        hU7gmOP3ncuE11kSnHN0acbzUHJFZq0sYX3O6XrXRxRDDDN0q+OKIOGDQwui2weRq6oSfzNzoBiph
        LPDJVZu6x8fFiJXxT9W5+qTYmak1o4nYd05+OMdxtYtUnjQfmFvuTC1SEERrBHwZ+xQuqdWydAjtX
        dUPD67hWT7spvQFQ1uGSQ8VTGNAW1YGBJAAuzp7RzBxSPjxBb/TBRJtGwibF3SE39dDuUFBagxc05
        HIStHn9g==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noS4u-004awa-Iy; Tue, 10 May 2022 15:47:12 +0000
Date:   Tue, 10 May 2022 16:47:12 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, hch@lst.de
Subject: Re: +
 vmscan-convert-the-writeback-handling-in-shrink_page_list-to-folios.patch
 added to mm-unstable branch
Message-ID: <YnqJAGgV7S8b51fk@casper.infradead.org>
References: <20220506013250.B5929C385A8@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506013250.B5929C385A8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, May 05, 2022 at 06:32:50PM -0700, Andrew Morton wrote:
> +++ a/mm/vmscan.c
> @@ -1598,40 +1598,42 @@ retry:
>  			stat->nr_congested += nr_pages;
>  
>  		/*
> -		 * If a page at the tail of the LRU is under writeback, there
> +		 * If a folio at the tail of the LRU is under writeback, there
>  		 * are three cases to consider.
>  		 *
> -		 * 1) If reclaim is encountering an excessive number of pages
> -		 *    under writeback and this page is both under writeback and
> -		 *    PageReclaim then it indicates that pages are being queued
> -		 *    for IO but are being recycled through the LRU before the
> -		 *    IO can complete. Waiting on the page itself risks an
> -		 *    indefinite stall if it is impossible to writeback the
> -		 *    page due to IO error or disconnected storage so instead
> -		 *    note that the LRU is being scanned too quickly and the
> -		 *    caller can stall after page list has been processed.
> +		 * 1) If reclaim is encountering an excessive number of folios
> +		 *    under writeback and this folio is both under
> +		 *    writeback and has the reclaim flag set then it
> +		 *    indicates that folios are being queued for I/O but
> +		 *    are being recycled through the LRU before the I/O
> +		 *    can complete. Waiting on the folio itself risks an
> +		 *    indefinite stall if it is impossible to writeback
> +		 *    the folio due to I/O error or disconnected storage
> +		 *    so instead note that the LRU is being scanned too
> +		 *    quickly and the caller can stall after the folio
> +		 *    list has been processed.
>  		 *

At some point between this email being sent and what's currently in
linux-next, the above asterisk changed to a hash (* -> #).  You may
or may not want to fix that.


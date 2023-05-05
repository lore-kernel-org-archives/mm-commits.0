Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B607C77B75
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 23:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbjEEXGQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 19:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbjEEXGF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 19:06:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266EC199D
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 16:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KzbLpKxu9IPiAHwrddB9vxonVs2gl2TFIae1sjyAzvI=; b=utJj9q6etERW9DmSVFmF2cCKAX
        IX2x0AhiAzPjoj1I1O9MYgSENFsv1ZuhtQpxsBTLmddIrcLtg8VzaCrz5UCUBOpyG5mFPeBxvYKHM
        rSj2CxQ7Y2rdtG+tXk2rTITTIehqNvkDnbquOOWEma80ifnqrXQI63sVBvqa0D1jLBIwx7BNSPBTU
        5KszJpRZMEeuyhTWqNU01Esu2SKsOAAiFFr7OivZ1YDvKie9D1ozRxSLXshTkAqOn5/Uy/Xldffhr
        ZoZb3nGF+PkO1GEIpwSFWaVFm/wEbgSEVvsqexxmU3/JLzSuT8QbQAO4Fj/e1KlIzK5orEgmBS1R9
        VujY8P7A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pv4Uv-00Bxe3-FH; Fri, 05 May 2023 23:05:57 +0000
Date:   Sat, 6 May 2023 00:05:57 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, marc.dionne@auristor.com, jack@suse.cz,
        dhowells@redhat.com, hch@lst.de
Subject: Re: [merged mm-hotfixes-stable]
 filemap-fix-the-conditional-folio_put-in-filemap_fault.patch removed from
 -mm tree
Message-ID: <ZFWL1QyYs8asYDzR@casper.infradead.org>
References: <20230505224305.B7761C433D2@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230505224305.B7761C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, May 05, 2023 at 03:43:05PM -0700, Andrew Morton wrote:
> 
> The quilt patch titled
>      Subject: filemap: fix the conditional folio_put in filemap_fault
> has been removed from the -mm tree.  Its filename was
>      filemap-fix-the-conditional-folio_put-in-filemap_fault.patch
> 
> This patch was dropped because it was merged into the mm-hotfixes-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

I thought i nacked this?

> ------------------------------------------------------
> From: Christoph Hellwig <hch@lst.de>
> Subject: filemap: fix the conditional folio_put in filemap_fault
> Date: Wed, 3 May 2023 17:45:25 +0200
> 
> folio can't be NULL here now that __filemap_get_folio returns an ERR_PTR. 
> Remove the conditional folio_put after the out_retry label and add a new
> label for the cases where we have a valid folio.
> 
> Link: https://lkml.kernel.org/r/20230503154526.1223095-1-hch@lst.de
> Fixes: 66dabbb65d67 ("mm: return an ERR_PTR from __filemap_get_folio")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: syzbot+48011b86c8ea329af1b9@syzkaller.appspotmail.com
> Reviewed-by: Jan Kara <jack@suse.cz>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Marc Dionne <marc.dionne@auristor.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/filemap.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> --- a/mm/filemap.c~filemap-fix-the-conditional-folio_put-in-filemap_fault
> +++ a/mm/filemap.c
> @@ -3298,7 +3298,7 @@ retry_find:
>  	}
>  
>  	if (!lock_folio_maybe_drop_mmap(vmf, folio, &fpin))
> -		goto out_retry;
> +		goto out_retry_put_folio;
>  
>  	/* Did it get truncated? */
>  	if (unlikely(folio->mapping != mapping)) {
> @@ -3334,7 +3334,7 @@ retry_find:
>  	 */
>  	if (fpin) {
>  		folio_unlock(folio);
> -		goto out_retry;
> +		goto out_retry_put_folio;
>  	}
>  	if (mapping_locked)
>  		filemap_invalidate_unlock_shared(mapping);
> @@ -3363,7 +3363,7 @@ page_not_uptodate:
>  	fpin = maybe_unlock_mmap_for_io(vmf, fpin);
>  	error = filemap_read_folio(file, mapping->a_ops->read_folio, folio);
>  	if (fpin)
> -		goto out_retry;
> +		goto out_retry_put_folio;
>  	folio_put(folio);
>  
>  	if (!error || error == AOP_TRUNCATED_PAGE)
> @@ -3372,14 +3372,14 @@ page_not_uptodate:
>  
>  	return VM_FAULT_SIGBUS;
>  
> +out_retry_put_folio:
> +	folio_put(folio);
>  out_retry:
>  	/*
>  	 * We dropped the mmap_lock, we need to return to the fault handler to
>  	 * re-find the vma and come back and find our hopefully still populated
>  	 * page.
>  	 */
> -	if (folio)
> -		folio_put(folio);
>  	if (mapping_locked)
>  		filemap_invalidate_unlock_shared(mapping);
>  	if (fpin)
> _
> 
> Patches currently in -mm which might be from hch@lst.de are
> 
> 

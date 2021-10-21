Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 219CAC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 21 Oct 2021 02:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 029AA611EF
	for <mm-commits@archiver.kernel.org>; Thu, 21 Oct 2021 02:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhJUCgi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Oct 2021 22:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhJUCgh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Oct 2021 22:36:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60CBC06161C
        for <mm-commits@vger.kernel.org>; Wed, 20 Oct 2021 19:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=02w/teJyItipJXW6Ei4ZqytK3D54cJLvv0ayfdS+jx8=; b=LIfDBXDHGhS4ZPK1IzC8VOqf+d
        8r5z65OauTC6sjkJXqL/W2810OiX61EdJQweiSPkbgFqG1pCDoxWw+jIZMG6fxuJVDfRkMKaXCp1L
        pYSlIJ7/Aeh9WdBs0dA3uAH1HRIjL8gbsg+EWGBXRxHfcCTpROnYxQF/SBdA8Puu1KjqgJZzQcYOs
        yRVYjLiVvlSDENXjGjw6Cljzmph2LMSGqEDHNVm51l7TwUr5NXprNJG1RxjpKJngmj3zAmtpeuNe+
        I6caNWBpCP0Sb45a3wVeC19I2RsBTUiiSTetal36NAXQWbNGDxWBZ8xHJS1WRt4XrJPQLVOsrKct2
        JSpNW7Sg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mdNs1-00Cz6H-Tf; Thu, 21 Oct 2021 02:32:13 +0000
Date:   Thu, 21 Oct 2021 03:31:53 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     akpm@linux-foundation.org
Cc:     mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject: Re: + restore-acct_reclaim_writeback-for-folio.patch added to -mm
 tree
Message-ID: <YXDRGSguCkAyE/Lk@casper.infradead.org>
References: <20211021010842.rf7R8AF9I%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021010842.rf7R8AF9I%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Oct 20, 2021 at 06:08:42PM -0700, akpm@linux-foundation.org wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: restore-acct_reclaim_writeback-for-folio
> 
> Make Mel's "mm/vmscan: throttle reclaim and compaction when too may pages
> are isolated" work for folio changes.

Mmm.  acct_reclaim_writeback() is going to need to be converted to
folios -- it accounts a page as a single page instead of as however
many pages it contains.

This patch makes sense to apply, so this is just a note that there's
a fuller fixup to come later.

> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/filemap.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/mm/filemap.c~restore-acct_reclaim_writeback-for-folio
> +++ a/mm/filemap.c
> @@ -1600,6 +1600,7 @@ void folio_end_writeback(struct folio *f
>  
>  	smp_mb__after_atomic();
>  	folio_wake(folio, PG_writeback);
> +	acct_reclaim_writeback(folio_page(folio, 0));
>  	folio_put(folio);
>  }
>  EXPORT_SYMBOL(folio_end_writeback);
> _
> 
> Patches currently in -mm which might be from akpm@linux-foundation.org are
> 
> kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
> mm.patch
> memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes.patch
> mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix.patch
> mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2.patch
> mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
> procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
> ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
> revert-acct_reclaim_writeback-for-next.patch
> linux-next-rejects.patch
> restore-acct_reclaim_writeback-for-folio.patch
> mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
> kernel-forkc-export-kernel_thread-to-modules.patch
> 

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4DD4C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 21:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF57260ED4
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 21:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhKEVMG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 17:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbhKEVMF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 Nov 2021 17:12:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9CDC061570
        for <mm-commits@vger.kernel.org>; Fri,  5 Nov 2021 14:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IgvaR9WLH5C+GC6rX62zzro+YvA1rBRh7mO0dhPBk5Q=; b=Qxzuqp8dxpGywRl17f5hdEFB2z
        Y22OKuY616E4vpwnabObw30yEKgwZnP7aQxaoAJz9u/3Ooj/fUpi/qEgJKIKGykL7TlTeCyeRfzZW
        7S9b+F3stqe0luJf9jzNDclujQJqxxBMGQnXNXHZRB/le5iiCSxKhg2H+BCbLSIYhO+wkMsjmKyqF
        dFgjo9CzwFBPt+RygWXr4rXVXpSlkG/nLl+ZAwAtvUf4LUltVSFKj30Lmv1/DgDurfiT4ibjA5rzT
        t9gKNltReQivtz0ZlwfdiXErJ8ogR++pRiOmvTxbFfQBt43QaGNKkO1b4lwpy3LABbm/24sLFBzyF
        xCa8UaSQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mj6M2-006pTm-9N; Fri, 05 Nov 2021 21:03:13 +0000
Date:   Fri, 5 Nov 2021 21:02:30 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     adilger.kernel@dilger.ca, corbet@lwn.net, david@fromorbit.com,
        djwong@kernel.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, neilb@suse.de, riel@surriel.com,
        torvalds@linux-foundation.org, tytso@mit.edu, vbabka@suse.cz
Subject: Re: [patch 149/262] mm/vmscan: throttle reclaim until some writeback
 completes if congested
Message-ID: <YYWb5jTLkNRUI6ea@casper.infradead.org>
References: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
 <20211105204225.iIh99P9cn%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211105204225.iIh99P9cn%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Nov 05, 2021 at 01:42:25PM -0700, Andrew Morton wrote:
> --- a/mm/filemap.c~mm-vmscan-throttle-reclaim-until-some-writeback-completes-if-congested
> +++ a/mm/filemap.c
> @@ -1612,6 +1612,7 @@ void end_page_writeback(struct page *pag
>  
>  	smp_mb__after_atomic();
>  	wake_up_page(page, PG_writeback);
> +	acct_reclaim_writeback(page);
>  	put_page(page);
>  }
>  EXPORT_SYMBOL(end_page_writeback);

hmm?  I think you based on some older version of Linus' tree that didn't
have folios.  This fixup patch was against an older fixup patch that you did, 
but maybe it's enough for Linus to apply ...

diff --git a/mm/filemap.c b/mm/filemap.c
index 6844c9816a86..daa0e23a6ee6 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1607,7 +1607,7 @@ void folio_end_writeback(struct folio *folio)
 
 	smp_mb__after_atomic();
 	folio_wake(folio, PG_writeback);
-	acct_reclaim_writeback(folio_page(folio, 0));
+	acct_reclaim_writeback(folio);
 	folio_put(folio);
 }
 EXPORT_SYMBOL(folio_end_writeback);
diff --git a/mm/internal.h b/mm/internal.h
index 632c55c5a075..3b79a5c9427a 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -41,15 +41,15 @@ static inline void *folio_raw_mapping(struct folio *folio)
 	return (void *)(mapping & ~PAGE_MAPPING_FLAGS);
 }
 
-void __acct_reclaim_writeback(pg_data_t *pgdat, struct page *page,
+void __acct_reclaim_writeback(pg_data_t *pgdat, struct folio *folio,
 						int nr_throttled);
-static inline void acct_reclaim_writeback(struct page *page)
+static inline void acct_reclaim_writeback(struct folio *folio)
 {
-	pg_data_t *pgdat = page_pgdat(page);
+	pg_data_t *pgdat = folio_pgdat(folio);
 	int nr_throttled = atomic_read(&pgdat->nr_writeback_throttled);
 
 	if (nr_throttled)
-		__acct_reclaim_writeback(pgdat, page, nr_throttled);
+		__acct_reclaim_writeback(pgdat, folio, nr_throttled);
 }
 
 static inline void wake_throttle_isolated(pg_data_t *pgdat)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 59c07ee4220d..fb9584641ac7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1085,12 +1085,12 @@ void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason)
  * pages to clean. If enough pages have been cleaned since throttling
  * started then wakeup the throttled tasks.
  */
-void __acct_reclaim_writeback(pg_data_t *pgdat, struct page *page,
+void __acct_reclaim_writeback(pg_data_t *pgdat, struct folio *folio,
 							int nr_throttled)
 {
 	unsigned long nr_written;
 
-	inc_node_page_state(page, NR_THROTTLED_WRITTEN);
+	node_stat_add_folio(folio, NR_THROTTLED_WRITTEN);
 
 	/*
 	 * This is an inaccurate read as the per-cpu deltas may not


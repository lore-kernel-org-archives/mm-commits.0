Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC70C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  1 Nov 2021 13:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A3C860FE8
	for <mm-commits@archiver.kernel.org>; Mon,  1 Nov 2021 13:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbhKANRl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Nov 2021 09:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbhKANRk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 1 Nov 2021 09:17:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F33C061714
        for <mm-commits@vger.kernel.org>; Mon,  1 Nov 2021 06:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7cHZeUB2yfVcEcxc2RHeW8/e69+DBqCV3vrJS4ynlp0=; b=nhZpWx/Udw2RJmoiG2E6ejFI81
        rvQni5rDnE5RrdVEmhc1ziQr3Uf6syYE1lhkvQ7jgmgBP1m/TCE7cPtb0CWJnt2MLebA185EP33Zt
        CLQGnD5yjE9ratIZD1v4I+Ppi50LK2zpb8wxIn5BmJqIRb8RsJPTOxU9pOrBYzRcNKd4Li+lf76wx
        CmlO74xiGC9WJRRqPfZDskkNS0UWVT6OLXWKRklCmDxliVHKlR8IYq45a9Kl8PBVLX1me9z3BiwMb
        VOW+VyCL5mYHe3J76z/6IlJicbnuUyC/E3wrPpdVzAyw1L5t0+xXHJe/N7JSaw90XQiQMHp1EboTa
        hW3iSZYA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mhX7M-003mj8-K7; Mon, 01 Nov 2021 13:13:27 +0000
Date:   Mon, 1 Nov 2021 13:12:52 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     akpm@linux-foundation.org
Cc:     mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject: Re: + restore-acct_reclaim_writeback-for-folio.patch added to -mm
 tree
Message-ID: <YX/n1Nj1df6JfWLw@casper.infradead.org>
References: <20211021010842.rf7R8AF9I%akpm@linux-foundation.org>
 <YXDRGSguCkAyE/Lk@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXDRGSguCkAyE/Lk@casper.infradead.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Oct 21, 2021 at 03:33:16AM +0100, Matthew Wilcox wrote:
> On Wed, Oct 20, 2021 at 06:08:42PM -0700, akpm@linux-foundation.org wrote:
> > From: Andrew Morton <akpm@linux-foundation.org>
> > Subject: restore-acct_reclaim_writeback-for-folio
> > 
> > Make Mel's "mm/vmscan: throttle reclaim and compaction when too may pages
> > are isolated" work for folio changes.
> 
> Mmm.  acct_reclaim_writeback() is going to need to be converted to
> folios -- it accounts a page as a single page instead of as however
> many pages it contains.
> 
> This patch makes sense to apply, so this is just a note that there's
> a fuller fixup to come later.

Later seems to be now.  This patch compiles.  The only non-mechanical
change in here is changing inc_node_page_state() to
node_stat_add_folio() which accounts the number of pages in the folio
instead of 1.

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

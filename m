Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 421E9C43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0140522201
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633088;
	bh=bX7VzBOzh53KeWxHAEHq2ingEbvqR0h7IECo0hgmsos=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=aQNFB67T6UKzTF4kj6RayWhQEpziuxZkV2QL9shktQ985uALQV3SgYOhD/iwWcaD8
	 g/NxuWE+5oRWlVg8IiIcCqtxMMIZbw6jFEfeRrF866AmwON5EYl2ZZorE/dRuvYHyq
	 BQK1OgitSAS9tCZmjpX2U8v0prwIxYhUUFgJDN4Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730151AbgJMXv1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730421AbgJMXv0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:51:26 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32E4D21D7A;
        Tue, 13 Oct 2020 23:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633085;
        bh=bX7VzBOzh53KeWxHAEHq2ingEbvqR0h7IECo0hgmsos=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rmOq18sL0cdiwXH/LXHVJt6eS1o6gn3hfwfA/lmWGeC4syeGdzAxletgmIkidPaNX
         QpBXy+Nt26OjYY9ZHquXj20zQOCtO12Tc6klOFxzlwtkbclqFQ8pbYZhA0PoBXqBpW
         2YjpaRER7DXcVYJlRVYN8o/VxEbt7EokLValB5vA=
Date:   Tue, 13 Oct 2020 16:51:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, cai@redhat.com,
        chris@chris-wilson.co.uk, hannes@cmpxchg.org, hughd@google.com,
        jani.nikula@linux.intel.com, linux-mm@kvack.org,
        matthew.auld@intel.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org, ying.huang@intel.com
Subject:  [patch 056/181] mm: optimise madvise WILLNEED
Message-ID: <20201013235124.9efI4nvew%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: optimise madvise WILLNEED

Instead of calling find_get_entry() for every page index, use an XArray
iterator to skip over NULL entries, and avoid calling get_page(),
because we only want the swap entries.

[willy@infradead.org: fix LTP soft lockups]
  Link: https://lkml.kernel.org/r/20200914165032.GS6583@casper.infradead.org
Link: https://lkml.kernel.org/r/20200910183318.20139-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Qian Cai <cai@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/mm/madvise.c~mm-optimise-madvise-willneed
+++ a/mm/madvise.c
@@ -224,25 +224,28 @@ static void force_shm_swapin_readahead(s
 		unsigned long start, unsigned long end,
 		struct address_space *mapping)
 {
-	pgoff_t index;
+	XA_STATE(xas, &mapping->i_pages, linear_page_index(vma, start));
+	pgoff_t end_index = end / PAGE_SIZE;
 	struct page *page;
-	swp_entry_t swap;
 
-	for (; start < end; start += PAGE_SIZE) {
-		index = ((start - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
+	rcu_read_lock();
+	xas_for_each(&xas, page, end_index) {
+		swp_entry_t swap;
 
-		page = find_get_entry(mapping, index);
-		if (!xa_is_value(page)) {
-			if (page)
-				put_page(page);
+		if (!xa_is_value(page))
 			continue;
-		}
+		xas_pause(&xas);
+		rcu_read_unlock();
+
 		swap = radix_to_swp_entry(page);
 		page = read_swap_cache_async(swap, GFP_HIGHUSER_MOVABLE,
 							NULL, 0, false);
 		if (page)
 			put_page(page);
+
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 
 	lru_add_drain();	/* Push any new pages onto the LRU now */
 }
_

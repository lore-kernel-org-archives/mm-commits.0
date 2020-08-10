Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A545C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3E482065D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027196;
	bh=pGd2EdoCNhsipzIOmnjUp+iSQudg03wdTDA3ach/zgI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=fyOyZag2V21xv+YnUcw6vNYI7fHpOqwTPq6jfNZNCE6/rZcPykL66+pcvv9Hnax5K
	 DdPpD4mzRC8NqEGtanjOM8gWf3IDerdOXUkAeRncwVbFGFLBI+NeEqqo0kIWLTyv1y
	 gV/e4wIKla+R0MS+EzH7g7zpuqp4nUtcvbArpDbw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgHJCjz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:39:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgHJCjz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:39:55 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EE21206C3;
        Mon, 10 Aug 2020 02:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027194;
        bh=pGd2EdoCNhsipzIOmnjUp+iSQudg03wdTDA3ach/zgI=;
        h=Date:From:To:Subject:From;
        b=GKKPfZ27ElQDZV4bbm7HB1iNjJJ6E5TN2JkFGMjQM4jDMU3/7e0iSwknpwGX/ETbj
         BF9vA47XPsJ/xaNAQKwVYJfEuAM16mFS8nNXUFib9uldfNYETMKjd/GBV9YYsBGkP9
         MCnhhLbt5pU2NaAhK4Ae0r593MNaDnKsZd7SU6TE=
Date:   Sun, 09 Aug 2020 19:39:53 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, hannes@cmpxchg.org, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        pankaj.gupta.linux@gmail.com, richard.weiyang@gmail.com,
        rppt@linux.ibm.com, ying.huang@intel.com
Subject:  [merged] mm-page_alloc-drop-nr_free_pagecache_pages.patch
 removed from -mm tree
Message-ID: <20200810023953.zUHBYvb9-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: remove nr_free_pagecache_pages()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-drop-nr_free_pagecache_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: remove nr_free_pagecache_pages()

nr_free_pagecache_pages() isn't used outside page_alloc.c anymore - and
the name does not really help to understand what's going on.  Let's
open-code it instead and add a comment.

Link: http://lkml.kernel.org/r/20200619132410.23859-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 -
 mm/page_alloc.c      |   16 ++--------------
 2 files changed, 2 insertions(+), 15 deletions(-)

--- a/include/linux/swap.h~mm-page_alloc-drop-nr_free_pagecache_pages
+++ a/include/linux/swap.h
@@ -328,7 +328,6 @@ void workingset_update_node(struct xa_no
 /* linux/mm/page_alloc.c */
 extern unsigned long totalreserve_pages;
 extern unsigned long nr_free_buffer_pages(void);
-extern unsigned long nr_free_pagecache_pages(void);
 
 /* Definition of global_zone_page_state not available yet */
 #define nr_free_pages() global_zone_page_state(NR_FREE_PAGES)
--- a/mm/page_alloc.c~mm-page_alloc-drop-nr_free_pagecache_pages
+++ a/mm/page_alloc.c
@@ -5186,19 +5186,6 @@ unsigned long nr_free_buffer_pages(void)
 }
 EXPORT_SYMBOL_GPL(nr_free_buffer_pages);
 
-/**
- * nr_free_pagecache_pages - count number of pages beyond high watermark
- *
- * nr_free_pagecache_pages() counts the number of pages which are beyond the
- * high watermark within all zones.
- *
- * Return: number of pages beyond high watermark within all zones.
- */
-unsigned long nr_free_pagecache_pages(void)
-{
-	return nr_free_zone_pages(gfp_zone(GFP_HIGHUSER_MOVABLE));
-}
-
 static inline void show_node(struct zone *zone)
 {
 	if (IS_ENABLED(CONFIG_NUMA))
@@ -5920,7 +5907,8 @@ void __ref build_all_zonelists(pg_data_t
 		__build_all_zonelists(pgdat);
 		/* cpuset refresh routine should be here */
 	}
-	vm_total_pages = nr_free_pagecache_pages();
+	/* Get the number of free pages beyond high watermark in all zones. */
+	vm_total_pages = nr_free_zone_pages(gfp_zone(GFP_HIGHUSER_MOVABLE));
 	/*
 	 * Disable grouping by mobility if the number of pages in the
 	 * system is too low to allow the mechanism to work. It would be
_

Patches currently in -mm which might be from david@redhat.com are



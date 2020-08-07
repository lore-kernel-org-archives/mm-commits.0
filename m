Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F80C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF0EB22CAE
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781534;
	bh=kBT3HrzxcSqcOQ9dXEPzDEPS9SlFm5PAzFFM+x3Qp80=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=gjCRutOcaCqZBe2WWpus1+L7qHj57BeBiKDEKrgB1KkzbNp+z0EUd/vl94B6BRLjJ
	 VTbkys0Qp6n4wIL3eGhrfS8+jb7x18875mQso3wmpKQeA0YWfUrUl2FN33V3ZehQM0
	 XhCPl6s78FTsckfR6rFKiIS/u+K/Fw9vuJqyYh70=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgHGGZd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:25:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGGZd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:25:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7985B22CB3;
        Fri,  7 Aug 2020 06:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781532;
        bh=kBT3HrzxcSqcOQ9dXEPzDEPS9SlFm5PAzFFM+x3Qp80=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Iu2+ddhff3lty6ZVcg9sFoj/aH+2vbLkt/0q68Km2u/W7+efI1bph69lVgX/BSFth
         0IOgTfCliPob1ulyNbbzmMZ0XOTFMUqxV8bS4m/cBCfSmnCOsH/f3fOcdlid5t2bEI
         gxofuvRvPQlDA8OSOEDN3r6nqDCPuRvtTDXxRxFc=
Date:   Thu, 06 Aug 2020 23:25:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com,
        richard.weiyang@gmail.com, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, ying.huang@intel.com
Subject:  [patch 145/163] mm/page_alloc: remove
 nr_free_pagecache_pages()
Message-ID: <20200807062530.h-QH4wUWk%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

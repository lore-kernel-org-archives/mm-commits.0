Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2EACC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A77B22087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817691;
	bh=L85J8kJcojIRYYYkiAe8BwD095i7Fq9ai0OBFpZMVn8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=qr9vacVBqDL6805bbhmkKOc8UtHuqQkEaMUnhT35xA38hZxAlqAVW4aGgilMC6cnP
	 WsuFyxsiDXqiZE02TxsvU1E+GDrpdm/m9iC3xPkTWYeRFqcDCzUs7858DiZwTSYgqA
	 6D/EvjWfzRp/bzlFd1TinGSTAZkBKEm2m7oxWX3M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732513AbgJPDIL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:08:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbgJPDIL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:08:11 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E90E820789;
        Fri, 16 Oct 2020 03:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817688;
        bh=L85J8kJcojIRYYYkiAe8BwD095i7Fq9ai0OBFpZMVn8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qiVbHiqpiVyYtJOGRYuSpippZ9CTxbzM0gVbn0V2e07Wz7I4794VVtEP8wqaeAlQW
         7Z8th2G3Y8hW7+lYeEolSNMrm83vR1UK20i1ywVqLDyaPxjXIx7PtSSKQ+L2MGW70c
         9aw9DnOdZbFOc8rDSXOmZLBy6T2GyIW9fKZGlwtQ=
Date:   Thu, 15 Oct 2020 20:08:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, charante@codeaurora.org,
        dan.j.williams@intel.com, david@redhat.com, fenghua.yu@intel.com,
        logang@deltatee.com, mgorman@suse.de, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, tony.luck@intel.com,
        torvalds@linux-foundation.org, walken@google.com,
        willy@infradead.org
Subject:  [patch 064/156] mm/page_isolation: simplify return value
 of start_isolate_page_range()
Message-ID: <20201016030807.FvZihXD9o%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/page_isolation: simplify return value of start_isolate_page_range()

Callers no longer need the number of isolated pageblocks.  Let's simplify.

Link: https://lkml.kernel.org/r/20200819175957.28465-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Charan Teja Reddy <charante@codeaurora.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 mm/page_alloc.c     |    2 +-
 mm/page_isolation.c |    7 ++-----
 3 files changed, 4 insertions(+), 7 deletions(-)

--- a/mm/memory_hotplug.c~mm-page_isolation-simplify-return-value-of-start_isolate_page_range
+++ a/mm/memory_hotplug.c
@@ -1514,7 +1514,7 @@ int __ref offline_pages(unsigned long st
 	ret = start_isolate_page_range(start_pfn, end_pfn,
 				       MIGRATE_MOVABLE,
 				       MEMORY_OFFLINE | REPORT_FAILURE);
-	if (ret < 0) {
+	if (ret) {
 		reason = "failure to isolate range";
 		goto failed_removal;
 	}
--- a/mm/page_alloc.c~mm-page_isolation-simplify-return-value-of-start_isolate_page_range
+++ a/mm/page_alloc.c
@@ -8468,7 +8468,7 @@ int alloc_contig_range(unsigned long sta
 
 	ret = start_isolate_page_range(pfn_max_align_down(start),
 				       pfn_max_align_up(end), migratetype, 0);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	/*
--- a/mm/page_isolation.c~mm-page_isolation-simplify-return-value-of-start_isolate_page_range
+++ a/mm/page_isolation.c
@@ -173,8 +173,7 @@ __first_valid_page(unsigned long pfn, un
  * (e.g. __offline_pages will need to call it after check for isolated range for
  * a next retry).
  *
- * Return: the number of isolated pageblocks on success and -EBUSY if any part
- * of range cannot be isolated.
+ * Return: 0 on success and -EBUSY if any part of range cannot be isolated.
  */
 int start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
 			     unsigned migratetype, int flags)
@@ -182,7 +181,6 @@ int start_isolate_page_range(unsigned lo
 	unsigned long pfn;
 	unsigned long undo_pfn;
 	struct page *page;
-	int nr_isolate_pageblock = 0;
 
 	BUG_ON(!IS_ALIGNED(start_pfn, pageblock_nr_pages));
 	BUG_ON(!IS_ALIGNED(end_pfn, pageblock_nr_pages));
@@ -196,10 +194,9 @@ int start_isolate_page_range(unsigned lo
 				undo_pfn = pfn;
 				goto undo;
 			}
-			nr_isolate_pageblock++;
 		}
 	}
-	return nr_isolate_pageblock;
+	return 0;
 undo:
 	for (pfn = start_pfn;
 	     pfn < undo_pfn;
_

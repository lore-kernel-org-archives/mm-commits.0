Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 851B3C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FFAC2083B
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597861250;
	bh=hAbRhFvhUilF8QezSukR3eEY7pkan//prpR0a5yfrSc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ZBP/QebMwvhAAfQ1cGAP86wdeqjIhDjlQ47xLJJdALmcdd2Q1tP79Uy+T6+gAto6S
	 atw7JBO8HFtek1hFiSv/3CBvIYriNkaE+jdoksKj79rKv0A2CCpLun7GOoZHpZGJ6D
	 bHdk0DZY3e+HICDZOb0kiTCgY4laC6d699VnpdDg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgHSSUt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 14:20:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgHSSUt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 14:20:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EB0320786;
        Wed, 19 Aug 2020 18:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597861248;
        bh=hAbRhFvhUilF8QezSukR3eEY7pkan//prpR0a5yfrSc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mTAM+b9iRz8PNzxAYfMN/evG67oCxhOtDC1yRDPow6nWcs1c1+9LdfQlZs3lN0TKY
         pJ/XtV0WJ92cs1jXny4yOAbZ7YgPAZl7XpdApAhgjIz65GX6oTCZuxFxwe4wKoLFK3
         TVf8QqQO/x1fGLsxfCeABwZtzp/SFPnjq8Okh3hI=
Date:   Wed, 19 Aug 2020 11:20:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     bhe@redhat.com, charante@codeaurora.org, dan.j.williams@intel.com,
        david@redhat.com, fenghua.yu@intel.com, logang@deltatee.com,
        mgorman@suse.de, mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, tony.luck@intel.com, walken@google.com,
        willy@infradead.org
Subject:  +
 mm-memory_hotplug-drop-nr_isolate_pageblock-in-offline_pages.patch added to
 -mm tree
Message-ID: <20200819182047.YMBm3Wndp%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: drop nr_isolate_pageblock in offline_pages()
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-drop-nr_isolate_pageblock-in-offline_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-drop-nr_isolate_pageblock-in-offline_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-drop-nr_isolate_pageblock-in-offline_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: drop nr_isolate_pageblock in offline_pages()

We make sure that we cannot have any memory holes right at the beginning
of offline_pages() and we only support to online/offline full sections. 
Both, sections and pageblocks are a power of two in size, and sections
always span full pageblocks.

We can directly calculate the number of isolated pageblocks from nr_pages.

Link: https://lkml.kernel.org/r/20200819175957.28465-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
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

 mm/memory_hotplug.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-drop-nr_isolate_pageblock-in-offline_pages
+++ a/mm/memory_hotplug.c
@@ -1462,10 +1462,10 @@ int __ref offline_pages(unsigned long st
 {
 	const unsigned long end_pfn = start_pfn + nr_pages;
 	unsigned long pfn, system_ram_pages = 0;
-	int ret, node, nr_isolate_pageblock;
 	unsigned long flags;
 	struct zone *zone;
 	struct memory_notify arg;
+	int ret, node;
 	char *reason;
 
 	/* We can only offline full sections (e.g., SECTION_IS_ONLINE) */
@@ -1509,7 +1509,6 @@ int __ref offline_pages(unsigned long st
 		reason = "failure to isolate range";
 		goto failed_removal;
 	}
-	nr_isolate_pageblock = ret;
 
 	arg.start_pfn = start_pfn;
 	arg.nr_pages = nr_pages;
@@ -1571,7 +1570,7 @@ int __ref offline_pages(unsigned long st
 	 * pageblocks zone counter here.
 	 */
 	spin_lock_irqsave(&zone->lock, flags);
-	zone->nr_isolate_pageblock -= nr_isolate_pageblock;
+	zone->nr_isolate_pageblock -= nr_pages / pageblock_nr_pages;
 	spin_unlock_irqrestore(&zone->lock, flags);
 
 	/* removal success */
_

Patches currently in -mm which might be from david@redhat.com are

mm-page_alloc-tweak-comments-in-has_unmovable_pages.patch
mm-page_isolation-exit-early-when-pageblock-is-isolated-in-set_migratetype_isolate.patch
mm-page_isolation-drop-warn_on_once-in-set_migratetype_isolate.patch
mm-page_isolation-cleanup-set_migratetype_isolate.patch
virtio-mem-dont-special-case-zone_movable.patch
mm-document-semantics-of-zone_movable.patch
mm-memory_hotplug-inline-__offline_pages-into-offline_pages.patch
mm-memory_hotplug-enforce-section-granularity-when-onlining-offlining.patch
mm-memory_hotplug-simplify-page-offlining.patch
mm-page_alloc-simplify-__offline_isolated_pages.patch
mm-memory_hotplug-drop-nr_isolate_pageblock-in-offline_pages.patch
mm-page_isolation-simplify-return-value-of-start_isolate_page_range.patch
mm-memory_hotplug-simplify-page-onlining.patch
mm-page_alloc-drop-stale-pageblock-comment-in-memmap_init_zone.patch
mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone.patch
mm-memory_hotplug-mark-pageblocks-migrate_isolate-while-onlining-memory.patch


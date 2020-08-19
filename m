Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E7B4C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03ED320786
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597861254;
	bh=ux4fs5ABKmD3AVJdCIJKdCpwlmiVFs6XuHRgRsQW3P8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=LiMpaNHf1UXKHDrw+kjJ393yeWlVuJbY5n5stz2HitIYw6qtcVfJk5g4wUj6th4qb
	 rSwwrnn6MJ3155nrsP3kFYVgsBj+bbQMU3Q5bdqrhJlyY3tD1c5g5C2BefBDoIeV8M
	 RyCTgkVE0t6OZOh7mISsdeuW2IU8JJgemFvIuBCM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgHSSUx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 14:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgHSSUw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 14:20:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2146420758;
        Wed, 19 Aug 2020 18:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597861251;
        bh=ux4fs5ABKmD3AVJdCIJKdCpwlmiVFs6XuHRgRsQW3P8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hoAK4+k/2rB0EYcA0rWHeb4qF82uwYM+4lGDPBMPynGCJfh1jyY3pGiIlyaeOBBX5
         bTgBoXmYeJ+tH0tXjwE8qQsubIpqQSyYuEWA5AAvAttvpRs3qLgQVJQNCxH7g4mEkI
         wHwaHpQ9YOOGF16D3xhJkngu6827ZpQyWkDykZjk=
Date:   Wed, 19 Aug 2020 11:20:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     bhe@redhat.com, charante@codeaurora.org, dan.j.williams@intel.com,
        david@redhat.com, fenghua.yu@intel.com, logang@deltatee.com,
        mgorman@suse.de, mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, tony.luck@intel.com, walken@google.com,
        willy@infradead.org
Subject:  +
 mm-page_isolation-simplify-return-value-of-start_isolate_page_range.patch
 added to -mm tree
Message-ID: <20200819182050.k5nVhUPkW%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: simplify return value of start_isolate_page_range()
has been added to the -mm tree.  Its filename is
     mm-page_isolation-simplify-return-value-of-start_isolate_page_range.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_isolation-simplify-return-value-of-start_isolate_page_range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_isolation-simplify-return-value-of-start_isolate_page_range.patch

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
Subject: mm/page_isolation: simplify return value of start_isolate_page_range()

Callers no longer need the number of isolated pageblocks.  Let's simplify.

Link: https://lkml.kernel.org/r/20200819175957.28465-7-david@redhat.com
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

 mm/memory_hotplug.c |    2 +-
 mm/page_alloc.c     |    2 +-
 mm/page_isolation.c |    7 ++-----
 3 files changed, 4 insertions(+), 7 deletions(-)

--- a/mm/memory_hotplug.c~mm-page_isolation-simplify-return-value-of-start_isolate_page_range
+++ a/mm/memory_hotplug.c
@@ -1505,7 +1505,7 @@ int __ref offline_pages(unsigned long st
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
@@ -8449,7 +8449,7 @@ int alloc_contig_range(unsigned long sta
 
 	ret = start_isolate_page_range(pfn_max_align_down(start),
 				       pfn_max_align_up(end), migratetype, 0);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	/*
--- a/mm/page_isolation.c~mm-page_isolation-simplify-return-value-of-start_isolate_page_range
+++ a/mm/page_isolation.c
@@ -165,8 +165,7 @@ __first_valid_page(unsigned long pfn, un
  * pageblocks we may have modified and return -EBUSY to caller. This
  * prevents two threads from simultaneously working on overlapping ranges.
  *
- * Return: the number of isolated pageblocks on success and -EBUSY if any part
- * of range cannot be isolated.
+ * Return: 0 on success and -EBUSY if any part of range cannot be isolated.
  */
 int start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
 			     unsigned migratetype, int flags)
@@ -174,7 +173,6 @@ int start_isolate_page_range(unsigned lo
 	unsigned long pfn;
 	unsigned long undo_pfn;
 	struct page *page;
-	int nr_isolate_pageblock = 0;
 
 	BUG_ON(!IS_ALIGNED(start_pfn, pageblock_nr_pages));
 	BUG_ON(!IS_ALIGNED(end_pfn, pageblock_nr_pages));
@@ -188,10 +186,9 @@ int start_isolate_page_range(unsigned lo
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


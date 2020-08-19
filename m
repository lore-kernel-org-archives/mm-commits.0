Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C9CCC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F31FD20786
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597861261;
	bh=2o/p0JOSo7VyHHDQ14zEvkzfkcakIuFo9IlUKkWx9IY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=C7DRX9gE2OhtftTwkYXOiIo+7hSzWN8FAYzrUSzOaS5y3AGSJKB1Dtu3kIpzmZzPA
	 T/FB6Jz0Qk0sDiEfKUCwc/6dgrApcXkOPR2Y0PlOkPTpZKBy/bexX2ip5OGSnBgM38
	 mb2NKS6hwfo/kdTDDgmVN11ey7CULpFKGrr9P6/g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgHSSVA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 14:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgHSSU7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 14:20:59 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 074E520758;
        Wed, 19 Aug 2020 18:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597861258;
        bh=2o/p0JOSo7VyHHDQ14zEvkzfkcakIuFo9IlUKkWx9IY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ldtsjtKuHLA0CP7NT/gzpQiJFp8HfUbpON2Sr58TZ1kyqWxt3r/e50dyrNy+S7X93
         92vWzXYegBLsrnbaMRru5vUNjIt1kHm0cqulVCQBmK6KY0mbrm+Qs9jQ84CJQ0zDoh
         RGjsdHZ8RWVusHuVqMlbOi6ZkCpbPxlVWIYejPH4=
Date:   Wed, 19 Aug 2020 11:20:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     bhe@redhat.com, charante@codeaurora.org, dan.j.williams@intel.com,
        david@redhat.com, fenghua.yu@intel.com, logang@deltatee.com,
        mgorman@suse.de, mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, tony.luck@intel.com, walken@google.com,
        willy@infradead.org
Subject:  +
 mm-page_alloc-drop-stale-pageblock-comment-in-memmap_init_zone.patch added
 to -mm tree
Message-ID: <20200819182057.LyWid7clS%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: drop stale pageblock comment in memmap_init_zone*()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-drop-stale-pageblock-comment-in-memmap_init_zone.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-drop-stale-pageblock-comment-in-memmap_init_zone.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-drop-stale-pageblock-comment-in-memmap_init_zone.patch

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
Subject: mm/page_alloc: drop stale pageblock comment in memmap_init_zone*()

Commit ac5d2539b238 ("mm: meminit: reduce number of times pageblocks are
set during struct page init") moved the actual zone range check, leaving
only the alignment check for pageblocks.

Let's drop the stale comment and make the pageblock check easier to read.

Link: https://lkml.kernel.org/r/20200819175957.28465-9-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Charan Teja Reddy <charante@codeaurora.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-drop-stale-pageblock-comment-in-memmap_init_zone
+++ a/mm/page_alloc.c
@@ -6025,13 +6025,8 @@ void __meminit memmap_init_zone(unsigned
 		 * to reserve their blocks rather than leaking throughout
 		 * the address space during boot when many long-lived
 		 * kernel allocations are made.
-		 *
-		 * bitmap is created for zone's valid pfn range. but memmap
-		 * can be created for invalid pages (for alignment)
-		 * check here not to call set_pageblock_migratetype() against
-		 * pfn out of zone.
 		 */
-		if (!(pfn & (pageblock_nr_pages - 1))) {
+		if (IS_ALIGNED(pfn, pageblock_nr_pages)) {
 			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 			cond_resched();
 		}
@@ -6094,15 +6089,10 @@ void __ref memmap_init_zone_device(struc
 		 * the address space during boot when many long-lived
 		 * kernel allocations are made.
 		 *
-		 * bitmap is created for zone's valid pfn range. but memmap
-		 * can be created for invalid pages (for alignment)
-		 * check here not to call set_pageblock_migratetype() against
-		 * pfn out of zone.
-		 *
 		 * Please note that MEMMAP_HOTPLUG path doesn't clear memmap
 		 * because this is done early in section_activate()
 		 */
-		if (!(pfn & (pageblock_nr_pages - 1))) {
+		if (IS_ALIGNED(pfn, pageblock_nr_pages)) {
 			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 			cond_resched();
 		}
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


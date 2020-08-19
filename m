Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E9D8C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 556E320786
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597861238;
	bh=QLSAcN+8g0vhhCeONqM0yGQ1fjJCayoNDebTF5dCwgk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=gjZ3ly6LNMonJ+Xf/QrQ5SkkHINupWY6KWb6QeeucROwezc2jxuEP8d6d/Jf1lId+
	 HSPDc/8WP3Go8YXXVW23pt4OQNenHhexzjbehChHJRgNJe43/pvn4eVo6Y7Damm/YZ
	 sdjloIG0dg7LrXpdk44tnobhFbP7ppAsUxPnWMp8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgHSSUi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 14:20:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgHSSUh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 14:20:37 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C79020758;
        Wed, 19 Aug 2020 18:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597861236;
        bh=QLSAcN+8g0vhhCeONqM0yGQ1fjJCayoNDebTF5dCwgk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mlleyX6i2useZMQyWk5K3oeTQ+Sf9nqtfbBBuIucRUnL8ZZK4zRmemc4tAK/pRcmE
         A/kHh1d609kXQEH7qm3l88ta3hNedvvL75ns/7dNu8eKxyWDvm4Me8lcSLTH5vCJtO
         lTVl5NlJuNWnQGGnJuRapegZ4vT4PdS2J1uwlWu4=
Date:   Wed, 19 Aug 2020 11:20:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     bhe@redhat.com, charante@codeaurora.org, dan.j.williams@intel.com,
        david@redhat.com, fenghua.yu@intel.com, logang@deltatee.com,
        mgorman@suse.de, mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, tony.luck@intel.com, walken@google.com,
        willy@infradead.org
Subject:  +
 mm-memory_hotplug-inline-__offline_pages-into-offline_pages.patch added to
 -mm tree
Message-ID: <20200819182035.C-avZjgV2%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: inline __offline_pages() into offline_pages()
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-inline-__offline_pages-into-offline_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-inline-__offline_pages-into-offline_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-inline-__offline_pages-into-offline_pages.patch

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
Subject: mm/memory_hotplug: inline __offline_pages() into offline_pages()

Patch series "mm/memory_hotplug: online_pages()/offline_pages() cleanups", v2.

These are a bunch of cleanups for online_pages()/offline_pages() and
related code, mostly getting rid of memory hole handling that is no longer
necessary.  There is only a single walk_system_ram_range() call left in
offline_pages(), to make sure we don't have any memory holes.  I had some
of these patches lying around for a longer time but didn't have time to
polish them.

In addition, the last patch marks all pageblocks of memory to get onlined
MIGRATE_ISOLATE, so pages that have just been exposed to the buddy cannot
get allocated before onlining is complete.  Once heavy lifting is done,
the pageblocks are set to MIGRATE_MOVABLE, such that allocations are
possible.

I played with DIMMs and virtio-mem on x86-64 and didn't spot any
surprises.  I verified that the numer of isolated pageblocks is correctly
handled when onlining/offlining.


This patch (of 10):

There is only a single user, offline_pages(). Let's inline, to make
it look more similar to online_pages().

Link: https://lkml.kernel.org/r/20200819175957.28465-1-david@redhat.com
Link: https://lkml.kernel.org/r/20200819175957.28465-2-david@redhat.com
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
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-inline-__offline_pages-into-offline_pages
+++ a/mm/memory_hotplug.c
@@ -1475,11 +1475,10 @@ static int count_system_ram_pages_cb(uns
 	return 0;
 }
 
-static int __ref __offline_pages(unsigned long start_pfn,
-		  unsigned long end_pfn)
+int __ref offline_pages(unsigned long start_pfn, unsigned long nr_pages)
 {
-	unsigned long pfn, nr_pages = 0;
-	unsigned long offlined_pages = 0;
+	const unsigned long end_pfn = start_pfn + nr_pages;
+	unsigned long pfn, system_ram_pages = 0, offlined_pages = 0;
 	int ret, node, nr_isolate_pageblock;
 	unsigned long flags;
 	struct zone *zone;
@@ -1496,9 +1495,9 @@ static int __ref __offline_pages(unsigne
 	 * memory holes PG_reserved, don't need pfn_valid() checks, and can
 	 * avoid using walk_system_ram_range() later.
 	 */
-	walk_system_ram_range(start_pfn, end_pfn - start_pfn, &nr_pages,
+	walk_system_ram_range(start_pfn, nr_pages, &system_ram_pages,
 			      count_system_ram_pages_cb);
-	if (nr_pages != end_pfn - start_pfn) {
+	if (system_ram_pages != nr_pages) {
 		ret = -EINVAL;
 		reason = "memory holes";
 		goto failed_removal;
@@ -1633,11 +1632,6 @@ failed_removal:
 	return ret;
 }
 
-int offline_pages(unsigned long start_pfn, unsigned long nr_pages)
-{
-	return __offline_pages(start_pfn, start_pfn + nr_pages);
-}
-
 static int check_memblock_offlined_cb(struct memory_block *mem, void *arg)
 {
 	int ret = !is_memblock_offlined(mem);
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


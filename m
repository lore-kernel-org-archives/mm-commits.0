Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 070B4C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:07:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A51AB2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817669;
	bh=x7cGOu+Io1/O7CmBCo0QJU33lh758XhqZ3o0n4Yf77A=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=fH1kfDmQXYrOs5kJ0GYsFABD57CbpNT4BvQ3UmY/OtIDkmXBraBsYNg8yOJB9pwkx
	 usQQLNYLslKM0J8G0dcExcKh/re9FcUAZQqNoIRhBH6o5etZcgKguPvN85viAVNg6C
	 oTOnLR+qIlopGXQpwWScPIJ3O82X+7TihfYn7Yx0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732532AbgJPDHt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:07:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbgJPDHt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:07:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29A5E20789;
        Fri, 16 Oct 2020 03:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817668;
        bh=x7cGOu+Io1/O7CmBCo0QJU33lh758XhqZ3o0n4Yf77A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uR08XcMIkpOux8pzYOBpcqiuBf5ChbgCfyDrgmRRy7DWnD+tihwyWYCQ040AuP7wG
         7C4VYOOStMgDw22VIigaGbDKgG1dQDC8nyf+NALjgz6JgIZRFBvZfa5SbjQhltDAAg
         rj+Z5MmkICYjeGTSvzNBFwkyZdYjDVE5S+wBQNAI=
Date:   Thu, 15 Oct 2020 20:07:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, charante@codeaurora.org,
        dan.j.williams@intel.com, david@redhat.com, fenghua.yu@intel.com,
        logang@deltatee.com, mgorman@suse.de, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, tony.luck@intel.com,
        torvalds@linux-foundation.org, walken@google.com,
        willy@infradead.org
Subject:  [patch 059/156] mm/memory_hotplug: inline
 __offline_pages() into offline_pages()
Message-ID: <20201016030746.cIcBLZTgY%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
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
@@ -1484,11 +1484,10 @@ static int count_system_ram_pages_cb(uns
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
@@ -1505,9 +1504,9 @@ static int __ref __offline_pages(unsigne
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
@@ -1656,11 +1655,6 @@ failed_removal:
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

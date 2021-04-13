Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1ADBC433ED
	for <mm-commits@archiver.kernel.org>; Tue, 13 Apr 2021 17:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 985B0611CE
	for <mm-commits@archiver.kernel.org>; Tue, 13 Apr 2021 17:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347304AbhDMRri (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:47:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347267AbhDMRrh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Apr 2021 13:47:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C3B461166;
        Tue, 13 Apr 2021 17:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618336037;
        bh=Vw7SCEf8mhobFSPdJETfl/DgFei4JNJbOzT23R+Tzrk=;
        h=Date:From:To:Subject:From;
        b=c9k79d2FYZQmtGVARkuxsUM1CbhEaP98towwsfXTnSimwLqaiByBGr71ikfreOyk8
         pH343RGVYjL30u/eILr54ELFDFqy3lrlwo8ovko1EkkDfCiue2wqf6jmhnRAA4ppbR
         7np5R+WM45u6uE0o3rnnP+CDzCJQGHVb9jvQKT38=
Date:   Tue, 13 Apr 2021 10:47:17 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, osalvador@suse.de,
        mst@redhat.com, minchan@kernel.org, mhocko@suse.com,
        david@redhat.com, alexander.h.duyck@linux.intel.com,
        mgorman@techsingularity.net
Subject:  +
 =?us-ascii?Q?mm-memory=5Fhotplug-make-unpopulated-zones-pcp-structures?=
 =?us-ascii?Q?-unreachable-during-hot-remove.patch?= added to -mm tree
Message-ID: <20210413174717.EuYXY%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: make unpopulated zones PCP structures unreachable during hot remove
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-make-unpopulated-zones-pcp-structures-unreachable-during-hot-remove.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-make-unpopulated-zones-pcp-structures-unreachable-during-hot-remove.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-make-unpopulated-zones-pcp-structures-unreachable-during-hot-remove.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/memory_hotplug: make unpopulated zones PCP structures unreachable during hot remove

zone_pcp_reset allegedly protects against a race with drain_pages using
local_irq_save but this is bogus.  local_irq_save only operates on the
local CPU.  If memory hotplug is running on CPU A and drain_pages is
running on CPU B, disabling IRQs on CPU A does not affect CPU B and offers
no protection.

This patch deletes IRQ disable/enable on the grounds that IRQs protect
nothing and assumes the existing hotplug paths guarantees the PCP cannot
be used after zone_pcp_enable().  That should be the case already because
all the pages have been freed and there is no page to put on the PCP
lists.

Link: https://lkml.kernel.org/r/20210412090346.GQ3697@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/page_alloc.c~mm-memory_hotplug-make-unpopulated-zones-pcp-structures-unreachable-during-hot-remove
+++ a/mm/page_alloc.c
@@ -9020,12 +9020,9 @@ void zone_pcp_enable(struct zone *zone)
 
 void zone_pcp_reset(struct zone *zone)
 {
-	unsigned long flags;
 	int cpu;
 	struct per_cpu_pageset *pset;
 
-	/* avoid races with drain_pages()  */
-	local_irq_save(flags);
 	if (zone->pageset != &boot_pageset) {
 		for_each_online_cpu(cpu) {
 			pset = per_cpu_ptr(zone->pageset, cpu);
@@ -9034,7 +9031,6 @@ void zone_pcp_reset(struct zone *zone)
 		free_percpu(zone->pageset);
 		zone->pageset = &boot_pageset;
 	}
-	local_irq_restore(flags);
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-rename-alloced-to-allocated.patch
mm-page_alloc-add-a-bulk-page-allocator.patch
mm-page_alloc-add-a-bulk-page-allocator-fix.patch
mm-page_alloc-add-a-bulk-page-allocator-fix-fix.patch
mm-page_alloc-add-a-bulk-page-allocator-fix-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator.patch
mm-memory_hotplug-make-unpopulated-zones-pcp-structures-unreachable-during-hot-remove.patch


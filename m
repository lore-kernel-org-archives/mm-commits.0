Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29FF4C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:20:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DEC220758
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597861242;
	bh=9DEite7y6x33vtmSjH+cun9gaTgTU1XZuwTgcFY13l8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Aodgl88oYldPaGbGUgcnrPxiCcSuNZ1/xJDZcnDTvxa+qVVUXw1jI8+PiELygZiWf
	 DQVR2XXtdsnblidQWCVnj2nW4+m37zs4QUEyp5VOG8AD524AbisYzx/hb+j52jI8Nc
	 KpMv4Xms66MYuzXfraluWoRYF6hXDEucbBtv8lRs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgHSSUl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 14:20:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgHSSUk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 14:20:40 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B4C62083B;
        Wed, 19 Aug 2020 18:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597861239;
        bh=9DEite7y6x33vtmSjH+cun9gaTgTU1XZuwTgcFY13l8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=I0DMN9BCVElvmc6rDqYio6rB5S1hgaqFPJPI7y+6PjlDwOESDPT/BOtquL7XAEgcS
         Q8eczUHLcI/JuZt8+WESvF1Fb+u2HfkjTgbt9lsP05lWJa8pphT2Rh2Y1xfJ474Vei
         VXh6A/5yhzM6mHQKElJzNhniiFAHRiG+Sc6tHLxw=
Date:   Wed, 19 Aug 2020 11:20:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     bhe@redhat.com, charante@codeaurora.org, dan.j.williams@intel.com,
        david@redhat.com, fenghua.yu@intel.com, logang@deltatee.com,
        mgorman@suse.de, mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, tony.luck@intel.com, walken@google.com,
        willy@infradead.org
Subject:  +
 mm-memory_hotplug-enforce-section-granularity-when-onlining-offlining.patch
 added to -mm tree
Message-ID: <20200819182038.IlytHwULx%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: enforce section granularity when onlining/offlining
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-enforce-section-granularity-when-onlining-offlining.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-enforce-section-granularity-when-onlining-offlining.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-enforce-section-granularity-when-onlining-offlining.patch

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
Subject: mm/memory_hotplug: enforce section granularity when onlining/offlining

Already two people (including me) tried to offline subsections, because
the function looks like it can deal with it.  But we really can only
online/offline full sections that are properly aligned (e.g., we can only
mark full sections online/offline via SECTION_IS_ONLINE).

Add a simple safety net to document the restriction now.  Current users
(core and powernv/memtrace) respect these restrictions.

Link: https://lkml.kernel.org/r/20200819175957.28465-3-david@redhat.com
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

 mm/memory_hotplug.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-enforce-section-granularity-when-onlining-offlining
+++ a/mm/memory_hotplug.c
@@ -801,6 +801,11 @@ int __ref online_pages(unsigned long pfn
 	int ret;
 	struct memory_notify arg;
 
+	/* We can only online full sections (e.g., SECTION_IS_ONLINE) */
+	if (WARN_ON_ONCE(!nr_pages ||
+			 !IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION)))
+		return -EINVAL;
+
 	mem_hotplug_begin();
 
 	/* associate pfn range with the zone */
@@ -1485,6 +1490,11 @@ int __ref offline_pages(unsigned long st
 	struct memory_notify arg;
 	char *reason;
 
+	/* We can only offline full sections (e.g., SECTION_IS_ONLINE) */
+	if (WARN_ON_ONCE(!nr_pages ||
+			 !IS_ALIGNED(start_pfn | nr_pages, PAGES_PER_SECTION)))
+		return -EINVAL;
+
 	mem_hotplug_begin();
 
 	/*
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


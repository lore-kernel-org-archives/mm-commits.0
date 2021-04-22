Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4119C433B4
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 04:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0F2661222
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 04:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhDVEZk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Apr 2021 00:25:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhDVEZg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Apr 2021 00:25:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE2AA6054E;
        Thu, 22 Apr 2021 04:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619065467;
        bh=OufHLVap0f1My8MjSzowDW5cL4DJuhoUxfsMQn4WUV4=;
        h=Date:From:To:Subject:From;
        b=hWeK6zc/AEPBqWucO5GZ+6w9ih5eC2qIjycbNExvly8sMRHuP1Y5kLGoeWAhvlnz+
         iMGSFvfrXmJtTMtES9Iq6jrToDCNYFcy43JNYR4FQhyhdfQ79NKgf64Tmo1TWounL2
         Kh0f9WhIlXUjWuVoY/rf8m5VHVIMsg7ZiDz1Bz2U=
Date:   Wed, 21 Apr 2021 21:24:26 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?mmmemory=5Fhotplug-factor-out-adjusting-present-pages-into?=
 =?US-ASCII?Q?-adjust=5Fpresent=5Fpage=5Fcount.patch?= added to -mm tree
Message-ID: <20210422042426.D5EoO9Ysj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,memory_hotplug: factor out adjusting present pages into adjust_present_page_count()
has been added to the -mm tree.  Its filename is
     mmmemory_hotplug-factor-out-adjusting-present-pages-into-adjust_present_page_count.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmmemory_hotplug-factor-out-adjusting-present-pages-into-adjust_present_page_count.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmmemory_hotplug-factor-out-adjusting-present-pages-into-adjust_present_page_count.patch

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
Subject: mm,memory_hotplug: factor out adjusting present pages into adjust_present_page_count()

Let's have a single place (inspired by adjust_managed_page_count()) where
we adjust present pages.  In contrast to adjust_managed_page_count(), only
memory onlining/offlining is allowed to modify the number of present
pages.

Link: https://lkml.kernel.org/r/20210421102701.25051-4-osalvador@suse.de
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/mm/memory_hotplug.c~mmmemory_hotplug-factor-out-adjusting-present-pages-into-adjust_present_page_count
+++ a/mm/memory_hotplug.c
@@ -829,6 +829,16 @@ struct zone * zone_for_pfn_range(int onl
 	return default_zone_for_pfn(nid, start_pfn, nr_pages);
 }
 
+static void adjust_present_page_count(struct zone *zone, long nr_pages)
+{
+	unsigned long flags;
+
+	zone->present_pages += nr_pages;
+	pgdat_resize_lock(zone->zone_pgdat, &flags);
+	zone->zone_pgdat->node_present_pages += nr_pages;
+	pgdat_resize_unlock(zone->zone_pgdat, &flags);
+}
+
 int __ref online_pages(unsigned long pfn, unsigned long nr_pages,
 		       int online_type, int nid)
 {
@@ -884,11 +894,7 @@ int __ref online_pages(unsigned long pfn
 	}
 
 	online_pages_range(pfn, nr_pages);
-	zone->present_pages += nr_pages;
-
-	pgdat_resize_lock(zone->zone_pgdat, &flags);
-	zone->zone_pgdat->node_present_pages += nr_pages;
-	pgdat_resize_unlock(zone->zone_pgdat, &flags);
+	adjust_present_page_count(zone, nr_pages);
 
 	node_states_set_node(nid, &arg);
 	if (need_zonelists_rebuild)
@@ -1706,11 +1712,7 @@ int __ref offline_pages(unsigned long st
 
 	/* removal success */
 	adjust_managed_page_count(pfn_to_page(start_pfn), -nr_pages);
-	zone->present_pages -= nr_pages;
-
-	pgdat_resize_lock(zone->zone_pgdat, &flags);
-	zone->zone_pgdat->node_present_pages -= nr_pages;
-	pgdat_resize_unlock(zone->zone_pgdat, &flags);
+	adjust_present_page_count(zone, -nr_pages);
 
 	init_per_zone_wmark_min();
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-page_alloc-drop-pr_info_ratelimited-in-alloc_contig_range.patch
mmmemory_hotplug-factor-out-adjusting-present-pages-into-adjust_present_page_count.patch
kernel-resource-make-walk_system_ram_res-find-all-busy-ioresource_system_ram-resources.patch
kernel-resource-make-walk_mem_res-find-all-busy-ioresource_mem-resources.patch
kernel-resource-remove-first_lvl-siblings_only-logic.patch
drivers-char-remove-dev-kmem-for-good.patch
mm-remove-xlate_dev_kmem_ptr.patch
mm-vmalloc-remove-vwrite.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D36F3C433E0
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BD80225AC
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:53:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbhAXBxx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:53:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726433AbhAXBxx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:53:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15E8A225AC;
        Sun, 24 Jan 2021 01:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611453192;
        bh=QPIWDNH91rFRANYhQt+I9lkr9U2W3nlCb1tdnIsAYTQ=;
        h=Date:From:To:Subject:From;
        b=X7Xp2K+u8sC7+wu2X+3nxtg6x4+YGNU1S6EedHnItV4/S3+wgYZT6Wl5gieBpTqj3
         StGCmlxbNSAwVJ7C/wazRcjrqr936B6sDhtsYGql1/xy60TRq36rQ+JVCQlpoCma6w
         pb/1R1lgIRFEbbgvn7j6RrMzV1famDydskxusghU=
Date:   Sat, 23 Jan 2021 17:53:11 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, david@redhat.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com
Subject:  + mm-simplify-parameter-of-setup_usemap.patch added to
 -mm tree
Message-ID: <20210124015311.JufWDiFy9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: simplify parameter of setup_usemap()
has been added to the -mm tree.  Its filename is
     mm-simplify-parameter-of-setup_usemap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-simplify-parameter-of-setup_usemap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-simplify-parameter-of-setup_usemap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm: simplify parameter of setup_usemap()

Parameter 'zone' has got needed information, let's remove other
unnecessary parameters.

Link: https://lkml.kernel.org/r/20210122135956.5946-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/mm/page_alloc.c~mm-simplify-parameter-of-setup_usemap
+++ a/mm/page_alloc.c
@@ -6763,25 +6763,22 @@ static unsigned long __init usemap_size(
 	return usemapsize / 8;
 }
 
-static void __ref setup_usemap(struct pglist_data *pgdat,
-				struct zone *zone,
-				unsigned long zone_start_pfn,
-				unsigned long zonesize)
+static void __ref setup_usemap(struct zone *zone)
 {
-	unsigned long usemapsize = usemap_size(zone_start_pfn, zonesize);
+	unsigned long usemapsize = usemap_size(zone->zone_start_pfn,
+					       zone->spanned_pages);
 	zone->pageblock_flags = NULL;
 	if (usemapsize) {
 		zone->pageblock_flags =
 			memblock_alloc_node(usemapsize, SMP_CACHE_BYTES,
-					    pgdat->node_id);
+					    zone_to_nid(zone));
 		if (!zone->pageblock_flags)
 			panic("Failed to allocate %ld bytes for zone %s pageblock flags on node %d\n",
-			      usemapsize, zone->name, pgdat->node_id);
+			      usemapsize, zone->name, zone_to_nid(zone));
 	}
 }
 #else
-static inline void setup_usemap(struct pglist_data *pgdat, struct zone *zone,
-				unsigned long zone_start_pfn, unsigned long zonesize) {}
+static inline void setup_usemap(struct zone *zone) {}
 #endif /* CONFIG_SPARSEMEM */
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
@@ -6976,7 +6973,7 @@ static void __init free_area_init_core(s
 			continue;
 
 		set_pageblock_order();
-		setup_usemap(pgdat, zone, zone_start_pfn, size);
+		setup_usemap(zone);
 		init_currently_empty_zone(zone, zone_start_pfn, size);
 		memmap_init_zone(zone);
 	}
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-fix-prototype-warning-from-kernel-test-robot.patch
mm-rename-memmap_init-and-memmap_init_zone.patch
mm-simplify-parater-of-function-memmap_init_zone.patch
mm-simplify-parameter-of-setup_usemap.patch
mm-remove-unneeded-local-variable-in-free_area_init_core.patch


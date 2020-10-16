Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0875C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B3BE2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817698;
	bh=QXiSLAy/LF8YTCm3JBwQcUf75lr4Av2hOwrRcAqwkK8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=rg8OMCcue3aph5UVVuAutHd0IbUxaaJs577h8FHj1Kx0Zt1V6vLkJC9Dz458HeB4R
	 WSA5+zN922rz4etoAQxdFf31fOrShKV30MCMN1dPnhY9CaFK0DFObFjHdrRj7K5VM2
	 xh9No+NuUCRzA+ySk4Y965XayqPcQbE0T/IYm8yU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732403AbgJPDIS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbgJPDIS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:08:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12FF520789;
        Fri, 16 Oct 2020 03:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817697;
        bh=QXiSLAy/LF8YTCm3JBwQcUf75lr4Av2hOwrRcAqwkK8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Y3Rp56AnTl2s5tvYO/s/1qEdwu24jNJJENeJsfX2/GDmzz80GAEqKC2vlg5RLrPDU
         nvOrmvwHz5JpH04XBIWbQTrLcvE78AE6kMg3gswQt9JKud5SdQEclG4FEdFAP/5zyU
         362ni0e3pln0kyxkFEBU3E9nx8/4VGQiO2cPol8U=
Date:   Thu, 15 Oct 2020 20:08:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, charante@codeaurora.org,
        dan.j.williams@intel.com, david@redhat.com, fenghua.yu@intel.com,
        logang@deltatee.com, mgorman@suse.de, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, tony.luck@intel.com,
        torvalds@linux-foundation.org, walken@google.com,
        willy@infradead.org
Subject:  [patch 066/156] mm/page_alloc: drop stale pageblock
 comment in memmap_init_zone*()
Message-ID: <20201016030815.iugAY2iFj%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: drop stale pageblock comment in memmap_init_zone*()

Commit ac5d2539b238 ("mm: meminit: reduce number of times pageblocks are
set during struct page init") moved the actual zone range check, leaving
only the alignment check for pageblocks.

Let's drop the stale comment and make the pageblock check easier to read.

Link: https://lkml.kernel.org/r/20200819175957.28465-9-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
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
@@ -6042,13 +6042,8 @@ void __meminit memmap_init_zone(unsigned
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
@@ -6111,15 +6106,10 @@ void __ref memmap_init_zone_device(struc
 		 * the address space during boot when many long-lived
 		 * kernel allocations are made.
 		 *
-		 * bitmap is created for zone's valid pfn range. but memmap
-		 * can be created for invalid pages (for alignment)
-		 * check here not to call set_pageblock_migratetype() against
-		 * pfn out of zone.
-		 *
 		 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
 		 * because this is done early in section_activate()
 		 */
-		if (!(pfn & (pageblock_nr_pages - 1))) {
+		if (IS_ALIGNED(pfn, pageblock_nr_pages)) {
 			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 			cond_resched();
 		}
_

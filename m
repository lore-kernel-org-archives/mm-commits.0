Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32557C61DF4
	for <mm-commits@archiver.kernel.org>; Fri, 24 Nov 2023 18:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbjKXSlP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Nov 2023 13:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjKXSlP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Nov 2023 13:41:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE06719D
        for <mm-commits@vger.kernel.org>; Fri, 24 Nov 2023 10:41:21 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E671C433C7;
        Fri, 24 Nov 2023 18:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700851281;
        bh=h4rsvGlsMd2ehhUNBwz0z/hlxv7Y2Yg8RP1dNXbGQfg=;
        h=Date:To:From:Subject:From;
        b=H4gwp17r39rvavHAXUC8nL9RSMG5FLCfjKsg5b8r6YXjYJ9S7R52vl2GQN+XoJEBJ
         rJfuk/fToU0oA43W0LkKZ8a0eqgBV06Jj+H5+duKBCb2EOWpbuf/xECPUNKq6hbDIg
         68r1kFFrdNu1GpnFHIeu8Avimtz60jASO6qKN0ls=
Date:   Fri, 24 Nov 2023 10:41:20 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        quic_pkondeti@quicinc.com, mhocko@suse.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org, david@redhat.com,
        quic_charante@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-correct-high-atomic-reserve-calculations.patch added to mm-unstable branch
Message-Id: <20231124184121.3E671C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: correct high atomic reserve calculations
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-correct-high-atomic-reserve-calculations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-correct-high-atomic-reserve-calculations.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: mm: page_alloc: correct high atomic reserve calculations
Date: Fri, 24 Nov 2023 16:35:52 +0530

Patch series "mm: page_alloc: fixes for high atomic reserve
caluculations", v3.

The state of the system where the issue exposed shown in oom kill logs:

[  295.998653] Normal free:7728kB boost:0kB min:804kB low:1004kB high:1204kB reserved_highatomic:8192KB active_anon:4kB inactive_anon:0kB active_file:24kB inactive_file:24kB unevictable:1220kB writepending:0kB present:70732kB managed:49224kB mlocked:0kB bounce:0kB free_pcp:688kBlocal_pcp:492kB free_cma:0kB
[  295.998656] lowmem_reserve[]: 0 32
[  295.998659] Normal: 508*4kB (UMEH) 241*8kB (UMEH) 143*16kB (UMEH)
33*32kB (UH) 7*64kB (UH) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 7752kB

From the above, it is seen that ~16MB of memory reserved for high atomic
reserves against the expectation of 1% reserves which is fixed in the 1st
patch.

Don't reserve the high atomic page blocks if 1% of zone memory size is
below a pageblock size.


This patch (of 2):

reserve_highatomic_pageblock() aims to reserve the 1% of the managed pages
of a zone, which is used for the high order atomic allocations.

It uses the below calculation to reserve:
static void reserve_highatomic_pageblock(struct page *page, ....) {

   .......
   max_managed = (zone_managed_pages(zone) / 100) + pageblock_nr_pages;

   if (zone->nr_reserved_highatomic >= max_managed)
       goto out;

   zone->nr_reserved_highatomic += pageblock_nr_pages;
   set_pageblock_migratetype(page, MIGRATE_HIGHATOMIC);
   move_freepages_block(zone, page, MIGRATE_HIGHATOMIC, NULL);

out:
   ....
}

Since we are always appending the 1% of zone managed pages count to
pageblock_nr_pages, the minimum it is turning into 2 pageblocks as the
nr_reserved_highatomic is incremented/decremented in pageblock sizes.

Encountered a system(actually a VM running on the Linux kernel) with the
below zone configuration:
Normal free:7728kB boost:0kB min:804kB low:1004kB high:1204kB
reserved_highatomic:8192KB managed:49224kB

The existing calculations making it to reserve the 8MB(with pageblock size
of 4MB) i.e.  16% of the zone managed memory.  Reserving such high amount
of memory can easily exert memory pressure in the system thus may lead
into unnecessary reclaims till unreserving of high atomic reserves.

Since high atomic reserves are managed in pageblock size granules, as
MIGRATE_HIGHATOMIC is set for such pageblock, fix the calculations for
high atomic reserves as, minimum is pageblock size , maximum is
approximately 1% of the zone managed pages.

Link: https://lkml.kernel.org/r/cover.1700821416.git.quic_charante@quicinc.com
Link: https://lkml.kernel.org/r/1660034138397b82a0a8b6ae51cbe96bd583d89e.1700821416.git.quic_charante@quicinc.com
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-correct-high-atomic-reserve-calculations
+++ a/mm/page_alloc.c
@@ -1880,10 +1880,11 @@ static void reserve_highatomic_pageblock
 	unsigned long max_managed, flags;
 
 	/*
-	 * Limit the number reserved to 1 pageblock or roughly 1% of a zone.
+	 * The number reserved as: minimum is 1 pageblock, maximum is
+	 * roughly 1% of a zone.
 	 * Check is race-prone but harmless.
 	 */
-	max_managed = (zone_managed_pages(zone) / 100) + pageblock_nr_pages;
+	max_managed = ALIGN((zone_managed_pages(zone) / 100), pageblock_nr_pages);
 	if (zone->nr_reserved_highatomic >= max_managed)
 		return;
 
_

Patches currently in -mm which might be from quic_charante@quicinc.com are

mm-sparsemem-fix-race-in-accessing-memory_section-usage.patch
mm-sparsemem-fix-race-in-accessing-memory_section-usage-v2.patch
mm-page_alloc-correct-high-atomic-reserve-calculations.patch
mm-page_alloc-enforce-minimum-zone-size-to-do-high-atomic-reserves.patch


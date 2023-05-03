Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92985C7EE2A
	for <mm-commits@archiver.kernel.org>; Wed,  3 May 2023 00:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjECAWW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 20:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjECAWS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 20:22:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D731997
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 17:22:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0549A629E0
        for <mm-commits@vger.kernel.org>; Wed,  3 May 2023 00:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5795CC433D2;
        Wed,  3 May 2023 00:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683073336;
        bh=CEhivoS3sIYFemCQiu5PFPanfcJbwUgFmrSDRPLwuj0=;
        h=Date:To:From:Subject:From;
        b=CpcuJ4efNblfifUe6+jyz66vng8F/OXJznQQ4Y9gDmcVJFc4C2yv5b3vJg3cUc/9s
         zExICAueIirQ6iiTH5Ij2d9Td5MgMZ5aqvZW8N4QW0JXRpA6HYj/7GHq5AXof/g0WN
         9HIMFuhJUaNt6Er85cNOel65PsfXzyPVeCxDaBqE=
Date:   Tue, 02 May 2023 17:22:15 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        rppt@kernel.org, mhocko@suse.com, mgorman@techsingularity.net,
        david@redhat.com, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-add-some-comments-to-explain-the-possible-hole-in-__pageblock_pfn_to_page.patch removed from -mm tree
Message-Id: <20230503002216.5795CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: add some comments to explain the possible hole in __pageblock_pfn_to_page()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-some-comments-to-explain-the-possible-hole-in-__pageblock_pfn_to_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm/page_alloc: add some comments to explain the possible hole in __pageblock_pfn_to_page()
Date: Tue, 25 Apr 2023 20:44:53 +0800

Now the __pageblock_pfn_to_page() is used by set_zone_contiguous(), which
checks whether the given zone contains holes, and uses
pfn_to_online_page() to validate if the start pfn is online and valid, as
well as using pfn_valid() to validate the end pfn.

However, the __pageblock_pfn_to_page() function may return non-NULL even
if the end pfn of a pageblock is in a memory hole in some situations.  For
example, if the pageblock order is MAX_ORDER, which will fall into 2
sub-sections, and the end pfn of the pageblock may be hole even though the
start pfn is online and valid.

See below memory layout as an example and suppose the pageblock order is
MAX_ORDER.

[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000040000000-0x00000000ffffffff]
[    0.000000]   DMA32    empty
[    0.000000]   Normal   [mem 0x0000000100000000-0x0000001fa7ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000040000000-0x0000001fa3c7ffff]
[    0.000000]   node   0: [mem 0x0000001fa3c80000-0x0000001fa3ffffff]
[    0.000000]   node   0: [mem 0x0000001fa4000000-0x0000001fa402ffff]
[    0.000000]   node   0: [mem 0x0000001fa4030000-0x0000001fa40effff]
[    0.000000]   node   0: [mem 0x0000001fa40f0000-0x0000001fa73cffff]
[    0.000000]   node   0: [mem 0x0000001fa73d0000-0x0000001fa745ffff]
[    0.000000]   node   0: [mem 0x0000001fa7460000-0x0000001fa746ffff]
[    0.000000]   node   0: [mem 0x0000001fa7470000-0x0000001fa758ffff]
[    0.000000]   node   0: [mem 0x0000001fa7590000-0x0000001fa7dfffff]

Focus on the last memory range, and there is a hole for the range [mem
0x0000001fa7590000-0x0000001fa7dfffff].  That means the last pageblock
will contain the range from 0x1fa7c00000 to 0x1fa7ffffff, since the
pageblock must be 4M aligned.  And in this pageblock, these pfns will fall
into 2 sub-section (the sub-section size is 2M aligned).

So, the 1st sub-section (indicates pfn range: 0x1fa7c00000 - 0x1fa7dfffff
) in this pageblock is valid by calling subsection_map_init() in
free_area_init(), but the 2nd sub-section (indicates pfn range:
0x1fa7e00000 - 0x1fa7ffffff ) in this pageblock is not valid.

This did not break anything until now, but the zone continuous is fragile
in this possible scenario.  So as previous discussion[1], it is better to
add some comments to explain this possible issue in case there are some
future pfn walkers that rely on this.

[1] https://lore.kernel.org/all/87r0sdsmr6.fsf@yhuang6-desk2.ccr.corp.intel.com/

Link: https://lkml.kernel.org/r/5c26368865e79c743a453dea48d30670b19d2e4f.1682425534.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/5c26368865e79c743a453dea48d30670b19d2e4f.1682425534.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-add-some-comments-to-explain-the-possible-hole-in-__pageblock_pfn_to_page
+++ a/mm/page_alloc.c
@@ -1502,6 +1502,15 @@ void __free_pages_core(struct page *page
  * interleaving within a single pageblock. It is therefore sufficient to check
  * the first and last page of a pageblock and avoid checking each individual
  * page in a pageblock.
+ *
+ * Note: the function may return non-NULL struct page even for a page block
+ * which contains a memory hole (i.e. there is no physical memory for a subset
+ * of the pfn range). For example, if the pageblock order is MAX_ORDER, which
+ * will fall into 2 sub-sections, and the end pfn of the pageblock may be hole
+ * even though the start pfn is online and valid. This should be safe most of
+ * the time because struct pages are still initialized via init_unavailable_range()
+ * and pfn walkers shouldn't touch any physical memory range for which they do
+ * not recognize any specific metadata in struct pages.
  */
 struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
 				     unsigned long end_pfn, struct zone *zone)
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-page_alloc-drop-the-unnecessary-pfn_valid-for-start-pfn.patch


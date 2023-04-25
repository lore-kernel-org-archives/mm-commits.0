Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3778CC77B61
	for <mm-commits@archiver.kernel.org>; Tue, 25 Apr 2023 18:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbjDYS6L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Apr 2023 14:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234829AbjDYS6K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Apr 2023 14:58:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE8E18BB0
        for <mm-commits@vger.kernel.org>; Tue, 25 Apr 2023 11:57:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB722626B9
        for <mm-commits@vger.kernel.org>; Tue, 25 Apr 2023 18:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41008C433D2;
        Tue, 25 Apr 2023 18:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682449026;
        bh=eRVjOPweOoCRsyM5he9U2ZFDN9B8YD2qF0O0s1vb2t4=;
        h=Date:To:From:Subject:From;
        b=CpXbOyeFnn99wdQJvlpbvZ7K64RIPXdrTZHGS4KBbV+20w9GFMSGkxcf5kwTsHxi6
         F4MlqVq1CSDGT9AcZ8p6udHu1e/6gpy6gxiDJj6MDMyD3OUF+XiTbY1xteNX4PuCDR
         QNkfmDoXJ3tz2it/AnriTIPnlW1dC8tQ/TfEIWU0=
Date:   Tue, 25 Apr 2023 11:57:05 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        rppt@kernel.org, mhocko@suse.com, mgorman@techsingularity.net,
        david@redhat.com, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-add-some-comments-to-explain-the-possible-hole-in-__pageblock_pfn_to_page.patch added to mm-unstable branch
Message-Id: <20230425185706.41008C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add some comments to explain the possible hole in __pageblock_pfn_to_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-add-some-comments-to-explain-the-possible-hole-in-__pageblock_pfn_to_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-add-some-comments-to-explain-the-possible-hole-in-__pageblock_pfn_to_page.patch

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

See below memory layout as an example and suppose the pageblock order
is MAX_ORDER.

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
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
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

mm-page_alloc-add-some-comments-to-explain-the-possible-hole-in-__pageblock_pfn_to_page.patch


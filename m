Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F36F0C001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235902AbjHKXAo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236736AbjHKW7w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1181359C
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5807F678E6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC16C433C7;
        Fri, 11 Aug 2023 22:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794777;
        bh=9baGdWQzwPwKzy6mU3KfYzOm872oHGuA01Ry2ubVfbg=;
        h=Date:To:From:Subject:From;
        b=0GXl9XU5UpUN5NSAO2U+ETF63yBeCWsHuk27eLrBIICHW1Ey8aZtg+PZHqIue9EQv
         xw1sjPP39rF+mvmVGpX2ocM6tVKcWhgk7bInDU4lNlo6A+9pLwHFsgTxY5+4nRnuZT
         Y+QNWqlVcEQWXGNTtlaXg6DEFCQObNOo0KfI4RYs=
Date:   Fri, 11 Aug 2023 15:59:37 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        shikemeng@huaweicloud.com, mgorman@techsingularity.net,
        david@redhat.com, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-skip-the-memory-hole-rapidly-when-isolating-free-pages.patch removed from -mm tree
Message-Id: <20230811225937.ADC16C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: skip the memory hole rapidly when isolating free pages
has been removed from the -mm tree.  Its filename was
     mm-compaction-skip-the-memory-hole-rapidly-when-isolating-free-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: skip the memory hole rapidly when isolating free pages
Date: Fri, 7 Jul 2023 16:51:47 +0800

Just like commit 9721fd82351d ("mm: compaction: skip memory hole
rapidly when isolating migratable pages"), I can see it will also take
more time to skip the larger memory hole (range: 0x1000000000 -
0x1800000000) when isolating free pages on my machine with below memory
layout.  So like commit 9721fd82351d, adding a new helper to skip the
memory hole rapidly, which can reduce the time consumed from about 70us
to less than 1us.

[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000040000000-0x00000000ffffffff]
[    0.000000]   DMA32    empty
[    0.000000]   Normal   [mem 0x0000000100000000-0x0000001fa7ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000040000000-0x0000000fffffffff]
[    0.000000]   node   0: [mem 0x0000001800000000-0x0000001fa3c7ffff]
[    0.000000]   node   0: [mem 0x0000001fa3c80000-0x0000001fa3ffffff]
[    0.000000]   node   0: [mem 0x0000001fa4000000-0x0000001fa402ffff]
[    0.000000]   node   0: [mem 0x0000001fa4030000-0x0000001fa40effff]
[    0.000000]   node   0: [mem 0x0000001fa40f0000-0x0000001fa73cffff]
[    0.000000]   node   0: [mem 0x0000001fa73d0000-0x0000001fa745ffff]
[    0.000000]   node   0: [mem 0x0000001fa7460000-0x0000001fa746ffff]
[    0.000000]   node   0: [mem 0x0000001fa7470000-0x0000001fa758ffff]
[    0.000000]   node   0: [mem 0x0000001fa7590000-0x0000001fa7ffffff]

[shikemeng@huaweicloud.com: avoid missing last page block in section after skip offline sections]
  Link: https://lkml.kernel.org/r/20230804110454.2935878-1-shikemeng@huaweicloud.com
  Link: https://lkml.kernel.org/r/20230804110454.2935878-2-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/d2ba7e41ee566309b594311207ffca736375fc16.1688715750.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-skip-the-memory-hole-rapidly-when-isolating-free-pages
+++ a/mm/compaction.c
@@ -249,11 +249,36 @@ static unsigned long skip_offline_sectio
 
 	return 0;
 }
+
+/*
+ * If the PFN falls into an offline section, return the end PFN of the
+ * next online section in reverse. If the PFN falls into an online section
+ * or if there is no next online section in reverse, return 0.
+ */
+static unsigned long skip_offline_sections_reverse(unsigned long start_pfn)
+{
+	unsigned long start_nr = pfn_to_section_nr(start_pfn);
+
+	if (!start_nr || online_section_nr(start_nr))
+		return 0;
+
+	while (start_nr-- > 0) {
+		if (online_section_nr(start_nr))
+			return section_nr_to_pfn(start_nr) + PAGES_PER_SECTION;
+	}
+
+	return 0;
+}
 #else
 static unsigned long skip_offline_sections(unsigned long start_pfn)
 {
 	return 0;
 }
+
+static unsigned long skip_offline_sections_reverse(unsigned long start_pfn)
+{
+	return 0;
+}
 #endif
 
 /*
@@ -1668,8 +1693,15 @@ static void isolate_freepages(struct com
 
 		page = pageblock_pfn_to_page(block_start_pfn, block_end_pfn,
 									zone);
-		if (!page)
+		if (!page) {
+			unsigned long next_pfn;
+
+			next_pfn = skip_offline_sections_reverse(block_start_pfn);
+			if (next_pfn)
+				block_start_pfn = max(next_pfn, low_pfn);
+
 			continue;
+		}
 
 		/* Check the block is suitable for migration */
 		if (!suitable_migration_target(cc, page))
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are



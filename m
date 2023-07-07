Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF03C001B0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Jul 2023 19:15:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbjGGTPe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Jul 2023 15:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbjGGTPd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2023 15:15:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBE2124
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 12:15:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7121161A3E
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 19:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C220BC433C7;
        Fri,  7 Jul 2023 19:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688757331;
        bh=AV1nYRkaHA81IuQBIsUbnHZjBkNXBsDqPmuxtPZfMr4=;
        h=Date:To:From:Subject:From;
        b=hNvG+1L5MwW5pA00qdg2VVej8SV8+rnq23VvxxdWJtLSmQx0VCTWpUWznuAVHx0q9
         CR/pulV7WZ6/W0K+m1OiJzEzbqjGodpwNLgzwHIlt/mtCmJ8eaKB89/fwdOzPVHFdd
         9zV0QfA116xoOINZmbvOZLpMkeEZMJwXy1z/0Dj4=
Date:   Fri, 07 Jul 2023 12:15:31 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-skip-the-memory-hole-rapidly-when-isolating-free-pages.patch added to mm-unstable branch
Message-Id: <20230707191531.C220BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: skip the memory hole rapidly when isolating free pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-skip-the-memory-hole-rapidly-when-isolating-free-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-skip-the-memory-hole-rapidly-when-isolating-free-pages.patch

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
Subject: mm: compaction: skip the memory hole rapidly when isolating free pages
Date: Fri, 7 Jul 2023 16:51:47 +0800

On my machine with below memory layout, and I can see it will take more
time to skip the larger memory hole (range: 0x100000000 - 0x1800000000)
when isolating free pages.  So adding a new helper to skip the memory hole
rapidly, which can reduce the time consumed from about 70us to less than
1us.

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

Link: https://lkml.kernel.org/r/d2ba7e41ee566309b594311207ffca736375fc16.1688715750.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-skip-the-memory-hole-rapidly-when-isolating-free-pages
+++ a/mm/compaction.c
@@ -249,11 +249,31 @@ static unsigned long skip_offline_sectio
 
 	return 0;
 }
+
+static unsigned long skip_offline_sections_reverse(unsigned long start_pfn)
+{
+	unsigned long start_nr = pfn_to_section_nr(start_pfn);
+
+	if (!start_nr || online_section_nr(start_nr))
+		return 0;
+
+	while (start_nr-- > 0) {
+		if (online_section_nr(start_nr))
+			return section_nr_to_pfn(start_nr) + PAGES_PER_SECTION - 1;
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
@@ -1668,8 +1688,16 @@ static void isolate_freepages(struct com
 
 		page = pageblock_pfn_to_page(block_start_pfn, block_end_pfn,
 									zone);
-		if (!page)
+		if (!page) {
+			unsigned long next_pfn;
+
+			next_pfn = skip_offline_sections_reverse(block_start_pfn);
+			if (next_pfn)
+				block_start_pfn = max(pageblock_start_pfn(next_pfn),
+						      low_pfn);
+
 			continue;
+		}
 
 		/* Check the block is suitable for migration */
 		if (!suitable_migration_target(cc, page))
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-compaction-use-the-correct-type-of-list-for-free-pages.patch
mm-compaction-skip-the-memory-hole-rapidly-when-isolating-free-pages.patch


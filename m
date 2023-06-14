Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AF00EB64D8
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jun 2023 19:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbjFNT63 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jun 2023 15:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbjFNT62 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Jun 2023 15:58:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57A41FEF
        for <mm-commits@vger.kernel.org>; Wed, 14 Jun 2023 12:58:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B87164460
        for <mm-commits@vger.kernel.org>; Wed, 14 Jun 2023 19:58:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E423C433C8;
        Wed, 14 Jun 2023 19:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686772706;
        bh=4eItgTWFh2sOVr19m+3jndJu3y5f1N53xvV07vpBbOw=;
        h=Date:To:From:Subject:From;
        b=zcEeaMowOJriGsUwwowM091/zaroLnd1sSyyk0F9IbaGBIlKc4YGx3TcudTCINjLj
         Y4slL19aksaBVm1MHVx71KkdVlgZ+V+xDob132m153QcD1rEVvZzybAEFBnNrU02Dw
         SQEL7B7CmqDYa11OPvOySiZnWqBdOQ8ieIoqCVUI=
Date:   Wed, 14 Jun 2023 12:58:25 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-skip-memory-hole-rapidly-when-isolating-migratable-pages.patch added to mm-unstable branch
Message-Id: <20230614195826.7E423C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: skip memory hole rapidly when isolating migratable pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-skip-memory-hole-rapidly-when-isolating-migratable-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-skip-memory-hole-rapidly-when-isolating-migratable-pages.patch

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
Subject: mm: compaction: skip memory hole rapidly when isolating migratable pages
Date: Wed, 14 Jun 2023 16:40:20 +0800

On some machines, the normal zone can have a large memory hole like below
memory layout, and we can see the range from 0x100000000 to 0x1800000000
is a hole.  So when isolating some migratable pages, the scanner can meet
the hole and it will take more time to skip the large hole.  From my
measurement, I can see the isolation scanner will take 80us ~ 100us to
skip the large hole [0x100000000 - 0x1800000000].

So adding a new helper to fast search next online memory section to skip
the large hole can help to find next suitable pageblock efficiently.  With
this patch, I can see the large hole scanning only takes < 1us.

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

Link: https://lkml.kernel.org/r/75b4c8ca36bf44ad8c42bf0685ac19d272e426ec.1686705221.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-skip-memory-hole-rapidly-when-isolating-migratable-pages
+++ a/mm/compaction.c
@@ -229,6 +229,33 @@ static void reset_cached_positions(struc
 				pageblock_start_pfn(zone_end_pfn(zone) - 1);
 }
 
+#ifdef CONFIG_SPARSEMEM
+/*
+ * If the PFN falls into an offline section, return the start PFN of the
+ * next online section. If the PFN falls into an online section or if
+ * there is no next online section, return 0.
+ */
+static unsigned long skip_offline_sections(unsigned long start_pfn)
+{
+	unsigned long start_nr = pfn_to_section_nr(start_pfn);
+
+	if (online_section_nr(start_nr))
+		return 0;
+
+	while (++start_nr <= __highest_present_section_nr) {
+		if (online_section_nr(start_nr))
+			return section_nr_to_pfn(start_nr);
+	}
+
+	return 0;
+}
+#else
+static unsigned long skip_offline_sections(unsigned long start_pfn)
+{
+	return 0;
+}
+#endif
+
 /*
  * Compound pages of >= pageblock_order should consistently be skipped until
  * released. It is always pointless to compact pages of such order (if they are
@@ -1955,8 +1982,14 @@ static isolate_migrate_t isolate_migrate
 
 		page = pageblock_pfn_to_page(block_start_pfn,
 						block_end_pfn, cc->zone);
-		if (!page)
+		if (!page) {
+			unsigned long next_pfn;
+
+			next_pfn = skip_offline_sections(block_start_pfn);
+			if (next_pfn)
+				block_end_pfn = next_pfn;
 			continue;
+		}
 
 		/*
 		 * If isolation recently failed, do not retry. Only check the
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-compaction-skip-memory-hole-rapidly-when-isolating-migratable-pages.patch


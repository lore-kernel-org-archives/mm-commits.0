Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4805C001B0
	for <mm-commits@archiver.kernel.org>; Mon,  7 Aug 2023 16:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjHGQFs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Aug 2023 12:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjHGQFr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Aug 2023 12:05:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C29E79
        for <mm-commits@vger.kernel.org>; Mon,  7 Aug 2023 09:05:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 014E761D5F
        for <mm-commits@vger.kernel.org>; Mon,  7 Aug 2023 16:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D19C433C7;
        Mon,  7 Aug 2023 16:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691424343;
        bh=wqTIPTHBryhEeb4QUXy6+5cn5pNdok18aQ1pp5a+VeQ=;
        h=Date:To:From:Subject:From;
        b=b+QLPbYetkTrK1AEX+bp/9Av+GbH1d8kKN47CLIPuq3l4h5nNRNnxnEXlYOp1NC0W
         +jocS0ypOBFxTUqCnhoVuvlj69EBzE9oBb3cQ7+Ei9ktIa++wBzp+nx4NkUH/a74C+
         slCahZZKp8WqBqKsDP+T8hI8yYefJxgtQqwxSPgM=
Date:   Mon, 07 Aug 2023 09:05:42 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        david@redhat.com, baolin.wang@linux.alibaba.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-skip-the-memory-hole-rapidly-when-isolating-free-pages-fix.patch added to mm-unstable branch
Message-Id: <20230807160543.52D19C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: avoid missing last page block in section after skip offline sections
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-skip-the-memory-hole-rapidly-when-isolating-free-pages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-skip-the-memory-hole-rapidly-when-isolating-free-pages-fix.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/compaction: avoid missing last page block in section after skip offline sections
Date: Fri, 4 Aug 2023 19:04:47 +0800

skip_offline_sections_reverse will return the last pfn in found online
section.  Then we set block_start_pfn to start of page block which
contains the last pfn in section.  Then we continue, move one page block
forward and ignore the last page block in the online section.  Make
block_start_pfn point to first page block after online section to fix
this:

1. make skip_offline_sections_reverse return end pfn of online section,
   i.e. pfn of page block after online section.

2. assign block_start_pfn with next_pfn.

Link: https://lkml.kernel.org/r/20230804110454.2935878-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20230804110454.2935878-2-shikemeng@huaweicloud.com
Fixes: f63224525309 ("mm: compaction: skip the memory hole rapidly when isolating free pages")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-skip-the-memory-hole-rapidly-when-isolating-free-pages-fix
+++ a/mm/compaction.c
@@ -250,6 +250,11 @@ static unsigned long skip_offline_sectio
 	return 0;
 }
 
+/*
+ * If the PFN falls into an offline section, return the end PFN of the
+ * next online section in reverse. If the PFN falls into an online section
+ * or if there is no next online section in reverse, return 0.
+ */
 static unsigned long skip_offline_sections_reverse(unsigned long start_pfn)
 {
 	unsigned long start_nr = pfn_to_section_nr(start_pfn);
@@ -259,7 +264,7 @@ static unsigned long skip_offline_sectio
 
 	while (start_nr-- > 0) {
 		if (online_section_nr(start_nr))
-			return section_nr_to_pfn(start_nr) + PAGES_PER_SECTION - 1;
+			return section_nr_to_pfn(start_nr) + PAGES_PER_SECTION;
 	}
 
 	return 0;
@@ -1694,8 +1699,7 @@ static void isolate_freepages(struct com
 
 			next_pfn = skip_offline_sections_reverse(block_start_pfn);
 			if (next_pfn)
-				block_start_pfn = max(pageblock_start_pfn(next_pfn),
-						      low_pfn);
+				block_start_pfn = max(next_pfn, low_pfn);
 
 			continue;
 		}
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-correct-stale-comment-of-function-check_pte.patch
mm-compaction-skip-the-memory-hole-rapidly-when-isolating-free-pages-fix.patch
mm-page_table_check-remove-unused-parameters-in-page_table_check_clear.patch
mm-page_table_check-remove-unused-parameters-in-page_table_check_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_set.patch
mm-page_ext-remove-unused-return-value-of-offline_page_ext.patch
mm-page_ext-remove-rollback-for-untouched-mem_section-in-online_page_ext.patch
mm-page_ext-move-functions-around-for-minor-cleanups-to-page_ext.patch
mm-page_ext-add-common-function-to-get-client-data-from-page_ext.patch
mm-page_ext-use-page_ext_data-helper-in-page_table_check.patch
mm-page_ext-use-page_ext_data-helper-in-page_owner.patch
mm-rmap-correct-stale-comment-of-rmap_walk_anon-and-rmap_walk_file.patch
mm-page_poison-remove-unused-page_exth-from-page_poison.patch
mm-vmstat-remove-unused-page_exth-from-vmstat.patch
mm-page_ext-move-page_ext_operations-definition-under-config_page_extension.patch
mm-compaction-set-compact_cached_free_pfn-correctly-in-update_pageblock_skip.patch
mm-compaction-remove-unnecessary-cursor-page-in-isolate_freepages_block.patch
mm-compaction-remove-unnecessary-else-continue-at-end-of-loop-in-isolate_freepages_block.patch
mm-compaction-correct-last_migrated_pfn-update-in-compact_zone.patch
mm-compaction-skip-page-block-marked-skip-in-isolate_migratepages_block.patch
mm-compaction-correct-comment-of-fast_find_migrateblock-in-isolate_migratepages.patch
mm-compaction-correct-comment-of-cached-migrate-pfn-update.patch
mm-compaction-correct-comment-to-complete-migration-failure.patch
mm-compaction-remove-unnecessary-return-for-void-function.patch
mm-compaction-only-set-skip-flag-if-cc-no_set_skip_hint-is-false.patch


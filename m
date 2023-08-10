Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D93C001B0
	for <mm-commits@archiver.kernel.org>; Thu, 10 Aug 2023 17:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjHJRGq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Aug 2023 13:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbjHJRGo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2023 13:06:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0565F1BF7
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 10:06:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8973463061
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 17:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2F7C433C7;
        Thu, 10 Aug 2023 17:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691687203;
        bh=wWRaCEGQpYYkPg0j651IpR6Vs9WUYHCtRNihevJ1HPI=;
        h=Date:To:From:Subject:From;
        b=rPgGT7qwB2m+eKzGyR0UhGQQTfiPQF8vgmC0segBkDeDHvzY7mspfrtYHFRYdHTEC
         SkUEAwYPz2NIqJTMDXIHt/reI42GJq9lKp4Y93bXBHgrvM7sZ38uNTkdgZod5irqA/
         gmOrL4rkX3QsdUX0EegzHmhggRBIsSgfM0kH5yvE=
Date:   Thu, 10 Aug 2023 10:06:42 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-unnecessary-parameter-batch-of-nr_pcp_free.patch added to mm-unstable branch
Message-Id: <20230810170642.DF2F7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: remove unnecessary parameter batch of nr_pcp_free
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-remove-unnecessary-parameter-batch-of-nr_pcp_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-unnecessary-parameter-batch-of-nr_pcp_free.patch

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
Subject: mm/page_alloc: remove unnecessary parameter batch of nr_pcp_free
Date: Wed, 9 Aug 2023 18:07:54 +0800

We get batch from pcp and just pass it to nr_pcp_free immediately.  Get
batch from pcp inside nr_pcp_free to remove unnecessary parameter batch.

Link: https://lkml.kernel.org/r/20230809100754.3094517-3-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-unnecessary-parameter-batch-of-nr_pcp_free
+++ a/mm/page_alloc.c
@@ -2376,10 +2376,10 @@ static bool free_unref_page_prepare(stru
 	return true;
 }
 
-static int nr_pcp_free(struct per_cpu_pages *pcp, int high, int batch,
-		       bool free_high)
+static int nr_pcp_free(struct per_cpu_pages *pcp, int high, bool free_high)
 {
 	int min_nr_free, max_nr_free;
+	int batch = READ_ONCE(pcp->batch);
 
 	/* Free everything if batch freeing high-order pages. */
 	if (unlikely(free_high))
@@ -2446,9 +2446,7 @@ static void free_unref_page_commit(struc
 
 	high = nr_pcp_high(pcp, zone, free_high);
 	if (pcp->count >= high) {
-		int batch = READ_ONCE(pcp->batch);
-
-		free_pcppages_bulk(zone, nr_pcp_free(pcp, high, batch, free_high), pcp, pindex);
+		free_pcppages_bulk(zone, nr_pcp_free(pcp, high, free_high), pcp, pindex);
 	}
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
mm-page_alloc-remove-track-of-active-pcp-lists-range-in-bulk-free.patch
mm-page_alloc-remove-unnecessary-parameter-batch-of-nr_pcp_free.patch


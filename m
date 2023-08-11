Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B3AC41513
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236813AbjHKXFf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236736AbjHKXD4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094384487
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E3986464E
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029D1C433C8;
        Fri, 11 Aug 2023 23:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794917;
        bh=zaBKhq7rN9AjxuKaQLrc3TBlvJNBn3aPuhtKIlJPgBI=;
        h=Date:To:From:Subject:From;
        b=uxZSIcslaQ1PRrSU0fRkomzlFIsGfdX2TMaWKZecrF7K6SU8zTDwoe739Hda8f2Io
         mZVszwGKowkWvJ6DVFZ4jLZMOaljFhGd5TIDkFfY0Mmdw+nvsdl1/LYn3B7S4+u2Fr
         5AGu6ykA7OJZTaR4td11z5GaSl2dgY5bURgMZ9aE=
Date:   Fri, 11 Aug 2023 16:01:56 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, david@redhat.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-correct-stale-comment-of-rmap_walk_anon-and-rmap_walk_file.patch removed from -mm tree
Message-Id: <20230811230157.029D1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/rmap: correct stale comment of rmap_walk_anon and rmap_walk_file
has been removed from the -mm tree.  Its filename was
     mm-rmap-correct-stale-comment-of-rmap_walk_anon-and-rmap_walk_file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/rmap: correct stale comment of rmap_walk_anon and rmap_walk_file
Date: Tue, 18 Jul 2023 17:21:36 +0800

1. update page to folio in comment
2. add comment of new added @locked

Link: https://lkml.kernel.org/r/20230718092136.1935789-1-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/rmap.c~mm-rmap-correct-stale-comment-of-rmap_walk_anon-and-rmap_walk_file
+++ a/mm/rmap.c
@@ -2397,11 +2397,12 @@ out:
 /*
  * rmap_walk_anon - do something to anonymous page using the object-based
  * rmap method
- * @page: the page to be handled
+ * @folio: the folio to be handled
  * @rwc: control variable according to each walk type
+ * @locked: caller holds relevant rmap lock
  *
- * Find all the mappings of a page using the mapping pointer and the vma chains
- * contained in the anon_vma struct it points to.
+ * Find all the mappings of a folio using the mapping pointer and the vma
+ * chains contained in the anon_vma struct it points to.
  */
 static void rmap_walk_anon(struct folio *folio,
 		struct rmap_walk_control *rwc, bool locked)
@@ -2445,10 +2446,11 @@ static void rmap_walk_anon(struct folio
 
 /*
  * rmap_walk_file - do something to file page using the object-based rmap method
- * @page: the page to be handled
+ * @folio: the folio to be handled
  * @rwc: control variable according to each walk type
+ * @locked: caller holds relevant rmap lock
  *
- * Find all the mappings of a page using the mapping pointer and the vma chains
+ * Find all the mappings of a folio using the mapping pointer and the vma chains
  * contained in the address_space struct it points to.
  */
 static void rmap_walk_file(struct folio *folio,
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-page_ext-add-common-function-to-get-client-data-from-page_ext.patch
mm-page_ext-use-page_ext_data-helper-in-page_table_check.patch
mm-page_ext-use-page_ext_data-helper-in-page_owner.patch
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
mm-compaction-remove-unused-parameter-pgdata-of-fragmentation_score_wmark.patch
mm-page_alloc-remove-unnecessary-inner-__get_pfnblock_flags_mask.patch
mm-page_alloc-use-get_pfnblock_migratetype-to-avoid-extra-page_to_pfn.patch


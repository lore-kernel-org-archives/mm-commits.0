Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2298CC636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbjBCGke (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbjBCGjc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:39:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AACF8EB6C
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4F5C61DA5
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49539C4339E;
        Fri,  3 Feb 2023 06:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406225;
        bh=G6i5wIj64MRKaVOtWbxDEVvn9mnai772UbBGGEozIFI=;
        h=Date:To:From:Subject:From;
        b=ZtONSX/SqBgb/0UoZ8jMonbggDrCSH5AhIRTjmqQSXzo+VXqrlhNdIvtdQu+wI3V2
         7QrhuIRvwOcX4eYhmIQTiKJxEvxvxFl6WVEgPYKuvR1tMpAN7diiBDbfQzXMYymTQC
         wwy+2+DknWjqqQnuKnHkCwAy/P7fxjZmEVXD7r7k=
Date:   Thu, 02 Feb 2023 22:37:04 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-convert-__filemap_fdatawait_range-to-use-filemap_get_folios_tag.patch removed from -mm tree
Message-Id: <20230203063705.49539C4339E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: filemap: convert __filemap_fdatawait_range() to use filemap_get_folios_tag()
has been removed from the -mm tree.  Its filename was
     filemap-convert-__filemap_fdatawait_range-to-use-filemap_get_folios_tag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: filemap: convert __filemap_fdatawait_range() to use filemap_get_folios_tag()
Date: Wed, 4 Jan 2023 13:14:28 -0800

Convert function to use folios.  This is in preparation for the removal of
find_get_pages_range_tag().  This change removes 2 calls to
compound_head().

Link: https://lkml.kernel.org/r/20230104211448.4804-4-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcow (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/filemap.c~filemap-convert-__filemap_fdatawait_range-to-use-filemap_get_folios_tag
+++ a/mm/filemap.c
@@ -503,25 +503,27 @@ static void __filemap_fdatawait_range(st
 {
 	pgoff_t index = start_byte >> PAGE_SHIFT;
 	pgoff_t end = end_byte >> PAGE_SHIFT;
-	struct pagevec pvec;
-	int nr_pages;
+	struct folio_batch fbatch;
+	unsigned nr_folios;
+
+	folio_batch_init(&fbatch);
 
-	pagevec_init(&pvec);
 	while (index <= end) {
 		unsigned i;
 
-		nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index,
-				end, PAGECACHE_TAG_WRITEBACK);
-		if (!nr_pages)
+		nr_folios = filemap_get_folios_tag(mapping, &index, end,
+				PAGECACHE_TAG_WRITEBACK, &fbatch);
+
+		if (!nr_folios)
 			break;
 
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
+		for (i = 0; i < nr_folios; i++) {
+			struct folio *folio = fbatch.folios[i];
 
-			wait_on_page_writeback(page);
-			ClearPageError(page);
+			folio_wait_writeback(folio);
+			folio_clear_error(folio);
 		}
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 		cond_resched();
 	}
 }
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-add-folio_estimated_sharers.patch
mm-mempolicy-convert-queue_pages_pmd-to-queue_folios_pmd.patch
mm-mempolicy-convert-queue_pages_pte_range-to-queue_folios_pte_range.patch
mm-mempolicy-convert-queue_pages_hugetlb-to-queue_folios_hugetlb.patch
mm-mempolicy-convert-queue_pages_required-to-queue_folio_required.patch
mm-mempolicy-convert-migrate_page_add-to-migrate_folio_add.patch
mm-add-folio_get_nontail_page.patch
mm-migrate-add-folio_movable_ops.patch
mm-migrate-convert-isolate_movable_page-to-use-folios.patch
mm-migrate-convert-putback_movable_pages-to-use-folios.patch


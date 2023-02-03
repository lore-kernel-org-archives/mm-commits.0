Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C110BC636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbjBCGgw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbjBCGgD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3208C411
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCBDD61DA6
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40845C4339E;
        Fri,  3 Feb 2023 06:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406161;
        bh=aj3Reo5QNNekFCm3zmX5RE9SoXzUFgzYS7dToakThdc=;
        h=Date:To:From:Subject:From;
        b=tSqje5lJSKoU4062NfdLeN3QIO6BbteqBaqaDD4SRqvP43GzglJFW/NrcrgiT3mfn
         rludMwM2qyYnaXuB30B/eoucX7NN8STA1oWRiXPtI+dRcrcGmdl2TVqM8i/3fnhIhs
         6bL+FtBQPVjdvcxaARxklwlN+ry6LDTt5XNHnUZE=
Date:   Thu, 02 Feb 2023 22:36:00 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-deferred_split_huge_page-to-deferred_split_folio.patch removed from -mm tree
Message-Id: <20230203063601.40845C4339E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert deferred_split_huge_page() to deferred_split_folio()
has been removed from the -mm tree.  Its filename was
     mm-convert-deferred_split_huge_page-to-deferred_split_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert deferred_split_huge_page() to deferred_split_folio()
Date: Wed, 11 Jan 2023 14:29:13 +0000

Now that both callers use a folio, pass the folio in and save a call to
compound_head().

Link: https://lkml.kernel.org/r/20230111142915.1001531-28-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/transhuge.rst~mm-convert-deferred_split_huge_page-to-deferred_split_folio
+++ a/Documentation/mm/transhuge.rst
@@ -153,8 +153,8 @@ clear where references should go after s
 Note that split_huge_pmd() doesn't have any limitations on refcounting:
 pmd can be split at any point and never fails.
 
-Partial unmap and deferred_split_huge_page()
-============================================
+Partial unmap and deferred_split_folio()
+========================================
 
 Unmapping part of THP (with munmap() or other way) is not going to free
 memory immediately. Instead, we detect that a subpage of THP is not in use
@@ -166,6 +166,6 @@ the place where we can detect partial un
 counterproductive since in many cases partial unmap happens during exit(2) if
 a THP crosses a VMA boundary.
 
-The function deferred_split_huge_page() is used to queue a page for splitting.
+The function deferred_split_folio() is used to queue a folio for splitting.
 The splitting itself will happen when we get memory pressure via shrinker
 interface.
--- a/include/linux/huge_mm.h~mm-convert-deferred_split_huge_page-to-deferred_split_folio
+++ a/include/linux/huge_mm.h
@@ -187,7 +187,7 @@ static inline int split_huge_page(struct
 {
 	return split_huge_page_to_list(page, NULL);
 }
-void deferred_split_huge_page(struct page *page);
+void deferred_split_folio(struct folio *folio);
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze, struct folio *folio);
@@ -340,7 +340,7 @@ static inline int split_huge_page(struct
 {
 	return 0;
 }
-static inline void deferred_split_huge_page(struct page *page) {}
+static inline void deferred_split_folio(struct folio *folio) {}
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
 
--- a/mm/huge_memory.c~mm-convert-deferred_split_huge_page-to-deferred_split_folio
+++ a/mm/huge_memory.c
@@ -2815,9 +2815,8 @@ void free_transhuge_page(struct page *pa
 	free_compound_page(page);
 }
 
-void deferred_split_huge_page(struct page *page)
+void deferred_split_folio(struct folio *folio)
 {
-	struct folio *folio = page_folio(page);
 	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
 #ifdef CONFIG_MEMCG
 	struct mem_cgroup *memcg = folio_memcg(folio);
--- a/mm/rmap.c~mm-convert-deferred_split_huge_page-to-deferred_split_folio
+++ a/mm/rmap.c
@@ -1427,7 +1427,7 @@ void page_remove_rmap(struct page *page,
 		 */
 		if (folio_test_pmd_mappable(folio) && folio_test_anon(folio))
 			if (!compound || nr < nr_pmdmapped)
-				deferred_split_huge_page(&folio->page);
+				deferred_split_folio(folio);
 	}
 
 	/*
_

Patches currently in -mm which might be from willy@infradead.org are



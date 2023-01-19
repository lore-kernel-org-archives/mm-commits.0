Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 004A4C38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjASBV7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjASBT6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:19:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C0B69B0F
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6ED7C61B16
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D93C433EF;
        Thu, 19 Jan 2023 01:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090997;
        bh=0JIYPn3ud2M8pREf/BRm011oBmeE8Gmz6BfFd6YYjjY=;
        h=Date:To:From:Subject:From;
        b=c2XkOjSzxayikH+S2uybX+byVOVhnWmhpS3CeIbJrKNpvVizr7Dx2qLEZng+HhZbg
         lJB7pMLfUrFY/7Rgbp6n0ZXBbam1osKNN/mbiZkfWayzoY28acbEfzNWXM8GTIO4Qf
         UcBXqwTaViJ2Jlka7vEvw0GcQHr/EZCYy1gHd5u0=
Date:   Wed, 18 Jan 2023 17:16:37 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        sj@kernel.org, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-folio_is_pfmemalloc.patch removed from -mm tree
Message-Id: <20230119011637.C5D93C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: introduce folio_is_pfmemalloc
has been removed from the -mm tree.  Its filename was
     mm-introduce-folio_is_pfmemalloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm: introduce folio_is_pfmemalloc
Date: Fri, 6 Jan 2023 15:52:51 -0600

Add a folio equivalent for page_is_pfmemalloc. This removes two instances
of page_is_pfmemalloc(folio_page(folio, 0)) so the folio can be used
directly.

Link: https://lkml.kernel.org/r/20230106215251.599222-1-sidhartha.kumar@oracle.com
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   15 +++++++++++++++
 mm/slab.c          |    2 +-
 mm/slub.c          |    2 +-
 3 files changed, 17 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-introduce-folio_is_pfmemalloc
+++ a/include/linux/mm.h
@@ -1927,6 +1927,21 @@ static inline bool page_is_pfmemalloc(co
 }
 
 /*
+ * Return true only if the folio has been allocated with
+ * ALLOC_NO_WATERMARKS and the low watermark was not
+ * met implying that the system is under some pressure.
+ */
+static inline bool folio_is_pfmemalloc(const struct folio *folio)
+{
+	/*
+	 * lru.next has bit 1 set if the page is allocated from the
+	 * pfmemalloc reserves.  Callers may simply overwrite it if
+	 * they do not need to preserve that information.
+	 */
+	return (uintptr_t)folio->lru.next & BIT(1);
+}
+
+/*
  * Only to be called by the page allocator on a freshly allocated
  * page.
  */
--- a/mm/slab.c~mm-introduce-folio_is_pfmemalloc
+++ a/mm/slab.c
@@ -1373,7 +1373,7 @@ static struct slab *kmem_getpages(struct
 	/* Make the flag visible before any changes to folio->mapping */
 	smp_wmb();
 	/* Record if ALLOC_NO_WATERMARKS was set when allocating the slab */
-	if (sk_memalloc_socks() && page_is_pfmemalloc(folio_page(folio, 0)))
+	if (sk_memalloc_socks() && folio_is_pfmemalloc(folio))
 		slab_set_pfmemalloc(slab);
 
 	return slab;
--- a/mm/slub.c~mm-introduce-folio_is_pfmemalloc
+++ a/mm/slub.c
@@ -1859,7 +1859,7 @@ static inline struct slab *alloc_slab_pa
 	__folio_set_slab(folio);
 	/* Make the flag visible before any changes to folio->mapping */
 	smp_wmb();
-	if (page_is_pfmemalloc(folio_page(folio, 0)))
+	if (folio_is_pfmemalloc(folio))
 		slab_set_pfmemalloc(slab);
 
 	return slab;
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-remove-the-hugetlb-field-from-struct-page.patch
mm-memory-failure-convert-__get_huge_page_for_hwpoison-to-folios.patch
mm-memory-failure-convert-try_memory_failure_hugetlb-to-folios.patch
mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios.patch
mm-memory-failure-convert-free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-raw_hwp_list_head-to-folios.patch
mm-memory-failure-convert-__free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-hugetlb_set_page_hwpoison-to-folios.patch
mm-memory-failure-convert-unpoison_memory-to-folios.patch
mm-hugetlb-convert-isolate_hugetlb-to-folios.patch
mm-hugetlb-convert-__update_and_free_page-to-folios.patch
mm-hugetlb-convert-dequeue_hugetlb_page-functions-to-folios.patch
mm-hugetlb-convert-alloc_surplus_huge_page-to-folios.patch
mm-hugetlb-increase-use-of-folios-in-alloc_huge_page.patch
mm-hugetlb-convert-alloc_migrate_huge_page-to-folios.patch
mm-hugetlb-convert-restore_reserve_on_error-to-folios.patch
mm-hugetlb-convert-demote_free_huge_page-to-folios.patch
mm-hugetlb-convert-get_hwpoison_huge_page-to-folios.patch


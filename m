Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304D0C77B73
	for <mm-commits@archiver.kernel.org>; Sun, 16 Apr 2023 18:46:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjDPSqm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Apr 2023 14:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDPSqm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Apr 2023 14:46:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61EF106
        for <mm-commits@vger.kernel.org>; Sun, 16 Apr 2023 11:46:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5280C60F5A
        for <mm-commits@vger.kernel.org>; Sun, 16 Apr 2023 18:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A756EC433D2;
        Sun, 16 Apr 2023 18:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681670799;
        bh=IfHCRYvASU6oIXnptMGplKHX0Bn0frvnwxKYtqekcRs=;
        h=Date:To:From:Subject:From;
        b=0G3UxmGH4kVv3or1ERB/N1gSnS65D66GK4zLRZmvf5WG1vLtCKI2asuHhuaCVonTg
         QTOTRIT3k+a6Alv6ydYtV/oIrH61SKv0rloJya1U+JQ2+ciW8iSu0BEeLaVahUz4Q7
         JXaMzOcn1X1wiRf9o1zcez05iwhfhAwuElUzeL7E=
Date:   Sun, 16 Apr 2023 11:46:39 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, yuzhao@google.com,
        willy@infradead.org, shy828301@gmail.com, ryan.roberts@arm.com,
        roman.gushchin@linux.dev, mkoutny@suse.com,
        kirill.shutemov@linux.intel.com, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memcg-use-order-instead-of-nr-in-split_page_memcg.patch removed from -mm tree
Message-Id: <20230416184639.A756EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcg: use order instead of nr in split_page_memcg()
has been removed from the -mm tree.  Its filename was
     mm-memcg-use-order-instead-of-nr-in-split_page_memcg.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/memcg: use order instead of nr in split_page_memcg()
Date: Mon, 3 Apr 2023 16:18:33 -0400

Patch series "Split a folio to any lower order folios", v3.

File folio supports any order and people would like to support flexible
orders for anonymous folio[1] too.  Currently, split_huge_page() only
splits a huge page to order-0 pages, but splitting to orders higher than 0
is also useful.  This patchset adds support for splitting a huge page to
any lower order pages and uses it during file folio truncate operations.


This patch (of 7):

We do not have non power of two pages, using nr is error prone if nr is
not power-of-two.  Use page order instead.

Link: https://lkml.kernel.org/r/20230403201839.4097845-1-zi.yan@sent.com
Link: https://lkml.kernel.org/r/20230403201839.4097845-2-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/huge_memory.c           |    3 ++-
 mm/memcontrol.c            |    3 ++-
 mm/page_alloc.c            |    4 ++--
 4 files changed, 8 insertions(+), 6 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-use-order-instead-of-nr-in-split_page_memcg
+++ a/include/linux/memcontrol.h
@@ -1152,7 +1152,7 @@ static inline void memcg_memory_event_mm
 	rcu_read_unlock();
 }
 
-void split_page_memcg(struct page *head, unsigned int nr);
+void split_page_memcg(struct page *head, int order);
 
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 						gfp_t gfp_mask,
@@ -1593,7 +1593,7 @@ void count_memcg_event_mm(struct mm_stru
 {
 }
 
-static inline void split_page_memcg(struct page *head, unsigned int nr)
+static inline void split_page_memcg(struct page *head, int order)
 {
 }
 
--- a/mm/huge_memory.c~mm-memcg-use-order-instead-of-nr-in-split_page_memcg
+++ a/mm/huge_memory.c
@@ -2520,10 +2520,11 @@ static void __split_huge_page(struct pag
 	struct address_space *swap_cache = NULL;
 	unsigned long offset = 0;
 	unsigned int nr = thp_nr_pages(head);
+	int order = folio_order(folio);
 	int i;
 
 	/* complete memcg works before add pages to LRU */
-	split_page_memcg(head, nr);
+	split_page_memcg(head, order);
 
 	if (PageAnon(head) && PageSwapCache(head)) {
 		swp_entry_t entry = { .val = page_private(head) };
--- a/mm/memcontrol.c~mm-memcg-use-order-instead-of-nr-in-split_page_memcg
+++ a/mm/memcontrol.c
@@ -3441,11 +3441,12 @@ void obj_cgroup_uncharge(struct obj_cgro
 /*
  * Because page_memcg(head) is not set on tails, set it now.
  */
-void split_page_memcg(struct page *head, unsigned int nr)
+void split_page_memcg(struct page *head, int order)
 {
 	struct folio *folio = page_folio(head);
 	struct mem_cgroup *memcg = folio_memcg(folio);
 	int i;
+	unsigned int nr = 1 << order;
 
 	if (mem_cgroup_disabled() || !memcg)
 		return;
--- a/mm/page_alloc.c~mm-memcg-use-order-instead-of-nr-in-split_page_memcg
+++ a/mm/page_alloc.c
@@ -2781,7 +2781,7 @@ void split_page(struct page *page, unsig
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
 	split_page_owner(page, 1 << order);
-	split_page_memcg(page, 1 << order);
+	split_page_memcg(page, order);
 }
 EXPORT_SYMBOL_GPL(split_page);
 
@@ -4997,7 +4997,7 @@ static void *make_alloc_exact(unsigned l
 		struct page *last = page + nr;
 
 		split_page_owner(page, 1 << order);
-		split_page_memcg(page, 1 << order);
+		split_page_memcg(page, order);
 		while (page < --last)
 			set_page_refcounted(last);
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_owner-use-order-instead-of-nr-in-split_page_owner.patch
mm-memcg-make-memcg-huge-page-split-support-any-order-split.patch
mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner.patch
mm-thp-split-huge-page-to-any-lower-order-pages.patch
mm-truncate-split-huge-page-cache-page-to-a-non-zero-order-if-possible.patch
mm-huge_memory-enable-debugfs-to-split-huge-pages-to-any-order.patch


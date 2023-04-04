Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 969C2C6FD1D
	for <mm-commits@archiver.kernel.org>; Tue,  4 Apr 2023 21:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236274AbjDDVo4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Apr 2023 17:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235754AbjDDVo4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2023 17:44:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5374214
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 14:44:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67B44634C2
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 21:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70C1C433EF;
        Tue,  4 Apr 2023 21:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680644693;
        bh=lcQ0JCdr4b/OKqM04rocC/plnwviS1wsQY6esREHvdQ=;
        h=Date:To:From:Subject:From;
        b=GEZwkLeQAqDzvCn1lMtqyZoFlqkh9VLC32BcFMCum/39QOMNZnwlZ+UpuzCuc9Zqy
         X+KM0Vo5hMECMOzO0Eqz5xVLWgV0F17WNmyOeHQAV6Ta48gaoA9p/iNgxoqc8Ad8rq
         o0/ZlFVMLlbQWSCyOQwPrHqHtY+D7H/PkJ3LFbgE=
Date:   Tue, 04 Apr 2023 14:44:53 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, yuzhao@google.com,
        willy@infradead.org, shy828301@gmail.com, ryan.roberts@arm.com,
        roman.gushchin@linux.dev, mkoutny@suse.com,
        kirill.shutemov@linux.intel.com, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-use-order-instead-of-nr-in-split_page_memcg.patch added to mm-unstable branch
Message-Id: <20230404214453.B70C1C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: use order instead of nr in split_page_memcg()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-use-order-instead-of-nr-in-split_page_memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-use-order-instead-of-nr-in-split_page_memcg.patch

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
@@ -2512,10 +2512,11 @@ static void __split_huge_page(struct pag
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

mm-memcg-use-order-instead-of-nr-in-split_page_memcg.patch
mm-page_owner-use-order-instead-of-nr-in-split_page_owner.patch
mm-memcg-make-memcg-huge-page-split-support-any-order-split.patch
mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner.patch
mm-thp-split-huge-page-to-any-lower-order-pages.patch
mm-truncate-split-huge-page-cache-page-to-a-non-zero-order-if-possible.patch
mm-huge_memory-enable-debugfs-to-split-huge-pages-to-any-order.patch


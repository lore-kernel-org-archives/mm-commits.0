Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1027C761A6
	for <mm-commits@archiver.kernel.org>; Tue,  4 Apr 2023 21:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236515AbjDDVpJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Apr 2023 17:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236538AbjDDVpH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2023 17:45:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C78468F
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 14:45:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DAD1634C2
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 21:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638A0C433D2;
        Tue,  4 Apr 2023 21:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680644701;
        bh=JgaGu/rvUAyyyH6Eo+Br6uevWuAIFxN/Knk1qL/bs8Q=;
        h=Date:To:From:Subject:From;
        b=YnykuxZ6ck+lVxH1Fm/ncMwmnQl4DXCJb4nZbVCJmnxw5a3oWBSUX/RwNw8ziaP1y
         APlD9DfiekkAq8dzVFncPcRWJekn7etI9TtsONC4VQ9HzGmZY/vRIIDCSA8ppJKwH6
         ZHRcWvn2R71RBuPUQ5iMx5bWtJQBKFg7l3L3ztBg=
Date:   Tue, 04 Apr 2023 14:45:00 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, yuzhao@google.com,
        willy@infradead.org, shy828301@gmail.com, ryan.roberts@arm.com,
        roman.gushchin@linux.dev, mkoutny@suse.com,
        kirill.shutemov@linux.intel.com, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner.patch added to mm-unstable branch
Message-Id: <20230404214501.638A0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_owner: add support for splitting to any order in split page_owner
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner.patch

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
Subject: mm: page_owner: add support for splitting to any order in split page_owner
Date: Mon, 3 Apr 2023 16:18:36 -0400

It adds a new_order parameter to set new page order in page owner.  It
prepares for upcoming changes to support split huge page to any lower
order.

Link: https://lkml.kernel.org/r/20230403201839.4097845-5-zi.yan@sent.com
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

 include/linux/page_owner.h |   10 +++++-----
 mm/huge_memory.c           |    2 +-
 mm/page_alloc.c            |    4 ++--
 mm/page_owner.c            |    9 +++++----
 4 files changed, 13 insertions(+), 12 deletions(-)

--- a/include/linux/page_owner.h~mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner
+++ a/include/linux/page_owner.h
@@ -11,7 +11,7 @@ extern struct page_ext_operations page_o
 extern void __reset_page_owner(struct page *page, unsigned short order);
 extern void __set_page_owner(struct page *page,
 			unsigned short order, gfp_t gfp_mask);
-extern void __split_page_owner(struct page *page, int order);
+extern void __split_page_owner(struct page *page, int old_order, int new_order);
 extern void __folio_copy_owner(struct folio *newfolio, struct folio *old);
 extern void __set_page_owner_migrate_reason(struct page *page, int reason);
 extern void __dump_page_owner(const struct page *page);
@@ -31,10 +31,10 @@ static inline void set_page_owner(struct
 		__set_page_owner(page, order, gfp_mask);
 }
 
-static inline void split_page_owner(struct page *page, int order)
+static inline void split_page_owner(struct page *page, int old_order, int new_order)
 {
 	if (static_branch_unlikely(&page_owner_inited))
-		__split_page_owner(page, order);
+		__split_page_owner(page, old_order, new_order);
 }
 static inline void folio_copy_owner(struct folio *newfolio, struct folio *old)
 {
@@ -56,11 +56,11 @@ static inline void reset_page_owner(stru
 {
 }
 static inline void set_page_owner(struct page *page,
-			unsigned int order, gfp_t gfp_mask)
+			unsigned short order, gfp_t gfp_mask)
 {
 }
 static inline void split_page_owner(struct page *page,
-			int order)
+			int old_order, int new_order)
 {
 }
 static inline void folio_copy_owner(struct folio *newfolio, struct folio *folio)
--- a/mm/huge_memory.c~mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner
+++ a/mm/huge_memory.c
@@ -2557,7 +2557,7 @@ static void __split_huge_page(struct pag
 	unlock_page_lruvec(lruvec);
 	/* Caller disabled irqs, so they are still disabled here */
 
-	split_page_owner(head, order);
+	split_page_owner(head, order, 0);
 
 	/* See comment in __split_huge_page_tail() */
 	if (PageAnon(head)) {
--- a/mm/page_alloc.c~mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner
+++ a/mm/page_alloc.c
@@ -2780,7 +2780,7 @@ void split_page(struct page *page, unsig
 
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
-	split_page_owner(page, order);
+	split_page_owner(page, order, 0);
 	split_page_memcg(page, order, 0);
 }
 EXPORT_SYMBOL_GPL(split_page);
@@ -4996,7 +4996,7 @@ static void *make_alloc_exact(unsigned l
 		struct page *page = virt_to_page((void *)addr);
 		struct page *last = page + nr;
 
-		split_page_owner(page, order);
+		split_page_owner(page, order, 0);
 		split_page_memcg(page, order, 0);
 		while (page < --last)
 			set_page_refcounted(last);
--- a/mm/page_owner.c~mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner
+++ a/mm/page_owner.c
@@ -211,19 +211,20 @@ void __set_page_owner_migrate_reason(str
 	page_ext_put(page_ext);
 }
 
-void __split_page_owner(struct page *page, int order)
+void __split_page_owner(struct page *page, int old_order, int new_order)
 {
 	int i;
 	struct page_ext *page_ext = page_ext_get(page);
 	struct page_owner *page_owner;
-	unsigned int nr = 1 << order;
+	unsigned int old_nr = 1 << old_order;
+	unsigned int new_nr = 1 << new_order;
 
 	if (unlikely(!page_ext))
 		return;
 
-	for (i = 0; i < nr; i++) {
+	for (i = 0; i < old_nr; i += new_nr) {
 		page_owner = get_page_owner(page_ext);
-		page_owner->order = 0;
+		page_owner->order = new_order;
 		page_ext = page_ext_next(page_ext);
 	}
 	page_ext_put(page_ext);
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-memcg-use-order-instead-of-nr-in-split_page_memcg.patch
mm-page_owner-use-order-instead-of-nr-in-split_page_owner.patch
mm-memcg-make-memcg-huge-page-split-support-any-order-split.patch
mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner.patch
mm-thp-split-huge-page-to-any-lower-order-pages.patch
mm-truncate-split-huge-page-cache-page-to-a-non-zero-order-if-possible.patch
mm-huge_memory-enable-debugfs-to-split-huge-pages-to-any-order.patch


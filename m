Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 179F1C6FD1D
	for <mm-commits@archiver.kernel.org>; Tue,  4 Apr 2023 21:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235754AbjDDVpB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Apr 2023 17:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236473AbjDDVo7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2023 17:44:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63ACD4214
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 14:44:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E67E1634C2
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 21:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1ABC433D2;
        Tue,  4 Apr 2023 21:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680644696;
        bh=UUU1LUifjX/UzLgUBe9dh3m2CIYQHNRn3CTLyWOLj3I=;
        h=Date:To:From:Subject:From;
        b=Ga3Neu2DYv8mwnPForbw9AY4JZr+pRq/MkoJtW5m29YqrLFhSYZxK3TRKfk74Cn0J
         vHGHUk2yOFIIprNCa8nsnSc4TDqmWAH1ms2cQ935l+6pNR7p5SFvR4qroPXeRx/H7n
         bG9h4FR+Qe1mLM8ZNMXpgj/KP/Uv6K11IaAQEmw8=
Date:   Tue, 04 Apr 2023 14:44:55 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, yuzhao@google.com,
        willy@infradead.org, shy828301@gmail.com, ryan.roberts@arm.com,
        roman.gushchin@linux.dev, mkoutny@suse.com,
        kirill.shutemov@linux.intel.com, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-use-order-instead-of-nr-in-split_page_owner.patch added to mm-unstable branch
Message-Id: <20230404214456.4D1ABC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: use order instead of nr in split_page_owner()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_owner-use-order-instead-of-nr-in-split_page_owner.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-use-order-instead-of-nr-in-split_page_owner.patch

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
Subject: mm/page_owner: use order instead of nr in split_page_owner()
Date: Mon, 3 Apr 2023 16:18:34 -0400

We do not have non power of two pages, using nr is error prone if nr is
not power-of-two.  Use page order instead.

Link: https://lkml.kernel.org/r/20230403201839.4097845-3-zi.yan@sent.com
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

 include/linux/page_owner.h |    8 ++++----
 mm/huge_memory.c           |    2 +-
 mm/page_alloc.c            |    4 ++--
 mm/page_owner.c            |    3 ++-
 4 files changed, 9 insertions(+), 8 deletions(-)

--- a/include/linux/page_owner.h~mm-page_owner-use-order-instead-of-nr-in-split_page_owner
+++ a/include/linux/page_owner.h
@@ -11,7 +11,7 @@ extern struct page_ext_operations page_o
 extern void __reset_page_owner(struct page *page, unsigned short order);
 extern void __set_page_owner(struct page *page,
 			unsigned short order, gfp_t gfp_mask);
-extern void __split_page_owner(struct page *page, unsigned int nr);
+extern void __split_page_owner(struct page *page, int order);
 extern void __folio_copy_owner(struct folio *newfolio, struct folio *old);
 extern void __set_page_owner_migrate_reason(struct page *page, int reason);
 extern void __dump_page_owner(const struct page *page);
@@ -31,10 +31,10 @@ static inline void set_page_owner(struct
 		__set_page_owner(page, order, gfp_mask);
 }
 
-static inline void split_page_owner(struct page *page, unsigned int nr)
+static inline void split_page_owner(struct page *page, int order)
 {
 	if (static_branch_unlikely(&page_owner_inited))
-		__split_page_owner(page, nr);
+		__split_page_owner(page, order);
 }
 static inline void folio_copy_owner(struct folio *newfolio, struct folio *old)
 {
@@ -60,7 +60,7 @@ static inline void set_page_owner(struct
 {
 }
 static inline void split_page_owner(struct page *page,
-			unsigned short order)
+			int order)
 {
 }
 static inline void folio_copy_owner(struct folio *newfolio, struct folio *folio)
--- a/mm/huge_memory.c~mm-page_owner-use-order-instead-of-nr-in-split_page_owner
+++ a/mm/huge_memory.c
@@ -2557,7 +2557,7 @@ static void __split_huge_page(struct pag
 	unlock_page_lruvec(lruvec);
 	/* Caller disabled irqs, so they are still disabled here */
 
-	split_page_owner(head, nr);
+	split_page_owner(head, order);
 
 	/* See comment in __split_huge_page_tail() */
 	if (PageAnon(head)) {
--- a/mm/page_alloc.c~mm-page_owner-use-order-instead-of-nr-in-split_page_owner
+++ a/mm/page_alloc.c
@@ -2780,7 +2780,7 @@ void split_page(struct page *page, unsig
 
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
-	split_page_owner(page, 1 << order);
+	split_page_owner(page, order);
 	split_page_memcg(page, order);
 }
 EXPORT_SYMBOL_GPL(split_page);
@@ -4996,7 +4996,7 @@ static void *make_alloc_exact(unsigned l
 		struct page *page = virt_to_page((void *)addr);
 		struct page *last = page + nr;
 
-		split_page_owner(page, 1 << order);
+		split_page_owner(page, order);
 		split_page_memcg(page, order);
 		while (page < --last)
 			set_page_refcounted(last);
--- a/mm/page_owner.c~mm-page_owner-use-order-instead-of-nr-in-split_page_owner
+++ a/mm/page_owner.c
@@ -211,11 +211,12 @@ void __set_page_owner_migrate_reason(str
 	page_ext_put(page_ext);
 }
 
-void __split_page_owner(struct page *page, unsigned int nr)
+void __split_page_owner(struct page *page, int order)
 {
 	int i;
 	struct page_ext *page_ext = page_ext_get(page);
 	struct page_owner *page_owner;
+	unsigned int nr = 1 << order;
 
 	if (unlikely(!page_ext))
 		return;
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-memcg-use-order-instead-of-nr-in-split_page_memcg.patch
mm-page_owner-use-order-instead-of-nr-in-split_page_owner.patch
mm-memcg-make-memcg-huge-page-split-support-any-order-split.patch
mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner.patch
mm-thp-split-huge-page-to-any-lower-order-pages.patch
mm-truncate-split-huge-page-cache-page-to-a-non-zero-order-if-possible.patch
mm-huge_memory-enable-debugfs-to-split-huge-pages-to-any-order.patch


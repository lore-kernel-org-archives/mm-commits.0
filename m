Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D41A5C7619A
	for <mm-commits@archiver.kernel.org>; Wed,  5 Apr 2023 20:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjDEUCH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 16:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjDEUCG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 16:02:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B654699
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 13:01:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9402E63EC0
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00D0C4339E;
        Wed,  5 Apr 2023 20:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680724835;
        bh=YPwXKcgyLlSf8KFlvM303Xz4XU35F/IwaHE2nKye6ys=;
        h=Date:To:From:Subject:From;
        b=a2a2KEh0RAhr/X6J1hYEX1x5D7oZxGJf/M5HIy3gDUNQTurIiQE8rI7V3hThpVMvH
         PHnCStp5a6M+TzZxLAH7CU/YUI2Vc2kfe3gjNJoEOMvBlPADq5FJobzVAGjEB3ymdp
         Lsewm1ET1kt5W78Hc1Bl2yyaDzRx5aCVwF9prrpw=
Date:   Wed, 05 Apr 2023 13:00:35 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        keescook@chromium.org, halbuer@sra.uni-hannover.de, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-use-check_pages_enabled-static-key-to-check-tail-pages.patch added to mm-unstable branch
Message-Id: <20230405200035.C00D0C4339E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: use check_pages_enabled static key to check tail pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-use-check_pages_enabled-static-key-to-check-tail-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-use-check_pages_enabled-static-key-to-check-tail-pages.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: use check_pages_enabled static key to check tail pages
Date: Wed, 5 Apr 2023 16:28:40 +0200

Commit 700d2e9a36b9 ("mm, page_alloc: reduce page alloc/free sanity
checks") has introduced a new static key check_pages_enabled to control
when struct pages are sanity checked during allocation and freeing.  Mel
Gorman suggested that free_tail_pages_check() could use this static key as
well, instead of relying on CONFIG_DEBUG_VM.  That makes sense, so do
that.  Also rename the function to free_tail_page_prepare() because it
works on a single tail page and has a struct page preparation component as
well as the optional checking component.

Also remove some unnecessary unlikely() within static_branch_unlikely()
statements that Mel pointed out for commit 700d2e9a36b9.

Link: https://lkml.kernel.org/r/20230405142840.11068-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Suggested-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Alexander Halbuer <halbuer@sra.uni-hannover.de>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    2 +-
 mm/page_alloc.c      |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-page_alloc-use-check_pages_enabled-static-key-to-check-tail-pages
+++ a/mm/hugetlb_vmemmap.c
@@ -264,7 +264,7 @@ static void vmemmap_remap_pte(pte_t *pte
  * How many struct page structs need to be reset. When we reuse the head
  * struct page, the special metadata (e.g. page->flags or page->mapping)
  * cannot copy to the tail struct page structs. The invalid value will be
- * checked in the free_tail_pages_check(). In order to avoid the message
+ * checked in the free_tail_page_prepare(). In order to avoid the message
  * of "corrupted mapping in tail page". We need to reset at least 3 (one
  * head struct page struct and two tail struct page structs) struct page
  * structs.
--- a/mm/page_alloc.c~mm-page_alloc-use-check_pages_enabled-static-key-to-check-tail-pages
+++ a/mm/page_alloc.c
@@ -1131,7 +1131,7 @@ static inline bool free_page_is_bad(stru
 	return true;
 }
 
-static int free_tail_pages_check(struct page *head_page, struct page *page)
+static int free_tail_page_prepare(struct page *head_page, struct page *page)
 {
 	struct folio *folio = (struct folio *)head_page;
 	int ret = 1;
@@ -1142,7 +1142,7 @@ static int free_tail_pages_check(struct
 	 */
 	BUILD_BUG_ON((unsigned long)LIST_POISON1 & 1);
 
-	if (!IS_ENABLED(CONFIG_DEBUG_VM)) {
+	if (!static_branch_unlikely(&check_pages_enabled)) {
 		ret = 0;
 		goto out;
 	}
@@ -1276,9 +1276,9 @@ static __always_inline bool free_pages_p
 			ClearPageHasHWPoisoned(page);
 		for (i = 1; i < (1 << order); i++) {
 			if (compound)
-				bad += free_tail_pages_check(page, page + i);
+				bad += free_tail_pages_prepare(page, page + i);
 			if (is_check_pages_enabled()) {
-				if (unlikely(free_page_is_bad(page + i))) {
+				if (free_page_is_bad(page + i)) {
 					bad++;
 					continue;
 				}
@@ -1627,7 +1627,7 @@ static inline bool check_new_pages(struc
 		for (int i = 0; i < (1 << order); i++) {
 			struct page *p = page + i;
 
-			if (unlikely(check_new_page(p)))
+			if (check_new_page(p))
 				return true;
 		}
 	}
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-mmap-vma_merge-use-only-primary-pointers-for-preparing-merge.patch
mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-3.patch
mm-mmap-vma_merge-use-the-proper-vma-pointers-in-cases-1-and-6.patch
mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-4.patch
mm-mmap-vma_merge-initialize-mid-and-next-in-natural-order.patch
mm-mmap-vma_merge-set-mid-to-null-if-not-applicable.patch
mm-mmap-vma_merge-set-mid-to-null-if-not-applicable-fix.patch
mm-mmap-vma_merge-rename-adj_next-to-adj_start.patch
mm-mmap-vma_merge-convert-mergeability-checks-to-return-bool.patch
mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test.patch
mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test-fix.patch
mm-mremap-simplify-vma-expansion-again.patch
mm-page_alloc-use-check_pages_enabled-static-key-to-check-tail-pages.patch


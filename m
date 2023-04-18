Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4370CC6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjDRXfz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbjDRXev (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85583AF16
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1814C62EE4
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DDEBC433D2;
        Tue, 18 Apr 2023 23:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860866;
        bh=NpN1eOfBbKdfTZ+0GVvCVevBHlUY/kdDcxutx2M7aGg=;
        h=Date:To:From:Subject:From;
        b=w3NHraqIgBBa2R4zHtj4BwCyrEm0+X+/prvhYwUiYWjfFPvR85mWdYTxu1TevV419
         PhWPMCEv1ii1B3FN33NnScoQ1DVO16HKFEDzhWwrfIjkNAvTOjguilIBKe75i61OyW
         OBta6Ff4wFc/gQLM/aGpS8BiLKJSO00QJUm/xRYA=
Date:   Tue, 18 Apr 2023 16:34:25 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        keescook@chromium.org, halbuer@sra.uni-hannover.de, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-use-check_pages_enabled-static-key-to-check-tail-pages.patch removed from -mm tree
Message-Id: <20230418233426.6DDEBC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, page_alloc: use check_pages_enabled static key to check tail pages
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-check_pages_enabled-static-key-to-check-tail-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
+				bad += free_tail_page_prepare(page, page + i);
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



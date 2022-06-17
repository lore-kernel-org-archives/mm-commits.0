Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A02CCA479
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 23:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382080AbiFQXCE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 19:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381999AbiFQXB6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 19:01:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630DA633AB
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 16:01:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 181FFB82C04
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 23:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80F3C3411B;
        Fri, 17 Jun 2022 23:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655506914;
        bh=t3sA5ve0sMwnWq5bL9PvXf1xCSYFJjrk4gxpMcKdMYg=;
        h=Date:To:From:Subject:From;
        b=PN49u5lfwDtKqqOvfmmdzZIGaHMJdQ0dGv0sLNV53n4ADENx73Lf38wqvrdfgxH3/
         x779pnz84KwCcAFCp+GB90GUTmO4vZQZo077hZBvpapAnB01q+b/uDI8/gWk9OaxaM
         YemtdXWFNXRIxl6WX3qCzMkAZWvYpN7XaG2WPzPw=
Date:   Fri, 17 Jun 2022 16:01:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-convert-reclaim_pages-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20220617230154.A80F3C3411B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: convert reclaim_pages() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-convert-reclaim_pages-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-convert-reclaim_pages-to-use-a-folio.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/vmscan: convert reclaim_pages() to use a folio
Date: Fri, 17 Jun 2022 16:42:48 +0100

Remove a few hidden calls to compound_head, saving 76 bytes of text.

Link: https://lkml.kernel.org/r/20220617154248.700416-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-convert-reclaim_pages-to-use-a-folio
+++ a/mm/vmscan.c
@@ -2625,34 +2625,33 @@ static unsigned int reclaim_page_list(st
 	return nr_reclaimed;
 }
 
-unsigned long reclaim_pages(struct list_head *page_list)
+unsigned long reclaim_pages(struct list_head *folio_list)
 {
 	int nid;
 	unsigned int nr_reclaimed = 0;
-	LIST_HEAD(node_page_list);
-	struct page *page;
+	LIST_HEAD(node_folio_list);
 	unsigned int noreclaim_flag;
 
-	if (list_empty(page_list))
+	if (list_empty(folio_list))
 		return nr_reclaimed;
 
 	noreclaim_flag = memalloc_noreclaim_save();
 
-	nid = page_to_nid(lru_to_page(page_list));
+	nid = folio_nid(lru_to_folio(folio_list));
 	do {
-		page = lru_to_page(page_list);
+		struct folio *folio = lru_to_folio(folio_list);
 
-		if (nid == page_to_nid(page)) {
-			ClearPageActive(page);
-			list_move(&page->lru, &node_page_list);
+		if (nid == folio_nid(folio)) {
+			folio_clear_active(folio);
+			list_move(&folio->lru, &node_folio_list);
 			continue;
 		}
 
-		nr_reclaimed += reclaim_page_list(&node_page_list, NODE_DATA(nid));
-		nid = page_to_nid(lru_to_page(page_list));
-	} while (!list_empty(page_list));
+		nr_reclaimed += reclaim_page_list(&node_folio_list, NODE_DATA(nid));
+		nid = folio_nid(lru_to_folio(folio_list));
+	} while (!list_empty(folio_list));
 
-	nr_reclaimed += reclaim_page_list(&node_page_list, NODE_DATA(nid));
+	nr_reclaimed += reclaim_page_list(&node_folio_list, NODE_DATA(nid));
 
 	memalloc_noreclaim_restore(noreclaim_flag);
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch
mm-vmscan-convert-reclaim_clean_pages_from_list-to-folios.patch
mm-vmscan-convert-isolate_lru_pages-to-use-a-folio.patch
mm-vmscan-convert-move_pages_to_lru-to-use-a-folio.patch
mm-vmscan-convert-shrink_active_list-to-use-a-folio.patch
mm-vmscan-convert-reclaim_pages-to-use-a-folio.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A843CE936E7
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244744AbjJDUXS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245028AbjJDUWc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BA8E4
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:22:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30DBC433C7;
        Wed,  4 Oct 2023 20:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450945;
        bh=WMuNHatCURGm2CCHyFYhUlQLmCG8z63ahnD7W0MtDEk=;
        h=Date:To:From:Subject:From;
        b=Nbq9+xoYhfIlyGfkjTtrOX6MJ37IfMv+kkSIfo01yixn93L9VqLd/fnTi0wGZz3SJ
         2cqGT0D8dhivTsLbQqD/u4yZ9+6GKlvjFEwtKo40423xQKdkqGTfT1gGXf8FyhH4jA
         tatjPPQVKstlWF1TK4YuySMA7eKarOJNaMOvwo0I=
Date:   Wed, 04 Oct 2023 13:22:23 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        sidhartha.kumar@oracle.com, mike.kravetz@oracle.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-use-a-folio-in-free_hpage_workfn.patch removed from -mm tree
Message-Id: <20231004202224.F30DBC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: use a folio in free_hpage_workfn()
has been removed from the -mm tree.  Its filename was
     hugetlb-use-a-folio-in-free_hpage_workfn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: hugetlb: use a folio in free_hpage_workfn()
Date: Thu, 24 Aug 2023 15:13:23 +0100

Patch series "Small hugetlb cleanups", v2.

Some trivial folio conversions


This patch (of 3):

update_and_free_hugetlb_folio puts the memory on hpage_freelist as a folio
so we can take it off the list as a folio.

Link: https://lkml.kernel.org/r/20230824141325.2704553-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230824141325.2704553-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/hugetlb.c~hugetlb-use-a-folio-in-free_hpage_workfn
+++ a/mm/hugetlb.c
@@ -1787,22 +1787,22 @@ static void free_hpage_workfn(struct wor
 	node = llist_del_all(&hpage_freelist);
 
 	while (node) {
-		struct page *page;
+		struct folio *folio;
 		struct hstate *h;
 
-		page = container_of((struct address_space **)node,
-				     struct page, mapping);
+		folio = container_of((struct address_space **)node,
+				     struct folio, mapping);
 		node = node->next;
-		page->mapping = NULL;
+		folio->mapping = NULL;
 		/*
 		 * The VM_BUG_ON_FOLIO(!folio_test_hugetlb(folio), folio) in
 		 * folio_hstate() is going to trigger because a previous call to
 		 * remove_hugetlb_folio() will clear the hugetlb bit, so do
 		 * not use folio_hstate() directly.
 		 */
-		h = size_to_hstate(page_size(page));
+		h = size_to_hstate(folio_size(folio));
 
-		__update_and_free_hugetlb_folio(h, page_folio(page));
+		__update_and_free_hugetlb_folio(h, folio);
 
 		cond_resched();
 	}
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch


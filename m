Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E73CC2BA12
	for <mm-commits@archiver.kernel.org>; Sat, 16 Sep 2023 20:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbjIPUHs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Sep 2023 16:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235240AbjIPUHg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 16 Sep 2023 16:07:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDBF1B5
        for <mm-commits@vger.kernel.org>; Sat, 16 Sep 2023 13:07:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA2AC433C7;
        Sat, 16 Sep 2023 20:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694894851;
        bh=iScXlv4BM7b6U4DXLgyL660HODARaM5B5fwURayhZqs=;
        h=Date:To:From:Subject:From;
        b=jAY4GnjMHE9UvQuLFcRk7fe7LkqyfBxC7ujBtFhWQHsT0BFKSgdJF/BQd3v03yGxf
         EC9c3dUfFFZX9xpe1cT/3d/Dtm1qItalCOWj3qKUElqwlRpXQMe1Db15sJM+Cn7a5Q
         6VYMzgPntlWdMxIcAxCb4nDpn5vtvQoReEWOZmfI=
Date:   Sat, 16 Sep 2023 13:07:30 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        sidhartha.kumar@oracle.com, mike.kravetz@oracle.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-use-a-folio-in-free_hpage_workfn.patch added to mm-unstable branch
Message-Id: <20230916200731.6CA2AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: use a folio in free_hpage_workfn()
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-use-a-folio-in-free_hpage_workfn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-use-a-folio-in-free_hpage_workfn.patch

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
@@ -1780,22 +1780,22 @@ static void free_hpage_workfn(struct wor
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

mm-convert-dax-lock-unlock-page-to-lock-unlock-folio.patch
buffer-pass-gfp-flags-to-folio_alloc_buffers.patch
buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp.patch
ext4-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-convert-getblk_unmovable-and-__getblk-to-use-bdev_getblk.patch
buffer-convert-sb_getblk-to-call-__getblk.patch
ext4-call-bdev_getblk-from-sb_getblk_gfp.patch
buffer-remove-__getblk_gfp.patch
hugetlb-use-a-folio-in-free_hpage_workfn.patch
hugetlb-remove-a-few-calls-to-page_folio.patch
hugetlb-convert-remove_pool_huge_page-to-remove_pool_hugetlb_folio.patch


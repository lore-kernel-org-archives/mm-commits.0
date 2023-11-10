Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7549AC4167B
	for <mm-commits@archiver.kernel.org>; Fri, 10 Nov 2023 17:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjKJRlh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Nov 2023 12:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjKJRlf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Nov 2023 12:41:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E128446C7
        for <mm-commits@vger.kernel.org>; Fri, 10 Nov 2023 09:25:51 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEA6C433C7;
        Fri, 10 Nov 2023 17:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699637150;
        bh=VECGFibGvOYsCrLbglEKRjfYoOez7AtB9larab/iV+c=;
        h=Date:To:From:Subject:From;
        b=JGomhXJTnkrPehS/3RNDgAeY35Z4tBH3cleiKl9RIrNJ11EUgcYSgu2OYm6MW+Skj
         GPu/R+V4Ho2dwe02z6y27LtuNryDNu6AnAX+hqg447sh9nV/DvOrjir/9mMTGqUKo/
         doJ4qBwQaVGq/pzPbUTGhUIpZi1U3TTK7/+d8eBs=
Date:   Fri, 10 Nov 2023 09:25:50 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        gregory.price@memverge.com, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-task_mmu-use-a-folio-in-smaps_account.patch added to mm-unstable branch
Message-Id: <20231110172550.9FEA6C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: task_mmu: use a folio in smaps_account()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-task_mmu-use-a-folio-in-smaps_account.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-task_mmu-use-a-folio-in-smaps_account.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: task_mmu: use a folio in smaps_account()
Date: Fri, 10 Nov 2023 11:33:22 +0800

Replace seven implicit calls to compound_head() with one page_folio().

Link: https://lkml.kernel.org/r/20231110033324.2455523-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gregory.price@memverge.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/proc/task_mmu.c~mm-task_mmu-use-a-folio-in-smaps_account
+++ a/fs/proc/task_mmu.c
@@ -445,23 +445,25 @@ static void smaps_account(struct mem_siz
 {
 	int i, nr = compound ? compound_nr(page) : 1;
 	unsigned long size = nr * PAGE_SIZE;
+	struct folio *folio = page_folio(page);
 
 	/*
 	 * First accumulate quantities that depend only on |size| and the type
 	 * of the compound page.
 	 */
-	if (PageAnon(page)) {
+	if (folio_test_anon(folio)) {
 		mss->anonymous += size;
-		if (!PageSwapBacked(page) && !dirty && !PageDirty(page))
+		if (!folio_test_swapbacked(folio) && !dirty &&
+		    !folio_test_dirty(folio))
 			mss->lazyfree += size;
 	}
 
-	if (PageKsm(page))
+	if (folio_test_ksm(folio))
 		mss->ksm += size;
 
 	mss->resident += size;
 	/* Accumulate the size in pages that have been accessed. */
-	if (young || page_is_young(page) || PageReferenced(page))
+	if (young || folio_test_young(folio) || folio_test_referenced(folio))
 		mss->referenced += size;
 
 	/*
@@ -479,7 +481,7 @@ static void smaps_account(struct mem_siz
 	 * especially for migration entries.  Treat regular migration entries
 	 * as mapcount == 1.
 	 */
-	if ((page_count(page) == 1) || migration) {
+	if ((folio_ref_count(folio) == 1) || migration) {
 		smaps_page_accumulate(mss, page, size, size << PSS_SHIFT, dirty,
 			locked, true);
 		return;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

fs-proc-page-remove-unneeded-pagetail-pageslab-check.patch
fs-proc-page-use-a-folio-in-stable_page_flags.patch
fs-proc-page-respect-folio-head-page-flag-placement.patch
mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail.patch
mm-task_mmu-use-a-folio-in-smaps_account.patch
mm-task_mmu-use-a-folio-in-clear_refs_pte_range.patch
page_idle-kill-page-idle-and-young-wrapper.patch


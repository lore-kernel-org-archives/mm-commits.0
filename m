Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A6FC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 10 Nov 2023 19:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235919AbjKJTAS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Nov 2023 14:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235971AbjKJTAH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Nov 2023 14:00:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0B033045
        for <mm-commits@vger.kernel.org>; Fri, 10 Nov 2023 10:21:24 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB99C4166B;
        Fri, 10 Nov 2023 18:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699640412;
        bh=ZSRFimF/WLVf7wI6TG/MxrXSu2enZeEO1TrpVEChQjU=;
        h=Date:To:From:Subject:From;
        b=uH7u1SFd9/AKDRc8QlEmyT5haqJIVcv2yYTnCuFdxH9k6I/0m3zTvjlGi/hHJ8GGS
         27JxjgtZmhyW3lyCj47OEsybLyxzh3Oykqns1s5csauW//njli6w+S8EIcow4ieSpO
         okcnI/S9SycMd6VSnCFMX9flPQcEnZmbYw9zoQSc=
Date:   Fri, 10 Nov 2023 10:20:11 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        gregory.price@memverge.com, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-task_mmu-use-a-folio-in-smaps_account.patch removed from -mm tree
Message-Id: <20231110182012.2CB99C4166B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: task_mmu: use a folio in smaps_account()
has been removed from the -mm tree.  Its filename was
     mm-task_mmu-use-a-folio-in-smaps_account.patch

This patch was dropped because it was nacked

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

mm-task_mmu-use-a-folio-in-clear_refs_pte_range.patch
page_idle-kill-page-idle-and-young-wrapper.patch


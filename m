Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2284AC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiJCVH7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiJCVFz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5702B605
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69BA8610A5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF57DC433D7;
        Mon,  3 Oct 2022 21:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831128;
        bh=HNp9RVGKkfvYNGsMaq5HwF7bmYhLYBD87HosY62h+TU=;
        h=Date:To:From:Subject:From;
        b=F+58maSpx8AsfBi1Br58LVbm3Oq35c2+WKFuv2tk047XbsEi3kEUApannu/cvNnon
         3E2dyFYyYwKSTUYfIgI2jobx4KHeDqCFzs8Oz+LPn8y8hBJV7Qz4KoFSTlIy1lah9U
         bUhL1YJk8xiHGFd9vAsULyUXGudg54z7NnXxuZBw=
Date:   Mon, 03 Oct 2022 14:05:28 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-do_swap_page-to-use-folio_free_swap.patch removed from -mm tree
Message-Id: <20221003210528.BF57DC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert do_swap_page() to use folio_free_swap()
has been removed from the -mm tree.  Its filename was
     mm-convert-do_swap_page-to-use-folio_free_swap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert do_swap_page() to use folio_free_swap()
Date: Fri, 2 Sep 2022 20:46:42 +0100

Also convert should_try_to_free_swap() to use a folio.  This removes a few
calls to compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-47-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/memory.c~mm-convert-do_swap_page-to-use-folio_free_swap
+++ a/mm/memory.c
@@ -3641,14 +3641,14 @@ static vm_fault_t remove_device_exclusiv
 	return 0;
 }
 
-static inline bool should_try_to_free_swap(struct page *page,
+static inline bool should_try_to_free_swap(struct folio *folio,
 					   struct vm_area_struct *vma,
 					   unsigned int fault_flags)
 {
-	if (!PageSwapCache(page))
+	if (!folio_test_swapcache(folio))
 		return false;
-	if (mem_cgroup_swap_full(page) || (vma->vm_flags & VM_LOCKED) ||
-	    PageMlocked(page))
+	if (mem_cgroup_swap_full(&folio->page) || (vma->vm_flags & VM_LOCKED) ||
+	    folio_test_mlocked(folio))
 		return true;
 	/*
 	 * If we want to map a page that's in the swapcache writable, we
@@ -3656,8 +3656,8 @@ static inline bool should_try_to_free_sw
 	 * user. Try freeing the swapcache to get rid of the swapcache
 	 * reference only in case it's likely that we'll be the exlusive user.
 	 */
-	return (fault_flags & FAULT_FLAG_WRITE) && !PageKsm(page) &&
-		page_count(page) == 2;
+	return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio) &&
+		folio_ref_count(folio) == 2;
 }
 
 static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
@@ -3949,8 +3949,8 @@ vm_fault_t do_swap_page(struct vm_fault
 	 * yet.
 	 */
 	swap_free(entry);
-	if (should_try_to_free_swap(page, vma, vmf->flags))
-		try_to_free_swap(page);
+	if (should_try_to_free_swap(folio, vma, vmf->flags))
+		folio_free_swap(folio);
 
 	inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
 	dec_mm_counter_fast(vma->vm_mm, MM_SWAPENTS);
_

Patches currently in -mm which might be from willy@infradead.org are



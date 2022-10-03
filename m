Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C102C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiJCVH6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiJCVFz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CA021E2D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3306E610E7
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8801AC433B5;
        Mon,  3 Oct 2022 21:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831126;
        bh=Mc/FsL16aRUa/gxfMuZaYyxkzaTUDt0J642J+vCn57Y=;
        h=Date:To:From:Subject:From;
        b=TEY69mlua/LlqJV1ubxcsyzhaUwKEZTCFUX4xLK7ybO5VK20undFDasl6EKld+l0Q
         8UmYoq5O9X0R9HfPiqHK7K04CiMH82JohkdC98CnDcl5ce9h97rsvjP5XWEvdPhK/3
         lEN+E87/L+GUv+2dV4n++bzvjjnHHNwsbHrF3Opo=
Date:   Mon, 03 Oct 2022 14:05:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] uprobes-use-folios-more-widely-in-__replace_page.patch removed from -mm tree
Message-Id: <20221003210526.8801AC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: uprobes: use folios more widely in __replace_page()
has been removed from the -mm tree.  Its filename was
     uprobes-use-folios-more-widely-in-__replace_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: uprobes: use folios more widely in __replace_page()
Date: Fri, 2 Sep 2022 20:46:40 +0100

Remove a few hidden calls to compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-45-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/kernel/events/uprobes.c~uprobes-use-folios-more-widely-in-__replace_page
+++ a/kernel/events/uprobes.c
@@ -19,7 +19,7 @@
 #include <linux/export.h>
 #include <linux/rmap.h>		/* anon_vma_prepare */
 #include <linux/mmu_notifier.h>	/* set_pte_at_notify */
-#include <linux/swap.h>		/* try_to_free_swap */
+#include <linux/swap.h>		/* folio_free_swap */
 #include <linux/ptrace.h>	/* user_enable_single_step */
 #include <linux/kdebug.h>	/* notifier mechanism */
 #include "../../mm/internal.h"	/* munlock_vma_page */
@@ -154,8 +154,9 @@ static loff_t vaddr_to_offset(struct vm_
 static int __replace_page(struct vm_area_struct *vma, unsigned long addr,
 				struct page *old_page, struct page *new_page)
 {
+	struct folio *old_folio = page_folio(old_page);
 	struct mm_struct *mm = vma->vm_mm;
-	DEFINE_FOLIO_VMA_WALK(pvmw, page_folio(old_page), vma, addr, 0);
+	DEFINE_FOLIO_VMA_WALK(pvmw, old_folio, vma, addr, 0);
 	int err;
 	struct mmu_notifier_range range;
 
@@ -169,8 +170,8 @@ static int __replace_page(struct vm_area
 			return err;
 	}
 
-	/* For try_to_free_swap() below */
-	lock_page(old_page);
+	/* For folio_free_swap() below */
+	folio_lock(old_folio);
 
 	mmu_notifier_invalidate_range_start(&range);
 	err = -EAGAIN;
@@ -186,7 +187,7 @@ static int __replace_page(struct vm_area
 		/* no new page, just dec_mm_counter for old_page */
 		dec_mm_counter(mm, MM_ANONPAGES);
 
-	if (!PageAnon(old_page)) {
+	if (!folio_test_anon(old_folio)) {
 		dec_mm_counter(mm, mm_counter_file(old_page));
 		inc_mm_counter(mm, MM_ANONPAGES);
 	}
@@ -198,15 +199,15 @@ static int __replace_page(struct vm_area
 				  mk_pte(new_page, vma->vm_page_prot));
 
 	page_remove_rmap(old_page, vma, false);
-	if (!page_mapped(old_page))
-		try_to_free_swap(old_page);
+	if (!folio_mapped(old_folio))
+		folio_free_swap(old_folio);
 	page_vma_mapped_walk_done(&pvmw);
-	put_page(old_page);
+	folio_put(old_folio);
 
 	err = 0;
  unlock:
 	mmu_notifier_invalidate_range_end(&range);
-	unlock_page(old_page);
+	folio_unlock(old_folio);
 	return err;
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are



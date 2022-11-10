Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D74C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 03:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiKJDO5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 22:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKJDO5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 22:14:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F7D638B
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 19:14:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEBD961D50
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 03:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADA7C433D6;
        Thu, 10 Nov 2022 03:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668050095;
        bh=rOg2GusUHcrb9nv2I7WnxBc8GlDQLnqLrLYABg5n+HE=;
        h=Date:To:From:Subject:From;
        b=cmXxoGO0UyalnJQdf6tqbb8nUF37HL1UFsRXxMiBcqD95s+oVx3NwMb5ETQGVLxbi
         u3gw4zDSfT3pOw20CDycSTzkc8IyeOZNz4UsaAJg4zUwPlT8YPAs1E5kiyI6yd8nTr
         vxyttQ2bl0khf8Wf+pyzZW4+6IvToHUNamHGc+WE=
Date:   Wed, 09 Nov 2022 19:14:54 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com,
        quic_charante@quicinc.com, minchan@kernel.org,
        quic_pkondeti@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-fix-madvise_pageout-for-private-file-mappings.patch added to mm-unstable branch
Message-Id: <20221110031455.1ADA7C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: fix madvise_pageout for private file mappings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-fix-madvise_pageout-for-private-file-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-fix-madvise_pageout-for-private-file-mappings.patch

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
From: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Subject: mm/madvise: fix madvise_pageout for private file mappings
Date: Wed, 9 Nov 2022 10:48:36 +0530

When MADV_PAGEOUT is called on a private file mapping VMA region, we bail
out early if the process is neither owner nor write capable of the file. 
However, this VMA may have both private/shared clean pages and private
dirty pages.  The opportunity of paging out the private dirty pages (Anon
pages) is missed.  Fix this by caching the file access check and use it
later along with PageAnon() during page walk.

We observe ~10% improvement in zram usage, thus leaving more available
memory on a 4GB RAM system running Android.

Link: https://lkml.kernel.org/r/1667971116-12900-1-git-send-email-quic_pkondeti@quicinc.com
Signed-off-by: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

--- a/mm/madvise.c~mm-madvise-fix-madvise_pageout-for-private-file-mappings
+++ a/mm/madvise.c
@@ -40,6 +40,7 @@
 struct madvise_walk_private {
 	struct mmu_gather *tlb;
 	bool pageout;
+	bool can_pageout_file;
 };
 
 /*
@@ -325,6 +326,7 @@ static int madvise_cold_or_pageout_pte_r
 	struct madvise_walk_private *private = walk->private;
 	struct mmu_gather *tlb = private->tlb;
 	bool pageout = private->pageout;
+	bool pageout_anon_only = pageout && !private->can_pageout_file;
 	struct mm_struct *mm = tlb->mm;
 	struct vm_area_struct *vma = walk->vma;
 	pte_t *orig_pte, *pte, ptent;
@@ -361,6 +363,9 @@ static int madvise_cold_or_pageout_pte_r
 		if (page_mapcount(page) != 1)
 			goto huge_unlock;
 
+		if (pageout_anon_only && !PageAnon(page))
+			goto huge_unlock;
+
 		if (next - addr != HPAGE_PMD_SIZE) {
 			int err;
 
@@ -429,6 +434,8 @@ regular_page:
 		if (PageTransCompound(page)) {
 			if (page_mapcount(page) != 1)
 				break;
+			if (pageout_anon_only && !PageAnon(page))
+				break;
 			get_page(page);
 			if (!trylock_page(page)) {
 				put_page(page);
@@ -456,6 +463,9 @@ regular_page:
 		if (!PageLRU(page) || page_mapcount(page) != 1)
 			continue;
 
+		if (pageout_anon_only && !PageAnon(page))
+			continue;
+
 		VM_BUG_ON_PAGE(PageTransCompound(page), page);
 
 		if (pte_young(ptent)) {
@@ -538,11 +548,13 @@ static long madvise_cold(struct vm_area_
 
 static void madvise_pageout_page_range(struct mmu_gather *tlb,
 			     struct vm_area_struct *vma,
-			     unsigned long addr, unsigned long end)
+			     unsigned long addr, unsigned long end,
+			     bool can_pageout_file)
 {
 	struct madvise_walk_private walk_private = {
 		.pageout = true,
 		.tlb = tlb,
+		.can_pageout_file = can_pageout_file,
 	};
 
 	tlb_start_vma(tlb, vma);
@@ -550,10 +562,8 @@ static void madvise_pageout_page_range(s
 	tlb_end_vma(tlb, vma);
 }
 
-static inline bool can_do_pageout(struct vm_area_struct *vma)
+static inline bool can_do_file_pageout(struct vm_area_struct *vma)
 {
-	if (vma_is_anonymous(vma))
-		return true;
 	if (!vma->vm_file)
 		return false;
 	/*
@@ -573,17 +583,23 @@ static long madvise_pageout(struct vm_ar
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct mmu_gather tlb;
+	bool can_pageout_file;
 
 	*prev = vma;
 	if (!can_madv_lru_vma(vma))
 		return -EINVAL;
 
-	if (!can_do_pageout(vma))
-		return 0;
+	/*
+	 * If the VMA belongs to a private file mapping, there can be private
+	 * dirty pages which can be paged out if even this process is neither
+	 * owner nor write capable of the file. Cache the file access check
+	 * here and use it later during page walk.
+	 */
+	can_pageout_file = can_do_file_pageout(vma);
 
 	lru_add_drain();
 	tlb_gather_mmu(&tlb, mm);
-	madvise_pageout_page_range(&tlb, vma, start_addr, end_addr);
+	madvise_pageout_page_range(&tlb, vma, start_addr, end_addr, can_pageout_file);
 	tlb_finish_mmu(&tlb);
 
 	return 0;
_

Patches currently in -mm which might be from quic_pkondeti@quicinc.com are

mm-kfence-remove-hung_task-cruft.patch
mm-madvise-fix-madvise_pageout-for-private-file-mappings.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E02C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  2 Dec 2022 20:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbiLBUmJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Dec 2022 15:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiLBUmI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2022 15:42:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0DDCAFA1
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 12:42:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7CB7623C1
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 20:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDEEDC433D6;
        Fri,  2 Dec 2022 20:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670013726;
        bh=mMjEqDYwHu7ZrQ4NIwT1PE5GpKQAKPRGQBWAqtnFWx8=;
        h=Date:To:From:Subject:From;
        b=yzyVpIqxBig8eDtQ+jpIxlvCNwPGjgbmZ5MTKvcaUCsueYKO1iqrYlW3FVE0wV/qR
         tKhx584ZonJwRunsy+brZUoLg2QjSVSMOmpSNwT62YVK8WI40z6ihxWv3PAlawkjWf
         AgomKTb1kH1XXhoJKx8KgXXpjEYPtF3CZiqzK+a8=
Date:   Fri, 02 Dec 2022 12:42:05 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com,
        quic_charante@quicinc.com, minchan@kernel.org, david@redhat.com,
        quic_pkondeti@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-fix-madvise_pageout-for-private-file-mappings-v2.patch added to mm-unstable branch
Message-Id: <20221202204205.EDEEDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-madvise-fix-madvise_pageout-for-private-file-mappings-v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-fix-madvise_pageout-for-private-file-mappings-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-fix-madvise_pageout-for-private-file-mappings-v2.patch

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
Subject: mm-madvise-fix-madvise_pageout-for-private-file-mappings-v2
Date: Fri, 2 Dec 2022 11:59:57 +0530

- As per David's suggestion, removed new argument introduced in
  madvise_walk_private struct and directly call can_do_file_pageout()

- As per Mark's suggestions, optimized PageAnon() checks.  Also bail
  out early if the file mapping is not private.

Link: https://lkml.kernel.org/r/1669962597-27724-1-git-send-email-quic_pkondeti@quicinc.com
Signed-off-by: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   57 ++++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 28 deletions(-)

--- a/mm/madvise.c~mm-madvise-fix-madvise_pageout-for-private-file-mappings-v2
+++ a/mm/madvise.c
@@ -40,7 +40,6 @@
 struct madvise_walk_private {
 	struct mmu_gather *tlb;
 	bool pageout;
-	bool can_pageout_file;
 };
 
 /*
@@ -319,6 +318,21 @@ static long madvise_willneed(struct vm_a
 	return 0;
 }
 
+static inline bool can_do_file_pageout(struct vm_area_struct *vma)
+{
+	if (!vma->vm_file)
+		return false;
+	/*
+	 * paging out pagecache only for non-anonymous mappings that correspond
+	 * to the files the calling process could (if tried) open for writing;
+	 * otherwise we'd be including shared non-exclusive mappings, which
+	 * opens a side channel.
+	 */
+	return inode_owner_or_capable(&init_user_ns,
+				      file_inode(vma->vm_file)) ||
+	       file_permission(vma->vm_file, MAY_WRITE) == 0;
+}
+
 static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 				unsigned long addr, unsigned long end,
 				struct mm_walk *walk)
@@ -326,17 +340,20 @@ static int madvise_cold_or_pageout_pte_r
 	struct madvise_walk_private *private = walk->private;
 	struct mmu_gather *tlb = private->tlb;
 	bool pageout = private->pageout;
-	bool pageout_anon_only = pageout && !private->can_pageout_file;
 	struct mm_struct *mm = tlb->mm;
 	struct vm_area_struct *vma = walk->vma;
 	pte_t *orig_pte, *pte, ptent;
 	spinlock_t *ptl;
 	struct page *page = NULL;
 	LIST_HEAD(page_list);
+	bool pageout_anon_only_filter;
 
 	if (fatal_signal_pending(current))
 		return -EINTR;
 
+	pageout_anon_only_filter = pageout && !vma_is_anonymous(vma) &&
+					!can_do_file_pageout(vma);
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (pmd_trans_huge(*pmd)) {
 		pmd_t orig_pmd;
@@ -363,7 +380,7 @@ static int madvise_cold_or_pageout_pte_r
 		if (page_mapcount(page) != 1)
 			goto huge_unlock;
 
-		if (pageout_anon_only && !PageAnon(page))
+		if (pageout_anon_only_filter && !PageAnon(page))
 			goto huge_unlock;
 
 		if (next - addr != HPAGE_PMD_SIZE) {
@@ -434,7 +451,7 @@ regular_page:
 		if (PageTransCompound(page)) {
 			if (page_mapcount(page) != 1)
 				break;
-			if (pageout_anon_only && !PageAnon(page))
+			if (pageout_anon_only_filter && !PageAnon(page))
 				break;
 			get_page(page);
 			if (!trylock_page(page)) {
@@ -463,7 +480,7 @@ regular_page:
 		if (!PageLRU(page) || page_mapcount(page) != 1)
 			continue;
 
-		if (pageout_anon_only && !PageAnon(page))
+		if (pageout_anon_only_filter && !PageAnon(page))
 			continue;
 
 		VM_BUG_ON_PAGE(PageTransCompound(page), page);
@@ -548,13 +565,11 @@ static long madvise_cold(struct vm_area_
 
 static void madvise_pageout_page_range(struct mmu_gather *tlb,
 			     struct vm_area_struct *vma,
-			     unsigned long addr, unsigned long end,
-			     bool can_pageout_file)
+			     unsigned long addr, unsigned long end)
 {
 	struct madvise_walk_private walk_private = {
 		.pageout = true,
 		.tlb = tlb,
-		.can_pageout_file = can_pageout_file,
 	};
 
 	tlb_start_vma(tlb, vma);
@@ -562,28 +577,12 @@ static void madvise_pageout_page_range(s
 	tlb_end_vma(tlb, vma);
 }
 
-static inline bool can_do_file_pageout(struct vm_area_struct *vma)
-{
-	if (!vma->vm_file)
-		return false;
-	/*
-	 * paging out pagecache only for non-anonymous mappings that correspond
-	 * to the files the calling process could (if tried) open for writing;
-	 * otherwise we'd be including shared non-exclusive mappings, which
-	 * opens a side channel.
-	 */
-	return inode_owner_or_capable(&init_user_ns,
-				      file_inode(vma->vm_file)) ||
-	       file_permission(vma->vm_file, MAY_WRITE) == 0;
-}
-
 static long madvise_pageout(struct vm_area_struct *vma,
 			struct vm_area_struct **prev,
 			unsigned long start_addr, unsigned long end_addr)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct mmu_gather tlb;
-	bool can_pageout_file;
 
 	*prev = vma;
 	if (!can_madv_lru_vma(vma))
@@ -592,14 +591,16 @@ static long madvise_pageout(struct vm_ar
 	/*
 	 * If the VMA belongs to a private file mapping, there can be private
 	 * dirty pages which can be paged out if even this process is neither
-	 * owner nor write capable of the file. Cache the file access check
-	 * here and use it later during page walk.
+	 * owner nor write capable of the file. We allow private file mappings
+	 * further to pageout dirty anon pages.
 	 */
-	can_pageout_file = can_do_file_pageout(vma);
+	if (!vma_is_anonymous(vma) && (!can_do_file_pageout(vma) &&
+				(vma->vm_flags & VM_MAYSHARE)))
+		return 0;
 
 	lru_add_drain();
 	tlb_gather_mmu(&tlb, mm);
-	madvise_pageout_page_range(&tlb, vma, start_addr, end_addr, can_pageout_file);
+	madvise_pageout_page_range(&tlb, vma, start_addr, end_addr);
 	tlb_finish_mmu(&tlb);
 
 	return 0;
_

Patches currently in -mm which might be from quic_pkondeti@quicinc.com are

mm-madvise-fix-madvise_pageout-for-private-file-mappings.patch
mm-madvise-fix-madvise_pageout-for-private-file-mappings-v2.patch


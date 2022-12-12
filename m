Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71FDC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiLLCON (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbiLLCNx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:13:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1988FDF0B
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:13:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B93F0B80B67
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E46C433D2;
        Mon, 12 Dec 2022 02:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811227;
        bh=PdrX5g9757Id/xI1UZF0Xz38urj9WDCeWNwbXNcJYc8=;
        h=Date:To:From:Subject:From;
        b=d2aNZfz8qQHfbBWQRZRbeVK3Lcfmn0au8ts4RhcUqQp0s3sB3odPedAVE7Nrkqt6q
         1TXU1t4EC50swu3/nI7K5zJSMgl0/5yjnFB3F0disvBadjBW6lmiylBDI/vjAy7DkV
         ntnr63IqXLzLFZH8+Mo3bnv+lZxPMHt9qDrJKhao=
Date:   Sun, 11 Dec 2022 18:13:44 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com,
        quic_charante@quicinc.com, minchan@kernel.org, david@redhat.com,
        quic_pkondeti@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-fix-madvise_pageout-for-private-file-mappings.patch removed from -mm tree
Message-Id: <20221212021347.58E46C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/madvise: fix madvise_pageout for private file mappings
has been removed from the -mm tree.  Its filename was
     mm-madvise-fix-madvise_pageout-for-private-file-mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Subject: mm/madvise: fix madvise_pageout for private file mappings
Date: Wed, 9 Nov 2022 10:48:36 +0530

When MADV_PAGEOUT is called on a private file mapping VMA region, we bail
out early if the process is neither owner nor write capable of the file. 
However, this VMA may have both private/shared clean pages and private
dirty pages.  The opportunity of paging out the private dirty pages (Anon
pages) is missed.  Fix this behavior by allowing private file mappings
pageout further and perform the file access check along with PageAnon()
during page walk.

We observe ~10% improvement in zram usage, thus leaving more available
memory on a 4GB RAM system running Android.

[quic_pkondeti@quicinc.com: v2]
  Link: https://lkml.kernel.org/r/1669962597-27724-1-git-send-email-quic_pkondeti@quicinc.com
Link: https://lkml.kernel.org/r/1667971116-12900-1-git-send-email-quic_pkondeti@quicinc.com
Signed-off-by: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   53 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 18 deletions(-)

--- a/mm/madvise.c~mm-madvise-fix-madvise_pageout-for-private-file-mappings
+++ a/mm/madvise.c
@@ -318,6 +318,21 @@ static long madvise_willneed(struct vm_a
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
@@ -331,10 +346,14 @@ static int madvise_cold_or_pageout_pte_r
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
@@ -361,6 +380,9 @@ static int madvise_cold_or_pageout_pte_r
 		if (page_mapcount(page) != 1)
 			goto huge_unlock;
 
+		if (pageout_anon_only_filter && !PageAnon(page))
+			goto huge_unlock;
+
 		if (next - addr != HPAGE_PMD_SIZE) {
 			int err;
 
@@ -429,6 +451,8 @@ regular_page:
 		if (PageTransCompound(page)) {
 			if (page_mapcount(page) != 1)
 				break;
+			if (pageout_anon_only_filter && !PageAnon(page))
+				break;
 			get_page(page);
 			if (!trylock_page(page)) {
 				put_page(page);
@@ -456,6 +480,9 @@ regular_page:
 		if (!PageLRU(page) || page_mapcount(page) != 1)
 			continue;
 
+		if (pageout_anon_only_filter && !PageAnon(page))
+			continue;
+
 		VM_BUG_ON_PAGE(PageTransCompound(page), page);
 
 		if (pte_young(ptent)) {
@@ -550,23 +577,6 @@ static void madvise_pageout_page_range(s
 	tlb_end_vma(tlb, vma);
 }
 
-static inline bool can_do_pageout(struct vm_area_struct *vma)
-{
-	if (vma_is_anonymous(vma))
-		return true;
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
@@ -578,7 +588,14 @@ static long madvise_pageout(struct vm_ar
 	if (!can_madv_lru_vma(vma))
 		return -EINVAL;
 
-	if (!can_do_pageout(vma))
+	/*
+	 * If the VMA belongs to a private file mapping, there can be private
+	 * dirty pages which can be paged out if even this process is neither
+	 * owner nor write capable of the file. We allow private file mappings
+	 * further to pageout dirty anon pages.
+	 */
+	if (!vma_is_anonymous(vma) && (!can_do_file_pageout(vma) &&
+				(vma->vm_flags & VM_MAYSHARE)))
 		return 0;
 
 	lru_add_drain();
_

Patches currently in -mm which might be from quic_pkondeti@quicinc.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD03ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiILDbX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiILD3i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:29:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913412870A
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CF4F6113D
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58D7C433B5;
        Mon, 12 Sep 2022 03:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953354;
        bh=IqF7uovbH3bhZ3MmtKQZwYqUOQzafXW20NRUe220K+M=;
        h=Date:To:From:Subject:From;
        b=dCry1eSNA+RDlBuzsP4L0emk/9qw7TMEdD3gXvC8LmelAZ0QQ++aR9M8JHUwOImRo
         yCNbsgqnKl32BT3xSdbiLH3XOpJGrNCP8pYCqy32cPQdaMz6wWNIgnpjfW3BwGdmnA
         HUkOxYg1X5fAu91lGr1hl+sA0PiCnaBNUhkDQnAE=
Date:   Sun, 11 Sep 2022 20:29:13 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, lukas.bulwahn@gmail.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-make-detecting-shared-pte-more-reliable.patch removed from -mm tree
Message-Id: <20220912032913.E58D7C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: make detecting shared pte more reliable
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-make-detecting-shared-pte-more-reliable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: make detecting shared pte more reliable
Date: Tue, 16 Aug 2022 21:05:53 +0800

If the pagetables are shared, we shouldn't copy or take references.  Since
src could have unshared and dst shares with another vma, huge_pte_none()
is thus used to determine whether dst_pte is shared.  But this check isn't
reliable.  A shared pte could have pte none in pagetable in fact.  The
page count of ptep page should be checked here in order to reliably
determine whether pte is shared.

[lukas.bulwahn@gmail.com: remove unused local variable dst_entry in copy_hugetlb_page_range()]
  Link: https://lkml.kernel.org/r/20220822082525.26071-1-lukas.bulwahn@gmail.com
Link: https://lkml.kernel.org/r/20220816130553.31406-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-make-detecting-shared-pte-more-reliable
+++ a/mm/hugetlb.c
@@ -4750,7 +4750,7 @@ int copy_hugetlb_page_range(struct mm_st
 			    struct vm_area_struct *dst_vma,
 			    struct vm_area_struct *src_vma)
 {
-	pte_t *src_pte, *dst_pte, entry, dst_entry;
+	pte_t *src_pte, *dst_pte, entry;
 	struct page *ptepage;
 	unsigned long addr;
 	bool cow = is_cow_mapping(src_vma->vm_flags);
@@ -4795,15 +4795,13 @@ int copy_hugetlb_page_range(struct mm_st
 
 		/*
 		 * If the pagetables are shared don't copy or take references.
-		 * dst_pte == src_pte is the common case of src/dest sharing.
 		 *
+		 * dst_pte == src_pte is the common case of src/dest sharing.
 		 * However, src could have 'unshared' and dst shares with
-		 * another vma.  If dst_pte !none, this implies sharing.
-		 * Check here before taking page table lock, and once again
-		 * after taking the lock below.
+		 * another vma. So page_count of ptep page is checked instead
+		 * to reliably determine whether pte is shared.
 		 */
-		dst_entry = huge_ptep_get(dst_pte);
-		if ((dst_pte == src_pte) || !huge_pte_none(dst_entry)) {
+		if (page_count(virt_to_page(dst_pte)) > 1) {
 			addr |= last_addr_mask;
 			continue;
 		}
@@ -4812,13 +4810,10 @@ int copy_hugetlb_page_range(struct mm_st
 		src_ptl = huge_pte_lockptr(h, src, src_pte);
 		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 		entry = huge_ptep_get(src_pte);
-		dst_entry = huge_ptep_get(dst_pte);
 again:
-		if (huge_pte_none(entry) || !huge_pte_none(dst_entry)) {
+		if (huge_pte_none(entry)) {
 			/*
-			 * Skip if src entry none.  Also, skip in the
-			 * unlikely case dst entry !none as this implies
-			 * sharing with another vma.
+			 * Skip if src entry none.
 			 */
 			;
 		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry))) {
@@ -4897,7 +4892,7 @@ again:
 					restore_reserve_on_error(h, dst_vma, addr,
 								new);
 					put_page(new);
-					/* dst_entry won't change as in child */
+					/* huge_ptep of dst_pte won't change as in child */
 					goto again;
 				}
 				hugetlb_install_page(dst_vma, dst_pte, addr, new);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch


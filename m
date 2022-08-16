Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE637C2BB41
	for <mm-commits@archiver.kernel.org>; Tue, 16 Aug 2022 22:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237375AbiHPWzd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Aug 2022 18:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237707AbiHPWzX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 Aug 2022 18:55:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2308A61D4C
        for <mm-commits@vger.kernel.org>; Tue, 16 Aug 2022 15:55:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3667612BF
        for <mm-commits@vger.kernel.org>; Tue, 16 Aug 2022 22:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C30DC433C1;
        Tue, 16 Aug 2022 22:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660690521;
        bh=rPBt7TxSlAPKj5Xw4suad5bXx/COfKB3XVbE1r0N6JY=;
        h=Date:To:From:Subject:From;
        b=IWjCA9U+zeKHTT6gGqmwCzHkuAd74U8ihGYAusnyIyk9PvGhHrAzRt1JZ6GKs+8ek
         qmzI4aB3eoKZOC7OYA8A3iW/5flgiWRA5EDUmmUXBsNUh5xGgCVa0Fa9bkZwjIkrPR
         X6sbgxa+YsVYGJQ9WvBaDI5QaURePIn4nsUcDUwI=
Date:   Tue, 16 Aug 2022 15:55:20 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-make-detecting-shared-pte-more-reliable.patch added to mm-unstable branch
Message-Id: <20220816225521.0C30DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: make detecting shared pte more reliable
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-make-detecting-shared-pte-more-reliable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-make-detecting-shared-pte-more-reliable.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: make detecting shared pte more reliable
Date: Tue, 16 Aug 2022 21:05:53 +0800

If the pagetables are shared, we shouldn't copy or take references.  Since
src could have unshared and dst shares with another vma, huge_pte_none()
is thus used to determine whether dst_pte is shared.  But this check isn't
reliable.  A shared pte could have pte none in pagetable in fact.  The
page count of ptep page should be checked here in order to reliably
determine whether pte is shared.

Link: https://lkml.kernel.org/r/20220816130553.31406-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-make-detecting-shared-pte-more-reliable
+++ a/mm/hugetlb.c
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
@@ -4814,11 +4812,9 @@ int copy_hugetlb_page_range(struct mm_st
 		entry = huge_ptep_get(src_pte);
 		dst_entry = huge_ptep_get(dst_pte);
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
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
hugetlb_cgroup-remove-unneeded-nr_pages-0-check.patch
hugetlb_cgroup-hugetlbfs-use-helper-macro-sz_1kmg.patch
hugetlb_cgroup-remove-unneeded-return-value.patch
hugetlb_cgroup-use-helper-macro-numa_no_node.patch
hugetlb_cgroup-use-helper-for_each_hstate-and-hstate_index.patch
mm-hugetlb-fix-incorrect-update-of-max_huge_pages.patch
mm-hugetlb-fix-warn_onkobj-in-sysfs_create_group.patch
mm-hugetlb-fix-missing-call-to-restore_reserve_on_error.patch
mm-hugetlb_vmemmap-add-missing-smp_wmb-before-set_pte_at.patch
mm-hugetlb-fix-sysfs-group-leak-in-hugetlb_unregister_node.patch
mm-hugetlb-make-detecting-shared-pte-more-reliable.patch


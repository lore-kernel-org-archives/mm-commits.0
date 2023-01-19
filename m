Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 071B7C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjASBOt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjASBOC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:14:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39C465EC8
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:13:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AFF1B81FBB
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C08DC433D2;
        Thu, 19 Jan 2023 01:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090829;
        bh=PP2KmcUfYXcGTopicEeezfexIx5ANEMVIJnFhWmEabE=;
        h=Date:To:From:Subject:From;
        b=kr1y21erp/6woTZo3Wi+CL+lRTnod2dRCDVry6usiSBYcLWz+Gp5Dy/pk/K2sNInK
         nz5HKQFwn+ZAiQO4xsJhaqyGnyk+yfpU2CVdji+HlIKnFtj1Y3ySe0jmchJChim3aG
         Vqslmp/jluCR4hqklcYSNEG+GTggQuOb1fySpbOM=
Date:   Wed, 18 Jan 2023 17:13:48 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        riel@surriel.com, nadav.amit@gmail.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jthoughton@google.com, jhubbard@nvidia.com,
        jannh@google.com, david@redhat.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-document-huge_pte_offset-usage.patch removed from -mm tree
Message-Id: <20230119011349.2C08DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: document huge_pte_offset usage
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-document-huge_pte_offset-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: document huge_pte_offset usage
Date: Fri, 16 Dec 2022 10:50:54 -0500

huge_pte_offset() is potentially a pgtable walker, looking up pte_t* for a
hugetlb address.

Normally, it's always safe to walk a generic pgtable as long as we're with
the mmap lock held for either read or write, because that guarantees the
pgtable pages will always be valid during the process.

But it's not true for hugetlbfs, especially shared: hugetlbfs can have its
pgtable freed by pmd unsharing, it means that even with mmap lock held for
current mm, the PMD pgtable page can still go away from under us if pmd
unsharing is possible during the walk.

So we have two ways to make it safe even for a shared mapping:

  (1) If we're with the hugetlb vma lock held for either read/write, it's
      okay because pmd unshare cannot happen at all.

  (2) If we're with the i_mmap_rwsem lock held for either read/write, it's
      okay because even if pmd unshare can happen, the pgtable page cannot
      be freed from under us.

Document it.

Link: https://lkml.kernel.org/r/20221216155100.2043537-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/include/linux/hugetlb.h~mm-hugetlb-document-huge_pte_offset-usage
+++ a/include/linux/hugetlb.h
@@ -192,6 +192,38 @@ extern struct list_head huge_boot_pages;
 
 pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long addr, unsigned long sz);
+/*
+ * huge_pte_offset(): Walk the hugetlb pgtable until the last level PTE.
+ * Returns the pte_t* if found, or NULL if the address is not mapped.
+ *
+ * Since this function will walk all the pgtable pages (including not only
+ * high-level pgtable page, but also PUD entry that can be unshared
+ * concurrently for VM_SHARED), the caller of this function should be
+ * responsible of its thread safety.  One can follow this rule:
+ *
+ *  (1) For private mappings: pmd unsharing is not possible, so holding the
+ *      mmap_lock for either read or write is sufficient. Most callers
+ *      already hold the mmap_lock, so normally, no special action is
+ *      required.
+ *
+ *  (2) For shared mappings: pmd unsharing is possible (so the PUD-ranged
+ *      pgtable page can go away from under us!  It can be done by a pmd
+ *      unshare with a follow up munmap() on the other process), then we
+ *      need either:
+ *
+ *     (2.1) hugetlb vma lock read or write held, to make sure pmd unshare
+ *           won't happen upon the range (it also makes sure the pte_t we
+ *           read is the right and stable one), or,
+ *
+ *     (2.2) hugetlb mapping i_mmap_rwsem lock held read or write, to make
+ *           sure even if unshare happened the racy unmap() will wait until
+ *           i_mmap_rwsem is released.
+ *
+ * Option (2.1) is the safest, which guarantees pte stability from pmd
+ * sharing pov, until the vma lock released.  Option (2.2) doesn't protect
+ * a concurrent pmd unshare, but it makes sure the pgtable page is safe to
+ * access.
+ */
 pte_t *huge_pte_offset(struct mm_struct *mm,
 		       unsigned long addr, unsigned long sz);
 unsigned long hugetlb_mask_last_page(struct hstate *h);
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-vm-remove-__use_gnu-in-hugetlb-madvisec.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF3C8C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbjASBPS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbjASBOP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:14:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185DD689D2
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB622B81FBE
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611EAC433D2;
        Thu, 19 Jan 2023 01:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090837;
        bh=X1+mHQ6ZkiMJBA4bnlHYTGNnbGfxfMRPTLuvQ+OogSU=;
        h=Date:To:From:Subject:From;
        b=nYUDX5DnXgfpIocG93yXpW9LNBRmCA5xhwfMFVAfZg8TGWIfI8L5jWKF23cWxIa6s
         CR4R/cYTHgIiH2qPGBcrBLxK8VN0xA/EOfWlrB3QoCXJPjW1RQCIEV51LMt8X925UK
         yxnXBEJhq9ymOz11pExc1Vl4EbCQGzQoSz5A7mho=
Date:   Wed, 18 Jan 2023 17:13:56 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        riel@surriel.com, nadav.amit@gmail.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jthoughton@google.com, jhubbard@nvidia.com,
        jannh@google.com, david@redhat.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-make-walk_hugetlb_range-safe-to-pmd-unshare.patch removed from -mm tree
Message-Id: <20230119011357.611EAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: make walk_hugetlb_range() safe to pmd unshare
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-make-walk_hugetlb_range-safe-to-pmd-unshare.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: make walk_hugetlb_range() safe to pmd unshare
Date: Fri, 16 Dec 2022 10:52:26 -0500

Since walk_hugetlb_range() walks the pgtable, it needs the vma lock to
make sure the pgtable page will not be freed concurrently.

Link: https://lkml.kernel.org/r/20221216155226.2043738-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagewalk.h |   11 ++++++++++-
 mm/hmm.c                 |   15 ++++++++++++++-
 mm/pagewalk.c            |    2 ++
 3 files changed, 26 insertions(+), 2 deletions(-)

--- a/include/linux/pagewalk.h~mm-hugetlb-make-walk_hugetlb_range-safe-to-pmd-unshare
+++ a/include/linux/pagewalk.h
@@ -21,7 +21,16 @@ struct mm_walk;
  *			depth is -1 if not known, 0:PGD, 1:P4D, 2:PUD, 3:PMD.
  *			Any folded depths (where PTRS_PER_P?D is equal to 1)
  *			are skipped.
- * @hugetlb_entry:	if set, called for each hugetlb entry
+ * @hugetlb_entry:	if set, called for each hugetlb entry. This hook
+ *			function is called with the vma lock held, in order to
+ *			protect against a concurrent freeing of the pte_t* or
+ *			the ptl. In some cases, the hook function needs to drop
+ *			and retake the vma lock in order to avoid deadlocks
+ *			while calling other functions. In such cases the hook
+ *			function must either refrain from accessing the pte or
+ *			ptl after dropping the vma lock, or else revalidate
+ *			those items after re-acquiring the vma lock and before
+ *			accessing them.
  * @test_walk:		caller specific callback function to determine whether
  *			we walk over the current vma or not. Returning 0 means
  *			"do page table walk over the current vma", returning
--- a/mm/hmm.c~mm-hugetlb-make-walk_hugetlb_range-safe-to-pmd-unshare
+++ a/mm/hmm.c
@@ -492,8 +492,21 @@ static int hmm_vma_walk_hugetlb_entry(pt
 	required_fault =
 		hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, cpu_flags);
 	if (required_fault) {
+		int ret;
+
 		spin_unlock(ptl);
-		return hmm_vma_fault(addr, end, required_fault, walk);
+		hugetlb_vma_unlock_read(vma);
+		/*
+		 * Avoid deadlock: drop the vma lock before calling
+		 * hmm_vma_fault(), which will itself potentially take and
+		 * drop the vma lock. This is also correct from a
+		 * protection point of view, because there is no further
+		 * use here of either pte or ptl after dropping the vma
+		 * lock.
+		 */
+		ret = hmm_vma_fault(addr, end, required_fault, walk);
+		hugetlb_vma_lock_read(vma);
+		return ret;
 	}
 
 	pfn = pte_pfn(entry) + ((start & ~hmask) >> PAGE_SHIFT);
--- a/mm/pagewalk.c~mm-hugetlb-make-walk_hugetlb_range-safe-to-pmd-unshare
+++ a/mm/pagewalk.c
@@ -302,6 +302,7 @@ static int walk_hugetlb_range(unsigned l
 	const struct mm_walk_ops *ops = walk->ops;
 	int err = 0;
 
+	hugetlb_vma_lock_read(vma);
 	do {
 		next = hugetlb_entry_end(h, addr, end);
 		pte = huge_pte_offset(walk->mm, addr & hmask, sz);
@@ -314,6 +315,7 @@ static int walk_hugetlb_range(unsigned l
 		if (err)
 			break;
 	} while (addr = next, addr != end);
+	hugetlb_vma_unlock_read(vma);
 
 	return err;
 }
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-vm-remove-__use_gnu-in-hugetlb-madvisec.patch


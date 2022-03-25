Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A4B8C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbiCYWpI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234030AbiCYWpC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:45:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A1E20D80A
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:43:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FD60611CF
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74962C340F0;
        Fri, 25 Mar 2022 22:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248183;
        bh=ZCIP30bnIlu8YM2mbN8Xj573eBhGgSxhWg3+x2z8tW4=;
        h=Date:To:From:Subject:From;
        b=t1ZjPcyud1i3HFHIUnsBala2W2/+Y5h4pff+rgBK38uYkXzXvm0hRKpsJ+nkEeFsk
         f1MJZJLLEP9Nx4HWrOdDk4pQn0OWpup4clmltvE+k/Pl+W5TqS/8UZAp+T3+Dcg0C+
         zhMPC0MJg5gyTrKUKJ7HQZMY3p5RwECelBm/frps=
Date:   Fri, 25 Mar 2022 15:43:02 -0700
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        rppt@kernel.org, peterx@redhat.com, naoya.horiguchi@linux.dev,
        mhocko@suse.com, david@redhat.com, axelrasmussen@google.com,
        almasrymina@google.com, aarcange@redhat.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-enable-madv_dontneed-for-hugetlb-mappings.patch removed from -mm tree
Message-Id: <20220325224303.74962C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: enable MADV_DONTNEED for hugetlb mappings
has been removed from the -mm tree.  Its filename was
     mm-enable-madv_dontneed-for-hugetlb-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm: enable MADV_DONTNEED for hugetlb mappings

Patch series "Add hugetlb MADV_DONTNEED support", v3.

Userfaultfd selftests for hugetlb does not perform UFFD_EVENT_REMAP
testing.  However, mremap support was recently added in commit
550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed
vma").  While attempting to enable mremap support in the test, it was
discovered that the mremap test indirectly depends on MADV_DONTNEED.

madvise does not allow MADV_DONTNEED for hugetlb mappings.  However, that
is primarily due to the check in can_madv_lru_vma().  By simply removing
the check and adding huge page alignment, MADV_DONTNEED can be made to
work for hugetlb mappings.

Do note that there is no compelling use case for adding this support. 
This was discussed in the RFC [1].  However, adding support makes sense as
it is fairly trivial and brings hugetlb functionality more in line with
'normal' memory.

After enabling support, add selftest for MADV_DONTNEED as well as
MADV_REMOVE.  Then update userfaultfd selftest.

If new functionality is accepted, then madvise man page will be updated to
indicate hugetlb is supported.  It will also be updated to clarify what
happens to the passed length argument.


This patch (of 3):

MADV_DONTNEED is currently disabled for hugetlb mappings.  This certainly
makes sense in shared file mappings as the pagecache maintains a reference
to the page and it will never be freed.  However, it could be useful to
unmap and free pages in private mappings.  In addition, userfaultfd minor
fault users may be able to simplify code by using MADV_DONTNEED.

The primary thing preventing MADV_DONTNEED from working on hugetlb
mappings is a check in can_madv_lru_vma().  To allow support for hugetlb
mappings create and use a new routine madvise_dontneed_free_valid_vma()
that allows hugetlb mappings in this specific case.

For normal mappings, madvise requires the start address be PAGE aligned
and rounds up length to the next multiple of PAGE_SIZE.  Do similarly for
hugetlb mappings: require start address be huge page size aligned and
round up length to the next multiple of huge page size.  Use the new
madvise_dontneed_free_valid_vma routine to check alignment and round up
length/end.  zap_page_range requires this alignment for hugetlb vmas
otherwise we will hit BUGs.

Link: https://lkml.kernel.org/r/20220215002348.128823-1-mike.kravetz@oracle.com
Link: https://lkml.kernel.org/r/20220215002348.128823-2-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

--- a/mm/madvise.c~mm-enable-madv_dontneed-for-hugetlb-mappings
+++ a/mm/madvise.c
@@ -502,9 +502,14 @@ static void madvise_cold_page_range(stru
 	tlb_end_vma(tlb, vma);
 }
 
+static inline bool can_madv_lru_non_huge_vma(struct vm_area_struct *vma)
+{
+	return !(vma->vm_flags & (VM_LOCKED|VM_PFNMAP));
+}
+
 static inline bool can_madv_lru_vma(struct vm_area_struct *vma)
 {
-	return !(vma->vm_flags & (VM_LOCKED|VM_HUGETLB|VM_PFNMAP));
+	return can_madv_lru_non_huge_vma(vma) && !is_vm_hugetlb_page(vma);
 }
 
 static long madvise_cold(struct vm_area_struct *vma,
@@ -777,6 +782,23 @@ static long madvise_dontneed_single_vma(
 	return 0;
 }
 
+static bool madvise_dontneed_free_valid_vma(struct vm_area_struct *vma,
+					    unsigned long start,
+					    unsigned long *end,
+					    int behavior)
+{
+	if (!is_vm_hugetlb_page(vma))
+		return can_madv_lru_non_huge_vma(vma);
+
+	if (behavior != MADV_DONTNEED)
+		return false;
+	if (start & ~huge_page_mask(hstate_vma(vma)))
+		return false;
+
+	*end = ALIGN(*end, huge_page_size(hstate_vma(vma)));
+	return true;
+}
+
 static long madvise_dontneed_free(struct vm_area_struct *vma,
 				  struct vm_area_struct **prev,
 				  unsigned long start, unsigned long end,
@@ -785,7 +807,7 @@ static long madvise_dontneed_free(struct
 	struct mm_struct *mm = vma->vm_mm;
 
 	*prev = vma;
-	if (!can_madv_lru_vma(vma))
+	if (!madvise_dontneed_free_valid_vma(vma, start, &end, behavior))
 		return -EINVAL;
 
 	if (!userfaultfd_remove(vma, start, end)) {
@@ -807,7 +829,12 @@ static long madvise_dontneed_free(struct
 			 */
 			return -ENOMEM;
 		}
-		if (!can_madv_lru_vma(vma))
+		/*
+		 * Potential end adjustment for hugetlb vma is OK as
+		 * the check below keeps end within vma.
+		 */
+		if (!madvise_dontneed_free_valid_vma(vma, start, &end,
+						     behavior))
 			return -EINVAL;
 		if (end > vma->vm_end) {
 			/*
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-do-not-demote-poisoned-hugetlb-pages.patch


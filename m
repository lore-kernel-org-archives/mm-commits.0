Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2987C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Feb 2022 01:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241758AbiBPBGY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 20:06:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233535AbiBPBGY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 20:06:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26BBF5408
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 17:06:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DA95B81AE4
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 01:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AD4C340EB;
        Wed, 16 Feb 2022 01:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644973570;
        bh=pgbhpWR2zi5cLgHqfjruEDDolTO9xnTg9HGMMe1HFIU=;
        h=Date:To:From:Subject:From;
        b=tB8EsSK7qOwxo3FB6Xv5Dw5GoE1zX1JhhKlt+paO4DYX4KmlgStu+Mr7k15opU45U
         QruVfUr9DZ8fXgWsh27qNC6bT7sjxC8F1oHdP6CwgKpZqjlthxenQHtFqO/15Tr6pF
         IfRJf0N8RLI2XPoCscIofzJHoCQd28OEhspviI/I=
Date:   Tue, 15 Feb 2022 17:06:09 -0800
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        rppt@kernel.org, peterx@redhat.com, naoya.horiguchi@linux.dev,
        mhocko@suse.com, david@redhat.com, axelrasmussen@google.com,
        almasrymina@google.com, aarcange@redhat.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-enable-madv_dontneed-for-hugetlb-mappings.patch added to -mm tree
Message-Id: <20220216010610.08AD4C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: enable MADV_DONTNEED for hugetlb mappings
has been added to the -mm tree.  Its filename is
     mm-enable-madv_dontneed-for-hugetlb-mappings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-enable-madv_dontneed-for-hugetlb-mappings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-enable-madv_dontneed-for-hugetlb-mappings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -554,9 +554,14 @@ static void madvise_cold_page_range(stru
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
@@ -829,6 +834,23 @@ static long madvise_dontneed_single_vma(
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
@@ -837,7 +859,7 @@ static long madvise_dontneed_free(struct
 	struct mm_struct *mm = vma->vm_mm;
 
 	*prev = vma;
-	if (!can_madv_lru_vma(vma))
+	if (!madvise_dontneed_free_valid_vma(vma, start, &end, behavior))
 		return -EINVAL;
 
 	if (!userfaultfd_remove(vma, start, end)) {
@@ -859,7 +881,12 @@ static long madvise_dontneed_free(struct
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

selftests-vm-cleanup-hugetlb-file-after-mremap-test.patch
mm-enable-madv_dontneed-for-hugetlb-mappings.patch
selftests-vm-add-hugetlb-madvise-madv_dontneed-madv_remove-test.patch
userfaultfd-selftests-enable-hugetlb-remap-and-remove-event-testing.patch


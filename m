Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05289C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 01:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383123AbiDFB4m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357028AbiDEUj4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 16:39:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DA72E68D
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 13:19:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 635AD6199D
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 20:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3C4C385A1;
        Tue,  5 Apr 2022 20:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649189834;
        bh=8/l+ZtJfoPJoB4kQ08MB4S4Te7j45ssQbej1Ml5v3XE=;
        h=Date:To:From:Subject:From;
        b=VKGmosJcasU62GBX+C2NqfEAiX9HyVVYouJXzEarU8YejDARbOc/RNuNNF1066dl1
         aWIaSr0Dz+Z4sGAm+JNKubdwDYsLlwivw1qoe5S1U1d/5UGqPd562AoPNTDVFoXmlb
         XTbuunxYW/O7g3aiJ+ksUjskWoEtw08s1BSbjiLU=
Date:   Tue, 05 Apr 2022 13:17:14 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-dont-recycle-vma-pgtable-if-uffd-wp-registered.patch added to -mm tree
Message-Id: <20220405201714.BE3C4C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: don't recycle vma pgtable if uffd-wp registered
has been added to the -mm tree.  Its filename is
     mm-khugepaged-dont-recycle-vma-pgtable-if-uffd-wp-registered.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-khugepaged-dont-recycle-vma-pgtable-if-uffd-wp-registered.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-khugepaged-dont-recycle-vma-pgtable-if-uffd-wp-registered.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/khugepaged: don't recycle vma pgtable if uffd-wp registered

When we're trying to collapse a 2M huge shmem page, don't retract pgtable
pmd page if it's registered with uffd-wp, because that pgtable could have
pte markers installed.  Recycling of that pgtable means we'll lose the pte
markers.  That could cause data loss for an uffd-wp enabled application on
shmem.

Instead of disabling khugepaged on these files, simply skip retracting
these special VMAs, then the page cache can still be merged into a huge
thp, and other mm/vma can still map the range of file with a huge thp when
proper.

Note that checking VM_UFFD_WP needs to be done with mmap_sem held for
write, that avoids race like:

         khugepaged                             user thread
         ==========                             ===========
     check VM_UFFD_WP, not set
                                       UFFDIO_REGISTER with uffd-wp on shmem
                                       wr-protect some pages (install markers)
     take mmap_sem write lock
     erase pmd and free pmd page
      --> pte markers are dropped unnoticed!

Link: https://lkml.kernel.org/r/20220405014921.14994-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-dont-recycle-vma-pgtable-if-uffd-wp-registered
+++ a/mm/khugepaged.c
@@ -1474,6 +1474,10 @@ void collapse_pte_mapped_thp(struct mm_s
 	if (!hugepage_vma_check(vma, vma->vm_flags | VM_HUGEPAGE))
 		return;
 
+	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
+	if (userfaultfd_wp(vma))
+		return;
+
 	hpage = find_lock_page(vma->vm_file->f_mapping,
 			       linear_page_index(vma, haddr));
 	if (!hpage)
@@ -1609,7 +1613,15 @@ static void retract_page_tables(struct a
 		 * reverse order. Trylock is a way to avoid deadlock.
 		 */
 		if (mmap_write_trylock(mm)) {
-			if (!khugepaged_test_exit(mm))
+			/*
+			 * When a vma is registered with uffd-wp, we can't
+			 * recycle the pmd pgtable because there can be pte
+			 * markers installed.  Skip it only, so the rest mm/vma
+			 * can still have the same file mapped hugely, however
+			 * it'll always mapped in small page size for uffd-wp
+			 * registered ranges.
+			 */
+			if (!khugepaged_test_exit(mm) && !userfaultfd_wp(vma))
 				collapse_and_free_pmd(mm, vma, addr, pmd);
 			mmap_write_unlock(mm);
 		} else {
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-introduce-pte_marker-swap-entry.patch
mm-teach-core-mm-about-pte-markers.patch
mm-check-against-orig_pte-for-finish_fault.patch
mm-uffd-pte_marker_uffd_wp.patch
mm-shmem-take-care-of-uffdio_copy_mode_wp.patch
mm-shmem-handle-uffd-wp-special-pte-in-page-fault-handler.patch
mm-shmem-persist-uffd-wp-bit-across-zapping-for-file-backed.patch
mm-shmem-allow-uffd-wr-protect-none-pte-for-file-backed-mem.patch
mm-shmem-allows-file-back-mem-to-be-uffd-wr-protected-on-thps.patch
mm-shmem-handle-uffd-wp-during-fork.patch
mm-hugetlb-introduce-huge-pte-version-of-uffd-wp-helpers.patch
mm-hugetlb-hook-page-faults-for-uffd-write-protection.patch
mm-hugetlb-take-care-of-uffdio_copy_mode_wp.patch
mm-hugetlb-handle-uffdio_writeprotect.patch
mm-hugetlb-handle-pte-markers-in-page-faults.patch
mm-hugetlb-allow-uffd-wr-protect-none-ptes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required.patch
mm-hugetlb-handle-uffd-wp-during-fork.patch
mm-khugepaged-dont-recycle-vma-pgtable-if-uffd-wp-registered.patch
mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs.patch
mm-uffd-enable-write-protection-for-shmem-hugetlbfs.patch
mm-enable-pte-markers-by-default.patch
selftests-uffd-enable-uffd-wp-for-shmem-hugetlbfs.patch


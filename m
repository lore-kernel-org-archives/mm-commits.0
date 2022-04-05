Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D79C4321E
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 01:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381431AbiDFB4j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344343AbiDEUiW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 16:38:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56852222AC
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 13:19:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47D1C619AF
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 20:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD44C385A5;
        Tue,  5 Apr 2022 20:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649189813;
        bh=jm6JNsvLS48HaTtho1IAw65QQB8wEgKiocPR9Foi+0Q=;
        h=Date:To:From:Subject:From;
        b=VZI6Rpy+FfP/1nOhIWwBnVZmDEaa5UZPAeY1RvpCtbP/yTxK+DInjH1vEv9egPrmD
         nrR3XWd1nTJtSvWko43FMaUImMc4TsVGyxqm/6V3zCJZgeJINYwgnTPFlEqP2V6Ats
         Oz6AOxMvPLkRGl7a8Sj1FrWMKzO2/4iHnRYUg0B4=
Date:   Tue, 05 Apr 2022 13:16:53 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-handle-uffd-wp-during-fork.patch added to -mm tree
Message-Id: <20220405201653.9BD44C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: handle uffd-wp during fork()
has been added to the -mm tree.  Its filename is
     mm-shmem-handle-uffd-wp-during-fork.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-handle-uffd-wp-during-fork.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-handle-uffd-wp-during-fork.patch

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
Subject: mm/shmem: handle uffd-wp during fork()

Normally we skip copy page when fork() for VM_SHARED shmem, but we can't
skip it anymore if uffd-wp is enabled on dst vma.  This should only happen
when the src uffd has UFFD_FEATURE_EVENT_FORK enabled on uffd-wp shmem
vma, so that VM_UFFD_WP will be propagated onto dst vma too, then we
should copy the pgtables with uffd-wp bit and pte markers, because these
information will be lost otherwise.

Since the condition checks will become even more complicated for deciding
"whether a vma needs to copy the pgtable during fork()", introduce a
helper vma_needs_copy() for it, so everything will be clearer.

Link: https://lkml.kernel.org/r/20220405014855.14468-1-peterx@redhat.com
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

 mm/memory.c |   49 +++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 8 deletions(-)

--- a/mm/memory.c~mm-shmem-handle-uffd-wp-during-fork
+++ a/mm/memory.c
@@ -867,6 +867,14 @@ copy_nonpresent_pte(struct mm_struct *ds
 		if (try_restore_exclusive_pte(src_pte, src_vma, addr))
 			return -EBUSY;
 		return -ENOENT;
+	} else if (is_pte_marker_entry(entry)) {
+		/*
+		 * We're copying the pgtable should only because dst_vma has
+		 * uffd-wp enabled, do sanity check.
+		 */
+		WARN_ON_ONCE(!userfaultfd_wp(dst_vma));
+		set_pte_at(dst_mm, addr, dst_pte, pte);
+		return 0;
 	}
 	if (!userfaultfd_wp(dst_vma))
 		pte = pte_swp_clear_uffd_wp(pte);
@@ -1221,6 +1229,38 @@ copy_p4d_range(struct vm_area_struct *ds
 	return 0;
 }
 
+/*
+ * Return true if the vma needs to copy the pgtable during this fork().  Return
+ * false when we can speed up fork() by allowing lazy page faults later until
+ * when the child accesses the memory range.
+ */
+bool
+vma_needs_copy(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
+{
+	/*
+	 * Always copy pgtables when dst_vma has uffd-wp enabled even if it's
+	 * file-backed (e.g. shmem). Because when uffd-wp is enabled, pgtable
+	 * contains uffd-wp protection information, that's something we can't
+	 * retrieve from page cache, and skip copying will lose those info.
+	 */
+	if (userfaultfd_wp(dst_vma))
+		return true;
+
+	if (src_vma->vm_flags & (VM_HUGETLB | VM_PFNMAP | VM_MIXEDMAP))
+		return true;
+
+	if (src_vma->anon_vma)
+		return true;
+
+	/*
+	 * Don't copy ptes where a page fault will fill them correctly.  Fork
+	 * becomes much lighter when there are big shared or private readonly
+	 * mappings. The tradeoff is that copy_page_range is more efficient
+	 * than faulting.
+	 */
+	return false;
+}
+
 int
 copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 {
@@ -1234,14 +1274,7 @@ copy_page_range(struct vm_area_struct *d
 	bool is_cow;
 	int ret;
 
-	/*
-	 * Don't copy ptes where a page fault will fill them correctly.
-	 * Fork becomes much lighter when there are big shared or private
-	 * readonly mappings. The tradeoff is that copy_page_range is more
-	 * efficient than faulting.
-	 */
-	if (!(src_vma->vm_flags & (VM_HUGETLB | VM_PFNMAP | VM_MIXEDMAP)) &&
-	    !src_vma->anon_vma)
+	if (!vma_needs_copy(dst_vma, src_vma))
 		return 0;
 
 	if (is_vm_hugetlb_page(src_vma))
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


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09BC0C46467
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 01:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455321AbiDFB5k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346257AbiDEUeI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 16:34:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54285FD6E6
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 13:17:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9665C61924
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 20:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB84AC385A3;
        Tue,  5 Apr 2022 20:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649189797;
        bh=IwoXhqecGQBDz9y+blY6YHcd/IJ5d1qzCbg+XddOKrw=;
        h=Date:To:From:Subject:From;
        b=iEjg72CgR/1nEiPm+FjYND1B5W3+Ikkw0BJgfrdFv4TvfkuqG9uHm6dpalTgZOtja
         Fm1RaWhuZVj8t7J8vlMAveigyqRWlsjfErUcPVraNnbt8faV6Sal/Cm/roLDYyipOX
         9VkSPU5VSLKSM+sMnzj2zsb4SJsxbeloanqrBo6w=
Date:   Tue, 05 Apr 2022 13:16:36 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-check-against-orig_pte-for-finish_fault.patch added to -mm tree
Message-Id: <20220405201636.EB84AC385A3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: check against orig_pte for finish_fault()
has been added to the -mm tree.  Its filename is
     mm-check-against-orig_pte-for-finish_fault.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-check-against-orig_pte-for-finish_fault.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-check-against-orig_pte-for-finish_fault.patch

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
Subject: mm: check against orig_pte for finish_fault()

We used to check against none pte in finish_fault(), with the assumption
that the orig_pte is always none pte.

This change prepares us to be able to call do_fault() on !none ptes.  For
example, we should allow that to happen for pte marker so that we can
restore information out of the pte markers.

Let's change the "pte_none" check into detecting changes since we fetched
orig_pte.  One trivial thing to take care of here is, when pmd==NULL for
the pgtable we may not initialize orig_pte at all in handle_pte_fault().

By default orig_pte will be all zeros however the problem is not all
architectures are using all-zeros for a none pte.  pte_clear() will be the
right thing to use here so that we'll always have a valid orig_pte value
for the whole handle_pte_fault() call.

Link: https://lkml.kernel.org/r/20220405014836.14077-1-peterx@redhat.com
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

 mm/memory.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-check-against-orig_pte-for-finish_fault
+++ a/mm/memory.c
@@ -4237,7 +4237,7 @@ vm_fault_t finish_fault(struct vm_fault
 				      vmf->address, &vmf->ptl);
 	ret = 0;
 	/* Re-check under ptl */
-	if (likely(pte_none(*vmf->pte)))
+	if (likely(pte_same(*vmf->pte, vmf->orig_pte)))
 		do_set_pte(vmf, page, vmf->address);
 	else
 		ret = VM_FAULT_NOPAGE;
@@ -4705,6 +4705,13 @@ static vm_fault_t handle_pte_fault(struc
 		 * concurrent faults and from rmap lookups.
 		 */
 		vmf->pte = NULL;
+		/*
+		 * Always initialize orig_pte.  This matches with below
+		 * code to have orig_pte to be the none pte if pte==NULL.
+		 * This makes the rest code to be always safe to reference
+		 * it, e.g. in finish_fault() we'll detect pte changes.
+		 */
+		pte_clear(vmf->vma->vm_mm, vmf->address, &vmf->orig_pte);
 	} else {
 		/*
 		 * If a huge pmd materialized under us just retry later.  Use
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


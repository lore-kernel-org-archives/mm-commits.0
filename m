Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D070C4321E
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 01:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1845654AbiDFB6I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348249AbiDEUeS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 16:34:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9367FE40A
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 13:17:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DDC361991
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 20:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F5BC385A0;
        Tue,  5 Apr 2022 20:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649189815;
        bh=iewTb1FszArMNcCziukZxc7glDO7Cqbo95/uSE0fLm8=;
        h=Date:To:From:Subject:From;
        b=o4LbCqi/3mk8WldmMrym+TdbOMxCipaedeykcWVTjFivyQ/WXbYCG7gDbKAzPR/aa
         kArisuCBcJ19Upnka25BwJl3VagnOUipINQBxbbnwDfOcwrw91iRrgH19B3LxzZf9Z
         GVkd6f1GmBKShTW0OP6OVCAG6RLNtrvNH2uAY6gY=
Date:   Tue, 05 Apr 2022 13:16:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-introduce-huge-pte-version-of-uffd-wp-helpers.patch added to -mm tree
Message-Id: <20220405201655.95F5BC385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: introduce huge pte version of uffd-wp helpers
has been added to the -mm tree.  Its filename is
     mm-hugetlb-introduce-huge-pte-version-of-uffd-wp-helpers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-introduce-huge-pte-version-of-uffd-wp-helpers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-introduce-huge-pte-version-of-uffd-wp-helpers.patch

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
Subject: mm/hugetlb: introduce huge pte version of uffd-wp helpers

They will be used in the follow up patches to either check/set/clear
uffd-wp bit of a huge pte.

So far it reuses all the small pte helpers.  Archs can overwrite these
versions when necessary (with __HAVE_ARCH_HUGE_PTE_UFFD_WP* macros) in the
future.

Link: https://lkml.kernel.org/r/20220405014858.14531-1-peterx@redhat.com
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

 arch/s390/include/asm/hugetlb.h |   15 +++++++++++++++
 include/asm-generic/hugetlb.h   |   15 +++++++++++++++
 2 files changed, 30 insertions(+)

--- a/arch/s390/include/asm/hugetlb.h~mm-hugetlb-introduce-huge-pte-version-of-uffd-wp-helpers
+++ a/arch/s390/include/asm/hugetlb.h
@@ -115,6 +115,21 @@ static inline pte_t huge_pte_modify(pte_
 	return pte_modify(pte, newprot);
 }
 
+static inline pte_t huge_pte_mkuffd_wp(pte_t pte)
+{
+	return pte;
+}
+
+static inline pte_t huge_pte_clear_uffd_wp(pte_t pte)
+{
+	return pte;
+}
+
+static inline int huge_pte_uffd_wp(pte_t pte)
+{
+	return 0;
+}
+
 static inline bool gigantic_page_runtime_supported(void)
 {
 	return true;
--- a/include/asm-generic/hugetlb.h~mm-hugetlb-introduce-huge-pte-version-of-uffd-wp-helpers
+++ a/include/asm-generic/hugetlb.h
@@ -35,6 +35,21 @@ static inline pte_t huge_pte_modify(pte_
 	return pte_modify(pte, newprot);
 }
 
+static inline pte_t huge_pte_mkuffd_wp(pte_t pte)
+{
+	return pte_mkuffd_wp(pte);
+}
+
+static inline pte_t huge_pte_clear_uffd_wp(pte_t pte)
+{
+	return pte_clear_uffd_wp(pte);
+}
+
+static inline int huge_pte_uffd_wp(pte_t pte)
+{
+	return pte_uffd_wp(pte);
+}
+
 #ifndef __HAVE_ARCH_HUGE_PTE_CLEAR
 static inline void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
 		    pte_t *ptep, unsigned long sz)
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


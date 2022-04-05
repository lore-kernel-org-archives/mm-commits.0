Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 544D0C43217
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 01:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391742AbiDFB5C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346567AbiDEUeI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 16:34:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B298FD6D6
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 13:17:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7944D619A9
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 20:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3E9C385A0;
        Tue,  5 Apr 2022 20:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649189817;
        bh=KuwLJ7Ao+vZZU5ockiZXirm1kyUnCGfiZZgiv+oq7CQ=;
        h=Date:To:From:Subject:From;
        b=Q+1+3UjvUkUYPHRwf02WxekF2RfV3wKkyJV3zcZCBGQ8uzzzcj9pwAOqDVWokf5P7
         TEhI9d3ZHhgaF0DyT3FcxeCr0vsSBcHwG5Hs80e4cPruM1nQXwfHtL7Ya0tRIjn6Hu
         nGdJbYR5nsE7idNoQnXoO2PWKGbPD/KblxNTkdNU=
Date:   Tue, 05 Apr 2022 13:16:57 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-hook-page-faults-for-uffd-write-protection.patch added to -mm tree
Message-Id: <20220405201657.CC3E9C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: hook page faults for uffd write protection
has been added to the -mm tree.  Its filename is
     mm-hugetlb-hook-page-faults-for-uffd-write-protection.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-hook-page-faults-for-uffd-write-protection.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-hook-page-faults-for-uffd-write-protection.patch

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
Subject: mm/hugetlb: hook page faults for uffd write protection

Hook up hugetlbfs_fault() with the capability to handle userfaultfd-wp
faults.

We do this slightly earlier than hugetlb_cow() so that we can avoid taking
some extra locks that we definitely don't need.

Link: https://lkml.kernel.org/r/20220405014901.14590-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-hook-page-faults-for-uffd-write-protection
+++ a/mm/hugetlb.c
@@ -5711,6 +5711,26 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	if (unlikely(!pte_same(entry, huge_ptep_get(ptep))))
 		goto out_ptl;
 
+	/* Handle userfault-wp first, before trying to lock more pages */
+	if (userfaultfd_wp(vma) && huge_pte_uffd_wp(huge_ptep_get(ptep)) &&
+	    (flags & FAULT_FLAG_WRITE) && !huge_pte_write(entry)) {
+		struct vm_fault vmf = {
+			.vma = vma,
+			.address = haddr,
+			.real_address = address,
+			.flags = flags,
+		};
+
+		spin_unlock(ptl);
+		if (pagecache_page) {
+			unlock_page(pagecache_page);
+			put_page(pagecache_page);
+		}
+		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+		i_mmap_unlock_read(mapping);
+		return handle_userfault(&vmf, VM_UFFD_WP);
+	}
+
 	/*
 	 * hugetlb_wp() requires page locks of pte_page(entry) and
 	 * pagecache_page, so here we need take the former one
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


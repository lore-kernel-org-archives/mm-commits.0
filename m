Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99CB4C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 01:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbiDFBzJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379032AbiDEUk1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 16:40:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BD5FCBD2
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 13:19:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9661D619A2
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 20:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F8CC385A1;
        Tue,  5 Apr 2022 20:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649189837;
        bh=m0RU93pY7ZNXtcI3n9ZkrKGdtYBcBSuZuVIzodfqTlM=;
        h=Date:To:From:Subject:From;
        b=bZ+XrgWAixwATrl007Hx3ksT5qA8byhX0HlSqk4zuRRgFu1JBhkDcUIDJWlirnvKx
         ZTA0VfYhWM4KFIN74w7LKelbLEXiXYMmXz/sdPOxNPLwvFSZ6j4M/vhHBMZc8QRfRo
         sQiV1Xb7hEhzVPHjwJZQFRvq0RkQWhtG1RhPZNcs=
Date:   Tue, 05 Apr 2022 13:17:16 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs.patch added to -mm tree
Message-Id: <20220405201716.F0F8CC385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/pagemap: recognize uffd-wp bit for shmem/hugetlbfs
has been added to the -mm tree.  Its filename is
     mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs.patch

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
Subject: mm/pagemap: recognize uffd-wp bit for shmem/hugetlbfs

This requires the pagemap code to be able to recognize the newly
introduced swap special pte for uffd-wp, meanwhile the general case for
hugetlb that we recently start to support.  It should make pagemap uffd-wp
support complete.

Link: https://lkml.kernel.org/r/20220405014923.15047-1-peterx@redhat.com
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

 fs/proc/task_mmu.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/proc/task_mmu.c~mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs
+++ a/fs/proc/task_mmu.c
@@ -1421,6 +1421,8 @@ static pagemap_entry_t pte_to_pagemap_en
 		migration = is_migration_entry(entry);
 		if (is_pfn_swap_entry(entry))
 			page = pfn_swap_entry_to_page(entry);
+		if (pte_marker_entry_uffd_wp(entry))
+			flags |= PM_UFFD_WP;
 	}
 
 	if (page && !PageAnon(page))
@@ -1556,10 +1558,15 @@ static int pagemap_hugetlb_range(pte_t *
 		if (page_mapcount(page) == 1)
 			flags |= PM_MMAP_EXCLUSIVE;
 
+		if (huge_pte_uffd_wp(pte))
+			flags |= PM_UFFD_WP;
+
 		flags |= PM_PRESENT;
 		if (pm->show_pfn)
 			frame = pte_pfn(pte) +
 				((addr & ~hmask) >> PAGE_SHIFT);
+	} else if (pte_swp_uffd_wp_any(pte)) {
+		flags |= PM_UFFD_WP;
 	}
 
 	for (; addr != end; addr += PAGE_SIZE) {
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


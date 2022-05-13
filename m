Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 494D0C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383790AbiEMTVl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383833AbiEMTVM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4026A38B0
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD0AB6220A
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBC1C34100;
        Fri, 13 May 2022 19:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469670;
        bh=Fy6xHcK4IHP6JzH1wDMjCArTFiqWMbyaEQHKLhkByGs=;
        h=Date:To:From:Subject:From;
        b=Wg0mJ83FxD9NjG/tZQ+yd8RJ7FqKG2OrCUOmQy1hEl90GE2gBQQh5Lzrn/uKFzcYY
         NjqsVfsOM4NsERx0vkdnfgLZIjtMTA0hTKSxprLia+HBn5NhK5wLRgDA1tupvUbQG3
         LJvsStvy6rS+BQuCSR6kH2x0sQ5JRo48VqBLHACM=
Date:   Fri, 13 May 2022 12:21:09 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs.patch removed from -mm tree
Message-Id: <20220513192110.2CBC1C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/pagemap: recognize uffd-wp bit for shmem/hugetlbfs
has been removed from the -mm tree.  Its filename was
     mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



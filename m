Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 419EAC43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:09:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiGDBJ3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiGDBJ2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229EE617D
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAEBFB80BD1
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900A0C341C6;
        Mon,  4 Jul 2022 01:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896965;
        bh=eyGKkhSKAe3CmnjT95XFG/CzogHhdlt/1wmU6AfTkvU=;
        h=Date:To:From:Subject:From;
        b=G9RvPKEmavyzHCvewy9+DZJ/uIZkegKHN1hrfPQV3IM8oQ6iqBv448TmepYs5fu/k
         b5xHRG6s9dDNJX1cSa1rUUfmbxanpyzu/sBr277GVMZ2nu1/C0QYARW8fq1X6uVmiP
         IJoNvFSJ1TCwTDKbw81JuzgM/HiliI5iDVboo33o=
Date:   Sun, 03 Jul 2022 18:09:24 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        songmuchun@bytedance.com, peterx@redhat.com, osalvador@suse.de,
        mike.kravetz@oracle.com, lkp@intel.com, hch@lst.de,
        dhowells@redhat.com, david@redhat.com, cl@linux.com,
        apopple@nvidia.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch removed from -mm tree
Message-Id: <20220704010925.900A0C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migration: remove unneeded lock page and PageMovable check
has been removed from the -mm tree.  Its filename was
     mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/migration: remove unneeded lock page and PageMovable check
Date: Mon, 30 May 2022 19:30:14 +0800

When non-lru movable page was freed from under us, __ClearPageMovable must
have been done.  So we can remove unneeded lock page and PageMovable check
here.  Also free_pages_prepare() will clear PG_isolated for us, so we can
further remove ClearPageIsolated as suggested by David.

Link: https://lkml.kernel.org/r/20220530113016.16663-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/migrate.c~mm-migration-remove-unneeded-lock-page-and-pagemovable-check
+++ a/mm/migrate.c
@@ -1090,15 +1090,10 @@ static int unmap_and_move(new_page_t get
 		return -ENOSYS;
 
 	if (page_count(page) == 1) {
-		/* page was freed from under us. So we are done. */
+		/* Page was freed from under us. So we are done. */
 		ClearPageActive(page);
 		ClearPageUnevictable(page);
-		if (unlikely(__PageMovable(page))) {
-			lock_page(page);
-			if (!PageMovable(page))
-				ClearPageIsolated(page);
-			unlock_page(page);
-		}
+		/* free_pages_prepare() will clear PG_isolated. */
 		goto out;
 	}
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry.patch
mm-khugepaged-remove-unneeded-shmem_huge_enabled-check.patch
mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs.patch
mm-khugepaged-trivial-typo-and-codestyle-cleanup.patch
mm-khugepaged-minor-cleanup-for-collapse_file.patch
mm-khugepaged-use-helper-macro-__attr_rw.patch
mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch
mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch


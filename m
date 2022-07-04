Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78EC1CCA47C
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbiGDBKP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiGDBJ5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B29662F6
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBFE1B803F6
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70148C341C6;
        Mon,  4 Jul 2022 01:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896993;
        bh=hkYRrh0LlqVfsxsTE43R5EKygJ7kbFoez4eCtGUw38U=;
        h=Date:To:From:Subject:From;
        b=XCB3rFLdflqkj5xhi27fXsWcINTtmXP0EQXzG1BFmHH4TCC/myijY4k40PARVGBvf
         eFrjlBNg5vMtbTJA6wuuVt3cdPv3i5d2pPqkVdUOmn5Leu1dzxYivb+0yh9BA04Dr7
         5/lLiYuEOOtDa82Kti7c/uDPurumMQ4ole1fz/+0=
Date:   Sun, 03 Jul 2022 18:09:52 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, hughd@google.com,
        david@redhat.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swapfile-fix-possible-data-races-of-inuse_pages.patch removed from -mm tree
Message-Id: <20220704010953.70148C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swapfile: fix possible data races of inuse_pages
has been removed from the -mm tree.  Its filename was
     mm-swapfile-fix-possible-data-races-of-inuse_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swapfile: fix possible data races of inuse_pages
Date: Wed, 8 Jun 2022 22:40:30 +0800

si->inuse_pages could still be accessed concurrently now.  The plain reads
outside si->lock critical section, i.e.  swap_show and si_swapinfo, which
results in data races.  READ_ONCE and WRITE_ONCE is used to fix such data
races.  Note these data races should be ok because they're just used for
showing swap info.

[linmiaohe@huawei.com: use WRITE_ONCE to pair with READ_ONCE]
  Link: https://lkml.kernel.org/r/20220625093346.48894-2-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220608144031.829-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-fix-possible-data-races-of-inuse_pages
+++ a/mm/swapfile.c
@@ -695,7 +695,7 @@ static void swap_range_alloc(struct swap
 		si->lowest_bit += nr_entries;
 	if (end == si->highest_bit)
 		WRITE_ONCE(si->highest_bit, si->highest_bit - nr_entries);
-	si->inuse_pages += nr_entries;
+	WRITE_ONCE(si->inuse_pages, si->inuse_pages + nr_entries);
 	if (si->inuse_pages == si->pages) {
 		si->lowest_bit = si->max;
 		si->highest_bit = 0;
@@ -732,7 +732,7 @@ static void swap_range_free(struct swap_
 			add_to_avail_list(si);
 	}
 	atomic_long_add(nr_entries, &nr_swap_pages);
-	si->inuse_pages -= nr_entries;
+	WRITE_ONCE(si->inuse_pages, si->inuse_pages - nr_entries);
 	if (si->flags & SWP_BLKDEV)
 		swap_slot_free_notify =
 			si->bdev->bd_disk->fops->swap_slot_free_notify;
@@ -2640,7 +2640,7 @@ static int swap_show(struct seq_file *sw
 	}
 
 	bytes = si->pages << (PAGE_SHIFT - 10);
-	inuse = si->inuse_pages << (PAGE_SHIFT - 10);
+	inuse = READ_ONCE(si->inuse_pages) << (PAGE_SHIFT - 10);
 
 	file = si->swap_file;
 	len = seq_file_path(swap, file, " \t\n\\");
@@ -3259,7 +3259,7 @@ void si_swapinfo(struct sysinfo *val)
 		struct swap_info_struct *si = swap_info[type];
 
 		if ((si->flags & SWP_USED) && !(si->flags & SWP_WRITEOK))
-			nr_to_be_unused += si->inuse_pages;
+			nr_to_be_unused += READ_ONCE(si->inuse_pages);
 	}
 	val->freeswap = atomic_long_read(&nr_swap_pages) + nr_to_be_unused;
 	val->totalswap = total_swap_pages + nr_to_be_unused;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

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


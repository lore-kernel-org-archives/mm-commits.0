Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE6BC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 00:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiGDABh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 20:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiGDABh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 20:01:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7969260E9
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 17:01:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 97FF9CE107B
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 00:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E9DC341C6;
        Mon,  4 Jul 2022 00:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656892892;
        bh=Gpjg2YJ1cKR+hq6Wf35fEMPtNFA2IKmt56DBs5NSCjY=;
        h=Date:To:From:Subject:From;
        b=RhGRMLhD0hdcyDqQxUWWikaYkB6OjvuWfEbg3nyzppD+RrmRq9cHkXTqyg1ZzjRaG
         fa0vLxLlm5M4sfxYjyq4vesiQdsro2eyGgBRkCQ/mCN1lKB6A6F9zywARegyU4xRpz
         Jw0OVrAuS002HP3TGLt47ZSqnTDTnJRlvXio/y30=
Date:   Sun, 03 Jul 2022 17:01:31 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swapfile-fix-possible-data-races-of-inuse_pages-v3.patch removed from -mm tree
Message-Id: <20220704000132.86E9DC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-swapfile-fix-possible-data-races-of-inuse_pages-v3
has been removed from the -mm tree.  Its filename was
     mm-swapfile-fix-possible-data-races-of-inuse_pages-v3.patch

This patch was dropped because it was folded into mm-swapfile-fix-possible-data-races-of-inuse_pages.patch

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm-swapfile-fix-possible-data-races-of-inuse_pages-v3
Date: Sat, 25 Jun 2022 17:33:45 +0800

use WRITE_ONCE to pair with READ_ONCE

Link: https://lkml.kernel.org/r/20220625093346.48894-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-fix-possible-data-races-of-inuse_pages-v3
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
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
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


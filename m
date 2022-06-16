Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F23C43334
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jun 2022 20:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiFPUtZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 16:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378873AbiFPUsx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 16:48:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845E85EBD5
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 13:48:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 178C9B82466
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 20:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CFAC3411B;
        Thu, 16 Jun 2022 20:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655412529;
        bh=4FbDUiO/+qFxwLa64HTQjQC5D6WOl4hzVGQePSVnIuY=;
        h=Date:To:From:Subject:From;
        b=OyzpuLKVI2ihQSAT4xYq4iYXVDJjG2WhalE8pe7+G8z5al8c/u9kggCh599HLNNs3
         ei8VPbd5KfS+QylvK0fYWbJJem5iQopfy/yQGmbzJ5jHO8Bl4Jq0/HH6bRFa5yHBM5
         Ou4gQd5WZOYa1DKyErp7IXj1IDkecWFP+V2kqAh4=
Date:   Thu, 16 Jun 2022 13:48:48 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, surenb@google.com,
        shy828301@gmail.com, peterx@redhat.com, neilb@suse.de,
        mike.kravetz@oracle.com, dhowells@redhat.com, david@redhat.com,
        apopple@nvidia.com, aarcange@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-minor-cleanup-for-collapse_file.patch removed from -mm tree
Message-Id: <20220616204849.C1CFAC3411B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: minor cleanup for collapse_file
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-minor-cleanup-for-collapse_file.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/khugepaged: minor cleanup for collapse_file
Date: Sat, 11 Jun 2022 16:47:28 +0800

nr_none is always 0 for non-shmem case because the page can be read from
the backend store.  So when nr_none !  = 0, it must be in is_shmem case. 
Also only adjust the nrpages and uncharge shmem when nr_none != 0 to save
cpu cycles.

Link: https://lkml.kernel.org/r/20220611084731.55155-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-minor-cleanup-for-collapse_file
+++ a/mm/khugepaged.c
@@ -1885,8 +1885,7 @@ out_unlock:
 
 	if (nr_none) {
 		__mod_lruvec_page_state(new_page, NR_FILE_PAGES, nr_none);
-		if (is_shmem)
-			__mod_lruvec_page_state(new_page, NR_SHMEM, nr_none);
+		__mod_lruvec_page_state(new_page, NR_SHMEM, nr_none);
 	}
 
 	/* Join all the small entries into a single multi-index entry */
@@ -1950,10 +1949,10 @@ xa_unlocked:
 
 		/* Something went wrong: roll back page cache changes */
 		xas_lock_irq(&xas);
-		mapping->nrpages -= nr_none;
-
-		if (is_shmem)
+		if (nr_none) {
+			mapping->nrpages -= nr_none;
 			shmem_uncharge(mapping->host, nr_none);
+		}
 
 		xas_set(&xas, start);
 		xas_for_each(&xas, page, end - 1) {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

maintainers-add-myself-as-a-memory-failure-reviewer.patch
mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch
mm-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-memremap-fix-wrong-function-name-above-memremap_pages.patch
mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-vmscan-dont-try-to-reclaim-freed-folios.patch
lib-test_hmm-avoid-accessing-uninitialized-pages.patch
mm-memremap-fix-memunmap_pages-race-with-get_dev_pagemap.patch
mm-khugepaged-use-helper-macro-__attr_rw.patch
mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch
mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch


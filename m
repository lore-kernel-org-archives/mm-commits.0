Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A56D9C43334
	for <mm-commits@archiver.kernel.org>; Sun,  3 Jul 2022 23:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiGCXGB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 19:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiGCXGA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 19:06:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F15B2665
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 16:05:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40609B8015B
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 23:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5543C341C6;
        Sun,  3 Jul 2022 23:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656889556;
        bh=0k2CnyToS+wo/JTjs0/MrUlvBtVX93VOcpy/aiN2B9g=;
        h=Date:To:From:Subject:From;
        b=vz/AwAJ6E9O5JEuWiudWxPYk6hxyvUdK9hxa6UOol3V3Y8FaxWJ4ZqHem+pQpJSXB
         1V27GqnO9+fpMtn1/Kixe2A70E0P2iiGBS1qa5LC4tiEXz5Ao+2a9BBXeDgJSYnokh
         W8HtZU08YEGedgyGli6ZRtfsolxut5LI8WtUim5k=
Date:   Sun, 03 Jul 2022 16:05:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmscan-dont-try-to-reclaim-freed-folios.patch removed from -mm tree
Message-Id: <20220703230556.A5543C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: don't try to reclaim freed folios
has been removed from the -mm tree.  Its filename was
     mm-vmscan-dont-try-to-reclaim-freed-folios.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmscan: don't try to reclaim freed folios
Date: Wed, 8 Jun 2022 22:14:32 +0800

If folios were freed from under us, there's no need to reclaim them.  Skip
these folios to save lots of cpu cycles and avoid possible unnecessary
disk I/O.

Link: https://lkml.kernel.org/r/20220608141432.23258-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-dont-try-to-reclaim-freed-folios
+++ a/mm/vmscan.c
@@ -1610,13 +1610,19 @@ retry:
 		folio = lru_to_folio(page_list);
 		list_del(&folio->lru);
 
+		nr_pages = folio_nr_pages(folio);
+
+		if (folio_ref_count(folio) == 1 &&
+		    folio_ref_freeze(folio, 1)) {
+			/* folio was freed from under us. So we are done. */
+			goto free_it;
+		}
+
 		if (!folio_trylock(folio))
 			goto keep;
 
 		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
 
-		nr_pages = folio_nr_pages(folio);
-
 		/* Account the number of base pages */
 		sc->nr_scanned += nr_pages;
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages-v3.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
mm-khugepaged-remove-unneeded-shmem_huge_enabled-check.patch
mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs.patch
mm-khugepaged-trivial-typo-and-codestyle-cleanup.patch
mm-khugepaged-minor-cleanup-for-collapse_file.patch
mm-khugepaged-use-helper-macro-__attr_rw.patch
mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch
mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch


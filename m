Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B62C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383763AbiEMTXU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383779AbiEMTWh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1417132EC3
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5AFEB83159
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77EF9C34113;
        Fri, 13 May 2022 19:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469713;
        bh=Xwmb0/rTLOPJoaxyixgvrgrJuGCiTcqT0rcHXsTEcDQ=;
        h=Date:To:From:Subject:From;
        b=Wkve1hFP8DuppxfwI4XEsaNFy9v9qO8gNlCyXlAHjhuxzhcYDNONiGb14vZjKdMad
         FKFLOcfr8mEIq3B5GYChvT9+nD2pv5Ev6ID8lBLD52pO3/2TKGKAzKQNM/Yfoln82b
         B1cip4VulWaXcz3yqWapPHjLO/eKU9dSmxPomdCU=
Date:   Fri, 13 May 2022 12:21:52 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmscan-convert-the-activate_locked-portion-of-shrink_page_list-to-folios.patch removed from -mm tree
Message-Id: <20220513192153.77EF9C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: vmscan: convert the activate_locked portion of shrink_page_list to folios
has been removed from the -mm tree.  Its filename was
     vmscan-convert-the-activate_locked-portion-of-shrink_page_list-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: vmscan: convert the activate_locked portion of shrink_page_list to folios

This accounts the number of pages activated correctly for large folios.

Link: https://lkml.kernel.org/r/20220504182857.4013401-14-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/mm/vmscan.c~vmscan-convert-the-activate_locked-portion-of-shrink_page_list-to-folios
+++ a/mm/vmscan.c
@@ -1946,15 +1946,16 @@ activate_locked_split:
 		}
 activate_locked:
 		/* Not a candidate for swapping, so reclaim swap space. */
-		if (PageSwapCache(page) && (mem_cgroup_swap_full(page) ||
-						PageMlocked(page)))
-			try_to_free_swap(page);
-		VM_BUG_ON_PAGE(PageActive(page), page);
-		if (!PageMlocked(page)) {
-			int type = page_is_file_lru(page);
-			SetPageActive(page);
+		if (folio_test_swapcache(folio) &&
+		    (mem_cgroup_swap_full(&folio->page) ||
+		     folio_test_mlocked(folio)))
+			try_to_free_swap(&folio->page);
+		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
+		if (!folio_test_mlocked(folio)) {
+			int type = folio_is_file_lru(folio);
+			folio_set_active(folio);
 			stat->nr_activate[type] += nr_pages;
-			count_memcg_page_event(page, PGACTIVATE);
+			count_memcg_folio_events(folio, PGACTIVATE, nr_pages);
 		}
 keep_locked:
 		unlock_page(page);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch


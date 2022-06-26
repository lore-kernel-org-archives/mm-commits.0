Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 988F1C43334
	for <mm-commits@archiver.kernel.org>; Sun, 26 Jun 2022 20:28:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbiFZU2B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Jun 2022 16:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbiFZU1z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Jun 2022 16:27:55 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A673EB5
        for <mm-commits@vger.kernel.org>; Sun, 26 Jun 2022 13:27:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5E029CE1126
        for <mm-commits@vger.kernel.org>; Sun, 26 Jun 2022 20:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD71C34114;
        Sun, 26 Jun 2022 20:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656275270;
        bh=BgypHAxxb5RwlHyZZNhBqaoiAhnEBjZBY1bpBaOUqRw=;
        h=Date:To:From:Subject:From;
        b=XBMCh7cSXT2RdawO87mALBf7NogceN3d9lXzDYf1DGiJ5Y94XCjiwLq9lqpW0aN0i
         QMf2jYxYqiudyU+l33bJhOBycsRkdN/j2oWjnRh8KYmX5dH6gS1hInoeh62ZeRLCgA
         tggVkXZ0Y/BxEJ+ekON5RhRN/l5elyml8kBSd70o=
Date:   Sun, 26 Jun 2022 13:27:50 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, surenb@google.com,
        shy828301@gmail.com, peterx@redhat.com, neilb@suse.de,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        aarcange@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-minor-cleanup-for-collapse_file.patch added to mm-unstable branch
Message-Id: <20220626202750.9DD71C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: minor cleanup for collapse_file
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-minor-cleanup-for-collapse_file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-minor-cleanup-for-collapse_file.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/khugepaged: minor cleanup for collapse_file
Date: Sat, 25 Jun 2022 17:28:13 +0800

nr_none is always 0 for non-shmem case because the page can be read from
the backend store.  So when nr_none !  = 0, it must be in is_shmem case. 
Also only adjust the nrpages and uncharge shmem when nr_none != 0 to save
cpu cycles.

Link: https://lkml.kernel.org/r/20220625092816.4856-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-minor-cleanup-for-collapse_file
+++ a/mm/khugepaged.c
@@ -1852,8 +1852,8 @@ out_unlock:
 
 	if (nr_none) {
 		__mod_lruvec_page_state(new_page, NR_FILE_PAGES, nr_none);
-		if (is_shmem)
-			__mod_lruvec_page_state(new_page, NR_SHMEM, nr_none);
+		/* nr_none is always 0 for non-shmem. */
+		__mod_lruvec_page_state(new_page, NR_SHMEM, nr_none);
 	}
 
 	/* Join all the small entries into a single multi-index entry */
@@ -1917,10 +1917,10 @@ xa_unlocked:
 
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

mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-vmscan-dont-try-to-reclaim-freed-folios.patch
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


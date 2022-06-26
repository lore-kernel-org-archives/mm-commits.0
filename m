Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B13CAC43334
	for <mm-commits@archiver.kernel.org>; Sun, 26 Jun 2022 20:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbiFZUc0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Jun 2022 16:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbiFZUcZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Jun 2022 16:32:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C661327
        for <mm-commits@vger.kernel.org>; Sun, 26 Jun 2022 13:32:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA78060FBD
        for <mm-commits@vger.kernel.org>; Sun, 26 Jun 2022 20:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A27C341CA;
        Sun, 26 Jun 2022 20:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656275543;
        bh=GhXwuA2tGyYNt2aq8cs2XuFOcY9MipMv/m+T+yAMO88=;
        h=Date:To:From:Subject:From;
        b=kTb0nm0RuPNv+fbi3etr9hkRHL6gxPT2PIbAoL8ma8vajamLoeRyyY5JjVK58vpLx
         EWq+bgoGyUTtyuvWcb+ZRkvPHl6/UesOjtEaf9CuSEd/kzh7d61CsGAKcMYSQR6TpZ
         3sVjpCF9GK9bWyHj9CLSnKeFmVF4JWmV78qZrdo8=
Date:   Sun, 26 Jun 2022 13:32:22 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-fix-possible-data-races-of-inuse_pages-v3.patch added to mm-unstable branch
Message-Id: <20220626203223.43A27C341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swapfile-fix-possible-data-races-of-inuse_pages-v3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swapfile-fix-possible-data-races-of-inuse_pages-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-fix-possible-data-races-of-inuse_pages-v3.patch

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
mm-swapfile-fix-possible-data-races-of-inuse_pages-v3.patch
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


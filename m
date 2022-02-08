Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61EB9C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  8 Feb 2022 22:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387615AbiBHWZx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:25:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387100AbiBHVyP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2022 16:54:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88ABC0612B8
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 13:54:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8363D615FB
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 21:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3399C004E1;
        Tue,  8 Feb 2022 21:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644357253;
        bh=IsZeIjqTBn4YhXG1T8G9cRq/ADMaMRlzO7/GKCXBN6s=;
        h=Date:To:From:Subject:From;
        b=oO8dlwG1xuujW0kbuue28ND8HohKP4KNuna1Q/rIgtaVC0QoEfzasQ+6UfXFZO2Np
         6MXACvBklsdRSvua1h4t63q4L5ILchQAMoTWQF8rTfeIlgpE1eZU604mKWXZWZWBn8
         twVl5t0On5glsZkemJAVXmFn8zUTVCEAqAg0+J8k=
Date:   Tue, 08 Feb 2022 13:54:12 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, surenb@google.com, shakeelb@google.com,
        riel@surriel.com, mhocko@suse.com, kirill@shutemov.name,
        hannes@cmpxchg.org, gthelen@google.com, david@redhat.com,
        apopple@nvidia.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-collapse_file-do-try_to_unmapttu_batch_flush.patch added to -mm tree
Message-Id: <20220208215412.D3399C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: collapse_file() do try_to_unmap(TTU_BATCH_FLUSH)
has been added to the -mm tree.  Its filename is
     mm-thp-collapse_file-do-try_to_unmapttu_batch_flush.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-collapse_file-do-try_to_unmapttu_batch_flush.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-collapse_file-do-try_to_unmapttu_batch_flush.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/thp: collapse_file() do try_to_unmap(TTU_BATCH_FLUSH)

collapse_file() is using unmap_mapping_pages(1) on each small page found
mapped, unlike others (reclaim, migration, splitting, memory-failure) who
use try_to_unmap().  There are four advantages to try_to_unmap(): first,
its TTU_IGNORE_MLOCK option now avoids leaving mlocked page in pagevec;
second, its vma lookup uses i_mmap_lock_read() not i_mmap_lock_write();
third, it breaks out early if page is not mapped everywhere it might be;
fourth, its TTU_BATCH_FLUSH option can be used, as in page reclaim, to
save up all the TLB flushing until all of the pages have been unmapped.

Wild guess: perhaps it was originally written to use try_to_unmap(), but
hit the VM_BUG_ON_PAGE(page_mapped) after unmapping, because without
TTU_SYNC it may skip page table locks; but unmap_mapping_pages() never
skips them, so fixed the issue.  I did once hit that VM_BUG_ON_PAGE()
since making this change: we could pass TTU_SYNC here, but I think just
delete the check - the race is very rare, this is an ordinary small page
so we don't need to be so paranoid about mapcount surprises, and the
page_ref_freeze() just below already handles the case adequately.

Link: https://lkml.kernel.org/r/cc3ad3e4-7045-f00-5a81-de3e3de6b69@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-thp-collapse_file-do-try_to_unmapttu_batch_flush
+++ a/mm/khugepaged.c
@@ -1823,13 +1823,12 @@ static void collapse_file(struct mm_stru
 		}
 
 		if (page_mapped(page))
-			unmap_mapping_pages(mapping, index, 1, false);
+			try_to_unmap(page, TTU_IGNORE_MLOCK | TTU_BATCH_FLUSH);
 
 		xas_lock_irq(&xas);
 		xas_set(&xas, index);
 
 		VM_BUG_ON_PAGE(page != xas_load(&xas), page);
-		VM_BUG_ON_PAGE(page_mapped(page), page);
 
 		/*
 		 * The page is expected to have page_count() == 3:
@@ -1893,6 +1892,13 @@ xa_locked:
 	xas_unlock_irq(&xas);
 xa_unlocked:
 
+	/*
+	 * If collapse is successful, flush must be done now before copying.
+	 * If collapse is unsuccessful, does flush actually need to be done?
+	 * Do it anyway, to clear the state.
+	 */
+	try_to_unmap_flush();
+
 	if (result == SCAN_SUCCEED) {
 		struct page *page, *tmp;
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-munlock-delete-page_mlock-and-all-its-works.patch
mm-munlock-delete-foll_mlock-and-foll_populate.patch
mm-munlock-delete-munlock_vma_pages_all-allow-oomreap.patch
mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page.patch
mm-munlock-replace-clear_page_mlock-by-final-clearance.patch
mm-munlock-maintain-page-mlock_count-while-unevictable.patch
mm-munlock-mlock_pte_range-when-mlocking-or-munlocking.patch
mm-migrate-__unmap_and_move-push-good-newpage-to-lru.patch
mm-munlock-delete-smp_mb-from-__pagevec_lru_add_fn.patch
mm-munlock-mlock_page-munlock_page-batch-by-pagevec.patch
mm-munlock-page-migration-needs-mlock-pagevec-drained.patch
mm-thp-collapse_file-do-try_to_unmapttu_batch_flush.patch
mm-thp-shrink_page_list-avoid-splitting-vm_locked-thp.patch


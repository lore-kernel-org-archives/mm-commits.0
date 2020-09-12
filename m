Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6887CC43461
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 23:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B487217BA
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 23:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599953062;
	bh=FYFR8YtfPM+cDsLBsuEKW2WP1ji1vYIwtHnDnc38yHA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=09SAuAui98IOu43vHpdHzazDe1EDWP14LocyThU5K9x+4vPgNbW2NJH41ifIZ5tC1
	 b/4/8x7eT9VPc0ip9JOyqtk0cirp8shHiKA1E/kVGFKMoyiZ/ARN5zTigxqrMVwkxn
	 wSo2dSiVC7rJRyjNgF3w0MxFm1pG3o0cggxV9jkY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbgILXYV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 19:24:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgILXYQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 19:24:16 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAA4F21775;
        Sat, 12 Sep 2020 23:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599953056;
        bh=FYFR8YtfPM+cDsLBsuEKW2WP1ji1vYIwtHnDnc38yHA=;
        h=Date:From:To:Subject:From;
        b=pJEe97sYh27V+11zuUe5Q5NBuZ7pzU5kmbfCOuuFz6SkBmIeAKJb6HUCLXgUgYRW5
         8uD6Wzg4WEW7jFOqf1v2MukXnJZTwt9HeJ12OWMlrWJLEMHLVuG0Bnyu2tzYm0U0DH
         Ae+SjcV0DRTIX+O+QWb+Knhz1Whi7f7MWC1yhg/k=
Date:   Sat, 12 Sep 2020 16:24:15 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        william.kucharski@oracle.com, matthew.auld@intel.com,
        jani.nikula@linux.intel.com, hughd@google.com, hannes@cmpxchg.org,
        chris@chris-wilson.co.uk, adobriyan@gmail.com, willy@infradead.org
Subject:  + mm-use-find_get_incore_page-in-memcontrol.patch added to
 -mm tree
Message-ID: <20200912232415.IeXB-%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use find_get_incore_page in memcontrol
has been added to the -mm tree.  Its filename is
     mm-use-find_get_incore_page-in-memcontrol.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-use-find_get_incore_page-in-memcontrol.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-use-find_get_incore_page-in-memcontrol.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use find_get_incore_page in memcontrol

The current code does not protect against swapoff of the underlying
swap device, so this is a bug fix as well as a worthwhile reduction in
code complexity.

Link: https://lkml.kernel.org/r/20200910183318.20139-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

--- a/mm/memcontrol.c~mm-use-find_get_incore_page-in-memcontrol
+++ a/mm/memcontrol.c
@@ -5539,35 +5539,15 @@ static struct page *mc_handle_swap_pte(s
 static struct page *mc_handle_file_pte(struct vm_area_struct *vma,
 			unsigned long addr, pte_t ptent, swp_entry_t *entry)
 {
-	struct page *page = NULL;
-	struct address_space *mapping;
-	pgoff_t pgoff;
-
 	if (!vma->vm_file) /* anonymous vma */
 		return NULL;
 	if (!(mc.flags & MOVE_FILE))
 		return NULL;
 
-	mapping = vma->vm_file->f_mapping;
-	pgoff = linear_page_index(vma, addr);
-
 	/* page is moved even if it's not RSS of this task(page-faulted). */
-#ifdef CONFIG_SWAP
 	/* shmem/tmpfs may report page out on swap: account for that too. */
-	if (shmem_mapping(mapping)) {
-		page = find_get_entry(mapping, pgoff);
-		if (xa_is_value(page)) {
-			swp_entry_t swp = radix_to_swp_entry(page);
-			*entry = swp;
-			page = find_get_page(swap_address_space(swp),
-					     swp_offset(swp));
-		}
-	} else
-		page = find_get_page(mapping, pgoff);
-#else
-	page = find_get_page(mapping, pgoff);
-#endif
-	return page;
+	return find_get_incore_page(vma->vm_file->f_mapping,
+			linear_page_index(vma, addr));
 }
 
 /**
_

Patches currently in -mm which might be from willy@infradead.org are

mm-debug-do-not-dereference-i_ino-blindly.patch
mm-factor-find_get_incore_page-out-of-mincore_page.patch
mm-use-find_get_incore_page-in-memcontrol.patch
mm-optimise-madvise-willneed.patch
proc-optimise-smaps-for-shmem-entries.patch
i915-use-find_lock_page-instead-of-find_lock_entry.patch
mm-convert-find_get_entry-to-return-the-head-page.patch
mm-shmem-return-head-page-from-find_lock_entry.patch
mm-add-find_lock_head.patch
mm-account-pmd-tables-like-pte-tables.patch
mm-move-pagedoublemap-bit.patch
mm-simplify-pagedoublemap-with-pf_second-policy.patch
xarray-add-xa_get_order.patch
xarray-add-xas_split.patch
xarray-add-xas_split-fix-2.patch
mm-filemap-fix-storing-to-a-thp-shadow-entry.patch
mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps.patch
mm-memory-remove-page-fault-assumption-of-compound-page-size.patch
mm-page_owner-change-split_page_owner-to-take-a-count.patch
mm-huge_memory-fix-page_trans_huge_mapcount-assumption-of-thp-size.patch
mm-huge_memory-fix-can_split_huge_page-assumption-of-thp-size.patch
mm-rmap-fix-assumptions-of-thp-size.patch
mm-truncate-fix-truncation-for-pages-of-arbitrary-size.patch
mm-page-writeback-support-tail-pages-in-wait_for_stable_page.patch
mm-vmscan-allow-arbitrary-sized-pages-to-be-paged-out.patch
mm-readahead-add-define_readahead.patch
mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control.patch
mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch
mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra.patch
harden-autofs-ioctl-table.patch


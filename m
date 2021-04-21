Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CB6C433B4
	for <mm-commits@archiver.kernel.org>; Wed, 21 Apr 2021 02:54:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F3B361405
	for <mm-commits@archiver.kernel.org>; Wed, 21 Apr 2021 02:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234682AbhDUCzR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Apr 2021 22:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233874AbhDUCzQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Apr 2021 22:55:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFAB261415;
        Wed, 21 Apr 2021 02:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618973684;
        bh=+6haH6tp9HzY56vfG9Ec6qJOD37WPdW8h3EoTpUG5kA=;
        h=Date:From:To:Subject:From;
        b=djQFY21T774daL3rnDnd7rWUMnVh9UQzJUWc4+Mh4rE+kYnpKfwpnaQRxukgK+2sT
         nJy2gMlvnqqJJHAVu/vBn84Md32cqzDM8QFwdwNYENalCiy65tpBerNGCfnG2HIBl6
         zvEnX1vn4TYe0UI3XHpU+XlWyZCMZrBRqnbthgRo=
Date:   Tue, 20 Apr 2021 19:54:43 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        songmuchun@bytedance.com, vbabka@suse.cz
Subject:  +
 mmhugetlb-drop-clearing-of-flag-from-prep_new_huge_page.patch added to -mm
 tree
Message-ID: <20210421025443.LgHTshxTj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hugetlb: drop clearing of flag from prep_new_huge_page
has been added to the -mm tree.  Its filename is
     mmhugetlb-drop-clearing-of-flag-from-prep_new_huge_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhugetlb-drop-clearing-of-flag-from-prep_new_huge_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhugetlb-drop-clearing-of-flag-from-prep_new_huge_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hugetlb: drop clearing of flag from prep_new_huge_page

Pages allocated via the page allocator or CMA get its private field
cleared by means of post_alloc_hook().

Pages allocated during boot, that is directly from the memblock allocator,
get cleared by
paging_init()->..->memmap_init_zone->..->__init_single_page() before any
memblock allocation.

Based on this ground, let us remove the clearing of the flag from
prep_new_huge_page() as it is not needed.  This was a leftover from
6c0371490140 ("hugetlb: convert PageHugeFreed to HPageFreed flag"). 
Previously the explicit clearing was necessary because compound
allocations do not get this initialization (see prep_compound_page).

Link: https://lkml.kernel.org/r/20210419075413.1064-4-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/hugetlb.c~mmhugetlb-drop-clearing-of-flag-from-prep_new_huge_page
+++ a/mm/hugetlb.c
@@ -1494,7 +1494,6 @@ static void prep_new_huge_page(struct hs
 	spin_lock_irq(&hugetlb_lock);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
-	ClearHPageFreed(page);
 	spin_unlock_irq(&hugetlb_lock);
 }
 
_

Patches currently in -mm which might be from osalvador@suse.de are

x86-vmemmap-drop-handling-of-4k-unaligned-vmemmap-range.patch
x86-vmemmap-drop-handling-of-1gb-vmemmap-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges-fix.patch
x86-vmemmap-optimize-for-consecutive-sections-in-partial-populated-pmds.patch
mmpage_alloc-bail-out-earlier-on-enomem-in-alloc_contig_migrate_range.patch
mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes.patch
mmhugetlb-drop-clearing-of-flag-from-prep_new_huge_page.patch
mmhugetlb-split-prep_new_huge_page-functionality.patch
mm-make-alloc_contig_range-handle-free-hugetlb-pages.patch
mm-make-alloc_contig_range-handle-in-use-hugetlb-pages.patch
mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig.patch
drivers-base-memory-introduce-memory_block_onlineoffline.patch
mmmemory_hotplug-relax-fully-spanned-sections-check.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range.patch
acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch
mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory.patch
x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch
arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch


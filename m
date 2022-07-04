Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01624C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbiGDBNN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbiGDBMH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:12:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6AAC630D
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:11:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 33511CE02C2
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F854C341C7;
        Mon,  4 Jul 2022 01:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897064;
        bh=3AStNMXQ0syPmpr4Q66NkPc9THlb8zIsBG3afV+9c8s=;
        h=Date:To:From:Subject:From;
        b=i1BtLTHxtP98vMfozlsQd5XOxDX5SNjXkNQmQaGyclAU+IGbMZ2FArI/0Msf1UFVw
         XnslIcQkvWpu/dxFQdB6OEqwVAaynE9hVpkScOHYTUc5b+ju8WgArx0rfL+er87UNo
         mGQXyIumdpEExI2gPZbolaC7W/YIkioJ9o6FayR0=
Date:   Sun, 03 Jul 2022 18:11:03 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, surenb@google.com,
        shy828301@gmail.com, peterx@redhat.com, neilb@suse.de,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        aarcange@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch removed from -mm tree
Message-Id: <20220704011104.8F854C341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: try to free transhuge swapcache when possible
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/khugepaged: try to free transhuge swapcache when possible
Date: Sat, 25 Jun 2022 17:28:16 +0800

Transhuge swapcaches won't be freed in __collapse_huge_page_copy().  It's
because release_pte_page() is not called for these pages and thus
free_page_and_swap_cache can't grab the page lock.  These pages won't be
freed from swap cache even if we are the only user until next time
reclaim.  It shouldn't hurt indeed, but we could try to free these pages
to save more memory for system.

Link: https://lkml.kernel.org/r/20220625092816.4856-8-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
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
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    5 +++++
 mm/khugepaged.c      |    7 ++++++-
 mm/swap.h            |    5 -----
 3 files changed, 11 insertions(+), 6 deletions(-)

--- a/include/linux/swap.h~mm-khugepaged-try-to-free-transhuge-swapcache-when-possible
+++ a/include/linux/swap.h
@@ -455,6 +455,7 @@ static inline unsigned long total_swapca
 	return global_node_page_state(NR_SWAPCACHE);
 }
 
+extern void free_swap_cache(struct page *page);
 extern void free_page_and_swap_cache(struct page *);
 extern void free_pages_and_swap_cache(struct page **, int);
 /* linux/mm/swapfile.c */
@@ -539,6 +540,10 @@ static inline void put_swap_device(struc
 /* used to sanity check ptes in zap_pte_range when CONFIG_SWAP=0 */
 #define free_swap_and_cache(e) is_pfn_swap_entry(e)
 
+static inline void free_swap_cache(struct page *page)
+{
+}
+
 static inline int add_swap_count_continuation(swp_entry_t swp, gfp_t gfp_mask)
 {
 	return 0;
--- a/mm/khugepaged.c~mm-khugepaged-try-to-free-transhuge-swapcache-when-possible
+++ a/mm/khugepaged.c
@@ -755,7 +755,12 @@ static void __collapse_huge_page_copy(pt
 
 	list_for_each_entry_safe(src_page, tmp, compound_pagelist, lru) {
 		list_del(&src_page->lru);
-		release_pte_page(src_page);
+		mod_node_page_state(page_pgdat(src_page),
+				    NR_ISOLATED_ANON + page_is_file_lru(src_page),
+				    -compound_nr(src_page));
+		unlock_page(src_page);
+		free_swap_cache(src_page);
+		putback_lru_page(src_page);
 	}
 }
 
--- a/mm/swap.h~mm-khugepaged-try-to-free-transhuge-swapcache-when-possible
+++ a/mm/swap.h
@@ -41,7 +41,6 @@ void __delete_from_swap_cache(struct fol
 void delete_from_swap_cache(struct folio *folio);
 void clear_shadow_from_swap_cache(int type, unsigned long begin,
 				  unsigned long end);
-void free_swap_cache(struct page *page);
 struct page *lookup_swap_cache(swp_entry_t entry,
 			       struct vm_area_struct *vma,
 			       unsigned long addr);
@@ -81,10 +80,6 @@ static inline struct address_space *swap
 	return NULL;
 }
 
-static inline void free_swap_cache(struct page *page)
-{
-}
-
 static inline void show_swap_cache_info(void)
 {
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch


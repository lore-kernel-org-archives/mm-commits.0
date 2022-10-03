Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E58C9C43217
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiJCVFo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJCVFL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED0EA1B6
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:04:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B9D66118C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC94C433D7;
        Mon,  3 Oct 2022 21:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831090;
        bh=g91c2aKnpStpMf55CseLGna2aZPQWiJV+qmL53uVm+E=;
        h=Date:To:From:Subject:From;
        b=T7iPGM6LAafiboLZQmD6iM1VI0GEirrVK/DTglAhwJ5ZqOqz8xj6BcifMwHocUUIA
         kBquJQJPdxy7KDeUDXQ70vtSvNypnBR5AWHVFiRuo2GBXsW4ojJGjB+vdbM6BBSP1/
         Z0h0aGHGsfTKVa1/nHg8VmfWPHmVRz68OLYrPYSs=
Date:   Mon, 03 Oct 2022 14:04:50 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-convert-put_swap_page-to-put_swap_folio.patch removed from -mm tree
Message-Id: <20221003210450.CFC94C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: convert put_swap_page() to put_swap_folio()
has been removed from the -mm tree.  Its filename was
     mm-swap-convert-put_swap_page-to-put_swap_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/swap: convert put_swap_page() to put_swap_folio()
Date: Fri, 2 Sep 2022 20:46:09 +0100

With all callers now using a folio, we can convert this function.

Link: https://lkml.kernel.org/r/20220902194653.1739778-14-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 ++--
 mm/shmem.c           |    2 +-
 mm/swap_slots.c      |    2 +-
 mm/swap_state.c      |    6 +++---
 mm/swapfile.c        |    4 ++--
 mm/vmscan.c          |    2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

--- a/include/linux/swap.h~mm-swap-convert-put_swap_page-to-put_swap_folio
+++ a/include/linux/swap.h
@@ -491,7 +491,7 @@ static inline long get_nr_swap_pages(voi
 extern void si_swapinfo(struct sysinfo *);
 swp_entry_t folio_alloc_swap(struct folio *folio);
 bool folio_free_swap(struct folio *folio);
-extern void put_swap_page(struct page *page, swp_entry_t entry);
+void put_swap_folio(struct folio *folio, swp_entry_t entry);
 extern swp_entry_t get_swap_page_of_type(int);
 extern int get_swap_pages(int n, swp_entry_t swp_entries[], int entry_size);
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
@@ -576,7 +576,7 @@ static inline void swap_free(swp_entry_t
 {
 }
 
-static inline void put_swap_page(struct page *page, swp_entry_t swp)
+static inline void put_swap_folio(struct folio *folio, swp_entry_t swp)
 {
 }
 
--- a/mm/shmem.c~mm-swap-convert-put_swap_page-to-put_swap_folio
+++ a/mm/shmem.c
@@ -1424,7 +1424,7 @@ static int shmem_writepage(struct page *
 	}
 
 	mutex_unlock(&shmem_swaplist_mutex);
-	put_swap_page(&folio->page, swap);
+	put_swap_folio(folio, swap);
 redirty:
 	folio_mark_dirty(folio);
 	if (wbc->for_reclaim)
--- a/mm/swapfile.c~mm-swap-convert-put_swap_page-to-put_swap_folio
+++ a/mm/swapfile.c
@@ -1332,7 +1332,7 @@ void swap_free(swp_entry_t entry)
 /*
  * Called after dropping swapcache to decrease refcnt to swap entries.
  */
-void put_swap_page(struct page *page, swp_entry_t entry)
+void put_swap_folio(struct folio *folio, swp_entry_t entry)
 {
 	unsigned long offset = swp_offset(entry);
 	unsigned long idx = offset / SWAPFILE_CLUSTER;
@@ -1341,7 +1341,7 @@ void put_swap_page(struct page *page, sw
 	unsigned char *map;
 	unsigned int i, free_entries = 0;
 	unsigned char val;
-	int size = swap_entry_size(thp_nr_pages(page));
+	int size = swap_entry_size(folio_nr_pages(folio));
 
 	si = _swap_info_get(entry);
 	if (!si)
--- a/mm/swap_slots.c~mm-swap-convert-put_swap_page-to-put_swap_folio
+++ a/mm/swap_slots.c
@@ -343,7 +343,7 @@ repeat:
 	get_swap_pages(1, &entry, 1);
 out:
 	if (mem_cgroup_try_charge_swap(folio, entry)) {
-		put_swap_page(&folio->page, entry);
+		put_swap_folio(folio, entry);
 		entry.val = 0;
 	}
 	return entry;
--- a/mm/swap_state.c~mm-swap-convert-put_swap_page-to-put_swap_folio
+++ a/mm/swap_state.c
@@ -218,7 +218,7 @@ bool add_to_swap(struct folio *folio)
 	return true;
 
 fail:
-	put_swap_page(&folio->page, entry);
+	put_swap_folio(folio, entry);
 	return false;
 }
 
@@ -237,7 +237,7 @@ void delete_from_swap_cache(struct folio
 	__delete_from_swap_cache(folio, entry, NULL);
 	xa_unlock_irq(&address_space->i_pages);
 
-	put_swap_page(&folio->page, entry);
+	put_swap_folio(folio, entry);
 	folio_ref_sub(folio, folio_nr_pages(folio));
 }
 
@@ -498,7 +498,7 @@ struct page *__read_swap_cache_async(swp
 	return &folio->page;
 
 fail_unlock:
-	put_swap_page(&folio->page, entry);
+	put_swap_folio(folio, entry);
 	folio_unlock(folio);
 	folio_put(folio);
 	return NULL;
--- a/mm/vmscan.c~mm-swap-convert-put_swap_page-to-put_swap_folio
+++ a/mm/vmscan.c
@@ -1352,7 +1352,7 @@ static int __remove_mapping(struct addre
 		mem_cgroup_swapout(folio, swap);
 		__delete_from_swap_cache(folio, swap, shadow);
 		xa_unlock_irq(&mapping->i_pages);
-		put_swap_page(&folio->page, swap);
+		put_swap_folio(folio, swap);
 	} else {
 		void (*free_folio)(struct folio *);
 
_

Patches currently in -mm which might be from willy@infradead.org are



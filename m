Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A14C4C43219
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiJCVH7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiJCVF4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2823123E
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59227B81123
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F1DC43470;
        Mon,  3 Oct 2022 21:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831130;
        bh=Vp9lk1C61X3yiVFuL9lmNqPp9bvAdiGOp0ZaXTgU8Mk=;
        h=Date:To:From:Subject:From;
        b=RKxvU9hMaSIeOWfwp5zRm3divy2iyi6/L9qHb0OhLgyqBYWcRNGyy4xKq8FdY1Y9B
         XW5GdhKheb1pRJQp3OQAgA2O32DtcTq1jml1mBb2L4zLSBnuCY8PtsfKlHnEST4YfD
         7U9FtwOyBqp4UJz7RzJzSuSZ9i8TaCccOY611BV4=
Date:   Mon, 03 Oct 2022 14:05:29 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-convert-mem_cgroup_swap_full-to-take-a-folio.patch removed from -mm tree
Message-Id: <20221003210529.F0F1DC43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg: convert mem_cgroup_swap_full() to take a folio
has been removed from the -mm tree.  Its filename was
     memcg-convert-mem_cgroup_swap_full-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: memcg: convert mem_cgroup_swap_full() to take a folio
Date: Fri, 2 Sep 2022 20:46:43 +0100

All callers now have a folio, so convert the function to take a folio. 
Saves a couple of calls to compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-48-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 ++--
 mm/memcontrol.c      |    6 +++---
 mm/memory.c          |    2 +-
 mm/swapfile.c        |    2 +-
 mm/vmscan.c          |    3 +--
 5 files changed, 8 insertions(+), 9 deletions(-)

--- a/include/linux/swap.h~memcg-convert-mem_cgroup_swap_full-to-take-a-folio
+++ a/include/linux/swap.h
@@ -692,7 +692,7 @@ static inline void mem_cgroup_uncharge_s
 }
 
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
-extern bool mem_cgroup_swap_full(struct page *page);
+extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
 static inline void mem_cgroup_swapout(struct folio *folio, swp_entry_t entry)
 {
@@ -714,7 +714,7 @@ static inline long mem_cgroup_get_nr_swa
 	return get_nr_swap_pages();
 }
 
-static inline bool mem_cgroup_swap_full(struct page *page)
+static inline bool mem_cgroup_swap_full(struct folio *folio)
 {
 	return vm_swap_full();
 }
--- a/mm/memcontrol.c~memcg-convert-mem_cgroup_swap_full-to-take-a-folio
+++ a/mm/memcontrol.c
@@ -7406,18 +7406,18 @@ long mem_cgroup_get_nr_swap_pages(struct
 	return nr_swap_pages;
 }
 
-bool mem_cgroup_swap_full(struct page *page)
+bool mem_cgroup_swap_full(struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
 	if (vm_swap_full())
 		return true;
 	if (cgroup_memory_noswap || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return false;
 
-	memcg = page_memcg(page);
+	memcg = folio_memcg(folio);
 	if (!memcg)
 		return false;
 
--- a/mm/memory.c~memcg-convert-mem_cgroup_swap_full-to-take-a-folio
+++ a/mm/memory.c
@@ -3647,7 +3647,7 @@ static inline bool should_try_to_free_sw
 {
 	if (!folio_test_swapcache(folio))
 		return false;
-	if (mem_cgroup_swap_full(&folio->page) || (vma->vm_flags & VM_LOCKED) ||
+	if (mem_cgroup_swap_full(folio) || (vma->vm_flags & VM_LOCKED) ||
 	    folio_test_mlocked(folio))
 		return true;
 	/*
--- a/mm/swapfile.c~memcg-convert-mem_cgroup_swap_full-to-take-a-folio
+++ a/mm/swapfile.c
@@ -148,7 +148,7 @@ static int __try_to_reclaim_swap(struct
 	if (folio_trylock(folio)) {
 		if ((flags & TTRS_ANYWAY) ||
 		    ((flags & TTRS_UNMAPPED) && !folio_mapped(folio)) ||
-		    ((flags & TTRS_FULL) && mem_cgroup_swap_full(&folio->page)))
+		    ((flags & TTRS_FULL) && mem_cgroup_swap_full(folio)))
 			ret = folio_free_swap(folio);
 		folio_unlock(folio);
 	}
--- a/mm/vmscan.c~memcg-convert-mem_cgroup_swap_full-to-take-a-folio
+++ a/mm/vmscan.c
@@ -2047,8 +2047,7 @@ activate_locked_split:
 activate_locked:
 		/* Not a candidate for swapping, so reclaim swap space. */
 		if (folio_test_swapcache(folio) &&
-		    (mem_cgroup_swap_full(&folio->page) ||
-		     folio_test_mlocked(folio)))
+		    (mem_cgroup_swap_full(folio) || folio_test_mlocked(folio)))
 			folio_free_swap(folio);
 		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
 		if (!folio_test_mlocked(folio)) {
_

Patches currently in -mm which might be from willy@infradead.org are



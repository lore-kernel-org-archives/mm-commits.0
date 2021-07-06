Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F38ECC07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBACE61C78
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhGFTNr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:13:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231702AbhGFTNr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:13:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B80BB61C74;
        Tue,  6 Jul 2021 19:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598668;
        bh=mI6fCaQUCjsAouRW/y6Z5Tg+NbSY7EgtJBJdyFYwwbI=;
        h=Date:From:To:Subject:From;
        b=OJhD5i/4HrMHX7A6OPXsygqhgMAjob3sNHzWqriEF/oJE+koBDKA0cXwgrGAiurSl
         HDKvRGxxc9Ydd4gVZ0EC8+C7czEutzbnpXWLiXOrtFq4gT7py5vmfNDYqRKU5dwKUf
         E8W4M8zQ+NUvlT64F86/t3FRg45Ez00pWnDcNm3Y=
Date:   Tue, 06 Jul 2021 12:11:07 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, dave.hansen@intel.com, hannes@cmpxchg.org,
        hughd@google.com, mgorman@suse.de, mhocko@kernel.org,
        mm-commits@vger.kernel.org, peterx@redhat.com, riel@surriel.com,
        tim.c.chen@intel.com, torvalds@linux-foundation.org,
        willy@infradead.org, ying.huang@intel.com
Subject:  [merged] mm-free-idle-swap-cache-page-after-cow.patch
 removed from -mm tree
Message-ID: <20210706191107.sv_6xVYCC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: free idle swap cache page after COW
has been removed from the -mm tree.  Its filename was
     mm-free-idle-swap-cache-page-after-cow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm: free idle swap cache page after COW

With commit 09854ba94c6a ("mm: do_wp_page() simplification"), after COW,
the idle swap cache page (neither the page nor the corresponding swap
entry is mapped by any process) will be left in the LRU list, even if it's
in the active list or the head of the inactive list.  So, the page
reclaimer may take quite some overhead to reclaim these actually unused
pages.

To help the page reclaiming, in this patch, after COW, the idle swap cache
page will be tried to be freed.  To avoid to introduce much overhead to
the hot COW code path,

a) there's almost zero overhead for non-swap case via checking
   PageSwapCache() firstly.

b) the page lock is acquired via trylock only.

To test the patch, we used pmbench memory accessing benchmark with
working-set larger than available memory on a 2-socket Intel server with a
NVMe SSD as swap device.  Test results shows that the pmbench score
increases up to 23.8% with the decreased size of swap cache and swapin
throughput.

Link: https://lkml.kernel.org/r/20210601053143.1380078-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>	[use free_swap_cache()]
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Tim Chen <tim.c.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    5 +++++
 mm/memory.c          |    2 ++
 mm/swap_state.c      |    2 +-
 3 files changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/swap.h~mm-free-idle-swap-cache-page-after-cow
+++ a/include/linux/swap.h
@@ -446,6 +446,7 @@ extern void __delete_from_swap_cache(str
 extern void delete_from_swap_cache(struct page *);
 extern void clear_shadow_from_swap_cache(int type, unsigned long begin,
 				unsigned long end);
+extern void free_swap_cache(struct page *);
 extern void free_page_and_swap_cache(struct page *);
 extern void free_pages_and_swap_cache(struct page **, int);
 extern struct page *lookup_swap_cache(swp_entry_t entry,
@@ -551,6 +552,10 @@ static inline void put_swap_device(struc
 #define free_pages_and_swap_cache(pages, nr) \
 	release_pages((pages), (nr));
 
+static inline void free_swap_cache(struct page *page)
+{
+}
+
 static inline void show_swap_cache_info(void)
 {
 }
--- a/mm/memory.c~mm-free-idle-swap-cache-page-after-cow
+++ a/mm/memory.c
@@ -3023,6 +3023,8 @@ static vm_fault_t wp_page_copy(struct vm
 				munlock_vma_page(old_page);
 			unlock_page(old_page);
 		}
+		if (page_copied)
+			free_swap_cache(old_page);
 		put_page(old_page);
 	}
 	return page_copied ? VM_FAULT_WRITE : 0;
--- a/mm/swap_state.c~mm-free-idle-swap-cache-page-after-cow
+++ a/mm/swap_state.c
@@ -286,7 +286,7 @@ void clear_shadow_from_swap_cache(int ty
  * try_to_free_swap() _with_ the lock.
  * 					- Marcelo
  */
-static inline void free_swap_cache(struct page *page)
+void free_swap_cache(struct page *page)
 {
 	if (PageSwapCache(page) && !page_mapped(page) && trylock_page(page)) {
 		try_to_free_swap(page);
_

Patches currently in -mm which might be from ying.huang@intel.com are



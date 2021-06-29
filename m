Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91FE0C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D8CB61D07
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbhF2Cjl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:39:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231332AbhF2Cjk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:39:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A7E561D09;
        Tue, 29 Jun 2021 02:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934233;
        bh=6nKUMrFy5wPO6MnDqGscr/SaFSDtQ47sX2WKoOdiID0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=T5nXPI9fEvuo/AOFurf44k0/9TFWcuucFr2tig7LOjWnluY96Jmw7WL1GToxsFXmE
         dZr7sALHZAin1jZ3quuAPEyaU96AjVa8Ndm6O8E+skpjSLoYHjTXwF4VJfMfrN2XvI
         brwZKLfBUoYPZRmpaeHNL0ERp8fhp+0i7vPtEjKY=
Date:   Mon, 28 Jun 2021 19:37:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com,
        linux-mm@kvack.org, mgorman@suse.de, mhocko@kernel.org,
        mm-commits@vger.kernel.org, peterx@redhat.com, riel@surriel.com,
        tim.c.chen@intel.com, torvalds@linux-foundation.org,
        willy@infradead.org, ying.huang@intel.com
Subject:  [patch 075/192] mm: free idle swap cache page after COW
Message-ID: <20210629023712.eg-0psEr5%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

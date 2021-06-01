Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF13C4708F
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 23:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8089613AE
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 23:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235217AbhFBABf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Jun 2021 20:01:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235213AbhFBABf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 1 Jun 2021 20:01:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D21061167;
        Tue,  1 Jun 2021 23:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622591992;
        bh=kB8dq8ArZ8PEtytKfYzzUWt+pm/+/AUjT9mH+UkZUwI=;
        h=Date:From:To:Subject:From;
        b=Vhy97VNBeQEjzK6M/2YYMoNsOPMqmNbbfjg9ljnowY2NvyjBYmUbsdYM7wGGuYgMC
         XtY9NfhVh2L1uXepLhagOpIntiflSxmxhTEwgC8rQ0XxWzTcEgbfqDjlfb62VF+o8v
         6kqZ1OQ/Y7AKAY55gIr6YIkyhn4BRH+lDjFyH9Q4=
Date:   Tue, 01 Jun 2021 16:59:51 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, dave.hansen@intel.com, hannes@cmpxchg.org,
        hughd@google.com, mgorman@suse.de, mhocko@kernel.org,
        mm-commits@vger.kernel.org, peterx@redhat.com, riel@surriel.com,
        tim.c.chen@intel.com, torvalds@linux-foundation.org,
        willy@infradead.org, ying.huang@intel.com
Subject:  + mm-free-idle-swap-cache-page-after-cow.patch added to
 -mm tree
Message-ID: <20210601235951.1YUFpxZEk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: free idle swap cache page after COW
has been added to the -mm tree.  Its filename is
     mm-free-idle-swap-cache-page-after-cow.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-free-idle-swap-cache-page-after-cow.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-free-idle-swap-cache-page-after-cow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3012,6 +3012,8 @@ static vm_fault_t wp_page_copy(struct vm
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
@@ -285,7 +285,7 @@ void clear_shadow_from_swap_cache(int ty
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

mm-swap-remove-unnecessary-smp_rmb-in-swap_type_to_swap_info.patch
mm-free-idle-swap-cache-page-after-cow.patch


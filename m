From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 059/128] mm/swap_state: fix a data race in
 swapin_nr_pages
Date: Mon, 01 Jun 2020 21:48:40 -0700
Message-ID: <20200602044840.Dvhd9xiLF%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgFBEsl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:48:41 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cai@lca.pw, elver@google.com, hughd@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Qian Cai <cai@lca.pw>
Subject: mm/swap_state: fix a data race in swapin_nr_pages

"prev_offset" is a static variable in swapin_nr_pages() that can be
accessed concurrently with only mmap_sem held in read mode as noticed by
KCSAN,

 BUG: KCSAN: data-race in swap_cluster_readahead / swap_cluster_readahead

 write to 0xffffffff92763830 of 8 bytes by task 14795 on cpu 17:
  swap_cluster_readahead+0x2a6/0x5e0
  swapin_readahead+0x92/0x8dc
  do_swap_page+0x49b/0xf20
  __handle_mm_fault+0xcfb/0xd70
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x715
  page_fault+0x34/0x40

 1 lock held by (dnf)/14795:
  #0: ffff897bd2e98858 (&mm->mmap_sem#2){++++}-{3:3}, at: do_page_fault+0x143/0x715
  do_user_addr_fault at arch/x86/mm/fault.c:1405
  (inlined by) do_page_fault at arch/x86/mm/fault.c:1535
 irq event stamp: 83493
 count_memcg_event_mm+0x1a6/0x270
 count_memcg_event_mm+0x119/0x270
 __do_softirq+0x365/0x589
 irq_exit+0xa2/0xc0

 read to 0xffffffff92763830 of 8 bytes by task 1 on cpu 22:
  swap_cluster_readahead+0xfd/0x5e0
  swapin_readahead+0x92/0x8dc
  do_swap_page+0x49b/0xf20
  __handle_mm_fault+0xcfb/0xd70
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x715
  page_fault+0x34/0x40

 1 lock held by systemd/1:
  #0: ffff897c38f14858 (&mm->mmap_sem#2){++++}-{3:3}, at: do_page_fault+0x143/0x715
 irq event stamp: 43530289
 count_memcg_event_mm+0x1a6/0x270
 count_memcg_event_mm+0x119/0x270
 __do_softirq+0x365/0x589
 irq_exit+0xa2/0xc0

Link: http://lkml.kernel.org/r/20200402213748.2237-1-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Marco Elver <elver@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/swap_state.c~mm-swap_state-fix-a-data-race-in-swapin_nr_pages
+++ a/mm/swap_state.c
@@ -509,10 +509,11 @@ static unsigned long swapin_nr_pages(uns
 		return 1;
 
 	hits = atomic_xchg(&swapin_readahead_hits, 0);
-	pages = __swapin_nr_pages(prev_offset, offset, hits, max_pages,
+	pages = __swapin_nr_pages(READ_ONCE(prev_offset), offset, hits,
+				  max_pages,
 				  atomic_read(&last_readahead_pages));
 	if (!hits)
-		prev_offset = offset;
+		WRITE_ONCE(prev_offset, offset);
 	atomic_set(&last_readahead_pages, pages);
 
 	return pages;
_

From: akpm@linux-foundation.org
Subject: + mm-call-swap_slot_free_notify-with-holding-page-lock.patch
 added to -mm tree
Date: Tue, 05 Apr 2016 13:48:29 -0700
Message-ID: <5704249d.+VvKy4Q9Lk8nZrbh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760022AbcDEUsa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 16:48:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hughd@google.com, kyeongdon.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: call swap_slot_free_notify() with page lock held
has been added to the -mm tree.  Its filename is
     mm-call-swap_slot_free_notify-with-holding-page-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-call-swap_slot_free_notify-with-holding-page-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-call-swap_slot_free_notify-with-holding-page-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: call swap_slot_free_notify() with page lock held

Kyeongdon reported below error which is BUG_ON(!PageSwapCache(page)) in
page_swap_info.  The reason is that page_endio in rw_page unlocks the page
if read I/O is completed so we need to hold a PG_lock again to check
PageSwapCache.  Otherwise, the page can be removed from swapcache.

[27833.995833] ------------[ cut here ]------------
[27833.995853] Kernel BUG at c00f9040 [verbose debug info unavailable]
[27833.995865] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM
[27833.995876] Modules linked in:
[27833.995892] CPU: 4 PID: 13446 Comm: RenderThread Tainted: G        W 3.10.84-g9f14aec-dirty #73
[27833.995903] task: c3b73200 ti: dd192000 task.ti: dd192000
[27833.995922] PC is at page_swap_info+0x10/0x2c
[27833.995934] LR is at swap_slot_free_notify+0x18/0x6c
[27833.995946] pc : [<c00f9040>]    lr : [<c00f5560>]    psr: 400f0113
[27833.995946] sp : dd193d78  ip : c2deb1e4  fp : da015180
[27833.995959] r10: 00000000  r9 : 000200da  r8 : c120fe08
[27833.995968] r7 : 00000000  r6 : 00000000  r5 : c249a6c0  r4 : = c249a6c0
[27833.995979] r3 : 00000000  r2 : 40080009  r1 : 200f0113  r0 : = c249a6c0
..<snip>
[27833.996273] [<c00f9040>] (page_swap_info+0x10/0x2c) from [<c00f5560>] (swap_slot_free_notify+0x18/0x6c)
[27833.996288] [<c00f5560>] (swap_slot_free_notify+0x18/0x6c) from [<c00f5c5c>] (swap_readpage+0x90/0x11c)
[27833.996302] [<c00f5c5c>] (swap_readpage+0x90/0x11c) from [<c00f62dc>] (read_swap_cache_async+0x134/0x1ac)
[27833.996317] [<c00f62dc>] (read_swap_cache_async+0x134/0x1ac) from [<c00f63c4>] (swapin_readahead+0x70/0xb0)
[27833.996334] [<c00f63c4>] (swapin_readahead+0x70/0xb0) from = [<c00e87e0>] (handle_pte_fault+0x320/0x6fc)
[27833.996348] [<c00e87e0>] (handle_pte_fault+0x320/0x6fc) from [<c00e8c7c>] (handle_mm_fault+0xc0/0xf0)
[27833.996363] [<c00e8c7c>] (handle_mm_fault+0xc0/0xf0) from = [<c001ac18>] (do_page_fault+0x11c/0x36c)
[27833.996378] [<c001ac18>] (do_page_fault+0x11c/0x36c) from = [<c000838c>] (do_DataAbort+0x34/0x118)
[27833.996392] [<c000838c>] (do_DataAbort+0x34/0x118) from [<c000d8b4>] (__dabt_usr+0x34/0x40)

Fixes: 3f2b1a04f44933f2 ("zram: revive swap_slot_free_notify")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Tested-by: Kyeongdon Kim <kyeongdon.kim@lge.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/page_io.c~mm-call-swap_slot_free_notify-with-holding-page-lock mm/page_io.c
--- a/mm/page_io.c~mm-call-swap_slot_free_notify-with-holding-page-lock
+++ a/mm/page_io.c
@@ -353,7 +353,11 @@ int swap_readpage(struct page *page)
 
 	ret = bdev_read_page(sis->bdev, swap_page_sector(page), page);
 	if (!ret) {
-		swap_slot_free_notify(page);
+		if (trylock_page(page)) {
+			swap_slot_free_notify(page);
+			unlock_page(page);
+		}
+
 		count_vm_event(PSWPIN);
 		return 0;
 	}
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit.patch
mm-call-swap_slot_free_notify-with-holding-page-lock.patch
zsmalloc-use-first_page-rather-than-page.patch
zsmalloc-clean-up-many-bug_on.patch
zsmalloc-reordering-function-parameter.patch
zsmalloc-remove-unused-pool-param-in-obj_free.patch
mm-use-put_page-to-free-page-instead-of-putback_lru_page.patch
mm-compaction-support-non-lru-movable-page-migration.patch
mm-add-non-lru-movable-page-support-document.patch
mm-balloon-use-general-movable-page-feature-into-balloon.patch
zsmalloc-keep-max_object-in-size_class.patch
zsmalloc-squeeze-inuse-into-page-mapping.patch
zsmalloc-remove-page_mapcount_reset.patch
zsmalloc-squeeze-freelist-into-page-mapping.patch
zsmalloc-move-struct-zs_meta-from-mapping-to-freelist.patch
zsmalloc-factor-page-chain-functionality-out.patch
zsmalloc-separate-free_zspage-from-putback_zspage.patch
zsmalloc-zs_compact-refactoring.patch
zsmalloc-migrate-head-page-of-zspage.patch
zsmalloc-use-single-linked-list-for-page-chain.patch
zsmalloc-migrate-tail-pages-in-zspage.patch
zram-use-__gfp_movable-for-memory-allocation.patch


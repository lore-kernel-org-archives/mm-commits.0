From: akpm@linux-foundation.org
Subject: +
 mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch added to
 -mm tree
Date: Wed, 23 Sep 2015 13:14:09 -0700
Message-ID: <56030811.xJw1CEZnQlFaXgcf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbbIWUOK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Sep 2015 16:14:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ebru.akagunduz@gmail.com, riel@redhat.com, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: do not hold anon_vma lock during swap in
has been added to the -mm tree.  Its filename is
     mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: do not hold anon_vma lock during swap in

khugepaged does swap in during collapse under anon_vma lock. It causes
complain from lockdep. The trace below shows following scenario:

 - khugepaged tries to swap in a page under mmap_sem and anon_vma lock;
 - do_swap_page() calls swapin_readahead() with GFP_HIGHUSER_MOVABLE;
 - __read_swap_cache_async() tries to allocate the page for swap in;
 - lockdep_trace_alloc() in __alloc_pages_nodemask() notices that with
   given gfp_mask we could end up in direct relaim.
 - Lockdep already knows that reclaim sometimes (e.g. in case of
   split_huge_page()) wants to take anon_vma lock on its own.

Therefore deadlock is possible.

The fix is to take anon_vma lock after swap in.

[18344.236625] =================================
[18344.236628] [ INFO: inconsistent lock state ]
[18344.236633] 4.3.0-rc1-next-20150918-dbg-00014-ge5128d0-dirty #361 Not tainted
[18344.236636] ---------------------------------
[18344.236640] inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
[18344.236645] khugepaged/32 [HC0[0]:SC0[0]:HE1:SE1] takes:
[18344.236648]  (&anon_vma->rwsem){++++?.}, at: [<ffffffff81134403>] khugepaged+0x8b0/0x1987
[18344.236662] {IN-RECLAIM_FS-W} state was registered at:
[18344.236666]   [<ffffffff8107d747>] __lock_acquire+0x8e2/0x1183
[18344.236673]   [<ffffffff8107e7ac>] lock_acquire+0x10b/0x1a6
[18344.236678]   [<ffffffff8150a367>] down_write+0x3b/0x6a
[18344.236686]   [<ffffffff811360d8>] split_huge_page_to_list+0x5b/0x61f
[18344.236689]   [<ffffffff811224b3>] add_to_swap+0x37/0x78
[18344.236691]   [<ffffffff810fd650>] shrink_page_list+0x4c2/0xb9a
[18344.236694]   [<ffffffff810fe47c>] shrink_inactive_list+0x371/0x5d9
[18344.236696]   [<ffffffff810fee2f>] shrink_lruvec+0x410/0x5ae
[18344.236698]   [<ffffffff810ff024>] shrink_zone+0x57/0x140
[18344.236700]   [<ffffffff810ffc79>] kswapd+0x6a5/0x91b
[18344.236702]   [<ffffffff81059588>] kthread+0x107/0x10f
[18344.236706]   [<ffffffff8150c7bf>] ret_from_fork+0x3f/0x70
[18344.236708] irq event stamp: 6517947
[18344.236709] hardirqs last  enabled at (6517947): [<ffffffff810f2d0c>] get_page_from_freelist+0x362/0x59e
[18344.236713] hardirqs last disabled at (6517946): [<ffffffff8150ba41>] _raw_spin_lock_irqsave+0x18/0x51
[18344.236715] softirqs last  enabled at (6507072): [<ffffffff81041cb0>] __do_softirq+0x2df/0x3f5
[18344.236719] softirqs last disabled at (6507055): [<ffffffff81041fb5>] irq_exit+0x40/0x94
[18344.236722]
               other info that might help us debug this:
[18344.236723]  Possible unsafe locking scenario:

[18344.236724]        CPU0
[18344.236725]        ----
[18344.236726]   lock(&anon_vma->rwsem);
[18344.236728]   <Interrupt>
[18344.236729]     lock(&anon_vma->rwsem);
[18344.236731]
                *** DEADLOCK ***

[18344.236733] 2 locks held by khugepaged/32:
[18344.236733]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81134122>] khugepaged+0x5cf/0x1987
[18344.236738]  #1:  (&anon_vma->rwsem){++++?.}, at: [<ffffffff81134403>] khugepaged+0x8b0/0x1987
[18344.236741]
               stack backtrace:
[18344.236744] CPU: 3 PID: 32 Comm: khugepaged Not tainted 4.3.0-rc1-next-20150918-dbg-00014-ge5128d0-dirty #361
[18344.236747]  0000000000000000 ffff880132827a00 ffffffff81230867 ffffffff8237ba90
[18344.236750]  ffff880132827a38 ffffffff810ea9b9 000000000000000a ffff8801333b52e0
[18344.236753]  ffff8801333b4c00 ffffffff8107b3ce 000000000000000a ffff880132827a78
[18344.236755] Call Trace:
[18344.236758]  [<ffffffff81230867>] dump_stack+0x4e/0x79
[18344.236761]  [<ffffffff810ea9b9>] print_usage_bug.part.24+0x259/0x268
[18344.236763]  [<ffffffff8107b3ce>] ? print_shortest_lock_dependencies+0x180/0x180
[18344.236765]  [<ffffffff8107c7fc>] mark_lock+0x381/0x567
[18344.236766]  [<ffffffff8107ca40>] mark_held_locks+0x5e/0x74
[18344.236768]  [<ffffffff8107ee9f>] lockdep_trace_alloc+0xb0/0xb3
[18344.236771]  [<ffffffff810f30cc>] __alloc_pages_nodemask+0x99/0x856
[18344.236772]  [<ffffffff810ebaf9>] ? find_get_entry+0x14b/0x17a
[18344.236774]  [<ffffffff810ebb16>] ? find_get_entry+0x168/0x17a
[18344.236777]  [<ffffffff811226d9>] __read_swap_cache_async+0x7b/0x1aa
[18344.236778]  [<ffffffff8112281d>] read_swap_cache_async+0x15/0x2d
[18344.236780]  [<ffffffff8112294f>] swapin_readahead+0x11a/0x16a
[18344.236783]  [<ffffffff81112791>] do_swap_page+0xa7/0x36b
[18344.236784]  [<ffffffff81112791>] ? do_swap_page+0xa7/0x36b
[18344.236787]  [<ffffffff8113444c>] khugepaged+0x8f9/0x1987
[18344.236790]  [<ffffffff810772f3>] ? wait_woken+0x88/0x88
[18344.236792]  [<ffffffff81133b53>] ? maybe_pmd_mkwrite+0x1a/0x1a
[18344.236794]  [<ffffffff81059588>] kthread+0x107/0x10f
[18344.236797]  [<ffffffff81059481>] ? kthread_create_on_node+0x1ea/0x1ea
[18344.236799]  [<ffffffff8150c7bf>] ret_from_fork+0x3f/0x70
[18344.236801]  [<ffffffff81059481>] ? kthread_create_on_node+0x1ea/0x1ea

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3 mm/huge_memory.c
--- a/mm/huge_memory.c~mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3
+++ a/mm/huge_memory.c
@@ -2691,10 +2691,10 @@ static void collapse_huge_page(struct mm
 		goto out;
 	}
 
-	anon_vma_lock_write(vma->anon_vma);
-
 	__collapse_huge_page_swapin(mm, vma, address, pmd);
 
+	anon_vma_lock_write(vma->anon_vma);
+
 	pte = pte_offset_map(pmd, address);
 	pte_ptl = pte_lockptr(mm, pmd);
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified.patch
rcu-force-alignment-on-struct-callback_head-rcu_head.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-support-madvisemadv_free-fix-3.patch


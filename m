From: akpm@linux-foundation.org
Subject: [to-be-updated] netvm-check-for-page-==-null-when-propagating-the-skb-pfmemalloc-flag.patch removed from -mm tree
Date: Fri, 24 Aug 2012 11:14:03 -0700
Message-ID: <20120824181404.EFB551E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:40112 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab2HXSOG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 14:14:06 -0400
Received: by vcqp1 with SMTP id p1so308690vcq.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 11:14:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, Ian.Campbell@eu.citrix.com, davem@davemloft.net, konrad.wilk@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: netvm: check for page == NULL when propagating the skb->pfmemalloc flag
has been removed from the -mm tree.  Its filename was
     netvm-check-for-page-==-null-when-propagating-the-skb-pfmemalloc-flag.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: netvm: check for page == NULL when propagating the skb->pfmemalloc flag

Commit c48a11c7 ("netvm: propagate page->pfmemalloc to skb") is
responsible for the following bug triggered by a xen network driver

[    1.908592] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[    1.908643] IP: [<ffffffffa0037750>] xennet_poll+0x980/0xec0 [xen_netfront]
[    1.908703] PGD ea1df067 PUD e8ada067 PMD 0
[    1.908774] Oops: 0000 [#1] SMP
[    1.908797] Modules linked in: fbcon tileblit font radeon bitblit softcursor ttm drm_kms_helper crc32c_intel xen_blkfront xen_netfront xen_fbfront fb_sys_fops sysimgblt sysfillrect syscopyarea +xen_kbdfront xenfs xen_privcmd
[    1.908938] CPU 0
[    1.908950] Pid: 2165, comm: ip Not tainted 3.5.0upstream-08854-g444fa66 #1
[    1.908983] RIP: e030:[<ffffffffa0037750>]  [<ffffffffa0037750>] xennet_poll+0x980/0xec0 [xen_netfront]
[    1.909029] RSP: e02b:ffff8800ffc03db8  EFLAGS: 00010282
[    1.909055] RAX: ffff8800ea010140 RBX: ffff8800f00e86c0 RCX: 000000000000009a
[    1.909055] RDX: 0000000000000040 RSI: 000000000000005a RDI: ffff8800fa7dee80
[    1.909055] RBP: ffff8800ffc03ee8 R08: ffff8800f00e86d8 R09: ffff8800ea010000
[    1.909055] R10: dead000000200200 R11: dead000000100100 R12: ffff8800fa7dee80
[    1.909055] R13: 000000000000005a R14: ffff8800fa7dee80 R15: 0000000000000200
[    1.909055] FS:  00007fbafc188700(0000) GS:ffff8800ffc00000(0000) knlGS:0000000000000000
[    1.909055] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.909055] CR2: 0000000000000010 CR3: 00000000ea108000 CR4: 0000000000002660
[    1.909055] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.909055] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    1.909055] Process ip (pid: 2165, threadinfo ffff8800ea0f2000, task ffff8800fa783040)
[    1.909055] Stack:
[    1.909055]  ffff8800e27e5040 ffff8800ffc03e88 ffff8800ffc03e68 ffff8800ffc03e48
[    1.909055]  7fffffffffffffff ffff8800ffc03e00 ffff8800e27e5040 ffff8800f00e86d8
[    1.909055]  ffff8800ffc03eb0 00000040ffffffff ffff8800f00e8000 00000000ffc03e30
[    1.909055] Call Trace:
[    1.909055]  <IRQ>
[    1.909055]  [<ffffffff81066028>] ?  pvclock_clocksource_read+0x58/0xd0
[    1.909055]  [<ffffffff81486352>] net_rx_action+0x112/0x240
[    1.909055]  [<ffffffff8107f319>] __do_softirq+0xb9/0x190
[    1.909055]  [<ffffffff815d8d7c>] call_softirq+0x1c/0x30

The problem is that the xenfront driver is passing a NULL page to
__skb_fill_page_desc() which was unexpected.  This patch checks that there
is a page before dereferencing.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/skbuff.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/skbuff.h~netvm-check-for-page-==-null-when-propagating-the-skb-pfmemalloc-flag include/linux/skbuff.h
--- a/include/linux/skbuff.h~netvm-check-for-page-==-null-when-propagating-the-skb-pfmemalloc-flag
+++ a/include/linux/skbuff.h
@@ -1256,7 +1256,7 @@ static inline void __skb_fill_page_desc(
 	 * do not lose pfmemalloc information as the pages would not be
 	 * allocated using __GFP_MEMALLOC.
 	 */
-	if (page->pfmemalloc && !page->mapping)
+	if (page && page->pfmemalloc && !page->mapping)
 		skb->pfmemalloc	= true;
 	frag->page.p		  = page;
 	frag->page_offset	  = off;
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-correct-page-pfmemalloc-to-fix-deactivate_slab-regression.patch
mm-have-order-0-compaction-start-near-a-pageblock-with-free-pages-v2.patch
mm-compaction-abort-async-compaction-if-locks-are-contended-or-taking-too-long-v2.patch
linux-next.patch
mm-remove-__gfp_no_kswapd.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
revert-mm-mempolicy-let-vma_merge-and-vma_split-handle-vma-vm_policy-linkages.patch
mempolicy-remove-mempolicy-sharing.patch
mempolicy-fix-a-race-in-shared_policy_replace.patch
mempolicy-fix-refcount-leak-in-mpol_set_shared_policy.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma-v2.patch


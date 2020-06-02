From: akpm@linux-foundation.org
Subject: [merged] mm-slub-fix-stack-overruns-with-slub_stats.patch
 removed from -mm tree
Date: Tue, 02 Jun 2020 14:37:57 -0700
Message-ID: <20200602213757.tG_Kr3R6b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgFBVh6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:37:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, cl@linux.com, glauber@scylladb.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com


The patch titled
     Subject: mm/slub: fix stack overruns with SLUB_STATS
has been removed from the -mm tree.  Its filename was
     mm-slub-fix-stack-overruns-with-slub_stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm/slub: fix stack overruns with SLUB_STATS

There is no need to copy SLUB_STATS items from root memcg cache to new
memcg cache copies.  Doing so could result in stack overruns because the
store function only accepts 0 to clear the stat and returns an error for
everything else while the show method would print out the whole stat. 
Then, the mismatch of the lengths returns from show and store methods
happens in memcg_propagate_slab_attrs(),

else if (root_cache->max_attr_size < ARRAY_SIZE(mbuf))
	buf = mbuf;

max_attr_size is only 2 from slab_attr_store(), then, it uses mbuf[64] in
show_stat() later where a bounch of sprintf() would overrun the stack
variable.  Fix it by always allocating a page of buffer to be used in
show_stat() if SLUB_STATS=y which should only be used for debug purpose.

 # echo 1 > /sys/kernel/slab/fs_cache/shrink
 BUG: KASAN: stack-out-of-bounds in number+0x421/0x6e0
 Write of size 1 at addr ffffc900256cfde0 by task kworker/76:0/53251

 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019
 Workqueue: memcg_kmem_cache memcg_kmem_cache_create_func
 Call Trace:
  dump_stack+0xa7/0xea
  print_address_description.constprop.5.cold.7+0x64/0x384
  __kasan_report.cold.8+0x76/0xda
  kasan_report+0x41/0x60
  __asan_store1+0x6d/0x70
  number+0x421/0x6e0
  vsnprintf+0x451/0x8e0
  sprintf+0x9e/0xd0
  show_stat+0x124/0x1d0
  alloc_slowpath_show+0x13/0x20
  __kmem_cache_create+0x47a/0x6b0

 addr ffffc900256cfde0 is located in stack of task kworker/76:0/53251 at offset 0 in frame:
  process_one_work+0x0/0xb90

 this frame has 1 object:
  [32, 72) 'lockdep_map'

 Memory state around the buggy address:
  ffffc900256cfc80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffffc900256cfd00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 >ffffc900256cfd80: 00 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1
                                                        ^
  ffffc900256cfe00: 00 00 00 00 00 f2 f2 f2 00 00 00 00 00 00 00 00
  ffffc900256cfe80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ==================================================================
 Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: __kmem_cache_create+0x6ac/0x6b0
 Workqueue: memcg_kmem_cache memcg_kmem_cache_create_func
 Call Trace:
  dump_stack+0xa7/0xea
  panic+0x23e/0x452
  __stack_chk_fail+0x22/0x30
  __kmem_cache_create+0x6ac/0x6b0

Link: http://lkml.kernel.org/r/20200429222356.4322-1-cai@lca.pw
Fixes: 107dab5c92d5 ("slub: slub-specific propagation changes")
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Glauber Costa <glauber@scylladb.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-fix-stack-overruns-with-slub_stats
+++ a/mm/slub.c
@@ -5691,7 +5691,8 @@ static void memcg_propagate_slab_attrs(s
 		 */
 		if (buffer)
 			buf = buffer;
-		else if (root_cache->max_attr_size < ARRAY_SIZE(mbuf))
+		else if (root_cache->max_attr_size < ARRAY_SIZE(mbuf) &&
+			 !IS_ENABLED(CONFIG_SLUB_STATS))
 			buf = mbuf;
 		else {
 			buffer = (char *) get_zeroed_page(GFP_KERNEL);
_

Patches currently in -mm which might be from cai@lca.pw are

mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn-fix.patch
khugepaged-allow-to-collapse-a-page-shared-across-fork-fix-fix.patch
mm-deactivations-shouldnt-bias-the-lru-balance-fix.patch
mm-kmemleak-silence-kcsan-splats-in-checksum.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races-v2.patch
mm-swap_state-mark-various-intentional-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races-v2.patch
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-util-annotate-an-data-race-at-vm_committed_as.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-annotate-a-data-race-in-page_zonenum.patch
mm-swap-annotate-data-races-for-lru_rotate_pvecs.patch

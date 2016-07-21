From: akpm@linux-foundation.org
Subject: + mm-add-per-zone-lru-list-stat.patch added to -mm tree
Date: Thu, 21 Jul 2016 14:08:58 -0700
Message-ID: <579139ea.2IN+9SxfcD78jCgv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbcGUVJA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jul 2016 17:09:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hannes@cmpxchg.org, mgorman@techsingularity.net, mhocko@suse.cz, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add per-zone lru list stat
has been added to the -mm tree.  Its filename is
     mm-add-per-zone-lru-list-stat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-per-zone-lru-list-stat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-per-zone-lru-list-stat.patch

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
Subject: mm: add per-zone lru list stat

When I did stress test with hackbench, I got OOM message frequently which
didn't ever happen in zone-lru.

gfp_mask=0x26004c0(GFP_KERNEL|__GFP_REPEAT|__GFP_NOTRACK), order=0
..
..
 [<c71a76e2>] __alloc_pages_nodemask+0xe52/0xe60
 [<c71f31dc>] ? new_slab+0x39c/0x3b0
 [<c71f31dc>] new_slab+0x39c/0x3b0
 [<c71f4eca>] ___slab_alloc.constprop.87+0x6da/0x840
 [<c763e6fc>] ? __alloc_skb+0x3c/0x260
 [<c777e127>] ? _raw_spin_unlock_irq+0x27/0x60
 [<c70cebfc>] ? trace_hardirqs_on_caller+0xec/0x1b0
 [<c70a1506>] ? finish_task_switch+0xa6/0x220
 [<c7219ee0>] ? poll_select_copy_remaining+0x140/0x140
 [<c7201645>] __slab_alloc.isra.81.constprop.86+0x40/0x6d
 [<c763e6fc>] ? __alloc_skb+0x3c/0x260
 [<c71f525c>] kmem_cache_alloc+0x22c/0x260
 [<c763e6fc>] ? __alloc_skb+0x3c/0x260
 [<c763e6fc>] __alloc_skb+0x3c/0x260
 [<c763eece>] alloc_skb_with_frags+0x4e/0x1a0
 [<c7638d6a>] sock_alloc_send_pskb+0x16a/0x1b0
 [<c770b581>] ? wait_for_unix_gc+0x31/0x90
 [<c71cfb1d>] ? alloc_set_pte+0x2ad/0x310
 [<c77084dd>] unix_stream_sendmsg+0x28d/0x340
 [<c7634dad>] sock_sendmsg+0x2d/0x40
 [<c7634e2c>] sock_write_iter+0x6c/0xc0
 [<c7204a90>] __vfs_write+0xc0/0x120
 [<c72053ab>] vfs_write+0x9b/0x1a0
 [<c71cc4a9>] ? __might_fault+0x49/0xa0
 [<c72062c4>] SyS_write+0x44/0x90
 [<c70036c6>] do_fast_syscall_32+0xa6/0x1e0
 [<c777ea2c>] sysenter_past_esp+0x45/0x74

Mem-Info:
active_anon:104698 inactive_anon:105791 isolated_anon:192
 active_file:433 inactive_file:283 isolated_file:22
 unevictable:0 dirty:0 writeback:296 unstable:0
 slab_reclaimable:6389 slab_unreclaimable:78927
 mapped:474 shmem:0 pagetables:101426 bounce:0
 free:10518 free_pcp:334 free_cma:0
Node 0 active_anon:418792kB inactive_anon:423164kB active_file:1732kB inactive_file:1132kB unevictable:0kB isolated(anon):768kB isolated(file):88kB mapped:1896kB dirty:0kB writeback:1184kB shmem:0kB writeback_tmp:0kB unstable:0kB pages_scanned:1478632 all_unreclaimable? yes
DMA free:3304kB min:68kB low:84kB high:100kB present:15992kB managed:15916kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:4088kB kernel_stack:0kB pagetables:2480kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
lowmem_reserve[]: 0 809 1965 1965
Normal free:3436kB min:3604kB low:4504kB high:5404kB present:897016kB managed:858460kB mlocked:0kB slab_reclaimable:25556kB slab_unreclaimable:311712kB kernel_stack:164608kB pagetables:30844kB bounce:0kB free_pcp:620kB local_pcp:104kB free_cma:0kB
lowmem_reserve[]: 0 0 9247 9247
HighMem free:33808kB min:512kB low:1796kB high:3080kB present:1183736kB managed:1183736kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:372252kB bounce:0kB free_pcp:428kB local_pcp:72kB free_cma:0kB
lowmem_reserve[]: 0 0 0 0
DMA: 2*4kB (UM) 2*8kB (UM) 0*16kB 1*32kB (U) 1*64kB (U) 2*128kB (UM) 1*256kB (U) 1*512kB (M) 0*1024kB 1*2048kB (U) 0*4096kB = 3192kB
Normal: 33*4kB (MH) 79*8kB (ME) 11*16kB (M) 4*32kB (M) 2*64kB (ME) 2*128kB (EH) 7*256kB (EH) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3244kB
HighMem: 2590*4kB (UM) 1568*8kB (UM) 491*16kB (UM) 60*32kB (UM) 6*64kB (M) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 33064kB
Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
25121 total pagecache pages
24160 pages in swap cache
Swap cache stats: add 86371, delete 62211, find 42865/60187
Free swap  = 4015560kB
Total swap = 4192252kB
524186 pages RAM
295934 pages HighMem/MovableOnly
9658 pages reserved
0 pages cma reserved

The order-0 allocation for normal zone failed while there are a lot of
reclaimable memory(i.e., anonymous memory with free swap). I wanted to
analyze the problem but it was hard because we removed per-zone lru stat
so I couldn't know how many of anonymous memory there are in normal/dma zone.

When we investigate OOM problem, reclaimable memory count is crucial stat
to find a problem. Without it, it's hard to parse the OOM message so I
believe we should keep it.

With per-zone lru stat,

gfp_mask=0x26004c0(GFP_KERNEL|__GFP_REPEAT|__GFP_NOTRACK), order=0
Mem-Info:
active_anon:101103 inactive_anon:102219 isolated_anon:0
 active_file:503 inactive_file:544 isolated_file:0
 unevictable:0 dirty:0 writeback:34 unstable:0
 slab_reclaimable:6298 slab_unreclaimable:74669
 mapped:863 shmem:0 pagetables:100998 bounce:0
 free:23573 free_pcp:1861 free_cma:0
Node 0 active_anon:404412kB inactive_anon:409040kB active_file:2012kB inactive_file:2176kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:3452kB dirty:0kB writeback:136kB shmem:0kB writeback_tmp:0kB unstable:0kB pages_scanned:1320845 all_unreclaimable? yes
DMA free:3296kB min:68kB low:84kB high:100kB active_anon:5540kB inactive_anon:0kB active_file:0kB inactive_file:0kB present:15992kB managed:15916kB mlocked:0kB slab_reclaimable:248kB slab_unreclaimable:2628kB kernel_stack:792kB pagetables:2316kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
lowmem_reserve[]: 0 809 1965 1965
Normal free:3600kB min:3604kB low:4504kB high:5404kB active_anon:86304kB inactive_anon:0kB active_file:160kB inactive_file:376kB present:897016kB managed:858524kB mlocked:0kB slab_reclaimable:24944kB slab_unreclaimable:296048kB kernel_stack:163832kB pagetables:35892kB bounce:0kB free_pcp:3076kB local_pcp:656kB free_cma:0kB
lowmem_reserve[]: 0 0 9247 9247
HighMem free:86156kB min:512kB low:1796kB high:3080kB active_anon:312852kB inactive_anon:410024kB active_file:1924kB inactive_file:2012kB present:1183736kB managed:1183736kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:365784kB bounce:0kB free_pcp:3868kB local_pcp:720kB free_cma:0kB
lowmem_reserve[]: 0 0 0 0
DMA: 8*4kB (UM) 8*8kB (UM) 4*16kB (M) 2*32kB (UM) 2*64kB (UM) 1*128kB (M) 3*256kB (UME) 2*512kB (UE) 1*1024kB (E) 0*2048kB 0*4096kB = 3296kB
Normal: 240*4kB (UME) 160*8kB (UME) 23*16kB (ME) 3*32kB (UE) 3*64kB (UME) 2*128kB (ME) 1*256kB (U) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3408kB
HighMem: 10942*4kB (UM) 3102*8kB (UM) 866*16kB (UM) 76*32kB (UM) 11*64kB (UM) 4*128kB (UM) 1*256kB (M) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 86344kB
Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
54409 total pagecache pages
53215 pages in swap cache
Swap cache stats: add 300982, delete 247765, find 157978/226539
Free swap  = 3803244kB
Total swap = 4192252kB
524186 pages RAM
295934 pages HighMem/MovableOnly
9642 pages reserved
0 pages cma reserved

With that, we can see normal zone has a 86M reclaimable memory so we can
know something goes wrong(I will fix the problem in next patch) in reclaim.

Link: http://lkml.kernel.org/r/1469110261-7365-2-git-send-email-mgorman@techsingularity.net
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    2 ++
 include/linux/mmzone.h    |    6 ++++++
 mm/page_alloc.c           |   10 ++++++++++
 mm/vmscan.c               |    9 ---------
 mm/vmstat.c               |    5 +++++
 5 files changed, 23 insertions(+), 9 deletions(-)

diff -puN include/linux/mm_inline.h~mm-add-per-zone-lru-list-stat include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-add-per-zone-lru-list-stat
+++ a/include/linux/mm_inline.h
@@ -45,6 +45,8 @@ static __always_inline void __update_lru
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
 	__mod_node_page_state(pgdat, NR_LRU_BASE + lru, nr_pages);
+	__mod_zone_page_state(&pgdat->node_zones[zid],
+				NR_ZONE_LRU_BASE + lru, nr_pages);
 	acct_highmem_file_pages(zid, lru, nr_pages);
 }
 
diff -puN include/linux/mmzone.h~mm-add-per-zone-lru-list-stat include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-add-per-zone-lru-list-stat
+++ a/include/linux/mmzone.h
@@ -110,6 +110,12 @@ struct zone_padding {
 enum zone_stat_item {
 	/* First 128 byte cacheline (assuming 64 bit words) */
 	NR_FREE_PAGES,
+	NR_ZONE_LRU_BASE, /* Used only for compaction and reclaim retry */
+	NR_ZONE_INACTIVE_ANON = NR_ZONE_LRU_BASE,
+	NR_ZONE_ACTIVE_ANON,
+	NR_ZONE_INACTIVE_FILE,
+	NR_ZONE_ACTIVE_FILE,
+	NR_ZONE_UNEVICTABLE,
 	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
 	NR_SLAB_RECLAIMABLE,
 	NR_SLAB_UNRECLAIMABLE,
diff -puN mm/page_alloc.c~mm-add-per-zone-lru-list-stat mm/page_alloc.c
--- a/mm/page_alloc.c~mm-add-per-zone-lru-list-stat
+++ a/mm/page_alloc.c
@@ -4356,6 +4356,11 @@ void show_free_areas(unsigned int filter
 			" min:%lukB"
 			" low:%lukB"
 			" high:%lukB"
+			" active_anon:%lukB"
+			" inactive_anon:%lukB"
+			" active_file:%lukB"
+			" inactive_file:%lukB"
+			" unevictable:%lukB"
 			" present:%lukB"
 			" managed:%lukB"
 			" mlocked:%lukB"
@@ -4373,6 +4378,11 @@ void show_free_areas(unsigned int filter
 			K(min_wmark_pages(zone)),
 			K(low_wmark_pages(zone)),
 			K(high_wmark_pages(zone)),
+			K(zone_page_state(zone, NR_ZONE_ACTIVE_ANON)),
+			K(zone_page_state(zone, NR_ZONE_INACTIVE_ANON)),
+			K(zone_page_state(zone, NR_ZONE_ACTIVE_FILE)),
+			K(zone_page_state(zone, NR_ZONE_INACTIVE_FILE)),
+			K(zone_page_state(zone, NR_ZONE_UNEVICTABLE)),
 			K(zone->present_pages),
 			K(zone->managed_pages),
 			K(zone_page_state(zone, NR_MLOCK)),
diff -puN mm/vmscan.c~mm-add-per-zone-lru-list-stat mm/vmscan.c
--- a/mm/vmscan.c~mm-add-per-zone-lru-list-stat
+++ a/mm/vmscan.c
@@ -1359,23 +1359,14 @@ static __always_inline void update_lru_s
 			enum lru_list lru, unsigned long *nr_zone_taken,
 			unsigned long nr_taken)
 {
-#ifdef CONFIG_HIGHMEM
 	int zid;
 
-	/*
-	 * Highmem has separate accounting for highmem pages so each zone
-	 * is updated separately.
-	 */
 	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
 		if (!nr_zone_taken[zid])
 			continue;
 
 		__update_lru_size(lruvec, lru, zid, -nr_zone_taken[zid]);
 	}
-#else
-	/* Zone ID does not matter on !HIGHMEM */
-	__update_lru_size(lruvec, lru, 0, -nr_taken);
-#endif
 
 #ifdef CONFIG_MEMCG
 	mem_cgroup_update_lru_size(lruvec, lru, -nr_taken);
diff -puN mm/vmstat.c~mm-add-per-zone-lru-list-stat mm/vmstat.c
--- a/mm/vmstat.c~mm-add-per-zone-lru-list-stat
+++ a/mm/vmstat.c
@@ -921,6 +921,11 @@ int fragmentation_index(struct zone *zon
 const char * const vmstat_text[] = {
 	/* enum zone_stat_item countes */
 	"nr_free_pages",
+	"nr_inactive_anon",
+	"nr_active_anon",
+	"nr_inactive_file",
+	"nr_active_file",
+	"nr_unevictable",
 	"nr_mlock",
 	"nr_slab_reclaimable",
 	"nr_slab_unreclaimable",
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-use-put_page-to-free-page-instead-of-putback_lru_page.patch
mm-migrate-support-non-lru-movable-page-migration.patch
mm-balloon-use-general-non-lru-movable-page-feature.patch
zsmalloc-keep-max_object-in-size_class.patch
zsmalloc-use-bit_spin_lock.patch
zsmalloc-use-accessor.patch
zsmalloc-factor-page-chain-functionality-out.patch
zsmalloc-introduce-zspage-structure.patch
zsmalloc-separate-free_zspage-from-putback_zspage.patch
zsmalloc-use-freeobj-for-index.patch
zsmalloc-page-migration-support.patch
zsmalloc-page-migration-support-fix.patch
zsmalloc-page-migration-support-fix-2.patch
zram-use-__gfp_movable-for-memory-allocation.patch
zsmalloc-use-obj_tag_bit-for-bit-shifter.patch
mm-add-nr_zsmalloc-to-vmstat.patch
mm-add-nr_zsmalloc-to-vmstat-fix-2.patch
mm-fix-build-warnings-in-linux-compactionh.patch
mm-page_alloc-fix-dirtyable-highmem-calculation.patch
mm-show-node_pages_scanned-per-node-not-zone.patch
mm-show-node_pages_scanned-per-node-not-zone-fix.patch
mm-add-per-zone-lru-list-stat.patch
mm-consider-per-zone-inactive-ratio-to-deactivate.patch


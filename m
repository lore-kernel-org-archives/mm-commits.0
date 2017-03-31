From: akpm@linux-foundation.org
Subject: [merged] mm-tile-drop-arch_addremove_memory.patch removed from
 -mm tree
Date: Fri, 31 Mar 2017 13:06:59 -0700
Message-ID: <58deb6e3.L6OMEMyMXxr2Qrp8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49298 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754594AbdCaUHC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 31 Mar 2017 16:07:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, aarcange@redhat.com, ak@linux.intel.com, arbab@linux.vnet.ibm.com, benh@kernel.crashing.org, cmetcalf@mellanox.com, dan.j.williams@gmail.com, daniel.kiper@oracle.com, heiko.carstens@de.ibm.com, hpa@zytor.com, imammedo@redhat.com, js1304@gmail.com, mgorman@suse.de, mingo@elte.hu, qiuxishi@huawei.com, rientjes@google.com, schwidefsky@de.ibm.com, slaoub@gmail.com, tglx@linutronix.de, tony.luck@intel.com, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com, yasu.isimatu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, tile: drop arch_{add,remove}_memory
has been removed from the -mm tree.  Its filename was
     mm-tile-drop-arch_addremove_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, tile: drop arch_{add,remove}_memory

These functions are unreachable because tile doesn't support memory
hotplug becasuse it doesn't select ARCH_ENABLE_MEMORY_HOTPLUG nor it
supports SPARSEMEM.

This code hasn't been compiled for a while obviously because nobody has
noticed that __add_pages has a different signature since 2009.

Link: http://lkml.kernel.org/r/20170330115454.32154-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: <slaoub@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Dan Williams <dan.j.williams@gmail.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Kani Toshimitsu <toshi.kani@hpe.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <yasu.isimatu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/mm/init.c |   30 ------------------------------
 1 file changed, 30 deletions(-)

diff -puN arch/tile/mm/init.c~mm-tile-drop-arch_addremove_memory arch/tile/mm/init.c
--- a/arch/tile/mm/init.c~mm-tile-drop-arch_addremove_memory
+++ a/arch/tile/mm/init.c
@@ -857,36 +857,6 @@ void __init mem_init(void)
 #endif
 }
 
-/*
- * this is for the non-NUMA, single node SMP system case.
- * Specifically, in the case of x86, we will always add
- * memory to the highmem for now.
- */
-#ifndef CONFIG_NEED_MULTIPLE_NODES
-int arch_add_memory(u64 start, u64 size, bool for_device)
-{
-	struct pglist_data *pgdata = &contig_page_data;
-	struct zone *zone = pgdata->node_zones + MAX_NR_ZONES-1;
-	unsigned long start_pfn = start >> PAGE_SHIFT;
-	unsigned long nr_pages = size >> PAGE_SHIFT;
-
-	return __add_pages(zone, start_pfn, nr_pages);
-}
-
-int remove_memory(u64 start, u64 size)
-{
-	return -EINVAL;
-}
-
-#ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(u64 start, u64 size)
-{
-	/* TODO */
-	return -EBUSY;
-}
-#endif
-#endif
-
 struct kmem_cache *pgd_cache;
 
 void __init pgtable_cache_init(void)
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-move-mm_percpu_wq-initialization-earlier.patch
lockdep-allow-to-disable-reclaim-lockup-detection.patch
xfs-abstract-pf_fstrans-to-pf_memalloc_nofs.patch
mm-introduce-memalloc_nofs_saverestore-api.patch
xfs-use-memalloc_nofs_saverestore-instead-of-memalloc_noio.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe.patch
mm-move-pcp-and-lru-pcp-drainging-into-single-wq.patch
mm-get-rid-of-zone_is_initialized.patch
mm-remove-return-value-from-init_currently_empty_zone.patch
mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch
mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch
mm-introduce-kvalloc-helpers.patch
mm-support-__gfp_repeat-in-kvmalloc_node-for-32kb.patch
rhashtable-simplify-a-strange-allocation-pattern.patch
ila-simplify-a-strange-allocation-pattern.patch
xattr-zero-out-memory-copied-to-userspace-in-getxattr.patch
treewide-use-kvalloc-rather-than-opencoded-variants.patch
net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant.patch
md-use-kvmalloc-rather-than-opencoded-variant.patch
bcache-use-kvmalloc.patch
mm-vmalloc-use-__gfp_highmem-implicitly.patch


From: akpm@linux-foundation.org
Subject: [folded-merged] mm-adaptive-hash-table-scaling-fix.patch removed
 from -mm tree
Date: Thu, 06 Jul 2017 15:17:39 -0700
Message-ID: <595eb703.vtR0dvHZPLlhbmf0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33066 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751974AbdGFWRk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:17:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, pasha.tatashin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop HASH_ADAPT
has been removed from the -mm tree.  Its filename was
     mm-adaptive-hash-table-scaling-fix.patch

This patch was dropped because it was folded into mm-adaptive-hash-table-scaling.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: drop HASH_ADAPT

"mm: Adaptive hash table scaling" has introduced a new large hash table
automatic scaling because the previous implementation led to too large
hashes on TB systems.  This is all nice and good but the patch assumes
that callers of alloc_large_system_hash will opt-in to use this new
scaling.  This makes the API unnecessarily complicated and error prone. 
The only thing that callers should care about is whether they have an
upper bound for the size or leave it to alloc_large_system_hash to decide
(by providing high_limit == 0).

As a quick code inspection shows there are users with high_limit == 0
which do not use the flag already e.g.  {dcache,inode}_init_early or
mnt_init when creating mnt has tables.  They certainly have no good reason
to use a different scaling because the [di]cache was the motivation for
introducing a different scaling in the first place (we just do this
attempt and use memblock).  It is also hard to imagine why we would mnt
hash tables need larger hash tables.

Just drop the flag and use the scaling whenever there is no high_limit
specified.

Link: http://lkml.kernel.org/r/20170509094607.GG6481@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c             |    2 +-
 fs/inode.c              |    2 +-
 include/linux/bootmem.h |    1 -
 mm/page_alloc.c         |    2 +-
 4 files changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/dcache.c~mm-adaptive-hash-table-scaling-fix fs/dcache.c
--- a/fs/dcache.c~mm-adaptive-hash-table-scaling-fix
+++ a/fs/dcache.c
@@ -3583,7 +3583,7 @@ static void __init dcache_init(void)
 					sizeof(struct hlist_bl_head),
 					dhash_entries,
 					13,
-					HASH_ZERO | HASH_ADAPT,
+					HASH_ZERO,
 					&d_hash_shift,
 					&d_hash_mask,
 					0,
diff -puN fs/inode.c~mm-adaptive-hash-table-scaling-fix fs/inode.c
--- a/fs/inode.c~mm-adaptive-hash-table-scaling-fix
+++ a/fs/inode.c
@@ -1951,7 +1951,7 @@ void __init inode_init(void)
 					sizeof(struct hlist_head),
 					ihash_entries,
 					14,
-					HASH_ZERO | HASH_ADAPT,
+					HASH_ZERO,
 					&i_hash_shift,
 					&i_hash_mask,
 					0,
diff -puN include/linux/bootmem.h~mm-adaptive-hash-table-scaling-fix include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-adaptive-hash-table-scaling-fix
+++ a/include/linux/bootmem.h
@@ -359,7 +359,6 @@ extern void *alloc_large_system_hash(con
 #define HASH_SMALL	0x00000002	/* sub-page allocation allowed, min
 					 * shift passed via *_hash_shift */
 #define HASH_ZERO	0x00000004	/* Zero allocated hash table */
-#define	HASH_ADAPT	0x00000008	/* Adaptive scale for large memory */
 
 /* Only NUMA needs hash distribution. 64bit NUMA architectures have
  * sufficient vmalloc space.
diff -puN mm/page_alloc.c~mm-adaptive-hash-table-scaling-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-adaptive-hash-table-scaling-fix
+++ a/mm/page_alloc.c
@@ -7221,7 +7221,7 @@ void *__init alloc_large_system_hash(con
 		if (PAGE_SHIFT < 20)
 			numentries = round_up(numentries, (1<<20)/PAGE_SIZE);
 
-		if (flags & HASH_ADAPT) {
+		if (!high_limit) {
 			unsigned long adapt;
 
 			for (adapt = ADAPT_SCALE_NPAGES; adapt < numentries;
_

Patches currently in -mm which might be from mhocko@suse.com are

fs-file-replace-alloc_fdmem-with-kvmalloc-alternative.patch
mm-remove-return-value-from-init_currently_empty_zone.patch
mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable.patch
mm-drop-page_initialized-check-from-get_nid_for_pfn.patch
mm-memory_hotplug-get-rid-of-is_zone_device_section.patch
mm-memory_hotplug-split-up-register_one_node.patch
mm-memory_hotplug-consider-offline-memblocks-removable.patch
mm-consider-zone-which-is-not-fully-populated-to-have-holes.patch
mm-compaction-skip-over-holes-in-__reset_isolation_suitable.patch
mm-__first_valid_page-skip-over-offline-pages.patch
mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch
mm-memory_hotplug-fix-mmop_online_keep-behavior.patch
mm-memory_hotplug-do-not-assume-zone_normal-is-default-kernel-zone.patch
mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory.patch
mm-memory_hotplug-fix-the-section-mismatch-warning.patch
mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch
mm-adaptive-hash-table-scaling.patch
mm-memory_hotplug-drop-artificial-restriction-on-online-offline.patch
mm-memory_hotplug-drop-config_movable_node.patch
mm-memory_hotplug-move-movable_node-to-the-hotplug-proper.patch


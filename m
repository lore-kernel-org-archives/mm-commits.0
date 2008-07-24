From: akpm@linux-foundation.org
Subject: - mm-page_allocc-cleanups.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:24:21 -0700
Message-ID: <200807242324.m6ONOLi0010775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754936AbYGXXYc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:24:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm/page_alloc.c: cleanups
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/page_alloc.c: cleanups
From: Adrian Bunk <bunk@kernel.org>

This patch contains the following cleanups:
- make the following needlessly global variables static:
  - required_kernelcore
  - zone_movable_pfn[]
- make the following needlessly global functions static:
  - move_freepages()
  - move_freepages_block()
  - setup_pageset()
  - find_usable_zone_for_movable()
  - adjust_zone_range_for_zone_movable()
  - __absent_pages_in_range()
  - find_min_pfn_for_node()
  - find_zone_movable_pfns_for_nodes()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-cleanups mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-cleanups
+++ a/mm/page_alloc.c
@@ -153,9 +153,9 @@ static unsigned long __meminitdata dma_r
   static unsigned long __meminitdata node_boundary_start_pfn[MAX_NUMNODES];
   static unsigned long __meminitdata node_boundary_end_pfn[MAX_NUMNODES];
 #endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
-  unsigned long __initdata required_kernelcore;
+  static unsigned long __initdata required_kernelcore;
   static unsigned long __initdata required_movablecore;
-  unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
+  static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
 
   /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
   int movable_zone;
@@ -674,9 +674,9 @@ static int fallbacks[MIGRATE_TYPES][MIGR
  * Note that start_page and end_pages are not aligned on a pageblock
  * boundary. If alignment is required, use move_freepages_block()
  */
-int move_freepages(struct zone *zone,
-			struct page *start_page, struct page *end_page,
-			int migratetype)
+static int move_freepages(struct zone *zone,
+			  struct page *start_page, struct page *end_page,
+			  int migratetype)
 {
 	struct page *page;
 	unsigned long order;
@@ -715,7 +715,8 @@ int move_freepages(struct zone *zone,
 	return pages_moved;
 }
 
-int move_freepages_block(struct zone *zone, struct page *page, int migratetype)
+static int move_freepages_block(struct zone *zone, struct page *page,
+				int migratetype)
 {
 	unsigned long start_pfn, end_pfn;
 	struct page *start_page, *end_page;
@@ -2652,7 +2653,7 @@ static int zone_batchsize(struct zone *z
 	return batch;
 }
 
-inline void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
+static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
 {
 	struct per_cpu_pages *pcp;
 
@@ -3099,7 +3100,7 @@ void __meminit get_pfn_range_for_nid(uns
  * assumption is made that zones within a node are ordered in monotonic
  * increasing memory addresses so that the "highest" populated zone is used
  */
-void __init find_usable_zone_for_movable(void)
+static void __init find_usable_zone_for_movable(void)
 {
 	int zone_index;
 	for (zone_index = MAX_NR_ZONES - 1; zone_index >= 0; zone_index--) {
@@ -3125,7 +3126,7 @@ void __init find_usable_zone_for_movable
  * highest usable zone for ZONE_MOVABLE. This preserves the assumption that
  * zones within a node are in order of monotonic increases memory addresses
  */
-void __meminit adjust_zone_range_for_zone_movable(int nid,
+static void __meminit adjust_zone_range_for_zone_movable(int nid,
 					unsigned long zone_type,
 					unsigned long node_start_pfn,
 					unsigned long node_end_pfn,
@@ -3186,7 +3187,7 @@ static unsigned long __meminit zone_span
  * Return the number of holes in a range on a node. If nid is MAX_NUMNODES,
  * then all holes in the requested range will be accounted for.
  */
-unsigned long __meminit __absent_pages_in_range(int nid,
+static unsigned long __meminit __absent_pages_in_range(int nid,
 				unsigned long range_start_pfn,
 				unsigned long range_end_pfn)
 {
@@ -3723,7 +3724,7 @@ static void __init sort_node_map(void)
 }
 
 /* Find the lowest pfn for a node */
-unsigned long __init find_min_pfn_for_node(int nid)
+static unsigned long __init find_min_pfn_for_node(int nid)
 {
 	int i;
 	unsigned long min_pfn = ULONG_MAX;
@@ -3795,7 +3796,7 @@ static unsigned long __init early_calcul
  * memory. When they don't, some nodes will have more kernelcore than
  * others
  */
-void __init find_zone_movable_pfns_for_nodes(unsigned long *movable_pfn)
+static void __init find_zone_movable_pfns_for_nodes(unsigned long *movable_pfn)
 {
 	int i, nid;
 	unsigned long usable_startpfn;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
init-do_mountsc-should-include-linux-initrdh.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
asm-generic-int-ll64h-always-provide-__su64.patch
remove-some-more-tipar-bits.patch
include-linux-kernelh-userspace-header-cleanup.patch
minix-remove-no_truncate-code.patch
jbd-unexport-journal_update_superblock.patch
coda-remove-coda_fs_old_api.patch
fat-dirc-switch-to-struct-__fat_dirent.patch
remove-the-in-kernel-struct-dirent64.patch
remove-unused-include-linux-direnths.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
pty-remove-unused-unix98_pty_count-options.patch
proper-extern-for-mwave_s_mdd.patch
if-0-hpet_unregister.patch
unexport-proc_clear_tty.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proper-pidhashmap_init-prototypes.patch
unexport-uts_sem.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
drm-make-drm_minors_cleanup-static.patch
make-cgroup_seqfile_release-static.patch
make-pnp_add_card_id-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
make-macfb_setup-static.patch
video-console-sticonrec-make-code-static.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
video-stifbc-make-2-functions-static.patch
reiser4.patch


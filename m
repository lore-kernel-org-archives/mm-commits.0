From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_owner-print-migratetype-of-page-and-pageblock-symbolic-flags.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:55:57 -0700
Message-ID: <56e9ba4d.oMzNCXThizACIkMk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbcCPTz6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:55:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_owner: print migratetype of page and pageblock, symbolic flags
has been removed from the -mm tree.  Its filename was
     mm-page_owner-print-migratetype-of-page-and-pageblock-symbolic-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_owner: print migratetype of page and pageblock, symbolic flags

The information in /sys/kernel/debug/page_owner includes the migratetype
of the pageblock the page belongs to.  This is also checked against the
page's migratetype (as declared by gfp_flags during its allocation), and
the page is reported as Fallback if its migratetype differs from the
pageblock's one.  t This is somewhat misleading because in fact fallback
allocation is not the only reason why these two can differ.  It also
doesn't direcly provide the page's migratetype, although it's possible to
derive that from the gfp_flags.

It's arguably better to print both page and pageblock's migratetype and
leave the interpretation to the consumer than to suggest fallback
allocation as the only possible reason.  While at it, we can print the
migratetypes as string the same way as /proc/pagetypeinfo does, as some of
the numeric values depend on kernel configuration.  For that, this patch
moves the migratetype_names array from #ifdef CONFIG_PROC_FS part of
mm/vmstat.c to mm/page_alloc.c and exports it.

With the new format strings for flags, we can now also provide symbolic
page and gfp flags in the /sys/kernel/debug/page_owner file.  This
replaces the positional printing of page flags as single letters, which
might have looked nicer, but was limited to a subset of flags, and
required the user to remember the letters.

Example page_owner entry after the patch:

Page allocated via order 0, mask 0x24213ca(GFP_HIGHUSER_MOVABLE|__GFP_COLD|__GFP_NOWARN|__GFP_NORETRY)
PFN 520 type Movable Block 1 type Movable Flags 0xfffff8001006c(referenced|uptodate|lru|active|mappedtodisk)
 [<ffffffff811682c4>] __alloc_pages_nodemask+0x134/0x230
 [<ffffffff811b4058>] alloc_pages_current+0x88/0x120
 [<ffffffff8115e386>] __page_cache_alloc+0xe6/0x120
 [<ffffffff8116ba6c>] __do_page_cache_readahead+0xdc/0x240
 [<ffffffff8116bd05>] ondemand_readahead+0x135/0x260
 [<ffffffff8116bfb1>] page_cache_sync_readahead+0x31/0x50
 [<ffffffff81160523>] generic_file_read_iter+0x453/0x760
 [<ffffffff811e0d57>] __vfs_read+0xa7/0xd0

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +++
 mm/page_alloc.c        |   13 +++++++++++++
 mm/page_owner.c        |   24 +++++++-----------------
 mm/vmstat.c            |   13 -------------
 4 files changed, 23 insertions(+), 30 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_owner-print-migratetype-of-page-and-pageblock-symbolic-flags include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_owner-print-migratetype-of-page-and-pageblock-symbolic-flags
+++ a/include/linux/mmzone.h
@@ -63,6 +63,9 @@ enum {
 	MIGRATE_TYPES
 };
 
+/* In mm/page_alloc.c; keep in sync also with show_migration_types() there */
+extern char * const migratetype_names[MIGRATE_TYPES];
+
 #ifdef CONFIG_CMA
 #  define is_migrate_cma(migratetype) unlikely((migratetype) == MIGRATE_CMA)
 #else
diff -puN mm/page_alloc.c~mm-page_owner-print-migratetype-of-page-and-pageblock-symbolic-flags mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_owner-print-migratetype-of-page-and-pageblock-symbolic-flags
+++ a/mm/page_alloc.c
@@ -223,6 +223,19 @@ static char * const zone_names[MAX_NR_ZO
 #endif
 };
 
+char * const migratetype_names[MIGRATE_TYPES] = {
+	"Unmovable",
+	"Movable",
+	"Reclaimable",
+	"HighAtomic",
+#ifdef CONFIG_CMA
+	"CMA",
+#endif
+#ifdef CONFIG_MEMORY_ISOLATION
+	"Isolate",
+#endif
+};
+
 compound_page_dtor * const compound_page_dtors[] = {
 	NULL,
 	free_compound_page,
diff -puN mm/page_owner.c~mm-page_owner-print-migratetype-of-page-and-pageblock-symbolic-flags mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-print-migratetype-of-page-and-pageblock-symbolic-flags
+++ a/mm/page_owner.c
@@ -100,8 +100,9 @@ print_page_owner(char __user *buf, size_
 		return -ENOMEM;
 
 	ret = snprintf(kbuf, count,
-			"Page allocated via order %u, mask 0x%x\n",
-			page_ext->order, page_ext->gfp_mask);
+			"Page allocated via order %u, mask %#x(%pGg)\n",
+			page_ext->order, page_ext->gfp_mask,
+			&page_ext->gfp_mask);
 
 	if (ret >= count)
 		goto err;
@@ -110,23 +111,12 @@ print_page_owner(char __user *buf, size_
 	pageblock_mt = get_pfnblock_migratetype(page, pfn);
 	page_mt  = gfpflags_to_migratetype(page_ext->gfp_mask);
 	ret += snprintf(kbuf + ret, count - ret,
-			"PFN %lu Block %lu type %d %s Flags %s%s%s%s%s%s%s%s%s%s%s%s\n",
+			"PFN %lu type %s Block %lu type %s Flags %#lx(%pGp)\n",
 			pfn,
+			migratetype_names[page_mt],
 			pfn >> pageblock_order,
-			pageblock_mt,
-			pageblock_mt != page_mt ? "Fallback" : "        ",
-			PageLocked(page)	? "K" : " ",
-			PageError(page)		? "E" : " ",
-			PageReferenced(page)	? "R" : " ",
-			PageUptodate(page)	? "U" : " ",
-			PageDirty(page)		? "D" : " ",
-			PageLRU(page)		? "L" : " ",
-			PageActive(page)	? "A" : " ",
-			PageSlab(page)		? "S" : " ",
-			PageWriteback(page)	? "W" : " ",
-			PageCompound(page)	? "C" : " ",
-			PageSwapCache(page)	? "B" : " ",
-			PageMappedToDisk(page)	? "M" : " ");
+			migratetype_names[pageblock_mt],
+			page->flags, &page->flags);
 
 	if (ret >= count)
 		goto err;
diff -puN mm/vmstat.c~mm-page_owner-print-migratetype-of-page-and-pageblock-symbolic-flags mm/vmstat.c
--- a/mm/vmstat.c~mm-page_owner-print-migratetype-of-page-and-pageblock-symbolic-flags
+++ a/mm/vmstat.c
@@ -924,19 +924,6 @@ static void walk_zones_in_node(struct se
 #endif
 
 #ifdef CONFIG_PROC_FS
-static char * const migratetype_names[MIGRATE_TYPES] = {
-	"Unmovable",
-	"Movable",
-	"Reclaimable",
-	"HighAtomic",
-#ifdef CONFIG_CMA
-	"CMA",
-#endif
-#ifdef CONFIG_MEMORY_ISOLATION
-	"Isolate",
-#endif
-};

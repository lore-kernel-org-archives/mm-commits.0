From: akpm@linux-foundation.org
Subject: +
 mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock.patch
 added to -mm tree
Date: Tue, 24 Nov 2015 14:45:18 -0800
Message-ID: <5654e87e.7Hfkj68GdjHHKKsh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110AbbKXWpT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Nov 2015 17:45:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_owner: print symbolic migratetype of both page and pageblock
has been added to the -mm tree.  Its filename is
     mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_owner: print symbolic migratetype of both page and pageblock

The information in /sys/kernel/debug/page_owner includes the migratetype
of the pageblock the page belongs to.  This is also checked against the
page's migratetype (as declared by gfp_flags during its allocation), and
the page is reported as Fallback if its migratetype differs from the
pageblock's one.

This is somewhat misleading because in fact fallback allocation is not the
only reason why these two can differ.  It also doesn't direcly provide the
page's migratetype, although it's possible to derive that from the
gfp_flags.

It's arguably better to print both page and pageblock's migratetype and
leave the interpretation to the consumer than to suggest fallback
allocation as the only possible reason.  While at it, we can print the
migratetypes as string the same way as /proc/pagetypeinfo does, as some of
the numeric values depend on kernel configuration.  For that, this patch
moves the migratetype_names array from #ifdef CONFIG_PROC_FS part of
mm/vmstat.c to mm/page_alloc.c and exports it.

Example page_owner entry after the patch:

Page allocated via order 0, mask 0x2420848
PFN 512 type Reclaimable Block 1 type Reclaimable Flags   R  LA
 [<ffffffff81164e8a>] __alloc_pages_nodemask+0x15a/0xa30
 [<ffffffff811ab808>] alloc_pages_current+0x88/0x120
 [<ffffffff8115bc36>] __page_cache_alloc+0xe6/0x120
 [<ffffffff8115c226>] pagecache_get_page+0x56/0x200
 [<ffffffff81205892>] __getblk_slow+0xd2/0x2b0
 [<ffffffff81205ab0>] __getblk_gfp+0x40/0x50
 [<ffffffff81206ad7>] __breadahead+0x17/0x50
 [<ffffffffa0437b27>] __ext4_get_inode_loc+0x397/0x3e0 [ext4]

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +++
 mm/page_alloc.c        |   13 +++++++++++++
 mm/page_owner.c        |    6 +++---
 mm/vmstat.c            |   13 -------------
 4 files changed, 19 insertions(+), 16 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock
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
diff -puN mm/page_alloc.c~mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock
+++ a/mm/page_alloc.c
@@ -229,6 +229,19 @@ static char * const zone_names[MAX_NR_ZO
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
diff -puN mm/page_owner.c~mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock
+++ a/mm/page_owner.c
@@ -110,11 +110,11 @@ print_page_owner(char __user *buf, size_
 	pageblock_mt = get_pfnblock_migratetype(page, pfn);
 	page_mt  = gfpflags_to_migratetype(page_ext->gfp_mask);
 	ret += snprintf(kbuf + ret, count - ret,
-			"PFN %lu Block %lu type %d %s Flags %s%s%s%s%s%s%s%s%s%s%s%s\n",
+			"PFN %lu type %s Block %lu type %s Flags %s%s%s%s%s%s%s%s%s%s%s%s\n",
 			pfn,
+			migratetype_names[page_mt],
 			pfn >> pageblock_order,
-			pageblock_mt,
-			pageblock_mt != page_mt ? "Fallback" : "        ",
+			migratetype_names[pageblock_mt],
 			PageLocked(page)	? "K" : " ",
 			PageError(page)		? "E" : " ",
 			PageReferenced(page)	? "R" : " ",
diff -puN mm/vmstat.c~mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock mm/vmstat.c
--- a/mm/vmstat.c~mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock
+++ a/mm/vmstat.c
@@ -921,19 +921,6 @@ static void walk_zones_in_node(struct se
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

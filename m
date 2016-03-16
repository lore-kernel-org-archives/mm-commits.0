From: akpm@linux-foundation.org
Subject: [merged] mm-page_owner-dump-page-owner-info-from-dump_page.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:56:06 -0700
Message-ID: <56e9ba56.2vVWLh2POLkNnTOv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934033AbcCPT4H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:56:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_owner: dump page owner info from dump_page()
has been removed from the -mm tree.  Its filename was
     mm-page_owner-dump-page-owner-info-from-dump_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_owner: dump page owner info from dump_page()

The page_owner mechanism is useful for dealing with memory leaks.  By
reading /sys/kernel/debug/page_owner one can determine the stack traces
leading to allocations of all pages, and find e.g.  a buggy driver.

This information might be also potentially useful for debugging, such as
the VM_BUG_ON_PAGE() calls to dump_page().  So let's print the stored info
from dump_page().

Example output:

page:ffffea000292f1c0 count:1 mapcount:0 mapping:ffff8800b2f6cc18 index:0x91d
flags: 0x1fffff8001002c(referenced|uptodate|lru|mappedtodisk)
page dumped because: VM_BUG_ON_PAGE(1)
page->mem_cgroup:ffff8801392c5000
page allocated via order 0, migratetype Movable, gfp_mask 0x24213ca(GFP_HIGHUSER_MOVABLE|__GFP_COLD|__GFP_NOWARN|__GFP_NORETRY)
 [<ffffffff811682c4>] __alloc_pages_nodemask+0x134/0x230
 [<ffffffff811b40c8>] alloc_pages_current+0x88/0x120
 [<ffffffff8115e386>] __page_cache_alloc+0xe6/0x120
 [<ffffffff8116ba6c>] __do_page_cache_readahead+0xdc/0x240
 [<ffffffff8116bd05>] ondemand_readahead+0x135/0x260
 [<ffffffff8116be9c>] page_cache_async_readahead+0x6c/0x70
 [<ffffffff811604c2>] generic_file_read_iter+0x3f2/0x760
 [<ffffffff811e0dc7>] __vfs_read+0xa7/0xd0
page has been migrated, last migrate reason: compaction

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_owner.h |    9 +++++++++
 mm/debug.c                 |    2 ++
 mm/page_alloc.c            |    1 +
 mm/page_owner.c            |   25 +++++++++++++++++++++++++
 4 files changed, 37 insertions(+)

diff -puN include/linux/page_owner.h~mm-page_owner-dump-page-owner-info-from-dump_page include/linux/page_owner.h
--- a/include/linux/page_owner.h~mm-page_owner-dump-page-owner-info-from-dump_page
+++ a/include/linux/page_owner.h
@@ -13,6 +13,7 @@ extern void __set_page_owner(struct page
 extern gfp_t __get_page_owner_gfp(struct page *page);
 extern void __copy_page_owner(struct page *oldpage, struct page *newpage);
 extern void __set_page_owner_migrate_reason(struct page *page, int reason);
+extern void __dump_page_owner(struct page *page);
 
 static inline void reset_page_owner(struct page *page, unsigned int order)
 {
@@ -44,6 +45,11 @@ static inline void set_page_owner_migrat
 	if (static_branch_unlikely(&page_owner_inited))
 		__set_page_owner_migrate_reason(page, reason);
 }
+static inline void dump_page_owner(struct page *page)
+{
+	if (static_branch_unlikely(&page_owner_inited))
+		__dump_page_owner(page);
+}
 #else
 static inline void reset_page_owner(struct page *page, unsigned int order)
 {
@@ -62,5 +68,8 @@ static inline void copy_page_owner(struc
 static inline void set_page_owner_migrate_reason(struct page *page, int reason)
 {
 }
+static inline void dump_page_owner(struct page *page)
+{
+}
 #endif /* CONFIG_PAGE_OWNER */
 #endif /* __LINUX_PAGE_OWNER_H */
diff -puN mm/debug.c~mm-page_owner-dump-page-owner-info-from-dump_page mm/debug.c
--- a/mm/debug.c~mm-page_owner-dump-page-owner-info-from-dump_page
+++ a/mm/debug.c
@@ -11,6 +11,7 @@
 #include <linux/memcontrol.h>
 #include <trace/events/mmflags.h>
 #include <linux/migrate.h>
+#include <linux/page_owner.h>
 
 #include "internal.h"
 
@@ -67,6 +68,7 @@ void dump_page_badflags(struct page *pag
 void dump_page(struct page *page, const char *reason)
 {
 	dump_page_badflags(page, reason, 0);
+	dump_page_owner(page);
 }
 EXPORT_SYMBOL(dump_page);
 
diff -puN mm/page_alloc.c~mm-page_owner-dump-page-owner-info-from-dump_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_owner-dump-page-owner-info-from-dump_page
+++ a/mm/page_alloc.c
@@ -443,6 +443,7 @@ static void bad_page(struct page *page,
 	printk(KERN_ALERT "BUG: Bad page state in process %s  pfn:%05lx\n",
 		current->comm, page_to_pfn(page));
 	dump_page_badflags(page, reason, bad_flags);
+	dump_page_owner(page);
 
 	print_modules();
 	dump_stack();
diff -puN mm/page_owner.c~mm-page_owner-dump-page-owner-info-from-dump_page mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-dump-page-owner-info-from-dump_page
+++ a/mm/page_owner.c
@@ -183,6 +183,31 @@ err:
 	return -ENOMEM;
 }
 
+void __dump_page_owner(struct page *page)
+{
+	struct page_ext *page_ext = lookup_page_ext(page);
+	struct stack_trace trace = {
+		.nr_entries = page_ext->nr_entries,
+		.entries = &page_ext->trace_entries[0],
+	};
+	gfp_t gfp_mask = page_ext->gfp_mask;
+	int mt = gfpflags_to_migratetype(gfp_mask);
+
+	if (!test_bit(PAGE_EXT_OWNER, &page_ext->flags)) {
+		pr_alert("page_owner info is not active (free page?)\n");
+		return;
+	}
+
+	pr_alert("page allocated via order %u, migratetype %s, "
+			"gfp_mask %#x(%pGg)\n", page_ext->order,
+			migratetype_names[mt], gfp_mask, &gfp_mask);
+	print_stack_trace(&trace, 0);
+
+	if (page_ext->last_migrate_reason != -1)
+		pr_alert("page has been migrated, last migrate reason: %s\n",
+			migrate_reason_names[page_ext->last_migrate_reason]);
+}
+
 static ssize_t
 read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-kswapd-remove-bogus-check-of-balance_classzone_idx.patch
mm-compaction-introduce-kcompactd.patch
mm-compaction-introduce-kcompactd-fix-3.patch
mm-compaction-introduce-kcompactd-fix-4.patch
mm-memory-hotplug-small-cleanup-in-online_pages.patch
mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd.patch
mm-tracing-refresh-__def_vmaflag_names-fix.patch
mm-use-radix_tree_iter_retry-fix.patch


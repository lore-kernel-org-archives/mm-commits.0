From: akpm@linux-foundation.org
Subject: [merged] mm-page_owner-track-and-print-last-migrate-reason.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:56:04 -0700
Message-ID: <56e9ba54.rThtggTAXaUEgWNS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934033AbcCPT4F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:56:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_owner: track and print last migrate reason
has been removed from the -mm tree.  Its filename was
     mm-page_owner-track-and-print-last-migrate-reason.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_owner: track and print last migrate reason

During migration, page_owner info is now copied with the rest of the page,
so the stacktrace leading to free page allocation during migration is
overwritten.  For debugging purposes, it might be however useful to know
that the page has been migrated since its initial allocation.  This might
happen many times during the lifetime for different reasons and fully
tracking this, especially with stacktraces would incur extra memory costs.
As a compromise, store and print the migrate_reason of the last migration
that occurred to the page.  This is enough to distinguish compaction, numa
balancing etc.

Example page_owner entry after the patch:

Page allocated via order 0, mask 0x24200ca(GFP_HIGHUSER_MOVABLE)
PFN 628753 type Movable Block 1228 type Movable Flags 0x1fffff80040030(dirty|lru|swapbacked)
 [<ffffffff811682c4>] __alloc_pages_nodemask+0x134/0x230
 [<ffffffff811b6325>] alloc_pages_vma+0xb5/0x250
 [<ffffffff81177491>] shmem_alloc_page+0x61/0x90
 [<ffffffff8117a438>] shmem_getpage_gfp+0x678/0x960
 [<ffffffff8117c2b9>] shmem_fallocate+0x329/0x440
 [<ffffffff811de600>] vfs_fallocate+0x140/0x230
 [<ffffffff811df434>] SyS_fallocate+0x44/0x70
 [<ffffffff8158cc2e>] entry_SYSCALL_64_fastpath+0x12/0x71
Page has been migrated, last migrate reason: compaction

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h    |    6 +++++-
 include/linux/page_ext.h   |    1 +
 include/linux/page_owner.h |    9 +++++++++
 mm/debug.c                 |   11 +++++++++++
 mm/migrate.c               |   10 +++++++---
 mm/page_owner.c            |   17 +++++++++++++++++
 6 files changed, 50 insertions(+), 4 deletions(-)

diff -puN include/linux/migrate.h~mm-page_owner-track-and-print-last-migrate-reason include/linux/migrate.h
--- a/include/linux/migrate.h~mm-page_owner-track-and-print-last-migrate-reason
+++ a/include/linux/migrate.h
@@ -23,9 +23,13 @@ enum migrate_reason {
 	MR_SYSCALL,		/* also applies to cpusets */
 	MR_MEMPOLICY_MBIND,
 	MR_NUMA_MISPLACED,
-	MR_CMA
+	MR_CMA,
+	MR_TYPES
 };
 
+/* In mm/debug.c; also keep sync with include/trace/events/migrate.h */
+extern char *migrate_reason_names[MR_TYPES];
+
 #ifdef CONFIG_MIGRATION
 
 extern void putback_movable_pages(struct list_head *l);
diff -puN include/linux/page_ext.h~mm-page_owner-track-and-print-last-migrate-reason include/linux/page_ext.h
--- a/include/linux/page_ext.h~mm-page_owner-track-and-print-last-migrate-reason
+++ a/include/linux/page_ext.h
@@ -45,6 +45,7 @@ struct page_ext {
 	unsigned int order;
 	gfp_t gfp_mask;
 	unsigned int nr_entries;
+	int last_migrate_reason;
 	unsigned long trace_entries[8];
 #endif
 };
diff -puN include/linux/page_owner.h~mm-page_owner-track-and-print-last-migrate-reason include/linux/page_owner.h
--- a/include/linux/page_owner.h~mm-page_owner-track-and-print-last-migrate-reason
+++ a/include/linux/page_owner.h
@@ -12,6 +12,7 @@ extern void __set_page_owner(struct page
 			unsigned int order, gfp_t gfp_mask);
 extern gfp_t __get_page_owner_gfp(struct page *page);
 extern void __copy_page_owner(struct page *oldpage, struct page *newpage);
+extern void __set_page_owner_migrate_reason(struct page *page, int reason);
 
 static inline void reset_page_owner(struct page *page, unsigned int order)
 {
@@ -38,6 +39,11 @@ static inline void copy_page_owner(struc
 	if (static_branch_unlikely(&page_owner_inited))
 		__copy_page_owner(oldpage, newpage);
 }
+static inline void set_page_owner_migrate_reason(struct page *page, int reason)
+{
+	if (static_branch_unlikely(&page_owner_inited))
+		__set_page_owner_migrate_reason(page, reason);
+}
 #else
 static inline void reset_page_owner(struct page *page, unsigned int order)
 {
@@ -53,5 +59,8 @@ static inline gfp_t get_page_owner_gfp(s
 static inline void copy_page_owner(struct page *oldpage, struct page *newpage)
 {
 }
+static inline void set_page_owner_migrate_reason(struct page *page, int reason)
+{
+}
 #endif /* CONFIG_PAGE_OWNER */
 #endif /* __LINUX_PAGE_OWNER_H */
diff -puN mm/debug.c~mm-page_owner-track-and-print-last-migrate-reason mm/debug.c
--- a/mm/debug.c~mm-page_owner-track-and-print-last-migrate-reason
+++ a/mm/debug.c
@@ -10,9 +10,20 @@
 #include <linux/trace_events.h>
 #include <linux/memcontrol.h>
 #include <trace/events/mmflags.h>
+#include <linux/migrate.h>
 
 #include "internal.h"
 
+char *migrate_reason_names[MR_TYPES] = {
+	"compaction",
+	"memory_failure",
+	"memory_hotplug",
+	"syscall_or_cpuset",
+	"mempolicy_mbind",
+	"numa_misplaced",
+	"cma",
+};
+
 const struct trace_print_flags pageflag_names[] = {
 	__def_pageflag_names,
 	{0, NULL}
diff -puN mm/migrate.c~mm-page_owner-track-and-print-last-migrate-reason mm/migrate.c
--- a/mm/migrate.c~mm-page_owner-track-and-print-last-migrate-reason
+++ a/mm/migrate.c
@@ -955,8 +955,10 @@ static ICE_noinline int unmap_and_move(n
 	}
 
 	rc = __unmap_and_move(page, newpage, force, mode);
-	if (rc == MIGRATEPAGE_SUCCESS)
+	if (rc == MIGRATEPAGE_SUCCESS) {
 		put_new_page = NULL;
+		set_page_owner_migrate_reason(newpage, reason);
+	}
 
 out:
 	if (rc != -EAGAIN) {
@@ -1021,7 +1023,7 @@ out:
 static int unmap_and_move_huge_page(new_page_t get_new_page,
 				free_page_t put_new_page, unsigned long private,
 				struct page *hpage, int force,
-				enum migrate_mode mode)
+				enum migrate_mode mode, int reason)
 {
 	int rc = -EAGAIN;
 	int *result = NULL;
@@ -1079,6 +1081,7 @@ put_anon:
 	if (rc == MIGRATEPAGE_SUCCESS) {
 		hugetlb_cgroup_migrate(hpage, new_hpage);
 		put_new_page = NULL;
+		set_page_owner_migrate_reason(new_hpage, reason);
 	}
 
 	unlock_page(hpage);
@@ -1151,7 +1154,7 @@ int migrate_pages(struct list_head *from
 			if (PageHuge(page))
 				rc = unmap_and_move_huge_page(get_new_page,
 						put_new_page, private, page,
-						pass > 2, mode);
+						pass > 2, mode, reason);
 			else
 				rc = unmap_and_move(get_new_page, put_new_page,
 						private, page, pass > 2, mode,
@@ -1842,6 +1845,7 @@ fail_putback:
 	set_page_memcg(new_page, page_memcg(page));
 	set_page_memcg(page, NULL);
 	page_remove_rmap(page, true);
+	set_page_owner_migrate_reason(new_page, MR_NUMA_MISPLACED);
 
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
diff -puN mm/page_owner.c~mm-page_owner-track-and-print-last-migrate-reason mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-track-and-print-last-migrate-reason
+++ a/mm/page_owner.c
@@ -6,6 +6,7 @@
 #include <linux/stacktrace.h>
 #include <linux/page_owner.h>
 #include <linux/jump_label.h>
+#include <linux/migrate.h>
 #include "internal.h"
 
 static bool page_owner_disabled = true;
@@ -73,10 +74,18 @@ void __set_page_owner(struct page *page,
 	page_ext->order = order;
 	page_ext->gfp_mask = gfp_mask;
 	page_ext->nr_entries = trace.nr_entries;
+	page_ext->last_migrate_reason = -1;
 
 	__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
 }
 
+void __set_page_owner_migrate_reason(struct page *page, int reason)
+{
+	struct page_ext *page_ext = lookup_page_ext(page);
+
+	page_ext->last_migrate_reason = reason;
+}
+
 gfp_t __get_page_owner_gfp(struct page *page)
 {
 	struct page_ext *page_ext = lookup_page_ext(page);
@@ -151,6 +160,14 @@ print_page_owner(char __user *buf, size_
 	if (ret >= count)
 		goto err;
 
+	if (page_ext->last_migrate_reason != -1) {
+		ret += snprintf(kbuf + ret, count - ret,
+			"Page has been migrated, last migrate reason: %s\n",
+			migrate_reason_names[page_ext->last_migrate_reason]);
+		if (ret >= count)
+			goto err;
+	}
+
 	ret += snprintf(kbuf + ret, count - ret, "\n");
 	if (ret >= count)
 		goto err;
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


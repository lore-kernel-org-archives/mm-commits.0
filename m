From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-remove-unused-parameter-in-init_currently_empty_zone.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:08:03 -0800
Message-ID: <563d08a3.V+JYAi1BkYQX5hup%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033601AbbKFUID (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:08:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: remove unused parameter in init_currently_empty_zone()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-unused-parameter-in-init_currently_empty_zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: mm/page_alloc: remove unused parameter in init_currently_empty_zone()

Commit a2f3aa02576632cdb ("[PATCH] Fix sparsemem on Cell") fixed an oops
experienced on the Cell architecture when init-time functions, early_*(),
are called at runtime by introducing an 'enum memmap_context' parameter to
memmap_init_zone() and init_currently_empty_zone().  This parameter is
intended to be used to tell whether the call of these two functions is
being made on behalf of a hotplug event, or happening at boot-time. 
However, init_currently_empty_zone() does not use this parameter at all,
so remove it.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +--
 mm/memory_hotplug.c    |    4 ++--
 mm/page_alloc.c        |    6 ++----
 3 files changed, 5 insertions(+), 8 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_alloc-remove-unused-parameter-in-init_currently_empty_zone include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-remove-unused-parameter-in-init_currently_empty_zone
+++ a/include/linux/mmzone.h
@@ -823,8 +823,7 @@ enum memmap_context {
 	MEMMAP_HOTPLUG,
 };
 extern int init_currently_empty_zone(struct zone *zone, unsigned long start_pfn,
-				     unsigned long size,
-				     enum memmap_context context);
+				     unsigned long size);
 
 extern void lruvec_init(struct lruvec *lruvec);
 
diff -puN mm/memory_hotplug.c~mm-page_alloc-remove-unused-parameter-in-init_currently_empty_zone mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-page_alloc-remove-unused-parameter-in-init_currently_empty_zone
+++ a/mm/memory_hotplug.c
@@ -339,8 +339,8 @@ static int __ref ensure_zone_is_initiali
 			unsigned long start_pfn, unsigned long num_pages)
 {
 	if (!zone_is_initialized(zone))
-		return init_currently_empty_zone(zone, start_pfn, num_pages,
-						 MEMMAP_HOTPLUG);
+		return init_currently_empty_zone(zone, start_pfn, num_pages);
+
 	return 0;
 }
 
diff -puN mm/page_alloc.c~mm-page_alloc-remove-unused-parameter-in-init_currently_empty_zone mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-unused-parameter-in-init_currently_empty_zone
+++ a/mm/page_alloc.c
@@ -4900,8 +4900,7 @@ static __meminit void zone_pcp_init(stru
 
 int __meminit init_currently_empty_zone(struct zone *zone,
 					unsigned long zone_start_pfn,
-					unsigned long size,
-					enum memmap_context context)
+					unsigned long size)
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int ret;
@@ -5413,8 +5412,7 @@ static void __paginginit free_area_init_
 
 		set_pageblock_order();
 		setup_usemap(pgdat, zone, zone_start_pfn, size);
-		ret = init_currently_empty_zone(zone, zone_start_pfn,
-						size, MEMMAP_EARLY);
+		ret = init_currently_empty_zone(zone, zone_start_pfn, size);
 		BUG_ON(ret);
 		memmap_init(size, nid, j, zone_start_pfn);
 		zone_start_pfn += size;
_

Patches currently in -mm which might be from bywxiaobai@163.com are

mm-oom_kill-introduce-is_sysrq_oom-helper.patch
fs-kdev_t-remove-unused-huge_valid_dev-function.patch
fs-kdev_t-old-new_valid_dev-can-be-boolean.patch
fs-vfs-remove-unnecessary-new_valid_dev-check.patch
fs-btrfs-remove-unnecessary-new_valid_dev-check.patch
fs-exofs-remove-unnecessary-new_valid_dev-check.patch
fs-ext2-remove-unnecessary-new_valid_dev-check.patch
fs-f2fs-remove-unnecessary-new_valid_dev-check.patch
fs-hpfs-remove-unnecessary-new_valid_dev-check.patch
fs-jfs-remove-unnecessary-new_valid_dev-check.patch
fs-ncpfs-remove-unnecessary-new_valid_dev-check.patch
fs-nilfs2-remove-unnecessary-new_valid_dev-check.patch
fs-reiserfs-remove-unnecessary-new_valid_dev-check.patch
fs-stat-remove-unnecessary-new_valid_dev-check.patch
fs-ubifs-remove-unnecessary-new_valid_dev-check.patch


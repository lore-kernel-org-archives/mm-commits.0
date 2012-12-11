From: akpm@linux-foundation.org
Subject: [folded-merged] memory-hotplug-fix-nr_free_pages-mismatch-fix.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:39:41 -0800
Message-ID: <20121211233942.9F2C620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:44702 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab2LKXjp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:39:45 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so1684wey.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:39:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, wujianguo106@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: fix NR_FREE_PAGES mismatch's fix
has been removed from the -mm tree.  Its filename was
     memory-hotplug-fix-nr_free_pages-mismatch-fix.patch

This patch was dropped because it was folded into memory-hotplug-fix-nr_free_pages-mismatch.patch

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: memory-hotplug: fix NR_FREE_PAGES mismatch's fix

When a page is freed and put into pcp list, get_freepage_migratetype()
doesn't return MIGRATE_ISOLATE even if this pageblock is isolated.
So we should use get_freepage_migratetype() instead of mt to check
whether it is isolated.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Reported-by: Jianguo Wu <wujianguo106@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~memory-hotplug-fix-nr_free_pages-mismatch-fix mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-fix-nr_free_pages-mismatch-fix
+++ a/mm/page_alloc.c
@@ -666,7 +666,7 @@ static void free_pcppages_bulk(struct zo
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
 			__free_one_page(page, zone, 0, mt);
 			trace_mm_page_pcpu_drain(page, 0, mt);
-			if (likely(mt != MIGRATE_ISOLATE)) {
+			if (likely(get_pageblock_migratetype(page) != MIGRATE_ISOLATE)) {
 				__mod_zone_page_state(zone, NR_FREE_PAGES, 1);
 				if (is_migrate_cma(mt))
 					__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, 1);
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mm-memory_hotplugc-update-start_pfn-in-zone-and-pg_data-when-spanned_pages-==-0.patch
drivers-base-nodec-cleanup-node_state_attr.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch
memory_hotplug-handle-empty-zone-when-online_movable-online_kernel.patch
memory_hotplug-ensure-every-online-node-has-normal-memory.patch


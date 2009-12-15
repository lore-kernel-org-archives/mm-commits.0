From: akpm@linux-foundation.org
Subject: [merged] mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:50:42 -0800
Message-ID: <200912152150.nBFLogNQ014976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760440AbZLOVvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:51:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     mm: move inc_zone_page_state(NR_ISOLATED) to just isolated place
has been removed from the -mm tree.  Its filename was
     mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: move inc_zone_page_state(NR_ISOLATED) to just isolated place
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Christoph pointed out inc_zone_page_state(NR_ISOLATED) should be placed
in right after isolate_page().

This patch does it.

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ++++
 mm/mempolicy.c      |    3 +++
 mm/migrate.c        |   12 ++++--------
 3 files changed, 11 insertions(+), 8 deletions(-)

diff -puN mm/memory_hotplug.c~mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place
+++ a/mm/memory_hotplug.c
@@ -27,6 +27,7 @@
 #include <linux/page-isolation.h>
 #include <linux/pfn.h>
 #include <linux/suspend.h>
+#include <linux/mm_inline.h>
 
 #include <asm/tlbflush.h>
 
@@ -672,6 +673,9 @@ do_migrate_range(unsigned long start_pfn
 		if (!ret) { /* Success */
 			list_add_tail(&page->lru, &source);
 			move_pages--;
+			inc_zone_page_state(page, NR_ISOLATED_ANON +
+					    page_is_file_cache(page));
+
 		} else {
 			/* Becasue we don't have big zone->lock. we should
 			   check this again here. */
diff -puN mm/mempolicy.c~mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place mm/mempolicy.c
--- a/mm/mempolicy.c~mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place
+++ a/mm/mempolicy.c
@@ -89,6 +89,7 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/ctype.h>
+#include <linux/mm_inline.h>
 
 #include <asm/tlbflush.h>
 #include <asm/uaccess.h>
@@ -809,6 +810,8 @@ static void migrate_page_add(struct page
 	if ((flags & MPOL_MF_MOVE_ALL) || page_mapcount(page) == 1) {
 		if (!isolate_lru_page(page)) {
 			list_add_tail(&page->lru, pagelist);
+			inc_zone_page_state(page, NR_ISOLATED_ANON +
+					    page_is_file_cache(page));
 		}
 	}
 }
diff -puN mm/migrate.c~mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place mm/migrate.c
--- a/mm/migrate.c~mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place
+++ a/mm/migrate.c
@@ -746,13 +746,6 @@ int migrate_pages(struct list_head *from
 	struct page *page2;
 	int swapwrite = current->flags & PF_SWAPWRITE;
 	int rc;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	list_for_each_entry(page, from, lru)
-		__inc_zone_page_state(page, NR_ISOLATED_ANON +
-				page_is_file_cache(page));
-	local_irq_restore(flags);
 
 	if (!swapwrite)
 		current->flags |= PF_SWAPWRITE;
@@ -878,8 +871,11 @@ static int do_move_page_to_node_array(st
 			goto put_and_set;
 
 		err = isolate_lru_page(page);
-		if (!err)
+		if (!err) {
 			list_add_tail(&page->lru, &pagelist);
+			inc_zone_page_state(page, NR_ISOLATED_ANON +
+					    page_is_file_cache(page));
+		}
 put_and_set:
 		/*
 		 * Either remove the duplicate refcount from
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mm-introduce-coredump-parameter-structure.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch


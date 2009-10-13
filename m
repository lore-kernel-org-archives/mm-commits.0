From: akpm@linux-foundation.org
Subject: + mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place.patch added to -mm tree
Date: Tue, 13 Oct 2009 11:55:08 -0700
Message-ID: <200910131855.n9DIt8FK018494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977AbZJMS4S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 14:56:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org


The patch titled
     mm: move inc_zone_page_state(NR_ISOLATED) to just isolated place
has been added to the -mm tree.  Its filename is
     mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: move inc_zone_page_state(NR_ISOLATED) to just isolated place
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Christoph pointed out inc_zone_page_state(NR_ISOLATED) should be placed
in right after isolate_page().

This patch does it.

Acked-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/memory_hotplug.c~mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place
+++ a/mm/memory_hotplug.c
@@ -26,6 +26,7 @@
 #include <linux/migrate.h>
 #include <linux/page-isolation.h>
 #include <linux/pfn.h>
+#include <linux/mm_inline.h>
 
 #include <asm/tlbflush.h>
 
@@ -663,6 +664,9 @@ do_migrate_range(unsigned long start_pfn
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

linux-next.patch
congestion_wait-dont-use-write.patch
cgroup-fix-strstrip-misuse.patch
strstrip-mark-as-as-must_check.patch
revert-mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
oom-dump-stack-and-vm-state-when-oom-killer-panics.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch
fix-memory-leak-of-never-putback-pages-in-mbind.patch
fix-memory-leak-of-do_mbind.patch


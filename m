From: akpm@linux-foundation.org
Subject: [merged]
 mm-migrate-dirty-page-without-clear_page_dirty_for_io-etc.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:16:58 -0800
Message-ID: <563d0aba.E6n/l/2TlhrgTh1+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032012AbbKFUQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:16:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, cl@linux.com, dave@stgolabs.net, dvyukov@google.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate dirty page without clear_page_dirty_for_io etc
has been removed from the -mm tree.  Its filename was
     mm-migrate-dirty-page-without-clear_page_dirty_for_io-etc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: migrate dirty page without clear_page_dirty_for_io etc

clear_page_dirty_for_io() has accumulated writeback and memcg subtleties
since v2.6.16 first introduced page migration; and the set_page_dirty()
which completed its migration of PageDirty, later had to be moderated to
__set_page_dirty_nobuffers(); then PageSwapBacked had to skip that too.

No actual problems seen with this procedure recently, but if you look into
what the clear_page_dirty_for_io(page)+set_page_dirty(newpage) is actually
achieving, it turns out to be nothing more than moving the PageDirty flag,
and its NR_FILE_DIRTY stat from one zone to another.

It would be good to avoid a pile of irrelevant decrementations and
incrementations, and improper event counting, and unnecessary descent of
the radix_tree under tree_lock (to set the PAGECACHE_TAG_DIRTY which
radix_tree_replace_slot() left in place anyway).

Do the NR_FILE_DIRTY movement, like the other stats movements, while
interrupts still disabled in migrate_page_move_mapping(); and don't even
bother if the zone is the same.  Do the PageDirty movement there under
tree_lock too, where old page is frozen and newpage not yet visible:
bearing in mind that as soon as newpage becomes visible in radix_tree, an
un-page-locked set_page_dirty() might interfere (or perhaps that's just
not possible: anything doing so should already hold an additional
reference to the old page, preventing its migration; but play safe).

But we do still need to transfer PageDirty in migrate_page_copy(), for
those who don't go the mapping route through migrate_page_move_mapping().

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   51 +++++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff -puN mm/migrate.c~mm-migrate-dirty-page-without-clear_page_dirty_for_io-etc mm/migrate.c
--- a/mm/migrate.c~mm-migrate-dirty-page-without-clear_page_dirty_for_io-etc
+++ a/mm/migrate.c
@@ -30,6 +30,7 @@
 #include <linux/mempolicy.h>
 #include <linux/vmalloc.h>
 #include <linux/security.h>
+#include <linux/backing-dev.h>
 #include <linux/syscalls.h>
 #include <linux/hugetlb.h>
 #include <linux/hugetlb_cgroup.h>
@@ -313,6 +314,8 @@ int migrate_page_move_mapping(struct add
 		struct buffer_head *head, enum migrate_mode mode,
 		int extra_count)
 {
+	struct zone *oldzone, *newzone;
+	int dirty;
 	int expected_count = 1 + extra_count;
 	void **pslot;
 
@@ -331,6 +334,9 @@ int migrate_page_move_mapping(struct add
 		return MIGRATEPAGE_SUCCESS;
 	}
 
+	oldzone = page_zone(page);
+	newzone = page_zone(newpage);
+
 	spin_lock_irq(&mapping->tree_lock);
 
 	pslot = radix_tree_lookup_slot(&mapping->page_tree,
@@ -378,6 +384,13 @@ int migrate_page_move_mapping(struct add
 		set_page_private(newpage, page_private(page));
 	}
 
+	/* Move dirty while page refs frozen and newpage not yet exposed */
+	dirty = PageDirty(page);
+	if (dirty) {
+		ClearPageDirty(page);
+		SetPageDirty(newpage);
+	}
+
 	radix_tree_replace_slot(pslot, newpage);
 
 	/*
@@ -387,6 +400,9 @@ int migrate_page_move_mapping(struct add
 	 */
 	page_unfreeze_refs(page, expected_count - 1);
 
+	spin_unlock(&mapping->tree_lock);
+	/* Leave irq disabled to prevent preemption while updating stats */
+
 	/*
 	 * If moved to a different zone then also account
 	 * the page for that zone. Other VM counters will be
@@ -397,13 +413,19 @@ int migrate_page_move_mapping(struct add
 	 * via NR_FILE_PAGES and NR_ANON_PAGES if they
 	 * are mapped to swap space.
 	 */
-	__dec_zone_page_state(page, NR_FILE_PAGES);
-	__inc_zone_page_state(newpage, NR_FILE_PAGES);
-	if (!PageSwapCache(page) && PageSwapBacked(page)) {
-		__dec_zone_page_state(page, NR_SHMEM);
-		__inc_zone_page_state(newpage, NR_SHMEM);
+	if (newzone != oldzone) {
+		__dec_zone_state(oldzone, NR_FILE_PAGES);
+		__inc_zone_state(newzone, NR_FILE_PAGES);
+		if (PageSwapBacked(page) && !PageSwapCache(page)) {
+			__dec_zone_state(oldzone, NR_SHMEM);
+			__inc_zone_state(newzone, NR_SHMEM);
+		}
+		if (dirty && mapping_cap_account_dirty(mapping)) {
+			__dec_zone_state(oldzone, NR_FILE_DIRTY);
+			__inc_zone_state(newzone, NR_FILE_DIRTY);
+		}
 	}
-	spin_unlock_irq(&mapping->tree_lock);
+	local_irq_enable();
 
 	return MIGRATEPAGE_SUCCESS;
 }
@@ -524,20 +546,9 @@ void migrate_page_copy(struct page *newp
 	if (PageMappedToDisk(page))
 		SetPageMappedToDisk(newpage);
 
-	if (PageDirty(page)) {
-		clear_page_dirty_for_io(page);
-		/*
-		 * Want to mark the page and the radix tree as dirty, and
-		 * redo the accounting that clear_page_dirty_for_io undid,
-		 * but we can't use set_page_dirty because that function
-		 * is actually a signal that all of the page has become dirty.
-		 * Whereas only part of our page may be dirty.
-		 */
-		if (PageSwapBacked(page))
-			SetPageDirty(newpage);
-		else
-			__set_page_dirty_nobuffers(newpage);
- 	}
+	/* Move dirty on pages not done by migrate_page_move_mapping() */
+	if (PageDirty(page))
+		SetPageDirty(newpage);
 
 	if (page_is_young(page))
 		set_page_young(newpage);
_

Patches currently in -mm which might be from hughd@google.com are

osd-fs-__r4w_get_page-rely-on-pageuptodate-for-uptodate.patch
mm-use-unsigned-int-for-page-order-fix-2.patch


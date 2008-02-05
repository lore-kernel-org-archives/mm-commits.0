From: akpm@linux-foundation.org
Subject: - page-migraton-handle-orphaned-pages.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:32:30 -0800
Message-ID: <200802052232.m15MWBYG012290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43409 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761174AbYBEWmb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, clameter@sgi.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     page migraton: handle orphaned pages
has been removed from the -mm tree.  Its filename was
     page-migraton-handle-orphaned-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page migraton: handle orphaned pages
From: Shaohua Li <shaohua.li@intel.com>

Orphaned page might have fs-private metadata, the page is truncated.  As
the page hasn't mapping, page migration refuse to migrate the page.  It
appears the page is only freed in page reclaim and if zone watermark is
low, the page is never freed, as a result migration always fail.  I thought
we could free the metadata so such page can be freed in migration and make
migration more reliable.

[akpm@linux-foundation.org: go direct to try_to_free_buffers()]
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c  |   30 ++++++++++++++++++++++++------
 mm/truncate.c |    2 +-
 2 files changed, 25 insertions(+), 7 deletions(-)

diff -puN mm/migrate.c~page-migraton-handle-orphaned-pages mm/migrate.c
--- a/mm/migrate.c~page-migraton-handle-orphaned-pages
+++ a/mm/migrate.c
@@ -640,15 +640,33 @@ static int unmap_and_move(new_page_t get
 		rcu_read_lock();
 		rcu_locked = 1;
 	}
+
 	/*
-	 * This is a corner case handling.
-	 * When a new swap-cache is read into, it is linked to LRU
-	 * and treated as swapcache but has no rmap yet.
-	 * Calling try_to_unmap() against a page->mapping==NULL page is
-	 * BUG. So handle it here.
+	 * Corner case handling:
+	 * 1. When a new swap-cache page is read into, it is added to the LRU
+	 * and treated as swapcache but it has no rmap yet.
+	 * Calling try_to_unmap() against a page->mapping==NULL page will
+	 * trigger a BUG.  So handle it here.
+	 * 2. An orphaned page (see truncate_complete_page) might have
+	 * fs-private metadata. The page can be picked up due to memory
+	 * offlining.  Everywhere else except page reclaim, the page is
+	 * invisible to the vm, so the page can not be migrated.  So try to
+	 * free the metadata, so the page can be freed.
 	 */
-	if (!page->mapping)
+	if (!page->mapping) {
+		if (!PageAnon(page) && PagePrivate(page)) {
+			/*
+			 * Go direct to try_to_free_buffers() here because
+			 * a) that's what try_to_release_page() would do anyway
+			 * b) we may be under rcu_read_lock() here, so we can't
+			 *    use GFP_KERNEL which is what try_to_release_page()
+			 *    needs to be effective.
+			 */
+			try_to_free_buffers(page);
+		}
 		goto rcu_unlock;
+	}
+
 	/* Establish migration ptes or remove ptes */
 	try_to_unmap(page, 1);
 
diff -puN mm/truncate.c~page-migraton-handle-orphaned-pages mm/truncate.c
--- a/mm/truncate.c~page-migraton-handle-orphaned-pages
+++ a/mm/truncate.c
@@ -84,7 +84,7 @@ EXPORT_SYMBOL(cancel_dirty_page);
 
 /*
  * If truncate cannot remove the fs-private metadata from the page, the page
- * becomes anonymous.  It will be left on the LRU and may even be mapped into
+ * becomes orphaned.  It will be left on the LRU and may even be mapped into
  * user pagetables if we're racing with filemap_fault().
  *
  * We need to bale out if page->mapping is no longer equal to the original
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
git-acpi.patch
git-kvm.patch

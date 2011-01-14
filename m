From: akpm@linux-foundation.org
Subject: [merged] do_wp_page-clarify-dirty_page-handling.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:45:21 -0800
Message-ID: <201101142248.p0EMmBjD005093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753050Ab1ANWsi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:48:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, david@fromorbit.com, hch@infradead.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mrubin@google.com, npiggin@kernel.dk, peterz@infradead.org, riel@redhat.co


The patch titled
     do_wp_page: clarify dirty_page handling
has been removed from the -mm tree.  Its filename was
     do_wp_page-clarify-dirty_page-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_wp_page: clarify dirty_page handling
From: Michel Lespinasse <walken@google.com>

Reorganize the code so that dirty pages are handled closer to the place
that makes them dirty (handling write fault into shared, writable VMAs). 
No behavior changes.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Theodore Tso <tytso@google.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   72 ++++++++++++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 34 deletions(-)

diff -puN mm/memory.c~do_wp_page-clarify-dirty_page-handling mm/memory.c
--- a/mm/memory.c~do_wp_page-clarify-dirty_page-handling
+++ a/mm/memory.c
@@ -2229,8 +2229,45 @@ reuse:
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 		if (ptep_set_access_flags(vma, address, page_table, entry,1))
 			update_mmu_cache(vma, address, page_table);
+		pte_unmap_unlock(page_table, ptl);
 		ret |= VM_FAULT_WRITE;
-		goto unlock;
+
+		if (!dirty_page)
+			return ret;
+
+		/*
+		 * Yes, Virginia, this is actually required to prevent a race
+		 * with clear_page_dirty_for_io() from clearing the page dirty
+		 * bit after it clear all dirty ptes, but before a racing
+		 * do_wp_page installs a dirty pte.
+		 *
+		 * do_no_page is protected similarly.
+		 */
+		if (!page_mkwrite) {
+			wait_on_page_locked(dirty_page);
+			set_page_dirty_balance(dirty_page, page_mkwrite);
+		}
+		put_page(dirty_page);
+		if (page_mkwrite) {
+			struct address_space *mapping = dirty_page->mapping;
+
+			set_page_dirty(dirty_page);
+			unlock_page(dirty_page);
+			page_cache_release(dirty_page);
+			if (mapping)	{
+				/*
+				 * Some device drivers do not set page.mapping
+				 * but still dirty their pages
+				 */
+				balance_dirty_pages_ratelimited(mapping);
+			}
+		}
+
+		/* file_update_time outside page_lock */
+		if (vma->vm_file)
+			file_update_time(vma->vm_file);
+
+		return ret;
 	}
 
 	/*
@@ -2336,39 +2373,6 @@ gotten:
 		page_cache_release(old_page);
 unlock:
 	pte_unmap_unlock(page_table, ptl);
-	if (dirty_page) {
-		/*
-		 * Yes, Virginia, this is actually required to prevent a race
-		 * with clear_page_dirty_for_io() from clearing the page dirty
-		 * bit after it clear all dirty ptes, but before a racing
-		 * do_wp_page installs a dirty pte.
-		 *
-		 * do_no_page is protected similarly.
-		 */
-		if (!page_mkwrite) {
-			wait_on_page_locked(dirty_page);
-			set_page_dirty_balance(dirty_page, page_mkwrite);
-		}
-		put_page(dirty_page);
-		if (page_mkwrite) {
-			struct address_space *mapping = dirty_page->mapping;
-
-			set_page_dirty(dirty_page);
-			unlock_page(dirty_page);
-			page_cache_release(dirty_page);
-			if (mapping)	{
-				/*
-				 * Some device drivers do not set page.mapping
-				 * but still dirty their pages
-				 */
-				balance_dirty_pages_ratelimited(mapping);
-			}
-		}

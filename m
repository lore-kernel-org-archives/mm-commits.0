From: akpm@linux-foundation.org
Subject: [folded] mm-close-page_mkwrite-races-try-3-update.patch removed from -mm tree
Date: Wed, 29 Apr 2009 08:25:32 -0700
Message-ID: <200904291525.n3TFPWlF005547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754162AbZD2P2X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 11:28:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, sage@newdream.net, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     mm-close-page_mkwrite-races-try-3 update
has been removed from the -mm tree.  Its filename was
     mm-close-page_mkwrite-races-try-3-update.patch

This patch was dropped because it was folded into mm-close-page_mkwrite-races-try-3.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-close-page_mkwrite-races-try-3 update
From: Nick Piggin <npiggin@suse.de>

Here's an incremental patch.

--
On Wed, Apr 15, 2009 at 06:38:47PM -0700, Andrew Morton wrote:
> Whoa.  Running file_update_time() under lock_page() opens a whole can
> of worms, doesn't it?  That thing can do journal commits and all sorts
> of stuff.  And I don't think this ordering is necessary here?

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Sage Weil <sage@newdream.net>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN mm/memory.c~mm-close-page_mkwrite-races-try-3-update mm/memory.c
--- a/mm/memory.c~mm-close-page_mkwrite-races-try-3-update
+++ a/mm/memory.c
@@ -2107,9 +2107,6 @@ gotten:
 unlock:
 	pte_unmap_unlock(page_table, ptl);
 	if (dirty_page) {
-		if (vma->vm_file)
-			file_update_time(vma->vm_file);
-
 		/*
 		 * Yes, Virginia, this is actually required to prevent a race
 		 * with clear_page_dirty_for_io() from clearing the page dirty
@@ -2131,6 +2128,10 @@ unlock:
 			page_cache_release(dirty_page);
 			balance_dirty_pages_ratelimited(mapping);
 		}
+
+		/* file_update_time outside page_lock */
+		if (vma->vm_file)
+			file_update_time(vma->vm_file);
 	}
 	return ret;
 oom_free_new:
@@ -2762,15 +2763,16 @@ out:
 	if (dirty_page) {
 		struct address_space *mapping = page->mapping;
 
-		if (vma->vm_file)
-			file_update_time(vma->vm_file);
-
 		if (set_page_dirty(dirty_page))
 			page_mkwrite = 1;
 		unlock_page(dirty_page);
 		put_page(dirty_page);
 		if (page_mkwrite)
 			balance_dirty_pages_ratelimited(mapping);
+
+		/* file_update_time outside page_lock */
+		if (vma->vm_file)
+			file_update_time(vma->vm_file);
 	} else {
 		unlock_page(vmf.page);
 		if (anon)
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-close-page_mkwrite-races-try-3.patch
mm-close-page_mkwrite-races-try-3-update.patch
mm-close-page_mkwrite-races-try-3-fix.patch
mm-close-page_mkwrite-races-try-3-fix-fix.patch
linux-next.patch
readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch
readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch
readahead-remove-sync-async-readahead-call-dependency.patch
readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead.patch
readahead-sequential-mmap-readahead.patch
readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
mm-clean-up-get_user_pages_fast-documentation.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
atomic-only-take-lock-when-the-counter-drops-to-zero-on-up-as-well.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch


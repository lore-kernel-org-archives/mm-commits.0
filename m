From: akpm@linux-foundation.org
Subject: - mm-improve-find_lock_page.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:31:20 -0700
Message-ID: <200710162031.l9GKVK21014492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39767 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965862AbXJPViB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:38:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: improve find_lock_page
has been removed from the -mm tree.  Its filename was
     mm-improve-find_lock_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: improve find_lock_page
From: Nick Piggin <npiggin@suse.de>

find_lock_page does not need to recheck ->index because if the page is in the
right mapping then the index must be the same.  Also, tree_lock does not need
to be retaken after the page is locked in order to test that ->mapping has not
changed, because holding the page lock pins its mapping.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/filemap.c~mm-improve-find_lock_page mm/filemap.c
--- a/mm/filemap.c~mm-improve-find_lock_page
+++ a/mm/filemap.c
@@ -621,26 +621,27 @@ struct page *find_lock_page(struct addre
 {
 	struct page *page;
 
-	read_lock_irq(&mapping->tree_lock);
 repeat:
+	read_lock_irq(&mapping->tree_lock);
 	page = radix_tree_lookup(&mapping->page_tree, offset);
 	if (page) {
 		page_cache_get(page);
 		if (TestSetPageLocked(page)) {
 			read_unlock_irq(&mapping->tree_lock);
 			__lock_page(page);
-			read_lock_irq(&mapping->tree_lock);
 
 			/* Has the page been truncated while we slept? */
-			if (unlikely(page->mapping != mapping ||
-				     page->index != offset)) {
+			if (unlikely(page->mapping != mapping)) {
 				unlock_page(page);
 				page_cache_release(page);
 				goto repeat;
 			}
+			VM_BUG_ON(page->index != offset);
+			goto out;
 		}
 	}
 	read_unlock_irq(&mapping->tree_lock);
+out:
 	return page;
 }
 EXPORT_SYMBOL(find_lock_page);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-document-tree_lock-zonelock-lockorder.patch
fs-reiserfs-cleanups.patch
atomic_opstxt-has-incorrect-misleading-and-insufficient-information.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
bitops-introduce-lock-ops.patch
alpha-fix-bitops.patch
alpha-lock-bitops.patch
alpha-lock-bitops-fix.patch
ia64-lock-bitops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
powerpc-lock-bitops.patch
powerpc-lock-bitops-fix.patch
bit_spin_lock-use-lock-bitops.patch
reiser4-fix-for-new-aops-patches.patch

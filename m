From: akpm@linux-foundation.org
Subject: [merged] mm-fix-invalidate_complete_page2-lock-ordering.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:13:33 -0700
Message-ID: <20121009181334.56D995C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:55475 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab2JISNh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:13:37 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so365319wey.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:13:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, akpm@linux-foundation.org, hannes@cmpxchg.org, levinsasha928@gmail.com, mel@csn.ul.ie, riel@redhat.com, stable@vger.kernel.org, walken@google.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix invalidate_complete_page2() lock ordering
has been removed from the -mm tree.  Its filename was
     mm-fix-invalidate_complete_page2-lock-ordering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: fix invalidate_complete_page2() lock ordering

In fuzzing with trinity, lockdep protested "possible irq lock inversion
dependency detected" when isolate_lru_page() reenabled interrupts while
still holding the supposedly irq-safe tree_lock:

invalidate_inode_pages2
  invalidate_complete_page2
    spin_lock_irq(&mapping->tree_lock)
    clear_page_mlock
      isolate_lru_page
        spin_unlock_irq(&zone->lru_lock)

isolate_lru_page() is correct to enable interrupts unconditionally:
invalidate_complete_page2() is incorrect to call clear_page_mlock() while
holding tree_lock, which is supposed to nest inside lru_lock.

Both truncate_complete_page() and invalidate_complete_page() call
clear_page_mlock() before taking tree_lock to remove page from radix_tree.
 I guess invalidate_complete_page2() preferred to test PageDirty (again)
under tree_lock before committing to the munlock; but since the page has
already been unmapped, its state is already somewhat inconsistent, and no
worse if clear_page_mlock() moved up.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Deciphered-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ying Han <yinghan@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/truncate.c~mm-fix-invalidate_complete_page2-lock-ordering mm/truncate.c
--- a/mm/truncate.c~mm-fix-invalidate_complete_page2-lock-ordering
+++ a/mm/truncate.c
@@ -394,11 +394,12 @@ invalidate_complete_page2(struct address
 	if (page_has_private(page) && !try_to_release_page(page, GFP_KERNEL))
 		return 0;
 
+	clear_page_mlock(page);
+
 	spin_lock_irq(&mapping->tree_lock);
 	if (PageDirty(page))
 		goto failed;
 
-	clear_page_mlock(page);
 	BUG_ON(page_has_private(page));
 	__delete_from_page_cache(page);
 	spin_unlock_irq(&mapping->tree_lock);
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch


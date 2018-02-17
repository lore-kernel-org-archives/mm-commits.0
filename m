From: akpm@linux-foundation.org
Subject: +
 mm-huge_memoryc-reorder-operations-in-__split_huge_page_tail.patch added to -mm tree
Date: Fri, 16 Feb 2018 16:19:55 -0800
Message-ID: <5a87752b.E7UhwaSDAplf8BKu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44402 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbeBQAT4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 19:19:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, kirill.shutemov@linux.intel.com, mhocko@suse.com, npiggin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory.c: reorder operations in __split_huge_page_tail()
has been added to the -mm tree.  Its filename is
     mm-huge_memoryc-reorder-operations-in-__split_huge_page_tail.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memoryc-reorder-operations-in-__split_huge_page_tail.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memoryc-reorder-operations-in-__split_huge_page_tail.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: mm/huge_memory.c: reorder operations in __split_huge_page_tail()

THP split makes non-atomic change of tail page flags.  This is almost ok
because tail pages are locked and isolated but this breaks recent changes
in page locking: non-atomic operation could clear bit PG_waiters.

As a result concurrent sequence get_page_unless_zero() -> lock_page()
might block forever.  Especially if this page was truncated later.

Fix is trivial: clone flags before unfreezing page reference counter.

This race exists since commit 62906027091f ("mm: add PageWaiters
indicating tasks are waiting for a page bit") while unsave unfreeze itself
was added in commit 8df651c7059e ("thp: cleanup split_huge_page()").

clear_compound_head() also must be called before unfreezing page reference
because after successful get_page_unless_zero() might follow put_page()
which needs correct compound_head().

And replace page_ref_inc()/page_ref_add() with page_ref_unfreeze() which
is made especially for that and has semantic of smp_store_release().

Link: http://lkml.kernel.org/r/151844393341.210639.13162088407980624477.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff -puN mm/huge_memory.c~mm-huge_memoryc-reorder-operations-in-__split_huge_page_tail mm/huge_memory.c
--- a/mm/huge_memory.c~mm-huge_memoryc-reorder-operations-in-__split_huge_page_tail
+++ a/mm/huge_memory.c
@@ -2355,26 +2355,13 @@ static void __split_huge_page_tail(struc
 	struct page *page_tail = head + tail;
 
 	VM_BUG_ON_PAGE(atomic_read(&page_tail->_mapcount) != -1, page_tail);
-	VM_BUG_ON_PAGE(page_ref_count(page_tail) != 0, page_tail);
 
 	/*
-	 * tail_page->_refcount is zero and not changing from under us. But
-	 * get_page_unless_zero() may be running from under us on the
-	 * tail_page. If we used atomic_set() below instead of atomic_inc() or
-	 * atomic_add(), we would then run atomic_set() concurrently with
-	 * get_page_unless_zero(), and atomic_set() is implemented in C not
-	 * using locked ops. spin_unlock on x86 sometime uses locked ops
-	 * because of PPro errata 66, 92, so unless somebody can guarantee
-	 * atomic_set() here would be safe on all archs (and not only on x86),
-	 * it's safer to use atomic_inc()/atomic_add().
+	 * Clone page flags before unfreezing refcount.
+	 *
+	 * After successful get_page_unless_zero() might follow flags change,
+	 * for exmaple lock_page() which set PG_waiters.
 	 */
-	if (PageAnon(head) && !PageSwapCache(head)) {
-		page_ref_inc(page_tail);
-	} else {
-		/* Additional pin to radix tree */
-		page_ref_add(page_tail, 2);
-	}
-
 	page_tail->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	page_tail->flags |= (head->flags &
 			((1L << PG_referenced) |
@@ -2387,14 +2374,21 @@ static void __split_huge_page_tail(struc
 			 (1L << PG_unevictable) |
 			 (1L << PG_dirty)));
 
-	/*
-	 * After clearing PageTail the gup refcount can be released.
-	 * Page flags also must be visible before we make the page non-compound.
-	 */
+	/* Page flags must be visible before we make the page non-compound. */
 	smp_wmb();
 
+	/*
+	 * Clear PageTail before unfreezing page refcount.
+	 *
+	 * After successful get_page_unless_zero() might follow put_page()
+	 * which needs correct compound_head().
+	 */
 	clear_compound_head(page_tail);
 
+	/* Finally unfreeze refcount. Additional reference from page cache. */
+	page_ref_unfreeze(page_tail, 1 + (!PageAnon(head) ||
+					  PageSwapCache(head)));
+
 	if (page_is_young(head))
 		set_page_young(page_tail);
 	if (page_is_idle(head))
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

mm-page_ref-use-atomic_set_release-in-page_ref_unfreeze.patch
mm-huge_memoryc-reorder-operations-in-__split_huge_page_tail.patch


From: akpm@linux-foundation.org
Subject: [merged] mm-munlock-use-mapcount-to-avoid-terrible-overhead.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:12:27 -0700
Message-ID: <201111012112.pA1LCRsD018877@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16028 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab1KAVMa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:12:30 -0400
Received: from wpaz29.hot.corp.google.com (wpaz29.hot.corp.google.com [172.24.198.93])
	by smtp-out.google.com with ESMTP id pA1LCSZ1027242
	for <mm-commits@vger.kernel.org>; Tue, 1 Nov 2011 14:12:29 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: munlock use mapcount to avoid terrible overhead
has been removed from the -mm tree.  Its filename was
     mm-munlock-use-mapcount-to-avoid-terrible-overhead.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: munlock use mapcount to avoid terrible overhead

A process spent 30 minutes exiting, just munlocking the pages of a large
anonymous area that had been alternately mprotected into page-sized vmas:
for every single page there's an anon_vma walk through all the other
little vmas to find the right one.

A general fix to that would be a lot more complicated (use prio_tree on
anon_vma?), but there's one very simple thing we can do to speed up the
common case: if a page to be munlocked is mapped only once, then it is our
vma that it is mapped into, and there's no need whatever to walk through
all the others.

Okay, there is a very remote race in munlock_vma_pages_range(), if between
its follow_page() and lock_page(), another process were to munlock the
same page, then page reclaim remove it from our vma, then another process
mlock it again.  We would find it with page_mapcount 1, yet it's still
mlocked in another process.  But never mind, that's much less likely than
the down_read_trylock() failure which munlocking already tolerates (in
try_to_unmap_one()): in due course page reclaim will discover and move the
page to unevictable instead.

[akpm@linux-foundation.org: add comment]
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/mlock.c~mm-munlock-use-mapcount-to-avoid-terrible-overhead mm/mlock.c
--- a/mm/mlock.c~mm-munlock-use-mapcount-to-avoid-terrible-overhead
+++ a/mm/mlock.c
@@ -110,7 +110,15 @@ void munlock_vma_page(struct page *page)
 	if (TestClearPageMlocked(page)) {
 		dec_zone_page_state(page, NR_MLOCK);
 		if (!isolate_lru_page(page)) {
-			int ret = try_to_munlock(page);
+			int ret = SWAP_AGAIN;
+
+			/*
+			 * Optimization: if the page was mapped just once,
+			 * that's our mapping and we don't need to check all the
+			 * other vmas.
+			 */
+			if (page_mapcount(page) > 1)
+				ret = try_to_munlock(page);
 			/*
 			 * did try_to_unlock() succeed or punt?
 			 */
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
drm-avoid-switching-to-text-console-if-there-is-no-panic-timeout.patch
thp-tail-page-refcounting-fix-5.patch
powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast.patch
powerpc-get_hugepte-dont-put_page-the-wrong-page.patch
powerpc-gup_hugepte-avoid-to-free-the-head-page-too-many-times.patch
powerpc-gup_hugepte-support-thp-based-tail-recounting.patch
powerpc-gup_huge_pmd-return-0-if-pte-changes.patch
s390-gup_huge_pmd-support-thp-tail-recounting.patch
s390-gup_huge_pmd-return-0-if-pte-changes.patch
sparc-gup_pte_range-support-thp-based-tail-recounting.patch
thp-share-get_huge_page_tail.patch
prio_tree-debugging-patch.patch


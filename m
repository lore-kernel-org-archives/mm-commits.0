From: akpm@linux-foundation.org
Subject: [merged]
 rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:38:03 -0700
Message-ID: <5591acab.DOjpxr/IAcEAv6AN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbbF2UiF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:38:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hughd@google.com, kirill.shutemov@linux.intel.com, minchan@kernel.org, paulmck@linux.vnet.ibm.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rmap: fix theoretical race between do_wp_page and shrink_active_list
has been removed from the -mm tree.  Its filename was
     rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: rmap: fix theoretical race between do_wp_page and shrink_active_list

As noted by Paul the compiler is free to store a temporary result in a
variable on stack, heap or global unless it is explicitly marked as
volatile, see:

  http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2015/n4455.html#sample-optimizations

This can result in a race between do_wp_page() and shrink_active_list() as
follows.

In do_wp_page() we can call page_move_anon_rmap(), which sets
page->mapping as follows:

  anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
  page->mapping = (struct address_space *) anon_vma;

The page in question may be on an LRU list, because nowhere in
do_wp_page() we remove it from the list, neither do we take any LRU
related locks.  Although the page is locked, shrink_active_list() can
still call page_referenced() on it concurrently, because the latter does
not require an anonymous page to be locked:

  CPU0                          CPU1
  ----                          ----
  do_wp_page                    shrink_active_list
   lock_page                     page_referenced
                                  PageAnon->yes, so skip trylock_page
   page_move_anon_rmap
    page->mapping = anon_vma
                                  rmap_walk
                                   PageAnon->no
                                   rmap_walk_file
                                    BUG
    page->mapping += PAGE_MAPPING_ANON

This patch fixes this race by explicitly forbidding the compiler to split
page->mapping store in page_move_anon_rmap() with the aid of WRITE_ONCE.

[akpm@linux-foundation.org: tweak comment, per Minchan]
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/rmap.c~rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list mm/rmap.c
--- a/mm/rmap.c~rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list
+++ a/mm/rmap.c
@@ -950,7 +950,12 @@ void page_move_anon_rmap(struct page *pa
 	VM_BUG_ON_PAGE(page->index != linear_page_index(vma, address), page);
 
 	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
-	page->mapping = (struct address_space *) anon_vma;
+	/*
+	 * Ensure that anon_vma and the PAGE_MAPPING_ANON bit are written
+	 * simultaneously, so a concurrent reader (eg page_referenced()'s
+	 * PageAnon()) will not see one without the other.
+	 */
+	WRITE_ONCE(page->mapping, (struct address_space *) anon_vma);
 }
 
 /**
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch


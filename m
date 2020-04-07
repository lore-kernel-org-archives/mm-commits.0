From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 074/166] mm: huge tmpfs: try to split_huge_page()
 when punching hole
Date: Mon, 06 Apr 2020 20:07:57 -0700
Message-ID: <20200407030757.9GtKiVpqL%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDH7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:07:59 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, alexander.duyck@gmail.com, david@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, mst@redhat.com, torvalds@linux-foundation.org, willy@infradead.org, yang.shi@linux.alibaba.com

From: Hugh Dickins <hughd@google.com>
Subject: mm: huge tmpfs: try to split_huge_page() when punching hole

Yang Shi writes:

Currently, when truncating a shmem file, if the range is partly in a THP
(start or end is in the middle of THP), the pages actually will just get
cleared rather than being freed, unless the range covers the whole THP. 
Even though all the subpages are truncated (randomly or sequentially), the
THP may still be kept in page cache.

This might be fine for some usecases which prefer preserving THP, but
balloon inflation is handled in base page size.  So when using shmem THP
as memory backend, QEMU inflation actually doesn't work as expected since
it doesn't free memory.  But the inflation usecase really needs to get the
memory freed.  (Anonymous THP will also not get freed right away, but will
be freed eventually when all subpages are unmapped: whereas shmem THP
still stays in page cache.)

Split THP right away when doing partial hole punch, and if split fails
just clear the page so that read of the punched area will return zeroes.

Hugh Dickins adds:

Our earlier "team of pages" huge tmpfs implementation worked in the way
that Yang Shi proposes; and we have been using this patch to continue to
split the huge page when hole-punched or truncated, since converting over
to the compound page implementation.  Although huge tmpfs gives out huge
pages when available, if the user specifically asks to truncate or punch a
hole (perhaps to free memory, perhaps to reduce the memcg charge), then
the filesystem should do so as best it can, splitting the huge page.

That is not always possible: any additional reference to the huge page
prevents split_huge_page() from succeeding, so the result can be flaky. 
But in practice it works successfully enough that we've not seen any
problem from that.

Add shmem_punch_compound() to encapsulate the decision of when a split is
needed, and doing the split if so.  Using this simplifies the flow in
shmem_undo_range(); and the first (trylock) pass does not need to do any
page clearing on failure, because the second pass will either succeed or
do that clearing.  Following the example of zero_user_segment() when
clearing a partial page, add flush_dcache_page() and set_page_dirty() when
clearing a hole - though I'm not certain that either is needed.

But: split_huge_page() would be sure to fail if shmem_undo_range()'s
pagevec holds further references to the huge page.  The easiest way to fix
that is for find_get_entries() to return early, as soon as it has put one
compound head or tail into the pagevec.  At first this felt like a hack;
but on examination, this convention better suits all its callers - or will
do, if the slight one-page-per-pagevec slowdown in shmem_unlock_mapping()
and shmem_seek_hole_data() is transformed into a 512-page-per-pagevec
speedup by checking for compound pages there.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2002261959020.10801@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   14 ++++++-
 mm/shmem.c   |   98 +++++++++++++++++++++----------------------------
 mm/swap.c    |    4 ++
 3 files changed, 60 insertions(+), 56 deletions(-)

--- a/mm/filemap.c~huge-tmpfs-try-to-split_huge_page-when-punching-hole
+++ a/mm/filemap.c
@@ -1693,6 +1693,11 @@ EXPORT_SYMBOL(pagecache_get_page);
  * Any shadow entries of evicted pages, or swap entries from
  * shmem/tmpfs, are included in the returned array.
  *
+ * If it finds a Transparent Huge Page, head or tail, find_get_entries()
+ * stops at that page: the caller is likely to have a better way to handle
+ * the compound page as a whole, and then skip its extent, than repeatedly
+ * calling find_get_entries() to return all its tails.
+ *
  * Return: the number of pages and shadow entries which were found.
  */
 unsigned find_get_entries(struct address_space *mapping,
@@ -1724,8 +1729,15 @@ unsigned find_get_entries(struct address
 		/* Has the page moved or been split? */
 		if (unlikely(page != xas_reload(&xas)))
 			goto put_page;
-		page = find_subpage(page, xas.xa_index);
 
+		/*
+		 * Terminate early on finding a THP, to allow the caller to
+		 * handle it all at once; but continue if this is hugetlbfs.
+		 */
+		if (PageTransHuge(page) && !PageHuge(page)) {
+			page = find_subpage(page, xas.xa_index);
+			nr_entries = ret + 1;
+		}
 export:
 		indices[ret] = xas.xa_index;
 		entries[ret] = page;
--- a/mm/shmem.c~huge-tmpfs-try-to-split_huge_page-when-punching-hole
+++ a/mm/shmem.c
@@ -789,6 +789,32 @@ void shmem_unlock_mapping(struct address
 }
 
 /*
+ * Check whether a hole-punch or truncation needs to split a huge page,
+ * returning true if no split was required, or the split has been successful.
+ *
+ * Eviction (or truncation to 0 size) should never need to split a huge page;
+ * but in rare cases might do so, if shmem_undo_range() failed to trylock on
+ * head, and then succeeded to trylock on tail.
+ *
+ * A split can only succeed when there are no additional references on the
+ * huge page: so the split below relies upon find_get_entries() having stopped
+ * when it found a subpage of the huge page, without getting further references.
+ */
+static bool shmem_punch_compound(struct page *page, pgoff_t start, pgoff_t end)
+{
+	if (!PageTransCompound(page))
+		return true;
+
+	/* Just proceed to delete a huge page wholly within the range punched */
+	if (PageHead(page) &&
+	    page->index >= start && page->index + HPAGE_PMD_NR <= end)
+		return true;
+
+	/* Try to split huge page, so we can truly punch the hole or truncate */
+	return split_huge_page(page) >= 0;
+}
+
+/*
  * Remove range of pages and swap entries from page cache, and free them.
  * If !unfalloc, truncate or punch hole; if unfalloc, undo failed fallocate.
  */
@@ -838,31 +864,11 @@ static void shmem_undo_range(struct inod
 			if (!trylock_page(page))
 				continue;
 
-			if (PageTransTail(page)) {
-				/* Middle of THP: zero out the page */
-				clear_highpage(page);
-				unlock_page(page);
-				continue;
-			} else if (PageTransHuge(page)) {
-				if (index == round_down(end, HPAGE_PMD_NR)) {
-					/*
-					 * Range ends in the middle of THP:
-					 * zero out the page
-					 */
-					clear_highpage(page);
-					unlock_page(page);
-					continue;
-				}
-				index += HPAGE_PMD_NR - 1;
-				i += HPAGE_PMD_NR - 1;
-			}
-
-			if (!unfalloc || !PageUptodate(page)) {
-				VM_BUG_ON_PAGE(PageTail(page), page);
-				if (page_mapping(page) == mapping) {
-					VM_BUG_ON_PAGE(PageWriteback(page), page);
+			if ((!unfalloc || !PageUptodate(page)) &&
+			    page_mapping(page) == mapping) {
+				VM_BUG_ON_PAGE(PageWriteback(page), page);
+				if (shmem_punch_compound(page, start, end))
 					truncate_inode_page(mapping, page);
-				}
 			}
 			unlock_page(page);
 		}
@@ -936,43 +942,25 @@ static void shmem_undo_range(struct inod
 
 			lock_page(page);
 
-			if (PageTransTail(page)) {
-				/* Middle of THP: zero out the page */
-				clear_highpage(page);
-				unlock_page(page);
-				/*
-				 * Partial thp truncate due 'start' in middle
-				 * of THP: don't need to look on these pages
-				 * again on !pvec.nr restart.
-				 */
-				if (index != round_down(end, HPAGE_PMD_NR))
-					start++;
-				continue;
-			} else if (PageTransHuge(page)) {
-				if (index == round_down(end, HPAGE_PMD_NR)) {
-					/*
-					 * Range ends in the middle of THP:
-					 * zero out the page
-					 */
-					clear_highpage(page);
-					unlock_page(page);
-					continue;
-				}
-				index += HPAGE_PMD_NR - 1;
-				i += HPAGE_PMD_NR - 1;
-			}
-
 			if (!unfalloc || !PageUptodate(page)) {
-				VM_BUG_ON_PAGE(PageTail(page), page);
-				if (page_mapping(page) == mapping) {
-					VM_BUG_ON_PAGE(PageWriteback(page), page);
-					truncate_inode_page(mapping, page);
-				} else {
+				if (page_mapping(page) != mapping) {
 					/* Page was replaced by swap: retry */
 					unlock_page(page);
 					index--;
 					break;
 				}
+				VM_BUG_ON_PAGE(PageWriteback(page), page);
+				if (shmem_punch_compound(page, start, end))
+					truncate_inode_page(mapping, page);
+				else {
+					/* Wipe the page and don't get stuck */
+					clear_highpage(page);
+					flush_dcache_page(page);
+					set_page_dirty(page);
+					if (index <
+					    round_up(start, HPAGE_PMD_NR))
+						start = index + 1;
+				}
 			}
 			unlock_page(page);
 		}
--- a/mm/swap.c~huge-tmpfs-try-to-split_huge_page-when-punching-hole
+++ a/mm/swap.c
@@ -1004,6 +1004,10 @@ void __pagevec_lru_add(struct pagevec *p
  * ascending indexes.  There may be holes in the indices due to
  * not-present entries.
  *
+ * Only one subpage of a Transparent Huge Page is returned in one call:
+ * allowing truncate_inode_pages_range() to evict the whole THP without
+ * cycling through a pagevec of extra references.
+ *
  * pagevec_lookup_entries() returns the number of entries which were
  * found.
  */
_

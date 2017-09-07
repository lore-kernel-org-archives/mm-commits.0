From: akpm@linux-foundation.org
Subject: [merged] mm-implement-find_get_pages_range.patch removed
 from -mm tree
Date: Thu, 07 Sep 2017 11:38:52 -0700
Message-ID: <20170907183852.mhw54GOnB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55834 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755705AbdIGSix (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:38:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: implement find_get_pages_range()
has been removed from the -mm tree.  Its filename was
     mm-implement-find_get_pages_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: implement find_get_pages_range()

Implement a variant of find_get_pages() that stops iterating at given
index.  This may be substantial performance gain if the mapping is sparse.
See following commit for details.  Furthermore lots of users of this
function (through pagevec_lookup()) actually want a range lookup and all
of them are currently open-coding this.

Also create corresponding pagevec_lookup_range() function.

Link: http://lkml.kernel.org/r/20170726114704.7626-4-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   12 +++++++++-
 include/linux/pagevec.h |   13 +++++++++--
 mm/filemap.c            |   42 +++++++++++++++++++++++++++-----------
 mm/swap.c               |   22 ++++++++++++-------
 4 files changed, 65 insertions(+), 24 deletions(-)

diff -puN include/linux/pagemap.h~mm-implement-find_get_pages_range include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-implement-find_get_pages_range
+++ a/include/linux/pagemap.h
@@ -353,8 +353,16 @@ struct page *find_lock_entry(struct addr
 unsigned find_get_entries(struct address_space *mapping, pgoff_t start,
 			  unsigned int nr_entries, struct page **entries,
 			  pgoff_t *indices);
-unsigned find_get_pages(struct address_space *mapping, pgoff_t *start,
-			unsigned int nr_pages, struct page **pages);
+unsigned find_get_pages_range(struct address_space *mapping, pgoff_t *start,
+			pgoff_t end, unsigned int nr_pages,
+			struct page **pages);
+static inline unsigned find_get_pages(struct address_space *mapping,
+			pgoff_t *start, unsigned int nr_pages,
+			struct page **pages)
+{
+	return find_get_pages_range(mapping, start, (pgoff_t)-1, nr_pages,
+				    pages);
+}
 unsigned find_get_pages_contig(struct address_space *mapping, pgoff_t start,
 			       unsigned int nr_pages, struct page **pages);
 unsigned find_get_pages_tag(struct address_space *mapping, pgoff_t *index,
diff -puN include/linux/pagevec.h~mm-implement-find_get_pages_range include/linux/pagevec.h
--- a/include/linux/pagevec.h~mm-implement-find_get_pages_range
+++ a/include/linux/pagevec.h
@@ -27,8 +27,17 @@ unsigned pagevec_lookup_entries(struct p
 				pgoff_t start, unsigned nr_entries,
 				pgoff_t *indices);
 void pagevec_remove_exceptionals(struct pagevec *pvec);
-unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
-		pgoff_t *start, unsigned nr_pages);
+unsigned pagevec_lookup_range(struct pagevec *pvec,
+			      struct address_space *mapping,
+			      pgoff_t *start, pgoff_t end, unsigned nr_pages);
+static inline unsigned pagevec_lookup(struct pagevec *pvec,
+				      struct address_space *mapping,
+				      pgoff_t *start, unsigned nr_pages)
+{
+	return pagevec_lookup_range(pvec, mapping, start, (pgoff_t)-1,
+				    nr_pages);
+}
+
 unsigned pagevec_lookup_tag(struct pagevec *pvec,
 		struct address_space *mapping, pgoff_t *index, int tag,
 		unsigned nr_pages);
diff -puN mm/filemap.c~mm-implement-find_get_pages_range mm/filemap.c
--- a/mm/filemap.c~mm-implement-find_get_pages_range
+++ a/mm/filemap.c
@@ -1557,24 +1557,29 @@ export:
 }
 
 /**
- * find_get_pages - gang pagecache lookup
+ * find_get_pages_range - gang pagecache lookup
  * @mapping:	The address_space to search
  * @start:	The starting page index
+ * @end:	The final page index (inclusive)
  * @nr_pages:	The maximum number of pages
  * @pages:	Where the resulting pages are placed
  *
- * find_get_pages() will search for and return a group of up to
- * @nr_pages pages in the mapping.  The pages are placed at @pages.
- * find_get_pages() takes a reference against the returned pages.
+ * find_get_pages_range() will search for and return a group of up to @nr_pages
+ * pages in the mapping starting at index @start and up to index @end
+ * (inclusive).  The pages are placed at @pages.  find_get_pages_range() takes
+ * a reference against the returned pages.
  *
  * The search returns a group of mapping-contiguous pages with ascending
  * indexes.  There may be holes in the indices due to not-present pages.
  * We also update @start to index the next page for the traversal.
  *
- * find_get_pages() returns the number of pages which were found.
+ * find_get_pages_range() returns the number of pages which were found. If this
+ * number is smaller than @nr_pages, the end of specified range has been
+ * reached.
  */
-unsigned find_get_pages(struct address_space *mapping, pgoff_t *start,
-			    unsigned int nr_pages, struct page **pages)
+unsigned find_get_pages_range(struct address_space *mapping, pgoff_t *start,
+			      pgoff_t end, unsigned int nr_pages,
+			      struct page **pages)
 {
 	struct radix_tree_iter iter;
 	void **slot;
@@ -1586,6 +1591,9 @@ unsigned find_get_pages(struct address_s
 	rcu_read_lock();
 	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, *start) {
 		struct page *head, *page;
+
+		if (iter.index > end)
+			break;
 repeat:
 		page = radix_tree_deref_slot(slot);
 		if (unlikely(!page))
@@ -1621,15 +1629,25 @@ repeat:
 		}
 
 		pages[ret] = page;
-		if (++ret == nr_pages)
-			break;
+		if (++ret == nr_pages) {
+			*start = pages[ret - 1]->index + 1;
+			goto out;
+		}
 	}
 
+	/*
+	 * We come here when there is no page beyond @end. We take care to not
+	 * overflow the index @start as it confuses some of the callers. This
+	 * breaks the iteration when there is page at index -1 but that is
+	 * already broken anyway.
+	 */
+	if (end == (pgoff_t)-1)
+		*start = (pgoff_t)-1;
+	else
+		*start = end + 1;
+out:
 	rcu_read_unlock();
 
-	if (ret)
-		*start = pages[ret - 1]->index + 1;
-
 	return ret;
 }
 
diff -puN mm/swap.c~mm-implement-find_get_pages_range mm/swap.c
--- a/mm/swap.c~mm-implement-find_get_pages_range
+++ a/mm/swap.c
@@ -946,29 +946,35 @@ void pagevec_remove_exceptionals(struct
 }
 
 /**
- * pagevec_lookup - gang pagecache lookup
+ * pagevec_lookup_range - gang pagecache lookup
  * @pvec:	Where the resulting pages are placed
  * @mapping:	The address_space to search
  * @start:	The starting page index
+ * @end:	The final page index
  * @nr_pages:	The maximum number of pages
  *
- * pagevec_lookup() will search for and return a group of up to @nr_pages pages
- * in the mapping.  The pages are placed in @pvec.  pagevec_lookup() takes a
+ * pagevec_lookup_range() will search for and return a group of up to @nr_pages
+ * pages in the mapping starting from index @start and upto index @end
+ * (inclusive).  The pages are placed in @pvec.  pagevec_lookup() takes a
  * reference against the pages in @pvec.
  *
  * The search returns a group of mapping-contiguous pages with ascending
  * indexes.  There may be holes in the indices due to not-present pages. We
  * also update @start to index the next page for the traversal.
  *
- * pagevec_lookup() returns the number of pages which were found.
+ * pagevec_lookup_range() returns the number of pages which were found. If this
+ * number is smaller than @nr_pages, the end of specified range has been
+ * reached.
  */
-unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
-		pgoff_t *start, unsigned nr_pages)
+unsigned pagevec_lookup_range(struct pagevec *pvec,
+		struct address_space *mapping, pgoff_t *start, pgoff_t end,
+		unsigned nr_pages)
 {
-	pvec->nr = find_get_pages(mapping, start, nr_pages, pvec->pages);
+	pvec->nr = find_get_pages_range(mapping, start, end, nr_pages,
+					pvec->pages);
 	return pagevec_count(pvec);
 }
-EXPORT_SYMBOL(pagevec_lookup);
+EXPORT_SYMBOL(pagevec_lookup_range);
 
 unsigned pagevec_lookup_tag(struct pagevec *pvec, struct address_space *mapping,
 		pgoff_t *index, int tag, unsigned nr_pages)
_

Patches currently in -mm which might be from jack@suse.cz are



From: akpm@linux-foundation.org
Subject: [patch 054/131] mm: implement find_get_pages_range_tag()
Date: Wed, 15 Nov 2017 17:34:33 -0800
Message-ID: <20171116013433.aGg8Tu1qZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39180 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932972AbdKPBef (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:34:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.m.jordan@oracle.com, dhowells@redhat.com, dsterba@suse.com, idryomov@gmail.com, jack@suse.cz, jaegeuk@kernel.org, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org, rpeterso@redhat.com, sfrench@samba.org, torvalds@linux-foundation.org, tytso@mit.edu, yuchao0@huawei.com, zyan@redhat.com

From: Jan Kara <jack@suse.cz>
Subject: mm: implement find_get_pages_range_tag()

Patch series "Ranged pagevec tagged lookup", v3.

In this series I provide a ranged variant of pagevec_lookup_tag() and use
it in places where it makes sense.  This series removes some common code
and it also has a potential for speeding up some operations similarly as
for pagevec_lookup_range() (but for now I can think of only artificial
cases where this happens).


This patch (of 16):

Implement a variant of find_get_pages_tag() that stops iterating at given
index.  Lots of users of this function (through pagevec_lookup()) actually
want a range lookup and all of them are currently open-coding this.

Also create corresponding pagevec_lookup_range_tag() function.

Link: http://lkml.kernel.org/r/20171009151359.31984-2-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Bob Peterson <rpeterso@redhat.com>
Cc: Chao Yu <yuchao0@huawei.com>
Cc: David Howells <dhowells@redhat.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Steve French <sfrench@samba.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   12 ++++++++++--
 include/linux/pagevec.h |   11 +++++++++--
 mm/filemap.c            |   33 ++++++++++++++++++++++++---------
 mm/swap.c               |    9 +++++----
 4 files changed, 48 insertions(+), 17 deletions(-)

diff -puN include/linux/pagemap.h~mm-implement-find_get_pages_range_tag include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-implement-find_get_pages_range_tag
+++ a/include/linux/pagemap.h
@@ -366,8 +366,16 @@ static inline unsigned find_get_pages(st
 }
 unsigned find_get_pages_contig(struct address_space *mapping, pgoff_t start,
 			       unsigned int nr_pages, struct page **pages);
-unsigned find_get_pages_tag(struct address_space *mapping, pgoff_t *index,
-			int tag, unsigned int nr_pages, struct page **pages);
+unsigned find_get_pages_range_tag(struct address_space *mapping, pgoff_t *index,
+			pgoff_t end, int tag, unsigned int nr_pages,
+			struct page **pages);
+static inline unsigned find_get_pages_tag(struct address_space *mapping,
+			pgoff_t *index, int tag, unsigned int nr_pages,
+			struct page **pages)
+{
+	return find_get_pages_range_tag(mapping, index, (pgoff_t)-1, tag,
+					nr_pages, pages);
+}
 unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t start,
 			int tag, unsigned int nr_entries,
 			struct page **entries, pgoff_t *indices);
diff -puN include/linux/pagevec.h~mm-implement-find_get_pages_range_tag include/linux/pagevec.h
--- a/include/linux/pagevec.h~mm-implement-find_get_pages_range_tag
+++ a/include/linux/pagevec.h
@@ -38,9 +38,16 @@ static inline unsigned pagevec_lookup(st
 	return pagevec_lookup_range(pvec, mapping, start, (pgoff_t)-1);
 }
 
-unsigned pagevec_lookup_tag(struct pagevec *pvec,
+unsigned pagevec_lookup_range_tag(struct pagevec *pvec,
+		struct address_space *mapping, pgoff_t *index, pgoff_t end,
+		int tag, unsigned nr_pages);
+static inline unsigned pagevec_lookup_tag(struct pagevec *pvec,
 		struct address_space *mapping, pgoff_t *index, int tag,
-		unsigned nr_pages);
+		unsigned nr_pages)
+{
+	return pagevec_lookup_range_tag(pvec, mapping, index, (pgoff_t)-1, tag,
+					nr_pages);
+}
 
 static inline void pagevec_init(struct pagevec *pvec, int cold)
 {
diff -puN mm/filemap.c~mm-implement-find_get_pages_range_tag mm/filemap.c
--- a/mm/filemap.c~mm-implement-find_get_pages_range_tag
+++ a/mm/filemap.c
@@ -1754,9 +1754,10 @@ repeat:
 EXPORT_SYMBOL(find_get_pages_contig);
 
 /**
- * find_get_pages_tag - find and return pages that match @tag
+ * find_get_pages_range_tag - find and return pages in given range matching @tag
  * @mapping:	the address_space to search
  * @index:	the starting page index
+ * @end:	The final page index (inclusive)
  * @tag:	the tag index
  * @nr_pages:	the maximum number of pages
  * @pages:	where the resulting pages are placed
@@ -1764,8 +1765,9 @@ EXPORT_SYMBOL(find_get_pages_contig);
  * Like find_get_pages, except we only return pages which are tagged with
  * @tag.   We update @index to index the next page for the traversal.
  */
-unsigned find_get_pages_tag(struct address_space *mapping, pgoff_t *index,
-			int tag, unsigned int nr_pages, struct page **pages)
+unsigned find_get_pages_range_tag(struct address_space *mapping, pgoff_t *index,
+			pgoff_t end, int tag, unsigned int nr_pages,
+			struct page **pages)
 {
 	struct radix_tree_iter iter;
 	void **slot;
@@ -1778,6 +1780,9 @@ unsigned find_get_pages_tag(struct addre
 	radix_tree_for_each_tagged(slot, &mapping->page_tree,
 				   &iter, *index, tag) {
 		struct page *head, *page;
+
+		if (iter.index > end)
+			break;
 repeat:
 		page = radix_tree_deref_slot(slot);
 		if (unlikely(!page))
@@ -1819,18 +1824,28 @@ repeat:
 		}
 
 		pages[ret] = page;
-		if (++ret == nr_pages)
-			break;
+		if (++ret == nr_pages) {
+			*index = pages[ret - 1]->index + 1;
+			goto out;
+		}
 	}
 
+	/*
+	 * We come here when we got at @end. We take care to not overflow the
+	 * index @index as it confuses some of the callers. This breaks the
+	 * iteration when there is page at index -1 but that is already broken
+	 * anyway.
+	 */
+	if (end == (pgoff_t)-1)
+		*index = (pgoff_t)-1;
+	else
+		*index = end + 1;
+out:
 	rcu_read_unlock();
 
-	if (ret)
-		*index = pages[ret - 1]->index + 1;
-
 	return ret;
 }
-EXPORT_SYMBOL(find_get_pages_tag);
+EXPORT_SYMBOL(find_get_pages_range_tag);
 
 /**
  * find_get_entries_tag - find and return entries that match @tag
diff -puN mm/swap.c~mm-implement-find_get_pages_range_tag mm/swap.c
--- a/mm/swap.c~mm-implement-find_get_pages_range_tag
+++ a/mm/swap.c
@@ -986,14 +986,15 @@ unsigned pagevec_lookup_range(struct pag
 }
 EXPORT_SYMBOL(pagevec_lookup_range);
 
-unsigned pagevec_lookup_tag(struct pagevec *pvec, struct address_space *mapping,
-		pgoff_t *index, int tag, unsigned nr_pages)
+unsigned pagevec_lookup_range_tag(struct pagevec *pvec,
+		struct address_space *mapping, pgoff_t *index, pgoff_t end,
+		int tag, unsigned nr_pages)
 {
-	pvec->nr = find_get_pages_tag(mapping, index, tag,
+	pvec->nr = find_get_pages_range_tag(mapping, index, end, tag,
 					nr_pages, pvec->pages);
 	return pagevec_count(pvec);
 }
-EXPORT_SYMBOL(pagevec_lookup_tag);
+EXPORT_SYMBOL(pagevec_lookup_range_tag);
 
 /*
  * Perform any setup for the swap system
_

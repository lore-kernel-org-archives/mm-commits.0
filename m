From: akpm@linux-foundation.org
Subject: + mm-lockless-pagecache.patch added to -mm tree
Date: Thu, 05 Jun 2008 13:35:07 -0700
Message-ID: <200806052035.m55KZ7Fr028513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753038AbYFEUgO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 16:36:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, benh@kernel.crashing.org, hugh@veritas.com, paulmck@us.ibm.com, paulus@samba.org


The patch titled
     mm: lockless pagecache
has been added to the -mm tree.  Its filename is
     mm-lockless-pagecache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: lockless pagecache
From: Nick Piggin <npiggin@suse.de>

Combine page_cache_get_speculative with lockless radix tree lookups to
introduce lockless page cache lookups (ie.  no mapping->tree_lock on the
read-side).

The only atomicity changes this introduces is that the gang pagecache
lookup functions now behave as if they are implemented with multiple
find_get_page calls, rather than operating on a snapshot of the pages.  In
practice, this atomicity guarantee is not used anyway, and it is to
replace individual lookups, so these semantics are natural.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |  179 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 134 insertions(+), 45 deletions(-)

diff -puN mm/filemap.c~mm-lockless-pagecache mm/filemap.c
--- a/mm/filemap.c~mm-lockless-pagecache
+++ a/mm/filemap.c
@@ -637,15 +637,35 @@ void __lock_page_nosync(struct page *pag
  * Is there a pagecache struct page at the given (mapping, offset) tuple?
  * If yes, increment its refcount and return it; if no, return NULL.
  */
-struct page * find_get_page(struct address_space *mapping, pgoff_t offset)
+struct page *find_get_page(struct address_space *mapping, pgoff_t offset)
 {
+	void **pagep;
 	struct page *page;
 
-	read_lock_irq(&mapping->tree_lock);
-	page = radix_tree_lookup(&mapping->page_tree, offset);
-	if (page)
-		page_cache_get(page);
-	read_unlock_irq(&mapping->tree_lock);
+	rcu_read_lock();
+repeat:
+	page = NULL;
+	pagep = radix_tree_lookup_slot(&mapping->page_tree, offset);
+	if (pagep) {
+		page = radix_tree_deref_slot(pagep);
+		if (unlikely(!page || page == RADIX_TREE_RETRY))
+			goto repeat;
+
+		if (!page_cache_get_speculative(page))
+			goto repeat;
+
+		/*
+		 * Has the page moved?
+		 * This is part of the lockless pagecache protocol. See
+		 * include/linux/pagemap.h for details.
+		 */
+		if (unlikely(page != *pagep)) {
+			page_cache_release(page);
+			goto repeat;
+		}
+	}
+	rcu_read_unlock();
+
 	return page;
 }
 EXPORT_SYMBOL(find_get_page);
@@ -660,32 +680,22 @@ EXPORT_SYMBOL(find_get_page);
  *
  * Returns zero if the page was not present. find_lock_page() may sleep.
  */
-struct page *find_lock_page(struct address_space *mapping,
-				pgoff_t offset)
+struct page *find_lock_page(struct address_space *mapping, pgoff_t offset)
 {
 	struct page *page;
 
 repeat:
-	read_lock_irq(&mapping->tree_lock);
-	page = radix_tree_lookup(&mapping->page_tree, offset);
+	page = find_get_page(mapping, offset);
 	if (page) {
-		page_cache_get(page);
-		if (TestSetPageLocked(page)) {
-			read_unlock_irq(&mapping->tree_lock);
-			__lock_page(page);
-
-			/* Has the page been truncated while we slept? */
-			if (unlikely(page->mapping != mapping)) {
-				unlock_page(page);
-				page_cache_release(page);
-				goto repeat;
-			}
-			VM_BUG_ON(page->index != offset);
-			goto out;
+		lock_page(page);
+		/* Has the page been truncated? */
+		if (unlikely(page->mapping != mapping)) {
+			unlock_page(page);
+			page_cache_release(page);
+			goto repeat;
 		}
+		VM_BUG_ON(page->index != offset);
 	}
-	read_unlock_irq(&mapping->tree_lock);
-out:
 	return page;
 }
 EXPORT_SYMBOL(find_lock_page);
@@ -751,13 +761,39 @@ unsigned find_get_pages(struct address_s
 {
 	unsigned int i;
 	unsigned int ret;
+	unsigned int nr_found;
+
+	rcu_read_lock();
+restart:
+	nr_found = radix_tree_gang_lookup_slot(&mapping->page_tree,
+				(void ***)pages, start, nr_pages);
+	ret = 0;
+	for (i = 0; i < nr_found; i++) {
+		struct page *page;
+repeat:
+		page = radix_tree_deref_slot((void **)pages[i]);
+		if (unlikely(!page))
+			continue;
+		/*
+		 * this can only trigger if nr_found == 1, making livelock
+		 * a non issue.
+		 */
+		if (unlikely(page == RADIX_TREE_RETRY))
+			goto restart;
 
-	read_lock_irq(&mapping->tree_lock);
-	ret = radix_tree_gang_lookup(&mapping->page_tree,
-				(void **)pages, start, nr_pages);
-	for (i = 0; i < ret; i++)
-		page_cache_get(pages[i]);
-	read_unlock_irq(&mapping->tree_lock);
+		if (!page_cache_get_speculative(page))
+			goto repeat;
+
+		/* Has the page moved? */
+		if (unlikely(page != *((void **)pages[i]))) {
+			page_cache_release(page);
+			goto repeat;
+		}
+
+		pages[ret] = page;
+		ret++;
+	}
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -778,19 +814,44 @@ unsigned find_get_pages_contig(struct ad
 {
 	unsigned int i;
 	unsigned int ret;
+	unsigned int nr_found;
+
+	rcu_read_lock();
+restart:
+	nr_found = radix_tree_gang_lookup_slot(&mapping->page_tree,
+				(void ***)pages, index, nr_pages);
+	ret = 0;
+	for (i = 0; i < nr_found; i++) {
+		struct page *page;
+repeat:
+		page = radix_tree_deref_slot((void **)pages[i]);
+		if (unlikely(!page))
+			continue;
+		/*
+		 * this can only trigger if nr_found == 1, making livelock
+		 * a non issue.
+		 */
+		if (unlikely(page == RADIX_TREE_RETRY))
+			goto restart;
 
-	read_lock_irq(&mapping->tree_lock);
-	ret = radix_tree_gang_lookup(&mapping->page_tree,
-				(void **)pages, index, nr_pages);
-	for (i = 0; i < ret; i++) {
-		if (pages[i]->mapping == NULL || pages[i]->index != index)
+		if (page->mapping == NULL || page->index != index)
 			break;
 
-		page_cache_get(pages[i]);
+		if (!page_cache_get_speculative(page))
+			goto repeat;
+
+		/* Has the page moved? */
+		if (unlikely(page != *((void **)pages[i]))) {
+			page_cache_release(page);
+			goto repeat;
+		}
+
+		pages[ret] = page;
+		ret++;
 		index++;
 	}
-	read_unlock_irq(&mapping->tree_lock);
-	return i;
+	rcu_read_unlock();
+	return ret;
 }
 EXPORT_SYMBOL(find_get_pages_contig);
 
@@ -810,15 +871,43 @@ unsigned find_get_pages_tag(struct addre
 {
 	unsigned int i;
 	unsigned int ret;
+	unsigned int nr_found;
+
+	rcu_read_lock();
+restart:
+	nr_found = radix_tree_gang_lookup_tag_slot(&mapping->page_tree,
+				(void ***)pages, *index, nr_pages, tag);
+	ret = 0;
+	for (i = 0; i < nr_found; i++) {
+		struct page *page;
+repeat:
+		page = radix_tree_deref_slot((void **)pages[i]);
+		if (unlikely(!page))
+			continue;
+		/*
+		 * this can only trigger if nr_found == 1, making livelock
+		 * a non issue.
+		 */
+		if (unlikely(page == RADIX_TREE_RETRY))
+			goto restart;
+
+		if (!page_cache_get_speculative(page))
+			goto repeat;
+
+		/* Has the page moved? */
+		if (unlikely(page != *((void **)pages[i]))) {
+			page_cache_release(page);
+			goto repeat;
+		}
+
+		pages[ret] = page;
+		ret++;
+	}
+	rcu_read_unlock();
 
-	read_lock_irq(&mapping->tree_lock);
-	ret = radix_tree_gang_lookup_tag(&mapping->page_tree,
-				(void **)pages, *index, nr_pages, tag);
-	for (i = 0; i < ret; i++)
-		page_cache_get(pages[i]);
 	if (ret)
 		*index = pages[ret - 1]->index + 1;
-	read_unlock_irq(&mapping->tree_lock);
+
 	return ret;
 }
 EXPORT_SYMBOL(find_get_pages_tag);
_

Patches currently in -mm which might be from npiggin@suse.de are

hugetlb-fix-lockdep-error.patch
linux-next.patch
spufs-convert-nopfn-to-fault.patch
vt-fix-vc_resize-locking.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-lockless-get_user_pages_fast.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch


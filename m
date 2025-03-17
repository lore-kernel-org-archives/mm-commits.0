Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16D1215771
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188266; cv=none; b=KKVm9E2qkw1rZqS9HGsa6IJlV8uuh6tImNCcEUgD4Ce/t+MAgtYVlg+sI9+9Uv1TL1TE3JByepb+gX1XUZ2bUmD2Lxpo+ehCBn7PeZrF+tUJ93iYdKYdU3/gMQm0irMFqEqE8j2BaZkEEE5pCozZyxNTURa1Kaqw90RoVQtToTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188266; c=relaxed/simple;
	bh=or7jsa2OQ5cUcYCnFoViqFbPzJi7GGiqW4KHord4Xw4=;
	h=Date:To:From:Subject:Message-Id; b=X6VMZVCcoXQFDt0ZQvasxvPcxUBgFrZE6IOq3K71TTmIioNjoZC8+r708uE++1YO9MxXYX+E1YAzGeYVDIjBzBuZWP3FhLaxDQY290vAAYXCKxn+2UqjxFbzvLWQB0XX3ma8LXo25/yngdioqObl0dmbT2H9Xor4ulGmIXtydxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N7O7qyU9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N7O7qyU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0FEC4CEED;
	Mon, 17 Mar 2025 05:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188265;
	bh=or7jsa2OQ5cUcYCnFoViqFbPzJi7GGiqW4KHord4Xw4=;
	h=Date:To:From:Subject:From;
	b=N7O7qyU9S5fh1xVpr5EHXDg4XesCD2yJVkTX8xYo7PrGTg1XLX9h7WWzDMW8yhW4O
	 SB7f21oRyWdYsIQDwdjL+vOsw0ewYZXhnSGzn4ZiorxyCrxm34Wrx9vOf1KUx+WY8u
	 vLZFrqIDeYYRWUwxsGkOsvaJGQ6Iz+mSXTWq/7g4=
Date: Sun, 16 Mar 2025 22:11:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tzimmermann@suse.de,soci@c64.rulez.org,simona.vetter@ffwll.ch,mcanal@igalia.com,jayakumar.lkml@gmail.com,deller@gmx.de,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch removed from -mm tree
Message-Id: <20250317051105.6C0FEC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: refactor rmap_walk_file() to separate out traversal logic
has been removed from the -mm tree.  Its filename was
     mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: refactor rmap_walk_file() to separate out traversal logic
Date: Sat, 8 Feb 2025 15:52:54 +0000

Patch series "expose mapping wrprotect, fix fb_defio use", v3.

Right now the only means by which we can write-protect a range using the
reverse mapping is via folio_mkclean().

However this is not always the appropriate means of doing so, specifically
in the case of the framebuffer deferred I/O logic (fb_defio enabled by
CONFIG_FB_DEFERRED_IO).  There, kernel pages are mapped read-only and
write-protect faults used to batch up I/O operations.

Each time the deferred work is done, folio_mkclean() is used to mark the
framebuffer page as having had I/O performed on it.  However doing so
requires the kernel page (perhaps allocated via vmalloc()) to have its
page->mapping, index fields set so the rmap can find everything that maps
it in order to write-protect.

This is problematic as firstly, these fields should not be set for
kernel-allocated memory, and secondly these are not folios (it's not user
memory) and page->index, mapping fields are now deprecated and soon to be
removed.

The removal of these fields is imminent, rendering this series more urgent
than it might first appear.

The implementers cannot be blamed for having used this however, as there
is simply no other way of performing this operation correctly.

This series fixes this - we provide the mapping_wrprotect_range() function
to allow the reverse mapping to be used to look up mappings from the page
cache object (i.e.  its address_space pointer) at a specific offset.

The fb_defio logic already stores this offset, and can simply be expanded
to keep track of the page cache object, so the change then becomes
straight-forward.

This series should have no functional change.


This patch (of 3):

In order to permit the traversal of the reverse mapping at a specified
mapping and offset rather than those specified by an input folio, we need
to separate out the portion of the rmap file logic which deals with this
traversal from those parts of the logic which interact with the folio.

This patch achieves this by adding a new static __rmap_walk_file()
function which rmap_walk_file() invokes.

This function permits the ability to pass NULL folio, on the assumption
that the caller has provided for this correctly in the callbacks specified
in the rmap_walk_control object.

Though it provides for this, and adds debug asserts to ensure that, should
a folio be specified, these are equal to the mapping and offset specified
in the folio, there should be no functional change as a result of this
patch.

The reason for adding this is to enable for future changes to permit users
to be able to traverse mappings of userland-mapped kernel memory,
write-protecting those mappings to enable page_mkwrite() or pfn_mkwrite()
fault handlers to be retriggered on subsequent dirty.

Link: https://lkml.kernel.org/r/cover.1739029358.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/0d1acec0cba1e5a12f9b53efcabc397541c90517.1739029358.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Kajtar Zsolt <soci@c64.rulez.org>
Cc: Maíra Canal <mcanal@igalia.com>
Cc: Matthew Wilcox <willy@infradead.org> [English fixes]
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   79 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 53 insertions(+), 26 deletions(-)

--- a/mm/rmap.c~mm-refactor-rmap_walk_file-to-separate-out-traversal-logic
+++ a/mm/rmap.c
@@ -2614,35 +2614,37 @@ static void rmap_walk_anon(struct folio
 		anon_vma_unlock_read(anon_vma);
 }
 
-/*
- * rmap_walk_file - do something to file page using the object-based rmap method
- * @folio: the folio to be handled
- * @rwc: control variable according to each walk type
- * @locked: caller holds relevant rmap lock
+/**
+ * __rmap_walk_file() - Traverse the reverse mapping for a file-backed mapping
+ * of a page mapped within a specified page cache object at a specified offset.
  *
- * Find all the mappings of a folio using the mapping pointer and the vma chains
- * contained in the address_space struct it points to.
+ * @folio: 		Either the folio whose mappings to traverse, or if NULL,
+ * 			the callbacks specified in @rwc will be configured such
+ * 			as to be able to look up mappings correctly.
+ * @mapping: 		The page cache object whose mapping VMAs we intend to
+ * 			traverse. If @folio is non-NULL, this should be equal to
+ *			folio_mapping(folio).
+ * @pgoff_start:	The offset within @mapping of the page which we are
+ * 			looking up. If @folio is non-NULL, this should be equal
+ * 			to folio_pgoff(folio).
+ * @nr_pages:		The number of pages mapped by the mapping. If @folio is
+ *			non-NULL, this should be equal to folio_nr_pages(folio).
+ * @rwc:		The reverse mapping walk control object describing how
+ *			the traversal should proceed.
+ * @locked:		Is the @mapping already locked? If not, we acquire the
+ *			lock.
  */
-static void rmap_walk_file(struct folio *folio,
-		struct rmap_walk_control *rwc, bool locked)
+static void __rmap_walk_file(struct folio *folio, struct address_space *mapping,
+			     pgoff_t pgoff_start, unsigned long nr_pages,
+			     struct rmap_walk_control *rwc, bool locked)
 {
-	struct address_space *mapping = folio_mapping(folio);
-	pgoff_t pgoff_start, pgoff_end;
+	pgoff_t pgoff_end = pgoff_start + nr_pages - 1;
 	struct vm_area_struct *vma;
 
-	/*
-	 * The page lock not only makes sure that page->mapping cannot
-	 * suddenly be NULLified by truncation, it makes sure that the
-	 * structure at mapping cannot be freed and reused yet,
-	 * so we can safely take mapping->i_mmap_rwsem.
-	 */
-	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
-
-	if (!mapping)
-		return;
+	VM_WARN_ON_FOLIO(folio && mapping != folio_mapping(folio), folio);
+	VM_WARN_ON_FOLIO(folio && pgoff_start != folio_pgoff(folio), folio);
+	VM_WARN_ON_FOLIO(folio && nr_pages != folio_nr_pages(folio), folio);
 
-	pgoff_start = folio_pgoff(folio);
-	pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
 	if (!locked) {
 		if (i_mmap_trylock_read(mapping))
 			goto lookup;
@@ -2657,8 +2659,7 @@ static void rmap_walk_file(struct folio
 lookup:
 	vma_interval_tree_foreach(vma, &mapping->i_mmap,
 			pgoff_start, pgoff_end) {
-		unsigned long address = vma_address(vma, pgoff_start,
-			       folio_nr_pages(folio));
+		unsigned long address = vma_address(vma, pgoff_start, nr_pages);
 
 		VM_BUG_ON_VMA(address == -EFAULT, vma);
 		cond_resched();
@@ -2671,12 +2672,38 @@ lookup:
 		if (rwc->done && rwc->done(folio))
 			goto done;
 	}
-
 done:
 	if (!locked)
 		i_mmap_unlock_read(mapping);
 }
 
+/*
+ * rmap_walk_file - do something to file page using the object-based rmap method
+ * @folio: the folio to be handled
+ * @rwc: control variable according to each walk type
+ * @locked: caller holds relevant rmap lock
+ *
+ * Find all the mappings of a folio using the mapping pointer and the vma chains
+ * contained in the address_space struct it points to.
+ */
+static void rmap_walk_file(struct folio *folio,
+		struct rmap_walk_control *rwc, bool locked)
+{
+	/*
+	 * The folio lock not only makes sure that folio->mapping cannot
+	 * suddenly be NULLified by truncation, it makes sure that the structure
+	 * at mapping cannot be freed and reused yet, so we can safely take
+	 * mapping->i_mmap_rwsem.
+	 */
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+
+	if (!folio->mapping)
+		return;
+
+	__rmap_walk_file(folio, folio->mapping, folio->index,
+			 folio_nr_pages(folio), rwc, locked);
+}
+
 void rmap_walk(struct folio *folio, struct rmap_walk_control *rwc)
 {
 	if (unlikely(folio_test_ksm(folio)))
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mremap-correctly-handle-partial-mremap-of-vma-starting-at-0.patch
mm-mremap-refactor-mremap-system-call-implementation.patch
mm-mremap-introduce-and-use-vma_remap_struct-threaded-state.patch
mm-mremap-initial-refactor-of-move_vma.patch
mm-mremap-complete-refactor-of-move_vma.patch
mm-mremap-refactor-move_page_tables-abstracting-state.patch
mm-mremap-thread-state-through-move-page-table-operation.patch


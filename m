Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A20F81E
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 00:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738887431; cv=none; b=XJKeUER09JSWGK9ZbH+rDBoHnJDnjnk6TMW62ECOBOyGdktnWqfz3DHKNNPzemPOqd2JB4ArzdbmaI0gk/9HdGlVseUSjGI2JzeG6eJUo9sEdGrZoznSmbObsZ3ZL0gkmVgAnkCY9d/Rbm2rSxC/ImZ/8/BixfA5FOyGQH0UKRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738887431; c=relaxed/simple;
	bh=stl12POPQ4wD9kQHDIMiQWp/n5UJ7eEpwIxp/8jCQfg=;
	h=Date:To:From:Subject:Message-Id; b=aY2fX5h+g2i3CLx9CnBvAg58WCyLrFg9mN+2VSoM3TuuQ8FuVJvv1ngDetRWwSFFTtvgAnt9rFsQ0WflrMQOcymtwspXotQJh36dZr4BPZ/g1gi07CQFqD6AvNLqZiYHJeOUwHy3p3Rtbzfz+w8FxpAHvUUKxvlYFLygUOz/Pm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oKqHoYVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oKqHoYVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E572EC4CEDD;
	Fri,  7 Feb 2025 00:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738887431;
	bh=stl12POPQ4wD9kQHDIMiQWp/n5UJ7eEpwIxp/8jCQfg=;
	h=Date:To:From:Subject:From;
	b=oKqHoYVhDNrL49h0FLnTC9c11p6A8H6LJ4HY5gHEBt+2/GViYu31lz8BXbJ6Kpuve
	 BwgFsf25H8p7hknIXBwzNzVxCTnbAKoEtAKklfUWFYCl87ehQhn9Iqo9AmMgw2fXH+
	 seDrpKqGdeuch9rcmqlvKjqIzQ2RECnJCfaJIwnY=
Date: Thu, 06 Feb 2025 16:17:10 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tzimmermann@suse.de,soci@c64.rulez.org,simona.vetter@ffwll.ch,mcanal@igalia.com,jayakumar.lkml@gmail.com,deller@gmx.de,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch added to mm-unstable branch
Message-Id: <20250207001710.E572EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: refactor rmap_walk_file() to separate out traversal logic
has been added to the -mm mm-unstable branch.  Its filename is
     mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: refactor rmap_walk_file() to separate out traversal logic
Date: Thu, 6 Feb 2025 15:33:19 +0000

Patch series "expose mapping wrprotect, fix fb_defio use", v2.

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


This patch (of 2):

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

Link: https://lkml.kernel.org/r/cover.1738855154.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/29d7038ab608eec8a1fae36ff4b64bd9c8658dd9.1738855154.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Maíra Canal <mcanal@igalia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Kajtar Zsolt <soci@c64.rulez.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   79 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 53 insertions(+), 26 deletions(-)

--- a/mm/rmap.c~mm-refactor-rmap_walk_file-to-separate-out-traversal-logic
+++ a/mm/rmap.c
@@ -2751,35 +2751,37 @@ static void rmap_walk_anon(struct folio
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
@@ -2794,8 +2796,7 @@ static void rmap_walk_file(struct folio
 lookup:
 	vma_interval_tree_foreach(vma, &mapping->i_mmap,
 			pgoff_start, pgoff_end) {
-		unsigned long address = vma_address(vma, pgoff_start,
-			       folio_nr_pages(folio));
+		unsigned long address = vma_address(vma, pgoff_start, nr_pages);
 
 		VM_BUG_ON_VMA(address == -EFAULT, vma);
 		cond_resched();
@@ -2808,12 +2809,38 @@ lookup:
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

mm-simplify-vma-merge-structure-and-expand-comments.patch
mm-further-refactor-commit_merge.patch
mm-eliminate-adj_start-parameter-from-commit_merge.patch
mm-make-vmg-target-consistent-and-further-simplify-commit_merge.patch
mm-completely-abstract-unnecessary-adj_start-calculation.patch
mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch
mm-provide-mapping_wrprotect_range-function.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78693215782
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188268; cv=none; b=Ojgh0SwlftRs/rjDQMh4B5gyoR1mR7s6TB063W7pqTHCChMir51VCOQGIRN+kQul+PUY1EFNz3JQISQlZ+9jqcbmN+nnS23NZi5CYTr08txu2tw3F74hOjmHJPuF3OJpe5KkMYf19dq5fpGxw/zeI60xcOXJtJUEb+gMhkA+zSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188268; c=relaxed/simple;
	bh=+3KiU35OyI3zeCm4kQ+e2Gf3F5X4aX+v3yjFKtoHhA0=;
	h=Date:To:From:Subject:Message-Id; b=O5NHaRK4qmbSfXhvm/H4f+bI17umi0OJBAyJpYZVZv97WFV+zMBmXHorpW4JpOTNT/SanhM8B7jg1/+nqAa8AJUBYkFdupVRmpXr6cGrhSSH11jFwy3pQcskdYSd9C2ld8Ag4HHq06LuZYvd2auRIlp0UYPcUW6q3Lpd8HL8kY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n4sMr8VF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n4sMr8VF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACD1C4CEEC;
	Mon, 17 Mar 2025 05:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188268;
	bh=+3KiU35OyI3zeCm4kQ+e2Gf3F5X4aX+v3yjFKtoHhA0=;
	h=Date:To:From:Subject:From;
	b=n4sMr8VF4va5k0Z5EFk7FKbWJ+JEs8duiPcZzxqY4Taip+pRq7ieKPL+aKRVETIPN
	 XmfC3HW1hjygjBl9V9k5YpYbVT3Jp6USL1Bp4yEWjikqllmbe5CNF3vTt1T8aPRkMi
	 kx/s0ZhIWxD5hLtoxFA9eNSNZzuyzrb+pD0EEjPI=
Date: Sun, 16 Mar 2025 22:11:07 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tzimmermann@suse.de,soci@c64.rulez.org,simona.vetter@ffwll.ch,mcanal@igalia.com,jayakumar.lkml@gmail.com,deller@gmx.de,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch removed from -mm tree
Message-Id: <20250317051108.4ACD1C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fb_defio: do not use deprecated page->mapping, index fields
has been removed from the -mm tree.  Its filename was
     fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: fb_defio: do not use deprecated page->mapping, index fields
Date: Sat, 8 Feb 2025 15:52:56 +0000

With the introduction of mapping_wrprotect_range() there is no need to use
folio_mkclean() in order to write-protect mappings of frame buffer pages,
and therefore no need to inappropriately set kernel-allocated page->index,
mapping fields to permit this operation.

Instead, store the pointer to the page cache object for the mapped driver
in the fb_deferred_io object, and use the already stored page offset from
the pageref object to look up mappings in order to write-protect them.

This is justified, as for the page objects to store a mapping pointer at
the point of assignment of pages, they must all reference the same
underlying address_space object.  Since the life time of the pagerefs is
also the lifetime of the fb_deferred_io object, storing the pointer here
makes sense.

This eliminates the need for all of the logic around setting and
maintaining page->index,mapping which we remove.

This eliminates the use of folio_mkclean() entirely but otherwise should
have no functional change.

[lorenzo.stoakes@oracle.com: fixup unused variable warnings]
  Link: https://lkml.kernel.org/r/d4018405-2762-4385-a816-e54cc23839ac@lucifer.local
Link: https://lkml.kernel.org/r/81171ab16c14e3df28f6de9d14982cee528d8519.1739029358.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Tested-by: Kajtar Zsolt <soci@c64.rulez.org>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Maíra Canal <mcanal@igalia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbdev/core/fb_defio.c |   43 +++++++++-----------------
 include/linux/fb.h                  |    1 
 2 files changed, 16 insertions(+), 28 deletions(-)

--- a/drivers/video/fbdev/core/fb_defio.c~fb_defio-do-not-use-deprecated-page-mapping-index-fields
+++ a/drivers/video/fbdev/core/fb_defio.c
@@ -69,14 +69,6 @@ out:
 	return pageref;
 }
 
-static void fb_deferred_io_pageref_clear(struct fb_deferred_io_pageref *pageref)
-{
-	struct page *page = pageref->page;
-
-	if (page)
-		page->mapping = NULL;
-}
-
 static struct fb_deferred_io_pageref *fb_deferred_io_pageref_get(struct fb_info *info,
 								 unsigned long offset,
 								 struct page *page)
@@ -140,13 +132,10 @@ static vm_fault_t fb_deferred_io_fault(s
 	if (!page)
 		return VM_FAULT_SIGBUS;
 
-	if (vmf->vma->vm_file)
-		page->mapping = vmf->vma->vm_file->f_mapping;
-	else
-		printk(KERN_ERR "no mapping available\n");
+	if (!vmf->vma->vm_file)
+		fb_err(info, "no mapping available\n");
 
-	BUG_ON(!page->mapping);
-	page->index = vmf->pgoff; /* for folio_mkclean() */
+	BUG_ON(!info->fbdefio->mapping);
 
 	vmf->page = page;
 	return 0;
@@ -194,9 +183,9 @@ static vm_fault_t fb_deferred_io_track_p
 
 	/*
 	 * We want the page to remain locked from ->page_mkwrite until
-	 * the PTE is marked dirty to avoid folio_mkclean() being called
-	 * before the PTE is updated, which would leave the page ignored
-	 * by defio.
+	 * the PTE is marked dirty to avoid mapping_wrprotect_range()
+	 * being called before the PTE is updated, which would leave
+	 * the page ignored by defio.
 	 * Do this by locking the page here and informing the caller
 	 * about it with VM_FAULT_LOCKED.
 	 */
@@ -274,15 +263,17 @@ static void fb_deferred_io_work(struct w
 	struct fb_deferred_io_pageref *pageref, *next;
 	struct fb_deferred_io *fbdefio = info->fbdefio;
 
-	/* here we mkclean the pages, then do all deferred IO */
+	/* here we wrprotect the page's mappings, then do all deferred IO. */
 	mutex_lock(&fbdefio->lock);
+#ifdef CONFIG_MMU
 	list_for_each_entry(pageref, &fbdefio->pagereflist, list) {
-		struct folio *folio = page_folio(pageref->page);
+		struct page *page = pageref->page;
+		pgoff_t pgoff = pageref->offset >> PAGE_SHIFT;
 
-		folio_lock(folio);
-		folio_mkclean(folio);
-		folio_unlock(folio);
+		mapping_wrprotect_range(fbdefio->mapping, pgoff,
+					page_to_pfn(page), 1);
 	}
+#endif
 
 	/* driver's callback with pagereflist */
 	fbdefio->deferred_io(info, &fbdefio->pagereflist);
@@ -337,6 +328,7 @@ void fb_deferred_io_open(struct fb_info
 {
 	struct fb_deferred_io *fbdefio = info->fbdefio;
 
+	fbdefio->mapping = file->f_mapping;
 	file->f_mapping->a_ops = &fb_deferred_io_aops;
 	fbdefio->open_count++;
 }
@@ -344,13 +336,7 @@ EXPORT_SYMBOL_GPL(fb_deferred_io_open);
 
 static void fb_deferred_io_lastclose(struct fb_info *info)
 {
-	unsigned long i;
-
 	flush_delayed_work(&info->deferred_work);
-
-	/* clear out the mapping that we setup */
-	for (i = 0; i < info->npagerefs; ++i)
-		fb_deferred_io_pageref_clear(&info->pagerefs[i]);
 }
 
 void fb_deferred_io_release(struct fb_info *info)
@@ -370,5 +356,6 @@ void fb_deferred_io_cleanup(struct fb_in
 
 	kvfree(info->pagerefs);
 	mutex_destroy(&fbdefio->lock);
+	fbdefio->mapping = NULL;
 }
 EXPORT_SYMBOL_GPL(fb_deferred_io_cleanup);
--- a/include/linux/fb.h~fb_defio-do-not-use-deprecated-page-mapping-index-fields
+++ a/include/linux/fb.h
@@ -225,6 +225,7 @@ struct fb_deferred_io {
 	int open_count; /* number of opened files; protected by fb_info lock */
 	struct mutex lock; /* mutex that protects the pageref list */
 	struct list_head pagereflist; /* list of pagerefs for touched pages */
+	struct address_space *mapping; /* page cache object for fb device */
 	/* callback */
 	struct page *(*get_page)(struct fb_info *info, unsigned long offset);
 	void (*deferred_io)(struct fb_info *info, struct list_head *pagelist);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mremap-correctly-handle-partial-mremap-of-vma-starting-at-0.patch
mm-mremap-refactor-mremap-system-call-implementation.patch
mm-mremap-introduce-and-use-vma_remap_struct-threaded-state.patch
mm-mremap-initial-refactor-of-move_vma.patch
mm-mremap-complete-refactor-of-move_vma.patch
mm-mremap-refactor-move_page_tables-abstracting-state.patch
mm-mremap-thread-state-through-move-page-table-operation.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B8833EC
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 00:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738887434; cv=none; b=mDs2v1YI6EMuOH9EiTBabI/NfJUr3ATPEsYn4a4JZj6iSUzBPD3L3qODAFmOK9QJuCeqePqUN0QfDGAMagjdiPCwXNJoK/JFP+uy5oJALkMR0Q0HudO3I+ylGGUjzB6zZFHvxp2QK2CcB5nGyXCDla2SgHVKkeopvD/7E6igHp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738887434; c=relaxed/simple;
	bh=5xIfrsM9dKSYemPSmE+G+VMvAvd+neJNzQmZmysE/ZA=;
	h=Date:To:From:Subject:Message-Id; b=JVQLC5HI3MGAvnmCHNkqDwv0SA00Ip6py14z60Agv6zIPFw87Ceny5F+/YsaJKgchV6vhDF63kk+wG5osYTUjM6/DaPYbOk57iUSB2hOX2ME9RPfZoGhevvh4Ve9rcnXpgAn2c1FaahrfZ2VyNvgCap3XMnLrsRDMpufKStn+5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O/Zwq/Am; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O/Zwq/Am"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB286C4CEDD;
	Fri,  7 Feb 2025 00:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738887433;
	bh=5xIfrsM9dKSYemPSmE+G+VMvAvd+neJNzQmZmysE/ZA=;
	h=Date:To:From:Subject:From;
	b=O/Zwq/AmNhPEe9CihjRd3eERREZORusD2sdHZ+HYL0e7i2lEX5gcx+fi9PCvw2B/h
	 MlmvD9RfRZX5Kl9NmLvZD7QaBC/0wFDJC8D6lrlUl88jdCHvaPnNjDkYkAer/3U2KM
	 7ir6InUPqsfhbnWcRKaN1R77fj4nO62unk+KT0wE=
Date: Thu, 06 Feb 2025 16:17:13 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tzimmermann@suse.de,soci@c64.rulez.org,simona.vetter@ffwll.ch,mcanal@igalia.com,jayakumar.lkml@gmail.com,deller@gmx.de,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch added to mm-unstable branch
Message-Id: <20250207001713.BB286C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fb_defio: do not use deprecated page->mapping, index fields
has been added to the -mm mm-unstable branch.  Its filename is
     fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch

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
Subject: fb_defio: do not use deprecated page->mapping, index fields
Date: Thu, 6 Feb 2025 15:33:21 +0000

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

Link: https://lkml.kernel.org/r/d6be40640e9f48fc5c3dcce01d5948ffa7add797.1738855154.git.lorenzo.stoakes@oracle.com
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

 drivers/video/fbdev/core/Kconfig    |    1 
 drivers/video/fbdev/core/fb_defio.c |   41 ++++++++------------------
 include/linux/fb.h                  |    1 
 3 files changed, 15 insertions(+), 28 deletions(-)

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
+		fb_err("no mapping available\n");
 
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
@@ -274,14 +263,14 @@ static void fb_deferred_io_work(struct w
 	struct fb_deferred_io_pageref *pageref, *next;
 	struct fb_deferred_io *fbdefio = info->fbdefio;
 
-	/* here we mkclean the pages, then do all deferred IO */
+	/* here we wrprotect the page's mappings, then do all deferred IO. */
 	mutex_lock(&fbdefio->lock);
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
 
 	/* driver's callback with pagereflist */
@@ -337,6 +326,7 @@ void fb_deferred_io_open(struct fb_info
 {
 	struct fb_deferred_io *fbdefio = info->fbdefio;
 
+	fbdefio->mapping = file->f_mapping;
 	file->f_mapping->a_ops = &fb_deferred_io_aops;
 	fbdefio->open_count++;
 }
@@ -344,13 +334,7 @@ EXPORT_SYMBOL_GPL(fb_deferred_io_open);
 
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
@@ -370,5 +354,6 @@ void fb_deferred_io_cleanup(struct fb_in
 
 	kvfree(info->pagerefs);
 	mutex_destroy(&fbdefio->lock);
+	fbdefio->mapping = NULL;
 }
 EXPORT_SYMBOL_GPL(fb_deferred_io_cleanup);
--- a/drivers/video/fbdev/core/Kconfig~fb_defio-do-not-use-deprecated-page-mapping-index-fields
+++ a/drivers/video/fbdev/core/Kconfig
@@ -135,6 +135,7 @@ config FB_SYSMEM_FOPS
 config FB_DEFERRED_IO
 	bool
 	depends on FB_CORE
+	depends on MMU
 
 config FB_DMAMEM_HELPERS
 	bool
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

mm-simplify-vma-merge-structure-and-expand-comments.patch
mm-further-refactor-commit_merge.patch
mm-eliminate-adj_start-parameter-from-commit_merge.patch
mm-make-vmg-target-consistent-and-further-simplify-commit_merge.patch
mm-completely-abstract-unnecessary-adj_start-calculation.patch
mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch
mm-provide-mapping_wrprotect_range-function.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EEF22089
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957102; cv=none; b=r0qkxxX466tthzvWO4A7dnpeGO4pQl22xfXW9xgnS2UPAA0tZOEGigYoap+J3wrMxRZMrdTia9/Snvfog88XJfQj/rUQuSirGvTqzO0JHcELMERhVl3bdWKsoMqr1gM+VaimLljYUXhfRh6NY0TdYKWBmkWRL8YY0Cd//Jh/8HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957102; c=relaxed/simple;
	bh=uWCx6XP6yHYcTr2pRXOHRCiVK8P1Sfm63zNbVgLq/b0=;
	h=Date:To:From:Subject:Message-Id; b=aF1uHEWBqJ+vg2DhFaUyhgUksuOKxTVkQmci0HOJzMLfb3fP4H9Dx7VNAuYNUFFnjCQSQHN5KuwVGYKsqTPfV5i2o6mldW50+4q4lG3eRC4/tMRRW/VNAg4VKQvH7XJHf+E4MFotv8O/Y3atq26HoRHK/6DmV0p8RJXI8laIKB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FNyMZNZj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FNyMZNZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D830C116B1;
	Mon,  6 May 2024 00:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957102;
	bh=uWCx6XP6yHYcTr2pRXOHRCiVK8P1Sfm63zNbVgLq/b0=;
	h=Date:To:From:Subject:From;
	b=FNyMZNZj8BxV7PnX+O6fhqfpzw+XoApDC87q8s4hpevbCeeNRaLc2861t8ZbLTPY7
	 9RLl6PcRZB7bgno56f8NGDh8hoFAMQbk1O+Ph53JUwcNvaQ/GnqEcjgwZTnmNHn7yg
	 mXhtYITS8B1oQFkFkvfckbSA06EiD8i7G4bk6GSI=
Date: Sun, 05 May 2024 17:58:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch removed from -mm tree
Message-Id: <20240506005822.7D830C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert put_devmap_managed_page_refs() to put_devmap_managed_folio_refs()
has been removed from the -mm tree.  Its filename was
     mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert put_devmap_managed_page_refs() to put_devmap_managed_folio_refs()
Date: Wed, 24 Apr 2024 20:19:08 +0100

All callers have a folio so we can remove this use of
page_ref_sub_return().

Link: https://lkml.kernel.org/r/20240424191914.361554-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   12 ++++++------
 mm/gup.c           |    6 +++---
 mm/memremap.c      |   10 +++++-----
 mm/swap.c          |    2 +-
 4 files changed, 15 insertions(+), 15 deletions(-)

--- a/include/linux/mm.h~mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs
+++ a/include/linux/mm.h
@@ -1441,17 +1441,17 @@ vm_fault_t finish_fault(struct vm_fault
 #if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_FS_DAX)
 DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
 
-bool __put_devmap_managed_page_refs(struct page *page, int refs);
-static inline bool put_devmap_managed_page_refs(struct page *page, int refs)
+bool __put_devmap_managed_folio_refs(struct folio *folio, int refs);
+static inline bool put_devmap_managed_folio_refs(struct folio *folio, int refs)
 {
 	if (!static_branch_unlikely(&devmap_managed_key))
 		return false;
-	if (!is_zone_device_page(page))
+	if (!folio_is_zone_device(folio))
 		return false;
-	return __put_devmap_managed_page_refs(page, refs);
+	return __put_devmap_managed_folio_refs(folio, refs);
 }
 #else /* CONFIG_ZONE_DEVICE && CONFIG_FS_DAX */
-static inline bool put_devmap_managed_page_refs(struct page *page, int refs)
+static inline bool put_devmap_managed_folio_refs(struct folio *folio, int refs)
 {
 	return false;
 }
@@ -1575,7 +1575,7 @@ static inline void put_page(struct page
 	 * For some devmap managed pages we need to catch refcount transition
 	 * from 2 to 1:
 	 */
-	if (put_devmap_managed_page_refs(&folio->page, 1))
+	if (put_devmap_managed_folio_refs(folio, 1))
 		return;
 	folio_put(folio);
 }
--- a/mm/gup.c~mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs
+++ a/mm/gup.c
@@ -89,7 +89,7 @@ retry:
 	 * belongs to this folio.
 	 */
 	if (unlikely(page_folio(page) != folio)) {
-		if (!put_devmap_managed_page_refs(&folio->page, refs))
+		if (!put_devmap_managed_folio_refs(folio, refs))
 			folio_put_refs(folio, refs);
 		goto retry;
 	}
@@ -156,7 +156,7 @@ struct folio *try_grab_folio(struct page
 	 */
 	if (unlikely((flags & FOLL_LONGTERM) &&
 		     !folio_is_longterm_pinnable(folio))) {
-		if (!put_devmap_managed_page_refs(&folio->page, refs))
+		if (!put_devmap_managed_folio_refs(folio, refs))
 			folio_put_refs(folio, refs);
 		return NULL;
 	}
@@ -198,7 +198,7 @@ static void gup_put_folio(struct folio *
 			refs *= GUP_PIN_COUNTING_BIAS;
 	}
 
-	if (!put_devmap_managed_page_refs(&folio->page, refs))
+	if (!put_devmap_managed_folio_refs(folio, refs))
 		folio_put_refs(folio, refs);
 }
 
--- a/mm/memremap.c~mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs
+++ a/mm/memremap.c
@@ -512,9 +512,9 @@ void zone_device_page_init(struct page *
 EXPORT_SYMBOL_GPL(zone_device_page_init);
 
 #ifdef CONFIG_FS_DAX
-bool __put_devmap_managed_page_refs(struct page *page, int refs)
+bool __put_devmap_managed_folio_refs(struct folio *folio, int refs)
 {
-	if (page->pgmap->type != MEMORY_DEVICE_FS_DAX)
+	if (folio->page.pgmap->type != MEMORY_DEVICE_FS_DAX)
 		return false;
 
 	/*
@@ -522,9 +522,9 @@ bool __put_devmap_managed_page_refs(stru
 	 * refcount is 1, then the page is free and the refcount is
 	 * stable because nobody holds a reference on the page.
 	 */
-	if (page_ref_sub_return(page, refs) == 1)
-		wake_up_var(&page->_refcount);
+	if (folio_ref_sub_return(folio, refs) == 1)
+		wake_up_var(&folio->_refcount);
 	return true;
 }
-EXPORT_SYMBOL(__put_devmap_managed_page_refs);
+EXPORT_SYMBOL(__put_devmap_managed_folio_refs);
 #endif /* CONFIG_FS_DAX */
--- a/mm/swap.c~mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs
+++ a/mm/swap.c
@@ -980,7 +980,7 @@ void folios_put_refs(struct folio_batch
 				unlock_page_lruvec_irqrestore(lruvec, flags);
 				lruvec = NULL;
 			}
-			if (put_devmap_managed_page_refs(&folio->page, nr_refs))
+			if (put_devmap_managed_folio_refs(folio, nr_refs))
 				continue;
 			if (folio_ref_sub_and_test(folio, nr_refs))
 				free_zone_device_folio(folio);
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch


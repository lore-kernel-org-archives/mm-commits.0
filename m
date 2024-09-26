Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7B217C9FC
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 20:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727384067; cv=none; b=TLvsskGU9d4q1YuGtiL2p2M5WkA2D8oz33AExFU2MhHnw3i+djRftrzR/qZJ8SQY3DZBem/a+DSAPirKsHNDgIm8LbDXtGUwfI4vEGA8wxVyLvBxJTLhDsS/rA6UrPy1CnHx1YsnfzTIz7gfJg1IT8ISYxw/wTgftBx5z3C/77Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727384067; c=relaxed/simple;
	bh=T0HvIFEZdqW9iOgU23UK/M3qCdOtpX60YDdcj/W97IA=;
	h=Date:To:From:Subject:Message-Id; b=pnj3BUPfiGIxstsg5OuMHBCQPan1xsjLZqsD5GOHez3TEkQ9QSBXnkTFvp3Gg0fosU6QsLSH4RoqPbtb0SS6yTmQID0RBZU25aTR91vHPkEwmrdQ27rscjr2eQQXxLb/M91pdxe0DgrMHcZohrYsbmHk5cpN3GJKfF2Oil4Rtxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NIp2Twwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NIp2Twwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F421C4CEC7;
	Thu, 26 Sep 2024 20:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727384067;
	bh=T0HvIFEZdqW9iOgU23UK/M3qCdOtpX60YDdcj/W97IA=;
	h=Date:To:From:Subject:From;
	b=NIp2TwwjUhLNT3tE5u8DRYCW20eFVAJyUuLBIFU1SXSVIvJnvos1AKNiEyScUQwxW
	 d2mhwAvJeu1XWHddC/TVXQezLZ9p6kVqHXt4inWxPqwQjmVNHe/HWQ7mM+xzuYOoNb
	 AQuv7HrH4Q+tkYwqh9HZmjiyKChNJkQcqtCVOVT8=
Date: Thu, 26 Sep 2024 13:54:26 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,osandov@osandov.com,hannes@cmpxchg.org,clm@fb.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-optimize-invalidation-of-shadow-entries.patch added to mm-unstable branch
Message-Id: <20240926205427.0F421C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: optimize invalidation of shadow entries
has been added to the -mm mm-unstable branch.  Its filename is
     mm-optimize-invalidation-of-shadow-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-optimize-invalidation-of-shadow-entries.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm: optimize invalidation of shadow entries
Date: Wed, 25 Sep 2024 15:47:16 -0700

The kernel invalidates the page cache in batches of PAGEVEC_SIZE.  For
each batch, it traverses the page cache tree and collects the entries
(folio and shadow entries) in the struct folio_batch.  For the shadow
entries present in the folio_batch, it has to traverse the page cache tree
for each individual entry to remove them.  This patch optimize this by
removing them in a single tree traversal.

To evaluate the changes, we created 200GiB file on a fuse fs and in a
memcg.  We created the shadow entries by triggering reclaim through
memory.reclaim in that specific memcg and measure the simple
fadvise(DONTNEED) operation.

 # time xfs_io -c 'fadvise -d 0 ${file_size}' file

              time (sec)
Without       5.12 +- 0.061
With-patch    4.19 +- 0.086 (18.16% decrease)

Link: https://lkml.kernel.org/r/20240925224716.2904498-3-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Chris Mason <clm@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |   46 ++++++++++++++++++----------------------------
 1 file changed, 18 insertions(+), 28 deletions(-)

--- a/mm/truncate.c~mm-optimize-invalidation-of-shadow-entries
+++ a/mm/truncate.c
@@ -23,42 +23,28 @@
 #include <linux/rmap.h>
 #include "internal.h"
 
-/*
- * Regular page slots are stabilized by the page lock even without the tree
- * itself locked.  These unlocked entries need verification under the tree
- * lock.
- */
-static inline void __clear_shadow_entry(struct address_space *mapping,
-				pgoff_t index, void *entry)
-{
-	XA_STATE(xas, &mapping->i_pages, index);
-
-	xas_set_update(&xas, workingset_update_node);
-	if (xas_load(&xas) != entry)
-		return;
-	xas_store(&xas, NULL);
-}
-
 static void clear_shadow_entries(struct address_space *mapping,
-				 struct folio_batch *fbatch, pgoff_t *indices)
+				 unsigned long start, unsigned long max)
 {
-	int i;
+	XA_STATE(xas, &mapping->i_pages, start);
+	struct folio *folio;
 
 	/* Handled by shmem itself, or for DAX we do nothing. */
 	if (shmem_mapping(mapping) || dax_mapping(mapping))
 		return;
 
-	spin_lock(&mapping->host->i_lock);
-	xa_lock_irq(&mapping->i_pages);
+	xas_set_update(&xas, workingset_update_node);
 
-	for (i = 0; i < folio_batch_count(fbatch); i++) {
-		struct folio *folio = fbatch->folios[i];
+	spin_lock(&mapping->host->i_lock);
+	xas_lock_irq(&xas);
 
+	/* Clear all shadow entries from start to max */
+	xas_for_each(&xas, folio, max) {
 		if (xa_is_value(folio))
-			__clear_shadow_entry(mapping, indices[i], folio);
+			xas_store(&xas, NULL);
 	}
 
-	xa_unlock_irq(&mapping->i_pages);
+	xas_unlock_irq(&xas);
 	if (mapping_shrinkable(mapping))
 		inode_add_lru(mapping->host);
 	spin_unlock(&mapping->host->i_lock);
@@ -481,7 +467,9 @@ unsigned long mapping_try_invalidate(str
 
 	folio_batch_init(&fbatch);
 	while (find_lock_entries(mapping, &index, end, &fbatch, indices)) {
-		for (i = 0; i < folio_batch_count(&fbatch); i++) {
+		int nr = folio_batch_count(&fbatch);
+
+		for (i = 0; i < nr; i++) {
 			struct folio *folio = fbatch.folios[i];
 
 			/* We rely upon deletion not changing folio->index */
@@ -508,7 +496,7 @@ unsigned long mapping_try_invalidate(str
 		}
 
 		if (xa_has_values)
-			clear_shadow_entries(mapping, &fbatch, indices);
+			clear_shadow_entries(mapping, indices[0], indices[nr-1]);
 
 		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
@@ -612,7 +600,9 @@ int invalidate_inode_pages2_range(struct
 	folio_batch_init(&fbatch);
 	index = start;
 	while (find_get_entries(mapping, &index, end, &fbatch, indices)) {
-		for (i = 0; i < folio_batch_count(&fbatch); i++) {
+		int nr = folio_batch_count(&fbatch);
+
+		for (i = 0; i < nr; i++) {
 			struct folio *folio = fbatch.folios[i];
 
 			/* We rely upon deletion not changing folio->index */
@@ -658,7 +648,7 @@ int invalidate_inode_pages2_range(struct
 		}
 
 		if (xa_has_values)
-			clear_shadow_entries(mapping, &fbatch, indices);
+			clear_shadow_entries(mapping, indices[0], indices[nr-1]);
 
 		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-optimize-truncation-of-shadow-entries.patch
mm-optimize-invalidation-of-shadow-entries.patch


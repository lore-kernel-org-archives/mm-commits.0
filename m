Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5D9142E86
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854743; cv=none; b=eQEWbAsnAVsHX77YxuOIZkPS0Fzc+HbPCaDVOwszVi4BLHK32RPwJyEZYx1oHDb8M7eq/jigWNQ6GIYXRdJLYE7H/E86tVXe1gRuwmZrmu3DTAWkUwH/TdfXHF5TkOJrL1h1zRg5Q9RT/LhcjoOwmIMPzlMLMCyQOlkoPRlyjWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854743; c=relaxed/simple;
	bh=tcDMa3fxcMSHqlKRTaldTPw1hyzBDhJahQnShgS/eXc=;
	h=Date:To:From:Subject:Message-Id; b=MfApb93dR1Ey6IE0W5XqvmKRYznz5v+JFbg6zOBoBJjLgnPnOCg3vNwMO1mVpSs3nwUPFWkwnzv8kt3mXJp9Q0tSRJu8hulozCFsJqhrF9xOI+OVgfCsqpS0veRx4G0KBELjb9me4GQk9T+8b3C29Pxy5cEZbdhu0zrs9opnGEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HIy+5Pa2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HIy+5Pa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F61C4CECF;
	Wed,  6 Nov 2024 00:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854742;
	bh=tcDMa3fxcMSHqlKRTaldTPw1hyzBDhJahQnShgS/eXc=;
	h=Date:To:From:Subject:From;
	b=HIy+5Pa2TFoMXa8dxS5TdU7nbQmxfSthrZfuyfmJxy3Iw7kHM++KYQ0tPJ2WruAqm
	 JZKA52j0wf7O2Z2OiuD38+76aBNk/zFjpge3a7/HERyMNK6PShgdpTrAepxkO+iqvq
	 TyR8I7UjPVqnI4geim5e1CADLFpDxCIWx0n3q0NI=
Date: Tue, 05 Nov 2024 16:59:02 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,osandov@osandov.com,hannes@cmpxchg.org,clm@fb.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-optimize-invalidation-of-shadow-entries.patch removed from -mm tree
Message-Id: <20241106005902.D5F61C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: optimize invalidation of shadow entries
has been removed from the -mm tree.  Its filename was
     mm-optimize-invalidation-of-shadow-entries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



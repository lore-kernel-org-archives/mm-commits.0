Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0CF13C918
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854742; cv=none; b=Q9UCgB4SDmVX77GE6dgwESTkLleKFM9ukYvV3OWCLRfZ4BwuOSaeKirZpit2V8nhMNLoPaOwy/gubGl2/jaCW0VyiEYU2R44MKY6LLUH4B+J829Xud9WYqeqcCsUS2T+r6cin1oSN1UnI5zxt5IaoHC9t01Pozqx47FJWTsnWyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854742; c=relaxed/simple;
	bh=GjHXXCkDz5UODB5uHTYOD6KjahXxZwJDNES8iPFkEK4=;
	h=Date:To:From:Subject:Message-Id; b=Z9s8w+daCnoSBF8yBxz4rD/8TAvUTQwQ8uwd4fG1b1wqmfXwTGZbxei8xAuLBGqtZO/TY+ZJydTq07oqvhN6UYoLghGKzAaHdrrDTnjwXqoFlzeqXboPYib131N/C3yjTOb8mEB4ZWve4ligrnUePI1dyaQBA44YF0tArs0LcAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yoIUVtC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yoIUVtC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD851C4CECF;
	Wed,  6 Nov 2024 00:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854741;
	bh=GjHXXCkDz5UODB5uHTYOD6KjahXxZwJDNES8iPFkEK4=;
	h=Date:To:From:Subject:From;
	b=yoIUVtC8lQ9JikCHfDrhbFQjhN9/zqr3prK8YInfQ0c0ObBgkyNiJ9POSFQUF0xdB
	 uyXzyzI6wW/wxFUcK37oMvlMifjiFjnjdzZ6KvrXq70/9RMxPphp5VKhC31ICVKdPy
	 koktpFgvW0dJSIYBbv2B7ljOO4ebsk1N6LEkOlb0=
Date: Tue, 05 Nov 2024 16:59:01 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,osandov@osandov.com,hannes@cmpxchg.org,clm@fb.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-optimize-truncation-of-shadow-entries.patch removed from -mm tree
Message-Id: <20241106005901.BD851C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: optimize truncation of shadow entries
has been removed from the -mm tree.  Its filename was
     mm-optimize-truncation-of-shadow-entries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm: optimize truncation of shadow entries
Date: Wed, 25 Sep 2024 15:47:15 -0700

Patch series "mm: optimize shadow entries removal", v2.

Some of our production workloads which processes a large amount of data
spends considerable amount of CPUs on truncation and invalidation of large
sized files (100s of GiBs of size).  Tracing the operations showed that
most of the time is in shadow entries removal.  This patch series
optimizes the truncation and invalidation operations.


This patch (of 2):

The kernel truncates the page cache in batches of PAGEVEC_SIZE.  For each
batch, it traverses the page cache tree and collects the entries (folio
and shadow entries) in the struct folio_batch.  For the shadow entries
present in the folio_batch, it has to traverse the page cache tree for
each individual entry to remove them.  This patch optimize this by
removing them in a single tree traversal.

On large machines in our production which run workloads manipulating large
amount of data, we have observed that a large amount of CPUs are spent on
truncation of very large files (100s of GiBs file sizes).  More
specifically most of time was spent on shadow entries cleanup, so
optimizing the shadow entries cleanup, even a little bit, has good impact.

To evaluate the changes, we created 200GiB file on a fuse fs and in a
memcg.  We created the shadow entries by triggering reclaim through
memory.reclaim in that specific memcg and measure the simple truncation
operation.

 # time truncate -s 0 file

              time (sec)
Without       5.164 +- 0.059
With-patch    4.21  +- 0.066 (18.47% decrease)

Link: https://lkml.kernel.org/r/20240925224716.2904498-1-shakeel.butt@linux.dev
Link: https://lkml.kernel.org/r/20240925224716.2904498-2-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Mason <clm@fb.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |   53 +++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

--- a/mm/truncate.c~mm-optimize-truncation-of-shadow-entries
+++ a/mm/truncate.c
@@ -68,54 +68,53 @@ static void clear_shadow_entries(struct
  * Unconditionally remove exceptional entries. Usually called from truncate
  * path. Note that the folio_batch may be altered by this function by removing
  * exceptional entries similar to what folio_batch_remove_exceptionals() does.
+ * Please note that indices[] has entries in ascending order as guaranteed by
+ * either find_get_entries() or find_lock_entries().
  */
 static void truncate_folio_batch_exceptionals(struct address_space *mapping,
 				struct folio_batch *fbatch, pgoff_t *indices)
 {
+	XA_STATE(xas, &mapping->i_pages, indices[0]);
+	int nr = folio_batch_count(fbatch);
+	struct folio *folio;
 	int i, j;
-	bool dax;
 
 	/* Handled by shmem itself */
 	if (shmem_mapping(mapping))
 		return;
 
-	for (j = 0; j < folio_batch_count(fbatch); j++)
+	for (j = 0; j < nr; j++)
 		if (xa_is_value(fbatch->folios[j]))
 			break;
 
-	if (j == folio_batch_count(fbatch))
+	if (j == nr)
 		return;
 
-	dax = dax_mapping(mapping);
-	if (!dax) {
-		spin_lock(&mapping->host->i_lock);
-		xa_lock_irq(&mapping->i_pages);
+	if (dax_mapping(mapping)) {
+		for (i = j; i < nr; i++) {
+			if (xa_is_value(fbatch->folios[i]))
+				dax_delete_mapping_entry(mapping, indices[i]);
+		}
+		goto out;
 	}
 
-	for (i = j; i < folio_batch_count(fbatch); i++) {
-		struct folio *folio = fbatch->folios[i];
-		pgoff_t index = indices[i];
-
-		if (!xa_is_value(folio)) {
-			fbatch->folios[j++] = folio;
-			continue;
-		}
+	xas_set(&xas, indices[j]);
+	xas_set_update(&xas, workingset_update_node);
 
-		if (unlikely(dax)) {
-			dax_delete_mapping_entry(mapping, index);
-			continue;
-		}
+	spin_lock(&mapping->host->i_lock);
+	xas_lock_irq(&xas);
 
-		__clear_shadow_entry(mapping, index, folio);
+	xas_for_each(&xas, folio, indices[nr-1]) {
+		if (xa_is_value(folio))
+			xas_store(&xas, NULL);
 	}
 
-	if (!dax) {
-		xa_unlock_irq(&mapping->i_pages);
-		if (mapping_shrinkable(mapping))
-			inode_add_lru(mapping->host);
-		spin_unlock(&mapping->host->i_lock);
-	}
-	fbatch->nr = j;
+	xas_unlock_irq(&xas);
+	if (mapping_shrinkable(mapping))
+		inode_add_lru(mapping->host);
+	spin_unlock(&mapping->host->i_lock);
+out:
+	folio_batch_remove_exceptionals(fbatch);
 }
 
 /**
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are



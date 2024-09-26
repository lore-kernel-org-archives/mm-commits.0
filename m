Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D93D282FA
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 20:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727384067; cv=none; b=YWgn97eASQjR/fkrz7itBa8jWiF76kzxAjmO8WMclQQ6c8VUfo5RZ659Z7xC1HJmwXi/wg7BMAueuKYtuvSEUD3W3UxfQCgReponK63Abw9ydVczsKs08B+KxnDfjtpnaiXXn++o1w2WJ/VFb45abUrwrcda08bRESE4lYVvGn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727384067; c=relaxed/simple;
	bh=KkUatDD7L4uyMUcP7vS39xwzF690ng3hZkslI6zvoto=;
	h=Date:To:From:Subject:Message-Id; b=pcwHOYt0KVbWouxBrsDcZ2Q73CO8uY2WkMGUhw3P+OjCxi9NyZa/FwcL5BhItsaHhHdzw4wXgpeipKgLy50XiZkDM83Z9SWcdNbFX5VuRQiEuW7Jwql9skYc+WFTwEod96u0Ij4QDZEyA1qs8KQlB3QJfM24mNSQDauQijIHBLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T08I83gq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T08I83gq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5079C4CEC5;
	Thu, 26 Sep 2024 20:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727384065;
	bh=KkUatDD7L4uyMUcP7vS39xwzF690ng3hZkslI6zvoto=;
	h=Date:To:From:Subject:From;
	b=T08I83gqvKdDN9iMb78UqPWiHOloL3lgnvw/ahEczddCOFSDiCelO8js90nLUDXaG
	 SOXPb9W/kT2EuR4yzFCeaUXSxXykhgZShCr680Bu+q4YXN+zFA1yPzNkS3BMulZTH/
	 L9adWOiZnQqXI5TseFpvxL7ryWG88WjVjCEXr40A=
Date: Thu, 26 Sep 2024 13:54:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,osandov@osandov.com,hannes@cmpxchg.org,clm@fb.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-optimize-truncation-of-shadow-entries.patch added to mm-unstable branch
Message-Id: <20240926205425.B5079C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: optimize truncation of shadow entries
has been added to the -mm mm-unstable branch.  Its filename is
     mm-optimize-truncation-of-shadow-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-optimize-truncation-of-shadow-entries.patch

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

mm-optimize-truncation-of-shadow-entries.patch
mm-optimize-invalidation-of-shadow-entries.patch


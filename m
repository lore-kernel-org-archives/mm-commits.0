Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1442012DD8E
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824901; cv=none; b=VCAejLWq1r1wk7TVElMGQ0hpbmGj38sD6qJtm9Zx42rhhMNFcb+Eqq4guhJTXN7dMoleAlWNy+mYrxGbsW4UcV4MlHk+0eFbIsrSNyxvGx5I78TzlLO4htzZ8NjNlHwwFdle7f8lL51o8GaYM4adQP7p5EC9frzWuWTGSAfHFrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824901; c=relaxed/simple;
	bh=ek+Qc2eJyqODSY8sb2DGJM7NwmSX3PlTwxeHP1vbZFI=;
	h=Date:To:From:Subject:Message-Id; b=du7Qs3GR3QlmqVIBMzpkOupxoCvVg4qdHGI58gvnNHtXs9q5SuHzHNVp2NlPRT1UrUv+svFEMNc5XenKySw+eQucngXLZLqPUn24byYaOaWzH8pXlnYwqA0PTjV/lPbq3JCL8dqMR9p+Qmiu18X0/TAzurASGcTLAb9O6BZTRDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aPI+WuIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aPI+WuIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4EFC32782;
	Fri, 12 Jul 2024 22:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824901;
	bh=ek+Qc2eJyqODSY8sb2DGJM7NwmSX3PlTwxeHP1vbZFI=;
	h=Date:To:From:Subject:From;
	b=aPI+WuINI4nScBUDCVjhSJRYgtNT1ahMI6AJlzNRBF1O/aBrvElWrVjwruKG2zSvo
	 lxuwPnF7Mpu/DBFy3NE2Q2vRx1zVmlyoUasOMCZWVhVg0JCGytY8ctEF8HJuyQq/Be
	 JahmW4QJDV9HkXBw1eLefXU654SAq3/5XU+H7rZo=
Date: Fri, 12 Jul 2024 15:55:00 -0700
To: mm-commits@vger.kernel.org,mgorman@techsingularity.net,hannes@cmpxchg.org,bharata@amd.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-truncate-batch-clear-shadow-entries.patch removed from -mm tree
Message-Id: <20240712225500.DE4EFC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/truncate: batch-clear shadow entries
has been removed from the -mm tree.  Its filename was
     mm-truncate-batch-clear-shadow-entries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/truncate: batch-clear shadow entries
Date: Mon, 8 Jul 2024 15:27:53 -0600

Make clear_shadow_entry() clear shadow entries in `struct folio_batch` so
that it can reduce contention on i_lock and i_pages locks, e.g.,

  watchdog: BUG: soft lockup - CPU#29 stuck for 11s! [fio:2701649]
    clear_shadow_entry+0x3d/0x100
    mapping_try_invalidate+0x117/0x1d0
    invalidate_mapping_pages+0x10/0x20
    invalidate_bdev+0x3c/0x50
    blkdev_common_ioctl+0x5f7/0xa90
    blkdev_ioctl+0x109/0x270

Also, rename clear_shadow_entry() to clear_shadow_entries() accordingly.

[yuzhao@google.com: v2]
  Link: https://lkml.kernel.org/r/20240710060933.3979380-1-yuzhao@google.com
Link: https://lkml.kernel.org/r/20240708212753.3120511-1-yuzhao@google.com
Reported-by: Bharata B Rao <bharata@amd.com>
Closes: https://lore.kernel.org/d2841226-e27b-4d3d-a578-63587a3aa4f3@amd.com/
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |   68 +++++++++++++++++++++---------------------------
 1 file changed, 31 insertions(+), 37 deletions(-)

--- a/mm/truncate.c~mm-truncate-batch-clear-shadow-entries
+++ a/mm/truncate.c
@@ -39,12 +39,25 @@ static inline void __clear_shadow_entry(
 	xas_store(&xas, NULL);
 }
 
-static void clear_shadow_entry(struct address_space *mapping, pgoff_t index,
-			       void *entry)
+static void clear_shadow_entries(struct address_space *mapping,
+				 struct folio_batch *fbatch, pgoff_t *indices)
 {
+	int i;
+
+	/* Handled by shmem itself, or for DAX we do nothing. */
+	if (shmem_mapping(mapping) || dax_mapping(mapping))
+		return;
+
 	spin_lock(&mapping->host->i_lock);
 	xa_lock_irq(&mapping->i_pages);
-	__clear_shadow_entry(mapping, index, entry);
+
+	for (i = 0; i < folio_batch_count(fbatch); i++) {
+		struct folio *folio = fbatch->folios[i];
+
+		if (xa_is_value(folio))
+			__clear_shadow_entry(mapping, indices[i], folio);
+	}
+
 	xa_unlock_irq(&mapping->i_pages);
 	if (mapping_shrinkable(mapping))
 		inode_add_lru(mapping->host);
@@ -105,36 +118,6 @@ static void truncate_folio_batch_excepti
 	fbatch->nr = j;
 }
 
-/*
- * Invalidate exceptional entry if easily possible. This handles exceptional
- * entries for invalidate_inode_pages().
- */
-static int invalidate_exceptional_entry(struct address_space *mapping,
-					pgoff_t index, void *entry)
-{
-	/* Handled by shmem itself, or for DAX we do nothing. */
-	if (shmem_mapping(mapping) || dax_mapping(mapping))
-		return 1;
-	clear_shadow_entry(mapping, index, entry);
-	return 1;
-}
-
-/*
- * Invalidate exceptional entry if clean. This handles exceptional entries for
- * invalidate_inode_pages2() so for DAX it evicts only clean entries.
- */
-static int invalidate_exceptional_entry2(struct address_space *mapping,
-					 pgoff_t index, void *entry)
-{
-	/* Handled by shmem itself */
-	if (shmem_mapping(mapping))
-		return 1;
-	if (dax_mapping(mapping))
-		return dax_invalidate_mapping_entry_sync(mapping, index);
-	clear_shadow_entry(mapping, index, entry);
-	return 1;
-}
-
 /**
  * folio_invalidate - Invalidate part or all of a folio.
  * @folio: The folio which is affected.
@@ -494,6 +477,7 @@ unsigned long mapping_try_invalidate(str
 	unsigned long ret;
 	unsigned long count = 0;
 	int i;
+	bool xa_has_values = false;
 
 	folio_batch_init(&fbatch);
 	while (find_lock_entries(mapping, &index, end, &fbatch, indices)) {
@@ -503,8 +487,8 @@ unsigned long mapping_try_invalidate(str
 			/* We rely upon deletion not changing folio->index */
 
 			if (xa_is_value(folio)) {
-				count += invalidate_exceptional_entry(mapping,
-							     indices[i], folio);
+				xa_has_values = true;
+				count++;
 				continue;
 			}
 
@@ -522,6 +506,10 @@ unsigned long mapping_try_invalidate(str
 			}
 			count += ret;
 		}
+
+		if (xa_has_values)
+			clear_shadow_entries(mapping, &fbatch, indices);
+
 		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
 		cond_resched();
@@ -616,6 +604,7 @@ int invalidate_inode_pages2_range(struct
 	int ret = 0;
 	int ret2 = 0;
 	int did_range_unmap = 0;
+	bool xa_has_values = false;
 
 	if (mapping_empty(mapping))
 		return 0;
@@ -629,8 +618,9 @@ int invalidate_inode_pages2_range(struct
 			/* We rely upon deletion not changing folio->index */
 
 			if (xa_is_value(folio)) {
-				if (!invalidate_exceptional_entry2(mapping,
-						indices[i], folio))
+				xa_has_values = true;
+				if (dax_mapping(mapping) &&
+				    !dax_invalidate_mapping_entry_sync(mapping, indices[i]))
 					ret = -EBUSY;
 				continue;
 			}
@@ -666,6 +656,10 @@ int invalidate_inode_pages2_range(struct
 				ret = ret2;
 			folio_unlock(folio);
 		}
+
+		if (xa_has_values)
+			clear_shadow_entries(mapping, &fbatch, indices);
+
 		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
 		cond_resched();
_

Patches currently in -mm which might be from yuzhao@google.com are



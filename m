Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C294D108
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824532; cv=none; b=JowFjw/uHKC000SeM2LdkgkESPjCiwN3AK3/ZQe1wF3tKNlJcgTYPTxU6X6grkDQYSvv0DzWu6QcFo5GTSo0cIlXs/YRntkVNbsX9eeUivvOMyIOuZq3sgPCfTD8kXshKuar65H2fCAk6Q1dBxkiyDlsCRfDS8W3NfoeKPCKxbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824532; c=relaxed/simple;
	bh=P6kHOfdLmJookfTodVT6aKrX/xmxH15ESoP3gdK57l8=;
	h=Date:To:From:Subject:Message-Id; b=envsofrP00XOHgIYAks/kPc16twEBOMT9LX1ULACFbdFMheuoIdjkLgNhInAc/K65DtoNI92AhjNDII1lqpkCSecwJoFNuzVQ9pAZYfApqFr7wZlCU/3qaZzXhDB/Dpo4WDHEsMwcvXg4UTUOCPvwgWPGKVHo8rNBjgj6hEjx9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lPQPNvZs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lPQPNvZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF525C32782;
	Fri, 12 Jul 2024 22:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824531;
	bh=P6kHOfdLmJookfTodVT6aKrX/xmxH15ESoP3gdK57l8=;
	h=Date:To:From:Subject:From;
	b=lPQPNvZsX2asblYDynRbKvK8JzsO+yHZDgdu14HGKxPKoTUtee4zh/EWmlfyRaPLx
	 3yEuIji9rLkak0Syt9nJ/AJoHwcGqw19HR2Xt+NO+jOR2J10xDUmXVp7cz24yG6qA5
	 46ZKJ3YIKiXlACCK4YyXDNaaM9flfLB7eP3sxd4Q=
Date: Fri, 12 Jul 2024 15:48:51 -0700
To: mm-commits@vger.kernel.org,mgorman@techsingularity.net,hannes@cmpxchg.org,bharata@amd.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-truncate-batch-clear-shadow-entries-v2.patch removed from -mm tree
Message-Id: <20240712224851.CF525C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-truncate-batch-clear-shadow-entries-v2
has been removed from the -mm tree.  Its filename was
     mm-truncate-batch-clear-shadow-entries-v2.patch

This patch was dropped because it was folded into mm-truncate-batch-clear-shadow-entries.patch

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm-truncate-batch-clear-shadow-entries-v2
Date: Wed, 10 Jul 2024 00:09:33 -0600

restore comment, rename clear_shadow_entry() to clear_shadow_entries()

Link: https://lkml.kernel.org/r/20240710060933.3979380-1-yuzhao@google.com
Reported-by: Bharata B Rao <bharata@amd.com>
Closes: https://lore.kernel.org/d2841226-e27b-4d3d-a578-63587a3aa4f3@amd.com/
Tested-by: Bharata B Rao <bharata@amd.com>
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/truncate.c~mm-truncate-batch-clear-shadow-entries-v2
+++ a/mm/truncate.c
@@ -39,11 +39,12 @@ static inline void __clear_shadow_entry(
 	xas_store(&xas, NULL);
 }
 
-static void clear_shadow_entry(struct address_space *mapping,
-			       struct folio_batch *fbatch, pgoff_t *indices)
+static void clear_shadow_entries(struct address_space *mapping,
+				 struct folio_batch *fbatch, pgoff_t *indices)
 {
 	int i;
 
+	/* Handled by shmem itself, or for DAX we do nothing. */
 	if (shmem_mapping(mapping) || dax_mapping(mapping))
 		return;
 
@@ -507,7 +508,7 @@ unsigned long mapping_try_invalidate(str
 		}
 
 		if (xa_has_values)
-			clear_shadow_entry(mapping, &fbatch, indices);
+			clear_shadow_entries(mapping, &fbatch, indices);
 
 		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
@@ -657,7 +658,7 @@ int invalidate_inode_pages2_range(struct
 		}
 
 		if (xa_has_values)
-			clear_shadow_entry(mapping, &fbatch, indices);
+			clear_shadow_entries(mapping, &fbatch, indices);
 
 		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-truncate-batch-clear-shadow-entries.patch
mm-mglru-fix-div-by-zero-in-vmpressure_calc_level.patch
mm-mglru-fix-overshooting-shrinker-memory.patch


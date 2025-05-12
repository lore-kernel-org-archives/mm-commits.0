Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931DF1553A3
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011035; cv=none; b=sV3KldqcZcMxhOCk60aeQXGwzw20cIHdyfERbTTM0f3e7+cCe+Gpo6PfDeBQre0lXDkOwDORxKM+4FEA+XjVXMpknMCxzEC5wF3ER/NB6qOk0qjDsjITGYI5gCdrJPejIsCMoMRnqKb6emIpDF2lAfIjo4MYrBL00smDce6mJHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011035; c=relaxed/simple;
	bh=bhCMZW+OAFcTwlbkPvB3mEG4jZFQzbKFHjrFPHePh2E=;
	h=Date:To:From:Subject:Message-Id; b=MNKQm+ytRhMx+g3vf8zIBE1gq2uG+gfwTkFpxWr3QNIj5WkZ6UgdGkO5IpBksGUF9AxPbx/m+NQa+wM7u4ePDaOQb+JWdA1nmsmd7WCI5OmkazQRRntBAYKZQ0+BA9QBFr1FMuYrzhpsRLNqERw6qiFyM5TsWMKqVKGhGQJBTdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zcIEtuhy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zcIEtuhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69379C4CEE4;
	Mon, 12 May 2025 00:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011035;
	bh=bhCMZW+OAFcTwlbkPvB3mEG4jZFQzbKFHjrFPHePh2E=;
	h=Date:To:From:Subject:From;
	b=zcIEtuhy3T53x+pglkLLwXt2BHYUFmqeNm5tsVSXV943p/0w6Lk3tp/TnnHABdpjb
	 XCCxq3X+oSDuNhAAhi2RKEdU9W+AtwooifpyDMBOJvhU+opPjKO70TbBnN7b4AQth6
	 jmOFJQr/G+MKDixIR+X7pO0atOTDInPS50KIDCyg=
Date: Sun, 11 May 2025 17:50:34 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,kasong@tencent.com,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-free-each-cluster-individually-in-swap_entries_put_map_nr.patch removed from -mm tree
Message-Id: <20250512005035.69379C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: free each cluster individually in swap_entries_put_map_nr()
has been removed from the -mm tree.  Its filename was
     mm-swap-free-each-cluster-individually-in-swap_entries_put_map_nr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: free each cluster individually in swap_entries_put_map_nr()
Date: Wed, 26 Mar 2025 00:25:26 +0800

1. Factor out general swap_entries_put_map() helper to drop entries
   belonging to one cluster.  If entries are last map, free entries in
   batch, otherwise put entries with cluster lock acquired and released
   only once.

2. Iterate and call swap_entries_put_map() for each cluster in
   swap_entries_put_nr() to leverage batch-remove for last map belonging
   to one cluster and reduce lock acquire/release in fallback case.

3. As swap_entries_put_nr() won't handle SWAP_HSA_CACHE drop, rename
   it to swap_entries_put_map_nr().

4. As we won't drop each entry invidually with swap_entry_put() now,
   do reclaim in free_swap_and_cache_nr() because
   swap_entries_put_map_nr() is general routine to drop reference and the
   relcaim work should only be done in free_swap_and_cache_nr().  Remove
   stale comment accordingly.

Link: https://lkml.kernel.org/r/20250325162528.68385-7-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   70 +++++++++++++++++++++---------------------------
 1 file changed, 32 insertions(+), 38 deletions(-)

--- a/mm/swapfile.c~mm-swap-free-each-cluster-individually-in-swap_entries_put_map_nr
+++ a/mm/swapfile.c
@@ -1463,25 +1463,10 @@ put_out:
 	return NULL;
 }
 
-static unsigned char swap_entry_put(struct swap_info_struct *si,
-				    swp_entry_t entry)
-{
-	struct swap_cluster_info *ci;
-	unsigned long offset = swp_offset(entry);
-	unsigned char usage;
-
-	ci = lock_cluster(si, offset);
-	usage = swap_entry_put_locked(si, ci, entry, 1);
-	unlock_cluster(ci);
-
-	return usage;
-}
-
-static bool swap_entries_put_nr(struct swap_info_struct *si,
-				swp_entry_t entry, int nr)
+static bool swap_entries_put_map(struct swap_info_struct *si,
+				 swp_entry_t entry, int nr)
 {
 	unsigned long offset = swp_offset(entry);
-	unsigned int type = swp_type(entry);
 	struct swap_cluster_info *ci;
 	bool has_cache = false;
 	unsigned char count;
@@ -1492,14 +1477,10 @@ static bool swap_entries_put_nr(struct s
 	count = swap_count(data_race(si->swap_map[offset]));
 	if (count != 1 && count != SWAP_MAP_SHMEM)
 		goto fallback;
-	/* cross into another cluster */
-	if (nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER)
-		goto fallback;
 
 	ci = lock_cluster(si, offset);
 	if (!swap_is_last_map(si, offset, nr, &has_cache)) {
-		unlock_cluster(ci);
-		goto fallback;
+		goto locked_fallback;
 	}
 	if (!has_cache)
 		swap_entries_free(si, ci, entry, nr);
@@ -1511,15 +1492,34 @@ static bool swap_entries_put_nr(struct s
 	return has_cache;
 
 fallback:
-	for (i = 0; i < nr; i++) {
-		if (data_race(si->swap_map[offset + i])) {
-			count = swap_entry_put(si, swp_entry(type, offset + i));
-			if (count == SWAP_HAS_CACHE)
-				has_cache = true;
-		} else {
-			WARN_ON_ONCE(1);
-		}
+	ci = lock_cluster(si, offset);
+locked_fallback:
+	for (i = 0; i < nr; i++, entry.val++) {
+		count = swap_entry_put_locked(si, ci, entry, 1);
+		if (count == SWAP_HAS_CACHE)
+			has_cache = true;
+	}
+	unlock_cluster(ci);
+	return has_cache;
+
+}
+
+static bool swap_entries_put_map_nr(struct swap_info_struct *si,
+				    swp_entry_t entry, int nr)
+{
+	int cluster_nr, cluster_rest;
+	unsigned long offset = swp_offset(entry);
+	bool has_cache = false;
+
+	cluster_rest = SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER;
+	while (nr) {
+		cluster_nr = min(nr, cluster_rest);
+		has_cache |= swap_entries_put_map(si, entry, cluster_nr);
+		cluster_rest = SWAPFILE_CLUSTER;
+		nr -= cluster_nr;
+		entry.val += cluster_nr;
 	}
+
 	return has_cache;
 }
 
@@ -1818,7 +1818,7 @@ void free_swap_and_cache_nr(swp_entry_t
 	/*
 	 * First free all entries in the range.
 	 */
-	any_only_cache = swap_entries_put_nr(si, entry, nr);
+	any_only_cache = swap_entries_put_map_nr(si, entry, nr);
 
 	/*
 	 * Short-circuit the below loop if none of the entries had their
@@ -1828,13 +1828,7 @@ void free_swap_and_cache_nr(swp_entry_t
 		goto out;
 
 	/*
-	 * Now go back over the range trying to reclaim the swap cache. This is
-	 * more efficient for large folios because we will only try to reclaim
-	 * the swap once per folio in the common case. If we do
-	 * swap_entry_put() and __try_to_reclaim_swap() in the same loop, the
-	 * latter will get a reference and lock the folio for every individual
-	 * page but will only succeed once the swap slot for every subpage is
-	 * zero.
+	 * Now go back over the range trying to reclaim the swap cache.
 	 */
 	for (offset = start_offset; offset < end_offset; offset += nr) {
 		nr = 1;
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7081A1FBE9E
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743988317; cv=none; b=Jt1zXfj6QGyonHYKouSquglDeDWLjpJIradMRSqh1tMs8jdT9SfKsctR4YOuqHVS8pub179V7MVeYNYdb74+CGDbZM02Vhv2/t9oFtmAM7Xoc0eGOAWP5bCz1dC8+W5iFgzKMWRnepQ7wMgjEh4c+UqYEh2PLl7FUpR86Oqbaao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743988317; c=relaxed/simple;
	bh=VlOtcXBwX+dO4ZqVsy4yfG/hE2KKX/qUjGGmNCfYEHk=;
	h=Date:To:From:Subject:Message-Id; b=hlFaTaTIkXFQzvBPK/sNbaGOahUHy9nGvioM9JNonRB/9/dBh+docuwyX1NR0IBUEaJNfS88zhOL8ZQwy43xBVY0k9ErgtLZ+96Wf8dWNZVJaH/yWXApPsuTOFEjt/tpBdhW5AiUpF6iutLfnPL3zV3oGXuxIDR/o6LS3773XJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IRgBoqgy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IRgBoqgy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A7EC4CEE3;
	Mon,  7 Apr 2025 01:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743988316;
	bh=VlOtcXBwX+dO4ZqVsy4yfG/hE2KKX/qUjGGmNCfYEHk=;
	h=Date:To:From:Subject:From;
	b=IRgBoqgyEzqppokgH1pDooaUqTnSPT9Cmyj1rH4vy4vOiTZ0f2KJlZGYwo+4BPMWW
	 Z3fnicyLOkRfM/ODlC5yQZ+EyWR9rFYWFXM19RDsfMUt4XjaRt7vWyvWNLSa/kJaRm
	 XpwCmH0nQ/czDNXa0dDJ3n860am6JX0v41z0HFug=
Date: Sun, 06 Apr 2025 18:11:56 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,kasong@tencent.com,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-free-each-cluster-individually-in-swap_entries_put_map_nr.patch added to mm-new branch
Message-Id: <20250407011156.D8A7EC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: free each cluster individually in swap_entries_put_map_nr()
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-free-each-cluster-individually-in-swap_entries_put_map_nr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-free-each-cluster-individually-in-swap_entries_put_map_nr.patch

This patch will later appear in the mm-new branch at
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
@@ -1454,25 +1454,10 @@ put_out:
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
@@ -1483,14 +1468,10 @@ static bool swap_entries_put_nr(struct s
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
@@ -1502,15 +1483,34 @@ static bool swap_entries_put_nr(struct s
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
 
@@ -1805,7 +1805,7 @@ void free_swap_and_cache_nr(swp_entry_t
 	/*
 	 * First free all entries in the range.
 	 */
-	any_only_cache = swap_entries_put_nr(si, entry, nr);
+	any_only_cache = swap_entries_put_map_nr(si, entry, nr);
 
 	/*
 	 * Short-circuit the below loop if none of the entries had their
@@ -1815,13 +1815,7 @@ void free_swap_and_cache_nr(swp_entry_t
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

mm-swap-rename-__swap__free-to-swap__put.patch
mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref.patch
mm-swap-use-swap_entries_free-to-free-swap-entry-in-swap_entry_put_locked.patch
mm-swap-use-swap_entries_free-drop-last-ref-count-in-swap_entries_put_nr.patch
mm-swap-drop-last-swap_map_shmem-flag-in-batch-in-swap_entries_put_nr.patch
mm-swap-free-each-cluster-individually-in-swap_entries_put_map_nr.patch
mm-swap-factor-out-helper-to-drop-cache-of-entries-within-a-single-cluster.patch
mm-swap-replace-cluster_swap_free_nr-with-swap_entries_put_.patch


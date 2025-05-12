Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5B5178CF8
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011031; cv=none; b=lGx5avc3xZL5VsrJ7XshWD0Ioy0JQlqAI89I9TT6j4cHEDkNzJ9NfLAr7CHU1ItKtWudy7wCHQHevSQq0HB+x1vQYd/w5VxJBjNF60/0LansjS9xtVfuJG+tRQhFKO2NbQJY42OSHYtBwV2w+b2aWirYHlt1j/dF1y6JVC0PPrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011031; c=relaxed/simple;
	bh=SNJGCas1JydSfcHeTzdgtvI09SKfe3fchG4wcaMzKoo=;
	h=Date:To:From:Subject:Message-Id; b=C/24PkmYsFRHzZJVN987nOi+fCB8InF0YGm1IXnFtcqQD/9qq8PZf1exvp4unR0etIdZXo6Lqes/BysEDe45vT6FGgiHXwN9d1ZBV08GOPoCVFxPqui3KoC10FUVMSTXnMSfL9n6pLWqWyIGSwVHh02fFLXpOLfsuhzqlZDeRm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hqtX2Oos; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hqtX2Oos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA5DC4CEE4;
	Mon, 12 May 2025 00:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011030;
	bh=SNJGCas1JydSfcHeTzdgtvI09SKfe3fchG4wcaMzKoo=;
	h=Date:To:From:Subject:From;
	b=hqtX2Oos7QmaotuZ87Q9JwxLLUQcttXALb6QpyTxySBxm6tLC/Z636nc9DYyU0kAO
	 r/DpQfBlJ9GZQV1wTbJGyNIm2kWxqCmWHo58Yve1mN32bWrtojnTsfkd7r0Jsf6qyB
	 L5F8bLPgCgNz+rmVOG2bDolH9tjgefboMF29Qze4=
Date: Sun, 11 May 2025 17:50:30 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,sj@kernel.org,kasong@tencent.com,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref.patch removed from -mm tree
Message-Id: <20250512005030.BFA5DC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: enable swap_entry_range_free() to drop any kind of last ref
has been removed from the -mm tree.  Its filename was
     mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: enable swap_entry_range_free() to drop any kind of last ref
Date: Wed, 26 Mar 2025 00:25:22 +0800

The original VM_BUG_ON only allows swap_entry_range_free() to drop last
SWAP_HAS_CACHE ref.  By allowing other kind of last ref in VM_BUG_ON,
swap_entry_range_free() could be a more general-purpose function able to
handle all kind of last ref.  Following thi change, also rename
swap_entry_range_free() to swap_entries_free() and update it's comment
accordingly.

This is a preparation to use swap_entries_free() to drop more kind of last
ref other than SWAP_HAS_CACHE.

[shikemeng@huaweicloud.com: add __maybe_unused attribute for swap_is_last_ref() and update comment]
  Link: https://lkml.kernel.org/r/20250410153908.612984-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20250325162528.68385-3-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Tested-by: SeongJae Park <sj@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

--- a/mm/swapfile.c~mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref
+++ a/mm/swapfile.c
@@ -52,9 +52,9 @@
 static bool swap_count_continued(struct swap_info_struct *, pgoff_t,
 				 unsigned char);
 static void free_swap_count_continuations(struct swap_info_struct *);
-static void swap_entry_range_free(struct swap_info_struct *si,
-				  struct swap_cluster_info *ci,
-				  swp_entry_t entry, unsigned int nr_pages);
+static void swap_entries_free(struct swap_info_struct *si,
+			      struct swap_cluster_info *ci,
+			      swp_entry_t entry, unsigned int nr_pages);
 static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
 static bool folio_swapcache_freeable(struct folio *folio);
@@ -1471,7 +1471,7 @@ static unsigned char swap_entry_put(stru
 	ci = lock_cluster(si, offset);
 	usage = swap_entry_put_locked(si, offset, 1);
 	if (!usage)
-		swap_entry_range_free(si, ci, swp_entry(si->type, offset), 1);
+		swap_entries_free(si, ci, swp_entry(si->type, offset), 1);
 	unlock_cluster(ci);
 
 	return usage;
@@ -1501,7 +1501,7 @@ static bool swap_entries_put_nr(struct s
 	for (i = 0; i < nr; i++)
 		WRITE_ONCE(si->swap_map[offset + i], SWAP_HAS_CACHE);
 	if (!has_cache)
-		swap_entry_range_free(si, ci, entry, nr);
+		swap_entries_free(si, ci, entry, nr);
 	unlock_cluster(ci);
 
 	return has_cache;
@@ -1520,12 +1520,22 @@ fallback:
 }
 
 /*
- * Drop the last HAS_CACHE flag of swap entries, caller have to
- * ensure all entries belong to the same cgroup.
+ * Check if it's the last ref of swap entry in the freeing path.
+ * Qualified vlaue includes 1, SWAP_HAS_CACHE or SWAP_MAP_SHMEM.
  */
-static void swap_entry_range_free(struct swap_info_struct *si,
-				  struct swap_cluster_info *ci,
-				  swp_entry_t entry, unsigned int nr_pages)
+static inline bool __maybe_unused swap_is_last_ref(unsigned char count)
+{
+	return (count == SWAP_HAS_CACHE) || (count == 1) ||
+	       (count == SWAP_MAP_SHMEM);
+}
+
+/*
+ * Drop the last ref of swap entries, caller have to ensure all entries
+ * belong to the same cgroup and cluster.
+ */
+static void swap_entries_free(struct swap_info_struct *si,
+			      struct swap_cluster_info *ci,
+			      swp_entry_t entry, unsigned int nr_pages)
 {
 	unsigned long offset = swp_offset(entry);
 	unsigned char *map = si->swap_map + offset;
@@ -1538,7 +1548,7 @@ static void swap_entry_range_free(struct
 
 	ci->count -= nr_pages;
 	do {
-		VM_BUG_ON(*map != SWAP_HAS_CACHE);
+		VM_BUG_ON(!swap_is_last_ref(*map));
 		*map = 0;
 	} while (++map < map_end);
 
@@ -1561,7 +1571,7 @@ static void cluster_swap_free_nr(struct
 	ci = lock_cluster(si, offset);
 	do {
 		if (!swap_entry_put_locked(si, offset, usage))
-			swap_entry_range_free(si, ci, swp_entry(si->type, offset), 1);
+			swap_entries_free(si, ci, swp_entry(si->type, offset), 1);
 	} while (++offset < end);
 	unlock_cluster(ci);
 }
@@ -1604,11 +1614,11 @@ void put_swap_folio(struct folio *folio,
 
 	ci = lock_cluster(si, offset);
 	if (swap_only_has_cache(si, offset, size))
-		swap_entry_range_free(si, ci, entry, size);
+		swap_entries_free(si, ci, entry, size);
 	else {
 		for (int i = 0; i < size; i++, entry.val++) {
 			if (!swap_entry_put_locked(si, offset + i, SWAP_HAS_CACHE))
-				swap_entry_range_free(si, ci, entry, 1);
+				swap_entries_free(si, ci, entry, 1);
 		}
 	}
 	unlock_cluster(ci);
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBD5263F54
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 22:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766268302; cv=none; b=MyX5nuVnJdGCwvSu+YV1WznljWqVnX+WD/a8bpA4aQKzeA8Ld6PSuRd3kWtGd4jHr5f1mWCN9oEQGH1tt3jPd0x6WBLrPJqtMM91SMvgsZQKlXu90ISwyELSHwy5FvHR3vUJ3ct6VdIKkRWORCPVkIX7UbJjK393c1ffsi+CZ5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766268302; c=relaxed/simple;
	bh=XezEk/9G8NxbCXutgYViwV4/7VVSLv0kKk47eJel5aI=;
	h=Date:To:From:Subject:Message-Id; b=CUIs+goeDehsXQX4pAeEFI3l/b8NNxJ/0WYSyvjCK9jc7RHeX1ubKCP1lBDxNKForflbfs6pPnFrXtr9iIY9QEDV1w3+QEPxP7a8aHGK7xIsHPh1LkcPQKs3sNC4P4WeXa9ydMQ9xMJBf1sLMokq3ml2A9YTgSkqF/0/sEZNMg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cU2E5Xvv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cU2E5Xvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71157C4CEF5;
	Sat, 20 Dec 2025 22:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766268301;
	bh=XezEk/9G8NxbCXutgYViwV4/7VVSLv0kKk47eJel5aI=;
	h=Date:To:From:Subject:From;
	b=cU2E5XvvHv41tzDMifByqN81NCxpVU5hzsXZGwP3KrDFgStDMo0uteKa9cgawzrJw
	 MENDPJYLs26afDeg8efzo9qPhUMs10e+06CzPqwf1cfPjqx93NYI+jf/QQOO35N0PA
	 k/k2mYwVFo4/Eb3LwXsyJhrbnNwzPD/MDATLLaQo=
Date: Sat, 20 Dec 2025 14:05:00 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,rafael@kernel.org,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-remove-swap_map_shmem.patch added to mm-new branch
Message-Id: <20251220220501.71157C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem, swap: remove SWAP_MAP_SHMEM
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-swap-remove-swap_map_shmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-remove-swap_map_shmem.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: mm/shmem, swap: remove SWAP_MAP_SHMEM
Date: Sat, 20 Dec 2025 03:43:37 +0800

The SWAP_MAP_SHMEM state was introduced in the commit aaa468653b4a
("swap_info: note SWAP_MAP_SHMEM"), to quickly determine if a swap entry
belongs to shmem during swapoff.

However, swapoff has since been rewritten in the commit b56a2d8af914 ("mm:
rid swapoff of quadratic complexity").  Now having swap count ==
SWAP_MAP_SHMEM value is basically the same as having swap count == 1, and
swap_shmem_alloc() behaves analogously to swap_duplicate().  The only
difference of note is that swap_shmem_alloc() does not check for -ENOMEM
returned from __swap_duplicate(), but it is OK because shmem never
re-duplicates any swap entry it owns.  This will stil be safe if we use
(batched) swap_duplicate() instead.

This commit adds swap_duplicate_nr(), the batched variant of
swap_duplicate(), and removes the SWAP_MAP_SHMEM state and the associated
swap_shmem_alloc() helper to simplify the state machine (both mentally and
in terms of actual code).  We will also have an extra state/special value
that can be repurposed (for swap entries that never gets re-duplicated).

Link: https://lkml.kernel.org/r/20251220-swap-table-p2-v5-8-8862a265a033@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   15 ++++++--------
 mm/shmem.c           |    2 -
 mm/swapfile.c        |   42 ++++++++++++++++-------------------------
 3 files changed, 25 insertions(+), 34 deletions(-)

--- a/include/linux/swap.h~mm-shmem-swap-remove-swap_map_shmem
+++ a/include/linux/swap.h
@@ -230,7 +230,6 @@ enum {
 /* Special value in first swap_map */
 #define SWAP_MAP_MAX	0x3e	/* Max count */
 #define SWAP_MAP_BAD	0x3f	/* Note page is bad */
-#define SWAP_MAP_SHMEM	0xbf	/* Owned by shmem/tmpfs */
 
 /* Special value in each swap_map continuation */
 #define SWAP_CONT_MAX	0x7f	/* Max count */
@@ -458,8 +457,7 @@ bool folio_free_swap(struct folio *folio
 void put_swap_folio(struct folio *folio, swp_entry_t entry);
 extern swp_entry_t get_swap_page_of_type(int);
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
-extern void swap_shmem_alloc(swp_entry_t, int);
-extern int swap_duplicate(swp_entry_t);
+extern int swap_duplicate_nr(swp_entry_t entry, int nr);
 extern int swapcache_prepare(swp_entry_t entry, int nr);
 extern void swap_free_nr(swp_entry_t entry, int nr_pages);
 extern void free_swap_and_cache_nr(swp_entry_t entry, int nr);
@@ -514,11 +512,7 @@ static inline int add_swap_count_continu
 	return 0;
 }
 
-static inline void swap_shmem_alloc(swp_entry_t swp, int nr)
-{
-}
-
-static inline int swap_duplicate(swp_entry_t swp)
+static inline int swap_duplicate_nr(swp_entry_t swp, int nr_pages)
 {
 	return 0;
 }
@@ -569,6 +563,11 @@ static inline int add_swap_extent(struct
 }
 #endif /* CONFIG_SWAP */
 
+static inline int swap_duplicate(swp_entry_t entry)
+{
+	return swap_duplicate_nr(entry, 1);
+}
+
 static inline void free_swap_and_cache(swp_entry_t entry)
 {
 	free_swap_and_cache_nr(entry, 1);
--- a/mm/shmem.c~mm-shmem-swap-remove-swap_map_shmem
+++ a/mm/shmem.c
@@ -1667,7 +1667,7 @@ try_split:
 			spin_unlock(&shmem_swaplist_lock);
 		}
 
-		swap_shmem_alloc(folio->swap, nr_pages);
+		swap_duplicate_nr(folio->swap, nr_pages);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		BUG_ON(folio_mapped(folio));
--- a/mm/swapfile.c~mm-shmem-swap-remove-swap_map_shmem
+++ a/mm/swapfile.c
@@ -201,7 +201,7 @@ static bool swap_is_last_map(struct swap
 	unsigned char *map_end = map + nr_pages;
 	unsigned char count = *map;
 
-	if (swap_count(count) != 1 && swap_count(count) != SWAP_MAP_SHMEM)
+	if (swap_count(count) != 1)
 		return false;
 
 	while (++map < map_end) {
@@ -1523,12 +1523,6 @@ static unsigned char swap_entry_put_lock
 	if (usage == SWAP_HAS_CACHE) {
 		VM_BUG_ON(!has_cache);
 		has_cache = 0;
-	} else if (count == SWAP_MAP_SHMEM) {
-		/*
-		 * Or we could insist on shmem.c using a special
-		 * swap_shmem_free() and free_shmem_swap_and_cache()...
-		 */
-		count = 0;
 	} else if ((count & ~COUNT_CONTINUED) <= SWAP_MAP_MAX) {
 		if (count == COUNT_CONTINUED) {
 			if (swap_count_continued(si, offset, count))
@@ -1626,7 +1620,7 @@ static bool swap_entries_put_map(struct
 	if (nr <= 1)
 		goto fallback;
 	count = swap_count(data_race(si->swap_map[offset]));
-	if (count != 1 && count != SWAP_MAP_SHMEM)
+	if (count != 1)
 		goto fallback;
 
 	ci = swap_cluster_lock(si, offset);
@@ -1680,12 +1674,10 @@ static bool swap_entries_put_map_nr(stru
 
 /*
  * Check if it's the last ref of swap entry in the freeing path.
- * Qualified value includes 1, SWAP_HAS_CACHE or SWAP_MAP_SHMEM.
  */
 static inline bool __maybe_unused swap_is_last_ref(unsigned char count)
 {
-	return (count == SWAP_HAS_CACHE) || (count == 1) ||
-	       (count == SWAP_MAP_SHMEM);
+	return (count == SWAP_HAS_CACHE) || (count == 1);
 }
 
 /*
@@ -3678,7 +3670,6 @@ static int __swap_duplicate(swp_entry_t
 
 	offset = swp_offset(entry);
 	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
-	VM_WARN_ON(usage == 1 && nr > 1);
 	ci = swap_cluster_lock(si, offset);
 
 	err = 0;
@@ -3738,27 +3729,28 @@ unlock_out:
 	return err;
 }
 
-/*
- * Help swapoff by noting that swap entry belongs to shmem/tmpfs
- * (in which case its reference count is never incremented).
- */
-void swap_shmem_alloc(swp_entry_t entry, int nr)
-{
-	__swap_duplicate(entry, SWAP_MAP_SHMEM, nr);
-}
-
-/*
- * Increase reference count of swap entry by 1.
+/**
+ * swap_duplicate_nr() - Increase reference count of nr contiguous swap entries
+ *                       by 1.
+ *
+ * @entry: first swap entry from which we want to increase the refcount.
+ * @nr: Number of entries in range.
+ *
  * Returns 0 for success, or -ENOMEM if a swap_count_continuation is required
  * but could not be atomically allocated.  Returns 0, just as if it succeeded,
  * if __swap_duplicate() fails for another reason (-EINVAL or -ENOENT), which
  * might occur if a page table entry has got corrupted.
+ *
+ * Note that we are currently not handling the case where nr > 1 and we need to
+ * add swap count continuation. This is OK, because no such user exists - shmem
+ * is the only user that can pass nr > 1, and it never re-duplicates any swap
+ * entry it owns.
  */
-int swap_duplicate(swp_entry_t entry)
+int swap_duplicate_nr(swp_entry_t entry, int nr)
 {
 	int err = 0;
 
-	while (!err && __swap_duplicate(entry, 1, 1) == -ENOMEM)
+	while (!err && __swap_duplicate(entry, 1, nr) == -ENOMEM)
 		err = add_swap_count_continuation(entry, GFP_ATOMIC);
 	return err;
 }
_

Patches currently in -mm which might be from nphamcs@gmail.com are

mm-shmem-swap-remove-swap_map_shmem.patch


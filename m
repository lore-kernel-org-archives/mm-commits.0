Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02B41553A3
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011029; cv=none; b=CNq1KNMlZBKdVSGTr3XWJk9nTABsyyQ204R1FTVAox/Ule0bUyTR9kf3koZtS+DIHxeHGk9RgUBwOfZtr/vAH5tSfwiQ3dzM/R6SYB9kbBNedhGnkLBzWJTfaC5wGtPtUV8SsGlqKatwYBJsT28+z5uivHy4IjkSZK1uOLx5zgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011029; c=relaxed/simple;
	bh=W/i8gZH9/2AECW8AEkdm9w0QWHbKkXK99GVxN8o2470=;
	h=Date:To:From:Subject:Message-Id; b=Q1kk2LodTWvASnNKFxkg64w1j3xF7mfTBOlyiB4i1m4JbGxXPTbonXYXktd6whqmlsdvOB8m1Gp4h6vWYutvkOhT/C6NnVjDayNn7TsCocnHhjL1Aau00Uf+Q2eCGHsaQBhVpiWGoSZXDzBe4X2uTIPRFZOTENbVri6c1uZA8x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zUfzgPuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zUfzgPuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94591C4CEE4;
	Mon, 12 May 2025 00:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011029;
	bh=W/i8gZH9/2AECW8AEkdm9w0QWHbKkXK99GVxN8o2470=;
	h=Date:To:From:Subject:From;
	b=zUfzgPuJtAlinNNv7OJ93RE7GLIYluLEL6QqsR3WNmIsyCM2vj/oZ3l1dNc33DfHo
	 /d+6TKS0z2QH9R0s5AGlhLAAsoPxzHZUyQVKYileWF9iLIXK2dNl7Wce9IhrP82VJn
	 1Z5bmF8YxSs9KZQcvCA9SOa7czk4FD8ohXjr1qYs=
Date: Sun, 11 May 2025 17:50:29 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,kasong@tencent.com,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-rename-__swap__free-to-swap__put.patch removed from -mm tree
Message-Id: <20250512005029.94591C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: rename __swap_[entry/entries]_free[_locked] to swap_[entry/entries]_put[_locked]
has been removed from the -mm tree.  Its filename was
     mm-swap-rename-__swap__free-to-swap__put.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: rename __swap_[entry/entries]_free[_locked] to swap_[entry/entries]_put[_locked]
Date: Wed, 26 Mar 2025 00:25:21 +0800

Patch series "Minor cleanups and improvements to swap freeing code", v4.

This series contains some cleanups and improvements which are made
during learning swapfile. Here is a summary of the changes:

1. Function naming improvments.

  - Use "put" instead of "free" to name functions which only do actual
    free when count drops to zero.

  - Use "entry" to name function only frees one swap slot.  Use
    "entries" to name function could may free multi swap slots within one
    cluster.  Use "_nr" suffix to name function which could free multi
    swap slots spanning cross multi clusters.

2. Eliminate the need to set swap slot to intermediate SWAP_HAS_CACHE
   value before do actual free by using swap_entry_range_free()

3. Add helpers swap_entries_put_map() and swap_entries_put_cache() as
   a general-purpose routine to free swap entries within a single cluster
   which will try batch-remove first and fallback to put eatch entry
   indvidually with cluster lock acquired/released only once.  By using
   these helpers, we could remove repeated code, levarage batch-remove in
   more cases and aoivd to acquire/release cluster lock for each single
   swap entry.


This patch (of 8):

In __swap_entry_free[_locked] and __swap_entries_free, we decrease count
first and only free swap entry if count drops to zero.  This behavior is
more akin to a put() operation rather than a free() operation.  Therefore,
rename these functions with "put" instead of "free".  Additionally, add
"_nr" suffix to swap_entries_put to indicate the input range may span swap
clusters.

Link: https://lkml.kernel.org/r/20250325162528.68385-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20250325162528.68385-2-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/mm/swapfile.c~mm-swap-rename-__swap__free-to-swap__put
+++ a/mm/swapfile.c
@@ -1355,9 +1355,9 @@ out:
 	return NULL;
 }
 
-static unsigned char __swap_entry_free_locked(struct swap_info_struct *si,
-					      unsigned long offset,
-					      unsigned char usage)
+static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
+					   unsigned long offset,
+					   unsigned char usage)
 {
 	unsigned char count;
 	unsigned char has_cache;
@@ -1461,15 +1461,15 @@ put_out:
 	return NULL;
 }
 
-static unsigned char __swap_entry_free(struct swap_info_struct *si,
-				       swp_entry_t entry)
+static unsigned char swap_entry_put(struct swap_info_struct *si,
+				    swp_entry_t entry)
 {
 	struct swap_cluster_info *ci;
 	unsigned long offset = swp_offset(entry);
 	unsigned char usage;
 
 	ci = lock_cluster(si, offset);
-	usage = __swap_entry_free_locked(si, offset, 1);
+	usage = swap_entry_put_locked(si, offset, 1);
 	if (!usage)
 		swap_entry_range_free(si, ci, swp_entry(si->type, offset), 1);
 	unlock_cluster(ci);
@@ -1477,8 +1477,8 @@ static unsigned char __swap_entry_free(s
 	return usage;
 }
 
-static bool __swap_entries_free(struct swap_info_struct *si,
-		swp_entry_t entry, int nr)
+static bool swap_entries_put_nr(struct swap_info_struct *si,
+				swp_entry_t entry, int nr)
 {
 	unsigned long offset = swp_offset(entry);
 	unsigned int type = swp_type(entry);
@@ -1509,7 +1509,7 @@ static bool __swap_entries_free(struct s
 fallback:
 	for (i = 0; i < nr; i++) {
 		if (data_race(si->swap_map[offset + i])) {
-			count = __swap_entry_free(si, swp_entry(type, offset + i));
+			count = swap_entry_put(si, swp_entry(type, offset + i));
 			if (count == SWAP_HAS_CACHE)
 				has_cache = true;
 		} else {
@@ -1560,7 +1560,7 @@ static void cluster_swap_free_nr(struct
 
 	ci = lock_cluster(si, offset);
 	do {
-		if (!__swap_entry_free_locked(si, offset, usage))
+		if (!swap_entry_put_locked(si, offset, usage))
 			swap_entry_range_free(si, ci, swp_entry(si->type, offset), 1);
 	} while (++offset < end);
 	unlock_cluster(ci);
@@ -1607,7 +1607,7 @@ void put_swap_folio(struct folio *folio,
 		swap_entry_range_free(si, ci, entry, size);
 	else {
 		for (int i = 0; i < size; i++, entry.val++) {
-			if (!__swap_entry_free_locked(si, offset + i, SWAP_HAS_CACHE))
+			if (!swap_entry_put_locked(si, offset + i, SWAP_HAS_CACHE))
 				swap_entry_range_free(si, ci, entry, 1);
 		}
 	}
@@ -1806,7 +1806,7 @@ void free_swap_and_cache_nr(swp_entry_t
 	/*
 	 * First free all entries in the range.
 	 */
-	any_only_cache = __swap_entries_free(si, entry, nr);
+	any_only_cache = swap_entries_put_nr(si, entry, nr);
 
 	/*
 	 * Short-circuit the below loop if none of the entries had their
@@ -1819,7 +1819,7 @@ void free_swap_and_cache_nr(swp_entry_t
 	 * Now go back over the range trying to reclaim the swap cache. This is
 	 * more efficient for large folios because we will only try to reclaim
 	 * the swap once per folio in the common case. If we do
-	 * __swap_entry_free() and __try_to_reclaim_swap() in the same loop, the
+	 * swap_entry_put() and __try_to_reclaim_swap() in the same loop, the
 	 * latter will get a reference and lock the folio for every individual
 	 * page but will only succeed once the swap slot for every subpage is
 	 * zero.
@@ -3789,7 +3789,7 @@ outer:
  * into, carry if so, or else fail until a new continuation page is allocated;
  * when the original swap_map count is decremented from 0 with continuation,
  * borrow from the continuation and report whether it still holds more.
- * Called while __swap_duplicate() or caller of __swap_entry_free_locked()
+ * Called while __swap_duplicate() or caller of swap_entry_put_locked()
  * holds cluster lock.
  */
 static bool swap_count_continued(struct swap_info_struct *si,
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are



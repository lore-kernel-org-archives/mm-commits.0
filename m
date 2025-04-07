Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742711FBEA8
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743988307; cv=none; b=PM9EYRrX5+OfnVny2WUkOxXjVBK7AaVz9MWxf2XTXXkk0ARQWBCMUIDFIQajIdprsNqfLQoECA63OzIEbzRoF1yAYoKmS1kR8ZGloop4VZvzNgnINA7J/ECuPUHFHWEWAOcDMkMp1PpPLyflz+I+Aq87ZXv5rnkVRdgr9AFnrBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743988307; c=relaxed/simple;
	bh=Q4nN2FiN0EV4pXAUn5yUmBEDLP7L8p42KwKCH93DqiI=;
	h=Date:To:From:Subject:Message-Id; b=CVU4k4hhITDP8Ueg32sbDHZEQ0DQBvmHyl4nCtL0F9RzrarFIdtTVYn78/I/BqNgbd9hOcUC5ohNl1tV1+nmPrSiop0otm/D/40RSWCaMocC1oOTrOEwv8GRfqS3nT0Wh67tiFw0si82xsWyh6rhmYSlQ0wsyUbsBZMSgWWZhUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nmmHkuYv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nmmHkuYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8194C4CEE3;
	Mon,  7 Apr 2025 01:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743988306;
	bh=Q4nN2FiN0EV4pXAUn5yUmBEDLP7L8p42KwKCH93DqiI=;
	h=Date:To:From:Subject:From;
	b=nmmHkuYvG+FSDEavuKdZ1l54mrfdcgqNsLGVwxaQ1No943aL+9cOJsdO06kxTuip4
	 Bi/o3TWuItkJjTxQKS4yQKkIMIR0cX3FeMBqyAvW3ja65rzPiiQwsbGKg1Pfzs1cHl
	 zFGks6/40fa5VsLezgryXTgIUw/MFk40NLYLw98k=
Date: Sun, 06 Apr 2025 18:11:46 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,kasong@tencent.com,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-rename-__swap__free-to-swap__put.patch added to mm-new branch
Message-Id: <20250407011146.C8194C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: rename __swap_[entry/entries]_free[_locked] to swap_[entry/entries]_put[_locked]
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-rename-__swap__free-to-swap__put.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-rename-__swap__free-to-swap__put.patch

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
@@ -1346,9 +1346,9 @@ out:
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
@@ -1452,15 +1452,15 @@ put_out:
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
@@ -1468,8 +1468,8 @@ static unsigned char __swap_entry_free(s
 	return usage;
 }
 
-static bool __swap_entries_free(struct swap_info_struct *si,
-		swp_entry_t entry, int nr)
+static bool swap_entries_put_nr(struct swap_info_struct *si,
+				swp_entry_t entry, int nr)
 {
 	unsigned long offset = swp_offset(entry);
 	unsigned int type = swp_type(entry);
@@ -1500,7 +1500,7 @@ static bool __swap_entries_free(struct s
 fallback:
 	for (i = 0; i < nr; i++) {
 		if (data_race(si->swap_map[offset + i])) {
-			count = __swap_entry_free(si, swp_entry(type, offset + i));
+			count = swap_entry_put(si, swp_entry(type, offset + i));
 			if (count == SWAP_HAS_CACHE)
 				has_cache = true;
 		} else {
@@ -1551,7 +1551,7 @@ static void cluster_swap_free_nr(struct
 
 	ci = lock_cluster(si, offset);
 	do {
-		if (!__swap_entry_free_locked(si, offset, usage))
+		if (!swap_entry_put_locked(si, offset, usage))
 			swap_entry_range_free(si, ci, swp_entry(si->type, offset), 1);
 	} while (++offset < end);
 	unlock_cluster(ci);
@@ -1598,7 +1598,7 @@ void put_swap_folio(struct folio *folio,
 		swap_entry_range_free(si, ci, entry, size);
 	else {
 		for (int i = 0; i < size; i++, entry.val++) {
-			if (!__swap_entry_free_locked(si, offset + i, SWAP_HAS_CACHE))
+			if (!swap_entry_put_locked(si, offset + i, SWAP_HAS_CACHE))
 				swap_entry_range_free(si, ci, entry, 1);
 		}
 	}
@@ -1797,7 +1797,7 @@ void free_swap_and_cache_nr(swp_entry_t
 	/*
 	 * First free all entries in the range.
 	 */
-	any_only_cache = __swap_entries_free(si, entry, nr);
+	any_only_cache = swap_entries_put_nr(si, entry, nr);
 
 	/*
 	 * Short-circuit the below loop if none of the entries had their
@@ -1810,7 +1810,7 @@ void free_swap_and_cache_nr(swp_entry_t
 	 * Now go back over the range trying to reclaim the swap cache. This is
 	 * more efficient for large folios because we will only try to reclaim
 	 * the swap once per folio in the common case. If we do
-	 * __swap_entry_free() and __try_to_reclaim_swap() in the same loop, the
+	 * swap_entry_put() and __try_to_reclaim_swap() in the same loop, the
 	 * latter will get a reference and lock the folio for every individual
 	 * page but will only succeed once the swap slot for every subpage is
 	 * zero.
@@ -3780,7 +3780,7 @@ outer:
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

mm-swap-rename-__swap__free-to-swap__put.patch
mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref.patch
mm-swap-use-swap_entries_free-to-free-swap-entry-in-swap_entry_put_locked.patch
mm-swap-use-swap_entries_free-drop-last-ref-count-in-swap_entries_put_nr.patch
mm-swap-drop-last-swap_map_shmem-flag-in-batch-in-swap_entries_put_nr.patch
mm-swap-free-each-cluster-individually-in-swap_entries_put_map_nr.patch
mm-swap-factor-out-helper-to-drop-cache-of-entries-within-a-single-cluster.patch
mm-swap-replace-cluster_swap_free_nr-with-swap_entries_put_.patch


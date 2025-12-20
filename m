Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C6E271469
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 22:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766268309; cv=none; b=lRNpOHvQ5747ey9wvGf7ilFqV65BfkAmln9C6PvAsGYE747N6YEWXLzp/sTWYEfw0yoPV+Y4CXZBxQKoIfjw2zPZeOifpT3tQR6uVBxOlBalwzbvrYkT8+Q4cN+AkssEo+kqWDFcZ9CIsZPlFPtKMdRbj+agfm8IlNe6/u9lGIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766268309; c=relaxed/simple;
	bh=XR44/FfnqRh2QAfpQag1TQN6Xzo96FBJR+xdMe2vsjk=;
	h=Date:To:From:Subject:Message-Id; b=jNYrqz+XRy5yxX0juDpp69gbKyv1jIZeSYyT2rCZPHZURslJuQs5RgUmdZvSI2TxMKWBSWU4siazySo8CLshQnTS6KEWFvUZ7PKzFTiur9ibGXeTbVnv7FVKQ6WA3jLR/Oh6/d+xZzV424mgWBdVoqgd4wTFUG99oqLCxAu/R0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lr/PomNX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lr/PomNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D46C4CEF5;
	Sat, 20 Dec 2025 22:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766268309;
	bh=XR44/FfnqRh2QAfpQag1TQN6Xzo96FBJR+xdMe2vsjk=;
	h=Date:To:From:Subject:From;
	b=Lr/PomNX9dXPL2mFqAM0Whcyg12AzvB83MJ/G7gwhz2oBhq+McXMFqcEsi93NVpoy
	 8TsoC7EvANKob3Zkj50064qF91tv4AlFwx4kdS4AL8SZs2EydrXABB+F/BZnaY93OL
	 Ma5kTCRil7skLlqIyNkMNghkcsRBQ460aqgj569c=
Date: Sat, 20 Dec 2025 14:05:08 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,rafael@kernel.org,nphamcs@gmail.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-split-locked-entry-duplicating-into-a-standalone-helper.patch added to mm-new branch
Message-Id: <20251220220509.30D46C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: split locked entry duplicating into a standalone helper
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-split-locked-entry-duplicating-into-a-standalone-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-split-locked-entry-duplicating-into-a-standalone-helper.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: split locked entry duplicating into a standalone helper
Date: Sat, 20 Dec 2025 03:43:40 +0800

No feature change, split the common logic into a stand alone helper to be
reused later.

Link: https://lkml.kernel.org/r/20251220-swap-table-p2-v5-11-8862a265a033@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   62 ++++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

--- a/mm/swapfile.c~mm-swap-split-locked-entry-duplicating-into-a-standalone-helper
+++ a/mm/swapfile.c
@@ -3667,26 +3667,14 @@ void si_swapinfo(struct sysinfo *val)
  * - swap-cache reference is requested but the entry is not used. -> ENOENT
  * - swap-mapped reference requested but needs continued swap count. -> ENOMEM
  */
-static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
+static int swap_dup_entries(struct swap_info_struct *si,
+			    struct swap_cluster_info *ci,
+			    unsigned long offset,
+			    unsigned char usage, int nr)
 {
-	struct swap_info_struct *si;
-	struct swap_cluster_info *ci;
-	unsigned long offset;
-	unsigned char count;
-	unsigned char has_cache;
-	int err, i;
+	int i;
+	unsigned char count, has_cache;
 
-	si = swap_entry_to_info(entry);
-	if (WARN_ON_ONCE(!si)) {
-		pr_err("%s%08lx\n", Bad_file, entry.val);
-		return -EINVAL;
-	}
-
-	offset = swp_offset(entry);
-	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
-	ci = swap_cluster_lock(si, offset);
-
-	err = 0;
 	for (i = 0; i < nr; i++) {
 		count = si->swap_map[offset + i];
 
@@ -3694,25 +3682,20 @@ static int __swap_duplicate(swp_entry_t
 		 * For swapin out, allocator never allocates bad slots. for
 		 * swapin, readahead is guarded by swap_entry_swapped.
 		 */
-		if (WARN_ON(swap_count(count) == SWAP_MAP_BAD)) {
-			err = -ENOENT;
-			goto unlock_out;
-		}
+		if (WARN_ON(swap_count(count) == SWAP_MAP_BAD))
+			return -ENOENT;
 
 		has_cache = count & SWAP_HAS_CACHE;
 		count &= ~SWAP_HAS_CACHE;
 
 		if (!count && !has_cache) {
-			err = -ENOENT;
+			return -ENOENT;
 		} else if (usage == SWAP_HAS_CACHE) {
 			if (has_cache)
-				err = -EEXIST;
+				return -EEXIST;
 		} else if ((count & ~COUNT_CONTINUED) > SWAP_MAP_MAX) {
-			err = -EINVAL;
+			return -EINVAL;
 		}
-
-		if (err)
-			goto unlock_out;
 	}
 
 	for (i = 0; i < nr; i++) {
@@ -3731,14 +3714,31 @@ static int __swap_duplicate(swp_entry_t
 			 * Don't need to rollback changes, because if
 			 * usage == 1, there must be nr == 1.
 			 */
-			err = -ENOMEM;
-			goto unlock_out;
+			return -ENOMEM;
 		}
 
 		WRITE_ONCE(si->swap_map[offset + i], count | has_cache);
 	}
 
-unlock_out:
+	return 0;
+}
+
+static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
+{
+	int err;
+	struct swap_info_struct *si;
+	struct swap_cluster_info *ci;
+	unsigned long offset = swp_offset(entry);
+
+	si = swap_entry_to_info(entry);
+	if (WARN_ON_ONCE(!si)) {
+		pr_err("%s%08lx\n", Bad_file, entry.val);
+		return -EINVAL;
+	}
+
+	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
+	ci = swap_cluster_lock(si, offset);
+	err = swap_dup_entries(si, ci, offset, usage, nr);
 	swap_cluster_unlock(ci);
 	return err;
 }
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-rename-__read_swap_cache_async-to-swap_cache_alloc_folio.patch
mm-swap-split-swap-cache-preparation-loop-into-a-standalone-helper.patch
mm-swap-never-bypass-the-swap-cache-even-for-swp_synchronous_io.patch
mm-swap-always-try-to-free-swap-cache-for-swp_synchronous_io-devices.patch
mm-swap-simplify-the-code-and-reduce-indention.patch
mm-swap-free-the-swap-cache-after-folio-is-mapped.patch
mm-shmem-never-bypass-the-swap-cache-for-swp_synchronous_io.patch
mm-swap-swap-entry-of-a-bad-slot-should-not-be-considered-as-swapped-out.patch
mm-swap-consolidate-cluster-reclaim-and-usability-check.patch
mm-swap-split-locked-entry-duplicating-into-a-standalone-helper.patch
mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer.patch
mm-swap-remove-workaround-for-unsynchronized-swap-map-cache-state.patch
mm-swap-cleanup-swap-entry-management-workflow.patch
mm-swap-add-folio-to-swap-cache-directly-on-allocation.patch
mm-swap-check-swap-table-directly-for-checking-cache.patch
mm-swap-clean-up-and-improve-swap-entries-freeing.patch
mm-swap-drop-the-swap_has_cache-flag.patch
mm-swap-remove-no-longer-needed-_swap_info_get.patch


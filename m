Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC441E485
	for <mm-commits@vger.kernel.org>; Sun, 11 May 2025 03:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746934493; cv=none; b=mi6PHE35EV2m59XEulf15l1ptAwaiJhRTFkeJppjxuB0/lPBNSOp6p9wl7Z3KYSmbuzY4oRPbAN+o0dwqfCvnK7FvM6D2XnPqbzaA8mNLcpxW4NF9OO4djsH74S7VOkovgko2x7fpoMiFX8iTIXcIWPzhqQRtTQHyCeO08ic1Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746934493; c=relaxed/simple;
	bh=AWeADXXTnx4ZEhZHC9sq7LQYBwmbqu6hu1G/WZm4GPQ=;
	h=Date:To:From:Subject:Message-Id; b=ueD6tzf/CQFzYfiBbgDs1fJVB24iWXOoCGKzD1U4WH+RdVgaUppqva9Zb1VNEW8VqiUrpN/6JypkvCVjXV+qzVBF6O94q0cr9bx6moAUz3qvsMzZieIxfsJBVCJli969xRGwkObPmaxJHXELxzB90F0Gu5DnulrDnHZEER0VGrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AG0aR00G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AG0aR00G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFE6C4CEE4;
	Sun, 11 May 2025 03:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746934492;
	bh=AWeADXXTnx4ZEhZHC9sq7LQYBwmbqu6hu1G/WZm4GPQ=;
	h=Date:To:From:Subject:From;
	b=AG0aR00GGtVeJRwqb2hi+lqsBF8dqQtQvITspbiNc2pNkqi56xp5vODnNbJZxxBga
	 cOKeD7v5hW8kOqQp1UWMZaobhV6ZApDRDFhR747soGbM6OYFEBLZyoIeg7UkZ7KAsu
	 qsEb6fQSdcsXr6e40ud0qmtr/te2nJV214qUvr54=
Date: Sat, 10 May 2025 20:34:51 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix.patch removed from -mm tree
Message-Id: <20250511033452.1FFE6C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: add __maybe_unused attribute for swap_is_last_ref() and update it's comment
has been removed from the -mm tree.  Its filename was
     mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix.patch

This patch was dropped because it was folded into mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref.patch

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: add __maybe_unused attribute for swap_is_last_ref() and update it's comment
Date: Thu, 10 Apr 2025 23:39:08 +0800

Add __maybe_unused attribute for swap_is_last_ref ()to fix following build
warning:

mm/swapfile.c:1517:20: warning: function 'swap_is_last_ref' is not needed and will not be emitted [-Wunneeded-internal-declaration]
    1517 | static inline bool swap_is_last_ref(unsigned char count)
         |                    ^~~~~~~~~~~~~~~~
   1 warning generated.

Besides, original comment for swap_entries_free() is placed before
swap_is_last_ref() which may introduce confusion.  Update comment to
address this.

Link: https://lkml.kernel.org/r/20250410153908.612984-1-shikemeng@huaweicloud.com
Fixes: 6bb001b6b64e ("mm: swap: enable swap_entry_range_free() to drop any kind of last ref")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Suggested-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Tested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix
+++ a/mm/swapfile.c
@@ -1520,15 +1520,19 @@ fallback:
 }
 
 /*
- * Drop the last ref(1, SWAP_HAS_CACHE or SWAP_MAP_SHMEM) of swap entries,
- * caller have to ensure all entries belong to the same cgroup and cluster.
+ * Check if it's the last ref of swap entry in the freeing path.
+ * Qualified vlaue includes 1, SWAP_HAS_CACHE or SWAP_MAP_SHMEM.
  */
-static inline bool swap_is_last_ref(unsigned char count)
+static inline bool __maybe_unused swap_is_last_ref(unsigned char count)
 {
 	return (count == SWAP_HAS_CACHE) || (count == 1) ||
 	       (count == SWAP_MAP_SHMEM);
 }
 
+/*
+ * Drop the last ref of swap entries, caller have to ensure all entries
+ * belong to the same cgroup and cluster.
+ */
 static void swap_entries_free(struct swap_info_struct *si,
 			      struct swap_cluster_info *ci,
 			      swp_entry_t entry, unsigned int nr_pages)
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


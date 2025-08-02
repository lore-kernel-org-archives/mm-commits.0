Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5697255248
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160878; cv=none; b=CgysXoj0Mn9AG2/EYNlHAfccUNwaPxeseHHzsuvDEWKprO4ZVxPkoLziuEDX7uyU2IiGUUeSe4yRQnDouDgd5C4Ew70I73+r3pPGNOVGeMVpdu4I+2XGPnkLEDhiRzgjAnX8WgDl6nk0sGvovWj5Jq7GN7KxbjYUGedTSs0Qq1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160878; c=relaxed/simple;
	bh=GeP1sKvTF5vp1zcwUjjzKDSGJ9yYtU8EuP7cWDom0DU=;
	h=Date:To:From:Subject:Message-Id; b=G/Bm589bTd8HsCPBbDY2R1i6tJmtW2P4CAQgD5VHr3OY9xKxmcus4qw6EfB1RvaT+cPGT7OxfjjYbCud6iXDXV7JCE56uHcVZ2JQuqx6ewIf3RqzqofOz4kL5WM4vUfy+dm9cUZRVWp1RMqITCiEhu0N8V+utH7QbkG8cWoGGcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NNmwQbrs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NNmwQbrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B997BC4CEEF;
	Sat,  2 Aug 2025 18:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160877;
	bh=GeP1sKvTF5vp1zcwUjjzKDSGJ9yYtU8EuP7cWDom0DU=;
	h=Date:To:From:Subject:From;
	b=NNmwQbrsUIcgq0ACsVaph/EeOtu8Qviy9E5rJedsfU58JSBn2BPAtqxuyWULGm3q3
	 iWsYbJACfPlgALDEEtph1fNeFcB3mlVCx+BtJMobU46Wa3PUku5edlhVAc3VD5ZQH1
	 fefLqNzTnegsvjAPEnsSyX/XDm8N5ngnNclmmyGs=
Date: Sat, 02 Aug 2025 11:54:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch removed from -mm tree
Message-Id: <20250802185437.B997BC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem, swap: avoid redundant Xarray lookup during swapin
has been removed from the -mm tree.  Its filename was
     mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/shmem, swap: avoid redundant Xarray lookup during swapin
Date: Mon, 28 Jul 2025 15:53:00 +0800

Patch series "mm/shmem, swap: bugfix and improvement of mTHP swap in", v6.

The current THP swapin path have several problems.  It may potentially
hang, may cause redundant faults due to false positive swap cache lookup,
and it issues redundant Xarray walks.  !CONFIG_TRANSPARENT_HUGEPAGE builds
may also contain unnecessary THP checks.

This series fixes all of the mentioned issues, the code should be more
robust and prepared for the swap table series.  Now 4 walks is reduced to
3 (get order & confirm, confirm, insert folio),
!CONFIG_TRANSPARENT_HUGEPAGE build overhead is also minimized, and comes
with a sanity check now.

The performance is slightly better after this series, sequential swap in
of 24G data from ZRAM, using transparent_hugepage_tmpfs=always (24 samples
each):

Before:         avg: 10.66s, stddev: 0.04
After patch 1:  avg: 10.58s, stddev: 0.04
After patch 2:  avg: 10.65s, stddev: 0.05
After patch 3:  avg: 10.65s, stddev: 0.04
After patch 4:  avg: 10.67s, stddev: 0.04
After patch 5:  avg: 9.79s,  stddev: 0.04
After patch 6:  avg: 9.79s,  stddev: 0.05
After patch 7:  avg: 9.78s,  stddev: 0.05
After patch 8:  avg: 9.79s,  stddev: 0.04

Several patches improve the performance by a little, which is about ~8%
faster in total.

Build kernel test showed very slightly improvement, testing with make -j48
with defconfig in a 768M memcg also using ZRAM as swap, and
transparent_hugepage_tmpfs=always (6 test runs):

Before:         avg: 3334.66s, stddev: 43.76
After patch 1:  avg: 3349.77s, stddev: 18.55
After patch 2:  avg: 3325.01s, stddev: 42.96
After patch 3:  avg: 3354.58s, stddev: 14.62
After patch 4:  avg: 3336.24s, stddev: 32.15
After patch 5:  avg: 3325.13s, stddev: 22.14
After patch 6:  avg: 3285.03s, stddev: 38.95
After patch 7:  avg: 3287.32s, stddev: 26.37
After patch 8:  avg: 3295.87s, stddev: 46.24


This patch (of 7):

Currently shmem calls xa_get_order to get the swap radix entry order,
requiring a full tree walk.  This can be easily combined with the swap
entry value checking (shmem_confirm_swap) to avoid the duplicated lookup
and abort early if the entry is gone already.  Which should improve the
performance.

Link: https://lkml.kernel.org/r/20250728075306.12704-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20250728075306.12704-3-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin
+++ a/mm/shmem.c
@@ -512,15 +512,27 @@ static int shmem_replace_entry(struct ad
 
 /*
  * Sometimes, before we decide whether to proceed or to fail, we must check
- * that an entry was not already brought back from swap by a racing thread.
+ * that an entry was not already brought back or split by a racing thread.
  *
  * Checking folio is not enough: by the time a swapcache folio is locked, it
  * might be reused, and again be swapcache, using the same swap as before.
+ * Returns the swap entry's order if it still presents, else returns -1.
  */
-static bool shmem_confirm_swap(struct address_space *mapping,
-			       pgoff_t index, swp_entry_t swap)
+static int shmem_confirm_swap(struct address_space *mapping, pgoff_t index,
+			      swp_entry_t swap)
 {
-	return xa_load(&mapping->i_pages, index) == swp_to_radix_entry(swap);
+	XA_STATE(xas, &mapping->i_pages, index);
+	int ret = -1;
+	void *entry;
+
+	rcu_read_lock();
+	do {
+		entry = xas_load(&xas);
+		if (entry == swp_to_radix_entry(swap))
+			ret = xas_get_order(&xas);
+	} while (xas_retry(&xas, entry));
+	rcu_read_unlock();
+	return ret;
 }
 
 /*
@@ -2293,16 +2305,20 @@ static int shmem_swapin_folio(struct ino
 		return -EIO;
 
 	si = get_swap_device(swap);
-	if (!si) {
-		if (!shmem_confirm_swap(mapping, index, swap))
+	order = shmem_confirm_swap(mapping, index, swap);
+	if (unlikely(!si)) {
+		if (order < 0)
 			return -EEXIST;
 		else
 			return -EINVAL;
 	}
+	if (unlikely(order < 0)) {
+		put_swap_device(si);
+		return -EEXIST;
+	}
 
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
-	order = xa_get_order(&mapping->i_pages, index);
 	if (!folio) {
 		int nr_pages = 1 << order;
 		bool fallback_order0 = false;
@@ -2412,7 +2428,7 @@ alloced:
 	 */
 	folio_lock(folio);
 	if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
-	    !shmem_confirm_swap(mapping, index, swap) ||
+	    shmem_confirm_swap(mapping, index, swap) < 0 ||
 	    folio->swap.val != swap.val) {
 		error = -EEXIST;
 		goto unlock;
@@ -2460,7 +2476,7 @@ alloced:
 	*foliop = folio;
 	return 0;
 failed:
-	if (!shmem_confirm_swap(mapping, index, swap))
+	if (shmem_confirm_swap(mapping, index, swap) < 0)
 		error = -EEXIST;
 	if (error == -EIO)
 		shmem_set_folio_swapin_error(inode, index, folio, swap,
_

Patches currently in -mm which might be from kasong@tencent.com are



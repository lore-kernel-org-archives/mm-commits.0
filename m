Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48436217F33
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188466; cv=none; b=evEa+avx0zPQk6mzpHg77fgNhXpOWISm0ULJq3/JyvcfEokeXajchGAA0dfvjxKVtxuGEyPk6vIdTk+R31V8WfVexHoZAsUycsAmaWw1/HDimjelY46b5XOvBZxL5NYnhfCU3CpAVNeXvdSL2R/D9IMTRmhQ/FudCF0rHoKPFyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188466; c=relaxed/simple;
	bh=78c5t4Jyqbn71MQ0JIHNpkRQQXHgHMdM3/O38mLv4yg=;
	h=Date:To:From:Subject:Message-Id; b=CJiTXro6jwuZuXDnlIaNssRXOOEMtcz6DLvHs9Bxki7frVYgTzRESzW2rgKjluZ1F9RfUAGJw9cl9tq5kCUQ+krbzu0ErS9c49bi6JvFYVsOxexLlYqiGy357ecN68/wC4RwPeICfticoGUjEPbJruLQSYdNqtnBiFYn2ApaivE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=merwtk6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="merwtk6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D353C4CEEC;
	Mon, 17 Mar 2025 05:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188466;
	bh=78c5t4Jyqbn71MQ0JIHNpkRQQXHgHMdM3/O38mLv4yg=;
	h=Date:To:From:Subject:From;
	b=merwtk6HAGXBplNyzpjPzwrXqqH7mE57vxdDfYAhMooVUHwqeq0nwUcLDAA5t40Lz
	 z6SicMREKhH1VvMHb3VSJjwEpQBei14npbhjsA2lv+HKNSaSB3UtugxqtC27hfm7xE
	 YGBWcFQfTW9U+TdDNp7IzOxpV5vL+ugZHDvXXczc=
Date: Sun, 16 Mar 2025 22:14:25 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,v-songbaohua@oppo.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-avoid-redundant-swap-device-pinning.patch removed from -mm tree
Message-Id: <20250317051426.1D353C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: avoid redundant swap device pinning
has been removed from the -mm tree.  Its filename was
     mm-swap-avoid-redundant-swap-device-pinning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: avoid redundant swap device pinning
Date: Fri, 14 Mar 2025 00:59:31 +0800

Currently __read_swap_cache_async() has get/put_swap_device() calls to
increase/decrease a swap device reference to prevent swapoff.  While some
of its callers have already held the swap device reference, e.g in
do_swap_page() and shmem_swapin_folio() where __read_swap_cache_async()
will finally called.  Now there are only two callers not holding a swap
device reference, so make them hold a reference instead.  And drop the
get/put_swap_device calls in __read_swap_cache_async.  This should reduce
the overhead for swap in during page fault slightly.

Link: https://lkml.kernel.org/r/20250313165935.63303-4-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   14 ++++++++------
 mm/zswap.c      |    8 +++++++-
 2 files changed, 15 insertions(+), 7 deletions(-)

--- a/mm/swap_state.c~mm-swap-avoid-redundant-swap-device-pinning
+++ a/mm/swap_state.c
@@ -426,17 +426,13 @@ struct folio *__read_swap_cache_async(sw
 		struct mempolicy *mpol, pgoff_t ilx, bool *new_page_allocated,
 		bool skip_if_exists)
 {
-	struct swap_info_struct *si;
+	struct swap_info_struct *si = swp_swap_info(entry);
 	struct folio *folio;
 	struct folio *new_folio = NULL;
 	struct folio *result = NULL;
 	void *shadow = NULL;
 
 	*new_page_allocated = false;
-	si = get_swap_device(entry);
-	if (!si)
-		return NULL;
-
 	for (;;) {
 		int err;
 		/*
@@ -532,7 +528,6 @@ fail_unlock:
 	put_swap_folio(new_folio, entry);
 	folio_unlock(new_folio);
 put_and_return:
-	put_swap_device(si);
 	if (!(*new_page_allocated) && new_folio)
 		folio_put(new_folio);
 	return result;
@@ -552,11 +547,16 @@ struct folio *read_swap_cache_async(swp_
 		struct vm_area_struct *vma, unsigned long addr,
 		struct swap_iocb **plug)
 {
+	struct swap_info_struct *si;
 	bool page_allocated;
 	struct mempolicy *mpol;
 	pgoff_t ilx;
 	struct folio *folio;
 
+	si = get_swap_device(entry);
+	if (!si)
+		return NULL;
+
 	mpol = get_vma_policy(vma, addr, 0, &ilx);
 	folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
 					&page_allocated, false);
@@ -564,6 +564,8 @@ struct folio *read_swap_cache_async(swp_
 
 	if (page_allocated)
 		swap_read_folio(folio, plug);
+
+	put_swap_device(si);
 	return folio;
 }
 
--- a/mm/zswap.c~mm-swap-avoid-redundant-swap-device-pinning
+++ a/mm/zswap.c
@@ -1051,14 +1051,20 @@ static int zswap_writeback_entry(struct
 	struct folio *folio;
 	struct mempolicy *mpol;
 	bool folio_was_allocated;
+	struct swap_info_struct *si;
 	struct writeback_control wbc = {
 		.sync_mode = WB_SYNC_NONE,
 	};
 
 	/* try to allocate swap cache folio */
+	si = get_swap_device(swpentry);
+	if (!si)
+		return -EEXIST;
+
 	mpol = get_task_policy(current);
 	folio = __read_swap_cache_async(swpentry, GFP_KERNEL, mpol,
-				NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
+			NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
+	put_swap_device(si);
 	if (!folio)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from kasong@tencent.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4E35B211
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 03:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740454002; cv=none; b=XBI7czEWNZY0+wWeTCMaCiNKY+mImI0BS4kTX6f8/aYNj8GdPYVewqviCbVz+3/jZXvhUpAD1jeW9KZVUD9w/3cNl92TH8IoCEF+LmpNcgZsGQtOa8cSdyvINB5HwDiewYXzSLtfwFKMI7bsQ1w8Cxtw98XT+XQ4Rv4ftVeyEUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740454002; c=relaxed/simple;
	bh=3F1KY3xg9Ff9JDmcn4O2XbXhfHLK0Va2p1enjgU/xDc=;
	h=Date:To:From:Subject:Message-Id; b=kUsE11YWmXePKHWB3rkqO20VzXR4IShIiPy4MOMmZrgKpxbUk644MtoYla7i1PzCf0MGFYGd5tyfq7ec0Nbog8HKFy2ZTGV8fNCTLNnQLvktMj0hDzY3K0qo78LHSTZ26o4vf+bvhh0puI4LJaruxsHQ1RakpIGli/UVE6FOEjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cYLC8ESW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cYLC8ESW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C7AC4CED6;
	Tue, 25 Feb 2025 03:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740454001;
	bh=3F1KY3xg9Ff9JDmcn4O2XbXhfHLK0Va2p1enjgU/xDc=;
	h=Date:To:From:Subject:From;
	b=cYLC8ESW+imSXwqpwCgEwQmyQazPX2ApI7LIhydIPm81hE/YPuncUFWdzaUv3HHeU
	 5Zb//jwvpU6aXnhT9LmXB35+Ck08lgADY7xNAqJeF3CAsgwiQP5O6mk+SLIGkBQR8L
	 TwxgZHbhq5CiEhsBO/9zU32PfbdMx+FThNaW8I6w=
Date: Mon, 24 Feb 2025 19:26:41 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,v-songbaohua@oppo.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-avoid-redundant-swap-device-pinning.patch added to mm-unstable branch
Message-Id: <20250225032641.89C7AC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: avoid redundant swap device pinning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-avoid-redundant-swap-device-pinning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-avoid-redundant-swap-device-pinning.patch

This patch will later appear in the mm-unstable branch at
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
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: avoid redundant swap device pinning
Date: Tue, 25 Feb 2025 02:02:08 +0800

Currently __read_swap_cache_async() has get/put_swap_device() calls to
increase/decrease a swap device reference to prevent swapoff.  While some
of its callers have already held the swap device reference, e.g in
do_swap_page() and shmem_swapin_folio() where __read_swap_cache_async()
will finally called.  Now there are only two callers not holding a swap
device reference, so make them hold a reference instead.  And drop the
get/put_swap_device calls in __read_swap_cache_async.  This should reduce
the overhead for swap in during page fault slightly.

Link: https://lkml.kernel.org/r/20250224180212.22802-4-ryncsn@gmail.com
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
 mm/zswap.c      |    6 ++++++
 2 files changed, 14 insertions(+), 6 deletions(-)

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
 				NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
+	put_swap_device(si);
 	if (!folio)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-avoid-reclaiming-irrelevant-swap-cache.patch
mm-swap-drop-the-flag-ttrs_direct.patch
mm-swap-avoid-redundant-swap-device-pinning.patch
mm-swap-dont-update-the-counter-up-front.patch
mm-swap-use-percpu-cluster-as-allocation-fast-path.patch
mm-swap-remove-swap-slot-cache.patch
mm-swap-simplify-folio-swap-allocation.patch


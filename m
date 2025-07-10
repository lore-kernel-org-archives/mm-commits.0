Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C76B660
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 03:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752119227; cv=none; b=eTy+k71VmpASj+I267erwxk2sfYL8i2/xevrMvBStcTBTnLvXIaQBAaLgAS+r6lCHB7seIosGo9aoTAyJAzTk/yLvb8oTuuU3ungMUog0oPdXnrPw3hVDQusI5jxSS6EQwBAZaZqAhkKrEulZR77jv4Q5hcHdbYZ85XRTefNJFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752119227; c=relaxed/simple;
	bh=umcpM51Fk5y7Knl9j3dTAiMla18VkjRZgzWWXJLKBY8=;
	h=Date:To:From:Subject:Message-Id; b=HLjX0aHZ4F1EdYDHNRI3A5WePJpIIGWxJbn0wlhKrn2h/17OO9Qz8Rgx40fqqHuOwFwtbYrZI2EsckojGasKyrN6M6MW6HkJ6WyG8G6vR2lTWScIUAzmndC5gbNq91nXXAnju8EwP6l0TUEllcFwBeTgaaBpWKSzFU1+/H4ehXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aSAaW4UK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aSAaW4UK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554E1C4CEE3;
	Thu, 10 Jul 2025 03:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752119227;
	bh=umcpM51Fk5y7Knl9j3dTAiMla18VkjRZgzWWXJLKBY8=;
	h=Date:To:From:Subject:From;
	b=aSAaW4UK5nna+vWQrjcUgJVxsVcNK02MI+IUhWAySJmAlMAIvqB197SQP4diPLSNN
	 8FXHnmXiYg93awtK/bBWBw7/YhDUCu3V0TKW5e385STh2kdT0mu4IQQshGSD5+mMap
	 ulgxU+Bisd99jFrJp9D/UqbSsAp8zl6VN6AWbT5o=
Date: Wed, 09 Jul 2025 20:47:06 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch added to mm-new branch
Message-Id: <20250710034707.554E1C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem, swap: avoid redundant Xarray lookup during swapin
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm/shmem, swap: avoid redundant Xarray lookup during swapin
Date: Thu, 10 Jul 2025 11:37:00 +0800

Currently shmem calls xa_get_order to get the swap radix entry order,
requiring a full tree walk.  This can be easily combined with the swap
entry value checking (shmem_confirm_swap) to avoid the duplicated lookup,
which should improve the performance.

Link: https://lkml.kernel.org/r/20250710033706.71042-3-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin
+++ a/mm/shmem.c
@@ -505,15 +505,27 @@ static int shmem_replace_entry(struct ad
 
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
@@ -2256,16 +2268,20 @@ static int shmem_swapin_folio(struct ino
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
@@ -2415,7 +2431,7 @@ alloced:
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

mm-list_lru-refactor-the-locking-code.patch
mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hung.patch
mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
mm-shmem-swap-tidy-up-thp-swapin-checks.patch
mm-shmem-swap-tidy-up-swap-entry-splitting.patch
mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling.patch
mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin.patch
mm-shmem-swap-fix-major-fault-counting.patch


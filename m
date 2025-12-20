Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D482FE078
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 22:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766268294; cv=none; b=nUKazJhni4ifPq2r8R/TK5HxiSe9Pw+v7hYHCeoP03Z2RWk5G6pLaW66no3cthqdvjizjp219ZECXDz/opuL9EDGWIys8Nax32ROI7IssRLNP/sAaPK51RB5PIruvg8ZvxbIhVxaMJLL4WhtY3yDQfQJlC6q/dkkrEmCAjCWb7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766268294; c=relaxed/simple;
	bh=tCZ1GYKVKMc8+L4kLlObk40N8ur4UIKfU7a5r2VId48=;
	h=Date:To:From:Subject:Message-Id; b=Vwa0WeJmxvWAjKQzh/TCpsG3ttGIlcH+dFt2xsoYwCueiBKMqxip6RAEGFpjqmP64YnjgpUjfsB9cfOC1dC4cML7A8jhVlyOIyGuPd1Z3XbGkNuyiOpkCRRbYLKY9m2obMBpyZgZFyoL08wePI/yByHCwjg6jeEC6/xzp47fOiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=esJBJQPv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="esJBJQPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE3BC4CEF5;
	Sat, 20 Dec 2025 22:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766268294;
	bh=tCZ1GYKVKMc8+L4kLlObk40N8ur4UIKfU7a5r2VId48=;
	h=Date:To:From:Subject:From;
	b=esJBJQPvblvEoXxwyGIe2tEaK9TLMp6BjMWgmZekWj0bOnWgS61dVPHeQZidD6I2z
	 rJOTCvW61FY5++ouyPXHzMELbvCz9kd8rSzaSHSxk3Q/GpGz/RUHKNlJCSZU5cVU6w
	 E/LojjB+raaDWF4jAoUHtWsk1Eut+uylMbbp4JjM=
Date: Sat, 20 Dec 2025 14:04:53 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,rafael@kernel.org,nphamcs@gmail.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-simplify-the-code-and-reduce-indention.patch added to mm-new branch
Message-Id: <20251220220454.2AE3BC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: simplify the code and reduce indention
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-simplify-the-code-and-reduce-indention.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-simplify-the-code-and-reduce-indention.patch

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
Subject: mm, swap: simplify the code and reduce indention
Date: Sat, 20 Dec 2025 03:43:34 +0800

Now swap cache is always used, multiple swap cache checks are no longer
useful, remove them and reduce the code indention.

No behavior change.

Link: https://lkml.kernel.org/r/20251220-swap-table-p2-v5-5-8862a265a033@tencent.com
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

 mm/memory.c |   89 ++++++++++++++++++++++++--------------------------
 1 file changed, 43 insertions(+), 46 deletions(-)

--- a/mm/memory.c~mm-swap-simplify-the-code-and-reduce-indention
+++ a/mm/memory.c
@@ -4764,55 +4764,52 @@ vm_fault_t do_swap_page(struct vm_fault
 		goto out_release;
 
 	page = folio_file_page(folio, swp_offset(entry));
-	if (swapcache) {
-		/*
-		 * Make sure folio_free_swap() or swapoff did not release the
-		 * swapcache from under us.  The page pin, and pte_same test
-		 * below, are not enough to exclude that.  Even if it is still
-		 * swapcache, we need to check that the page's swap has not
-		 * changed.
-		 */
-		if (unlikely(!folio_matches_swap_entry(folio, entry)))
-			goto out_page;
-
-		if (unlikely(PageHWPoison(page))) {
-			/*
-			 * hwpoisoned dirty swapcache pages are kept for killing
-			 * owner processes (which may be unknown at hwpoison time)
-			 */
-			ret = VM_FAULT_HWPOISON;
-			goto out_page;
-		}
-
-		/*
-		 * KSM sometimes has to copy on read faults, for example, if
-		 * folio->index of non-ksm folios would be nonlinear inside the
-		 * anon VMA -- the ksm flag is lost on actual swapout.
-		 */
-		folio = ksm_might_need_to_copy(folio, vma, vmf->address);
-		if (unlikely(!folio)) {
-			ret = VM_FAULT_OOM;
-			folio = swapcache;
-			goto out_page;
-		} else if (unlikely(folio == ERR_PTR(-EHWPOISON))) {
-			ret = VM_FAULT_HWPOISON;
-			folio = swapcache;
-			goto out_page;
-		}
-		if (folio != swapcache)
-			page = folio_page(folio, 0);
+	/*
+	 * Make sure folio_free_swap() or swapoff did not release the
+	 * swapcache from under us.  The page pin, and pte_same test
+	 * below, are not enough to exclude that.  Even if it is still
+	 * swapcache, we need to check that the page's swap has not
+	 * changed.
+	 */
+	if (unlikely(!folio_matches_swap_entry(folio, entry)))
+		goto out_page;
 
+	if (unlikely(PageHWPoison(page))) {
 		/*
-		 * If we want to map a page that's in the swapcache writable, we
-		 * have to detect via the refcount if we're really the exclusive
-		 * owner. Try removing the extra reference from the local LRU
-		 * caches if required.
+		 * hwpoisoned dirty swapcache pages are kept for killing
+		 * owner processes (which may be unknown at hwpoison time)
 		 */
-		if ((vmf->flags & FAULT_FLAG_WRITE) && folio == swapcache &&
-		    !folio_test_ksm(folio) && !folio_test_lru(folio))
-			lru_add_drain();
+		ret = VM_FAULT_HWPOISON;
+		goto out_page;
 	}
 
+	/*
+	 * KSM sometimes has to copy on read faults, for example, if
+	 * folio->index of non-ksm folios would be nonlinear inside the
+	 * anon VMA -- the ksm flag is lost on actual swapout.
+	 */
+	folio = ksm_might_need_to_copy(folio, vma, vmf->address);
+	if (unlikely(!folio)) {
+		ret = VM_FAULT_OOM;
+		folio = swapcache;
+		goto out_page;
+	} else if (unlikely(folio == ERR_PTR(-EHWPOISON))) {
+		ret = VM_FAULT_HWPOISON;
+		folio = swapcache;
+		goto out_page;
+	} else if (folio != swapcache)
+		page = folio_page(folio, 0);
+
+	/*
+	 * If we want to map a page that's in the swapcache writable, we
+	 * have to detect via the refcount if we're really the exclusive
+	 * owner. Try removing the extra reference from the local LRU
+	 * caches if required.
+	 */
+	if ((vmf->flags & FAULT_FLAG_WRITE) &&
+	    !folio_test_ksm(folio) && !folio_test_lru(folio))
+		lru_add_drain();
+
 	folio_throttle_swaprate(folio, GFP_KERNEL);
 
 	/*
@@ -5002,7 +4999,7 @@ check_folio:
 			pte, pte, nr_pages);
 
 	folio_unlock(folio);
-	if (folio != swapcache && swapcache) {
+	if (unlikely(folio != swapcache)) {
 		/*
 		 * Hold the lock to avoid the swap entry to be reused
 		 * until we take the PT lock for the pte_same() check
@@ -5040,7 +5037,7 @@ out_page:
 	folio_unlock(folio);
 out_release:
 	folio_put(folio);
-	if (folio != swapcache && swapcache) {
+	if (folio != swapcache) {
 		folio_unlock(swapcache);
 		folio_put(swapcache);
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


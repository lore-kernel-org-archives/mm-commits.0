Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719D124169D
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 22:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766268296; cv=none; b=emABkCGOEvXXWWRpWLMmNfjYTG1OJAQLllsv3O8KLKBRxd27MgjNXFaJo2D5BC1IY3uukFKjSV4i8Q76R+/dwm/jdioQIdPDtteMTsLNaapFwn+X0rneO2PQFCiRYNmqsfGOoFlHp4hE8+vNXdibfuH6rU5qVWs9O73qwKPy2FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766268296; c=relaxed/simple;
	bh=83rzpa5qu5SSHIuCxCU06KRkY4v+BipHteXigDzhYK0=;
	h=Date:To:From:Subject:Message-Id; b=oX3UHkUxlisEeI86jyoyIQVayYpsCEblRNfLb+Kdvc5UAnVnzpqkkPfxEaKOIB6aoq4+eUbqRYhkdG+LRKkM+EZ8FetHazoRmdaPxhdoxGy/N4PxDZWwm2XbtERLGMu1qdgfKoqmVjpLH7vWEZKMnXar630nxtkV9ATH4Sw1ZSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hVoPu7HH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hVoPu7HH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4322FC4CEF5;
	Sat, 20 Dec 2025 22:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766268296;
	bh=83rzpa5qu5SSHIuCxCU06KRkY4v+BipHteXigDzhYK0=;
	h=Date:To:From:Subject:From;
	b=hVoPu7HHvDyuEGhOx4/jj6aiANGQmUHJkJKKFNkFmlidnguc4QB09qrZVDcRwlRxW
	 pkt3FUo6LOzWFigAOp9Dtlra1kkmIeg8k3AfYnIHuHMv1PIT7xjeu5Oo4jZTqWkgiV
	 jCHhwOwjXEINwEC7YXrqPBNp2Mwk3omFs2fyYvBw=
Date: Sat, 20 Dec 2025 14:04:55 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,rafael@kernel.org,nphamcs@gmail.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-free-the-swap-cache-after-folio-is-mapped.patch added to mm-new branch
Message-Id: <20251220220456.4322FC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: free the swap cache after folio is mapped
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-free-the-swap-cache-after-folio-is-mapped.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-free-the-swap-cache-after-folio-is-mapped.patch

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
Subject: mm, swap: free the swap cache after folio is mapped
Date: Sat, 20 Dec 2025 03:43:35 +0800

Currently, we remove the folio from the swap cache and free the swap cache
before mapping the PTE.  To reduce repeated faults due to parallel swapins
of the same PTE, change it to remove the folio from the swap cache after
it is mapped.  So new faults from the swap PTE will be much more likely to
see the folio in the swap cache and wait on it.

This does not eliminate all swapin races: an ongoing swapin fault may
still see an empty swap cache.  That's harmless, as the PTE is changed
before the swap cache is cleared, so it will just return and not trigger
any repeated faults.  This does help to reduce the chance.

Link: https://lkml.kernel.org/r/20251220-swap-table-p2-v5-6-8862a265a033@tencent.com
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

 mm/memory.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/mm/memory.c~mm-swap-free-the-swap-cache-after-folio-is-mapped
+++ a/mm/memory.c
@@ -4362,6 +4362,7 @@ static vm_fault_t remove_device_exclusiv
 static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 					   struct folio *folio,
 					   struct vm_area_struct *vma,
+					   unsigned int extra_refs,
 					   unsigned int fault_flags)
 {
 	if (!folio_test_swapcache(folio))
@@ -4384,7 +4385,7 @@ static inline bool should_try_to_free_sw
 	 * reference only in case it's likely that we'll be the exclusive user.
 	 */
 	return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio) &&
-		folio_ref_count(folio) == (1 + folio_nr_pages(folio));
+		folio_ref_count(folio) == (extra_refs + folio_nr_pages(folio));
 }
 
 static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
@@ -4936,15 +4937,6 @@ check_folio:
 	 */
 	arch_swap_restore(folio_swap(entry, folio), folio);
 
-	/*
-	 * Remove the swap entry and conditionally try to free up the swapcache.
-	 * We're already holding a reference on the page but haven't mapped it
-	 * yet.
-	 */
-	swap_free_nr(entry, nr_pages);
-	if (should_try_to_free_swap(si, folio, vma, vmf->flags))
-		folio_free_swap(folio);
-
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
 	add_mm_counter(vma->vm_mm, MM_SWAPENTS, -nr_pages);
 	pte = mk_pte(page, vma->vm_page_prot);
@@ -4998,6 +4990,15 @@ check_folio:
 	arch_do_swap_page_nr(vma->vm_mm, vma, address,
 			pte, pte, nr_pages);
 
+	/*
+	 * Remove the swap entry and conditionally try to free up the swapcache.
+	 * Do it after mapping, so raced page faults will likely see the folio
+	 * in swap cache and wait on the folio lock.
+	 */
+	swap_free_nr(entry, nr_pages);
+	if (should_try_to_free_swap(si, folio, vma, nr_pages, vmf->flags))
+		folio_free_swap(folio);
+
 	folio_unlock(folio);
 	if (unlikely(folio != swapcache)) {
 		/*
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


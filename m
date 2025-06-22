Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E52542AAF;
	Sun, 22 Jun 2025 21:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750628925; cv=none; b=HV5XUbPBOJ0QxxzzxuqywoPHJCHv9fT7ePpJp+FJyiZSFUOe3cFsdzzgt57RMqzuYEgbuOgvUdJLaCYEvkavAmdOZbqpIMRzW2vv3ANVrcLFddL4C3giJ7ekl699ZHNm6wO/fEKLwZNLBsx79AOoGxAlhqC4IW4yJHRhRXAFpfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750628925; c=relaxed/simple;
	bh=flck0XCkxNF8NjfYUwIumgJbuoWPKoCB4JIQDX8XV3I=;
	h=Date:To:From:Subject:Message-Id; b=TfKvlM5H6hjlDijxvYlRFU1xqOaLjkSUMnowagD6d+y+lhp68FJjCSyZzMhji+y2f9pOWp4XryCbYO1HyAI5jqPn6LA7OIedVB2qKHm13XgrdFBHBIgz/EfuzUcMPz6O2Nr8weZKtjSTitxtVgLKoGzIvaBTSVDDt7tOFkbkDyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ykjnqDX/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ykjnqDX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA9DC4CEEA;
	Sun, 22 Jun 2025 21:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750628924;
	bh=flck0XCkxNF8NjfYUwIumgJbuoWPKoCB4JIQDX8XV3I=;
	h=Date:To:From:Subject:From;
	b=ykjnqDX/H6q+dlptT8saZzE+RlvlN+71JAOcOdTYUVEns8gfSBbT9y5FGZVlMTf15
	 gexKlN1j7310tMt7LCl7IN6rpPcpgeyz/KEWkfmexzDBsXpLek9djLZMXJp2nZ1WGC
	 qVFfBTU2pKyJBusNTAYI7JidBYqG2jYkWuibj4bw=
Date: Sun, 22 Jun 2025 14:48:43 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,gavinguo@igalia.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmhugetlb-change-mechanism-to-detect-a-cow-on-private-mapping.patch added to mm-new branch
Message-Id: <20250622214844.5CA9DC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,hugetlb: change mechanism to detect a COW on private mapping
has been added to the -mm mm-new branch.  Its filename is
     mmhugetlb-change-mechanism-to-detect-a-cow-on-private-mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmhugetlb-change-mechanism-to-detect-a-cow-on-private-mapping.patch

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
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hugetlb: change mechanism to detect a COW on private mapping
Date: Fri, 20 Jun 2025 14:30:10 +0200

Patch series "Misc rework on hugetlb faulting path", v2.

This patchset aims to give some love to the hugetlb faulting path, doing
so by removing obsolete comments that are no longer true, sorting out the
folio lock, and changing the mechanism we use to determine whether we are
COWing a private mapping already.

The most important patch of the series is #1, as it fixes a deadlock that
was described in [1], where two processes were holding the same lock for
the folio in the pagecache, and then deadlocked in the mutex.

Looking up and locking the folio in the pagecache was done to check
whether that folio was the same folio we had mapped in our pagetables,
meaning that if it was different we knew that we already mapped that folio
privately, so any further CoW would be made on a private mapping, which
lead us to the question: __Was the reservation for that address
consumed?__ That is all we care about, because if it was indeed consumed
and we are the owner and we cannot allocate more folios, we need to unmap
the folio from the processes pagetables and make it exclusive for us.

We figured we do not need to look up the folio at all, and it is just
enough to check whether the folio we have mapped is anonymous, which means
we mapped it privately, so the reservation was indeed consumed.

Patch #2 sorts out folio locking in the faulting path, reducing the scope
of it ,only taking it when we are dealing with an anonymous folio and
document it.  More details in the patch.

Patches #3-5 are cleanups.



hugetlb_wp() checks whether the process is trying to COW on a private
mapping in order to know whether the reservation for that address was
already consumed or not.  If it was consumed and we are the ownner of the
mapping, the folio will have to be unmapped from the other processes.

Currently, that check is done by looking up the folio in the pagecache and
comparing it to the folio which is mapped in our pagetables.  If it
differs, it means we already mapped it privately before, consuming a
reservation on the way.  All we are interested in is whether the mapped
folio is anonymous, so we can simplify and check for that instead.

Also, we transition from a trylock to a folio_lock, since the former was
only needed when hugetlb_fault() had to lock both folios, in order to
avoid deadlock.

Link: https://lkml.kernel.org/r/20250620123014.29748-1-osalvador@suse.de
Link: https://lkml.kernel.org/r/20250620123014.29748-2-osalvador@suse.de
Link: https://lore.kernel.org/lkml/20250513093448.592150-1-gavinguo@igalia.com/ [1]
Fixes: 40549ba8f8e0 ("hugetlb: use new vma_lock for pmd sharing synchronization")
Reported-by: Gavin Guo <gavinguo@igalia.com>
Closes: https://lore.kernel.org/lkml/20250513093448.592150-1-gavinguo@igalia.com/
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   70 +++++++++++--------------------------------------
 1 file changed, 17 insertions(+), 53 deletions(-)

--- a/mm/hugetlb.c~mmhugetlb-change-mechanism-to-detect-a-cow-on-private-mapping
+++ a/mm/hugetlb.c
@@ -6130,8 +6130,7 @@ static void unmap_ref_private(struct mm_
  * cannot race with other handlers or page migration.
  * Keep the pte_same checks anyway to make transition from the mutex easier.
  */
-static vm_fault_t hugetlb_wp(struct folio *pagecache_folio,
-		       struct vm_fault *vmf)
+static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct mm_struct *mm = vma->vm_mm;
@@ -6193,16 +6192,17 @@ retry_avoidcopy:
 		       PageAnonExclusive(&old_folio->page), &old_folio->page);
 
 	/*
-	 * If the process that created a MAP_PRIVATE mapping is about to
-	 * perform a COW due to a shared page count, attempt to satisfy
-	 * the allocation without using the existing reserves. The pagecache
-	 * page is used to determine if the reserve at this address was
-	 * consumed or not. If reserves were used, a partial faulted mapping
-	 * at the time of fork() could consume its reserves on COW instead
-	 * of the full address range.
+	 * If the process that created a MAP_PRIVATE mapping is about to perform
+	 * a COW due to a shared page count, attempt to satisfy the allocation
+	 * without using the existing reserves.
+	 * In order to determine where this is a COW on a MAP_PRIVATE mapping it
+	 * is enough to check whether the old_folio is anonymous. This means that
+	 * the reserve for this address was consumed. If reserves were used, a
+	 * partial faulted mapping at the fime of fork() could consume its reserves
+	 * on COW instead of the full address range.
 	 */
 	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER) &&
-			old_folio != pagecache_folio)
+	    folio_test_anon(old_folio))
 		cow_from_owner = true;
 
 	folio_get(old_folio);
@@ -6581,7 +6581,7 @@ static vm_fault_t hugetlb_no_page(struct
 	hugetlb_count_add(pages_per_huge_page(h), mm);
 	if ((vmf->flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
 		/* Optimization, do the COW without a second fault */
-		ret = hugetlb_wp(folio, vmf);
+		ret = hugetlb_wp(vmf);
 	}
 
 	spin_unlock(vmf->ptl);
@@ -6648,11 +6648,9 @@ vm_fault_t hugetlb_fault(struct mm_struc
 {
 	vm_fault_t ret;
 	u32 hash;
-	struct folio *folio = NULL;
-	struct folio *pagecache_folio = NULL;
+	struct folio *folio;
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping;
-	int need_wait_lock = 0;
 	struct vm_fault vmf = {
 		.vma = vma,
 		.address = address & huge_page_mask(h),
@@ -6747,8 +6745,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	 * If we are going to COW/unshare the mapping later, we examine the
 	 * pending reservations for this page now. This will ensure that any
 	 * allocations necessary to record that reservation occur outside the
-	 * spinlock. Also lookup the pagecache page now as it is used to
-	 * determine if a reservation has been consumed.
+	 * spinlock.
 	 */
 	if ((flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) &&
 	    !(vma->vm_flags & VM_MAYSHARE) && !huge_pte_write(vmf.orig_pte)) {
@@ -6758,11 +6755,6 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		}
 		/* Just decrements count, does not deallocate */
 		vma_end_reservation(h, vma, vmf.address);
-
-		pagecache_folio = filemap_lock_hugetlb_folio(h, mapping,
-							     vmf.pgoff);
-		if (IS_ERR(pagecache_folio))
-			pagecache_folio = NULL;
 	}
 
 	vmf.ptl = huge_pte_lock(h, mm, vmf.pte);
@@ -6776,10 +6768,6 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	    (flags & FAULT_FLAG_WRITE) && !huge_pte_write(vmf.orig_pte)) {
 		if (!userfaultfd_wp_async(vma)) {
 			spin_unlock(vmf.ptl);
-			if (pagecache_folio) {
-				folio_unlock(pagecache_folio);
-				folio_put(pagecache_folio);
-			}
 			hugetlb_vma_unlock_read(vma);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			return handle_userfault(&vmf, VM_UFFD_WP);
@@ -6791,23 +6779,14 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		/* Fallthrough to CoW */
 	}
 
-	/*
-	 * hugetlb_wp() requires page locks of pte_page(vmf.orig_pte) and
-	 * pagecache_folio, so here we need take the former one
-	 * when folio != pagecache_folio or !pagecache_folio.
-	 */
+	/* hugetlb_wp() requires page locks of pte_page(vmf.orig_pte) */
 	folio = page_folio(pte_page(vmf.orig_pte));
-	if (folio != pagecache_folio)
-		if (!folio_trylock(folio)) {
-			need_wait_lock = 1;
-			goto out_ptl;
-		}
-
+	folio_lock(folio);
 	folio_get(folio);
 
 	if (flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) {
 		if (!huge_pte_write(vmf.orig_pte)) {
-			ret = hugetlb_wp(pagecache_folio, &vmf);
+			ret = hugetlb_wp(&vmf);
 			goto out_put_page;
 		} else if (likely(flags & FAULT_FLAG_WRITE)) {
 			vmf.orig_pte = huge_pte_mkdirty(vmf.orig_pte);
@@ -6818,16 +6797,10 @@ vm_fault_t hugetlb_fault(struct mm_struc
 						flags & FAULT_FLAG_WRITE))
 		update_mmu_cache(vma, vmf.address, vmf.pte);
 out_put_page:
-	if (folio != pagecache_folio)
-		folio_unlock(folio);
+	folio_unlock(folio);
 	folio_put(folio);
 out_ptl:
 	spin_unlock(vmf.ptl);
-
-	if (pagecache_folio) {
-		folio_unlock(pagecache_folio);
-		folio_put(pagecache_folio);
-	}
 out_mutex:
 	hugetlb_vma_unlock_read(vma);
 
@@ -6839,15 +6812,6 @@ out_mutex:
 		vma_end_read(vma);
 
 	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-	/*
-	 * Generally it's safe to hold refcount during waiting page lock. But
-	 * here we just wait to defer the next page fault to avoid busy loop and
-	 * the page is not used after unlocked before returning from the current
-	 * page fault. So we are safe from accessing freed page, even if we wait
-	 * here without taking refcount.
-	 */
-	if (need_wait_lock)
-		folio_wait_locked(folio);
 	return ret;
 }
 
_

Patches currently in -mm which might be from osalvador@suse.de are

mmslub-do-not-special-case-n_normal-nodes-for-slab_nodes.patch
mmmemory_hotplug-remove-status_change_nid_normal-and-update-documentation.patch
mmmemory_hotplug-implement-numa-node-notifier.patch
mmslub-use-node-notifier-instead-of-memory-notifier.patch
mmmemory-tiers-use-node-notifier-instead-of-memory-notifier.patch
driverscxl-use-node-notifier-instead-of-memory-notifier.patch
drivershmat-use-node-notifier-instead-of-memory-notifier.patch
kernelcpuset-use-node-notifier-instead-of-memory-notifier.patch
mmmempolicy-use-node-notifier-instead-of-memory-notifier.patch
mmpage_ext-derive-the-node-from-the-pfn.patch
mmmemory_hotplug-drop-status_change_nid-parameter-from-memory_notify.patch
mmhugetlb-change-mechanism-to-detect-a-cow-on-private-mapping.patch
mmhugetlb-sort-out-folio-locking-in-the-faulting-path.patch
mmhugetlb-rename-anon_rmap-to-new_anon_folio-and-make-it-boolean.patch
mmhugetlb-rename-anon_rmap-to-new_anon_folio-and-make-it-boolean-fix.patch
mmhugetlb-drop-obsolete-comment-about-non-present-pte-and-second-faults.patch
mmhugetlb-drop-unlikelys-from-hugetlb_fault.patch


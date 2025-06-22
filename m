Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF7842AAF
	for <mm-commits@vger.kernel.org>; Sun, 22 Jun 2025 21:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750628929; cv=none; b=e7eeGicAr7aTb7WhuUjQlzzP+q81ZQUtkplnfJyhjqPAEDUgwCG+CrKsUYa79BRtd/JNf+0ScLSt+lEI+4WyOlzsLoyQTkqiGxWjso0U1Z/B+KPBLRqn8SbqtluG1iAI1MnSRCpjwqIYxrTzv4tRloM478swixcXzrWQUWZRMIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750628929; c=relaxed/simple;
	bh=7SG9PRjTvWR4QeZpw1FWV1v6S1FOBLjwQChkdZKCk1o=;
	h=Date:To:From:Subject:Message-Id; b=FLzkdGrZT1YyLpuHuRcmaYM08E2AUWe/0C1QngIJbRefYFlcPQSI3h2jlceYBBlaPr5rELzrhZdHXInzI1a7JOTLxUhMy5hnVN1RR15SNBE+ayJyNqTBmjzvaPepcypQMJgsZbLFNvuA64xYk/NH598l+dthLwbnWLdwTOUNwig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WH5hhQKl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WH5hhQKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61589C4CEEA;
	Sun, 22 Jun 2025 21:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750628928;
	bh=7SG9PRjTvWR4QeZpw1FWV1v6S1FOBLjwQChkdZKCk1o=;
	h=Date:To:From:Subject:From;
	b=WH5hhQKljoFQBlCkV7ipeaoGOofkjOcOyw7+Fg8AnSnRC4TqgPkx8HFpWEfH7jBpd
	 TTj78yC5ybqxtCKR9beTdVl38Za9ka+GultbiiUL7qIgae9jYCn3ctvcVjZVYbT08Q
	 +ZX5JOIcE0a/tkerx+6GezvrHLUm+iBAw0F2SBMs=
Date: Sun, 22 Jun 2025 14:48:47 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,gavinguo@igalia.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmhugetlb-rename-anon_rmap-to-new_anon_folio-and-make-it-boolean.patch added to mm-new branch
Message-Id: <20250622214848.61589C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,hugetlb: rename anon_rmap to new_anon_folio and make it boolean
has been added to the -mm mm-new branch.  Its filename is
     mmhugetlb-rename-anon_rmap-to-new_anon_folio-and-make-it-boolean.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmhugetlb-rename-anon_rmap-to-new_anon_folio-and-make-it-boolean.patch

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
Subject: mm,hugetlb: rename anon_rmap to new_anon_folio and make it boolean
Date: Fri, 20 Jun 2025 14:30:12 +0200

anon_rmap is used to determine whether the new allocated folio is
anonymous.  Rename it to something more meaningul like new_anon_folio and
make it boolean, as we use it like that.

While we are at it, drop 'new_pagecache_folio' as 'new_anon_folio' is
enough to check whether we need to restore the consumed reservation.

Link: https://lkml.kernel.org/r/20250620123014.29748-4-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Guo <gavinguo@igalia.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/mm/hugetlb.c~mmhugetlb-rename-anon_rmap-to-new_anon_folio-and-make-it-boolean
+++ a/mm/hugetlb.c
@@ -6405,17 +6405,16 @@ static bool hugetlb_pte_stable(struct hs
 static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 			struct vm_fault *vmf)
 {
+	u32 hash = hugetlb_fault_mutex_hash(mapping, vmf->pgoff);
+	bool new_folio, new_anon_folio = false;
 	struct vm_area_struct *vma = vmf->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	struct hstate *h = hstate_vma(vma);
 	vm_fault_t ret = VM_FAULT_SIGBUS;
-	int anon_rmap = 0;
-	unsigned long size;
+	bool folio_locked = true;
 	struct folio *folio;
+	unsigned long size;
 	pte_t new_pte;
-	bool new_folio, new_pagecache_folio = false;
-	u32 hash = hugetlb_fault_mutex_hash(mapping, vmf->pgoff);
-	bool folio_locked = true;
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -6496,6 +6495,7 @@ static vm_fault_t hugetlb_no_page(struct
 		folio_zero_user(folio, vmf->real_address);
 		__folio_mark_uptodate(folio);
 		new_folio = true;
+		new_anon_folio = !(vma->vm_flags & VM_MAYSHARE);
 
 		if (vma->vm_flags & VM_MAYSHARE) {
 			int err = hugetlb_add_to_page_cache(folio, mapping,
@@ -6514,10 +6514,8 @@ static vm_fault_t hugetlb_no_page(struct
 				ret = VM_FAULT_SIGBUS;
 				goto out;
 			}
-			new_pagecache_folio = true;
 		} else {
 			folio_lock(folio);
-			anon_rmap = 1;
 		}
 	} else {
 		/*
@@ -6566,7 +6564,7 @@ static vm_fault_t hugetlb_no_page(struct
 	if (!pte_same(huge_ptep_get(mm, vmf->address, vmf->pte), vmf->orig_pte))
 		goto backout;
 
-	if (anon_rmap)
+	if (new_anon_folio)
 		hugetlb_add_new_anon_rmap(folio, vma, vmf->address);
 	else
 		hugetlb_add_file_rmap(folio);
@@ -6582,7 +6580,7 @@ static vm_fault_t hugetlb_no_page(struct
 	hugetlb_count_add(pages_per_huge_page(h), mm);
 	if ((vmf->flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
 		/* No need to lock file folios. See comment in hugetlb_fault() */
-		if (!anon_rmap) {
+		if (!new_anon_folio) {
 			folio_locked = false;
 			folio_unlock(folio);
 		}
@@ -6618,7 +6616,8 @@ out:
 backout:
 	spin_unlock(vmf->ptl);
 backout_unlocked:
-	if (new_folio && !new_pagecache_folio)
+	/* We only need to restore reservations for private mappings */
+	if (new_folio && new_anon_folio)
 		restore_reserve_on_error(h, vma, vmf->address, folio);
 
 	if (folio_locked)
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


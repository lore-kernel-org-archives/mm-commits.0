Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A5242AAF
	for <mm-commits@vger.kernel.org>; Sun, 22 Jun 2025 21:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750628927; cv=none; b=aJ3SxdKDysAFef9D5YuPKlGiy0ZFw57kW0Pi1bw7xDNJdh/An/kyi5Z62ct3qCF47p03l0t1y8or65YvQjBO+EbW2CCTel+3cQW2dAcVsb/iWkAdAk+ui/0YEnX3dCDeyWmGrkoopm9/fSiQFy/FtpvLsrjSVcAjdxueNdK9opg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750628927; c=relaxed/simple;
	bh=8Rr7Y04n3YKIDSMWePOitKW7ttyS1oAps39dfM4xe/I=;
	h=Date:To:From:Subject:Message-Id; b=lkpkui/y+j+CmSLKgmESG7T8LblS561hAn/ptBclACrFjPveV/9e5h/V/3Qy+z75f+IYHV8Ow7A5VofQvf7kWzLKfhriZ8y53S3aHNUaF6wa9/3jhreZJkkXapHFfG/2WssQCE0PAmahuuGKiA+O+w36bPxPPo3nmPSoYXUO6oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zVAcUDFF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zVAcUDFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C00C4CEEA;
	Sun, 22 Jun 2025 21:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750628926;
	bh=8Rr7Y04n3YKIDSMWePOitKW7ttyS1oAps39dfM4xe/I=;
	h=Date:To:From:Subject:From;
	b=zVAcUDFFpGThit9iERrQHk2BbS3khSNCArxwcpafSuYxstd4vUs1RtwHFVhbkmM+d
	 9hOaij+EjeJEzX87WH0iQpciaW84lJPuhm311PSSivC4p8Sse8zVADywDxeOxcP41i
	 CIzTTooMJ3Shpry505vQWol5WdGiaz0NzWoyxEX8=
Date: Sun, 22 Jun 2025 14:48:45 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,gavinguo@igalia.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmhugetlb-sort-out-folio-locking-in-the-faulting-path.patch added to mm-new branch
Message-Id: <20250622214846.61C00C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,hugetlb: sort out folio locking in the faulting path
has been added to the -mm mm-new branch.  Its filename is
     mmhugetlb-sort-out-folio-locking-in-the-faulting-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmhugetlb-sort-out-folio-locking-in-the-faulting-path.patch

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
Subject: mm,hugetlb: sort out folio locking in the faulting path
Date: Fri, 20 Jun 2025 14:30:11 +0200

Recent conversations showed that there was a misunderstanding about why we
were locking the folio prior to call in hugetlb_wp().

In fact, as soon as we have the folio mapped into the pagetables, we no
longer need to hold it locked, because we know that no concurrent
truncation could have happened.

There is only one case where the folio needs to be locked, and that is
when we are handling an anonymous folio, because hugetlb_wp() will check
whether it can re-use it exclusively for the process that is faulting it
in.

So, pass the folio locked to hugetlb_wp() when that is the case.

Link: https://lkml.kernel.org/r/20250620123014.29748-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Gavin Guo <gavinguo@igalia.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   43 +++++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

--- a/mm/hugetlb.c~mmhugetlb-sort-out-folio-locking-in-the-faulting-path
+++ a/mm/hugetlb.c
@@ -6415,6 +6415,7 @@ static vm_fault_t hugetlb_no_page(struct
 	pte_t new_pte;
 	bool new_folio, new_pagecache_folio = false;
 	u32 hash = hugetlb_fault_mutex_hash(mapping, vmf->pgoff);
+	bool folio_locked = true;
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -6580,6 +6581,11 @@ static vm_fault_t hugetlb_no_page(struct
 
 	hugetlb_count_add(pages_per_huge_page(h), mm);
 	if ((vmf->flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
+		/* No need to lock file folios. See comment in hugetlb_fault() */
+		if (!anon_rmap) {
+			folio_locked = false;
+			folio_unlock(folio);
+		}
 		/* Optimization, do the COW without a second fault */
 		ret = hugetlb_wp(vmf);
 	}
@@ -6594,7 +6600,8 @@ static vm_fault_t hugetlb_no_page(struct
 	if (new_folio)
 		folio_set_hugetlb_migratable(folio);
 
-	folio_unlock(folio);
+	if (folio_locked)
+		folio_unlock(folio);
 out:
 	hugetlb_vma_unlock_read(vma);
 
@@ -6614,7 +6621,8 @@ backout_unlocked:
 	if (new_folio && !new_pagecache_folio)
 		restore_reserve_on_error(h, vma, vmf->address, folio);
 
-	folio_unlock(folio);
+	if (folio_locked)
+		folio_unlock(folio);
 	folio_put(folio);
 	goto out;
 }
@@ -6648,7 +6656,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 {
 	vm_fault_t ret;
 	u32 hash;
-	struct folio *folio;
+	struct folio *folio = NULL;
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping;
 	struct vm_fault vmf = {
@@ -6665,6 +6673,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		 * be hard to debug if called functions make assumptions
 		 */
 	};
+	bool folio_locked = false;
 
 	/*
 	 * Serialize hugepage allocation and instantiation, so that we don't
@@ -6779,13 +6788,24 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		/* Fallthrough to CoW */
 	}
 
-	/* hugetlb_wp() requires page locks of pte_page(vmf.orig_pte) */
-	folio = page_folio(pte_page(vmf.orig_pte));
-	folio_lock(folio);
-	folio_get(folio);
-
 	if (flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) {
 		if (!huge_pte_write(vmf.orig_pte)) {
+			/*
+			 * Anonymous folios need to be lock since hugetlb_wp()
+			 * checks whether we can re-use the folio exclusively
+			 * for us in case we are the only user of it.
+			 */
+			folio = page_folio(pte_page(vmf.orig_pte));
+			folio_get(folio);
+			if (folio_test_anon(folio)) {
+				spin_unlock(vmf.ptl);
+				folio_lock(folio);
+				folio_locked = true;
+				spin_lock(vmf.ptl);
+				if (unlikely(!pte_same(vmf.orig_pte, huge_ptep_get(mm,
+						   vmf.address, vmf.pte))))
+					goto out_put_page;
+			}
 			ret = hugetlb_wp(&vmf);
 			goto out_put_page;
 		} else if (likely(flags & FAULT_FLAG_WRITE)) {
@@ -6797,8 +6817,11 @@ vm_fault_t hugetlb_fault(struct mm_struc
 						flags & FAULT_FLAG_WRITE))
 		update_mmu_cache(vma, vmf.address, vmf.pte);
 out_put_page:
-	folio_unlock(folio);
-	folio_put(folio);
+	if (folio) {
+		if (folio_locked)
+			folio_unlock(folio);
+		folio_put(folio);
+	}
 out_ptl:
 	spin_unlock(vmf.ptl);
 out_mutex:
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


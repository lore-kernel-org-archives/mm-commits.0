Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A82191F9B
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 21:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733348576; cv=none; b=nyB9uMv/Xj1rvY/81gGL1dggIRXlFkgNw2uHbnqwb3slz6vw768c6zhbjvjdgf0AlOSgspTfKKj0BYPaTbpkb51aOyqk8zI0168Hshbec4GXM2zvKoI6F5dChUv1STpyfJRxRAs/h3bvgaoewB7aGbPek+31D/cemEYAzv8lbKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733348576; c=relaxed/simple;
	bh=7bTMh63MMQxgVJQ0ewzcYr1/U82uVS4opEZ1XREZhts=;
	h=Date:To:From:Subject:Message-Id; b=PNsV1slRSEhOZZXyHs5o8y2AbfYxNEv6fc7qsa06LLonfZzDmTWnGKFClqNy20DLTIJIK2fWSdH3S1RLdS9k1z5kQCpbr00dV3naXZnwuo667I37ImWSfWEJgyqOo2TIXxBTk7J/1AHRg4vgCbfcQTHMXPkfywWfaMcG0pCJkRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=reAcY/3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="reAcY/3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FC8C4CECD;
	Wed,  4 Dec 2024 21:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733348575;
	bh=7bTMh63MMQxgVJQ0ewzcYr1/U82uVS4opEZ1XREZhts=;
	h=Date:To:From:Subject:From;
	b=reAcY/3NErQ43LWLxTjlekx2gdvVBQcoHSpp3RvYGft3RL7uFidQmICNsYXJv08PB
	 oXWipjYN5+ty/P8ZdW+mzVUUQjravQkDDDIqagTOZvgoNneU4USSr3R43G5vhUo+fh
	 f54MAWWFFbpjUSX/wwc9sD9h80fEv2u07hrj1dSI=
Date: Wed, 04 Dec 2024 13:42:54 -0800
To: mm-commits@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,jhubbard@nvidia.com,jgg@nvidia.com,ehagberg@janestreet.com,david@redhat.com,guillaume@morinfr.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-support-foll_forcefoll_write.patch added to mm-unstable branch
Message-Id: <20241204214255.33FC8C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: support FOLL_FORCE|FOLL_WRITE
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-support-foll_forcefoll_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-support-foll_forcefoll_write.patch

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
From: Guillaume Morin <guillaume@morinfr.org>
Subject: mm/hugetlb: support FOLL_FORCE|FOLL_WRITE
Date: Wed, 4 Dec 2024 21:18:23 +0100

Eric reported that PTRACE_POKETEXT fails when applications use hugetlb for
mapping text using huge pages.  Before commit 1d8d14641fd9 ("mm/hugetlb:
support write-faults in shared mappings"), PTRACE_POKETEXT worked by
accident, but it was buggy and silently ended up mapping pages writable
into the page tables even though VM_WRITE was not set.

In general, FOLL_FORCE|FOLL_WRITE does currently not work with hugetlb. 
Let's implement FOLL_FORCE|FOLL_WRITE properly for hugetlb, such that what
used to work in the past by accident now properly works, allowing
applications using hugetlb for text etc.  to get properly debugged.

This change might also be required to implement uprobes support for
hugetlb [1].

[1] https://lore.kernel.org/lkml/ZiK50qob9yl5e0Xz@bender.morinfr.org/

Link: https://lkml.kernel.org/r/Z1C5D1D3NJFnADPz@bender.morinfr.org
Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric Hagberg <ehagberg@janestreet.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c     |   93 ++++++++++++++++++++++++-------------------------
 mm/hugetlb.c |   20 +++++-----
 2 files changed, 58 insertions(+), 55 deletions(-)

--- a/mm/gup.c~mm-hugetlb-support-foll_forcefoll_write
+++ a/mm/gup.c
@@ -596,6 +596,33 @@ static struct folio *try_grab_folio_fast
 }
 #endif	/* CONFIG_HAVE_GUP_FAST */
 
+/* Common code for can_follow_write_* */
+static inline bool can_follow_write_common(struct page *page,
+		struct vm_area_struct *vma, unsigned int flags)
+{
+	/* Maybe FOLL_FORCE is set to override it? */
+	if (!(flags & FOLL_FORCE))
+		return false;
+
+	/* But FOLL_FORCE has no effect on shared mappings */
+	if (vma->vm_flags & (VM_MAYSHARE | VM_SHARED))
+		return false;
+
+	/* ... or read-only private ones */
+	if (!(vma->vm_flags & VM_MAYWRITE))
+		return false;
+
+	/* ... or already writable ones that just need to take a write fault */
+	if (vma->vm_flags & VM_WRITE)
+		return false;
+
+	/*
+	 * See can_change_pte_writable(): we broke COW and could map the page
+	 * writable if we have an exclusive anonymous page ...
+	 */
+	return page && PageAnon(page) && PageAnonExclusive(page);
+}
+
 static struct page *no_page_table(struct vm_area_struct *vma,
 				  unsigned int flags, unsigned long address)
 {
@@ -622,6 +649,22 @@ static struct page *no_page_table(struct
 }
 
 #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
+/* FOLL_FORCE can write to even unwritable PUDs in COW mappings. */
+static inline bool can_follow_write_pud(pud_t pud, struct page *page,
+					struct vm_area_struct *vma,
+					unsigned int flags)
+{
+	/* If the pud is writable, we can write to the page. */
+	if (pud_write(pud))
+		return true;
+
+	if (!can_follow_write_common(page, vma, flags))
+		return false;
+
+	/* ... and a write-fault isn't required for other reasons. */
+	return !vma_soft_dirty_enabled(vma) || pud_soft_dirty(pud);
+}
+
 static struct page *follow_huge_pud(struct vm_area_struct *vma,
 				    unsigned long addr, pud_t *pudp,
 				    int flags, struct follow_page_context *ctx)
@@ -634,7 +677,8 @@ static struct page *follow_huge_pud(stru
 
 	assert_spin_locked(pud_lockptr(mm, pudp));
 
-	if ((flags & FOLL_WRITE) && !pud_write(pud))
+	if ((flags & FOLL_WRITE) &&
+	    !can_follow_write_pud(pud, page, vma, flags))
 		return NULL;
 
 	if (!pud_present(pud))
@@ -686,27 +730,7 @@ static inline bool can_follow_write_pmd(
 	if (pmd_write(pmd))
 		return true;
 
-	/* Maybe FOLL_FORCE is set to override it? */
-	if (!(flags & FOLL_FORCE))
-		return false;
-
-	/* But FOLL_FORCE has no effect on shared mappings */
-	if (vma->vm_flags & (VM_MAYSHARE | VM_SHARED))
-		return false;
-
-	/* ... or read-only private ones */
-	if (!(vma->vm_flags & VM_MAYWRITE))
-		return false;
-
-	/* ... or already writable ones that just need to take a write fault */
-	if (vma->vm_flags & VM_WRITE)
-		return false;
-
-	/*
-	 * See can_change_pte_writable(): we broke COW and could map the page
-	 * writable if we have an exclusive anonymous page ...
-	 */
-	if (!page || !PageAnon(page) || !PageAnonExclusive(page))
+	if (!can_follow_write_common(page, vma, flags))
 		return false;
 
 	/* ... and a write-fault isn't required for other reasons. */
@@ -807,27 +831,7 @@ static inline bool can_follow_write_pte(
 	if (pte_write(pte))
 		return true;
 
-	/* Maybe FOLL_FORCE is set to override it? */
-	if (!(flags & FOLL_FORCE))
-		return false;
-
-	/* But FOLL_FORCE has no effect on shared mappings */
-	if (vma->vm_flags & (VM_MAYSHARE | VM_SHARED))
-		return false;
-
-	/* ... or read-only private ones */
-	if (!(vma->vm_flags & VM_MAYWRITE))
-		return false;
-
-	/* ... or already writable ones that just need to take a write fault */
-	if (vma->vm_flags & VM_WRITE)
-		return false;
-
-	/*
-	 * See can_change_pte_writable(): we broke COW and could map the page
-	 * writable if we have an exclusive anonymous page ...
-	 */
-	if (!page || !PageAnon(page) || !PageAnonExclusive(page))
+	if (!can_follow_write_common(page, vma, flags))
 		return false;
 
 	/* ... and a write-fault isn't required for other reasons. */
@@ -1294,9 +1298,6 @@ static int check_vma_flags(struct vm_are
 		if (!(vm_flags & VM_WRITE) || (vm_flags & VM_SHADOW_STACK)) {
 			if (!(gup_flags & FOLL_FORCE))
 				return -EFAULT;
-			/* hugetlb does not support FOLL_FORCE|FOLL_WRITE. */
-			if (is_vm_hugetlb_page(vma))
-				return -EFAULT;
 			/*
 			 * We used to let the write,force case do COW in a
 			 * VM_MAYWRITE VM_SHARED !VM_WRITE vma, so ptrace could
--- a/mm/hugetlb.c~mm-hugetlb-support-foll_forcefoll_write
+++ a/mm/hugetlb.c
@@ -5169,6 +5169,13 @@ static void set_huge_ptep_writable(struc
 		update_mmu_cache(vma, address, ptep);
 }
 
+static void set_huge_ptep_maybe_writable(struct vm_area_struct *vma,
+					 unsigned long address, pte_t *ptep)
+{
+	if (vma->vm_flags & VM_WRITE)
+		set_huge_ptep_writable(vma, address, ptep);
+}
+
 bool is_hugetlb_entry_migration(pte_t pte)
 {
 	swp_entry_t swp;
@@ -5802,13 +5809,6 @@ static vm_fault_t hugetlb_wp(struct foli
 	if (!unshare && huge_pte_uffd_wp(pte))
 		return 0;
 
-	/*
-	 * hugetlb does not support FOLL_FORCE-style write faults that keep the
-	 * PTE mapped R/O such as maybe_mkwrite() would do.
-	 */
-	if (WARN_ON_ONCE(!unshare && !(vma->vm_flags & VM_WRITE)))
-		return VM_FAULT_SIGSEGV;
-
 	/* Let's take out MAP_SHARED mappings first. */
 	if (vma->vm_flags & VM_MAYSHARE) {
 		set_huge_ptep_writable(vma, vmf->address, vmf->pte);
@@ -5837,7 +5837,8 @@ retry_avoidcopy:
 			SetPageAnonExclusive(&old_folio->page);
 		}
 		if (likely(!unshare))
-			set_huge_ptep_writable(vma, vmf->address, vmf->pte);
+			set_huge_ptep_maybe_writable(vma, vmf->address,
+						     vmf->pte);
 
 		delayacct_wpcopy_end();
 		return 0;
@@ -5943,7 +5944,8 @@ retry_avoidcopy:
 	spin_lock(vmf->ptl);
 	vmf->pte = hugetlb_walk(vma, vmf->address, huge_page_size(h));
 	if (likely(vmf->pte && pte_same(huge_ptep_get(mm, vmf->address, vmf->pte), pte))) {
-		pte_t newpte = make_huge_pte(vma, &new_folio->page, !unshare);
+		const bool writable = !unshare && (vma->vm_flags & VM_WRITE);
+		pte_t newpte = make_huge_pte(vma, &new_folio->page, writable);
 
 		/* Break COW or unshare */
 		huge_ptep_clear_flush(vma, vmf->address, vmf->pte);
_

Patches currently in -mm which might be from guillaume@morinfr.org are

mm-hugetlb-support-foll_forcefoll_write.patch


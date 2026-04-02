Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B545F37C900
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 18:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775154851; cv=none; b=E8ixbEzubYEo3MkxyVPISD6NcIZBCWm+Z48Z8NKUK/k/lNtkFbK3kjfhyU81vL/KF5Kmc7h6ebkrmclclIoPkoEgffM23fqI2xzbbBloGemujsMxAMKcLjJs5bQ5kxkJbRXzxaOrkltdgYiJgq9lj11T7Vx1PYfTxjxvOynOPo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775154851; c=relaxed/simple;
	bh=uXYYqxgYSnP2tI83FRGvxQfDN2pfRc2osjw89JkjFEo=;
	h=Date:To:From:Subject:Message-Id; b=HxFI9JD8uXtW6vn+7cx1idrSPxWsWnpBvxG2dX72ZMyXAViKYFA2CMJpUZzfX3ewIWjF0HtxmDnAQ6armHTwTlgJCWpqaVXfpjkZl4qEeTnEOe7TV74pzHyylCMNSXcEhoI55Euj6dK3lkDxnBvEUGYYWqPIbgFzat+Qg3NZ6o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UmlYxNGL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UmlYxNGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61191C116C6;
	Thu,  2 Apr 2026 18:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775154851;
	bh=uXYYqxgYSnP2tI83FRGvxQfDN2pfRc2osjw89JkjFEo=;
	h=Date:To:From:Subject:From;
	b=UmlYxNGLXXR3HOXIn4eSB6NmEtMtWXPpHOrdTW8OiV7ehh/AqxiGVA4nrzxyRWyFF
	 ZS8njLsuJ2DCR6xl2ClpLEFyyIXpSO1siM856J7vr6Y1EYSM7NIrnQCD5zgoh8oOqu
	 lRd3So78RCi7cPjjNhxhIBFXXVKdunaLJmGp6G4M=
Date: Thu, 02 Apr 2026 11:34:10 -0700
To: mm-commits@vger.kernel.org,luyang@redhat.com,ljs@kernel.org,liam.howlett@oracle.com,jhladky@redhat.com,jannh@google.com,dev.jain@arm.com,david@kernel.org,pfalcato@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-special-case-small-folios-when-applying-write-permissions.patch added to mm-unstable branch
Message-Id: <20260402183411.61191C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mprotect: special-case small folios when applying permissions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mprotect-special-case-small-folios-when-applying-write-permissions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-special-case-small-folios-when-applying-write-permissions.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Pedro Falcato <pfalcato@suse.de>
Subject: mm/mprotect: special-case small folios when applying permissions
Date: Thu, 2 Apr 2026 15:16:28 +0100

The common order-0 case is important enough to want its own branch, and
avoids the hairy, large loop logic that the CPU does not seem to handle
particularly well.

While at it, encourage the compiler to inline batch PTE logic and resolve
constant branches by adding __always_inline strategically.

Link: https://lkml.kernel.org/r/20260402141628.3367596-3-pfalcato@suse.de
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Tested-by: Luke Yang <luyang@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jiri Hladky <jhladky@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   91 ++++++++++++++++++++++++++++++------------------
 1 file changed, 57 insertions(+), 34 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-special-case-small-folios-when-applying-write-permissions
+++ a/mm/mprotect.c
@@ -117,9 +117,9 @@ static int mprotect_folio_pte_batch(stru
 }
 
 /* Set nr_ptes number of ptes, starting from idx */
-static void prot_commit_flush_ptes(struct vm_area_struct *vma, unsigned long addr,
-		pte_t *ptep, pte_t oldpte, pte_t ptent, int nr_ptes,
-		int idx, bool set_write, struct mmu_gather *tlb)
+static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, pte_t oldpte, pte_t ptent,
+		int nr_ptes, int idx, bool set_write, struct mmu_gather *tlb)
 {
 	/*
 	 * Advance the position in the batch by idx; note that if idx > 0,
@@ -143,7 +143,7 @@ static void prot_commit_flush_ptes(struc
  * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
  * that the ptes point to consecutive pages of the same anon large folio.
  */
-static int page_anon_exclusive_sub_batch(int start_idx, int max_len,
+static __always_inline int page_anon_exclusive_sub_batch(int start_idx, int max_len,
 		struct page *first_page, bool expected_anon_exclusive)
 {
 	int idx;
@@ -169,7 +169,7 @@ static int page_anon_exclusive_sub_batch
  * pte of the batch. Therefore, we must individually check all pages and
  * retrieve sub-batches.
  */
-static void commit_anon_folio_batch(struct vm_area_struct *vma,
+static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
 		struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
 		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
@@ -188,7 +188,7 @@ static void commit_anon_folio_batch(stru
 	}
 }
 
-static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
+static __always_inline void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
 		struct folio *folio, struct page *page, unsigned long addr, pte_t *ptep,
 		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
@@ -277,6 +277,45 @@ static long change_softleaf_pte(struct v
 	return 0;
 }
 
+static __always_inline void change_present_ptes(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
+		int nr_ptes, unsigned long end, pgprot_t newprot,
+		struct folio *folio, struct page *page, unsigned long cp_flags)
+{
+	const bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
+	const bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
+	pte_t ptent, oldpte;
+
+	oldpte = modify_prot_start_ptes(vma, addr, ptep, nr_ptes);
+	ptent = pte_modify(oldpte, newprot);
+
+	if (uffd_wp)
+		ptent = pte_mkuffd_wp(ptent);
+	else if (uffd_wp_resolve)
+		ptent = pte_clear_uffd_wp(ptent);
+
+	/*
+	 * In some writable, shared mappings, we might want
+	 * to catch actual write access -- see
+	 * vma_wants_writenotify().
+	 *
+	 * In all writable, private mappings, we have to
+	 * properly handle COW.
+	 *
+	 * In both cases, we can sometimes still change PTEs
+	 * writable and avoid the write-fault handler, for
+	 * example, if a PTE is already dirty and no other
+	 * COW or special handling is required.
+	 */
+	if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
+	     !pte_write(ptent))
+		set_write_prot_commit_flush_ptes(vma, folio, page,
+			addr, ptep, oldpte, ptent, nr_ptes, tlb);
+	else
+		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent,
+			nr_ptes, /* idx = */ 0, /* set_write = */ false, tlb);
+}
+
 static long change_pte_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
@@ -287,7 +326,6 @@ static long change_pte_range(struct mmu_
 	bool is_private_single_threaded;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
-	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
 	int nr_ptes;
 
 	tlb_change_page_size(tlb, PAGE_SIZE);
@@ -308,7 +346,6 @@ static long change_pte_range(struct mmu_
 			int max_nr_ptes = (end - addr) >> PAGE_SHIFT;
 			struct folio *folio = NULL;
 			struct page *page;
-			pte_t ptent;
 
 			/* Already in the desired state. */
 			if (prot_numa && pte_protnone(oldpte))
@@ -334,34 +371,20 @@ static long change_pte_range(struct mmu_
 
 			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
 
-			oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
-			ptent = pte_modify(oldpte, newprot);
-
-			if (uffd_wp)
-				ptent = pte_mkuffd_wp(ptent);
-			else if (uffd_wp_resolve)
-				ptent = pte_clear_uffd_wp(ptent);
-
 			/*
-			 * In some writable, shared mappings, we might want
-			 * to catch actual write access -- see
-			 * vma_wants_writenotify().
-			 *
-			 * In all writable, private mappings, we have to
-			 * properly handle COW.
-			 *
-			 * In both cases, we can sometimes still change PTEs
-			 * writable and avoid the write-fault handler, for
-			 * example, if a PTE is already dirty and no other
-			 * COW or special handling is required.
+			 * Optimize for the small-folio common case by
+			 * special-casing it here. Compiler constant propagation
+			 * plus copious amounts of __always_inline does wonders.
 			 */
-			if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
-			     !pte_write(ptent))
-				set_write_prot_commit_flush_ptes(vma, folio, page,
-				addr, pte, oldpte, ptent, nr_ptes, tlb);
-			else
-				prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
-					nr_ptes, /* idx = */ 0, /* set_write = */ false, tlb);
+			if (likely(nr_ptes == 1)) {
+				change_present_ptes(tlb, vma, addr, pte, 1,
+					end, newprot, folio, page, cp_flags);
+			} else {
+				change_present_ptes(tlb, vma, addr, pte,
+					nr_ptes, end, newprot, folio, page,
+					cp_flags);
+			}
+
 			pages += nr_ptes;
 		} else if (pte_none(oldpte)) {
 			/*
_

Patches currently in -mm which might be from pfalcato@suse.de are

mm-mprotect-move-softleaf-code-out-of-the-main-function.patch
mm-mprotect-special-case-small-folios-when-applying-write-permissions.patch


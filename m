Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793404296;
	b=EdYG5+atAGDxPTmygEQn/CUF4M19geJTEm6tK29mfEMTXF97MCI4qffJ1x/Qt8eHwaMU
	 HltUPx5L80D0JoY1QmrqeJ1YZ2pSHCwvOpzgROYx6shrIvMrhMlqG1nQ2+J7nreb5nCwh
	 iEq1za3UCYxuZTIDuIKTbheBcHyMAc4VnervYL8Oqj/yqWYruVMUEK5J4Bq+L0TEowFx5
	 R11M5Oh8C6b3QBQpQDHIF9QeMn6fD4pvZphvujNpB/pfIlawyEM4QyvGxKhtUnwkZ1tBu
	 0/OM4FyA+8MUNkbE3LU8Xw9vJMyUOpPyu30+gcvemN4M+6DrDUG7gg82wzViOmaMR9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793404296;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=/Bdo3vuvau4gHPFm9SBv8D3zh7KOM7kautqy1pUSNVE=;
	b=Kg4sWAo00zw0TraNk9p0HHEyjzJi9hOnH7f56DRq52adCADPrX/0YG52pMjjsOAh+WNV
	 tlllqy6Y/XWB4JydfJxLFNqNKH56RugP9b+q7McNvF11fU2W1aetj5R0Q3wqcJCmFVZfO
	 wzZT0b4/CbhU22wuNRpxjFOwqCLLv4+8CnCr9tcewm0fqEKcUl3+tU7YYQAnH2ywnsiwk
	 7WnQeba2BeXvD8Uoz6E1IcwH/garNGvkdCf9OFADLezSZP07zcFOEKThmShgZQbbcUPG4
	 nB6JhocEqM5okQxD1Y1Vjyq4CcoGi83kJ9l6bp2Y1XeNgQ+zQblvS+qzarxnCFF8QPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=POicyiJH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB8E606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 23:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=POicyiJH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB141F000C1;
	Fri, 30 Oct 2026 23:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793404295;
	bh=/Bdo3vuvau4gHPFm9SBv8D3zh7KOM7kautqy1pUSNVE=;
	h=Date:To:From:Subject;
	b=POicyiJHJ7uEncij0R/iR3ktJq2nXlvhsdDotkluSsNFiBaqBzSwctR8C24bWRJDP
	 Z+PJ4EH5mUm44MyFSR+/BBgXUbXt0ywgh45EGPMrYi4ulqnQ07O2Zan6mV0gDixDaV
	 4pmD0tE/hV55/mLkZb2PLgPICqYIYUXxiCuMiuVI=
Date: Fri, 30 Oct 2026 16:51:35 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,david@kernel.org,azpijr@gmail.com,
	anshuman.khandual@arm.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-remove-the-mkwrite-argument-from-__vm_insert_mixed.patch added to mm-new branch
Message-Id: <20261030235135.7AB141F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/memory: remove the mkwrite argument from __vm_insert_mixed()
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-remove-the-mkwrite-argument-from-__vm_insert_mixed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-remove-the-mkwrite-argument-from-__vm_insert_mixed.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/memory: remove the mkwrite argument from __vm_insert_mixed()
Date: Sat, 03 Oct 2026 01:05:33 +0900

__vm_insert_mixed() is only called from vmf_insert_mixed() with
mkwrite == false, so mkwrite is also always false in vm_mixed_ok()
and insert_pfn().

So remove the argument and the unreachable code in insert_pfn().

No functional change.

Link: https://lore.kernel.org/20261002160535.661399-3-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/memory.c |   57 +++++++++++++++-----------------------------------
 1 file changed, 18 insertions(+), 39 deletions(-)

--- a/mm/memory.c~mm-memory-remove-the-mkwrite-argument-from-__vm_insert_mixed
+++ a/mm/memory.c
@@ -2459,7 +2459,14 @@ static int insert_page_into_pte_locked(s
 		if (!mkwrite)
 			return -EBUSY;
 
-		/* see insert_pfn(). */
+		/*
+		 * For read faults on private mappings the PFN passed in may
+		 * not match the PFN we have mapped if the mapped PFN is a
+		 * writeable COW page.  In the mkwrite case we are creating a
+		 * writable PTE for a shared mapping and we expect the PFNs to
+		 * match. If they don't match, we are likely racing with block
+		 * allocation and mapping invalidation.
+		 */
 		if (pte_pfn(pteval) != page_to_pfn(page)) {
 			WARN_ON_ONCE(!is_zero_pfn(pte_pfn(pteval)));
 			return -EFAULT;
@@ -2864,7 +2871,7 @@ int vm_map_pages_zero(struct vm_area_str
 EXPORT_SYMBOL(vm_map_pages_zero);
 
 static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
-			unsigned long pfn, pgprot_t prot, bool mkwrite)
+			unsigned long pfn, pgprot_t prot)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *pte, entry;
@@ -2874,38 +2881,12 @@ static vm_fault_t insert_pfn(struct vm_a
 	if (!pte)
 		return VM_FAULT_OOM;
 	entry = ptep_get(pte);
-	if (!pte_none(entry)) {
-		if (mkwrite) {
-			/*
-			 * For read faults on private mappings the PFN passed
-			 * in may not match the PFN we have mapped if the
-			 * mapped PFN is a writeable COW page.  In the mkwrite
-			 * case we are creating a writable PTE for a shared
-			 * mapping and we expect the PFNs to match. If they
-			 * don't match, we are likely racing with block
-			 * allocation and mapping invalidation so just skip the
-			 * update.
-			 */
-			if (pte_pfn(entry) != pfn) {
-				WARN_ON_ONCE(!is_zero_pfn(pte_pfn(entry)));
-				goto out_unlock;
-			}
-			entry = pte_mkyoung(entry);
-			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-			if (ptep_set_access_flags(vma, addr, pte, entry, 1))
-				update_mmu_cache(vma, addr, pte);
-		}
+	if (!pte_none(entry))
 		goto out_unlock;
-	}
 
 	/* Ok, finally just insert the thing.. */
 	entry = pte_mkspecial(pfn_pte(pfn, prot));
 
-	if (mkwrite) {
-		entry = pte_mkyoung(entry);
-		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-	}
-
 	set_pte_at(mm, addr, pte, entry);
 	update_mmu_cache(vma, addr, pte); /* XXX: why not for insert_page? */
 
@@ -2973,7 +2954,7 @@ vm_fault_t vmf_insert_pfn_prot(struct vm
 
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
-	return insert_pfn(vma, addr, pfn, pgprot, false);
+	return insert_pfn(vma, addr, pfn, pgprot);
 }
 EXPORT_SYMBOL(vmf_insert_pfn_prot);
 
@@ -3004,11 +2985,9 @@ vm_fault_t vmf_insert_pfn(struct vm_area
 }
 EXPORT_SYMBOL(vmf_insert_pfn);
 
-static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn,
-			bool mkwrite)
+static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn)
 {
-	if (unlikely(is_zero_pfn(pfn)) &&
-	    (mkwrite || !vm_mixed_zeropage_allowed(vma)))
+	if (unlikely(is_zero_pfn(pfn)) && !vm_mixed_zeropage_allowed(vma))
 		return false;
 	/* these checks mirror the abort conditions in vm_normal_page */
 	if (vma->vm_flags & VM_MIXEDMAP)
@@ -3019,12 +2998,12 @@ static bool vm_mixed_ok(struct vm_area_s
 }
 
 static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long pfn, bool mkwrite)
+		unsigned long addr, unsigned long pfn)
 {
 	pgprot_t pgprot = vma->vm_page_prot;
 	int err;
 
-	if (!vm_mixed_ok(vma, pfn, mkwrite))
+	if (!vm_mixed_ok(vma, pfn))
 		return VM_FAULT_SIGBUS;
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
@@ -3051,9 +3030,9 @@ static vm_fault_t __vm_insert_mixed(stru
 		 * result in pfn_t_has_page() == false.
 		 */
 		page = pfn_to_page(pfn);
-		err = insert_page(vma, addr, page, pgprot, mkwrite);
+		err = insert_page(vma, addr, page, pgprot, false);
 	} else {
-		return insert_pfn(vma, addr, pfn, pgprot, mkwrite);
+		return insert_pfn(vma, addr, pfn, pgprot);
 	}
 
 	if (err == -ENOMEM)
@@ -3092,7 +3071,7 @@ EXPORT_SYMBOL_GPL(vmf_insert_page_mkwrit
 vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 		unsigned long pfn)
 {
-	return __vm_insert_mixed(vma, addr, pfn, false);
+	return __vm_insert_mixed(vma, addr, pfn);
 }
 EXPORT_SYMBOL(vmf_insert_mixed);
 
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-memory-remove-unused-vmf_insert_mixed_mkwrite.patch
mm-memory-remove-the-mkwrite-argument-from-__vm_insert_mixed.patch
mm-memory-merge-__vm_insert_mixed-into-vmf_insert_mixed.patch


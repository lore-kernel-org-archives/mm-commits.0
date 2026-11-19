Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061306;
	b=zoYCsvlhLhG2+ysxAN51OSgJ5ItC9DEPCBHWfuJ9cL7y8q8dw4arHsIl9cJIk4F6s7fn
	 JvO+7A7gfYreKlp/J7zwWnAYMF2p27YqVZEV1yTvNO22LXz3qK+q+lV+87bKjf+vJ6poU
	 wd5cCfElkRTquoaqYoDosup5mVaDSqMvyixYNIEBbJNgdcehNLWL7O03/Tze1fqQVlKQa
	 8Gp/zYxzMZMSo5cFOKPBUmiuvj+vC1KHC0p61U+t8J151wvjq3z4j7rT6Su4VP42nHmFn
	 qMJfeoqC6F87RG5IBOtlBWe3s+h9eUSnOxMUSFC946yZGLRixV4iCKQ0egWuFUqtalQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061306;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=4KQrEB/DssrnnrW1UFIcXBXPPoqEGXgo0wJzwU6nLZI=;
	b=lEDY1860dbRi/cr2J4VqMrdyIEtnvtOLUR0INcwHMdUjIo6Jwnl28UGJZHMaqtt1ws3T
	 gNvQrkuVdbDbt98hdNJ8HNQW9An3rWgHDH5M+uHbq8K6aNWfXGXPF633+5KdlkR64sBQI
	 qgfK2jCkbx37VOXJPp22YUdjNGg9CkxSc3wfCuWHaYKEMg/9RVPpT0N/ymj3XZn7yuEQb
	 nXpfOFxt6Kid2fefIIE6nlGpeObBKyG47ORHuhdWKTgBgyGcTWKMd2R5gxqP44IAA1pkl
	 45AH5wCVOKL8Hk4ijSjzB3thTXKMGltoGV7BUvsi3RSMLg2vDb8H5y8uSUmbUeNtIvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Nc7Ic7+f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2762F606A326
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 04:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Nc7Ic7+f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D3C1F000C7;
	Thu, 19 Nov 2026 04:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795061305;
	bh=4KQrEB/DssrnnrW1UFIcXBXPPoqEGXgo0wJzwU6nLZI=;
	h=Date:To:From:Subject;
	b=Nc7Ic7+fOkeqY0kJN2QC9TUE41GSXkZFtudVcsl0ghOD1N8XdGIycAgvMaV/DekYY
	 m3BSsB0U+wi0WdIdAUrRWN2nQATq2APCNRD3aOEXe44Xvm/p95ZRfq9rehDawEvheH
	 fFAa0k4Po+PlDGSnXnBb6ecUx89STlZrlXvOOQ9I=
Date: Wed, 18 Nov 2026 20:08:25 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,david@kernel.org,azpijr@gmail.com,
	anshuman.khandual@arm.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memory-remove-the-mkwrite-argument-from-__vm_insert_mixed.patch removed from -mm tree
Message-Id: <20261119040825.D3D3C1F000C7@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/memory: remove the mkwrite argument from __vm_insert_mixed()
has been removed from the -mm tree.  Its filename was
     mm-memory-remove-the-mkwrite-argument-from-__vm_insert_mixed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 mm/memory.c |   57 +++++++++++++++-----------------------------------
 1 file changed, 18 insertions(+), 39 deletions(-)

--- a/mm/memory.c~mm-memory-remove-the-mkwrite-argument-from-__vm_insert_mixed
+++ a/mm/memory.c
@@ -2474,7 +2474,14 @@ static int insert_page_into_pte_locked(s
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
@@ -2881,7 +2888,7 @@ int vm_map_pages_zero(struct vm_area_str
 EXPORT_SYMBOL(vm_map_pages_zero);
 
 static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
-			unsigned long pfn, pgprot_t prot, bool mkwrite)
+			unsigned long pfn, pgprot_t prot)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *pte, entry;
@@ -2891,38 +2898,12 @@ static vm_fault_t insert_pfn(struct vm_a
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
 
@@ -2990,7 +2971,7 @@ vm_fault_t vmf_insert_pfn_prot(struct vm
 
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
-	return insert_pfn(vma, addr, pfn, pgprot, false);
+	return insert_pfn(vma, addr, pfn, pgprot);
 }
 EXPORT_SYMBOL(vmf_insert_pfn_prot);
 
@@ -3021,11 +3002,9 @@ vm_fault_t vmf_insert_pfn(struct vm_area
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
@@ -3036,12 +3015,12 @@ static bool vm_mixed_ok(struct vm_area_s
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
@@ -3068,9 +3047,9 @@ static vm_fault_t __vm_insert_mixed(stru
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
@@ -3109,7 +3088,7 @@ EXPORT_SYMBOL_GPL(vmf_insert_page_mkwrit
 vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 		unsigned long pfn)
 {
-	return __vm_insert_mixed(vma, addr, pfn, false);
+	return __vm_insert_mixed(vma, addr, pfn);
 }
 EXPORT_SYMBOL(vmf_insert_mixed);
 
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-memory-merge-__vm_insert_mixed-into-vmf_insert_mixed.patch
fault-inject-use-a-shared-initialization-helper-for-the-random-state.patch
fault-inject-fix-wrong-unit-of-verbose_ratelimit_interval_ms.patch
fault-injection-fix-typo-in-failcmdsh.patch


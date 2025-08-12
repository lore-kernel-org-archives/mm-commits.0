Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9CB225D6
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 00:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754959026; cv=none; b=jUPdknUCzrol+sDml8xdHihS3MyAPipWkH1Ow8SZX5ClPGNDmOu4FitElciVbBGPIqgQvz5qMn5F3a1Xz21LXANLgVoxAbDDDnVWAuuY+9sXGtTJaQxdXAF0KZUGsc5jwnvc4/393441I6VKyGmzaQVc8f1VDh/qLCghDmW3Hhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754959026; c=relaxed/simple;
	bh=ItWFLD382yYbNiDwvbBmShJeObhIlVjypjy3O0r2zi8=;
	h=Date:To:From:Subject:Message-Id; b=hjcfOyI9/hnU6dZLQbE3kr48hmcDYB6HJXgfV4BFTLBvizESirmKAihwoUSZe08Gj/QAcccr6Vf9RiXN51su47rYua04MVMcx2/GFiK6N2kV6exc3SUwpr7oJLVR2xUDBiBrbT0JwGgZxTsUYnjxtgQ+Pym4oOE0cgAZHScnavg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aIs0PL39; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aIs0PL39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FCBC4CEED;
	Tue, 12 Aug 2025 00:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754959025;
	bh=ItWFLD382yYbNiDwvbBmShJeObhIlVjypjy3O0r2zi8=;
	h=Date:To:From:Subject:From;
	b=aIs0PL39Y39WPiIgPlsuLSDFS1viUWF7JTxGSpOoUBs0G/VZG/saHEpnZppZzM74f
	 iYVz+TERPnH6SffltV0PPshOrVf6ZratgxDtTvmSPW7WxSOFPzf8c3kopJnKdtfIxc
	 qsAn0ZY49MyvdLuBjpvd4KJr/zpTLpUIGqxPqM/A=
Date: Mon, 11 Aug 2025 17:37:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,sstabellini@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,richard.weiyang@gmail.com,osalvador@suse.de,oleksandr_tyshchenko@epam.com,npiggin@gmail.com,npache@redhat.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,jgross@suse.com,jannh@google.com,jack@suse.cz,hughd@google.com,dev.jain@arm.com,david.vrabel@citrix.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-move-more-common-code-into-insert_pud.patch added to mm-new branch
Message-Id: <20250812003705.38FCBC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: move more common code into insert_pud()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-move-more-common-code-into-insert_pud.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-move-more-common-code-into-insert_pud.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: move more common code into insert_pud()
Date: Mon, 11 Aug 2025 13:26:22 +0200

Let's clean it all further up.

No functional change intended.

Link: https://lkml.kernel.org/r/20250811112631.759341-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-move-more-common-code-into-insert_pud
+++ a/mm/huge_memory.c
@@ -1507,25 +1507,30 @@ static pud_t maybe_pud_mkwrite(pud_t pud
 	return pud;
 }
 
-static void insert_pud(struct vm_area_struct *vma, unsigned long addr,
+static vm_fault_t insert_pud(struct vm_area_struct *vma, unsigned long addr,
 		pud_t *pud, struct folio_or_pfn fop, pgprot_t prot, bool write)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	spinlock_t *ptl;
 	pud_t entry;
 
+	if (addr < vma->vm_start || addr >= vma->vm_end)
+		return VM_FAULT_SIGBUS;
+
+	ptl = pud_lock(mm, pud);
 	if (!pud_none(*pud)) {
 		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
 					  fop.pfn;
 
 		if (write) {
 			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn))
-				return;
+				goto out_unlock;
 			entry = pud_mkyoung(*pud);
 			entry = maybe_pud_mkwrite(pud_mkdirty(entry), vma);
 			if (pudp_set_access_flags(vma, addr, pud, entry, 1))
 				update_mmu_cache_pud(vma, addr, pud);
 		}
-		return;
+		goto out_unlock;
 	}
 
 	if (fop.is_folio) {
@@ -1544,6 +1549,9 @@ static void insert_pud(struct vm_area_st
 	}
 	set_pud_at(mm, addr, pud, entry);
 	update_mmu_cache_pud(vma, addr, pud);
+out_unlock:
+	spin_unlock(ptl);
+	return VM_FAULT_NOPAGE;
 }
 
 /**
@@ -1565,7 +1573,6 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_
 	struct folio_or_pfn fop = {
 		.pfn = pfn,
 	};
-	spinlock_t *ptl;
 
 	/*
 	 * If we had pud_special, we could avoid all these restrictions,
@@ -1577,16 +1584,9 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_
 						(VM_PFNMAP|VM_MIXEDMAP));
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
 
-	if (addr < vma->vm_start || addr >= vma->vm_end)
-		return VM_FAULT_SIGBUS;
-
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
-	ptl = pud_lock(vma->vm_mm, vmf->pud);
-	insert_pud(vma, addr, vmf->pud, fop, pgprot, write);
-	spin_unlock(ptl);
-
-	return VM_FAULT_NOPAGE;
+	return insert_pud(vma, addr, vmf->pud, fop, pgprot, write);
 }
 EXPORT_SYMBOL_GPL(vmf_insert_pfn_pud);
 
@@ -1603,25 +1603,15 @@ vm_fault_t vmf_insert_folio_pud(struct v
 {
 	struct vm_area_struct *vma = vmf->vma;
 	unsigned long addr = vmf->address & PUD_MASK;
-	pud_t *pud = vmf->pud;
-	struct mm_struct *mm = vma->vm_mm;
 	struct folio_or_pfn fop = {
 		.folio = folio,
 		.is_folio = true,
 	};
-	spinlock_t *ptl;
-
-	if (addr < vma->vm_start || addr >= vma->vm_end)
-		return VM_FAULT_SIGBUS;
 
 	if (WARN_ON_ONCE(folio_order(folio) != PUD_ORDER))
 		return VM_FAULT_SIGBUS;
 
-	ptl = pud_lock(mm, pud);
-	insert_pud(vma, addr, vmf->pud, fop, vma->vm_page_prot, write);
-	spin_unlock(ptl);
-
-	return VM_FAULT_NOPAGE;
+	return insert_pud(vma, addr, vmf->pud, fop, vma->vm_page_prot, write);
 }
 EXPORT_SYMBOL_GPL(vmf_insert_folio_pud);
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
_

Patches currently in -mm which might be from david@redhat.com are

mm-migrate-remove-migratepage_unmap.patch
treewide-remove-migratepage_success.patch
mm-huge_memory-move-more-common-code-into-insert_pmd.patch
mm-huge_memory-move-more-common-code-into-insert_pud.patch
mm-huge_memory-support-huge-zero-folio-in-vmf_insert_folio_pmd.patch
fs-dax-use-vmf_insert_folio_pmd-to-insert-the-huge-zero-folio.patch
mm-huge_memory-mark-pmd-mappings-of-the-huge-zero-folio-special.patch
mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch
mm-memory-convert-print_bad_pte-to-print_bad_page_map.patch
mm-memory-factor-out-common-code-from-vm_normal_page_.patch
mm-introduce-and-use-vm_normal_page_pud.patch
mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page.patch


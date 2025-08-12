Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB9F2586CE
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 00:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754959047; cv=none; b=ouGsJ+yRLNt/5Vb4iTaQ4SJkdkGu3VwUytU97GjwBP+8jfrUdDlobX+YMftDq10hiWfJSacgerGansYu+Ih/JdZQwe9Mhp1nvT8131ggRPQys+YqHcv5OYFwHNrJGo3AJbC/aTdro27DFWd7lU2qNk0A3dB7G4fSz/MEkbUD0U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754959047; c=relaxed/simple;
	bh=NCNccTexDETYJYlpfybQfBiDv/E2Xg7Fcn4Qvj6dUjo=;
	h=Date:To:From:Subject:Message-Id; b=o8LXcxNCI7KkANew2pn6ud+FGCgr5EIzOk5dm0r4cnfwo/IOzsWrdmBUlbAaFHDzUMwf3wawaotcnviJaO1mDYVMf2Nb2DV0ums21Qzu87TlujfZLt9UYq9HPJymtsdg5ZKHULoOdCn/JoOoiIIQr6ECk2Z7fRGPKq0twl6jcdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dIZv2TY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dIZv2TY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBEC6C4CEED;
	Tue, 12 Aug 2025 00:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754959047;
	bh=NCNccTexDETYJYlpfybQfBiDv/E2Xg7Fcn4Qvj6dUjo=;
	h=Date:To:From:Subject:From;
	b=dIZv2TY+zhKN19qZ6luw0DhkW97yp/4p18fu3zeIqw1t8iIk4j0cHVMOWlqnL3CJ8
	 0FzC3Z16qLdMn6rqtBiRMGfb2U1JmhfrYl6Qaoiod0rU29KpIgb1T/lyDPt/BysnO+
	 OPWHMYz5ePLTb/vNIvWGbulG9x6Qmf84mU/3UezM=
Date: Mon, 11 Aug 2025 17:37:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,sstabellini@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,richard.weiyang@gmail.com,osalvador@suse.de,oleksandr_tyshchenko@epam.com,npiggin@gmail.com,npache@redhat.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,jgross@suse.com,jannh@google.com,jack@suse.cz,hughd@google.com,dev.jain@arm.com,david.vrabel@citrix.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page.patch added to mm-new branch
Message-Id: <20250812003726.DBEC6C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rename vm_ops->find_special_page() to vm_ops->find_normal_page()
has been added to the -mm mm-new branch.  Its filename is
     mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page.patch

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
Subject: mm: rename vm_ops->find_special_page() to vm_ops->find_normal_page()
Date: Mon, 11 Aug 2025 13:26:31 +0200

...  and hide it behind a kconfig option.  There is really no need for any
!xen code to perform this check.

The naming is a bit off: we want to find the "normal" page when a PTE was
marked "special".  So it's really not "finding a special" page.

Improve the documentation, and add a comment in the code where XEN ends up
performing the pte_mkspecial() through a hypercall.  More details can be
found in commit 923b2919e2c3 ("xen/gntdev: mark userspace PTEs as special
on x86 PV guests").

Link: https://lkml.kernel.org/r/20250811112631.759341-12-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Williams <dan.j.williams@intel.com>
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

 drivers/xen/Kconfig              |    1 +
 drivers/xen/gntdev.c             |    5 +++--
 include/linux/mm.h               |   18 +++++++++++++-----
 mm/Kconfig                       |    2 ++
 mm/memory.c                      |   12 ++++++++++--
 tools/testing/vma/vma_internal.h |   18 +++++++++++++-----
 6 files changed, 42 insertions(+), 14 deletions(-)

--- a/drivers/xen/gntdev.c~mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page
+++ a/drivers/xen/gntdev.c
@@ -321,6 +321,7 @@ static int find_grant_ptes(pte_t *pte, u
 	BUG_ON(pgnr >= map->count);
 	pte_maddr = arbitrary_virt_to_machine(pte).maddr;
 
+	/* Note: this will perform a pte_mkspecial() through the hypercall. */
 	gnttab_set_map_op(&map->map_ops[pgnr], pte_maddr, flags,
 			  map->grants[pgnr].ref,
 			  map->grants[pgnr].domid);
@@ -528,7 +529,7 @@ static void gntdev_vma_close(struct vm_a
 	gntdev_put_map(priv, map);
 }
 
-static struct page *gntdev_vma_find_special_page(struct vm_area_struct *vma,
+static struct page *gntdev_vma_find_normal_page(struct vm_area_struct *vma,
 						 unsigned long addr)
 {
 	struct gntdev_grant_map *map = vma->vm_private_data;
@@ -539,7 +540,7 @@ static struct page *gntdev_vma_find_spec
 static const struct vm_operations_struct gntdev_vmops = {
 	.open = gntdev_vma_open,
 	.close = gntdev_vma_close,
-	.find_special_page = gntdev_vma_find_special_page,
+	.find_normal_page = gntdev_vma_find_normal_page,
 };
 
 /* ------------------------------------------------------------------ */
--- a/drivers/xen/Kconfig~mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page
+++ a/drivers/xen/Kconfig
@@ -138,6 +138,7 @@ config XEN_GNTDEV
 	depends on XEN
 	default m
 	select MMU_NOTIFIER
+	select FIND_NORMAL_PAGE
 	help
 	  Allows userspace processes to use grants.
 
--- a/include/linux/mm.h~mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page
+++ a/include/linux/mm.h
@@ -657,13 +657,21 @@ struct vm_operations_struct {
 	struct mempolicy *(*get_policy)(struct vm_area_struct *vma,
 					unsigned long addr, pgoff_t *ilx);
 #endif
+#ifdef CONFIG_FIND_NORMAL_PAGE
 	/*
-	 * Called by vm_normal_page() for special PTEs to find the
-	 * page for @addr.  This is useful if the default behavior
-	 * (using pte_page()) would not find the correct page.
+	 * Called by vm_normal_page() for special PTEs in @vma at @addr. This
+	 * allows for returning a "normal" page from vm_normal_page() even
+	 * though the PTE indicates that the "struct page" either does not exist
+	 * or should not be touched: "special".
+	 *
+	 * Do not add new users: this really only works when a "normal" page
+	 * was mapped, but then the PTE got changed to something weird (+
+	 * marked special) that would not make pte_pfn() identify the originally
+	 * inserted page.
 	 */
-	struct page *(*find_special_page)(struct vm_area_struct *vma,
-					  unsigned long addr);
+	struct page *(*find_normal_page)(struct vm_area_struct *vma,
+					 unsigned long addr);
+#endif /* CONFIG_FIND_NORMAL_PAGE */
 };
 
 #ifdef CONFIG_NUMA_BALANCING
--- a/mm/Kconfig~mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page
+++ a/mm/Kconfig
@@ -1381,6 +1381,8 @@ config PT_RECLAIM
 
 	  Note: now only empty user PTE page table pages will be reclaimed.
 
+config FIND_NORMAL_PAGE
+	def_bool n
 
 source "mm/damon/Kconfig"
 
--- a/mm/memory.c~mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page
+++ a/mm/memory.c
@@ -639,6 +639,12 @@ static void print_bad_page_map(struct vm
  * trivial. Secondly, an architecture may not have a spare page table
  * entry bit, which requires a more complicated scheme, described below.
  *
+ * With CONFIG_FIND_NORMAL_PAGE, we might have the "special" bit set on
+ * page table entries that actually map "normal" pages: however, that page
+ * cannot be looked up through the PFN stored in the page table entry, but
+ * instead will be looked up through vm_ops->find_normal_page(). So far, this
+ * only applies to PTEs.
+ *
  * A raw VM_PFNMAP mapping (ie. one that is not COWed) is always considered a
  * special mapping (even if there are underlying and valid "struct pages").
  * COWed pages of a VM_PFNMAP are always normal.
@@ -679,8 +685,10 @@ static inline struct page *__vm_normal_p
 {
 	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
 		if (unlikely(special)) {
-			if (vma->vm_ops && vma->vm_ops->find_special_page)
-				return vma->vm_ops->find_special_page(vma, addr);
+#ifdef CONFIG_FIND_NORMAL_PAGE
+			if (vma->vm_ops && vma->vm_ops->find_normal_page)
+				return vma->vm_ops->find_normal_page(vma, addr);
+#endif /* CONFIG_FIND_NORMAL_PAGE */
 			if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
 				return NULL;
 			if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
--- a/tools/testing/vma/vma_internal.h~mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page
+++ a/tools/testing/vma/vma_internal.h
@@ -467,13 +467,21 @@ struct vm_operations_struct {
 	struct mempolicy *(*get_policy)(struct vm_area_struct *vma,
 					unsigned long addr, pgoff_t *ilx);
 #endif
+#ifdef CONFIG_FIND_NORMAL_PAGE
 	/*
-	 * Called by vm_normal_page() for special PTEs to find the
-	 * page for @addr.  This is useful if the default behavior
-	 * (using pte_page()) would not find the correct page.
+	 * Called by vm_normal_page() for special PTEs in @vma at @addr. This
+	 * allows for returning a "normal" page from vm_normal_page() even
+	 * though the PTE indicates that the "struct page" either does not exist
+	 * or should not be touched: "special".
+	 *
+	 * Do not add new users: this really only works when a "normal" page
+	 * was mapped, but then the PTE got changed to something weird (+
+	 * marked special) that would not make pte_pfn() identify the originally
+	 * inserted page.
 	 */
-	struct page *(*find_special_page)(struct vm_area_struct *vma,
-					  unsigned long addr);
+	struct page *(*find_normal_page)(struct vm_area_struct *vma,
+					 unsigned long addr);
+#endif /* CONFIG_FIND_NORMAL_PAGE */
 };
 
 struct vm_unmapped_area_info {
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


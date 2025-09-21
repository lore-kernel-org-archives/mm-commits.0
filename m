Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3D429ACC3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489883; cv=none; b=aEgiNY78Xudk2fU7dI0KHFwHH41C7kwY3VqmvAncq04sHr4nEgkwtY+HlzFrxnPOaGrg5akt8rpvThXEvm41tjQ0Iczu+ZNPr12571pZiy8G/AG5GCqsbVuF0k01r/mIVo5lSCMqjyn8p0z/BsaUG7Pag6exJTwIWpwOiTdfKwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489883; c=relaxed/simple;
	bh=2KqnaKNz46v9fjVUH93YZXDmJOQ0F2aNb4JE2VKPnoA=;
	h=Date:To:From:Subject:Message-Id; b=mtVRS6UMsWILZRD1XCFCE4DX1j2QFX0ABQqDpwQRf3RU9PS55XwqSmGvX8CFcmiVBOzhB68JbRnZE34rufEeYVjAka3JGQP7zGaVbL0TIxiyKjJjnbEhgIWM5/MAcat2nAdrecQN1/3/r6hcawolyoNYydmozY+AdrYIF/5h4Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L+41UU2j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L+41UU2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CD8C4CEE7;
	Sun, 21 Sep 2025 21:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489883;
	bh=2KqnaKNz46v9fjVUH93YZXDmJOQ0F2aNb4JE2VKPnoA=;
	h=Date:To:From:Subject:From;
	b=L+41UU2jwKEkZnlGLenUiG26m7NJ3KMD16O0/kkfb4WIP48aGR0xVgvE5H8l7xS9F
	 HTCw35ELJu3TwGDl7Ohco9n8FqcxfpF7eSYn+yGmG9S8lJkK9jfEM2f0JnxR6E1N08
	 15f811FhW7xYmOxceWe1OdCx7/Bl8shOEKi7eEvY=
Date: Sun, 21 Sep 2025 14:24:43 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,willy@infradead.org,weixugc@google.com,vishal.moola@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,thuth@redhat.com,tglx@linutronix.de,svens@linux.ibm.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rientjes@google.com,peterz@infradead.org,osalvador@suse.de,nysal@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,lorenzo.stoakes@oracle.com,linux@armlinux.org.uk,liam.howlett@oracle.com,jfalempe@redhat.com,jcmvbkbc@gmail.com,james.bottomley@HansenPartnership.com,jack@suse.cz,hughd@google.com,hpa@zytor.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,deller@gmx.de,david@redhat.com,davem@davemloft.net,chris@zankel.net,broonie@kernel.org,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,andreas@gaisler.com,agordeev@linux.ibm.com,max.kellermann@ionos.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-constify-assert-test-functions-in-mmh.patch removed from -mm tree
Message-Id: <20250921212443.83CD8C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: constify assert/test functions in mm.h
has been removed from the -mm tree.  Its filename was
     mm-constify-assert-test-functions-in-mmh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Max Kellermann <max.kellermann@ionos.com>
Subject: mm: constify assert/test functions in mm.h
Date: Mon, 1 Sep 2025 22:50:20 +0200

For improved const-correctness.

We select certain assert and test functions which either invoke each
other, functions that are already const-ified, or no further functions.

It is therefore relatively trivial to const-ify them, which provides a
basis for further const-ification further up the call stack.

Link: https://lkml.kernel.org/r/20250901205021.3573313-12-max.kellermann@ionos.com
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christian Zankel <chris@zankel.net>
Cc: David Rientjes <rientjes@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jocelyn Falempe <jfalempe@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Nysal Jan K.A" <nysal@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russel King <linux@armlinux.org.uk>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/include/linux/mm.h~mm-constify-assert-test-functions-in-mmh
+++ a/include/linux/mm.h
@@ -719,7 +719,7 @@ static inline void release_fault_lock(st
 		mmap_read_unlock(vmf->vma->vm_mm);
 }
 
-static inline void assert_fault_locked(struct vm_fault *vmf)
+static inline void assert_fault_locked(const struct vm_fault *vmf)
 {
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK)
 		vma_assert_locked(vmf->vma);
@@ -732,7 +732,7 @@ static inline void release_fault_lock(st
 	mmap_read_unlock(vmf->vma->vm_mm);
 }
 
-static inline void assert_fault_locked(struct vm_fault *vmf)
+static inline void assert_fault_locked(const struct vm_fault *vmf)
 {
 	mmap_assert_locked(vmf->vma->vm_mm);
 }
@@ -875,7 +875,7 @@ static inline bool vma_is_initial_stack(
 		vma->vm_end >= vma->vm_mm->start_stack;
 }
 
-static inline bool vma_is_temporary_stack(struct vm_area_struct *vma)
+static inline bool vma_is_temporary_stack(const struct vm_area_struct *vma)
 {
 	int maybe_stack = vma->vm_flags & (VM_GROWSDOWN | VM_GROWSUP);
 
@@ -889,7 +889,7 @@ static inline bool vma_is_temporary_stac
 	return false;
 }
 
-static inline bool vma_is_foreign(struct vm_area_struct *vma)
+static inline bool vma_is_foreign(const struct vm_area_struct *vma)
 {
 	if (!current->mm)
 		return true;
@@ -900,7 +900,7 @@ static inline bool vma_is_foreign(struct
 	return false;
 }
 
-static inline bool vma_is_accessible(struct vm_area_struct *vma)
+static inline bool vma_is_accessible(const struct vm_area_struct *vma)
 {
 	return vma->vm_flags & VM_ACCESS_FLAGS;
 }
@@ -911,7 +911,7 @@ static inline bool is_shared_maywrite(vm
 		(VM_SHARED | VM_MAYWRITE);
 }
 
-static inline bool vma_is_shared_maywrite(struct vm_area_struct *vma)
+static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 {
 	return is_shared_maywrite(vma->vm_flags);
 }
@@ -1855,7 +1855,7 @@ static inline struct folio *pfn_folio(un
 }
 
 #ifdef CONFIG_MMU
-static inline pte_t mk_pte(struct page *page, pgprot_t pgprot)
+static inline pte_t mk_pte(const struct page *page, pgprot_t pgprot)
 {
 	return pfn_pte(page_to_pfn(page), pgprot);
 }
@@ -1870,7 +1870,7 @@ static inline pte_t mk_pte(struct page *
  *
  * Return: A page table entry suitable for mapping this folio.
  */
-static inline pte_t folio_mk_pte(struct folio *folio, pgprot_t pgprot)
+static inline pte_t folio_mk_pte(const struct folio *folio, pgprot_t pgprot)
 {
 	return pfn_pte(folio_pfn(folio), pgprot);
 }
@@ -1886,7 +1886,7 @@ static inline pte_t folio_mk_pte(struct
  *
  * Return: A page table entry suitable for mapping this folio.
  */
-static inline pmd_t folio_mk_pmd(struct folio *folio, pgprot_t pgprot)
+static inline pmd_t folio_mk_pmd(const struct folio *folio, pgprot_t pgprot)
 {
 	return pmd_mkhuge(pfn_pmd(folio_pfn(folio), pgprot));
 }
@@ -1902,7 +1902,7 @@ static inline pmd_t folio_mk_pmd(struct
  *
  * Return: A page table entry suitable for mapping this folio.
  */
-static inline pud_t folio_mk_pud(struct folio *folio, pgprot_t pgprot)
+static inline pud_t folio_mk_pud(const struct folio *folio, pgprot_t pgprot)
 {
 	return pud_mkhuge(pfn_pud(folio_pfn(folio), pgprot));
 }
@@ -3520,7 +3520,7 @@ struct vm_area_struct *vma_lookup(struct
 	return mtree_load(&mm->mm_mt, addr);
 }
 
-static inline unsigned long stack_guard_start_gap(struct vm_area_struct *vma)
+static inline unsigned long stack_guard_start_gap(const struct vm_area_struct *vma)
 {
 	if (vma->vm_flags & VM_GROWSDOWN)
 		return stack_guard_gap;
@@ -3532,7 +3532,7 @@ static inline unsigned long stack_guard_
 	return 0;
 }
 
-static inline unsigned long vm_start_gap(struct vm_area_struct *vma)
+static inline unsigned long vm_start_gap(const struct vm_area_struct *vma)
 {
 	unsigned long gap = stack_guard_start_gap(vma);
 	unsigned long vm_start = vma->vm_start;
@@ -3543,7 +3543,7 @@ static inline unsigned long vm_start_gap
 	return vm_start;
 }
 
-static inline unsigned long vm_end_gap(struct vm_area_struct *vma)
+static inline unsigned long vm_end_gap(const struct vm_area_struct *vma)
 {
 	unsigned long vm_end = vma->vm_end;
 
@@ -3555,7 +3555,7 @@ static inline unsigned long vm_end_gap(s
 	return vm_end;
 }
 
-static inline unsigned long vma_pages(struct vm_area_struct *vma)
+static inline unsigned long vma_pages(const struct vm_area_struct *vma)
 {
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
@@ -3572,7 +3572,7 @@ static inline struct vm_area_struct *fin
 	return vma;
 }
 
-static inline bool range_in_vma(struct vm_area_struct *vma,
+static inline bool range_in_vma(const struct vm_area_struct *vma,
 				unsigned long start, unsigned long end)
 {
 	return (vma && vma->vm_start <= start && end <= vma->vm_end);
@@ -3688,7 +3688,7 @@ static inline int vm_fault_to_errno(vm_f
  * Indicates whether GUP can follow a PROT_NONE mapped page, or whether
  * a (NUMA hinting) fault is required.
  */
-static inline bool gup_can_follow_protnone(struct vm_area_struct *vma,
+static inline bool gup_can_follow_protnone(const struct vm_area_struct *vma,
 					   unsigned int flags)
 {
 	/*
@@ -3818,7 +3818,7 @@ static inline bool debug_guardpage_enabl
 	return static_branch_unlikely(&_debug_guardpage_enabled);
 }
 
-static inline bool page_is_guard(struct page *page)
+static inline bool page_is_guard(const struct page *page)
 {
 	if (!debug_guardpage_enabled())
 		return false;
@@ -3849,7 +3849,7 @@ static inline void debug_pagealloc_map_p
 static inline void debug_pagealloc_unmap_pages(struct page *page, int numpages) {}
 static inline unsigned int debug_guardpage_minorder(void) { return 0; }
 static inline bool debug_guardpage_enabled(void) { return false; }
-static inline bool page_is_guard(struct page *page) { return false; }
+static inline bool page_is_guard(const struct page *page) { return false; }
 static inline bool set_page_guard(struct zone *zone, struct page *page,
 			unsigned int order) { return false; }
 static inline void clear_page_guard(struct zone *zone, struct page *page,
@@ -3931,7 +3931,7 @@ void vmemmap_free(unsigned long start, u
 #endif
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-static inline unsigned long vmem_altmap_offset(struct vmem_altmap *altmap)
+static inline unsigned long vmem_altmap_offset(const struct vmem_altmap *altmap)
 {
 	/* number of pfns from base where pfn_to_page() is valid */
 	if (altmap)
@@ -3945,7 +3945,7 @@ static inline void vmem_altmap_free(stru
 	altmap->alloc -= nr_pfns;
 }
 #else
-static inline unsigned long vmem_altmap_offset(struct vmem_altmap *altmap)
+static inline unsigned long vmem_altmap_offset(const struct vmem_altmap *altmap)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from max.kellermann@ionos.com are



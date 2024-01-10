Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9D52CA4
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 05:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V+8yKWd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCD0C433C7;
	Wed, 10 Jan 2024 05:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704864033;
	bh=tkNgpVK4QBL4n7WUCGJMsVmzoSiQ32Vb6pel9rrv1vQ=;
	h=Date:To:From:Subject:From;
	b=V+8yKWd9YQL/iLSGocuuId+fFchScefc3S0UwnHBRs15PwcdhI1FvCpkp/Hq99Jeb
	 hFO6Mi6qCNyL/T21lan9U7bdagfnkcScAQ/jtZYb+y/FVF+6gfrtp6CyerKvhgQZoJ
	 F3BcRMZi9lkMda9FK1QPiJk4W8m980hqi0sPZ71o=
Date: Tue, 09 Jan 2024 21:20:33 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,mhocko@suse.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,anshuman.khandual@arm.com,aneesh.kumar@linux.ibm.com,agordeev@linux.ibm.com,sumanthk@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-mm-allocate-vmemmap-pages-from-self-contained-memory-range.patch added to mm-unstable branch
Message-Id: <20240110052033.DBCD0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390/mm: allocate vmemmap pages from self-contained memory range
has been added to the -mm mm-unstable branch.  Its filename is
     s390-mm-allocate-vmemmap-pages-from-self-contained-memory-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-mm-allocate-vmemmap-pages-from-self-contained-memory-range.patch

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
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: s390/mm: allocate vmemmap pages from self-contained memory range
Date: Mon, 8 Jan 2024 14:27:44 +0100

Allocate memory map (struct pages array) from the hotplugged memory
range, rather than using system memory. The change addresses the issue
where standby memory, when configured to be much larger than online
memory, could potentially lead to ipl failure due to memory map
allocation from online memory. For example, 16MB of memory map
allocation is needed for a memory block size of 1GB and when standby
memory is configured much larger than online memory, this could lead to
ipl failure.

To address this issue, the solution involves introducing "memmap on
memory" using the vmem_altmap structure on s390.  Architectures that
want to implement it should pass the altmap to the vmemmap_populate()
function and its associated callchain. This enhancement is discussed in
commit 4b94ffdc4163 ("x86, mm: introduce vmem_altmap to augment
vmemmap_populate()")

Provide "memmap on memory" support for s390 by passing the altmap in
vmemmap_populate() and its callchain. The allocation path is described
as follows:
* When altmap is NULL in vmemmap_populate(), memory map allocation
  occurs using the existing vmemmap_alloc_block_buf().
* When altmap is not NULL in vmemmap_populate(), memory map allocation
  still uses vmemmap_alloc_block_buf(), but this function internally
  calls altmap_alloc_block_buf().

For deallocation, the process is outlined as follows:
* When altmap is NULL in vmemmap_free(), memory map deallocation happens
  through free_pages().
* When altmap is not NULL in vmemmap_free(), memory map deallocation
  occurs via vmem_altmap_free().

While memory map allocation is primarily handled through the
self-contained memory map range, there might still be a small amount of
system memory allocation required for vmemmap pagetables. To mitigate
this impact, this feature will be limited to machines with EDAT1
support.

Link: https://lkml.kernel.org/r/20240108132747.3238763-3-sumanthk@linux.ibm.com
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/init.c |    3 --
 arch/s390/mm/vmem.c |   62 +++++++++++++++++++++++-------------------
 2 files changed, 35 insertions(+), 30 deletions(-)

--- a/arch/s390/mm/init.c~s390-mm-allocate-vmemmap-pages-from-self-contained-memory-range
+++ a/arch/s390/mm/init.c
@@ -281,9 +281,6 @@ int arch_add_memory(int nid, u64 start,
 	unsigned long size_pages = PFN_DOWN(size);
 	int rc;
 
-	if (WARN_ON_ONCE(params->altmap))
-		return -EINVAL;
-
 	if (WARN_ON_ONCE(params->pgprot.pgprot != PAGE_KERNEL.pgprot))
 		return -EINVAL;
 
--- a/arch/s390/mm/vmem.c~s390-mm-allocate-vmemmap-pages-from-self-contained-memory-range
+++ a/arch/s390/mm/vmem.c
@@ -33,8 +33,12 @@ static void __ref *vmem_alloc_pages(unsi
 	return memblock_alloc(size, size);
 }
 
-static void vmem_free_pages(unsigned long addr, int order)
+static void vmem_free_pages(unsigned long addr, int order, struct vmem_altmap *altmap)
 {
+	if (altmap) {
+		vmem_altmap_free(altmap, 1 << order);
+		return;
+	}
 	/* We don't expect boot memory to be removed ever. */
 	if (!slab_is_available() ||
 	    WARN_ON_ONCE(PageReserved(virt_to_page((void *)addr))))
@@ -156,7 +160,8 @@ static bool vmemmap_unuse_sub_pmd(unsign
 
 /* __ref: we'll only call vmemmap_alloc_block() via vmemmap_populate() */
 static int __ref modify_pte_table(pmd_t *pmd, unsigned long addr,
-				  unsigned long end, bool add, bool direct)
+				  unsigned long end, bool add, bool direct,
+				  struct vmem_altmap *altmap)
 {
 	unsigned long prot, pages = 0;
 	int ret = -ENOMEM;
@@ -172,11 +177,11 @@ static int __ref modify_pte_table(pmd_t
 			if (pte_none(*pte))
 				continue;
 			if (!direct)
-				vmem_free_pages((unsigned long) pfn_to_virt(pte_pfn(*pte)), 0);
+				vmem_free_pages((unsigned long)pfn_to_virt(pte_pfn(*pte)), get_order(PAGE_SIZE), altmap);
 			pte_clear(&init_mm, addr, pte);
 		} else if (pte_none(*pte)) {
 			if (!direct) {
-				void *new_page = vmemmap_alloc_block(PAGE_SIZE, NUMA_NO_NODE);
+				void *new_page = vmemmap_alloc_block_buf(PAGE_SIZE, NUMA_NO_NODE, altmap);
 
 				if (!new_page)
 					goto out;
@@ -213,7 +218,8 @@ static void try_free_pte_table(pmd_t *pm
 
 /* __ref: we'll only call vmemmap_alloc_block() via vmemmap_populate() */
 static int __ref modify_pmd_table(pud_t *pud, unsigned long addr,
-				  unsigned long end, bool add, bool direct)
+				  unsigned long end, bool add, bool direct,
+				  struct vmem_altmap *altmap)
 {
 	unsigned long next, prot, pages = 0;
 	int ret = -ENOMEM;
@@ -234,11 +240,11 @@ static int __ref modify_pmd_table(pud_t
 				if (IS_ALIGNED(addr, PMD_SIZE) &&
 				    IS_ALIGNED(next, PMD_SIZE)) {
 					if (!direct)
-						vmem_free_pages(pmd_deref(*pmd), get_order(PMD_SIZE));
+						vmem_free_pages(pmd_deref(*pmd), get_order(PMD_SIZE), altmap);
 					pmd_clear(pmd);
 					pages++;
 				} else if (!direct && vmemmap_unuse_sub_pmd(addr, next)) {
-					vmem_free_pages(pmd_deref(*pmd), get_order(PMD_SIZE));
+					vmem_free_pages(pmd_deref(*pmd), get_order(PMD_SIZE), altmap);
 					pmd_clear(pmd);
 				}
 				continue;
@@ -261,7 +267,7 @@ static int __ref modify_pmd_table(pud_t
 				 * page tables since vmemmap_populate gets
 				 * called for each section separately.
 				 */
-				new_page = vmemmap_alloc_block(PMD_SIZE, NUMA_NO_NODE);
+				new_page = vmemmap_alloc_block_buf(PMD_SIZE, NUMA_NO_NODE, altmap);
 				if (new_page) {
 					set_pmd(pmd, __pmd(__pa(new_page) | prot));
 					if (!IS_ALIGNED(addr, PMD_SIZE) ||
@@ -280,7 +286,7 @@ static int __ref modify_pmd_table(pud_t
 				vmemmap_use_sub_pmd(addr, next);
 			continue;
 		}
-		ret = modify_pte_table(pmd, addr, next, add, direct);
+		ret = modify_pte_table(pmd, addr, next, add, direct, altmap);
 		if (ret)
 			goto out;
 		if (!add)
@@ -302,12 +308,12 @@ static void try_free_pmd_table(pud_t *pu
 	for (i = 0; i < PTRS_PER_PMD; i++, pmd++)
 		if (!pmd_none(*pmd))
 			return;
-	vmem_free_pages(pud_deref(*pud), CRST_ALLOC_ORDER);
+	vmem_free_pages(pud_deref(*pud), CRST_ALLOC_ORDER, NULL);
 	pud_clear(pud);
 }
 
 static int modify_pud_table(p4d_t *p4d, unsigned long addr, unsigned long end,
-			    bool add, bool direct)
+			    bool add, bool direct, struct vmem_altmap *altmap)
 {
 	unsigned long next, prot, pages = 0;
 	int ret = -ENOMEM;
@@ -347,7 +353,7 @@ static int modify_pud_table(p4d_t *p4d,
 		} else if (pud_large(*pud)) {
 			continue;
 		}
-		ret = modify_pmd_table(pud, addr, next, add, direct);
+		ret = modify_pmd_table(pud, addr, next, add, direct, altmap);
 		if (ret)
 			goto out;
 		if (!add)
@@ -370,12 +376,12 @@ static void try_free_pud_table(p4d_t *p4
 		if (!pud_none(*pud))
 			return;
 	}
-	vmem_free_pages(p4d_deref(*p4d), CRST_ALLOC_ORDER);
+	vmem_free_pages(p4d_deref(*p4d), CRST_ALLOC_ORDER, NULL);
 	p4d_clear(p4d);
 }
 
 static int modify_p4d_table(pgd_t *pgd, unsigned long addr, unsigned long end,
-			    bool add, bool direct)
+			    bool add, bool direct, struct vmem_altmap *altmap)
 {
 	unsigned long next;
 	int ret = -ENOMEM;
@@ -394,7 +400,7 @@ static int modify_p4d_table(pgd_t *pgd,
 				goto out;
 			p4d_populate(&init_mm, p4d, pud);
 		}
-		ret = modify_pud_table(p4d, addr, next, add, direct);
+		ret = modify_pud_table(p4d, addr, next, add, direct, altmap);
 		if (ret)
 			goto out;
 		if (!add)
@@ -415,12 +421,12 @@ static void try_free_p4d_table(pgd_t *pg
 		if (!p4d_none(*p4d))
 			return;
 	}
-	vmem_free_pages(pgd_deref(*pgd), CRST_ALLOC_ORDER);
+	vmem_free_pages(pgd_deref(*pgd), CRST_ALLOC_ORDER, NULL);
 	pgd_clear(pgd);
 }
 
 static int modify_pagetable(unsigned long start, unsigned long end, bool add,
-			    bool direct)
+			    bool direct, struct vmem_altmap *altmap)
 {
 	unsigned long addr, next;
 	int ret = -ENOMEM;
@@ -445,7 +451,7 @@ static int modify_pagetable(unsigned lon
 				goto out;
 			pgd_populate(&init_mm, pgd, p4d);
 		}
-		ret = modify_p4d_table(pgd, addr, next, add, direct);
+		ret = modify_p4d_table(pgd, addr, next, add, direct, altmap);
 		if (ret)
 			goto out;
 		if (!add)
@@ -458,14 +464,16 @@ out:
 	return ret;
 }
 
-static int add_pagetable(unsigned long start, unsigned long end, bool direct)
+static int add_pagetable(unsigned long start, unsigned long end, bool direct,
+			 struct vmem_altmap *altmap)
 {
-	return modify_pagetable(start, end, true, direct);
+	return modify_pagetable(start, end, true, direct, altmap);
 }
 
-static int remove_pagetable(unsigned long start, unsigned long end, bool direct)
+static int remove_pagetable(unsigned long start, unsigned long end, bool direct,
+			    struct vmem_altmap *altmap)
 {
-	return modify_pagetable(start, end, false, direct);
+	return modify_pagetable(start, end, false, direct, altmap);
 }
 
 /*
@@ -474,7 +482,7 @@ static int remove_pagetable(unsigned lon
 static int vmem_add_range(unsigned long start, unsigned long size)
 {
 	start = (unsigned long)__va(start);
-	return add_pagetable(start, start + size, true);
+	return add_pagetable(start, start + size, true, NULL);
 }
 
 /*
@@ -483,7 +491,7 @@ static int vmem_add_range(unsigned long
 static void vmem_remove_range(unsigned long start, unsigned long size)
 {
 	start = (unsigned long)__va(start);
-	remove_pagetable(start, start + size, true);
+	remove_pagetable(start, start + size, true, NULL);
 }
 
 /*
@@ -496,9 +504,9 @@ int __meminit vmemmap_populate(unsigned
 
 	mutex_lock(&vmem_mutex);
 	/* We don't care about the node, just use NUMA_NO_NODE on allocations */
-	ret = add_pagetable(start, end, false);
+	ret = add_pagetable(start, end, false, altmap);
 	if (ret)
-		remove_pagetable(start, end, false);
+		remove_pagetable(start, end, false, altmap);
 	mutex_unlock(&vmem_mutex);
 	return ret;
 }
@@ -509,7 +517,7 @@ void vmemmap_free(unsigned long start, u
 		  struct vmem_altmap *altmap)
 {
 	mutex_lock(&vmem_mutex);
-	remove_pagetable(start, end, false);
+	remove_pagetable(start, end, false, altmap);
 	mutex_unlock(&vmem_mutex);
 }
 
_

Patches currently in -mm which might be from sumanthk@linux.ibm.com are

mm-memory_hotplug-introduce-mem_prepare_online-mem_finish_offline-notifiers.patch
s390-mm-allocate-vmemmap-pages-from-self-contained-memory-range.patch
s390-sclp-remove-unhandled-memory-notifier-type.patch
s390-mm-implement-mem_prepare_online-mem_finish_offline-notifiers.patch
s390-enable-mhp_memmap_on_memory.patch


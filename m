From: akpm@linux-foundation.org
Subject: [merged]
 pagemap-introduce-pagemap_entry_t-without-pmshift-bits.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:23:53 -0700
Message-ID: <51db11c9.cET73P1zKSabAgRf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab3GHTXy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com, mtosatti@redhat.com, mpm@selenic.com, kosaki.motohiro@gmail.com, glommer@parallels.com, xemul@parallels.com

Subject: [merged] pagemap-introduce-pagemap_entry_t-without-pmshift-bits.patch removed from -mm tree
To: xemul@parallels.com,glommer@parallels.com,kosaki.motohiro@gmail.com,mpm@selenic.com,mtosatti@redhat.com,xiaoguangrong@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:53 -0700


The patch titled
     Subject: pagemap: introduce pagemap_entry_t without pmshift bits
has been removed from the -mm tree.  Its filename was
     pagemap-introduce-pagemap_entry_t-without-pmshift-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pavel Emelyanov <xemul@parallels.com>
Subject: pagemap: introduce pagemap_entry_t without pmshift bits

These bits are always constant (== PAGE_SHIFT) and just occupy space in
the entry.  Moreover, in next patch we will need to report one more bit in
the pagemap, but all bits are already busy on it.

That said, describe the pagemap entry that has 6 more free zero bits.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-introduce-pagemap_entry_t-without-pmshift-bits fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-introduce-pagemap_entry_t-without-pmshift-bits
+++ a/fs/proc/task_mmu.c
@@ -807,6 +807,7 @@ typedef struct {
 struct pagemapread {
 	int pos, len;
 	pagemap_entry_t *buffer;
+	bool v2;
 };
 
 #define PAGEMAP_WALK_SIZE	(PMD_SIZE)
@@ -820,14 +821,16 @@ struct pagemapread {
 #define PM_PSHIFT_BITS      6
 #define PM_PSHIFT_OFFSET    (PM_STATUS_OFFSET - PM_PSHIFT_BITS)
 #define PM_PSHIFT_MASK      (((1LL << PM_PSHIFT_BITS) - 1) << PM_PSHIFT_OFFSET)
-#define PM_PSHIFT(x)        (((u64) (x) << PM_PSHIFT_OFFSET) & PM_PSHIFT_MASK)
+#define __PM_PSHIFT(x)      (((u64) (x) << PM_PSHIFT_OFFSET) & PM_PSHIFT_MASK)
 #define PM_PFRAME_MASK      ((1LL << PM_PSHIFT_OFFSET) - 1)
 #define PM_PFRAME(x)        ((x) & PM_PFRAME_MASK)
+/* in "new" pagemap pshift bits are occupied with more status bits */
+#define PM_STATUS2(v2, x)   (__PM_PSHIFT(v2 ? x : PAGE_SHIFT))
 
 #define PM_PRESENT          PM_STATUS(4LL)
 #define PM_SWAP             PM_STATUS(2LL)
 #define PM_FILE             PM_STATUS(1LL)
-#define PM_NOT_PRESENT      PM_PSHIFT(PAGE_SHIFT)
+#define PM_NOT_PRESENT(v2)  PM_STATUS2(v2, 0)
 #define PM_END_OF_BUFFER    1
 
 static inline pagemap_entry_t make_pme(u64 val)
@@ -850,7 +853,7 @@ static int pagemap_pte_hole(unsigned lon
 	struct pagemapread *pm = walk->private;
 	unsigned long addr;
 	int err = 0;
-	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT);
+	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
 
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
 		err = add_to_pagemap(addr, &pme, pm);
@@ -860,7 +863,7 @@ static int pagemap_pte_hole(unsigned lon
 	return err;
 }
 
-static void pte_to_pagemap_entry(pagemap_entry_t *pme,
+static void pte_to_pagemap_entry(pagemap_entry_t *pme, struct pagemapread *pm,
 		struct vm_area_struct *vma, unsigned long addr, pte_t pte)
 {
 	u64 frame, flags;
@@ -879,18 +882,18 @@ static void pte_to_pagemap_entry(pagemap
 		if (is_migration_entry(entry))
 			page = migration_entry_to_page(entry);
 	} else {
-		*pme = make_pme(PM_NOT_PRESENT);
+		*pme = make_pme(PM_NOT_PRESENT(pm->v2));
 		return;
 	}
 
 	if (page && !PageAnon(page))
 		flags |= PM_FILE;
 
-	*pme = make_pme(PM_PFRAME(frame) | PM_PSHIFT(PAGE_SHIFT) | flags);
+	*pme = make_pme(PM_PFRAME(frame) | PM_STATUS2(pm->v2, 0) | flags);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static void thp_pmd_to_pagemap_entry(pagemap_entry_t *pme,
+static void thp_pmd_to_pagemap_entry(pagemap_entry_t *pme, struct pagemapread *pm,
 					pmd_t pmd, int offset)
 {
 	/*
@@ -900,12 +903,12 @@ static void thp_pmd_to_pagemap_entry(pag
 	 */
 	if (pmd_present(pmd))
 		*pme = make_pme(PM_PFRAME(pmd_pfn(pmd) + offset)
-				| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT);
+				| PM_STATUS2(pm->v2, 0) | PM_PRESENT);
 	else
-		*pme = make_pme(PM_NOT_PRESENT);
+		*pme = make_pme(PM_NOT_PRESENT(pm->v2));
 }
 #else
-static inline void thp_pmd_to_pagemap_entry(pagemap_entry_t *pme,
+static inline void thp_pmd_to_pagemap_entry(pagemap_entry_t *pme, struct pagemapread *pm,
 						pmd_t pmd, int offset)
 {
 }
@@ -918,7 +921,7 @@ static int pagemap_pte_range(pmd_t *pmd,
 	struct pagemapread *pm = walk->private;
 	pte_t *pte;
 	int err = 0;
-	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT);
+	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
 
 	/* find the first VMA at or above 'addr' */
 	vma = find_vma(walk->mm, addr);
@@ -928,7 +931,7 @@ static int pagemap_pte_range(pmd_t *pmd,
 
 			offset = (addr & ~PAGEMAP_WALK_MASK) >>
 					PAGE_SHIFT;
-			thp_pmd_to_pagemap_entry(&pme, *pmd, offset);
+			thp_pmd_to_pagemap_entry(&pme, pm, *pmd, offset);
 			err = add_to_pagemap(addr, &pme, pm);
 			if (err)
 				break;
@@ -945,7 +948,7 @@ static int pagemap_pte_range(pmd_t *pmd,
 		 * and need a new, higher one */
 		if (vma && (addr >= vma->vm_end)) {
 			vma = find_vma(walk->mm, addr);
-			pme = make_pme(PM_NOT_PRESENT);
+			pme = make_pme(PM_NOT_PRESENT(pm->v2));
 		}
 
 		/* check that 'vma' actually covers this address,
@@ -953,7 +956,7 @@ static int pagemap_pte_range(pmd_t *pmd,
 		if (vma && (vma->vm_start <= addr) &&
 		    !is_vm_hugetlb_page(vma)) {
 			pte = pte_offset_map(pmd, addr);
-			pte_to_pagemap_entry(&pme, vma, addr, *pte);
+			pte_to_pagemap_entry(&pme, pm, vma, addr, *pte);
 			/* unmap before userspace copy */
 			pte_unmap(pte);
 		}
@@ -968,14 +971,14 @@ static int pagemap_pte_range(pmd_t *pmd,
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-static void huge_pte_to_pagemap_entry(pagemap_entry_t *pme,
+static void huge_pte_to_pagemap_entry(pagemap_entry_t *pme, struct pagemapread *pm,
 					pte_t pte, int offset)
 {
 	if (pte_present(pte))
 		*pme = make_pme(PM_PFRAME(pte_pfn(pte) + offset)
-				| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT);
+				| PM_STATUS2(pm->v2, 0) | PM_PRESENT);
 	else
-		*pme = make_pme(PM_NOT_PRESENT);
+		*pme = make_pme(PM_NOT_PRESENT(pm->v2));
 }
 
 /* This function walks within one hugetlb entry in the single call */
@@ -989,7 +992,7 @@ static int pagemap_hugetlb_range(pte_t *
 
 	for (; addr != end; addr += PAGE_SIZE) {
 		int offset = (addr & ~hmask) >> PAGE_SHIFT;
-		huge_pte_to_pagemap_entry(&pme, *pte, offset);
+		huge_pte_to_pagemap_entry(&pme, pm, *pte, offset);
 		err = add_to_pagemap(addr, &pme, pm);
 		if (err)
 			return err;
@@ -1051,6 +1054,7 @@ static ssize_t pagemap_read(struct file
 	if (!count)
 		goto out_task;
 
+	pm.v2 = false;
 	pm.len = PM_ENTRY_BYTES * (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
 	pm.buffer = kmalloc(pm.len, GFP_TEMPORARY);
 	ret = -ENOMEM;
_

Patches currently in -mm which might be from xemul@parallels.com are

origin.patch
linux-next.patch


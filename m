From: akpm@linux-foundation.org
Subject: + pagemap-switch-to-the-new-format-and-do-some-cleanup.patch
 added to -mm tree
Date: Tue, 14 Jul 2015 11:57:53 -0700
Message-ID: <55a55bb1.unkzLtFeuBqzc1yF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbbGNS5y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 14:57:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, mwilliamson@undo-software.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pagemap: switch to the new format and do some cleanup
has been added to the -mm tree.  Its filename is
     pagemap-switch-to-the-new-format-and-do-some-cleanup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pagemap-switch-to-the-new-format-and-do-some-cleanup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pagemap-switch-to-the-new-format-and-do-some-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: pagemap: switch to the new format and do some cleanup

This patch removes page-shift bits (scheduled to remove since 3.11) and
completes migration to the new bit layout.  Also it cleans messy macro.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mark Williamson <mwilliamson@undo-software.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c    |  150 ++++++++++++++--------------------------
 tools/vm/page-types.c |   25 ++----
 2 files changed, 61 insertions(+), 114 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-switch-to-the-new-format-and-do-some-cleanup fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-switch-to-the-new-format-and-do-some-cleanup
+++ a/fs/proc/task_mmu.c
@@ -713,23 +713,6 @@ const struct file_operations proc_tid_sm
 	.release	= proc_map_release,
 };
 
-/*
- * We do not want to have constant page-shift bits sitting in
- * pagemap entries and are about to reuse them some time soon.
- *
- * Here's the "migration strategy":
- * 1. when the system boots these bits remain what they are,
- *    but a warning about future change is printed in log;
- * 2. once anyone clears soft-dirty bits via clear_refs file,
- *    these flag is set to denote, that user is aware of the
- *    new API and those page-shift bits change their meaning.
- *    The respective warning is printed in dmesg;
- * 3. In a couple of releases we will remove all the mentions
- *    of page-shift in pagemap entries.
- */
-
-static bool soft_dirty_cleared __read_mostly;
-
 enum clear_refs_types {
 	CLEAR_REFS_ALL = 1,
 	CLEAR_REFS_ANON,
@@ -890,13 +873,6 @@ static ssize_t clear_refs_write(struct f
 	if (type < CLEAR_REFS_ALL || type >= CLEAR_REFS_LAST)
 		return -EINVAL;
 
-	if (type == CLEAR_REFS_SOFT_DIRTY) {
-		soft_dirty_cleared = true;
-		pr_warn_once("The pagemap bits 55-60 has changed their meaning!"
-			     " See the linux/Documentation/vm/pagemap.txt for "
-			     "details.\n");
-	}
-
 	task = get_proc_task(file_inode(file));
 	if (!task)
 		return -ESRCH;
@@ -964,36 +940,24 @@ typedef struct {
 struct pagemapread {
 	int pos, len;		/* units: PM_ENTRY_BYTES, not bytes */
 	pagemap_entry_t *buffer;
-	bool v2;
 };
 
 #define PAGEMAP_WALK_SIZE	(PMD_SIZE)
 #define PAGEMAP_WALK_MASK	(PMD_MASK)
 
-#define PM_ENTRY_BYTES      sizeof(pagemap_entry_t)
-#define PM_STATUS_BITS      3
-#define PM_STATUS_OFFSET    (64 - PM_STATUS_BITS)
-#define PM_STATUS_MASK      (((1LL << PM_STATUS_BITS) - 1) << PM_STATUS_OFFSET)
-#define PM_STATUS(nr)       (((nr) << PM_STATUS_OFFSET) & PM_STATUS_MASK)
-#define PM_PSHIFT_BITS      6
-#define PM_PSHIFT_OFFSET    (PM_STATUS_OFFSET - PM_PSHIFT_BITS)
-#define PM_PSHIFT_MASK      (((1LL << PM_PSHIFT_BITS) - 1) << PM_PSHIFT_OFFSET)
-#define __PM_PSHIFT(x)      (((u64) (x) << PM_PSHIFT_OFFSET) & PM_PSHIFT_MASK)
-#define PM_PFRAME_MASK      ((1LL << PM_PSHIFT_OFFSET) - 1)
-#define PM_PFRAME(x)        ((x) & PM_PFRAME_MASK)
-/* in "new" pagemap pshift bits are occupied with more status bits */
-#define PM_STATUS2(v2, x)   (__PM_PSHIFT(v2 ? x : PAGE_SHIFT))
-
-#define __PM_SOFT_DIRTY      (1LL)
-#define PM_PRESENT          PM_STATUS(4LL)
-#define PM_SWAP             PM_STATUS(2LL)
-#define PM_FILE             PM_STATUS(1LL)
-#define PM_NOT_PRESENT(v2)  PM_STATUS2(v2, 0)
+#define PM_ENTRY_BYTES		sizeof(pagemap_entry_t)
+#define PM_PFRAME_BITS		55
+#define PM_PFRAME_MASK		GENMASK_ULL(PM_PFRAME_BITS - 1, 0)
+#define PM_SOFT_DIRTY		BIT_ULL(55)
+#define PM_FILE			BIT_ULL(61)
+#define PM_SWAP			BIT_ULL(62)
+#define PM_PRESENT		BIT_ULL(63)
+
 #define PM_END_OF_BUFFER    1
 
-static inline pagemap_entry_t make_pme(u64 val)
+static inline pagemap_entry_t make_pme(u64 frame, u64 flags)
 {
-	return (pagemap_entry_t) { .pme = val };
+	return (pagemap_entry_t) { .pme = (frame & PM_PFRAME_MASK) | flags };
 }
 
 static int add_to_pagemap(unsigned long addr, pagemap_entry_t *pme,
@@ -1014,7 +978,7 @@ static int pagemap_pte_hole(unsigned lon
 
 	while (addr < end) {
 		struct vm_area_struct *vma = find_vma(walk->mm, addr);
-		pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
+		pagemap_entry_t pme = make_pme(0, 0);
 		/* End of address space hole, which we mark as non-present. */
 		unsigned long hole_end;
 
@@ -1034,7 +998,7 @@ static int pagemap_pte_hole(unsigned lon
 
 		/* Addresses in the VMA. */
 		if (vma->vm_flags & VM_SOFTDIRTY)
-			pme.pme |= PM_STATUS2(pm->v2, __PM_SOFT_DIRTY);
+			pme = make_pme(0, PM_SOFT_DIRTY);
 		for (; addr < min(end, vma->vm_end); addr += PAGE_SIZE) {
 			err = add_to_pagemap(addr, &pme, pm);
 			if (err)
@@ -1045,63 +1009,61 @@ out:
 	return err;
 }
 
-static void pte_to_pagemap_entry(pagemap_entry_t *pme, struct pagemapread *pm,
+static pagemap_entry_t pte_to_pagemap_entry(struct pagemapread *pm,
 		struct vm_area_struct *vma, unsigned long addr, pte_t pte)
 {
-	u64 frame, flags;
+	u64 frame = 0, flags = 0;
 	struct page *page = NULL;
-	int flags2 = 0;
 
 	if (pte_present(pte)) {
 		frame = pte_pfn(pte);
-		flags = PM_PRESENT;
+		flags |= PM_PRESENT;
 		page = vm_normal_page(vma, addr, pte);
 		if (pte_soft_dirty(pte))
-			flags2 |= __PM_SOFT_DIRTY;
+			flags |= PM_SOFT_DIRTY;
 	} else if (is_swap_pte(pte)) {
 		swp_entry_t entry;
 		if (pte_swp_soft_dirty(pte))
-			flags2 |= __PM_SOFT_DIRTY;
+			flags |= PM_SOFT_DIRTY;
 		entry = pte_to_swp_entry(pte);
 		frame = swp_type(entry) |
 			(swp_offset(entry) << MAX_SWAPFILES_SHIFT);
-		flags = PM_SWAP;
+		flags |= PM_SWAP;
 		if (is_migration_entry(entry))
 			page = migration_entry_to_page(entry);
-	} else {
-		if (vma->vm_flags & VM_SOFTDIRTY)
-			flags2 |= __PM_SOFT_DIRTY;
-		*pme = make_pme(PM_NOT_PRESENT(pm->v2) | PM_STATUS2(pm->v2, flags2));
-		return;
 	}
 
 	if (page && !PageAnon(page))
 		flags |= PM_FILE;
-	if ((vma->vm_flags & VM_SOFTDIRTY))
-		flags2 |= __PM_SOFT_DIRTY;
+	if (vma->vm_flags & VM_SOFTDIRTY)
+		flags |= PM_SOFT_DIRTY;
 
-	*pme = make_pme(PM_PFRAME(frame) | PM_STATUS2(pm->v2, flags2) | flags);
+	return make_pme(frame, flags);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static void thp_pmd_to_pagemap_entry(pagemap_entry_t *pme, struct pagemapread *pm,
-		pmd_t pmd, int offset, int pmd_flags2)
+static pagemap_entry_t thp_pmd_to_pagemap_entry(struct pagemapread *pm,
+		pmd_t pmd, int offset, u64 flags)
 {
+	u64 frame = 0;
+
 	/*
 	 * Currently pmd for thp is always present because thp can not be
 	 * swapped-out, migrated, or HWPOISONed (split in such cases instead.)
 	 * This if-check is just to prepare for future implementation.
 	 */
-	if (pmd_present(pmd))
-		*pme = make_pme(PM_PFRAME(pmd_pfn(pmd) + offset)
-				| PM_STATUS2(pm->v2, pmd_flags2) | PM_PRESENT);
-	else
-		*pme = make_pme(PM_NOT_PRESENT(pm->v2) | PM_STATUS2(pm->v2, pmd_flags2));
+	if (pmd_present(pmd)) {
+		frame = pmd_pfn(pmd) + offset;
+		flags |= PM_PRESENT;
+	}
+
+	return make_pme(frame, flags);
 }
 #else
-static inline void thp_pmd_to_pagemap_entry(pagemap_entry_t *pme, struct pagemapread *pm,
-		pmd_t pmd, int offset, int pmd_flags2)
+static pagemap_entry_t thp_pmd_to_pagemap_entry(struct pagemapread *pm,
+		pmd_t pmd, int offset, u64 flags)
 {
+	return make_pme(0, 0);
 }
 #endif
 
@@ -1115,12 +1077,10 @@ static int pagemap_pte_range(pmd_t *pmd,
 	int err = 0;
 
 	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
-		int pmd_flags2;
+		u64 flags = 0;
 
 		if ((vma->vm_flags & VM_SOFTDIRTY) || pmd_soft_dirty(*pmd))
-			pmd_flags2 = __PM_SOFT_DIRTY;
-		else
-			pmd_flags2 = 0;
+			flags |= PM_SOFT_DIRTY;
 
 		for (; addr != end; addr += PAGE_SIZE) {
 			unsigned long offset;
@@ -1128,7 +1088,7 @@ static int pagemap_pte_range(pmd_t *pmd,
 
 			offset = (addr & ~PAGEMAP_WALK_MASK) >>
 					PAGE_SHIFT;
-			thp_pmd_to_pagemap_entry(&pme, pm, *pmd, offset, pmd_flags2);
+			pme = thp_pmd_to_pagemap_entry(pm, *pmd, offset, flags);
 			err = add_to_pagemap(addr, &pme, pm);
 			if (err)
 				break;
@@ -1148,7 +1108,7 @@ static int pagemap_pte_range(pmd_t *pmd,
 	for (; addr < end; pte++, addr += PAGE_SIZE) {
 		pagemap_entry_t pme;
 
-		pte_to_pagemap_entry(&pme, pm, vma, addr, *pte);
+		pme = pte_to_pagemap_entry(pm, vma, addr, *pte);
 		err = add_to_pagemap(addr, &pme, pm);
 		if (err)
 			break;
@@ -1161,16 +1121,17 @@ static int pagemap_pte_range(pmd_t *pmd,
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-static void huge_pte_to_pagemap_entry(pagemap_entry_t *pme, struct pagemapread *pm,
-					pte_t pte, int offset, int flags2)
+static pagemap_entry_t huge_pte_to_pagemap_entry(struct pagemapread *pm,
+					pte_t pte, int offset, u64 flags)
 {
-	if (pte_present(pte))
-		*pme = make_pme(PM_PFRAME(pte_pfn(pte) + offset)	|
-				PM_STATUS2(pm->v2, flags2)		|
-				PM_PRESENT);
-	else
-		*pme = make_pme(PM_NOT_PRESENT(pm->v2)			|
-				PM_STATUS2(pm->v2, flags2));
+	u64 frame = 0;
+
+	if (pte_present(pte)) {
+		frame = pte_pfn(pte) + offset;
+		flags |= PM_PRESENT;
+	}
+
+	return make_pme(frame, flags);
 }
 
 /* This function walks within one hugetlb entry in the single call */
@@ -1181,17 +1142,15 @@ static int pagemap_hugetlb_range(pte_t *
 	struct pagemapread *pm = walk->private;
 	struct vm_area_struct *vma = walk->vma;
 	int err = 0;
-	int flags2;
+	u64 flags = 0;
 	pagemap_entry_t pme;
 
 	if (vma->vm_flags & VM_SOFTDIRTY)
-		flags2 = __PM_SOFT_DIRTY;
-	else
-		flags2 = 0;
+		flags |= PM_SOFT_DIRTY;
 
 	for (; addr != end; addr += PAGE_SIZE) {
 		int offset = (addr & ~hmask) >> PAGE_SHIFT;
-		huge_pte_to_pagemap_entry(&pme, pm, *pte, offset, flags2);
+		pme = huge_pte_to_pagemap_entry(pm, *pte, offset, flags);
 		err = add_to_pagemap(addr, &pme, pm);
 		if (err)
 			return err;
@@ -1212,7 +1171,8 @@ static int pagemap_hugetlb_range(pte_t *
  * Bits 0-54  page frame number (PFN) if present
  * Bits 0-4   swap type if swapped
  * Bits 5-54  swap offset if swapped
- * Bits 55-60 page shift (page size = 1<<page shift)
+ * Bit  55    pte is soft-dirty (see Documentation/vm/soft-dirty.txt)
+ * Bits 56-60 zero
  * Bit  61    page is file-page or shared-anon
  * Bit  62    page swapped
  * Bit  63    page present
@@ -1251,7 +1211,6 @@ static ssize_t pagemap_read(struct file
 	if (!count)
 		goto out_mm;
 
-	pm.v2 = soft_dirty_cleared;
 	pm.len = (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
 	pm.buffer = kmalloc(pm.len * PM_ENTRY_BYTES, GFP_TEMPORARY);
 	ret = -ENOMEM;
@@ -1324,9 +1283,6 @@ static int pagemap_open(struct inode *in
 	/* do not disclose physical addresses: attack vector */
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	pr_warn_once("Bits 55-60 of /proc/PID/pagemap entries are about "
-			"to stop being page-shift some time soon. See the "
-			"linux/Documentation/vm/pagemap.txt for details.\n");
 
 	mm = proc_mem_open(inode, PTRACE_MODE_READ);
 	if (IS_ERR(mm))
diff -puN tools/vm/page-types.c~pagemap-switch-to-the-new-format-and-do-some-cleanup tools/vm/page-types.c
--- a/tools/vm/page-types.c~pagemap-switch-to-the-new-format-and-do-some-cleanup
+++ a/tools/vm/page-types.c
@@ -57,23 +57,14 @@
  * pagemap kernel ABI bits
  */
 
-#define PM_ENTRY_BYTES      sizeof(uint64_t)
-#define PM_STATUS_BITS      3
-#define PM_STATUS_OFFSET    (64 - PM_STATUS_BITS)
-#define PM_STATUS_MASK      (((1LL << PM_STATUS_BITS) - 1) << PM_STATUS_OFFSET)
-#define PM_STATUS(nr)       (((nr) << PM_STATUS_OFFSET) & PM_STATUS_MASK)
-#define PM_PSHIFT_BITS      6
-#define PM_PSHIFT_OFFSET    (PM_STATUS_OFFSET - PM_PSHIFT_BITS)
-#define PM_PSHIFT_MASK      (((1LL << PM_PSHIFT_BITS) - 1) << PM_PSHIFT_OFFSET)
-#define __PM_PSHIFT(x)      (((uint64_t) (x) << PM_PSHIFT_OFFSET) & PM_PSHIFT_MASK)
-#define PM_PFRAME_MASK      ((1LL << PM_PSHIFT_OFFSET) - 1)
-#define PM_PFRAME(x)        ((x) & PM_PFRAME_MASK)
-
-#define __PM_SOFT_DIRTY      (1LL)
-#define PM_PRESENT          PM_STATUS(4LL)
-#define PM_SWAP             PM_STATUS(2LL)
-#define PM_SOFT_DIRTY       __PM_PSHIFT(__PM_SOFT_DIRTY)

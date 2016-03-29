From: akpm@linux-foundation.org
Subject: +
 procfs-add-support-for-puds-to-smaps-clear_refs-and-pagemap.patch added to
 -mm tree
Date: Tue, 29 Mar 2016 14:08:14 -0700
Message-ID: <56faeebe.zM5Y32B4324DdWee%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbcC2VIQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Mar 2016 17:08:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, dan.j.williams@intel.com, david@fromorbit.com, hpa@zytor.com, jack@suse.cz, kirill@shutemov.name, mingo@elte.hu, rientjes@google.com, ross.zwisler@linux.intel.com, tglx@linutronix.de, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: add support for PUDs to smaps, clear_refs and pagemap
has been added to the -mm tree.  Its filename is
     procfs-add-support-for-puds-to-smaps-clear_refs-and-pagemap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/procfs-add-support-for-puds-to-smaps-clear_refs-and-pagemap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/procfs-add-support-for-puds-to-smaps-clear_refs-and-pagemap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: procfs: add support for PUDs to smaps, clear_refs and pagemap

Because there's no 'struct page' for DAX THPs, a lot of this code is
simpler than the PMD code it mimics.  Extra code would need to be added to
support PUDs of anonymous or page-cache THPs.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |  109 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff -puN fs/proc/task_mmu.c~procfs-add-support-for-puds-to-smaps-clear_refs-and-pagemap fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~procfs-add-support-for-puds-to-smaps-clear_refs-and-pagemap
+++ a/fs/proc/task_mmu.c
@@ -586,6 +586,33 @@ static void smaps_pmd_entry(pmd_t *pmd,
 }
 #endif
 
+static int smaps_pud_range(pud_t *pud, unsigned long addr, unsigned long end,
+		struct mm_walk *walk)
+{
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+	struct vm_area_struct *vma = walk->vma;
+	struct mem_size_stats *mss = walk->private;
+
+	if (is_huge_zero_pud(*pud))
+		return 0;
+
+	mss->resident += HPAGE_PUD_SIZE;
+	if (vma->vm_flags & VM_SHARED) {
+		if (pud_dirty(*pud))
+			mss->shared_dirty += HPAGE_PUD_SIZE;
+		else
+			mss->shared_clean += HPAGE_PUD_SIZE;
+	} else {
+		if (pud_dirty(*pud))
+			mss->private_dirty += HPAGE_PUD_SIZE;
+		else
+			mss->private_clean += HPAGE_PUD_SIZE;
+	}
+#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+
+	return 0;
+}
+
 static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			   struct mm_walk *walk)
 {
@@ -720,6 +747,7 @@ static int show_smap(struct seq_file *m,
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss;
 	struct mm_walk smaps_walk = {
+		.pud_entry = smaps_pud_range,
 		.pmd_entry = smaps_pte_range,
 #ifdef CONFIG_HUGETLB_PAGE
 		.hugetlb_entry = smaps_hugetlb_range,
@@ -903,13 +931,50 @@ static inline void clear_soft_dirty_pmd(
 
 	set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 }
+static inline void clear_soft_dirty_pud(struct vm_area_struct *vma,
+		unsigned long addr, pud_t *pudp)
+{
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+	pud_t pud = pudp_huge_get_and_clear(vma->vm_mm, addr, pudp);
+
+	pud = pud_wrprotect(pud);
+	pud = pud_clear_soft_dirty(pud);
+
+	if (vma->vm_flags & VM_SOFTDIRTY)
+		vma->vm_flags &= ~VM_SOFTDIRTY;
+
+	set_pud_at(vma->vm_mm, addr, pudp, pud);
+#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+}
 #else
 static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp)
 {
 }
+static inline void clear_soft_dirty_pud(struct vm_area_struct *vma,
+		unsigned long addr, pud_t *pudp)
+{
+}
 #endif
 
+static int clear_refs_pud_range(pud_t *pud, unsigned long addr,
+				unsigned long end, struct mm_walk *walk)
+{
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+	struct clear_refs_private *cp = walk->private;
+	struct vm_area_struct *vma = walk->vma;
+
+	if (cp->type == CLEAR_REFS_SOFT_DIRTY) {
+		clear_soft_dirty_pud(vma, addr, pud);
+	} else {
+		/* Clear accessed and referenced bits. */
+		pudp_test_and_clear_young(vma, addr, pud);
+	}
+#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+
+	return 0;
+}
+
 static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 				unsigned long end, struct mm_walk *walk)
 {
@@ -1020,6 +1085,7 @@ static ssize_t clear_refs_write(struct f
 			.type = type,
 		};
 		struct mm_walk clear_refs_walk = {
+			.pud_entry = clear_refs_pud_range,
 			.pmd_entry = clear_refs_pte_range,
 			.test_walk = clear_refs_test_walk,
 			.mm = mm,
@@ -1184,6 +1250,48 @@ static pagemap_entry_t pte_to_pagemap_en
 	return make_pme(frame, flags);
 }
 
+static int pagemap_pud_range(pud_t *pudp, unsigned long addr, unsigned long end,
+			     struct mm_walk *walk)
+{
+	int err = 0;
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+	struct vm_area_struct *vma = walk->vma;
+	struct pagemapread *pm = walk->private;
+	u64 flags = 0, frame = 0;
+	pud_t pud = *pudp;
+
+	if ((vma->vm_flags & VM_SOFTDIRTY) || pud_soft_dirty(pud))
+		flags |= PM_SOFT_DIRTY;
+
+	/*
+	 * Currently pud for thp is always present because thp
+	 * can not be swapped-out, migrated, or HWPOISONed
+	 * (split in such cases instead.)
+	 * This if-check is just to prepare for future implementation.
+	 */
+	if (pud_present(pud)) {
+		flags |= PM_PRESENT;
+		if (!(vma->vm_flags & VM_SHARED))
+			flags |= PM_MMAP_EXCLUSIVE;
+
+		if (pm->show_pfn)
+			frame = pud_pfn(pud) +
+					((addr & ~PUD_MASK) >> PAGE_SHIFT);
+
+		for (; addr != end; addr += PAGE_SIZE) {
+			pagemap_entry_t pme = make_pme(frame, flags);
+
+			err = add_to_pagemap(addr, &pme, pm);
+			if (err)
+				break;
+			if (pm->show_pfn && (flags & PM_PRESENT))
+				frame++;
+		}
+	}
+#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+	return err;
+}
+
 static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 			     struct mm_walk *walk)
 {
@@ -1363,6 +1471,7 @@ static ssize_t pagemap_read(struct file
 	if (!pm.buffer)
 		goto out_mm;
 
+	pagemap_walk.pud_entry = pagemap_pud_range;
 	pagemap_walk.pmd_entry = pagemap_pmd_range;
 	pagemap_walk.pte_hole = pagemap_pte_hole;
 #ifdef CONFIG_HUGETLB_PAGE
_

Patches currently in -mm which might be from willy@linux.intel.com are

mmdebug-always-evaluate-the-arguments-to-vm_bug_on_.patch
mm-convert-an-open-coded-vm_bug_on_vma.patch
mmfsdax-change-pmd_fault-to-huge_fault.patch
mm-add-support-for-pud-sized-transparent-hugepages.patch
mincore-add-support-for-puds.patch
procfs-add-support-for-puds-to-smaps-clear_refs-and-pagemap.patch
x86-unify-native__get_and_clear-smp-case.patch
x86-fix-whitespace-issues.patch
x86-add-support-for-pud-sized-transparent-hugepages.patch
dax-support-for-transparent-pud-pages.patch
ext4-support-for-pud-sized-transparent-huge-pages.patch
dax-use-vmf-gfp_mask.patch
dax-remove-unnecessary-rechecking-of-i_size.patch
dax-use-vmf-pgoff-in-fault-handlers.patch


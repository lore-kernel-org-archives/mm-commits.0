Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D149C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 277492246B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgLODIW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:08:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:36030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbgLODIO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:08:14 -0500
Date:   Mon, 14 Dec 2020 19:07:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001653;
        bh=B7HLfDm9bU51qO2VSMEKssjmSAn3qbVB21QYRzYVNDs=;
        h=From:To:Subject:In-Reply-To:From;
        b=US9CgVqMvz6tbqNUoCaQQbFIkMU6RhHkpGSOE5PZUegToljcjNQ4e5D6pM2bWo1g1
         yrLD3W6VraK+EkZVw9XkeI3LJv8ejUpKkDo1hmgY6L+HDRtfUgooMiNJJ0coTV+Qiz
         KAnECwm2ocS5iPtkDs98bajtzJXLHbeirKZSG8CU=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, almasrymina@google.com,
        aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        arnd@arndb.de, bgeffon@google.com, bp@alien8.de,
        catalin.marinas@arm.com, christian.brauner@ubuntu.com,
        dave.hansen@intel.com, frederic@kernel.org, gshan@redhat.com,
        hnaveed@wavecomp.com, hpa@zytor.com, jhubbard@nvidia.com,
        justin.he@arm.com, kaleshsingh@google.com, keescook@chromium.org,
        kirill.shutemov@linux.intel.com, krzk@kernel.org,
        linux-mm@kvack.org, linuxram@us.ibm.com, lkp@intel.com,
        lokeshgidra@google.com, mark.rutland@arm.com, masahiroy@kernel.org,
        mhiramat@kernel.org, minchan@google.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        rcampbell@nvidia.com, rppt@kernel.org, samitolvanen@google.com,
        sandipan@linux.ibm.com, shuah@kernel.org, sjpark@amazon.de,
        steven.price@arm.com, surenb@google.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, will@kernel.org, ziy@nvidia.com
Subject:  [patch 075/200] mm: speedup mremap on 1GB or larger
 regions
Message-ID: <20201215030730.NC3CU98e4%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Kalesh Singh <kaleshsingh@google.com>
Subject: mm: speedup mremap on 1GB or larger regions

Android needs to move large memory regions for garbage collection.  The GC
requires moving physical pages of multi-gigabyte heap using mremap.=20
During this move, the application threads have to be paused for
correctness.  It is critical to keep this pause as short as possible to
avoid jitters during user interaction.

Optimize mremap for >=3D 1GB-sized regions by moving at the PUD/PGD level if
the source and destination addresses are PUD-aligned.  For
CONFIG_PGTABLE_LEVELS =3D=3D 3, moving at the PUD level in effect moves PGD
entries, since the PUD entry is =E2=80=9Cfolded back=E2=80=9D onto the PGD =
entry.  Add
HAVE_MOVE_PUD so that architectures where moving at the PUD level isn't
supported/tested can turn this off by not selecting the config.

Link: https://lkml.kernel.org/r/20201014005320.2233162-4-kaleshsingh@google=
.com
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Hassan Naveed <hnaveed@wavecomp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jia He <justin.he@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: SeongJae Park <sjpark@amazon.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig |    7 +
 mm/mremap.c  |  230 ++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 197 insertions(+), 40 deletions(-)

--- a/arch/Kconfig~mm-speedup-mremap-on-1gb-or-larger-regions
+++ a/arch/Kconfig
@@ -648,6 +648,13 @@ config HAVE_IRQ_TIME_ACCOUNTING
 	  Archs need to ensure they use a high enough resolution clock to
 	  support irq time accounting and then call enable_sched_clock_irqtime().
=20
+config HAVE_MOVE_PUD
+	bool
+	help
+	  Architectures that select this are able to move page tables at the
+	  PUD level. If there are only 3 page table levels, the move effectively
+	  happens at the PGD level.
+
 config HAVE_MOVE_PMD
 	bool
 	help
--- a/mm/mremap.c~mm-speedup-mremap-on-1gb-or-larger-regions
+++ a/mm/mremap.c
@@ -30,12 +30,11 @@
=20
 #include "internal.h"
=20
-static pmd_t *get_old_pmd(struct mm_struct *mm, unsigned long addr)
+static pud_t *get_old_pud(struct mm_struct *mm, unsigned long addr)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
-	pmd_t *pmd;
=20
 	pgd =3D pgd_offset(mm, addr);
 	if (pgd_none_or_clear_bad(pgd))
@@ -49,6 +48,18 @@ static pmd_t *get_old_pmd(struct mm_stru
 	if (pud_none_or_clear_bad(pud))
 		return NULL;
=20
+	return pud;
+}
+
+static pmd_t *get_old_pmd(struct mm_struct *mm, unsigned long addr)
+{
+	pud_t *pud;
+	pmd_t *pmd;
+
+	pud =3D get_old_pud(mm, addr);
+	if (!pud)
+		return NULL;
+
 	pmd =3D pmd_offset(pud, addr);
 	if (pmd_none(*pmd))
 		return NULL;
@@ -56,19 +67,27 @@ static pmd_t *get_old_pmd(struct mm_stru
 	return pmd;
 }
=20
-static pmd_t *alloc_new_pmd(struct mm_struct *mm, struct vm_area_struct *v=
ma,
+static pud_t *alloc_new_pud(struct mm_struct *mm, struct vm_area_struct *v=
ma,
 			    unsigned long addr)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
=20
 	pgd =3D pgd_offset(mm, addr);
 	p4d =3D p4d_alloc(mm, pgd, addr);
 	if (!p4d)
 		return NULL;
-	pud =3D pud_alloc(mm, p4d, addr);
+
+	return pud_alloc(mm, p4d, addr);
+}
+
+static pmd_t *alloc_new_pmd(struct mm_struct *mm, struct vm_area_struct *v=
ma,
+			    unsigned long addr)
+{
+	pud_t *pud;
+	pmd_t *pmd;
+
+	pud =3D alloc_new_pud(mm, vma, addr);
 	if (!pud)
 		return NULL;
=20
@@ -249,14 +268,148 @@ static bool move_normal_pmd(struct vm_ar
=20
 	return true;
 }
+#else
+static inline bool move_normal_pmd(struct vm_area_struct *vma,
+		unsigned long old_addr, unsigned long new_addr, pmd_t *old_pmd,
+		pmd_t *new_pmd)
+{
+	return false;
+}
 #endif
=20
+#ifdef CONFIG_HAVE_MOVE_PUD
+static bool move_normal_pud(struct vm_area_struct *vma, unsigned long old_=
addr,
+		  unsigned long new_addr, pud_t *old_pud, pud_t *new_pud)
+{
+	spinlock_t *old_ptl, *new_ptl;
+	struct mm_struct *mm =3D vma->vm_mm;
+	pud_t pud;
+
+	/*
+	 * The destination pud shouldn't be established, free_pgtables()
+	 * should have released it.
+	 */
+	if (WARN_ON_ONCE(!pud_none(*new_pud)))
+		return false;
+
+	/*
+	 * We don't have to worry about the ordering of src and dst
+	 * ptlocks because exclusive mmap_lock prevents deadlock.
+	 */
+	old_ptl =3D pud_lock(vma->vm_mm, old_pud);
+	new_ptl =3D pud_lockptr(mm, new_pud);
+	if (new_ptl !=3D old_ptl)
+		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
+
+	/* Clear the pud */
+	pud =3D *old_pud;
+	pud_clear(old_pud);
+
+	VM_BUG_ON(!pud_none(*new_pud));
+
+	/* Set the new pud */
+	set_pud_at(mm, new_addr, new_pud, pud);
+	flush_tlb_range(vma, old_addr, old_addr + PUD_SIZE);
+	if (new_ptl !=3D old_ptl)
+		spin_unlock(new_ptl);
+	spin_unlock(old_ptl);
+
+	return true;
+}
+#else
+static inline bool move_normal_pud(struct vm_area_struct *vma,
+		unsigned long old_addr, unsigned long new_addr, pud_t *old_pud,
+		pud_t *new_pud)
+{
+	return false;
+}
+#endif
+
+enum pgt_entry {
+	NORMAL_PMD,
+	HPAGE_PMD,
+	NORMAL_PUD,
+};
+
+/*
+ * Returns an extent of the corresponding size for the pgt_entry specified=
 if
+ * valid. Else returns a smaller extent bounded by the end of the source a=
nd
+ * destination pgt_entry.
+ */
+static unsigned long get_extent(enum pgt_entry entry, unsigned long old_ad=
dr,
+			unsigned long old_end, unsigned long new_addr)
+{
+	unsigned long next, extent, mask, size;
+
+	switch (entry) {
+	case HPAGE_PMD:
+	case NORMAL_PMD:
+		mask =3D PMD_MASK;
+		size =3D PMD_SIZE;
+		break;
+	case NORMAL_PUD:
+		mask =3D PUD_MASK;
+		size =3D PUD_SIZE;
+		break;
+	default:
+		BUILD_BUG();
+		break;
+	}
+
+	next =3D (old_addr + size) & mask;
+	/* even if next overflowed, extent below will be ok */
+	extent =3D (next > old_end) ? old_end - old_addr : next - old_addr;
+	next =3D (new_addr + size) & mask;
+	if (extent > next - new_addr)
+		extent =3D next - new_addr;
+	return extent;
+}
+
+/*
+ * Attempts to speedup the move by moving entry at the level corresponding=
 to
+ * pgt_entry. Returns true if the move was successful, else false.
+ */
+static bool move_pgt_entry(enum pgt_entry entry, struct vm_area_struct *vm=
a,
+			unsigned long old_addr, unsigned long new_addr,
+			void *old_entry, void *new_entry, bool need_rmap_locks)
+{
+	bool moved =3D false;
+
+	/* See comment in move_ptes() */
+	if (need_rmap_locks)
+		take_rmap_locks(vma);
+
+	switch (entry) {
+	case NORMAL_PMD:
+		moved =3D move_normal_pmd(vma, old_addr, new_addr, old_entry,
+					new_entry);
+		break;
+	case NORMAL_PUD:
+		moved =3D move_normal_pud(vma, old_addr, new_addr, old_entry,
+					new_entry);
+		break;
+	case HPAGE_PMD:
+		moved =3D IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+			move_huge_pmd(vma, old_addr, new_addr, old_entry,
+				      new_entry);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	if (need_rmap_locks)
+		drop_rmap_locks(vma);
+
+	return moved;
+}
+
 unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
 		unsigned long new_addr, unsigned long len,
 		bool need_rmap_locks)
 {
-	unsigned long extent, next, old_end;
+	unsigned long extent, old_end;
 	struct mmu_notifier_range range;
 	pmd_t *old_pmd, *new_pmd;
=20
@@ -269,53 +422,50 @@ unsigned long move_page_tables(struct vm
=20
 	for (; old_addr < old_end; old_addr +=3D extent, new_addr +=3D extent) {
 		cond_resched();
-		next =3D (old_addr + PMD_SIZE) & PMD_MASK;
-		/* even if next overflowed, extent below will be ok */
-		extent =3D next - old_addr;
-		if (extent > old_end - old_addr)
-			extent =3D old_end - old_addr;
-		next =3D (new_addr + PMD_SIZE) & PMD_MASK;
-		if (extent > next - new_addr)
-			extent =3D next - new_addr;
+		/*
+		 * If extent is PUD-sized try to speed up the move by moving at the
+		 * PUD level if possible.
+		 */
+		extent =3D get_extent(NORMAL_PUD, old_addr, old_end, new_addr);
+		if (IS_ENABLED(CONFIG_HAVE_MOVE_PUD) && extent =3D=3D PUD_SIZE) {
+			pud_t *old_pud, *new_pud;
+
+			old_pud =3D get_old_pud(vma->vm_mm, old_addr);
+			if (!old_pud)
+				continue;
+			new_pud =3D alloc_new_pud(vma->vm_mm, vma, new_addr);
+			if (!new_pud)
+				break;
+			if (move_pgt_entry(NORMAL_PUD, vma, old_addr, new_addr,
+					   old_pud, new_pud, need_rmap_locks))
+				continue;
+		}
+
+		extent =3D get_extent(NORMAL_PMD, old_addr, old_end, new_addr);
 		old_pmd =3D get_old_pmd(vma->vm_mm, old_addr);
 		if (!old_pmd)
 			continue;
 		new_pmd =3D alloc_new_pmd(vma->vm_mm, vma, new_addr);
 		if (!new_pmd)
 			break;
-		if (is_swap_pmd(*old_pmd) || pmd_trans_huge(*old_pmd) || pmd_devmap(*old=
_pmd)) {
-			if (extent =3D=3D HPAGE_PMD_SIZE) {
-				bool moved;
-				/* See comment in move_ptes() */
-				if (need_rmap_locks)
-					take_rmap_locks(vma);
-				moved =3D move_huge_pmd(vma, old_addr, new_addr,
-						      old_pmd, new_pmd);
-				if (need_rmap_locks)
-					drop_rmap_locks(vma);
-				if (moved)
-					continue;
-			}
+		if (is_swap_pmd(*old_pmd) || pmd_trans_huge(*old_pmd) ||
+		    pmd_devmap(*old_pmd)) {
+			if (extent =3D=3D HPAGE_PMD_SIZE &&
+			    move_pgt_entry(HPAGE_PMD, vma, old_addr, new_addr,
+					   old_pmd, new_pmd, need_rmap_locks))
+				continue;
 			split_huge_pmd(vma, old_pmd, old_addr);
 			if (pmd_trans_unstable(old_pmd))
 				continue;
-		} else if (extent =3D=3D PMD_SIZE) {
-#ifdef CONFIG_HAVE_MOVE_PMD
+		} else if (IS_ENABLED(CONFIG_HAVE_MOVE_PMD) &&
+			   extent =3D=3D PMD_SIZE) {
 			/*
 			 * If the extent is PMD-sized, try to speed the move by
 			 * moving at the PMD level if possible.
 			 */
-			bool moved;
-
-			if (need_rmap_locks)
-				take_rmap_locks(vma);
-			moved =3D move_normal_pmd(vma, old_addr, new_addr,
-						old_pmd, new_pmd);
-			if (need_rmap_locks)
-				drop_rmap_locks(vma);
-			if (moved)
+			if (move_pgt_entry(NORMAL_PMD, vma, old_addr, new_addr,
+					   old_pmd, new_pmd, need_rmap_locks))
 				continue;
-#endif
 		}
=20
 		if (pte_alloc(new_vma->vm_mm, new_pmd))
_

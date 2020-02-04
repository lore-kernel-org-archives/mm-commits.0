From: akpm@linux-foundation.org
Subject: [merged]
 x86-mm-avoid-allocating-struct-mm_struct-on-the-stack.patch removed from
 -mm tree
Date: Tue, 04 Feb 2020 10:41:57 -0800
Message-ID: <20200204184157.FZ8cG6JbK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727542AbgBDSmA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:42:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex@ghiti.fr, aou@eecs.berkeley.edu, ard.biesheuvel@linaro.org, arnd@arndb.de, benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com, dave.hansen@linux.intel.com, davem@davemloft.net, gor@linux.ibm.com, heiko.carstens@de.ibm.com, hpa@zytor.com, james.morse@arm.com, jglisse@redhat.com, jhogan@kernel.org, kan.liang@linux.intel.com, linux@armlinux.org.uk, luto@kernel.org, mark.rutland@arm.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paul.burton@mips.com, paul.walmsley@sifive.com, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org, sfr@canb.auug.org.au, steven.price@arm.com, tglx@linutronix.de, vgupta@synopsys.com, will@kernel.org, zong.li@sifive.com


The patch titled
     Subject: x86: mm: avoid allocating struct mm_struct on the stack
has been removed from the -mm tree.  Its filename was
     x86-mm-avoid-allocating-struct-mm_struct-on-the-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Steven Price <steven.price@arm.com>
Subject: x86: mm: avoid allocating struct mm_struct on the stack

struct mm_struct is quite large (~1664 bytes) and so allocating on the
stack may cause problems as the kernel stack size is small.

Since ptdump_walk_pgd_level_core() was only allocating the structure so
that it could modify the pgd argument we can instead introduce a pgd
override in struct mm_walk and pass this down the call stack to where it
is needed.

Since the correct mm_struct is now being passed down, it is now also
unnecessary to take the mmap_sem semaphore because ptdump_walk_pgd() will
now take the semaphore on the real mm.

[steven.price@arm.com: restore missed arm64 changes]
  Link: http://lkml.kernel.org/r/20200108145710.34314-1-steven.price@arm.com
Link: http://lkml.kernel.org/r/20200108145710.34314-1-steven.price@arm.com
Signed-off-by: Steven Price <steven.price@arm.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Hogan <jhogan@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Liang, Kan" <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Burton <paul.burton@mips.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zong Li <zong.li@sifive.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/dump.c           |    4 ++--
 arch/x86/mm/debug_pagetables.c |   10 ++--------
 arch/x86/mm/dump_pagetables.c  |   18 +++++++-----------
 include/linux/pagewalk.h       |    3 +++
 include/linux/ptdump.h         |    2 +-
 mm/pagewalk.c                  |    7 ++++++-
 mm/ptdump.c                    |    4 ++--
 7 files changed, 23 insertions(+), 25 deletions(-)

--- a/arch/arm64/mm/dump.c~x86-mm-avoid-allocating-struct-mm_struct-on-the-stack
+++ a/arch/arm64/mm/dump.c
@@ -323,7 +323,7 @@ void ptdump_walk(struct seq_file *s, str
 		}
 	};
 
-	ptdump_walk_pgd(&st.ptdump, info->mm);
+	ptdump_walk_pgd(&st.ptdump, info->mm, NULL);
 }
 
 static void ptdump_initialize(void)
@@ -361,7 +361,7 @@ void ptdump_check_wx(void)
 		}
 	};
 
-	ptdump_walk_pgd(&st.ptdump, &init_mm);
+	ptdump_walk_pgd(&st.ptdump, &init_mm, NULL);
 
 	if (st.wx_pages || st.uxn_pages)
 		pr_warn("Checked W+X mappings: FAILED, %lu W+X pages found, %lu non-UXN pages found\n",
--- a/arch/x86/mm/debug_pagetables.c~x86-mm-avoid-allocating-struct-mm_struct-on-the-stack
+++ a/arch/x86/mm/debug_pagetables.c
@@ -15,11 +15,8 @@ DEFINE_SHOW_ATTRIBUTE(ptdump);
 
 static int ptdump_curknl_show(struct seq_file *m, void *v)
 {
-	if (current->mm->pgd) {
-		down_read(&current->mm->mmap_sem);
+	if (current->mm->pgd)
 		ptdump_walk_pgd_level_debugfs(m, current->mm, false);
-		up_read(&current->mm->mmap_sem);
-	}
 	return 0;
 }
 
@@ -28,11 +25,8 @@ DEFINE_SHOW_ATTRIBUTE(ptdump_curknl);
 #ifdef CONFIG_PAGE_TABLE_ISOLATION
 static int ptdump_curusr_show(struct seq_file *m, void *v)
 {
-	if (current->mm->pgd) {
-		down_read(&current->mm->mmap_sem);
+	if (current->mm->pgd)
 		ptdump_walk_pgd_level_debugfs(m, current->mm, true);
-		up_read(&current->mm->mmap_sem);
-	}
 	return 0;
 }
 
--- a/arch/x86/mm/dump_pagetables.c~x86-mm-avoid-allocating-struct-mm_struct-on-the-stack
+++ a/arch/x86/mm/dump_pagetables.c
@@ -357,7 +357,8 @@ static void note_page(struct ptdump_stat
 	}
 }
 
-static void ptdump_walk_pgd_level_core(struct seq_file *m, pgd_t *pgd,
+static void ptdump_walk_pgd_level_core(struct seq_file *m,
+				       struct mm_struct *mm, pgd_t *pgd,
 				       bool checkwx, bool dmesg)
 {
 	const struct ptdump_range ptdump_ranges[] = {
@@ -386,12 +387,7 @@ static void ptdump_walk_pgd_level_core(s
 		.seq		= m
 	};
 
-	struct mm_struct fake_mm = {
-		.pgd = pgd
-	};
-	init_rwsem(&fake_mm.mmap_sem);
-
-	ptdump_walk_pgd(&st.ptdump, &fake_mm);
+	ptdump_walk_pgd(&st.ptdump, mm, pgd);
 
 	if (!checkwx)
 		return;
@@ -404,7 +400,7 @@ static void ptdump_walk_pgd_level_core(s
 
 void ptdump_walk_pgd_level(struct seq_file *m, struct mm_struct *mm)
 {
-	ptdump_walk_pgd_level_core(m, mm->pgd, false, true);
+	ptdump_walk_pgd_level_core(m, mm, mm->pgd, false, true);
 }
 
 void ptdump_walk_pgd_level_debugfs(struct seq_file *m, struct mm_struct *mm,
@@ -415,7 +411,7 @@ void ptdump_walk_pgd_level_debugfs(struc
 	if (user && boot_cpu_has(X86_FEATURE_PTI))
 		pgd = kernel_to_user_pgdp(pgd);
 #endif
-	ptdump_walk_pgd_level_core(m, pgd, false, false);
+	ptdump_walk_pgd_level_core(m, mm, pgd, false, false);
 }
 EXPORT_SYMBOL_GPL(ptdump_walk_pgd_level_debugfs);
 
@@ -430,13 +426,13 @@ void ptdump_walk_user_pgd_level_checkwx(
 
 	pr_info("x86/mm: Checking user space page tables\n");
 	pgd = kernel_to_user_pgdp(pgd);
-	ptdump_walk_pgd_level_core(NULL, pgd, true, false);
+	ptdump_walk_pgd_level_core(NULL, &init_mm, pgd, true, false);
 #endif
 }
 
 void ptdump_walk_pgd_level_checkwx(void)
 {
-	ptdump_walk_pgd_level_core(NULL, INIT_PGD, true, false);
+	ptdump_walk_pgd_level_core(NULL, &init_mm, INIT_PGD, true, false);
 }
 
 static int __init pt_dump_init(void)
--- a/include/linux/pagewalk.h~x86-mm-avoid-allocating-struct-mm_struct-on-the-stack
+++ a/include/linux/pagewalk.h
@@ -74,6 +74,7 @@ enum page_walk_action {
  * mm_walk - walk_page_range data
  * @ops:	operation to call during the walk
  * @mm:		mm_struct representing the target process of page table walk
+ * @pgd:	pointer to PGD; only valid with no_vma (otherwise set to NULL)
  * @vma:	vma currently walked (NULL if walking outside vmas)
  * @action:	next action to perform (see enum page_walk_action)
  * @no_vma:	walk ignoring vmas (vma will always be NULL)
@@ -84,6 +85,7 @@ enum page_walk_action {
 struct mm_walk {
 	const struct mm_walk_ops *ops;
 	struct mm_struct *mm;
+	pgd_t *pgd;
 	struct vm_area_struct *vma;
 	enum page_walk_action action;
 	bool no_vma;
@@ -95,6 +97,7 @@ int walk_page_range(struct mm_struct *mm
 		void *private);
 int walk_page_range_novma(struct mm_struct *mm, unsigned long start,
 			  unsigned long end, const struct mm_walk_ops *ops,
+			  pgd_t *pgd,
 			  void *private);
 int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
 		void *private);
--- a/include/linux/ptdump.h~x86-mm-avoid-allocating-struct-mm_struct-on-the-stack
+++ a/include/linux/ptdump.h
@@ -17,6 +17,6 @@ struct ptdump_state {
 	const struct ptdump_range *range;
 };
 
-void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm);
+void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd);
 
 #endif /* _LINUX_PTDUMP_H */
--- a/mm/pagewalk.c~x86-mm-avoid-allocating-struct-mm_struct-on-the-stack
+++ a/mm/pagewalk.c
@@ -206,7 +206,10 @@ static int walk_pgd_range(unsigned long
 	const struct mm_walk_ops *ops = walk->ops;
 	int err = 0;
 
-	pgd = pgd_offset(walk->mm, addr);
+	if (walk->pgd)
+		pgd = walk->pgd + pgd_index(addr);
+	else
+		pgd = pgd_offset(walk->mm, addr);
 	do {
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd)) {
@@ -436,11 +439,13 @@ int walk_page_range(struct mm_struct *mm
  */
 int walk_page_range_novma(struct mm_struct *mm, unsigned long start,
 			  unsigned long end, const struct mm_walk_ops *ops,
+			  pgd_t *pgd,
 			  void *private)
 {
 	struct mm_walk walk = {
 		.ops		= ops,
 		.mm		= mm,
+		.pgd		= pgd,
 		.private	= private,
 		.no_vma		= true
 	};
--- a/mm/ptdump.c~x86-mm-avoid-allocating-struct-mm_struct-on-the-stack
+++ a/mm/ptdump.c
@@ -122,14 +122,14 @@ static const struct mm_walk_ops ptdump_o
 	.pte_hole	= ptdump_hole,
 };
 
-void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm)
+void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd)
 {
 	const struct ptdump_range *range = st->range;
 
 	down_read(&mm->mmap_sem);
 	while (range->start != range->end) {
 		walk_page_range_novma(mm, range->start, range->end,
-				      &ptdump_ops, st);
+				      &ptdump_ops, pgd, st);
 		range++;
 	}
 	up_read(&mm->mmap_sem);
_

Patches currently in -mm which might be from steven.price@arm.com are

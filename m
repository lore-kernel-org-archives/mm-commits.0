From: akpm@linux-foundation.org
Subject: +
 x86-mm-ptdump-calculate-effective-permissions-correctly.patch added to -mm
 tree
Date: Thu, 21 May 2020 12:06:43 -0700
Message-ID: <20200521190643.gzUQBbLsz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729548AbgEUTGp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 May 2020 15:06:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@alien8.de, dave.hansen@linux.intel.com, jbeulich@suse.com, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org, stable@vger.kernel.org, steven.price@arm.com, tglx@linutronix.de


The patch titled
     Subject: x86: mm: ptdump: calculate effective permissions correctly
has been added to the -mm tree.  Its filename is
     x86-mm-ptdump-calculate-effective-permissions-correctly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-ptdump-calculate-effective-permissions-correctly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-ptdump-calculate-effective-permissions-correctly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Steven Price <steven.price@arm.com>
Subject: x86: mm: ptdump: calculate effective permissions correctly

Patch series "Fix W+X debug feature on x86"

Jan alerted me[1] that the W+X detection debug feature was broken in x86
by my change[2] to switch x86 to use the generic ptdump infrastructure.

Fundamentally the approach of trying to move the calculation of effective
permissions into note_page() was broken because note_page() is only called
for 'leaf' entries and the effective permissions are passed down via the
internal nodes of the page tree.  The solution I've taken here is to
create a new (optional) callback which is called for all nodes of the page
tree and therefore can calculate the effective permissions.

Secondly on some configurations (32 bit with PAE) "unsigned long" is not
large enough to store the table entries.  The fix here is simple - let's
just use a u64.

[1] https://lore.kernel.org/lkml/d573dc7e-e742-84de-473d-f971142fa319@suse.com/
[2] 2ae27137b2db ("x86: mm: convert dump_pagetables to use walk_page_range")


This patch (of 2):

By switching the x86 page table dump code to use the generic code the
effective permissions are no longer calculated correctly because the
note_page() function is only called for *leaf* entries.  To calculate the
actual effective permissions it is necessary to observe the full hierarchy
of the page tree.

Introduce a new callback for ptdump which is called for every entry and
can therefore update the prot_levels array correctly.  note_page() can
then simply access the appropriate element in the array.

Link: http://lkml.kernel.org/r/20200521152308.33096-1-steven.price@arm.com
Link: http://lkml.kernel.org/r/20200521152308.33096-2-steven.price@arm.com
Fixes: 2ae27137b2db ("x86: mm: convert dump_pagetables to use walk_page_range")
Signed-off-by: Steven Price <steven.price@arm.com>
Reported-by: Jan Beulich <jbeulich@suse.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/dump_pagetables.c |   31 +++++++++++++++++++------------
 include/linux/ptdump.h        |    1 +
 mm/ptdump.c                   |   17 ++++++++++++++++-
 3 files changed, 36 insertions(+), 13 deletions(-)

--- a/arch/x86/mm/dump_pagetables.c~x86-mm-ptdump-calculate-effective-permissions-correctly
+++ a/arch/x86/mm/dump_pagetables.c
@@ -249,10 +249,22 @@ static void note_wx(struct pg_state *st,
 		  (void *)st->start_address);
 }
 
-static inline pgprotval_t effective_prot(pgprotval_t prot1, pgprotval_t prot2)
+static void effective_prot(struct ptdump_state *pt_st, int level, u64 val)
 {
-	return (prot1 & prot2 & (_PAGE_USER | _PAGE_RW)) |
-	       ((prot1 | prot2) & _PAGE_NX);
+	struct pg_state *st = container_of(pt_st, struct pg_state, ptdump);
+	pgprotval_t prot = val & PTE_FLAGS_MASK;
+	pgprotval_t effective;
+
+	if (level > 0) {
+		pgprotval_t higher_prot = st->prot_levels[level - 1];
+
+		effective = (higher_prot & prot & (_PAGE_USER | _PAGE_RW)) |
+			    ((higher_prot | prot) & _PAGE_NX);
+	} else {
+		effective = prot;
+	}
+
+	st->prot_levels[level] = effective;
 }
 
 /*
@@ -270,16 +282,10 @@ static void note_page(struct ptdump_stat
 	struct seq_file *m = st->seq;
 
 	new_prot = val & PTE_FLAGS_MASK;
+	new_eff = st->prot_levels[level];
 
-	if (level > 0) {
-		new_eff = effective_prot(st->prot_levels[level - 1],
-					 new_prot);
-	} else {
-		new_eff = new_prot;
-	}
-
-	if (level >= 0)
-		st->prot_levels[level] = new_eff;
+	if (!val)
+		new_eff = 0;
 
 	/*
 	 * If we have a "break" in the series, we need to flush the state that
@@ -374,6 +380,7 @@ static void ptdump_walk_pgd_level_core(s
 	struct pg_state st = {
 		.ptdump = {
 			.note_page	= note_page,
+			.effective_prot = effective_prot,
 			.range		= ptdump_ranges
 		},
 		.level = -1,
--- a/include/linux/ptdump.h~x86-mm-ptdump-calculate-effective-permissions-correctly
+++ a/include/linux/ptdump.h
@@ -14,6 +14,7 @@ struct ptdump_state {
 	/* level is 0:PGD to 4:PTE, or -1 if unknown */
 	void (*note_page)(struct ptdump_state *st, unsigned long addr,
 			  int level, unsigned long val);
+	void (*effective_prot)(struct ptdump_state *st, int level, u64 val);
 	const struct ptdump_range *range;
 };
 
--- a/mm/ptdump.c~x86-mm-ptdump-calculate-effective-permissions-correctly
+++ a/mm/ptdump.c
@@ -36,6 +36,9 @@ static int ptdump_pgd_entry(pgd_t *pgd,
 		return note_kasan_page_table(walk, addr);
 #endif
 
+	if (st->effective_prot)
+		st->effective_prot(st, 0, pgd_val(val));
+
 	if (pgd_leaf(val))
 		st->note_page(st, addr, 0, pgd_val(val));
 
@@ -53,6 +56,9 @@ static int ptdump_p4d_entry(p4d_t *p4d,
 		return note_kasan_page_table(walk, addr);
 #endif
 
+	if (st->effective_prot)
+		st->effective_prot(st, 1, p4d_val(val));
+
 	if (p4d_leaf(val))
 		st->note_page(st, addr, 1, p4d_val(val));
 
@@ -70,6 +76,9 @@ static int ptdump_pud_entry(pud_t *pud,
 		return note_kasan_page_table(walk, addr);
 #endif
 
+	if (st->effective_prot)
+		st->effective_prot(st, 2, pud_val(val));
+
 	if (pud_leaf(val))
 		st->note_page(st, addr, 2, pud_val(val));
 
@@ -87,6 +96,8 @@ static int ptdump_pmd_entry(pmd_t *pmd,
 		return note_kasan_page_table(walk, addr);
 #endif
 
+	if (st->effective_prot)
+		st->effective_prot(st, 3, pmd_val(val));
 	if (pmd_leaf(val))
 		st->note_page(st, addr, 3, pmd_val(val));
 
@@ -97,8 +108,12 @@ static int ptdump_pte_entry(pte_t *pte,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
+	pte_t val = READ_ONCE(*pte);
+
+	if (st->effective_prot)
+		st->effective_prot(st, 4, pte_val(val));
 
-	st->note_page(st, addr, 4, pte_val(READ_ONCE(*pte)));
+	st->note_page(st, addr, 4, pte_val(val));
 
 	return 0;
 }
_

Patches currently in -mm which might be from steven.price@arm.com are

x86-mm-ptdump-calculate-effective-permissions-correctly.patch
mm-ptdump-expand-type-of-val-in-note_page.patch

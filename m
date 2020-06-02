From: akpm@linux-foundation.org
Subject: [merged] mm-ptdump-expand-type-of-val-in-note_page.patch
 removed from -mm tree
Date: Tue, 02 Jun 2020 14:41:08 -0700
Message-ID: <20200602214108.Y2xZZckZT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728080AbgFBVlJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:41:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@alien8.de, dave.hansen@linux.intel.com, jbeulich@suse.com, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org, stable@vger.kernel.org, steven.price@arm.com, tglx@linutronix.de


The patch titled
     Subject: mm: ptdump: expand type of 'val' in note_page()
has been removed from the -mm tree.  Its filename was
     mm-ptdump-expand-type-of-val-in-note_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Steven Price <steven.price@arm.com>
Subject: mm: ptdump: expand type of 'val' in note_page()

The page table entry is passed in the 'val' argument to note_page(),
however this was previously an "unsigned long" which is fine on 64-bit
platforms.  But for 32 bit x86 it is not always big enough to contain a
page table entry which may be 64 bits.

Change the type to u64 to ensure that it is always big enough.

[akpm@linux-foundation.org: fix riscv]
Link: http://lkml.kernel.org/r/20200521152308.33096-3-steven.price@arm.com
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

 arch/arm64/mm/dump.c          |    2 +-
 arch/riscv/mm/ptdump.c        |    2 +-
 arch/x86/mm/dump_pagetables.c |    2 +-
 include/linux/ptdump.h        |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/mm/dump.c~mm-ptdump-expand-type-of-val-in-note_page
+++ a/arch/arm64/mm/dump.c
@@ -252,7 +252,7 @@ static void note_prot_wx(struct pg_state
 }
 
 static void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
-		      unsigned long val)
+		      u64 val)
 {
 	struct pg_state *st = container_of(pt_st, struct pg_state, ptdump);
 	static const char units[] = "KMGTPE";
--- a/arch/riscv/mm/ptdump.c~mm-ptdump-expand-type-of-val-in-note_page
+++ a/arch/riscv/mm/ptdump.c
@@ -204,7 +204,7 @@ static void note_prot_wx(struct pg_state
 }
 
 static void note_page(struct ptdump_state *pt_st, unsigned long addr,
-		      int level, unsigned long val)
+		      int level, u64 val)
 {
 	struct pg_state *st = container_of(pt_st, struct pg_state, ptdump);
 	u64 pa = PFN_PHYS(pte_pfn(__pte(val)));
--- a/arch/x86/mm/dump_pagetables.c~mm-ptdump-expand-type-of-val-in-note_page
+++ a/arch/x86/mm/dump_pagetables.c
@@ -273,7 +273,7 @@ static void effective_prot(struct ptdump
  * print what we collected so far.
  */
 static void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
-		      unsigned long val)
+		      u64 val)
 {
 	struct pg_state *st = container_of(pt_st, struct pg_state, ptdump);
 	pgprotval_t new_prot, new_eff;
--- a/include/linux/ptdump.h~mm-ptdump-expand-type-of-val-in-note_page
+++ a/include/linux/ptdump.h
@@ -13,7 +13,7 @@ struct ptdump_range {
 struct ptdump_state {
 	/* level is 0:PGD to 4:PTE, or -1 if unknown */
 	void (*note_page)(struct ptdump_state *st, unsigned long addr,
-			  int level, unsigned long val);
+			  int level, u64 val);
 	void (*effective_prot)(struct ptdump_state *st, int level, u64 val);
 	const struct ptdump_range *range;
 };
_

Patches currently in -mm which might be from steven.price@arm.com are

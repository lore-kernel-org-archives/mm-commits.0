Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095E91553A3
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011066; cv=none; b=GOAjpsb3nTJuCc6hFWw6pCEiZ3e+33Ft5dd1MIJrKjkS6WReIBtm6iSaXGv9JcBox2oJXG31pwqHdX+5rleu3PYwa4g7nnQeOuyIfhYcFEW2LLzJ7UGSqdUIm0piCsv/o2i6FLMGZMKLL7TvE2XGOxS6pJKhMlTM0HgyJzSi+XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011066; c=relaxed/simple;
	bh=X3PfRnr72X04YMcwdZc+SFi+wqvz4O+zLoacOmO9ePg=;
	h=Date:To:From:Subject:Message-Id; b=RwHIQy456o6hbgUx4cpaKfxRFPXqz9SuWkZhfA2IG8E+AKT6BH3nuMDYPfIh/J6ihurZV1/nJUejGTEBRciFxwCs++k7Um4dZep6XNxgGnN3NjMlm8ymQGpBp2OIrKdBtjWzytmONz/vAmKpEtTvNjniqh6qznrqIYoO7hxU97E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cmLdAHTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cmLdAHTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E5FC4CEE4;
	Mon, 12 May 2025 00:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011065;
	bh=X3PfRnr72X04YMcwdZc+SFi+wqvz4O+zLoacOmO9ePg=;
	h=Date:To:From:Subject:From;
	b=cmLdAHTcc0Xna/tU6AKLTlL/2Ry7/u/UaQHDVnMlwcXMCJobszpO/0YG0Gd7tspoK
	 wxuZXv5ruGvxUX81to/+45L6d322Z00cnfnxB0nyvDjTiczSvLvIVKudbOZuLJqIx3
	 LyOor4S5MZPzC0/SqssgcG5lEpTODB2z2NpiVzRc=
Date: Sun, 11 May 2025 17:51:05 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,ryan.roberts@arm.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mingo@redhat.com,mark.rutland@arm.com,maddy@linux.ibm.com,hca@linux.ibm.com,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,ardb@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ptdump-split-effective_prot-into-level-specific-callbacks.patch removed from -mm tree
Message-Id: <20250512005105.D2E5FC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ptdump: split effective_prot() into level specific callbacks
has been removed from the -mm tree.  Its filename was
     mm-ptdump-split-effective_prot-into-level-specific-callbacks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/ptdump: split effective_prot() into level specific callbacks
Date: Mon, 7 Apr 2025 11:01:12 +0530

Last argument in effective_prot() is u64 assuming pxd_val() returned value
(all page table levels) is 64 bit.  pxd_val() is very platform specific
and its type should not be assumed in generic MM.

Split effective_prot() into individual page table level specific callbacks
which accepts corresponding pxd_t argument instead and then the
subscribing platform (only x86) just derive pxd_val() from the entries as
required and proceed as earlier.

Link: https://lkml.kernel.org/r/20250407053113.746295-3-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/dump_pagetables.c |   32 +++++++++++++++++++++++++++++++-
 include/linux/ptdump.h        |    6 +++++-
 mm/ptdump.c                   |   20 ++++++++++----------
 3 files changed, 46 insertions(+), 12 deletions(-)

--- a/arch/x86/mm/dump_pagetables.c~mm-ptdump-split-effective_prot-into-level-specific-callbacks
+++ a/arch/x86/mm/dump_pagetables.c
@@ -266,6 +266,32 @@ static void effective_prot(struct ptdump
 	st->prot_levels[level] = effective;
 }
 
+static void effective_prot_pte(struct ptdump_state *st, pte_t pte)
+{
+	effective_prot(st, 4, pte_val(pte));
+}
+
+static void effective_prot_pmd(struct ptdump_state *st, pmd_t pmd)
+{
+	effective_prot(st, 3, pmd_val(pmd));
+}
+
+static void effective_prot_pud(struct ptdump_state *st, pud_t pud)
+{
+	effective_prot(st, 2, pud_val(pud));
+}
+
+static void effective_prot_p4d(struct ptdump_state *st, p4d_t p4d)
+{
+	effective_prot(st, 1, p4d_val(p4d));
+}
+
+static void effective_prot_pgd(struct ptdump_state *st, pgd_t pgd)
+{
+	effective_prot(st, 0, pgd_val(pgd));
+}
+
+
 /*
  * This function gets called on a break in a continuous series
  * of PTE entries; the next one is different so we need to
@@ -416,7 +442,11 @@ bool ptdump_walk_pgd_level_core(struct s
 			.note_page_p4d = note_page_p4d,
 			.note_page_pgd = note_page_pgd,
 			.note_page_flush = note_page_flush,
-			.effective_prot = effective_prot,
+			.effective_prot_pte = effective_prot_pte,
+			.effective_prot_pmd = effective_prot_pmd,
+			.effective_prot_pud = effective_prot_pud,
+			.effective_prot_p4d = effective_prot_p4d,
+			.effective_prot_pgd = effective_prot_pgd,
 			.range		= ptdump_ranges
 		},
 		.level = -1,
--- a/include/linux/ptdump.h~mm-ptdump-split-effective_prot-into-level-specific-callbacks
+++ a/include/linux/ptdump.h
@@ -17,7 +17,11 @@ struct ptdump_state {
 	void (*note_page_p4d)(struct ptdump_state *st, unsigned long addr, p4d_t p4d);
 	void (*note_page_pgd)(struct ptdump_state *st, unsigned long addr, pgd_t pgd);
 	void (*note_page_flush)(struct ptdump_state *st);
-	void (*effective_prot)(struct ptdump_state *st, int level, u64 val);
+	void (*effective_prot_pte)(struct ptdump_state *st, pte_t pte);
+	void (*effective_prot_pmd)(struct ptdump_state *st, pmd_t pmd);
+	void (*effective_prot_pud)(struct ptdump_state *st, pud_t pud);
+	void (*effective_prot_p4d)(struct ptdump_state *st, p4d_t p4d);
+	void (*effective_prot_pgd)(struct ptdump_state *st, pgd_t pgd);
 	const struct ptdump_range *range;
 };
 
--- a/mm/ptdump.c~mm-ptdump-split-effective_prot-into-level-specific-callbacks
+++ a/mm/ptdump.c
@@ -38,8 +38,8 @@ static int ptdump_pgd_entry(pgd_t *pgd,
 		return note_kasan_page_table(walk, addr);
 #endif
 
-	if (st->effective_prot)
-		st->effective_prot(st, 0, pgd_val(val));
+	if (st->effective_prot_pgd)
+		st->effective_prot_pgd(st, val);
 
 	if (pgd_leaf(val)) {
 		st->note_page_pgd(st, addr, val);
@@ -61,8 +61,8 @@ static int ptdump_p4d_entry(p4d_t *p4d,
 		return note_kasan_page_table(walk, addr);
 #endif
 
-	if (st->effective_prot)
-		st->effective_prot(st, 1, p4d_val(val));
+	if (st->effective_prot_p4d)
+		st->effective_prot_p4d(st, val);
 
 	if (p4d_leaf(val)) {
 		st->note_page_p4d(st, addr, val);
@@ -84,8 +84,8 @@ static int ptdump_pud_entry(pud_t *pud,
 		return note_kasan_page_table(walk, addr);
 #endif
 
-	if (st->effective_prot)
-		st->effective_prot(st, 2, pud_val(val));
+	if (st->effective_prot_pud)
+		st->effective_prot_pud(st, val);
 
 	if (pud_leaf(val)) {
 		st->note_page_pud(st, addr, val);
@@ -106,8 +106,8 @@ static int ptdump_pmd_entry(pmd_t *pmd,
 		return note_kasan_page_table(walk, addr);
 #endif
 
-	if (st->effective_prot)
-		st->effective_prot(st, 3, pmd_val(val));
+	if (st->effective_prot_pmd)
+		st->effective_prot_pmd(st, val);
 	if (pmd_leaf(val)) {
 		st->note_page_pmd(st, addr, val);
 		walk->action = ACTION_CONTINUE;
@@ -122,8 +122,8 @@ static int ptdump_pte_entry(pte_t *pte,
 	struct ptdump_state *st = walk->private;
 	pte_t val = ptep_get_lockless(pte);
 
-	if (st->effective_prot)
-		st->effective_prot(st, 4, pte_val(val));
+	if (st->effective_prot_pte)
+		st->effective_prot_pte(st, val);
 
 	st->note_page_pte(st, addr, val);
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are



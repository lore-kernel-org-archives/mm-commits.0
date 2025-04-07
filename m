Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B028217F31
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 19:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744054981; cv=none; b=KurqUSvA+oGbw8DI4BWyxwMJEDGKdYfmctcA+7ZJHZ/TMBHsVrqKUKgZW+Fi5VG4jFaeGJpeLMt2FRoEPxtoqSt55imAZsV7GdLt4tRGna7SOhAPZl7cG5elsfm3SJV2h++zXuK/jFSjHxUjbtxotEweBGBnSFVsA+zCMXAUkJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744054981; c=relaxed/simple;
	bh=32hJYOp993HCgLicLcvSzU30B5SFaJBN5tRHXH2L57Y=;
	h=Date:To:From:Subject:Message-Id; b=UdSaO3uqD89/pAUiT9B17iGQ0xf9F9FnZuTe/km6+ubet0VlZDRe1mx1W0l+8AuHJPVSp33o+j4vGa8rnwPBidnoXGwakTj0w3SEutXsG/wcRSFDkHVJ5+1gbzckE7P2CDJKjFi4yq0mHDVRtO2aXspMDUSurRo9UOLd8nfMx+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iQvrrTXK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iQvrrTXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E1BC4CEDD;
	Mon,  7 Apr 2025 19:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744054980;
	bh=32hJYOp993HCgLicLcvSzU30B5SFaJBN5tRHXH2L57Y=;
	h=Date:To:From:Subject:From;
	b=iQvrrTXKG7tP3wIbIEYnvMvVtlmydFCbLUxnI+rJjq9nRAmEurPwQswicaxdcN7Ay
	 O5/npTxkuhpP0ZcDlPMzxIMTfX3PMnsm8QhpEriuSJdiAt9J7F3SwTJELgfHpPX9m9
	 jBw5H1l6Cl1YTiWuBWvQlhuO9VnK0VA5M0QYcZoM=
Date: Mon, 07 Apr 2025 12:42:59 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,ryan.roberts@arm.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mingo@redhat.com,mark.rutland@arm.com,maddy@linux.ibm.com,hca@linux.ibm.com,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,ardb@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ptdump-split-effective_prot-into-level-specific-callbacks.patch added to mm-new branch
Message-Id: <20250407194300.82E1BC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ptdump: split effective_prot() into level specific callbacks
has been added to the -mm mm-new branch.  Its filename is
     mm-ptdump-split-effective_prot-into-level-specific-callbacks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ptdump-split-effective_prot-into-level-specific-callbacks.patch

This patch will later appear in the mm-new branch at
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

mm-ptdump-split-note_page-into-level-specific-callbacks.patch
mm-ptdump-split-effective_prot-into-level-specific-callbacks.patch
arm64-mm-define-ptdesc_t.patch


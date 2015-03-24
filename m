From: akpm@linux-foundation.org
Subject: + mtrr-mm-x86-enhance-mtrr-checks-for-kva-huge-page-mapping.patch added to -mm tree
Date: Tue, 24 Mar 2015 15:43:48 -0700
Message-ID: <5511e8a4.zDHU6X9kR3q/150M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbbCXWnt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 18:43:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, Elliott@hp.com, dave.hansen@intel.com, hpa@zytor.com, mingo@redhat.com, pebolle@tiscali.nl, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mtrr, mm, x86: enhance MTRR checks for KVA huge page mapping
has been added to the -mm tree.  Its filename is
     mtrr-mm-x86-enhance-mtrr-checks-for-kva-huge-page-mapping.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mtrr-mm-x86-enhance-mtrr-checks-for-kva-huge-page-mapping.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mtrr-mm-x86-enhance-mtrr-checks-for-kva-huge-page-mapping.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: mtrr, mm, x86: enhance MTRR checks for KVA huge page mapping

This patch adds an additional argument, 'uniform', to mtrr_type_lookup(),
which returns 1 when a given range is covered uniformly by MTRRs, i.e. 
the range is fully covered by a single MTRR entry or the default type.

pud_set_huge() and pmd_set_huge() are changed to check the new 'uniform'
flag to see if it is safe to create a huge page mapping to the range. 
This allows them to create a huge page mapping to a range covered by a
single MTRR entry of any memory type.  It also detects a non-optimal
request properly.  They continue to check with the WB type since the WB
type has no effect even if a request spans multiple MTRR entries.

pmd_set_huge() logs a warning message to a non-optimal request so that
driver writers will be aware of such a case.  Drivers should make a
mapping request aligned to a single MTRR entry when the range is covered
by MTRRs.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Robert Elliott <Elliott@hp.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/mtrr.h        |    5 ++-
 arch/x86/kernel/cpu/mtrr/generic.c |   35 ++++++++++++++++++++-------
 arch/x86/mm/pat.c                  |    4 +--
 arch/x86/mm/pgtable.c              |   25 +++++++++++--------
 4 files changed, 47 insertions(+), 22 deletions(-)

diff -puN arch/x86/include/asm/mtrr.h~mtrr-mm-x86-enhance-mtrr-checks-for-kva-huge-page-mapping arch/x86/include/asm/mtrr.h
--- a/arch/x86/include/asm/mtrr.h~mtrr-mm-x86-enhance-mtrr-checks-for-kva-huge-page-mapping
+++ a/arch/x86/include/asm/mtrr.h
@@ -31,7 +31,7 @@
  * arch_phys_wc_add and arch_phys_wc_del.
  */
 # ifdef CONFIG_MTRR
-extern u8 mtrr_type_lookup(u64 addr, u64 end);
+extern u8 mtrr_type_lookup(u64 addr, u64 end, u8 *uniform);
 extern void mtrr_save_fixed_ranges(void *);
 extern void mtrr_save_state(void);
 extern int mtrr_add(unsigned long base, unsigned long size,
@@ -50,11 +50,12 @@ extern int mtrr_trim_uncached_memory(uns
 extern int amd_special_default_mtrr(void);
 extern int phys_wc_to_mtrr_index(int handle);
 #  else
-static inline u8 mtrr_type_lookup(u64 addr, u64 end)
+static inline u8 mtrr_type_lookup(u64 addr, u64 end, u8 *uniform)
 {
 	/*
 	 * Return no-MTRRs:
 	 */
+	*uniform = 1;
 	return MTRR_TYPE_INVALID;
 }
 #define mtrr_save_fixed_ranges(arg) do {} while (0)
diff -puN arch/x86/kernel/cpu/mtrr/generic.c~mtrr-mm-x86-enhance-mtrr-checks-for-kva-huge-page-mapping arch/x86/kernel/cpu/mtrr/generic.c
--- a/arch/x86/kernel/cpu/mtrr/generic.c~mtrr-mm-x86-enhance-mtrr-checks-for-kva-huge-page-mapping
+++ a/arch/x86/kernel/cpu/mtrr/generic.c
@@ -148,19 +148,22 @@ static u8 mtrr_type_lookup_fixed(u64 sta
  * Return Value:
  * MTRR_TYPE_(type) - Matched memory type or default memory type (unmatched)
  *
- * Output Argument:
+ * Output Arguments:
  * repeat - Set to 1 when [start:end] spanned across MTRR range and type
  *	    returned corresponds only to [start:*partial_end].  Caller has
  *	    to lookup again for [*partial_end:end].
+ * uniform - Set to 1 when MTRR covers the region uniformly, i.e. the region
+ *	     is fully covered by a single MTRR entry or the default type.
  */
 static u8 mtrr_type_lookup_variable(u64 start, u64 end, u64 *partial_end,
-				    int *repeat)
+				    int *repeat, u8 *uniform)
 {
 	int i;
 	u64 base, mask;
 	u8 prev_match, curr_match;
 
 	*repeat = 0;
+	*uniform = 1;
 
 	/* Make end inclusive end, instead of exclusive */
 	end--;
@@ -208,6 +211,7 @@ static u8 mtrr_type_lookup_variable(u64
 
 			end = *partial_end - 1; /* end is inclusive */
 			*repeat = 1;
+			*uniform = 0;
 		}
 
 		if (!start_state)
@@ -219,6 +223,7 @@ static u8 mtrr_type_lookup_variable(u64
 			continue;
 		}
 
+		*uniform = 0;
 		if (check_type_overlap(&prev_match, &curr_match))
 			return curr_match;
 	}
@@ -235,13 +240,19 @@ static u8 mtrr_type_lookup_variable(u64
  * Return Values:
  * MTRR_TYPE_(type)  - The effective MTRR type for the region
  * MTRR_TYPE_INVALID - MTRR is disabled
+ *
+ * Output Argument:
+ * uniform - Set to 1 when MTRR covers the region uniformly, i.e. the region
+ *	     is fully covered by a single MTRR entry or the default type.
  */
-u8 mtrr_type_lookup(u64 start, u64 end)
+u8 mtrr_type_lookup(u64 start, u64 end, u8 *uniform)
 {
-	u8 type, prev_type;
+	u8 type, prev_type, is_uniform, dummy;
 	int repeat;
 	u64 partial_end;
 
+	*uniform = 1;
+
 	if (!mtrr_state_set)
 		return MTRR_TYPE_INVALID;
 
@@ -253,14 +264,17 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 	 * the variable ranges.
 	 */
 	type = mtrr_type_lookup_fixed(start, end);
-	if (type != MTRR_TYPE_INVALID)
+	if (type != MTRR_TYPE_INVALID) {
+		*uniform = 0;
 		return type;
+	}
 
 	/*
 	 * Look up the variable ranges.  Look of multiple ranges matching
 	 * this address and pick type as per MTRR precedence.
 	 */
-	type = mtrr_type_lookup_variable(start, end, &partial_end, &repeat);
+	type = mtrr_type_lookup_variable(start, end, &partial_end,
+					 &repeat, &is_uniform);
 
 	/*
 	 * Common path is with repeat = 0.
@@ -271,16 +285,21 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 	while (repeat) {
 		prev_type = type;
 		start = partial_end;
+		is_uniform = 0;
+
 		type = mtrr_type_lookup_variable(start, end, &partial_end,
-						 &repeat);
+						 &repeat, &dummy);
 
-		if (check_type_overlap(&prev_type, &type))
+		if (check_type_overlap(&prev_type, &type)) {
+			*uniform = 0;
 			return type;
+		}
 	}
 
 	if (mtrr_tom2 && (start >= (1ULL<<32)) && (end < mtrr_tom2))
 		return MTRR_TYPE_WRBACK;
 
+	*uniform = is_uniform;
 	return type;
 }
 
diff -puN arch/x86/mm/pat.c~mtrr-mm-x86-enhance-mtrr-checks-for-kva-huge-page-mapping arch/x86/mm/pat.c
--- a/arch/x86/mm/pat.c~mtrr-mm-x86-enhance-mtrr-checks-for-kva-huge-page-mapping
+++ a/arch/x86/mm/pat.c
@@ -267,9 +267,9 @@ static unsigned long pat_x_mtrr_type(u64
 	 * request is for WB.
 	 */
 	if (req_type == _PAGE_CACHE_MODE_WB) {
-		u8 mtrr_type;
+		u8 mtrr_type, uniform;
 
-		mtrr_type = mtrr_type_lookup(start, end);
+		mtrr_type = mtrr_type_lookup(start, end, &uniform);
 		if (mtrr_type != MTRR_TYPE_WRBACK)
 			return _PAGE_CACHE_MODE_UC_MINUS;
 
diff -puN arch/x86/mm/pgtable.c~mtrr-mm-x86-enhance-mtrr-checks-for-kva-huge-page-mapping arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c~mtrr-mm-x86-enhance-mtrr-checks-for-kva-huge-page-mapping
+++ a/arch/x86/mm/pgtable.c
@@ -567,17 +567,18 @@ void native_set_fixmap(enum fixed_addres
  * pud_set_huge - setup kernel PUD mapping
  *
  * MTRR can override PAT memory types with 4KB granularity.  Therefore,
- * it does not set up a huge page when the range is covered by a non-WB
- * type of MTRR.  MTRR_TYPE_INVALID indicates that MTRR are disabled.
+ * it only sets up a huge page when the range is mapped uniformly by MTRR
+ * (i.e. the range is fully covered by a single MTRR entry or the default
+ * type) or the MTRR memory type is WB.
  *
  * Return 1 on success, and 0 when no PUD was set.
  */
 int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot)
 {
-	u8 mtrr;
+	u8 mtrr, uniform;
 
-	mtrr = mtrr_type_lookup(addr, addr + PUD_SIZE);
-	if ((mtrr != MTRR_TYPE_WRBACK) && (mtrr != MTRR_TYPE_INVALID))
+	mtrr = mtrr_type_lookup(addr, addr + PUD_SIZE, &uniform);
+	if ((!uniform) && (mtrr != MTRR_TYPE_WRBACK))
 		return 0;
 
 	prot = pgprot_4k_2_large(prot);
@@ -593,18 +594,22 @@ int pud_set_huge(pud_t *pud, phys_addr_t
  * pmd_set_huge - setup kernel PMD mapping
  *
  * MTRR can override PAT memory types with 4KB granularity.  Therefore,
- * it does not set up a huge page when the range is covered by a non-WB
- * type of MTRR.  MTRR_TYPE_INVALID indicates that MTRR are disabled.
+ * it only sets up a huge page when the range is mapped uniformly by MTRR
+ * (i.e. the range is fully covered by a single MTRR entry or the default
+ * type) or the MTRR memory type is WB.
  *
  * Return 1 on success, and 0 when no PMD was set.
  */
 int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot)
 {
-	u8 mtrr;
+	u8 mtrr, uniform;
 
-	mtrr = mtrr_type_lookup(addr, addr + PMD_SIZE);
-	if ((mtrr != MTRR_TYPE_WRBACK) && (mtrr != MTRR_TYPE_INVALID))
+	mtrr = mtrr_type_lookup(addr, addr + PMD_SIZE, &uniform);
+	if ((!uniform) && (mtrr != MTRR_TYPE_WRBACK)) {
+		pr_warn("pmd_set_huge: requesting [mem %#010llx-%#010llx], which spans more than a single MTRR entry\n",
+				addr, addr + PMD_SIZE);
 		return 0;
+	}
 
 	prot = pgprot_4k_2_large(prot);
 
_

Patches currently in -mm which might be from toshi.kani@hp.com are

mm-change-__get_vm_area_node-to-use-fls_long.patch
lib-add-huge-i-o-map-capability-interfaces.patch
lib-add-huge-i-o-map-capability-interfaces-fix.patch
mm-change-ioremap-to-set-up-huge-i-o-mappings.patch
mm-change-ioremap-to-set-up-huge-i-o-mappings-fix.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
x86-mm-support-huge-i-o-mapping-capability-i-f.patch
x86-mm-support-huge-kva-mappings-on-x86.patch
x86-mm-support-huge-kva-mappings-on-x86-fix.patch
linux-next.patch
mm-x86-document-return-values-of-mapping-funcs.patch
mtrr-x86-fix-mtrr-lookup-to-handle-inclusive-entry.patch
mtrr-x86-remove-a-wrong-address-check-in-__mtrr_type_lookup.patch
mtrr-x86-fix-mtrr-state-checks-in-mtrr_type_lookup.patch
mtrr-x86-define-mtrr_type_invalid-for-mtrr_type_lookup.patch
mtrr-x86-clean-up-mtrr_type_lookup.patch
mtrr-mm-x86-enhance-mtrr-checks-for-kva-huge-page-mapping.patch


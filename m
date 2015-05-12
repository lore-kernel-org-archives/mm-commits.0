From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mtrr-x86-define-mtrr_type_invalid-for-mtrr_type_lookup.patch removed from
 -mm tree
Date: Tue, 12 May 2015 12:57:46 -0700
Message-ID: <55525b3a.VvY9S9iQEI1kFhvg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933352AbbELT5r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 May 2015 15:57:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, Elliott@hp.com, dave.hansen@intel.com, hpa@zytor.com, mingo@redhat.com, pebolle@tiscali.nl, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mtrr, x86: define MTRR_TYPE_INVALID for mtrr_type_lookup()
has been removed from the -mm tree.  Its filename was
     mtrr-x86-define-mtrr_type_invalid-for-mtrr_type_lookup.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: mtrr, x86: define MTRR_TYPE_INVALID for mtrr_type_lookup()

mtrr_type_lookup() returns 0xFF when it cannot return a valid MTRR memory
type since MTRRs are disabled.  This patch defines MTRR_TYPE_INVALID to
clarify the meaning of this value, and documents its usage.

There is no functional change in this patch.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Robert Elliott <Elliott@hp.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/mtrr.h        |    2 +-
 arch/x86/include/uapi/asm/mtrr.h   |    8 +++++++-
 arch/x86/kernel/cpu/mtrr/generic.c |   14 +++++++-------
 arch/x86/mm/pgtable.c              |    8 ++++----
 4 files changed, 19 insertions(+), 13 deletions(-)

diff -puN arch/x86/include/asm/mtrr.h~mtrr-x86-define-mtrr_type_invalid-for-mtrr_type_lookup arch/x86/include/asm/mtrr.h
--- a/arch/x86/include/asm/mtrr.h~mtrr-x86-define-mtrr_type_invalid-for-mtrr_type_lookup
+++ a/arch/x86/include/asm/mtrr.h
@@ -55,7 +55,7 @@ static inline u8 mtrr_type_lookup(u64 ad
 	/*
 	 * Return no-MTRRs:
 	 */
-	return 0xff;
+	return MTRR_TYPE_INVALID;
 }
 #define mtrr_save_fixed_ranges(arg) do {} while (0)
 #define mtrr_save_state() do {} while (0)
diff -puN arch/x86/include/uapi/asm/mtrr.h~mtrr-x86-define-mtrr_type_invalid-for-mtrr_type_lookup arch/x86/include/uapi/asm/mtrr.h
--- a/arch/x86/include/uapi/asm/mtrr.h~mtrr-x86-define-mtrr_type_invalid-for-mtrr_type_lookup
+++ a/arch/x86/include/uapi/asm/mtrr.h
@@ -107,7 +107,7 @@ struct mtrr_state_type {
 #define MTRRIOC_GET_PAGE_ENTRY   _IOWR(MTRR_IOCTL_BASE, 8, struct mtrr_gentry)
 #define MTRRIOC_KILL_PAGE_ENTRY  _IOW(MTRR_IOCTL_BASE,  9, struct mtrr_sentry)
 
-/*  These are the region types  */
+/* MTRR memory types, which are defined in SDM */
 #define MTRR_TYPE_UNCACHABLE 0
 #define MTRR_TYPE_WRCOMB     1
 /*#define MTRR_TYPE_         2*/
@@ -117,5 +117,11 @@ struct mtrr_state_type {
 #define MTRR_TYPE_WRBACK     6
 #define MTRR_NUM_TYPES       7
 
+/*
+ * Invalid MTRR memory type.  mtrr_type_lookup() returns this value when
+ * MTRRs are disabled.  Note, this value is allocated from the reserved
+ * values (0x7-0xff) of the MTRR memory types.
+ */
+#define MTRR_TYPE_INVALID    0xff
 
 #endif /* _UAPI_ASM_X86_MTRR_H */
diff -puN arch/x86/kernel/cpu/mtrr/generic.c~mtrr-x86-define-mtrr_type_invalid-for-mtrr_type_lookup arch/x86/kernel/cpu/mtrr/generic.c
--- a/arch/x86/kernel/cpu/mtrr/generic.c~mtrr-x86-define-mtrr_type_invalid-for-mtrr_type_lookup
+++ a/arch/x86/kernel/cpu/mtrr/generic.c
@@ -104,7 +104,7 @@ static int check_type_overlap(u8 *prev,
 
 /*
  * Error/Semi-error returns:
- * 0xFF - when MTRR is not enabled
+ * MTRR_TYPE_INVALID - when MTRR is not enabled
  * *repeat == 1 implies [start:end] spanned across MTRR range and type returned
  *		corresponds only to [start:*partial_end].
  *		Caller has to lookup again for [*partial_end:end].
@@ -117,10 +117,10 @@ static u8 __mtrr_type_lookup(u64 start,
 
 	*repeat = 0;
 	if (!mtrr_state_set)
-		return 0xFF;
+		return MTRR_TYPE_INVALID;
 
 	if (!(mtrr_state.enabled & MTRR_STATE_MTRR_ENABLED))
-		return 0xFF;
+		return MTRR_TYPE_INVALID;
 
 	/* Make end inclusive end, instead of exclusive */
 	end--;
@@ -151,7 +151,7 @@ static u8 __mtrr_type_lookup(u64 start,
 	 * Look of multiple ranges matching this address and pick type
 	 * as per MTRR precedence
 	 */
-	prev_match = 0xFF;
+	prev_match = MTRR_TYPE_INVALID;
 	for (i = 0; i < num_var_ranges; ++i) {
 		unsigned short start_state, end_state, inclusive;
 
@@ -199,7 +199,7 @@ static u8 __mtrr_type_lookup(u64 start,
 			continue;
 
 		curr_match = mtrr_state.var_ranges[i].base_lo & 0xff;
-		if (prev_match == 0xFF) {
+		if (prev_match == MTRR_TYPE_INVALID) {
 			prev_match = curr_match;
 			continue;
 		}
@@ -213,7 +213,7 @@ static u8 __mtrr_type_lookup(u64 start,
 			return MTRR_TYPE_WRBACK;
 	}
 
-	if (prev_match != 0xFF)
+	if (prev_match != MTRR_TYPE_INVALID)
 		return prev_match;
 
 	return mtrr_state.def_type;
@@ -222,7 +222,7 @@ static u8 __mtrr_type_lookup(u64 start,
 /*
  * Returns the effective MTRR type for the region
  * Error return:
- * 0xFF - when MTRR is not enabled
+ * MTRR_TYPE_INVALID - when MTRR is not enabled
  */
 u8 mtrr_type_lookup(u64 start, u64 end)
 {
diff -puN arch/x86/mm/pgtable.c~mtrr-x86-define-mtrr_type_invalid-for-mtrr_type_lookup arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c~mtrr-x86-define-mtrr_type_invalid-for-mtrr_type_lookup
+++ a/arch/x86/mm/pgtable.c
@@ -568,7 +568,7 @@ void native_set_fixmap(enum fixed_addres
  *
  * MTRR can override PAT memory types with 4KB granularity.  Therefore,
  * it does not set up a huge page when the range is covered by a non-WB
- * type of MTRR.  0xFF indicates that MTRR are disabled.
+ * type of MTRR.  MTRR_TYPE_INVALID indicates that MTRR are disabled.
  *
  * Return 1 on success, and 0 when no PUD was set.
  */
@@ -577,7 +577,7 @@ int pud_set_huge(pud_t *pud, phys_addr_t
 	u8 mtrr;
 
 	mtrr = mtrr_type_lookup(addr, addr + PUD_SIZE);
-	if ((mtrr != MTRR_TYPE_WRBACK) && (mtrr != 0xFF))
+	if ((mtrr != MTRR_TYPE_WRBACK) && (mtrr != MTRR_TYPE_INVALID))
 		return 0;
 
 	prot = pgprot_4k_2_large(prot);
@@ -594,7 +594,7 @@ int pud_set_huge(pud_t *pud, phys_addr_t
  *
  * MTRR can override PAT memory types with 4KB granularity.  Therefore,
  * it does not set up a huge page when the range is covered by a non-WB
- * type of MTRR.  0xFF indicates that MTRR are disabled.
+ * type of MTRR.  MTRR_TYPE_INVALID indicates that MTRR are disabled.
  *
  * Return 1 on success, and 0 when no PMD was set.
  */
@@ -603,7 +603,7 @@ int pmd_set_huge(pmd_t *pmd, phys_addr_t
 	u8 mtrr;
 
 	mtrr = mtrr_type_lookup(addr, addr + PMD_SIZE);
-	if ((mtrr != MTRR_TYPE_WRBACK) && (mtrr != 0xFF))
+	if ((mtrr != MTRR_TYPE_WRBACK) && (mtrr != MTRR_TYPE_INVALID))
 		return 0;
 
 	prot = pgprot_4k_2_large(prot);
_

Patches currently in -mm which might be from toshi.kani@hp.com are

linux-next.patch
mtrr-x86-clean-up-mtrr_type_lookup.patch
mtrr-mm-x86-enhance-mtrr-checks-for-kva-huge-page-mapping.patch


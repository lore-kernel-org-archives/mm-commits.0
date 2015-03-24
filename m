From: akpm@linux-foundation.org
Subject: + mtrr-x86-clean-up-mtrr_type_lookup.patch added to -mm tree
Date: Tue, 24 Mar 2015 15:43:46 -0700
Message-ID: <5511e8a2.LplN/Y5cd6bIveNq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbbCXWnr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 18:43:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, Elliott@hp.com, dave.hansen@intel.com, hpa@zytor.com, mingo@redhat.com, pebolle@tiscali.nl, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mtrr, x86: clean up mtrr_type_lookup()
has been added to the -mm tree.  Its filename is
     mtrr-x86-clean-up-mtrr_type_lookup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mtrr-x86-clean-up-mtrr_type_lookup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mtrr-x86-clean-up-mtrr_type_lookup.patch

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
Subject: mtrr, x86: clean up mtrr_type_lookup()

MTRRs contain fixed and variable entries.  mtrr_type_lookup() may
repeatedly call __mtrr_type_lookup() to handle a request that overlaps
with variable entries.  However, __mtrr_type_lookup() also handles the
fixed entries, which do not have to be repeated.  Therefore, this patch
creates separate functions, mtrr_type_lookup_fixed() and
mtrr_type_lookup_variable(), to handle the fixed and variable ranges
respectively.

The patch also updates the function headers to clarify the return values
and output argument.  It updates comments to clarify that the repeating is
necessary to handle overlaps with the default type, since overlaps with
multiple entries alone can be handled without such repeating.

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

 arch/x86/kernel/cpu/mtrr/generic.c |  137 ++++++++++++++++-----------
 1 file changed, 86 insertions(+), 51 deletions(-)

diff -puN arch/x86/kernel/cpu/mtrr/generic.c~mtrr-x86-clean-up-mtrr_type_lookup arch/x86/kernel/cpu/mtrr/generic.c
--- a/arch/x86/kernel/cpu/mtrr/generic.c~mtrr-x86-clean-up-mtrr_type_lookup
+++ a/arch/x86/kernel/cpu/mtrr/generic.c
@@ -102,55 +102,69 @@ static int check_type_overlap(u8 *prev,
 	return 0;
 }
 
-/*
- * Error/Semi-error returns:
- * MTRR_TYPE_INVALID - when MTRR is not enabled
- * *repeat == 1 implies [start:end] spanned across MTRR range and type returned
- *		corresponds only to [start:*partial_end].
- *		Caller has to lookup again for [*partial_end:end].
+/**
+ * mtrr_type_lookup_fixed - look up memory type in MTRR fixed entries
+ *
+ * MTRR fixed entries are divided into the following ways:
+ *  0x00000 - 0x7FFFF : This range is divided into eight 64KB sub-ranges
+ *  0x80000 - 0xBFFFF : This range is divided into sixteen 16KB sub-ranges
+ *  0xC0000 - 0xFFFFF : This range is divided into sixty-four 4KB sub-ranges
+ *
+ * Return Values:
+ * MTRR_TYPE_(type)  - Matched memory type
+ * MTRR_TYPE_INVALID - Unmatched or fixed entries are disabled
  */
-static u8 __mtrr_type_lookup(u64 start, u64 end, u64 *partial_end, int *repeat)
+static u8 mtrr_type_lookup_fixed(u64 start, u64 end)
+{
+	int idx;
+
+	if (start >= 0x100000)
+		return MTRR_TYPE_INVALID;
+
+	if (!(mtrr_state.have_fixed) ||
+	    !(mtrr_state.enabled & MTRR_STATE_MTRR_FIXED_ENABLED))
+		return MTRR_TYPE_INVALID;
+
+	if (start < 0x80000) {		/* 0x0 - 0x7FFFF */
+		idx = 0;
+		idx += (start >> 16);
+		return mtrr_state.fixed_ranges[idx];
+
+	} else if (start < 0xC0000) {	/* 0x80000 - 0xBFFFF */
+		idx = 1 * 8;
+		idx += ((start - 0x80000) >> 14);
+		return mtrr_state.fixed_ranges[idx];
+	}
+
+	/* 0xC0000 - 0xFFFFF */
+	idx = 3 * 8;
+	idx += ((start - 0xC0000) >> 12);
+	return mtrr_state.fixed_ranges[idx];
+}
+
+/**
+ * mtrr_type_lookup_variable - look up memory type in MTRR variable entries
+ *
+ * Return Value:
+ * MTRR_TYPE_(type) - Matched memory type or default memory type (unmatched)
+ *
+ * Output Argument:
+ * repeat - Set to 1 when [start:end] spanned across MTRR range and type
+ *	    returned corresponds only to [start:*partial_end].  Caller has
+ *	    to lookup again for [*partial_end:end].
+ */
+static u8 mtrr_type_lookup_variable(u64 start, u64 end, u64 *partial_end,
+				    int *repeat)
 {
 	int i;
 	u64 base, mask;
 	u8 prev_match, curr_match;
 
 	*repeat = 0;
-	if (!mtrr_state_set)
-		return MTRR_TYPE_INVALID;
-
-	if (!(mtrr_state.enabled & MTRR_STATE_MTRR_ENABLED))
-		return MTRR_TYPE_INVALID;
 
 	/* Make end inclusive end, instead of exclusive */
 	end--;
 
-	/* Look in fixed ranges. Just return the type as per start */
-	if ((start < 0x100000) &&
-	    (mtrr_state.have_fixed) &&
-	    (mtrr_state.enabled & MTRR_STATE_MTRR_FIXED_ENABLED)) {
-		int idx;
-
-		if (start < 0x80000) {
-			idx = 0;
-			idx += (start >> 16);
-			return mtrr_state.fixed_ranges[idx];
-		} else if (start < 0xC0000) {
-			idx = 1 * 8;
-			idx += ((start - 0x80000) >> 14);
-			return mtrr_state.fixed_ranges[idx];
-		} else {
-			idx = 3 * 8;
-			idx += ((start - 0xC0000) >> 12);
-			return mtrr_state.fixed_ranges[idx];
-		}
-	}
-
-	/*
-	 * Look in variable ranges
-	 * Look of multiple ranges matching this address and pick type
-	 * as per MTRR precedence
-	 */
 	prev_match = MTRR_TYPE_INVALID;
 	for (i = 0; i < num_var_ranges; ++i) {
 		unsigned short start_state, end_state, inclusive;
@@ -179,7 +193,8 @@ static u8 __mtrr_type_lookup(u64 start,
 			 * Return the type for first region and a pointer to
 			 * the start of second region so that caller will
 			 * lookup again on the second region.
-			 * Note: This way we handle multiple overlaps as well.
+			 * Note: This way we handle overlaps with multiple
+			 * entries and the default type properly.
 			 */
 			if (start_state)
 				*partial_end = base + get_mtrr_size(mask);
@@ -208,21 +223,18 @@ static u8 __mtrr_type_lookup(u64 start,
 			return curr_match;
 	}
 
-	if (mtrr_tom2) {
-		if (start >= (1ULL<<32) && (end < mtrr_tom2))
-			return MTRR_TYPE_WRBACK;
-	}
-
 	if (prev_match != MTRR_TYPE_INVALID)
 		return prev_match;
 
 	return mtrr_state.def_type;
 }
 
-/*
- * Returns the effective MTRR type for the region
- * Error return:
- * MTRR_TYPE_INVALID - when MTRR is not enabled
+/**
+ * mtrr_type_lookup - look up memory type in MTRR
+ *
+ * Return Values:
+ * MTRR_TYPE_(type)  - The effective MTRR type for the region
+ * MTRR_TYPE_INVALID - MTRR is disabled
  */
 u8 mtrr_type_lookup(u64 start, u64 end)
 {
@@ -230,22 +242,45 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 	int repeat;
 	u64 partial_end;
 
-	type = __mtrr_type_lookup(start, end, &partial_end, &repeat);
+	if (!mtrr_state_set)
+		return MTRR_TYPE_INVALID;
+
+	if (!(mtrr_state.enabled & MTRR_STATE_MTRR_ENABLED))
+		return MTRR_TYPE_INVALID;
+
+	/*
+	 * Look up the fixed ranges first, which take priority over
+	 * the variable ranges.
+	 */
+	type = mtrr_type_lookup_fixed(start, end);
+	if (type != MTRR_TYPE_INVALID)
+		return type;
+
+	/*
+	 * Look up the variable ranges.  Look of multiple ranges matching
+	 * this address and pick type as per MTRR precedence.
+	 */
+	type = mtrr_type_lookup_variable(start, end, &partial_end, &repeat);
 
 	/*
 	 * Common path is with repeat = 0.
 	 * However, we can have cases where [start:end] spans across some
-	 * MTRR range. Do repeated lookups for that case here.
+	 * MTRR ranges and/or the default type.  Do repeated lookups for
+	 * that case here.
 	 */
 	while (repeat) {
 		prev_type = type;
 		start = partial_end;
-		type = __mtrr_type_lookup(start, end, &partial_end, &repeat);
+		type = mtrr_type_lookup_variable(start, end, &partial_end,
+						 &repeat);
 
 		if (check_type_overlap(&prev_type, &type))
 			return type;
 	}
 
+	if (mtrr_tom2 && (start >= (1ULL<<32)) && (end < mtrr_tom2))
+		return MTRR_TYPE_WRBACK;
+
 	return type;
 }
 
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


From: akpm@linux-foundation.org
Subject: + mtrr-x86-fix-mtrr-state-checks-in-mtrr_type_lookup.patch added
 to -mm tree
Date: Tue, 24 Mar 2015 15:43:42 -0700
Message-ID: <5511e89e.mResNLLc+mJt8Dy4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38132 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbbCXWnn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 18:43:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, Elliott@hp.com, dave.hansen@intel.com, hpa@zytor.com, mingo@redhat.com, pebolle@tiscali.nl, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mtrr, x86: fix MTRR state checks in mtrr_type_lookup()
has been added to the -mm tree.  Its filename is
     mtrr-x86-fix-mtrr-state-checks-in-mtrr_type_lookup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mtrr-x86-fix-mtrr-state-checks-in-mtrr_type_lookup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mtrr-x86-fix-mtrr-state-checks-in-mtrr_type_lookup.patch

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
Subject: mtrr, x86: fix MTRR state checks in mtrr_type_lookup()

'mtrr_state.enabled' contains the FE (fixed MTRRs enabled)
and E (MTRRs enabled) flags in MSR_MTRRdefType.  Intel SDM,
section 11.11.2.1, defines these flags as follows:
 - All MTRRs are disabled when the E flag is clear.
   The FE flag has no affect when the E flag is clear.
 - The default type is enabled when the E flag is set.
 - MTRR variable ranges are enabled when the E flag is set.
 - MTRR fixed ranges are enabled when both E and FE flags
   are set.

MTRR state checks in __mtrr_type_lookup() do not match with
SDM.  Hence, this patch makes the following changes:
 - The current code detects MTRRs disabled when both E and
   FE flags are clear in mtrr_state.enabled.  Fix to detect
   MTRRs disabled when the E flag is clear.
 - The current code does not check if the FE bit is set in
   mtrr_state.enabled when looking into the fixed entries.
   Fix to check the FE flag.
 - The current code returns the default type when the E flag
   is clear in mtrr_state.enabled.  However, the default type
   is also disabled when the E flag is clear.  Fix to remove
   the code as this case is handled as MTRR disabled with
   the 1st change.

In addition, this patch defines the E and FE flags in
mtrr_state.enabled as follows.
 - FE flag: MTRR_STATE_MTRR_FIXED_ENABLED
 - E  flag: MTRR_STATE_MTRR_ENABLED

print_mtrr_state() is also updated accordingly.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Robert Elliott <Elliott@hp.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/uapi/asm/mtrr.h   |    4 ++++
 arch/x86/kernel/cpu/mtrr/generic.c |   15 ++++++++-------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff -puN arch/x86/include/uapi/asm/mtrr.h~mtrr-x86-fix-mtrr-state-checks-in-mtrr_type_lookup arch/x86/include/uapi/asm/mtrr.h
--- a/arch/x86/include/uapi/asm/mtrr.h~mtrr-x86-fix-mtrr-state-checks-in-mtrr_type_lookup
+++ a/arch/x86/include/uapi/asm/mtrr.h
@@ -88,6 +88,10 @@ struct mtrr_state_type {
 	mtrr_type def_type;
 };
 
+/* Bit fields for enabled in struct mtrr_state_type */
+#define MTRR_STATE_MTRR_FIXED_ENABLED	0x01
+#define MTRR_STATE_MTRR_ENABLED		0x02
+
 #define MTRRphysBase_MSR(reg) (0x200 + 2 * (reg))
 #define MTRRphysMask_MSR(reg) (0x200 + 2 * (reg) + 1)
 
diff -puN arch/x86/kernel/cpu/mtrr/generic.c~mtrr-x86-fix-mtrr-state-checks-in-mtrr_type_lookup arch/x86/kernel/cpu/mtrr/generic.c
--- a/arch/x86/kernel/cpu/mtrr/generic.c~mtrr-x86-fix-mtrr-state-checks-in-mtrr_type_lookup
+++ a/arch/x86/kernel/cpu/mtrr/generic.c
@@ -119,14 +119,16 @@ static u8 __mtrr_type_lookup(u64 start,
 	if (!mtrr_state_set)
 		return 0xFF;
 
-	if (!mtrr_state.enabled)
+	if (!(mtrr_state.enabled & MTRR_STATE_MTRR_ENABLED))
 		return 0xFF;
 
 	/* Make end inclusive end, instead of exclusive */
 	end--;
 
 	/* Look in fixed ranges. Just return the type as per start */
-	if (mtrr_state.have_fixed && (start < 0x100000)) {
+	if ((start < 0x100000) &&
+	    (mtrr_state.have_fixed) &&
+	    (mtrr_state.enabled & MTRR_STATE_MTRR_FIXED_ENABLED)) {
 		int idx;
 
 		if (start < 0x80000) {
@@ -149,9 +151,6 @@ static u8 __mtrr_type_lookup(u64 start,
 	 * Look of multiple ranges matching this address and pick type
 	 * as per MTRR precedence
 	 */
-	if (!(mtrr_state.enabled & 2))
-		return mtrr_state.def_type;
-
 	prev_match = 0xFF;
 	for (i = 0; i < num_var_ranges; ++i) {
 		unsigned short start_state, end_state, inclusive;
@@ -348,7 +347,9 @@ static void __init print_mtrr_state(void
 		 mtrr_attrib_to_str(mtrr_state.def_type));
 	if (mtrr_state.have_fixed) {
 		pr_debug("MTRR fixed ranges %sabled:\n",
-			 mtrr_state.enabled & 1 ? "en" : "dis");
+			((mtrr_state.enabled & MTRR_STATE_MTRR_ENABLED) &&
+			 (mtrr_state.enabled & MTRR_STATE_MTRR_FIXED_ENABLED)) ?
+			 "en" : "dis");
 		print_fixed(0x00000, 0x10000, mtrr_state.fixed_ranges + 0);
 		for (i = 0; i < 2; ++i)
 			print_fixed(0x80000 + i * 0x20000, 0x04000,
@@ -361,7 +362,7 @@ static void __init print_mtrr_state(void
 		print_fixed_last();
 	}
 	pr_debug("MTRR variable ranges %sabled:\n",
-		 mtrr_state.enabled & 2 ? "en" : "dis");
+		 mtrr_state.enabled & MTRR_STATE_MTRR_ENABLED ? "en" : "dis");
 	high_width = (__ffs64(size_or_mask) - (32 - PAGE_SHIFT) + 3) / 4;
 
 	for (i = 0; i < num_var_ranges; ++i) {
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


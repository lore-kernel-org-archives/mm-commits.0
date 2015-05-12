From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mtrr-x86-fix-mtrr-lookup-to-handle-inclusive-entry.patch removed from -mm
 tree
Date: Tue, 12 May 2015 12:57:41 -0700
Message-ID: <55525b35./yHtrnaYvn74SJO0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933352AbbELT5m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 May 2015 15:57:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, Elliott@hp.com, dave.hansen@intel.com, hpa@zytor.com, mingo@redhat.com, pebolle@tiscali.nl, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mtrr, x86: fix MTRR lookup to handle inclusive entry
has been removed from the -mm tree.  Its filename was
     mtrr-x86-fix-mtrr-lookup-to-handle-inclusive-entry.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: mtrr, x86: fix MTRR lookup to handle inclusive entry

When an MTRR entry is inclusive to a requested range, i.e.  the start and
end of the request are not within the MTRR entry range but the range
contains the MTRR entry entirely, __mtrr_type_lookup() ignores such a case
because both start_state and end_state are set to zero.

This bug can cause the following issues:

1) reserve_memtype() tracks an effective memory type in case a request
   type is WB (ex.  /dev/mem blindly uses WB).  Missing to track with its
   effective type causes a subsequent request to map the same range with
   the effective type to fail.

2) pud_set_huge() and pmd_set_huge() check if a requested range has any
   overlap with MTRRs.  Missing to detect an overlap may cause a
   performance penalty or undefined behavior.

This patch fixes the bug by adding a new flag, 'inclusive', to detect the
inclusive case.  This case is then handled in the same way as
(!start_state && end_state).  With this fix, __mtrr_type_lookup() handles
the inclusive case properly.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Robert Elliott <Elliott@hp.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mtrr/generic.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN arch/x86/kernel/cpu/mtrr/generic.c~mtrr-x86-fix-mtrr-lookup-to-handle-inclusive-entry arch/x86/kernel/cpu/mtrr/generic.c
--- a/arch/x86/kernel/cpu/mtrr/generic.c~mtrr-x86-fix-mtrr-lookup-to-handle-inclusive-entry
+++ a/arch/x86/kernel/cpu/mtrr/generic.c
@@ -154,7 +154,7 @@ static u8 __mtrr_type_lookup(u64 start,
 
 	prev_match = 0xFF;
 	for (i = 0; i < num_var_ranges; ++i) {
-		unsigned short start_state, end_state;
+		unsigned short start_state, end_state, inclusive;
 
 		if (!(mtrr_state.var_ranges[i].mask_lo & (1 << 11)))
 			continue;
@@ -166,15 +166,16 @@ static u8 __mtrr_type_lookup(u64 start,
 
 		start_state = ((start & mask) == (base & mask));
 		end_state = ((end & mask) == (base & mask));
+		inclusive = ((start < base) && (end > base));
 
-		if (start_state != end_state) {
+		if ((start_state != end_state) || inclusive) {
 			/*
 			 * We have start:end spanning across an MTRR.
-			 * We split the region into
-			 * either
-			 * (start:mtrr_end) (mtrr_end:end)
-			 * or
-			 * (start:mtrr_start) (mtrr_start:end)
+			 * We split the region into either
+			 * - start_state:1
+			 *     (start:mtrr_end) (mtrr_end:end)
+			 * - end_state:1 or inclusive:1
+			 *     (start:mtrr_start) (mtrr_start:end)
 			 * depending on kind of overlap.
 			 * Return the type for first region and a pointer to
 			 * the start of second region so that caller will
@@ -195,7 +196,7 @@ static u8 __mtrr_type_lookup(u64 start,
 			*repeat = 1;
 		}
 
-		if ((start & mask) != (base & mask))
+		if (!start_state)
 			continue;
 
 		curr_match = mtrr_state.var_ranges[i].base_lo & 0xff;
_

Patches currently in -mm which might be from toshi.kani@hp.com are

linux-next.patch
mtrr-x86-fix-mtrr-state-checks-in-mtrr_type_lookup.patch
mtrr-x86-define-mtrr_type_invalid-for-mtrr_type_lookup.patch
mtrr-x86-clean-up-mtrr_type_lookup.patch
mtrr-mm-x86-enhance-mtrr-checks-for-kva-huge-page-mapping.patch


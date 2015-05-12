From: akpm@linux-foundation.org
Subject: [merged]
 mtrr-x86-remove-a-wrong-address-check-in-__mtrr_type_lookup.patch removed
 from -mm tree
Date: Tue, 12 May 2015 12:57:56 -0700
Message-ID: <55525b44.YbMG3taxEl7l0wxU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933488AbbELT55 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 May 2015 15:57:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, Elliott@hp.com, dave.hansen@intel.com, hpa@zytor.com, mingo@redhat.com, pebolle@tiscali.nl, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mtrr, x86: remove a wrong address check in __mtrr_type_lookup()
has been removed from the -mm tree.  Its filename was
     mtrr-x86-remove-a-wrong-address-check-in-__mtrr_type_lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: mtrr, x86: remove a wrong address check in __mtrr_type_lookup()

__mtrr_type_lookup() checks MTRR fixed ranges when mtrr_state.have_fixed
is set and start is less than 0x100000.  However, the 'else if (start <
0x1000000)' in the code checks with a wrong address as it has an
extra-zero in the address.  The code still runs correctly as this check is
meaningless, though.

This patch replaces the wrong address check with 'else' with no condition.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Robert Elliott <Elliott@hp.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mtrr/generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/cpu/mtrr/generic.c~mtrr-x86-remove-a-wrong-address-check-in-__mtrr_type_lookup arch/x86/kernel/cpu/mtrr/generic.c
--- a/arch/x86/kernel/cpu/mtrr/generic.c~mtrr-x86-remove-a-wrong-address-check-in-__mtrr_type_lookup
+++ a/arch/x86/kernel/cpu/mtrr/generic.c
@@ -137,7 +137,7 @@ static u8 __mtrr_type_lookup(u64 start,
 			idx = 1 * 8;
 			idx += ((start - 0x80000) >> 14);
 			return mtrr_state.fixed_ranges[idx];
-		} else if (start < 0x1000000) {
+		} else {
 			idx = 3 * 8;
 			idx += ((start - 0xC0000) >> 12);
 			return mtrr_state.fixed_ranges[idx];
_

Patches currently in -mm which might be from toshi.kani@hp.com are

linux-next.patch


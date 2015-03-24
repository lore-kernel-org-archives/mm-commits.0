From: akpm@linux-foundation.org
Subject: +
 mtrr-x86-remove-a-wrong-address-check-in-__mtrr_type_lookup.patch added to
 -mm tree
Date: Tue, 24 Mar 2015 15:43:40 -0700
Message-ID: <5511e89c.O44EIHIbkZPC6FPI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbbCXWnl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 18:43:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, Elliott@hp.com, dave.hansen@intel.com, hpa@zytor.com, mingo@redhat.com, pebolle@tiscali.nl, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mtrr, x86: remove a wrong address check in __mtrr_type_lookup()
has been added to the -mm tree.  Its filename is
     mtrr-x86-remove-a-wrong-address-check-in-__mtrr_type_lookup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mtrr-x86-remove-a-wrong-address-check-in-__mtrr_type_lookup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mtrr-x86-remove-a-wrong-address-check-in-__mtrr_type_lookup.patch

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


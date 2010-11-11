From: akpm@linux-foundation.org
Subject: + arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline.patch added to -mm tree
Date: Thu, 11 Nov 2010 12:56:43 -0800
Message-ID: <201011112128.oABLSsjp003620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756393Ab0KKV3O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Nov 2010 16:29:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, feng.tang@intel.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de


The patch titled
     arch/x86/include/asm/fixmap.h: mark __set_fixmap_offset as __always_inline
has been added to the -mm tree.  Its filename is
     arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/include/asm/fixmap.h: mark __set_fixmap_offset as __always_inline
From: Andrew Morton <akpm@linux-foundation.org>

When compiling arch/x86/kernel/early_printk_mrst.c with i386 allmodconfig,
gcc-4.1.0 generates an out-of-line copy of __set_fixmap_offset() whcih
contains a reference to __this_fixmap_does_not_exist which the compiler cannot
elide.

Marking __set_fixmap_offset() as __always_inline prevents this.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/fixmap.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/early_printk_mrst.c~arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline arch/x86/kernel/early_printk_mrst.c
diff -puN arch/x86/include/asm/fixmap.h~arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline arch/x86/include/asm/fixmap.h
--- a/arch/x86/include/asm/fixmap.h~arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline
+++ a/arch/x86/include/asm/fixmap.h
@@ -216,8 +216,8 @@ static inline unsigned long virt_to_fix(
 }
 
 /* Return an pointer with offset calculated */
-static inline unsigned long __set_fixmap_offset(enum fixed_addresses idx,
-				phys_addr_t phys, pgprot_t flags)
+static __always_inline unsigned long
+__set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys, pgprot_t flags)
 {
 	__set_fixmap(idx, phys, flags);
 	return fix_to_virt(idx) + (phys & (PAGE_SIZE - 1));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hpet-factor-timer-allocate-from-open.patch
atomic-add-atomic_inc_not_zero_hint-checkpatch-fixes.patch
drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store.patch
restrict-unprivileged-access-to-kernel-syslog-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-low-threshold-to-pwm-backlight.patch
arch-x86-kernel-entry_32s-work-around-gas-2161-glitch.patch
arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline.patch


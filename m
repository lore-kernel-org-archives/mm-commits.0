From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-entry_32s-work-around-gas-2161-glitch.patch added to -mm tree
Date: Thu, 11 Nov 2010 12:14:07 -0800
Message-ID: <201011112046.oABKkIen001723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754642Ab0KKUqc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Nov 2010 15:46:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@zytor.com, jbeulich@novell.com, mingo@elte.hu


The patch titled
     arch/x86/kernel/entry_32.S: work around gas-2.16.1 glitch
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-entry_32s-work-around-gas-2161-glitch.patch

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
Subject: arch/x86/kernel/entry_32.S: work around gas-2.16.1 glitch
From: Andrew Morton <akpm@linux-foundation.org>

With i386, gas-2.16.1:

arch/x86/kernel/entry_32.S: Assembler messages:
arch/x86/kernel/entry_32.S:398: Error: too many positional arguments

Parenthesising TI_sysenter_return makes it go away.

It changes the cpp output from

 pushl_cfi (60 -8192 +8+4*4)(%esp)

to

 pushl_cfi ((60)-8192 +8+4*4)(%esp)

Cc: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/entry_32.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/entry_32.S~arch-x86-kernel-entry_32s-work-around-gas-2161-glitch arch/x86/kernel/entry_32.S
--- a/arch/x86/kernel/entry_32.S~arch-x86-kernel-entry_32s-work-around-gas-2161-glitch
+++ a/arch/x86/kernel/entry_32.S
@@ -395,7 +395,7 @@ sysenter_past_esp:
 	 * A tiny bit of offset fixup is necessary - 4*4 means the 4 words
 	 * pushed above; +8 corresponds to copy_thread's esp0 setting.
 	 */
-	pushl_cfi (TI_sysenter_return-THREAD_SIZE_asm+8+4*4)(%esp)
+	pushl_cfi ((TI_sysenter_return)-THREAD_SIZE_asm+8+4*4)(%esp)
 	CFI_REL_OFFSET eip, 0
 
 	pushl_cfi %eax
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


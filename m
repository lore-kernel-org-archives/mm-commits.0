From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-hpetc-make-the-hpet-compare-register-read-back-failed-warning-conditional-on-the-hpet=verbose-boot-option.patch added to -mm tree
Date: Mon, 12 Apr 2010 13:32:59 -0700
Message-ID: <201004122033.o3CKX0ij025402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753393Ab0DLUdY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Apr 2010 16:33:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, mingo@elte.hu, rui.zhang@intel.com, tglx@linutronix.de, venki@google.com


The patch titled
     arch/x86/kernel/hpet.c: make the "hpet: compare register read back failed" warning conditional on the hpet=verbose boot option
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-hpetc-make-the-hpet-compare-register-read-back-failed-warning-conditional-on-the-hpet=verbose-boot-option.patch

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
Subject: arch/x86/kernel/hpet.c: make the "hpet: compare register read back failed" warning conditional on the hpet=verbose boot option
From: john stultz <johnstul@us.ibm.com>

A considerable number of people are hitting this warning and are raising
"bug" reports.  We don't seem to be getting much benefit from the warning,
so let's hide it unless hpet-verbose.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/hpet.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/hpet.c~arch-x86-kernel-hpetc-make-the-hpet-compare-register-read-back-failed-warning-conditional-on-the-hpet=verbose-boot-option arch/x86/kernel/hpet.c
--- a/arch/x86/kernel/hpet.c~arch-x86-kernel-hpetc-make-the-hpet-compare-register-read-back-failed-warning-conditional-on-the-hpet=verbose-boot-option
+++ a/arch/x86/kernel/hpet.c
@@ -406,8 +406,10 @@ static int hpet_next_event(unsigned long
 	 * read returns old value.
 	 */
 	if (unlikely((u32)hpet_readl(HPET_Tn_CMP(timer)) != cnt)) {
-		WARN_ONCE(hpet_readl(HPET_Tn_CMP(timer)) != cnt,
-		  KERN_WARNING "hpet: compare register read back failed.\n");
+		if (hpet_verbose)
+			WARN_ONCE(hpet_readl(HPET_Tn_CMP(timer)) != cnt,
+			  KERN_WARNING
+			  "hpet: compare register read back failed.\n");
 	}
 
 	return (s32)(hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

linux-next.patch
arch-x86-kernel-hpetc-make-the-hpet-compare-register-read-back-failed-warning-conditional-on-the-hpet=verbose-boot-option.patch
cs5535-clockevt-free-timer-in-irq-setup-error-path.patch
time-clean-up-warp_clock.patch
time-clean-up-direct-xtime-usage-in-xen.patch
ntp-make-time_adjust-static.patch
ntp-remove-tickadj.patch
xtensa-fix-unnecessary-setting-of-xtime.patch
hangcheck-timer-fix-x86_32-bugs.patch
time-kill-off-config_generic_time.patch


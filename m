From: akpm@linux-foundation.org
Subject: [alternative-merged] arch-x86-kernel-hpetc-make-the-hpet-compare-register-read-back-failed-warning-conditional-on-the-hpet=verbose-boot-option.patch removed from -mm tree
Date: Fri, 07 May 2010 11:41:26 -0400
Message-ID: <201005071842.o47IguJf005141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757774Ab0EGSn1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 May 2010 14:43:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, mingo@elte.hu, rui.zhang@intel.com, tglx@linutronix.de, venki@google.com, mm-commits@vger.kernel.org


The patch titled
     arch/x86/kernel/hpet.c: make the "hpet: compare register read back failed" warning conditional on the hpet=verbose boot option
has been removed from the -mm tree.  Its filename was
     arch-x86-kernel-hpetc-make-the-hpet-compare-register-read-back-failed-warning-conditional-on-the-hpet=verbose-boot-option.patch

This patch was dropped because an alternative patch was merged

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
hpet-factor-timer-allocate-from-open.patch
hangcheck-timer-fix-x86_32-bugs.patch
time-kill-off-config_generic_time.patch


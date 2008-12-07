From: akpm@linux-foundation.org
Subject: - apm-remove-config_apm_real_mode_power_off-in-favor-of-kernel-parameter.patch removed from -mm tree
Date: Sat, 06 Dec 2008 16:04:56 -0800
Message-ID: <200812070004.mB704uPW021064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753524AbYLGAFX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 19:05:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: niels.devos@wincor-nixdorf.com, hpa@zytor.com, mingo@elte.hu, sfr@canb.auug.org.au, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     apm: remove CONFIG_APM_REAL_MODE_POWER_OFF in favor of a kernel parameter
has been removed from the -mm tree.  Its filename was
     apm-remove-config_apm_real_mode_power_off-in-favor-of-kernel-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: apm: remove CONFIG_APM_REAL_MODE_POWER_OFF in favor of a kernel parameter
From: Niels de Vos <niels.devos@wincor-nixdorf.com>

Remove CONFIG_APM_REAL_MODE_POWER_OFF like CONFIG_APM_POWER_OFF which
has been done for linux-2.2.14pre8 (http://lkml.org/lkml/1999/11/23/3).

Re-introducing CONFIG_APM_POWER_OFF got nack-ed. Stephen didn't bother
to remove CONFIG_APM_REAL_MODE_POWER_OFF, let's get rid of it now.
	Reference: http://lkml.org/lkml/2008/5/7/97

Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig         |    7 -------
 arch/x86/kernel/apm_32.c |    4 ----
 2 files changed, 11 deletions(-)

diff -puN arch/x86/Kconfig~apm-remove-config_apm_real_mode_power_off-in-favor-of-kernel-parameter arch/x86/Kconfig
--- a/arch/x86/Kconfig~apm-remove-config_apm_real_mode_power_off-in-favor-of-kernel-parameter
+++ a/arch/x86/Kconfig
@@ -1665,13 +1665,6 @@ config APM_ALLOW_INTS
 	  many of the newer IBM Thinkpads.  If you experience hangs when you
 	  suspend, try setting this to Y.  Otherwise, say N.
 
-config APM_REAL_MODE_POWER_OFF
-	bool "Use real mode APM BIOS call to power off"
-	help
-	  Use real mode APM BIOS calls to switch off the computer. This is
-	  a work-around for a number of buggy BIOSes. Switch this option on if
-	  your computer crashes instead of powering off properly.
-
 endif # APM
 
 source "arch/x86/kernel/cpu/cpufreq/Kconfig"
diff -puN arch/x86/kernel/apm_32.c~apm-remove-config_apm_real_mode_power_off-in-favor-of-kernel-parameter arch/x86/kernel/apm_32.c
--- a/arch/x86/kernel/apm_32.c~apm-remove-config_apm_real_mode_power_off-in-favor-of-kernel-parameter
+++ a/arch/x86/kernel/apm_32.c
@@ -391,11 +391,7 @@ static int power_off;
 #else
 static int power_off = 1;
 #endif
-#ifdef CONFIG_APM_REAL_MODE_POWER_OFF
-static int realmode_power_off = 1;
-#else
 static int realmode_power_off;
-#endif
 #ifdef CONFIG_APM_ALLOW_INTS
 static int allow_ints = 1;
 #else
_

Patches currently in -mm which might be from niels.devos@wincor-nixdorf.com are

linux-next.patch
serio_raw-add-support-for-translated-serio_i8042xl-ports.patch


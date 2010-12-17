From: akpm@linux-foundation.org
Subject: + x86-watchdog-compile-fix-when-config_local_apic-not-enabled.patch added to -mm tree
Date: Thu, 16 Dec 2010 18:21:29 -0800
Message-ID: <201012170224.oBH2OKJK014111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750943Ab0LQCY3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Dec 2010 21:24:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dzickus@redhat.com


The patch titled
     x86, watchdog: Compile fix when CONFIG_LOCAL_APIC not enabled
has been added to the -mm tree.  Its filename is
     x86-watchdog-compile-fix-when-config_local_apic-not-enabled.patch

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
Subject: x86, watchdog: Compile fix when CONFIG_LOCAL_APIC not enabled
From: Don Zickus <dzickus@redhat.com>

When adjusting the code to handle removing the old nmi watchdog,
I forgot to consider the compile case when the local apic is not
enabled.  This small change fixes the compile warning:

arch/x86/kernel/apic/hw_nmi.c:28:6: error: redefinition of `touch_nmi_watchdog'

Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/apic/hw_nmi.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/x86/kernel/apic/hw_nmi.c~x86-watchdog-compile-fix-when-config_local_apic-not-enabled arch/x86/kernel/apic/hw_nmi.c
--- a/arch/x86/kernel/apic/hw_nmi.c~x86-watchdog-compile-fix-when-config_local_apic-not-enabled
+++ a/arch/x86/kernel/apic/hw_nmi.c
@@ -17,6 +17,7 @@
 #include <linux/nmi.h>
 #include <linux/module.h>
 
+#ifdef ARCH_HAS_NMI_WATCHDOG
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 u64 hw_nmi_get_sample_period(void)
 {
@@ -31,6 +32,8 @@ void touch_nmi_watchdog(void)
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
 #endif
+#endif
+
 #ifdef arch_trigger_all_cpu_backtrace
 /* For reliability, we're prepared to waste bits here. */
 static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
_

Patches currently in -mm which might be from dzickus@redhat.com are

linux-next.patch
x86-watchdog-compile-fix-when-config_local_apic-not-enabled.patch


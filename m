From: akpm@linux-foundation.org
Subject: [merged] x86-watchdog-compile-fix-when-config_local_apic-not-enabled.patch removed from -mm tree
Date: Fri, 17 Dec 2010 14:30:08 -0800
Message-ID: <201012172233.oBHMX6tv032666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756015Ab0LQWdS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Dec 2010 17:33:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     x86, watchdog: Compile fix when CONFIG_LOCAL_APIC not enabled
has been removed from the -mm tree.  Its filename was
     x86-watchdog-compile-fix-when-config_local_apic-not-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


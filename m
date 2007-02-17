From: akpm@linux-foundation.org
Subject: - acpi-fix-missing-include-for-up.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:14:46 -0800
Message-ID: <200702170714.l1H7EkgH021552@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51162 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946509AbXBQHQt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:16:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, len.brown@intel.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     ACPI: fix missing include for UP
has been removed from the -mm tree.  Its filename was
     acpi-fix-missing-include-for-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI: fix missing include for UP
From: Thomas Gleixner <tglx@linutronix.de>

apic.h does not get included on UP compiles.  That way the
APICTIMER_STOPS_ON_C3 is not there and UP boxen have no support for timer
broadcasting.  This was never noticed, because the lapic timer is only used
for profiling on UP.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/acpi/processor_idle.c~acpi-fix-missing-include-for-up drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~acpi-fix-missing-include-for-up
+++ a/drivers/acpi/processor_idle.c
@@ -40,6 +40,16 @@
 #include <linux/sched.h>	/* need_resched() */
 #include <linux/latency.h>
 
+/*
+ * Include the apic definitions for x86 to have the APIC timer related defines
+ * available also for UP (on SMP it gets magically included via linux/smp.h).
+ * asm/acpi.h is not an option, as it would require more include magic. Also
+ * creating an empty asm-ia64/apic.h would just trade pest vs. cholera.
+ */
+#ifdef CONFIG_X86
+#include <asm/apic.h>
+#endif
+
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-block.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch

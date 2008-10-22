From: akpm@linux-foundation.org
Subject: - x86-acpi-fix-breakage-of-resume-on-64-bit-up-systems-with-smp-kernel.patch removed from -mm tree
Date: Wed, 22 Oct 2008 13:08:49 -0700
Message-ID: <200810222008.m9MK8nvT013852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753713AbYJVUJ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Oct 2008 16:09:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, ajw1980@gmail.com, lenb@kernel.org, mingo@elte.hu, pavel@suse.cz, stable@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86 acpi: fix breakage of resume on 64-bit UP systems with SMP kernel
has been removed from the -mm tree.  Its filename was
     x86-acpi-fix-breakage-of-resume-on-64-bit-up-systems-with-smp-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86 acpi: fix breakage of resume on 64-bit UP systems with SMP kernel
From: Rafael J. Wysocki <rjw@sisk.pl>

We are now using per CPU GDT tables in head_64.S and the original
early_gdt_descr.address is invalidated after boot by
setup_per_cpu_areas().  This breaks resume from suspend to RAM on x86_64
UP systems using SMP kernels, because this part of head_64.S is also
executed during the resume and the invalid GDT address causes the system
to crash.  It doesn't break on 'true' SMP systems, because
early_gdt_descr.address is modified every time native_cpu_up() runs. 
However, during resume it should point to the GDT of the boot CPU rather
than to another CPU's GDT.

For this reason, during suspend to RAM always make early_gdt_descr.address
point to the boot CPU's GDT.

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=11568, which is a
regression from 2.6.26.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-and-tested-by: Andy Wettstein <ajw1980@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Len Brown <lenb@kernel.org>
Acked-by: Pavel Machek <pavel@suse.cz>
Cc: <stable@kernel.org>		[2.6.27.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/acpi/sleep.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/x86/kernel/acpi/sleep.c~x86-acpi-fix-breakage-of-resume-on-64-bit-up-systems-with-smp-kernel arch/x86/kernel/acpi/sleep.c
--- a/arch/x86/kernel/acpi/sleep.c~x86-acpi-fix-breakage-of-resume-on-64-bit-up-systems-with-smp-kernel
+++ a/arch/x86/kernel/acpi/sleep.c
@@ -10,6 +10,7 @@
 #include <linux/dmi.h>
 #include <linux/cpumask.h>
 #include <asm/segment.h>
+#include <asm/desc.h>
 
 #include "realmode/wakeup.h"
 #include "sleep.h"
@@ -98,6 +99,8 @@ int acpi_save_state_mem(void)
 	header->trampoline_segment = setup_trampoline() >> 4;
 #ifdef CONFIG_SMP
 	stack_start.sp = temp_stack + sizeof(temp_stack);
+	early_gdt_descr.address =
+			(unsigned long)get_cpu_gdt_table(smp_processor_id());
 #endif
 	initial_code = (unsigned long)wakeup_long64;
 	saved_magic = 0x123456789abcdef0;
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
linux-next.patch
skge-adapt-skge-to-use-reworked-pci-pm.patch
e100-adapt-to-the-reworked-pci-pm.patch
shrink_slab-handle-bad-shrinkers.patch


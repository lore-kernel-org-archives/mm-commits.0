From: akpm@linux-foundation.org
Subject: - i386-do-not-restore-reserved-memory-after-hibernation.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:09:48 -0700
Message-ID: <200707192009.l6JK9mP5020611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51667 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761143AbXGSUQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, ak@suse.de, pavel@ucw.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     i386: do not restore reserved memory after hibernation
has been removed from the -mm tree.  Its filename was
     i386-do-not-restore-reserved-memory-after-hibernation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: do not restore reserved memory after hibernation
From: Rafael J. Wysocki <rjw@sisk.pl>

On some systems the ACPI NVS area is located in the first 1 MB of RAM and
it is overwritten by the i386 code during the restore after hibernation. 
This confuses the ACPI platform firmware that doesn't update the AC adapter
status appropriately as a result
(http://bugzilla.kernel.org/show_bug.cgi?id=7995).

The solution is to register the reserved memory in the first 1 MB as
'nosave', so that swsusp doesn't touch it during the restore.  Also, this
has been done on x86_64 for a long time now, so this patch makes the i386
restore code behave like the x86_64 one.

[akpm@linux-foundation.org: build fix]
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <ak@suse.de>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/e820.c  |   32 ++++++++++++++++++++++++++++++++
 arch/i386/kernel/setup.c |    1 +
 include/asm-i386/e820.h  |    8 ++++++++
 3 files changed, 41 insertions(+)

diff -puN arch/i386/kernel/e820.c~i386-do-not-restore-reserved-memory-after-hibernation arch/i386/kernel/e820.c
--- a/arch/i386/kernel/e820.c~i386-do-not-restore-reserved-memory-after-hibernation
+++ a/arch/i386/kernel/e820.c
@@ -10,6 +10,7 @@
 #include <linux/efi.h>
 #include <linux/pfn.h>
 #include <linux/uaccess.h>
+#include <linux/suspend.h>
 
 #include <asm/pgtable.h>
 #include <asm/page.h>
@@ -320,6 +321,37 @@ static int __init request_standard_resou
 
 subsys_initcall(request_standard_resources);
 
+#if defined(CONFIG_PM) && defined(CONFIG_SOFTWARE_SUSPEND)
+/**
+ * e820_mark_nosave_regions - Find the ranges of physical addresses that do not
+ * correspond to e820 RAM areas and mark the corresponding pages as nosave for
+ * hibernation.
+ *
+ * This function requires the e820 map to be sorted and without any
+ * overlapping entries and assumes the first e820 area to be RAM.
+ */
+void __init e820_mark_nosave_regions(void)
+{
+	int i;
+	unsigned long pfn;
+
+	pfn = PFN_DOWN(e820.map[0].addr + e820.map[0].size);
+	for (i = 1; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+
+		if (pfn < PFN_UP(ei->addr))
+			register_nosave_region(pfn, PFN_UP(ei->addr));
+
+		pfn = PFN_DOWN(ei->addr + ei->size);
+		if (ei->type != E820_RAM)
+			register_nosave_region(PFN_UP(ei->addr), pfn);
+
+		if (pfn >= max_low_pfn)
+			break;
+	}
+}
+#endif
+
 void __init add_memory_region(unsigned long long start,
 			      unsigned long long size, int type)
 {
diff -puN arch/i386/kernel/setup.c~i386-do-not-restore-reserved-memory-after-hibernation arch/i386/kernel/setup.c
--- a/arch/i386/kernel/setup.c~i386-do-not-restore-reserved-memory-after-hibernation
+++ a/arch/i386/kernel/setup.c
@@ -640,6 +640,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	e820_register_memory();
+	e820_mark_nosave_regions();
 
 #ifdef CONFIG_VT
 #if defined(CONFIG_VGA_CONSOLE)
diff -puN include/asm-i386/e820.h~i386-do-not-restore-reserved-memory-after-hibernation include/asm-i386/e820.h
--- a/include/asm-i386/e820.h~i386-do-not-restore-reserved-memory-after-hibernation
+++ a/include/asm-i386/e820.h
@@ -47,6 +47,14 @@ extern void e820_register_memory(void);
 extern void limit_regions(unsigned long long size);
 extern void print_memory_map(char *who);
 
+#if defined(CONFIG_PM) && defined(CONFIG_SOFTWARE_SUSPEND)
+extern void e820_mark_nosave_regions(void);
+#else
+static inline void e820_mark_nosave_regions(void)
+{
+}
+#endif
+
 #endif/*!__ASSEMBLY__*/
 
 #endif/*__E820_HEADER*/
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
acpi-implement-the-set_target-callback-from-pm_ops.patch
acpi-add-acpi_pm_device_sleep_state-helper-routine.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-fix-compilation-of-suspend-code-if-config_pm-is-unset.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
shrink_slab-handle-bad-shrinkers.patch

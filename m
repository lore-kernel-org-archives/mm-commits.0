From: akpm@linux-foundation.org
Subject: [to-be-updated] kernel-rebootc-move-arch-x86-reboot=-handling-to-generic-kernel.patch removed from -mm tree
Date: Wed, 24 Apr 2013 15:18:25 -0700
Message-ID: <20130424221825.8B75C5A4034@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:64136 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989Ab3DXWS0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Apr 2013 18:18:26 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so7979ggc.0
        for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2013 15:18:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, akpm@linux-foundation.org, hpa@zytor.com, mingo@redhat.com, rja@sgi.com, shawn.guo@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/reboot.c: move arch/x86 reboot= handling to generic kernel
has been removed from the -mm tree.  Its filename was
     kernel-rebootc-move-arch-x86-reboot=-handling-to-generic-kernel.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Robin Holt <holt@sgi.com>
Subject: kernel/reboot.c: move arch/x86 reboot= handling to generic kernel

Since arch/x86 has the most extensive reboot= handling and it appears to
have no effect on the remaining architectures.  This patch moves that
reboot= handling from arch/x86 to the generic kernel.

Signed-off-by: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   14 ++-
 arch/x86/kernel/reboot.c            |  113 +-------------------------
 kernel/reboot.c                     |   96 ++++++++++++++++++++--
 3 files changed, 109 insertions(+), 114 deletions(-)

diff -puN Documentation/kernel-parameters.txt~kernel-rebootc-move-arch-x86-reboot=-handling-to-generic-kernel Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~kernel-rebootc-move-arch-x86-reboot=-handling-to-generic-kernel
+++ a/Documentation/kernel-parameters.txt
@@ -2669,9 +2669,17 @@ bytes respectively. Such letter suffixes
 			Run specified binary instead of /init from the ramdisk,
 			used for early userspace startup. See initrd.
 
-	reboot=		[BUGS=X86-32,BUGS=ARM,BUGS=IA-64] Rebooting mode
-			Format: <reboot_mode>[,<reboot_mode2>[,...]]
-			See arch/*/kernel/reboot.c or arch/*/kernel/process.c
+	reboot=		[KNL]
+			Format:
+				[w[arm] | c[old]] \
+				[,b[ios] | a[cpi] | k[bd] | t[riple] | e[fi] | p[ci]] \
+				[,f[orce] \
+				[,] s[mp]####
+			Where reboot_mode is one of warm or cold,
+			      reboot_type is one of bios, acpi, kbd, triple, efi, or pci,
+			      reboot_force is either force or not specified,
+			      and reboot_cpu is s[mp]#### with #### being the
+			      processor to be used for rebooting.
 
 	relax_domain_level=
 			[KNL, SMP] Set scheduler's default relax_domain_level.
diff -puN arch/x86/kernel/reboot.c~kernel-rebootc-move-arch-x86-reboot=-handling-to-generic-kernel arch/x86/kernel/reboot.c
--- a/arch/x86/kernel/reboot.c~kernel-rebootc-move-arch-x86-reboot=-handling-to-generic-kernel
+++ a/arch/x86/kernel/reboot.c
@@ -36,22 +36,11 @@ void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
 static const struct desc_ptr no_idt = {};
-static int reboot_mode;
-enum reboot_type reboot_type = BOOT_ACPI;
-int reboot_force;
+extern int reboot_mode;
+extern enum reboot_type reboot_type;
+extern int reboot_force;
 
-/*
- * This variable is used privately to keep track of whether or not
- * reboot_type is still set to its default value (i.e., reboot= hasn't
- * been set on the command line).  This is needed so that we can
- * suppress DMI scanning for reboot quirks.  Without it, it's
- * impossible to override a faulty reboot quirk without recompiling.
- */
-static int reboot_default = 1;
-
-#ifdef CONFIG_SMP
-static int reboot_cpu = -1;
-#endif
+extern int reboot_default;
 
 /*
  * This is set if we need to go through the 'emergency' path.
@@ -63,78 +52,6 @@ static int reboot_emergency;
 /* This is set by the PCI code if either type 1 or type 2 PCI is detected */
 bool port_cf9_safe = false;
 
-/*
- * reboot=b[ios] | s[mp] | t[riple] | k[bd] | e[fi] [, [w]arm | [c]old] | p[ci]
- * warm   Don't set the cold reboot flag
- * cold   Set the cold reboot flag
- * bios   Reboot by jumping through the BIOS
- * smp    Reboot by executing reset on BSP or other CPU
- * triple Force a triple fault (init)
- * kbd    Use the keyboard controller. cold reset (default)
- * acpi   Use the RESET_REG in the FADT
- * efi    Use efi reset_system runtime service
- * pci    Use the so-called "PCI reset register", CF9
- * force  Avoid anything that could hang.
- */
-static int __init reboot_setup(char *str)
-{
-	for (;;) {
-		/*
-		 * Having anything passed on the command line via
-		 * reboot= will cause us to disable DMI checking
-		 * below.
-		 */
-		reboot_default = 0;
-
-		switch (*str) {
-		case 'w':
-			reboot_mode = 0x1234;
-			break;
-
-		case 'c':
-			reboot_mode = 0;
-			break;
-
-#ifdef CONFIG_SMP
-		case 's':
-			if (isdigit(*(str+1))) {
-				reboot_cpu = (int) (*(str+1) - '0');
-				if (isdigit(*(str+2)))
-					reboot_cpu = reboot_cpu*10 + (int)(*(str+2) - '0');
-			}
-			/*
-			 * We will leave sorting out the final value
-			 * when we are ready to reboot, since we might not
-			 * have detected BSP APIC ID or smp_num_cpu
-			 */
-			break;
-#endif /* CONFIG_SMP */
-
-		case 'b':
-		case 'a':
-		case 'k':
-		case 't':
-		case 'e':
-		case 'p':
-			reboot_type = *str;
-			break;
-
-		case 'f':
-			reboot_force = 1;
-			break;
-		}
-
-		str = strchr(str, ',');
-		if (str)
-			str++;
-		else
-			break;
-	}
-	return 1;
-}
-
-__setup("reboot=", reboot_setup);
-
 
 /*
  * Reboot options and system auto-detection code provided by
@@ -614,26 +531,10 @@ void native_machine_shutdown(void)
 {
 	/* Stop the cpus and apics */
 #ifdef CONFIG_SMP
-
-	/* The boot cpu is always logical cpu 0 */
-	int reboot_cpu_id = 0;
-
-	/* See if there has been given a command line override */
-	if ((reboot_cpu != -1) && (reboot_cpu < nr_cpu_ids) &&
-		cpu_online(reboot_cpu))
-		reboot_cpu_id = reboot_cpu;
-
-	/* Make certain the cpu I'm about to reboot on is online */
-	if (!cpu_online(reboot_cpu_id))
-		reboot_cpu_id = smp_processor_id();
-
-	/* Make certain I only run on the appropriate processor */
-	set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));
-
 	/*
-	 * O.K Now that I'm on the appropriate processor, stop all of the
-	 * others. Also disable the local irq to not receive the per-cpu
-	 * timer interrupt which may trigger scheduler's load balance.
+	 * Stop all of the others. Also disable the local irq to
+	 * not receive the per-cpu timer interrupt which may trigger
+	 * scheduler's load balance.
 	 */
 	local_irq_disable();
 	stop_other_cpus();
diff -puN kernel/reboot.c~kernel-rebootc-move-arch-x86-reboot=-handling-to-generic-kernel kernel/reboot.c
--- a/kernel/reboot.c~kernel-rebootc-move-arch-x86-reboot=-handling-to-generic-kernel
+++ a/kernel/reboot.c
@@ -6,6 +6,7 @@
 
 #define pr_fmt(fmt)	"reboot: " fmt
 
+#include <linux/ctype.h>
 #include <linux/export.h>
 #include <linux/kexec.h>
 #include <linux/kmod.h>
@@ -69,22 +70,107 @@ int unregister_reboot_notifier(struct no
 }
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
+/*
+ * This variable is used privately to keep track of whether or not
+ * reboot_type is still set to its default value (i.e., reboot= hasn't
+ * been set on the command line).  This is needed so that we can
+ * suppress DMI scanning for reboot quirks.  Without it, it's
+ * impossible to override a faulty reboot quirk without recompiling.
+ */
+int reboot_default = 1;
+int reboot_mode;
+enum reboot_type reboot_type = BOOT_ACPI;
+int reboot_force;
+static int reboot_cpu;
+
+/*
+ * reboot=b[ios] | s[mp] | t[riple] | k[bd] | e[fi] [, [w]arm | [c]old] | p[ci]
+ * warm   Don't set the cold reboot flag
+ * cold   Set the cold reboot flag
+ * bios   Reboot by jumping through the BIOS
+ * smp    Reboot by executing reset on BSP or other CPU
+ * triple Force a triple fault (init)
+ * kbd    Use the keyboard controller. cold reset (default)
+ * acpi   Use the RESET_REG in the FADT
+ * efi    Use efi reset_system runtime service
+ * pci    Use the so-called "PCI reset register", CF9
+ * force  Avoid anything that could hang.
+ */
+static int __init reboot_setup(char *str)
+{
+	int i;
+
+	for (;;) {
+		/*
+		 * Having anything passed on the command line via
+		 * reboot= will cause us to disable DMI checking
+		 * below.
+		 */
+		reboot_default = 0;
+
+		switch (*str) {
+		case 'w':
+			reboot_mode = 0x1234;
+			break;
+
+		case 'c':
+			reboot_mode = 0;
+			break;
+
+#ifdef CONFIG_SMP
+		case 's':
+			if (*(str + 1) == 'm' && *(str + 2) == 'p')
+				str += 2;
+
+			reboot_cpu = 0;
+			for (i = 1; isdigit(*(str + i)); i++) {
+				reboot_cpu *= 10;
+				reboot_cpu += (int)(*(str + i) - '0');
+			}
+
+			break;
+#endif /* CONFIG_SMP */
+
+		case 'b':
+		case 'a':
+		case 'k':
+		case 't':
+		case 'e':
+		case 'p':
+			reboot_type = *str;
+			break;
+
+		case 'f':
+			reboot_force = 1;
+			break;
+		}
+
+		str = strchr(str, ',');
+		if (str)
+			str++;
+		else
+			break;
+	}
+	return 1;
+}
+__setup("reboot=", reboot_setup);
+
+
 static void migrate_to_reboot_cpu(void)
 {
-	/* The boot cpu is always logical cpu 0 */
-	int reboot_cpu_id = 0;
+	int cpu = reboot_cpu;
 
 	cpu_hotplug_disable();
 
 	/* Make certain the cpu I'm about to reboot on is online */
-	if (!cpu_online(reboot_cpu_id))
-		reboot_cpu_id = cpumask_first(cpu_online_mask);
+	if (!cpu_online(cpu))
+		cpu = cpumask_first(cpu_online_mask);
 
 	/* Prevent races with other tasks migrating this task */
 	current->flags |= PF_THREAD_BOUND;
 
 	/* Make certain I only run on the appropriate processor */
-	set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));
+	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 }
 
 /**
_

Patches currently in -mm which might be from holt@sgi.com are

ipc-sysv-shared-memory-limited-to-8tib.patch
ipc-sysv-shared-memory-limited-to-8tib-fix.patch


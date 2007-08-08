From: akpm@linux-foundation.org
Subject: + pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-2x.patch added to -mm tree
Date: Tue, 07 Aug 2007 17:39:10 -0700
Message-ID: <200708080039.l780dAj2012764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53535 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759487AbXHHAkA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 20:40:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, ak@suse.de, benh@kernel.crashing.org, lenb@kernel.org, paulus@samba.org, rmk@arm.linux.org.uk


The patch titled
     PM: Fix dependencies of CONFIG_SUSPEND and CONFIG_HIBERNATION
has been added to the -mm tree.  Its filename is
     pm-fix-dependencies-of-config_suspend-and-config_hibernation-updat=
ed-2x.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: PM: Fix dependencies of CONFIG_SUSPEND and CONFIG_HIBERNATION
=46rom: Rafael J. Wysocki <rjw@sisk.pl>

Dependencies of CONFIG_SUSPEND and CONFIG_HIBERNATION introduced by com=
mit
296699de6bdc717189a331ab6bbe90e05c94db06 "Introduce CONFIG_SUSPEND for
suspend-to-Ram and standby" are incorrect, as they don't cover the fact=
s that
(1) not all architectures support suspend and (2) SMP hibernation is on=
ly
possible on X86 and PPC64 (if CONFIG_PPC64_SWSUSP is set).

Moreover, SMP suspend and hibernation are only possible if CONFIG_HOTPL=
UG is
set, because they select HOTPLUG_CPU that depends on it. =A0Also, since=
 suspend
and hibernation don't depend on EXPERIMENTAL, arrange things so that CP=
U
hotplug can be selected if it is not set.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Len Brown <lenb@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig      |    2 -
 arch/i386/Kconfig     |    3 +-
 arch/powerpc/Kconfig  |    3 +-
 arch/x86_64/Kconfig   |    2 -
 arch/x86_64/defconfig |    1=20
 include/linux/cpu.h   |    6 ++---
 kernel/cpu.c          |    4 +--
 kernel/power/Kconfig  |   43 ++++++++++++++++++++++++++++++----------
 8 files changed, 44 insertions(+), 20 deletions(-)

diff -puN arch/arm/Kconfig~pm-fix-dependencies-of-config_suspend-and-co=
nfig_hibernation-updated-2x arch/arm/Kconfig
--- a/arch/arm/Kconfig~pm-fix-dependencies-of-config_suspend-and-config=
_hibernation-updated-2x
+++ a/arch/arm/Kconfig
@@ -594,7 +594,7 @@ config NR_CPUS
=20
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL
+	depends on SMP && HOTPLUG && (EXPERIMENTAL || PM_SLEEP_SMP)
 	help
 	  Say Y here to experiment with turning CPUs off and on.  CPUs
 	  can be controlled through /sys/devices/system/cpu.
diff -puN arch/i386/Kconfig~pm-fix-dependencies-of-config_suspend-and-c=
onfig_hibernation-updated-2x arch/i386/Kconfig
--- a/arch/i386/Kconfig~pm-fix-dependencies-of-config_suspend-and-confi=
g_hibernation-updated-2x
+++ a/arch/i386/Kconfig
@@ -904,7 +904,8 @@ config PHYSICAL_ALIGN
=20
 config HOTPLUG_CPU
 	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL=
)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL && !X86_VOYAGER
+	depends on SMP && HOTPLUG && (EXPERIMENTAL || PM_SLEEP_SMP) \
+		   && !X86_VOYAGER
 	---help---
 	  Say Y here to experiment with turning CPUs off and on, and to
 	  enable suspend on SMP systems. CPUs can be controlled through
diff -puN arch/powerpc/Kconfig~pm-fix-dependencies-of-config_suspend-an=
d-config_hibernation-updated-2x arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~pm-fix-dependencies-of-config_suspend-and-co=
nfig_hibernation-updated-2x
+++ a/arch/powerpc/Kconfig
@@ -194,7 +194,8 @@ config IOMMU_VMERGE
=20
 config HOTPLUG_CPU
 	bool "Support for enabling/disabling CPUs"
-	depends on SMP && HOTPLUG && EXPERIMENTAL && (PPC_PSERIES || PPC_PMAC=
)
+	depends on SMP && HOTPLUG && (EXPERIMENTAL || PM_SLEEP_SMP) \
+		   && (PPC_PSERIES || PPC_PMAC)
 	---help---
 	  Say Y here to be able to disable and re-enable individual
 	  CPUs at runtime on SMP machines.
diff -puN arch/x86_64/Kconfig~pm-fix-dependencies-of-config_suspend-and=
-config_hibernation-updated-2x arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~pm-fix-dependencies-of-config_suspend-and-con=
fig_hibernation-updated-2x
+++ a/arch/x86_64/Kconfig
@@ -445,7 +445,7 @@ config PHYSICAL_ALIGN
=20
 config HOTPLUG_CPU
 	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL=
)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL
+	depends on SMP && HOTPLUG && (EXPERIMENTAL || PM_SLEEP_SMP)
 	help
 		Say Y here to experiment with turning CPUs off and on.  CPUs
 		can be controlled through /sys/devices/system/cpu/cpu#.
diff -puN arch/x86_64/defconfig~pm-fix-dependencies-of-config_suspend-a=
nd-config_hibernation-updated-2x arch/x86_64/defconfig
--- a/arch/x86_64/defconfig~pm-fix-dependencies-of-config_suspend-and-c=
onfig_hibernation-updated-2x
+++ a/arch/x86_64/defconfig
@@ -201,7 +201,6 @@ CONFIG_PM=3Dy
 # CONFIG_PM_DEBUG is not set
 CONFIG_HIBERNATION=3Dy
 CONFIG_PM_STD_PARTITION=3D""
-CONFIG_SUSPEND_SMP=3Dy
=20
 #
 # ACPI (Advanced Configuration and Power Interface) Support
diff -puN include/linux/cpu.h~pm-fix-dependencies-of-config_suspend-and=
-config_hibernation-updated-2x include/linux/cpu.h
--- a/include/linux/cpu.h~pm-fix-dependencies-of-config_suspend-and-con=
fig_hibernation-updated-2x
+++ a/include/linux/cpu.h
@@ -128,16 +128,16 @@ static inline void cpuhotplug_mutex_unlo
 static inline int cpu_is_offline(int cpu) { return 0; }
 #endif		/* CONFIG_HOTPLUG_CPU */
=20
-#ifdef CONFIG_SUSPEND_SMP
+#ifdef CONFIG_PM_SLEEP_SMP
 extern int suspend_cpu_hotplug;
=20
 extern int disable_nonboot_cpus(void);
 extern void enable_nonboot_cpus(void);
-#else
+#else /* !CONFIG_PM_SLEEP_SMP */
 #define suspend_cpu_hotplug	0
=20
 static inline int disable_nonboot_cpus(void) { return 0; }
 static inline void enable_nonboot_cpus(void) {}
-#endif
+#endif /* !CONFIG_PM_SLEEP_SMP */
=20
 #endif /* _LINUX_CPU_H_ */
diff -puN kernel/cpu.c~pm-fix-dependencies-of-config_suspend-and-config=
_hibernation-updated-2x kernel/cpu.c
--- a/kernel/cpu.c~pm-fix-dependencies-of-config_suspend-and-config_hib=
ernation-updated-2x
+++ a/kernel/cpu.c
@@ -273,7 +273,7 @@ int __cpuinit cpu_up(unsigned int cpu)
 	return err;
 }
=20
-#ifdef CONFIG_SUSPEND_SMP
+#ifdef CONFIG_PM_SLEEP_SMP
 static cpumask_t frozen_cpus;
=20
 int disable_nonboot_cpus(void)
@@ -334,4 +334,4 @@ void enable_nonboot_cpus(void)
 out:
 	mutex_unlock(&cpu_add_remove_lock);
 }
-#endif
+#endif /* CONFIG_PM_SLEEP_SMP */
diff -puN kernel/power/Kconfig~pm-fix-dependencies-of-config_suspend-an=
d-config_hibernation-updated-2x kernel/power/Kconfig
--- a/kernel/power/Kconfig~pm-fix-dependencies-of-config_suspend-and-co=
nfig_hibernation-updated-2x
+++ a/kernel/power/Kconfig
@@ -72,15 +72,10 @@ config PM_TRACE
 	CAUTION: this option will cause your machine's real-time clock to be
 	set to an invalid time after a resume.
=20
-config SUSPEND_SMP_POSSIBLE
-	bool
-	depends on (X86 && !X86_VOYAGER) || (PPC64 && (PPC_PSERIES || PPC_PMA=
C))
-	depends on SMP
-	default y
-
-config SUSPEND_SMP
+config PM_SLEEP_SMP
 	bool
-	depends on SUSPEND_SMP_POSSIBLE && PM_SLEEP
+	depends on SUSPEND_SMP_POSSIBLE || HIBERNATION_SMP_POSSIBLE
+	depends on PM_SLEEP
 	select HOTPLUG_CPU
 	default y
=20
@@ -89,20 +84,48 @@ config PM_SLEEP
 	depends on SUSPEND || HIBERNATION
 	default y
=20
+config SUSPEND_UP_POSSIBLE
+	bool
+	depends on (X86 && !X86_VOYAGER) || PPC || ARM || BLACKFIN || MIPS \
+		   || SUPERH || FRV
+	depends on !SMP
+	default y
+
+config SUSPEND_SMP_POSSIBLE
+	bool
+	depends on (X86 && !X86_VOYAGER) \
+		   || (PPC && (PPC_PSERIES || PPC_PMAC)) || ARM
+	depends on SMP
+	depends on HOTPLUG
+	default y
+
 config SUSPEND
 	bool "Suspend to RAM and standby"
 	depends on PM
-	depends on !SMP || SUSPEND_SMP_POSSIBLE
+	depends on SUSPEND_UP_POSSIBLE || SUSPEND_SMP_POSSIBLE
 	default y
 	---help---
 	  Allow the system to enter sleep states in which main memory is
 	  powered and thus its contents are preserved, such as the
 	  suspend-to-RAM state (i.e. the ACPI S3 state).
=20
+config HIBERNATION_UP_POSSIBLE
+	bool
+	depends on X86 || PPC64_SWSUSP || FRV || PPC32
+	depends on !SMP
+	default y
+
+config HIBERNATION_SMP_POSSIBLE
+	bool
+	depends on (X86 && !X86_VOYAGER) || PPC64_SWSUSP
+	depends on SMP
+	depends on HOTPLUG
+	default y
+
 config HIBERNATION
 	bool "Hibernation (aka 'suspend to disk')"
 	depends on PM && SWAP
-	depends on ((X86 || PPC64_SWSUSP || FRV || PPC32) && !SMP) || SUSPEND=
_SMP_POSSIBLE
+	depends on HIBERNATION_UP_POSSIBLE || HIBERNATION_SMP_POSSIBLE
 	---help---
 	  Enable the suspend to disk (STD) functionality, which is usually
 	  called "hibernation" in user interfaces.  STD checkpoints the
_

Patches currently in -mm which might be from rjw@sisk.pl are

hibernation-do-not-try-to-mark-invalid-pfns-as-nosave.patch
pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-2x=
=2Epatch
uli526x-add-suspend-and-resume-routines.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-do-not-send-signals-to-kernel-threads.patch
unexport-pm_power_off_prepare.patch
pm_trace-displays-the-wrong-time-from-the-rtc.patch
freezer-be-more-verbose.patch
freezer-use-wait-queue-instead-of-busy-looping.patch
freezer-measure-freezing-time.patch
shrink_slab-handle-bad-shrinkers.patch

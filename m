From: akpm@linux-foundation.org
Subject: + pm-move-definition-of-struct-pm_ops-to-suspendh.patch added to -mm tree
Date: Tue, 17 Jul 2007 17:03:20 -0700
Message-ID: <200707180003.l6I03KG4014526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58551 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933009AbXGRADn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 20:03:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, greg@kroah.com, lenb@kernel.org, pavel@ucw.cz


The patch titled
     PM: Move definition of struct pm_ops to suspend.h
has been added to the -mm tree.  Its filename is
     pm-move-definition-of-struct-pm_ops-to-suspendh.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: PM: Move definition of struct pm_ops to suspend.h
=46rom: Rafael J. Wysocki <rjw@sisk.pl>

Move the definition of 'struct pm_ops' and related functions from <linu=
x/pm.h>
to <linux/suspend.h> .

There are, at least, the following reasons to do that:
* 'struct pm_ops' is specifically related to suspend and not to the pow=
er
=A0 management in general.
* As long as 'struct pm_ops' is defined in <linux/pm.h>, any modificati=
on of it
=A0 causes the entire kernel to be recompiled, which is unnecessary and=
 annoying.
* Some suspend-related features are already defined in <linux/suspend.h=
>, so it
=A0 is logical to move the definition of 'struct pm_ops' into there.
* 'struct hibernation_ops', being the hibernation-related counterpart o=
f
=A0 'struct pm_ops', is defined in <linux/suspend.h> .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/common/sharpsl_pm.c             |    1=20
 arch/arm/mach-at91/pm.c                  |    3=20
 arch/arm/mach-omap1/pm.c                 |    3=20
 arch/arm/mach-omap2/pm.c                 |    9 -
 arch/arm/mach-pnx4008/pm.c               |    2=20
 arch/arm/mach-pxa/pxa25x.c               |    2=20
 arch/arm/mach-pxa/pxa27x.c               |    2=20
 arch/blackfin/mach-common/pm.c           |    2=20
 arch/powerpc/platforms/52xx/mpc52xx_pm.c |    2=20
 drivers/char/apm-emulation.c             |    2=20
 include/asm-arm/arch-pxa/pm.h            |    2=20
 include/linux/pm.h                       |   91 ----------------
 include/linux/suspend.h                  |  113 ++++++++++++++++++---
 13 files changed, 114 insertions(+), 120 deletions(-)

diff -puN arch/arm/common/sharpsl_pm.c~pm-move-definition-of-struct-pm_=
ops-to-suspendh arch/arm/common/sharpsl_pm.c
--- a/arch/arm/common/sharpsl_pm.c~pm-move-definition-of-struct-pm_ops-=
to-suspendh
+++ a/arch/arm/common/sharpsl_pm.c
@@ -24,6 +24,7 @@
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <linux/apm-emulation.h>
+#include <linux/suspend.h>
=20
 #include <asm/hardware.h>
 #include <asm/mach-types.h>
diff -puN arch/arm/mach-at91/pm.c~pm-move-definition-of-struct-pm_ops-t=
o-suspendh arch/arm/mach-at91/pm.c
--- a/arch/arm/mach-at91/pm.c~pm-move-definition-of-struct-pm_ops-to-su=
spendh
+++ a/arch/arm/mach-at91/pm.c
@@ -10,10 +10,9 @@
  * (at your option) any later version.
  */
=20
-#include <linux/pm.h>
+#include <linux/suspend.h>
 #include <linux/sched.h>
 #include <linux/proc_fs.h>
-#include <linux/pm.h>
 #include <linux/interrupt.h>
 #include <linux/sysfs.h>
 #include <linux/module.h>
diff -puN arch/arm/mach-omap1/pm.c~pm-move-definition-of-struct-pm_ops-=
to-suspendh arch/arm/mach-omap1/pm.c
--- a/arch/arm/mach-omap1/pm.c~pm-move-definition-of-struct-pm_ops-to-s=
uspendh
+++ a/arch/arm/mach-omap1/pm.c
@@ -35,10 +35,9 @@
  * 675 Mass Ave, Cambridge, MA 02139, USA.
  */
=20
-#include <linux/pm.h>
+#include <linux/suspend.h>
 #include <linux/sched.h>
 #include <linux/proc_fs.h>
-#include <linux/pm.h>
 #include <linux/interrupt.h>
 #include <linux/sysfs.h>
 #include <linux/module.h>
diff -puN arch/arm/mach-omap2/pm.c~pm-move-definition-of-struct-pm_ops-=
to-suspendh arch/arm/mach-omap2/pm.c
--- a/arch/arm/mach-omap2/pm.c~pm-move-definition-of-struct-pm_ops-to-s=
uspendh
+++ a/arch/arm/mach-omap2/pm.c
@@ -16,10 +16,9 @@
  * published by the Free Software Foundation.
  */
=20
-#include <linux/pm.h>
+#include <linux/suspend.h>
 #include <linux/sched.h>
 #include <linux/proc_fs.h>
-#include <linux/pm.h>
 #include <linux/interrupt.h>
 #include <linux/sysfs.h>
 #include <linux/module.h>
@@ -85,9 +84,6 @@ static int omap2_pm_prepare(suspend_stat
 	case PM_SUSPEND_MEM:
 		break;
=20
-	case PM_SUSPEND_DISK:
-		return -ENOTSUPP;
-
 	default:
 		return -EINVAL;
 	}
@@ -353,9 +349,6 @@ static int omap2_pm_enter(suspend_state_
 	case PM_SUSPEND_MEM:
 		ret =3D omap2_pm_suspend();
 		break;
-	case PM_SUSPEND_DISK:
-		ret =3D -ENOTSUPP;
-		break;
 	default:
 		ret =3D -EINVAL;
 	}
diff -puN arch/arm/mach-pnx4008/pm.c~pm-move-definition-of-struct-pm_op=
s-to-suspendh arch/arm/mach-pnx4008/pm.c
--- a/arch/arm/mach-pnx4008/pm.c~pm-move-definition-of-struct-pm_ops-to=
-suspendh
+++ a/arch/arm/mach-pnx4008/pm.c
@@ -15,7 +15,7 @@
 #include <linux/rtc.h>
 #include <linux/sched.h>
 #include <linux/proc_fs.h>
-#include <linux/pm.h>
+#include <linux/suspend.h>
 #include <linux/delay.h>
 #include <linux/clk.h>
=20
diff -puN arch/arm/mach-pxa/pxa25x.c~pm-move-definition-of-struct-pm_op=
s-to-suspendh arch/arm/mach-pxa/pxa25x.c
--- a/arch/arm/mach-pxa/pxa25x.c~pm-move-definition-of-struct-pm_ops-to=
-suspendh
+++ a/arch/arm/mach-pxa/pxa25x.c
@@ -20,7 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
-#include <linux/pm.h>
+#include <linux/suspend.h>
=20
 #include <asm/hardware.h>
 #include <asm/arch/irqs.h>
diff -puN arch/arm/mach-pxa/pxa27x.c~pm-move-definition-of-struct-pm_op=
s-to-suspendh arch/arm/mach-pxa/pxa27x.c
--- a/arch/arm/mach-pxa/pxa27x.c~pm-move-definition-of-struct-pm_ops-to=
-suspendh
+++ a/arch/arm/mach-pxa/pxa27x.c
@@ -14,7 +14,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/pm.h>
+#include <linux/suspend.h>
 #include <linux/platform_device.h>
=20
 #include <asm/hardware.h>
diff -puN arch/blackfin/mach-common/pm.c~pm-move-definition-of-struct-p=
m_ops-to-suspendh arch/blackfin/mach-common/pm.c
--- a/arch/blackfin/mach-common/pm.c~pm-move-definition-of-struct-pm_op=
s-to-suspendh
+++ a/arch/blackfin/mach-common/pm.c
@@ -32,7 +32,7 @@
  * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
=20
-#include <linux/pm.h>
+#include <linux/suspend.h>
 #include <linux/sched.h>
 #include <linux/proc_fs.h>
 #include <linux/io.h>
diff -puN arch/powerpc/platforms/52xx/mpc52xx_pm.c~pm-move-definition-o=
f-struct-pm_ops-to-suspendh arch/powerpc/platforms/52xx/mpc52xx_pm.c
--- a/arch/powerpc/platforms/52xx/mpc52xx_pm.c~pm-move-definition-of-st=
ruct-pm_ops-to-suspendh
+++ a/arch/powerpc/platforms/52xx/mpc52xx_pm.c
@@ -1,5 +1,5 @@
 #include <linux/init.h>
-#include <linux/pm.h>
+#include <linux/suspend.h>
 #include <linux/io.h>
 #include <asm/time.h>
 #include <asm/cacheflush.h>
diff -puN drivers/char/apm-emulation.c~pm-move-definition-of-struct-pm_=
ops-to-suspendh drivers/char/apm-emulation.c
--- a/drivers/char/apm-emulation.c~pm-move-definition-of-struct-pm_ops-=
to-suspendh
+++ a/drivers/char/apm-emulation.c
@@ -18,7 +18,7 @@
 #include <linux/apm_bios.h>
 #include <linux/capability.h>
 #include <linux/sched.h>
-#include <linux/pm.h>
+#include <linux/suspend.h>
 #include <linux/apm-emulation.h>
 #include <linux/freezer.h>
 #include <linux/device.h>
diff -puN include/asm-arm/arch-pxa/pm.h~pm-move-definition-of-struct-pm=
_ops-to-suspendh include/asm-arm/arch-pxa/pm.h
--- a/include/asm-arm/arch-pxa/pm.h~pm-move-definition-of-struct-pm_ops=
-to-suspendh
+++ a/include/asm-arm/arch-pxa/pm.h
@@ -7,5 +7,7 @@
  *
  */
=20
+#include <linux/suspend.h>
+
 extern int pxa_pm_prepare(suspend_state_t state);
 extern int pxa_pm_enter(suspend_state_t state);
diff -puN include/linux/pm.h~pm-move-definition-of-struct-pm_ops-to-sus=
pendh include/linux/pm.h
--- a/include/linux/pm.h~pm-move-definition-of-struct-pm_ops-to-suspend=
h
+++ a/include/linux/pm.h
@@ -103,97 +103,6 @@ extern void (*pm_idle)(void);
 extern void (*pm_power_off)(void);
 extern void (*pm_power_off_prepare)(void);
=20
-typedef int __bitwise suspend_state_t;
-
-#define PM_SUSPEND_ON		((__force suspend_state_t) 0)
-#define PM_SUSPEND_STANDBY	((__force suspend_state_t) 1)
-#define PM_SUSPEND_MEM		((__force suspend_state_t) 3)
-#define PM_SUSPEND_MAX		((__force suspend_state_t) 4)
-
-/**
- * struct pm_ops - Callbacks for managing platform dependent system sl=
eep
- *	states.
- *
- * @valid: Callback to determine if given system sleep state is suppor=
ted by
- *	the platform.
- *	Valid (ie. supported) states are advertised in /sys/power/state.  N=
ote
- *	that it still may be impossible to enter given system sleep state i=
f the
- *	conditions aren't right.
- *	There is the %pm_valid_only_mem function available that can be assi=
gned
- *	to this if the platform only supports mem sleep.
- *
- * @set_target: Tell the platform which system sleep state is going to=
 be
- *	entered.
- *	@set_target() is executed right prior to suspending devices.  The
- *	information conveyed to the platform code by @set_target() should b=
e
- *	disregarded by the platform as soon as @finish() is executed and if
- *	@prepare() fails.  If @set_target() fails (ie. returns nonzero),
- *	@prepare(), @enter() and @finish() will not be called by the PM cor=
e.
- *	This callback is optional.  However, if it is implemented, the argu=
ment
- *	passed to @prepare(), @enter() and @finish() is meaningless and sho=
uld
- *	be ignored.
- *
- * @prepare: Prepare the platform for entering the system sleep state =
indicated
- *	by @set_target() or represented by the argument if @set_target() is=
 not
- *	implemented.
- *	@prepare() is called right after devices have been suspended (ie. t=
he
- *	appropriate .suspend() method has been executed for each device) an=
d
- *	before the nonboot CPUs are disabled (it is executed with IRQs enab=
led).
- *	This callback is optional.  It returns 0 on success or a negative
- *	error code otherwise, in which case the system cannot enter the des=
ired
- *	sleep state (@enter() and @finish() will not be called in that case=
).
- *
- * @enter: Enter the system sleep state indicated by @set_target() or
- *	represented by the argument if @set_target() is not implemented.
- *	This callback is mandatory.  It returns 0 on success or a negative
- *	error code otherwise, in which case the system cannot enter the des=
ired
- *	sleep state.
- *
- * @finish: Called when the system has just left a sleep state, right =
after
- *	the nonboot CPUs have been enabled and before devices are resumed (=
it is
- *	executed with IRQs enabled).  If @set_target() is not implemented, =
the
- *	argument represents the sleep state being left.
- *	This callback is optional, but should be implemented by the platfor=
ms
- *	that implement @prepare().  If implemented, it is always called aft=
er
- *	@enter() (even if @enter() fails).
- */
-struct pm_ops {
-	int (*valid)(suspend_state_t state);
-	int (*set_target)(suspend_state_t state);
-	int (*prepare)(suspend_state_t state);
-	int (*enter)(suspend_state_t state);
-	int (*finish)(suspend_state_t state);
-};
-
-extern struct pm_ops *pm_ops;
-
-/**
- * pm_set_ops - set platform dependent power management ops
- * @pm_ops: The new power management operations to set.
- */
-extern void pm_set_ops(struct pm_ops *pm_ops);
-extern int pm_valid_only_mem(suspend_state_t state);
-
-/**
- * arch_suspend_disable_irqs - disable IRQs for suspend
- *
- * Disables IRQs (in the default case). This is a weak symbol in the c=
ommon
- * code and thus allows architectures to override it if more needs to =
be
- * done. Not called for suspend to disk.
- */
-extern void arch_suspend_disable_irqs(void);
-
-/**
- * arch_suspend_enable_irqs - enable IRQs after suspend
- *
- * Enables IRQs (in the default case). This is a weak symbol in the co=
mmon
- * code and thus allows architectures to override it if more needs to =
be
- * done. Not called for suspend to disk.
- */
-extern void arch_suspend_enable_irqs(void);
-
-extern int pm_suspend(suspend_state_t state);
-
 /*
  * Device power management
  */
diff -puN include/linux/suspend.h~pm-move-definition-of-struct-pm_ops-t=
o-suspendh include/linux/suspend.h
--- a/include/linux/suspend.h~pm-move-definition-of-struct-pm_ops-to-su=
spendh
+++ a/include/linux/suspend.h
@@ -1,5 +1,5 @@
-#ifndef _LINUX_SWSUSP_H
-#define _LINUX_SWSUSP_H
+#ifndef _LINUX_SUSPEND_H
+#define _LINUX_SUSPEND_H
=20
 #if defined(CONFIG_X86) || defined(CONFIG_FRV) || defined(CONFIG_PPC32=
) || defined(CONFIG_PPC64)
 #include <asm/suspend.h>
@@ -10,6 +10,105 @@
 #include <linux/pm.h>
 #include <linux/mm.h>
=20
+#if defined(CONFIG_PM) && defined(CONFIG_VT) && defined(CONFIG_VT_CONS=
OLE)
+extern int pm_prepare_console(void);
+extern void pm_restore_console(void);
+#else
+static inline int pm_prepare_console(void) { return 0; }
+static inline void pm_restore_console(void) {}
+#endif
+
+typedef int __bitwise suspend_state_t;
+
+#define PM_SUSPEND_ON		((__force suspend_state_t) 0)
+#define PM_SUSPEND_STANDBY	((__force suspend_state_t) 1)
+#define PM_SUSPEND_MEM		((__force suspend_state_t) 3)
+#define PM_SUSPEND_MAX		((__force suspend_state_t) 4)
+
+/**
+ * struct pm_ops - Callbacks for managing platform dependent system sl=
eep
+ *	states.
+ *
+ * @valid: Callback to determine if given system sleep state is suppor=
ted by
+ *	the platform.
+ *	Valid (ie. supported) states are advertised in /sys/power/state.  N=
ote
+ *	that it still may be impossible to enter given system sleep state i=
f the
+ *	conditions aren't right.
+ *	There is the %pm_valid_only_mem function available that can be assi=
gned
+ *	to this if the platform only supports mem sleep.
+ *
+ * @set_target: Tell the platform which system sleep state is going to=
 be
+ *	entered.
+ *	@set_target() is executed right prior to suspending devices.  The
+ *	information conveyed to the platform code by @set_target() should b=
e
+ *	disregarded by the platform as soon as @finish() is executed and if
+ *	@prepare() fails.  If @set_target() fails (ie. returns nonzero),
+ *	@prepare(), @enter() and @finish() will not be called by the PM cor=
e.
+ *	This callback is optional.  However, if it is implemented, the argu=
ment
+ *	passed to @prepare(), @enter() and @finish() is meaningless and sho=
uld
+ *	be ignored.
+ *
+ * @prepare: Prepare the platform for entering the system sleep state =
indicated
+ *	by @set_target() or represented by the argument if @set_target() is=
 not
+ *	implemented.
+ *	@prepare() is called right after devices have been suspended (ie. t=
he
+ *	appropriate .suspend() method has been executed for each device) an=
d
+ *	before the nonboot CPUs are disabled (it is executed with IRQs enab=
led).
+ *	This callback is optional.  It returns 0 on success or a negative
+ *	error code otherwise, in which case the system cannot enter the des=
ired
+ *	sleep state (@enter() and @finish() will not be called in that case=
).
+ *
+ * @enter: Enter the system sleep state indicated by @set_target() or
+ *	represented by the argument if @set_target() is not implemented.
+ *	This callback is mandatory.  It returns 0 on success or a negative
+ *	error code otherwise, in which case the system cannot enter the des=
ired
+ *	sleep state.
+ *
+ * @finish: Called when the system has just left a sleep state, right =
after
+ *	the nonboot CPUs have been enabled and before devices are resumed (=
it is
+ *	executed with IRQs enabled).  If @set_target() is not implemented, =
the
+ *	argument represents the sleep state being left.
+ *	This callback is optional, but should be implemented by the platfor=
ms
+ *	that implement @prepare().  If implemented, it is always called aft=
er
+ *	@enter() (even if @enter() fails).
+ */
+struct pm_ops {
+	int (*valid)(suspend_state_t state);
+	int (*set_target)(suspend_state_t state);
+	int (*prepare)(suspend_state_t state);
+	int (*enter)(suspend_state_t state);
+	int (*finish)(suspend_state_t state);
+};
+
+extern struct pm_ops *pm_ops;
+
+/**
+ * pm_set_ops - set platform dependent power management ops
+ * @pm_ops: The new power management operations to set.
+ */
+extern void pm_set_ops(struct pm_ops *pm_ops);
+extern int pm_valid_only_mem(suspend_state_t state);
+
+/**
+ * arch_suspend_disable_irqs - disable IRQs for suspend
+ *
+ * Disables IRQs (in the default case). This is a weak symbol in the c=
ommon
+ * code and thus allows architectures to override it if more needs to =
be
+ * done. Not called for suspend to disk.
+ */
+extern void arch_suspend_disable_irqs(void);
+
+/**
+ * arch_suspend_enable_irqs - enable IRQs after suspend
+ *
+ * Enables IRQs (in the default case). This is a weak symbol in the co=
mmon
+ * code and thus allows architectures to override it if more needs to =
be
+ * done. Not called for suspend to disk.
+ */
+extern void arch_suspend_enable_irqs(void);
+
+extern int pm_suspend(suspend_state_t state);
+
 /* struct pbe is used for creating lists of pages that should be resto=
red
  * atomically during the resume from disk, because the page frames the=
y have
  * occupied before the suspend are in use.
@@ -24,14 +123,6 @@ struct pbe {
 extern void drain_local_pages(void);
 extern void mark_free_pages(struct zone *zone);
=20
-#if defined(CONFIG_PM) && defined(CONFIG_VT) && defined(CONFIG_VT_CONS=
OLE)
-extern int pm_prepare_console(void);
-extern void pm_restore_console(void);
-#else
-static inline int pm_prepare_console(void) { return 0; }
-static inline void pm_restore_console(void) {}
-#endif
-
 /**
  * struct hibernation_ops - hibernation platform support
  *
@@ -127,4 +218,4 @@ static inline void register_nosave_regio
 }
 #endif
=20
-#endif /* _LINUX_SWSUSP_H */
+#endif /* _LINUX_SUSPEND_H */
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
x86_64-pm_trace-support.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-do-not-require-dev-spew-to-get-pm_debug.patch
swsusp-remove-incorrect-code-from-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
swsusp-introduce-restore-platform-operations.patch
swsusp-fix-hibernation-code-ordering.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-=
rev-2.patch
pm-reduce-code-duplication-between-mainc-and-userc-updated.patch
acpi-do-not-prepare-for-hibernation-in-acpi_shutdown.patch
pm-introduce-pm_power_off_prepare.patch
pm-optional-beeping-during-resume-from-suspend-to-ram.patch
pm-integrate-beeping-flag-with-existing-acpi_sleep-flags.patch
pm-remove-deprecated-sysfs-files.patch
pm-remove-deprecated-dpm_runtime_-routines.patch
suspend-maintainers-update.patch
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

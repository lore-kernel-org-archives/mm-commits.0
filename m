From: akpm@linux-foundation.org
Subject: + pm-rework-struct-platform_suspend_ops.patch added to -mm tree
Date: Tue, 17 Jul 2007 17:03:24 -0700
Message-ID: <200707180003.l6I03Odw014532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54075 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936432AbXGRADq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 20:03:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, greg@kroah.com, lenb@kernel.org, pavel@ucw.cz


The patch titled
     PM: Rework struct platform_suspend_ops
has been added to the -mm tree.  Its filename is
     pm-rework-struct-platform_suspend_ops.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: PM: Rework struct platform_suspend_ops
=46rom: Rafael J. Wysocki <rjw@sisk.pl>

There is no reason why the .prepare() and .finish() methods in 'struct
platform_suspend_ops' should take any arguments, since architectures do=
n't use
these methods' argument in any practically meaningful way (ie.  either =
the
target system sleep state is conveyed to the platform by .set_target(),=
 or
there is only one suspend state supported and it is indicated to the PM=
 core
by .valid(), or .prepare() and .finish() aren't defined at all).  =A0Th=
ere also
is no reason why .finish() should return any result.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap1/pm.c                 |   20 +-------
 arch/arm/mach-omap2/pm.c                 |   20 +-------
 arch/blackfin/mach-common/pm.c           |   49 ++-------------------
 arch/powerpc/platforms/52xx/mpc52xx_pm.c |    9 ---
 drivers/acpi/sleep/main.c                |    7 ---
 include/asm-arm/arch-pxa/pm.h            |    1=20
 include/linux/suspend.h                  |   13 ++---
 kernel/power/main.c                      |   12 +----
 8 files changed, 24 insertions(+), 107 deletions(-)

diff -puN arch/arm/mach-omap1/pm.c~pm-rework-struct-platform_suspend_op=
s arch/arm/mach-omap1/pm.c
--- a/arch/arm/mach-omap1/pm.c~pm-rework-struct-platform_suspend_ops
+++ a/arch/arm/mach-omap1/pm.c
@@ -613,27 +613,15 @@ static void (*saved_idle)(void) =3D NULL;
=20
 /*
  *	omap_pm_prepare - Do preliminary suspend work.
- *	@state:		suspend state we're entering.
  *
  */
-static int omap_pm_prepare(suspend_state_t state)
+static int omap_pm_prepare(void)
 {
-	int error =3D 0;
-
 	/* We cannot sleep in idle until we have resumed */
 	saved_idle =3D pm_idle;
 	pm_idle =3D NULL;
=20
-	switch (state)
-	{
-	case PM_SUSPEND_STANDBY:
-	case PM_SUSPEND_MEM:
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return error;
+	return 0;
 }
=20
=20
@@ -661,16 +649,14 @@ static int omap_pm_enter(suspend_state_t
=20
 /**
  *	omap_pm_finish - Finish up suspend sequence.
- *	@state:		State we're coming out of.
  *
  *	This is called after we wake back up (or if entering the sleep stat=
e
  *	failed).
  */
=20
-static int omap_pm_finish(suspend_state_t state)
+static void omap_pm_finish(void)
 {
 	pm_idle =3D saved_idle;
-	return 0;
 }
=20
=20
diff -puN arch/arm/mach-omap2/pm.c~pm-rework-struct-platform_suspend_op=
s arch/arm/mach-omap2/pm.c
--- a/arch/arm/mach-omap2/pm.c~pm-rework-struct-platform_suspend_ops
+++ a/arch/arm/mach-omap2/pm.c
@@ -70,25 +70,12 @@ void omap2_pm_idle(void)
 	local_irq_enable();
 }
=20
-static int omap2_pm_prepare(suspend_state_t state)
+static int omap2_pm_prepare(void)
 {
-	int error =3D 0;
-
 	/* We cannot sleep in idle until we have resumed */
 	saved_idle =3D pm_idle;
 	pm_idle =3D NULL;
-
-	switch (state)
-	{
-	case PM_SUSPEND_STANDBY:
-	case PM_SUSPEND_MEM:
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	return error;
+	return 0;
 }
=20
 #define INT0_WAKE_MASK	(OMAP_IRQ_BIT(INT_24XX_GPIO_BANK1) |	\
@@ -356,10 +343,9 @@ static int omap2_pm_enter(suspend_state_
 	return ret;
 }
=20
-static int omap2_pm_finish(suspend_state_t state)
+static void omap2_pm_finish(void)
 {
 	pm_idle =3D saved_idle;
-	return 0;
 }
=20
 static struct platform_suspend_ops omap_pm_ops =3D {
diff -puN arch/blackfin/mach-common/pm.c~pm-rework-struct-platform_susp=
end_ops arch/blackfin/mach-common/pm.c
--- a/arch/blackfin/mach-common/pm.c~pm-rework-struct-platform_suspend_=
ops
+++ a/arch/blackfin/mach-common/pm.c
@@ -89,28 +89,15 @@ void bfin_pm_suspend_standby_enter(void)
 #endif				/* CONFIG_PM_WAKEUP_GPIO_BY_SIC_IWR */
 }
=20
-
 /*
- *	bfin_pm_prepare - Do preliminary suspend work.
- *	@state:		suspend state we're entering.
+ *	bfin_pm_valid - Tell the PM core that we only support the standby s=
leep
+ *			state
+ *	@state:		suspend state we're checking.
  *
  */
-static int bfin_pm_prepare(suspend_state_t state)
+static int bfin_pm_valid(suspend_state_t state)
 {
-	int error =3D 0;
-
-	switch (state) {
-	case PM_SUSPEND_STANDBY:
-		break;
-
-	case PM_SUSPEND_MEM:
-		return -ENOTSUPP;
-
-	default:
-		return -EINVAL;
-	}
-
-	return error;
+	return (state =3D=3D PM_SUSPEND_STANDBY);
 }
=20
 /*
@@ -135,33 +122,9 @@ static int bfin_pm_enter(suspend_state_t
 	return 0;
 }
=20
-/*
- *	bfin_pm_finish - Finish up suspend sequence.
- *	@state:		State we're coming out of.
- *
- *	This is called after we wake back up (or if entering the sleep stat=
e
- *	failed).
- */
-static int bfin_pm_finish(suspend_state_t state)
-{
-	switch (state) {
-	case PM_SUSPEND_STANDBY:
-		break;
-
-	case PM_SUSPEND_MEM:
-		return -ENOTSUPP;
-
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 struct platform_suspend_ops bfin_pm_ops =3D {
-	.prepare =3D bfin_pm_prepare,
+	.valid =3D bfin_pm_valid,
 	.enter =3D bfin_pm_enter,
-	.finish =3D bfin_pm_finish,
 };
=20
 static int __init bfin_pm_init(void)
diff -puN arch/powerpc/platforms/52xx/mpc52xx_pm.c~pm-rework-struct-pla=
tform_suspend_ops arch/powerpc/platforms/52xx/mpc52xx_pm.c
--- a/arch/powerpc/platforms/52xx/mpc52xx_pm.c~pm-rework-struct-platfor=
m_suspend_ops
+++ a/arch/powerpc/platforms/52xx/mpc52xx_pm.c
@@ -57,11 +57,8 @@ int mpc52xx_set_wakeup_gpio(u8 pin, u8 l
 	return 0;
 }
=20
-int mpc52xx_pm_prepare(suspend_state_t state)
+static int mpc52xx_pm_prepare(void)
 {
-	if (state !=3D PM_SUSPEND_STANDBY)
-		return -EINVAL;
-
 	/* map the whole register space */
 	mbar =3D mpc52xx_find_and_map("mpc5200");
 	if (!mbar) {
@@ -166,15 +163,13 @@ int mpc52xx_pm_enter(suspend_state_t sta
 	return 0;
 }
=20
-int mpc52xx_pm_finish(suspend_state_t state)
+static void mpc52xx_pm_finish(void)
 {
 	/* call board resume code */
 	if (mpc52xx_suspend.board_resume_finish)
 		mpc52xx_suspend.board_resume_finish(mbar);
=20
 	iounmap(mbar);
-
-	return 0;
 }
=20
 static struct platform_suspend_ops mpc52xx_pm_ops =3D {
diff -puN drivers/acpi/sleep/main.c~pm-rework-struct-platform_suspend_o=
ps drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~pm-rework-struct-platform_suspend_ops
+++ a/drivers/acpi/sleep/main.c
@@ -61,13 +61,12 @@ static int acpi_pm_set_target(suspend_st
=20
 /**
  *	acpi_pm_prepare - Do preliminary suspend work.
- *	@pm_state: ignored
  *
  *	If necessary, set the firmware waking vector and do arch-specific
  *	nastiness to get the wakeup code to the waking vector.
  */
=20
-static int acpi_pm_prepare(suspend_state_t pm_state)
+static int acpi_pm_prepare(void)
 {
 	int error =3D acpi_sleep_prepare(acpi_target_sleep_state);
=20
@@ -137,13 +136,12 @@ static int acpi_pm_enter(suspend_state_t
=20
 /**
  *	acpi_pm_finish - Finish up suspend sequence.
- *	@pm_state: ignored
  *
  *	This is called after we wake back up (or if entering the sleep stat=
e
  *	failed).=20
  */
=20
-static int acpi_pm_finish(suspend_state_t pm_state)
+static void acpi_pm_finish(void)
 {
 	u32 acpi_state =3D acpi_target_sleep_state;
=20
@@ -159,7 +157,6 @@ static int acpi_pm_finish(suspend_state_
 		printk("Broken toshiba laptop -> kicking interrupts\n");
 		init_8259A(0);
 	}
-	return 0;
 }
=20
 int acpi_suspend(u32 acpi_state)
diff -puN include/asm-arm/arch-pxa/pm.h~pm-rework-struct-platform_suspe=
nd_ops include/asm-arm/arch-pxa/pm.h
--- a/include/asm-arm/arch-pxa/pm.h~pm-rework-struct-platform_suspend_o=
ps
+++ a/include/asm-arm/arch-pxa/pm.h
@@ -9,5 +9,4 @@
=20
 #include <linux/suspend.h>
=20
-extern int pxa_pm_prepare(suspend_state_t state);
 extern int pxa_pm_enter(suspend_state_t state);
diff -puN include/linux/suspend.h~pm-rework-struct-platform_suspend_ops=
 include/linux/suspend.h
--- a/include/linux/suspend.h~pm-rework-struct-platform_suspend_ops
+++ a/include/linux/suspend.h
@@ -45,12 +45,10 @@ typedef int __bitwise suspend_state_t;
  *	@prepare() fails.  If @set_target() fails (ie. returns nonzero),
  *	@prepare(), @enter() and @finish() will not be called by the PM cor=
e.
  *	This callback is optional.  However, if it is implemented, the argu=
ment
- *	passed to @prepare(), @enter() and @finish() is meaningless and sho=
uld
- *	be ignored.
+ *	passed to @enter() is meaningless and should be ignored.
  *
  * @prepare: Prepare the platform for entering the system sleep state =
indicated
- *	by @set_target() or represented by the argument if @set_target() is=
 not
- *	implemented.
+ *	by @set_target().
  *	@prepare() is called right after devices have been suspended (ie. t=
he
  *	appropriate .suspend() method has been executed for each device) an=
d
  *	before the nonboot CPUs are disabled (it is executed with IRQs enab=
led).
@@ -66,8 +64,7 @@ typedef int __bitwise suspend_state_t;
  *
  * @finish: Called when the system has just left a sleep state, right =
after
  *	the nonboot CPUs have been enabled and before devices are resumed (=
it is
- *	executed with IRQs enabled).  If @set_target() is not implemented, =
the
- *	argument represents the sleep state being left.
+ *	executed with IRQs enabled).
  *	This callback is optional, but should be implemented by the platfor=
ms
  *	that implement @prepare().  If implemented, it is always called aft=
er
  *	@enter() (even if @enter() fails).
@@ -75,9 +72,9 @@ typedef int __bitwise suspend_state_t;
 struct platform_suspend_ops {
 	int (*valid)(suspend_state_t state);
 	int (*set_target)(suspend_state_t state);
-	int (*prepare)(suspend_state_t state);
+	int (*prepare)(void);
 	int (*enter)(suspend_state_t state);
-	int (*finish)(suspend_state_t state);
+	void (*finish)(void);
 };
=20
 extern struct platform_suspend_ops *suspend_ops;
diff -puN kernel/power/main.c~pm-rework-struct-platform_suspend_ops ker=
nel/power/main.c
--- a/kernel/power/main.c~pm-rework-struct-platform_suspend_ops
+++ a/kernel/power/main.c
@@ -56,13 +56,6 @@ int suspend_valid_only_mem(suspend_state
 	return state =3D=3D PM_SUSPEND_MEM;
 }
=20
-
-static inline void pm_finish(suspend_state_t state)
-{
-	if (suspend_ops->finish)
-		suspend_ops->finish(state);
-}
-
 /**
  *	suspend_prepare - Do prep work before entering low-power state.
  *
@@ -169,7 +162,7 @@ int suspend_devices_and_enter(suspend_st
 		goto Resume_console;
 	}
 	if (suspend_ops->prepare) {
-		error =3D suspend_ops->prepare(state);
+		error =3D suspend_ops->prepare();
 		if (error)
 			goto Resume_devices;
 	}
@@ -178,7 +171,8 @@ int suspend_devices_and_enter(suspend_st
 		suspend_enter(state);
=20
 	enable_nonboot_cpus();
-	pm_finish(state);
+	if (suspend_ops->finish)
+		suspend_ops->finish();
  Resume_devices:
 	device_resume();
  Resume_console:
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

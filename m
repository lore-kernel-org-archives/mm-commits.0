From: akpm@linux-foundation.org
Subject: - suspend-introduce-begin-and-end-callbacks.patch removed from -mm tree
Date: Sun, 13 Jan 2008 03:33:38 -0800
Message-ID: <200801131133.m0DBXIuD009834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53070 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422AbYAMLdc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 06:33:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Suspend: Introduce begin() and end() callbacks
has been removed from the -mm tree.  Its filename was
     suspend-introduce-begin-and-end-callbacks.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: Suspend: Introduce begin() and end() callbacks
=46rom: Rafael J. Wysocki <rjw@sisk.pl>

On ACPI systems the target state set by acpi_pm_set_target() is reset b=
y
acpi_pm_finish(), but that need not be called if the suspend fails.  =A0=
All
platforms that use the .set_target() global suspend callback are affect=
ed by
analogous issues.

=46or this reason, we need an additional global suspend callback that w=
ill reset
the target state regardless of whether or not the suspend is successful=
=2E=20
=A0Also, it is reasonable to rename the .set_target() callback, since i=
t will be
used for a different purpose on ACPI systems (due to ACPI 1.0x code ord=
ering
requirements).

Introduce the global suspend callback .end() to be executed at the end =
of the
suspend sequence and rename the .set_target() global suspend callback t=
o
=2Ebegin().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-at91/pm.c                   |   17 ++++++++---
 arch/powerpc/platforms/52xx/lite5200_pm.c |   10 +++++-
 drivers/acpi/sleep/main.c                 |   22 ++++++++++++---
 include/linux/suspend.h                   |   29 ++++++++++++--------
 kernel/power/main.c                       |    9 ++++--
 5 files changed, 63 insertions(+), 24 deletions(-)

diff -puN arch/arm/mach-at91/pm.c~suspend-introduce-begin-and-end-callb=
acks arch/arm/mach-at91/pm.c
--- a/arch/arm/mach-at91/pm.c~suspend-introduce-begin-and-end-callbacks
+++ a/arch/arm/mach-at91/pm.c
@@ -52,7 +52,7 @@ static suspend_state_t target_state;
 /*
  * Called after processes are frozen, but before we shutdown devices.
  */
-static int at91_pm_set_target(suspend_state_t state)
+static int at91_pm_begin(suspend_state_t state)
 {
 	target_state =3D state;
 	return 0;
@@ -197,11 +197,20 @@ error:
 	return 0;
 }
=20
+/*
+ * Called right prior to thawing processes.
+ */
+static void at91_pm_end(void)
+{
+	target_state =3D PM_SUSPEND_ON;
+}
+
=20
 static struct platform_suspend_ops at91_pm_ops =3D{
-	.valid		=3D at91_pm_valid_state,
-	.set_target	=3D at91_pm_set_target,
-	.enter		=3D at91_pm_enter,
+	.valid	=3D at91_pm_valid_state,
+	.begin	=3D at91_pm_begin,
+	.enter	=3D at91_pm_enter,
+	.end	=3D at91_pm_end,
 };
=20
 static int __init at91_pm_init(void)
diff -puN arch/powerpc/platforms/52xx/lite5200_pm.c~suspend-introduce-b=
egin-and-end-callbacks arch/powerpc/platforms/52xx/lite5200_pm.c
--- a/arch/powerpc/platforms/52xx/lite5200_pm.c~suspend-introduce-begin=
-and-end-callbacks
+++ a/arch/powerpc/platforms/52xx/lite5200_pm.c
@@ -31,7 +31,7 @@ static int lite5200_pm_valid(suspend_sta
 	}
 }
=20
-static int lite5200_pm_set_target(suspend_state_t state)
+static int lite5200_pm_begin(suspend_state_t state)
 {
 	if (lite5200_pm_valid(state)) {
 		lite5200_pm_target_state =3D state;
@@ -208,12 +208,18 @@ static void lite5200_pm_finish(void)
 		mpc52xx_pm_finish();
 }
=20
+static void lite5200_pm_end(void)
+{
+	lite5200_pm_target_state =3D PM_SUSPEND_ON;
+}
+
 static struct platform_suspend_ops lite5200_pm_ops =3D {
 	.valid		=3D lite5200_pm_valid,
-	.set_target	=3D lite5200_pm_set_target,
+	.begin		=3D lite5200_pm_begin,
 	.prepare	=3D lite5200_pm_prepare,
 	.enter		=3D lite5200_pm_enter,
 	.finish		=3D lite5200_pm_finish,
+	.end		=3D lite5200_pm_end,
 };
=20
 int __init lite5200_pm_init(void)
diff -puN drivers/acpi/sleep/main.c~suspend-introduce-begin-and-end-cal=
lbacks drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~suspend-introduce-begin-and-end-callbac=
ks
+++ a/drivers/acpi/sleep/main.c
@@ -63,11 +63,11 @@ static u32 acpi_suspend_states[] =3D {
 static int init_8259A_after_S1;
=20
 /**
- *	acpi_pm_set_target - Set the target system sleep state to the state
+ *	acpi_pm_begin - Set the target system sleep state to the state
  *		associated with given @pm_state, if supported.
  */
=20
-static int acpi_pm_set_target(suspend_state_t pm_state)
+static int acpi_pm_begin(suspend_state_t pm_state)
 {
 	u32 acpi_state =3D acpi_suspend_states[pm_state];
 	int error =3D 0;
@@ -164,7 +164,7 @@ static int acpi_pm_enter(suspend_state_t
 }
=20
 /**
- *	acpi_pm_finish - Finish up suspend sequence.
+ *	acpi_pm_finish - Instruct the platform to leave a sleep state.
  *
  *	This is called after we wake back up (or if entering the sleep stat=
e
  *	failed).=20
@@ -190,6 +190,19 @@ static void acpi_pm_finish(void)
 #endif
 }
=20
+/**
+ *	acpi_pm_end - Finish up suspend sequence.
+ */
+
+static void acpi_pm_end(void)
+{
+	/*
+	 * This is necessary in case acpi_pm_finish() is not called during a
+	 * failing transition to a sleep state.
+	 */
+	acpi_target_sleep_state =3D ACPI_STATE_S0;
+}
+
 static int acpi_pm_state_valid(suspend_state_t pm_state)
 {
 	u32 acpi_state;
@@ -208,10 +221,11 @@ static int acpi_pm_state_valid(suspend_s
=20
 static struct platform_suspend_ops acpi_pm_ops =3D {
 	.valid =3D acpi_pm_state_valid,
-	.set_target =3D acpi_pm_set_target,
+	.begin =3D acpi_pm_begin,
 	.prepare =3D acpi_pm_prepare,
 	.enter =3D acpi_pm_enter,
 	.finish =3D acpi_pm_finish,
+	.end =3D acpi_pm_end,
 };
=20
 /*
diff -puN include/linux/suspend.h~suspend-introduce-begin-and-end-callb=
acks include/linux/suspend.h
--- a/include/linux/suspend.h~suspend-introduce-begin-and-end-callbacks
+++ a/include/linux/suspend.h
@@ -38,18 +38,16 @@ typedef int __bitwise suspend_state_t;
  *	There is the %suspend_valid_only_mem function available that can be
  *	assigned to this if the platform only supports mem sleep.
  *
- * @set_target: Tell the platform which system sleep state is going to=
 be
- *	entered.
- *	@set_target() is executed right prior to suspending devices.  The
- *	information conveyed to the platform code by @set_target() should b=
e
- *	disregarded by the platform as soon as @finish() is executed and if
- *	@prepare() fails.  If @set_target() fails (ie. returns nonzero),
+ * @begin: Initialise a transition to given system sleep state.
+ *	@begin() is executed right prior to suspending devices.  The inform=
ation
+ *	conveyed to the platform code by @begin() should be disregarded by =
it as
+ *	soon as @end() is executed.  If @begin() fails (ie. returns nonzero=
),
  *	@prepare(), @enter() and @finish() will not be called by the PM cor=
e.
  *	This callback is optional.  However, if it is implemented, the argu=
ment
- *	passed to @enter() is meaningless and should be ignored.
+ *	passed to @enter() is redundant and should be ignored.
  *
  * @prepare: Prepare the platform for entering the system sleep state =
indicated
- *	by @set_target().
+ *	by @begin().
  *	@prepare() is called right after devices have been suspended (ie. t=
he
  *	appropriate .suspend() method has been executed for each device) an=
d
  *	before the nonboot CPUs are disabled (it is executed with IRQs enab=
led).
@@ -57,8 +55,8 @@ typedef int __bitwise suspend_state_t;
  *	error code otherwise, in which case the system cannot enter the des=
ired
  *	sleep state (@enter() and @finish() will not be called in that case=
).
  *
- * @enter: Enter the system sleep state indicated by @set_target() or
- *	represented by the argument if @set_target() is not implemented.
+ * @enter: Enter the system sleep state indicated by @begin() or repre=
sented by
+ *	the argument if @begin() is not implemented.
  *	This callback is mandatory.  It returns 0 on success or a negative
  *	error code otherwise, in which case the system cannot enter the des=
ired
  *	sleep state.
@@ -69,13 +67,22 @@ typedef int __bitwise suspend_state_t;
  *	This callback is optional, but should be implemented by the platfor=
ms
  *	that implement @prepare().  If implemented, it is always called aft=
er
  *	@enter() (even if @enter() fails).
+ *
+ * @end: Called by the PM core right after resuming devices, to indica=
te to
+ *	the platform that the system has returned to the working state or
+ *	the transition to the sleep state has been aborted.
+ *	This callback is optional, but should be implemented by the platfor=
ms
+ *	that implement @begin(), but platforms implementing @begin() should
+ *	also provide a @end() which cleans up transitions aborted before
+ *	@enter().
  */
 struct platform_suspend_ops {
 	int (*valid)(suspend_state_t state);
-	int (*set_target)(suspend_state_t state);
+	int (*begin)(suspend_state_t state);
 	int (*prepare)(void);
 	int (*enter)(suspend_state_t state);
 	void (*finish)(void);
+	void (*end)(void);
 };
=20
 #ifdef CONFIG_SUSPEND
diff -puN kernel/power/main.c~suspend-introduce-begin-and-end-callbacks=
 kernel/power/main.c
--- a/kernel/power/main.c~suspend-introduce-begin-and-end-callbacks
+++ a/kernel/power/main.c
@@ -256,10 +256,10 @@ int suspend_devices_and_enter(suspend_st
 	if (!suspend_ops)
 		return -ENOSYS;
=20
-	if (suspend_ops->set_target) {
-		error =3D suspend_ops->set_target(state);
+	if (suspend_ops->begin) {
+		error =3D suspend_ops->begin(state);
 		if (error)
-			return error;
+			goto Close;
 	}
 	suspend_console();
 	error =3D device_suspend(PMSG_SUSPEND);
@@ -292,6 +292,9 @@ int suspend_devices_and_enter(suspend_st
 	device_resume();
  Resume_console:
 	resume_console();
+ Close:
+	if (suspend_ops->end)
+		suspend_ops->end();
 	return error;
 }
=20
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
pm-acquire-device-locks-on-suspend-rev-3.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes-2.patch
git-x86.patch
git-x86-vs-pm-acquire-device-locks-on-suspend-rev-3.patch
git-xfs.patch
cpufreq-initialise-default-governor-before-use.patch
page-allocator-clean-up-pcp-draining-functions.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
remove-obsolete-sys-devices-power-state-docs.patch
proc-fix-the-threaded-proc-self.patch
shrink_slab-handle-bad-shrinkers.patch

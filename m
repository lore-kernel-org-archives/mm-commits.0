From: akpm@linux-foundation.org
Subject: + hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4.patch added to -mm tree
Date: Fri, 14 Sep 2007 16:37:22 -0700
Message-ID: <200709142337.l8ENbMea029829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59775 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752680AbXINXh3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 19:37:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, pavel@ucw.cz


The patch titled
     Hibernation: Enter platform hibernation state in a consistent way
has been added to the -mm tree.  Its filename is
     hibernation-enter-platform-hibernation-state-in-a-consistent-way-r=
ev-4.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: Hibernation: Enter platform hibernation state in a consistent =
way
=46rom: Rafael J. Wysocki <rjw@sisk.pl>

Make hibernation_platform_enter() execute the enter-a-sleep-state seque=
nce
instead of the mixed shutdown-with-entering-S4 thing.

Replace the shutting down of devices done by kernel_shutdown_prepare(),=
 before
entering the ACPI S4 sleep state, with suspending them and the shutting=
 down
of sysdevs with calling device_power_down(PMSG_SUSPEND) (just like befo=
re
entering S1 or S3, but the target state is now S4).  =A0Also, disable t=
he
nonboot CPUs before entering the sleep state (S4), which generally alwa=
ys is a
good idea.

This is known to fix the "double disk spin down during hibernation" on =
some
machines, eg.  HPC nx6325 (ref.  http://lkml.org/lkml/2007/8/7/316 and =
the
following thread).  =A0Moreover, it has been reported to make
/sys/class/rtc/rtc0/wakealarm work correctly with hibernation for some =
users.=20
It also generally causes the hibernation state (ACPI S4) to be entered =
faster.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/disk.c |   61 ++++++++++++++++++++++++++++++------------
 1 files changed, 44 insertions(+), 17 deletions(-)

diff -puN kernel/power/disk.c~hibernation-enter-platform-hibernation-st=
ate-in-a-consistent-way-rev-4 kernel/power/disk.c
--- a/kernel/power/disk.c~hibernation-enter-platform-hibernation-state-=
in-a-consistent-way-rev-4
+++ a/kernel/power/disk.c
@@ -278,21 +278,48 @@ int hibernation_platform_enter(void)
 {
 	int error;
=20
-	if (hibernation_ops) {
-		kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
-		/*
-		 * We have cancelled the power transition by running
-		 * hibernation_ops->finish() before saving the image, so we
-		 * should let the firmware know that we're going to enter the
-		 * sleep state after all
-		 */
-		error =3D hibernation_ops->prepare();
-		sysdev_shutdown();
-		if (!error)
-			error =3D hibernation_ops->enter();
-	} else {
-		error =3D -ENOSYS;
+	if (!hibernation_ops)
+		return -ENOSYS;
+
+	/*
+	 * We have cancelled the power transition by running
+	 * hibernation_ops->finish() before saving the image, so we should le=
t
+	 * the firmware know that we're going to enter the sleep state after =
all
+	 */
+	error =3D hibernation_ops->start();
+	if (error)
+		return error;
+
+	suspend_console();
+	error =3D device_suspend(PMSG_SUSPEND);
+	if (error)
+		return error;
+
+	error =3D hibernation_ops->prepare();
+	if (error)
+		goto Resume_devices;
+
+	error =3D disable_nonboot_cpus();
+	if (error)
+		goto Finish;
+
+	local_irq_disable();
+	error =3D device_power_down(PMSG_SUSPEND);
+	if (!error) {
+		hibernation_ops->enter();
+		/* We should never get here */
+		while (1);
 	}
+	local_irq_enable();
+
+	/*
+	 * We don't need to reenable the nonboot CPUs or resume consoles, sin=
ce
+	 * the system is going to be halted anyway.
+	 */
+ Finish:
+	hibernation_ops->finish();
+ Resume_devices:
+	device_resume();
 	return error;
 }
=20
@@ -309,14 +336,14 @@ static void power_down(void)
 	case HIBERNATION_TEST:
 	case HIBERNATION_TESTPROC:
 		break;
-	case HIBERNATION_SHUTDOWN:
-		kernel_power_off();
-		break;
 	case HIBERNATION_REBOOT:
 		kernel_restart(NULL);
 		break;
 	case HIBERNATION_PLATFORM:
 		hibernation_platform_enter();
+	case HIBERNATION_SHUTDOWN:
+		kernel_power_off();
+		break;
 	}
 	kernel_halt();
 	/*
_

Patches currently in -mm which might be from rjw@sisk.pl are

fix-failure-to-resume-from-initrds.patch
hibernation-make-sure-that-acpi-is-enabled-in-acpi_hibernation_finish.p=
atch
acpi-clean-up-acpi_enter_sleep_state_prep.patch
git-netdev-all.patch
make-kernel-power-maincsuspend_enter-static.patch
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
freezer-introduce-freezer-firendly-waiting-macros-fix.patch
freezer-do-not-send-signals-to-kernel-threads.patch
unexport-pm_power_off_prepare.patch
pm_trace-displays-the-wrong-time-from-the-rtc.patch
freezer-be-more-verbose.patch
freezer-use-wait-queue-instead-of-busy-looping.patch
freezer-measure-freezing-time.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-opti=
on.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-opti=
on-update.patch
s2ram-kill-old-debugging-junk.patch
hibernation-arbitrary-boot-kernel-support-generic-code-rev-2.patch
hibernation-arbitrary-boot-kernel-support-on-x86_64-rev-2.patch
hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2.patch
hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64=
=2Epatch
hibernation-check-if-acpi-is-enabled-during-restore-in-the-right-place.=
patch
hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4.=
patch
pnp-make-pnpacpi_suspend-handle-errors.patch
shrink_slab-handle-bad-shrinkers.patch

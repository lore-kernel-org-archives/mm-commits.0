From: akpm@linux-foundation.org
Subject: - hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:41:31 -0700
Message-ID: <200710190341.l9J3fVjO012825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42566 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966493AbXJSDz4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Hibernation: Enter platform hibernation state in a consistent way
has been removed from the -mm tree.  Its filename was
     hibernation-enter-platform-hibernation-state-in-a-consistent-way-r=
ev-4.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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

 kernel/power/disk.c |   63 ++++++++++++++++++++++++++++++------------
 1 file changed, 46 insertions(+), 17 deletions(-)

diff -puN kernel/power/disk.c~hibernation-enter-platform-hibernation-st=
ate-in-a-consistent-way-rev-4 kernel/power/disk.c
--- a/kernel/power/disk.c~hibernation-enter-platform-hibernation-state-=
in-a-consistent-way-rev-4
+++ a/kernel/power/disk.c
@@ -278,21 +278,50 @@ int hibernation_platform_enter(void)
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
+		goto Resume_console;
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
+ Resume_console:
+	resume_console();
 	return error;
 }
=20
@@ -309,14 +338,14 @@ static void power_down(void)
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

origin.patch
git-acpi.patch
revert-x86_64-mm-cpa-einval.patch
shrink_slab-handle-bad-shrinkers.patch

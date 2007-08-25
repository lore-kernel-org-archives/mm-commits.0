From: akpm@linux-foundation.org
Subject: - add-suspend-related-notifications-for-cpu-hotplug-statistics.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:21:49 -0700
Message-ID: <200708250321.l7P3Lnop027892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51632 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535AbXHYDWO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 23:22:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Add suspend-related notifications for CPU hotplug
has been removed from the -mm tree.  Its filename was
     add-suspend-related-notifications-for-cpu-hotplug-statistics.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: Add suspend-related notifications for CPU hotplug
=46rom: Rafael J. Wysocki <rjw@sisk.pl>

Since nonboot CPUs are now disabled after tasks and devices have been
frozen and the CPU hotplug infrastructure is used for this purpose, we =
need
special CPU hotplug notifications that will help the CPU-hotplug-aware
subsystems distinguish normal CPU hotplug events=A0from CPU hotplug eve=
nts
related to a system-wide suspend or resume operation in progress.  This
patch introduces such notifications and causes them to be used during
suspend and resume transitions.  It also changes all of the
CPU-hotplug-aware subsystems to take these notifications into considera=
tion
(for now they are handled in the same way as the corresponding "normal"
ones).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/statistic.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN lib/statistic.c~add-suspend-related-notifications-for-cpu-hot=
plug-statistics lib/statistic.c
--- a/lib/statistic.c~add-suspend-related-notifications-for-cpu-hotplug=
-statistics
+++ a/lib/statistic.c
@@ -296,6 +296,7 @@ static int _statistic_hotcpu(struct stat
 		return NOTIFY_OK;
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		size =3D disc->size(stat);
 		dst =3D percpu_populate(stat->data, size, GFP_KERNEL, cpu);
 		if (!dst)
@@ -303,7 +304,9 @@ static int _statistic_hotcpu(struct stat
 		disc->reset(stat, dst);
 		break;
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		local_irq_save(flags);
 		dst =3D percpu_ptr(stat->data, smp_processor_id());
 		src =3D percpu_ptr(stat->data, cpu);
_

Patches currently in -mm which might be from rjw@sisk.pl are

pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-3x=
=2Epatch
git-acpi.patch
hibernation-make-sure-that-acpi-is-enabled-in-acpi_hibernation_finish.p=
atch
acpi-clean-up-acpi_enter_sleep_state_prep.patch
uli526x-add-suspend-and-resume-routines.patch
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
pnp-make-pnpacpi_suspend-handle-errors.patch
shrink_slab-handle-bad-shrinkers.patch

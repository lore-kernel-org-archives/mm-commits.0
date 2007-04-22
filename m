From: akpm@linux-foundation.org
Subject: + add-suspend-related-notifications-for-cpu-hotplug-statistics.patch added to -mm tree
Date: Sat, 21 Apr 2007 20:10:22 -0700
Message-ID: <200704220310.l3M3AMh4018422@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932192AbXDVDK1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Apr 2007 23:10:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl


The patch titled
     Add suspend-related notifications for CPU hotplug
has been added to the -mm tree.  Its filename is
     add-suspend-related-notifications-for-cpu-hotplug-statistics.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

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

fix-refrigerator-vs-thaw_process-race.patch
swsusp-use-inline-functions-for-changing-page-flags.patch
swsusp-do-not-use-page-flags.patch
mm-remove-unused-page-flags.patch
swsusp-fix-error-paths-in-snapshot_open.patch
swsusp-use-gfp_kernel-for-creating-basic-data-structures.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
power-management-force-pm_opsvalid-callback-to-be.patch
freezer-remove-pf_nofreeze-from-handle_initrd.patch
swsusp-use-rbtree-for-tracking-allocated-swap.patch
freezer-fix-racy-usage-of-try_to_freeze-in-kswapd.patch
remove-software_suspend.patch
power-management-change-sys-power-disk-display.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patc=
h
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
fix-pf_nofreeze-and-freezeable-race.patch
freezer-document-task_lock-in-thaw_process.patch
add-suspend-related-notifications-for-cpu-hotplug.patch
microcode-use-suspend-related-cpu-hotplug-notifications.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch

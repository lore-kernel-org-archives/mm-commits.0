From: akpm@linux-foundation.org
Subject: + pm-make-suspend_ops-static.patch added to -mm tree
Date: Tue, 17 Jul 2007 17:03:28 -0700
Message-ID: <200707180003.l6I03SWQ014538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56938 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761915AbXGRADl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 20:03:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, pavel@ucw.cz


The patch titled
     PM: Make suspend_ops static
has been added to the -mm tree.  Its filename is
     pm-make-suspend_ops-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: PM: Make suspend_ops static
=46rom: Rafael J. Wysocki <rjw@sisk.pl>

The variable suspend_ops representing the set of global platform-specif=
ic
suspend-related operations, used by the PM core, need not be exported o=
utside
of kernel/power/main.c .  =A0Make it static.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/suspend.h |    2 --
 kernel/power/main.c     |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN include/linux/suspend.h~pm-make-suspend_ops-static include/li=
nux/suspend.h
--- a/include/linux/suspend.h~pm-make-suspend_ops-static
+++ a/include/linux/suspend.h
@@ -77,8 +77,6 @@ struct platform_suspend_ops {
 	void (*finish)(void);
 };
=20
-extern struct platform_suspend_ops *suspend_ops;
-
 #ifdef CONFIG_PM
 /**
  * suspend_set_ops - set platform dependent suspend operations
diff -puN kernel/power/main.c~pm-make-suspend_ops-static kernel/power/m=
ain.c
--- a/kernel/power/main.c~pm-make-suspend_ops-static
+++ a/kernel/power/main.c
@@ -30,7 +30,7 @@ BLOCKING_NOTIFIER_HEAD(pm_chain_head);
=20
 DEFINE_MUTEX(pm_mutex);
=20
-struct platform_suspend_ops *suspend_ops;
+static struct platform_suspend_ops *suspend_ops;
=20
 /**
  *	suspend_set_ops - Set the global suspend method table.
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

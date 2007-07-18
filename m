From: akpm@linux-foundation.org
Subject: + pm-rename-hibernation_ops-to-platform_hibernation_ops.patch added to -mm tree
Date: Tue, 17 Jul 2007 17:03:32 -0700
Message-ID: <200707180003.l6I03W0D014544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54664 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935165AbXGRADw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 20:03:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, greg@kroah.com, lenb@kernel.org, pavel@ucw.cz


The patch titled
     PM: Rename hibernation_ops to platform_hibernation_ops
has been added to the -mm tree.  Its filename is
     pm-rename-hibernation_ops-to-platform_hibernation_ops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PM: Rename hibernation_ops to platform_hibernation_ops
From: Rafael J. Wysocki <rjw@sisk.pl>

Rename 'struct hibernation_ops' to 'struct platform_hibernation_ops' in
analogy with 'struct platform_suspend_ops'.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/main.c |    2 +-
 include/linux/suspend.h   |    8 ++++----
 kernel/power/disk.c       |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/acpi/sleep/main.c~pm-rename-hibernation_ops-to-platform_hibernation_ops drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~pm-rename-hibernation_ops-to-platform_hibernation_ops
+++ a/drivers/acpi/sleep/main.c
@@ -251,7 +251,7 @@ static void acpi_hibernation_restore_cle
 	acpi_hw_enable_all_runtime_gpes();
 }
 
-static struct hibernation_ops acpi_hibernation_ops = {
+static struct platform_hibernation_ops acpi_hibernation_ops = {
 	.start = acpi_hibernation_start,
 	.pre_snapshot = acpi_hibernation_prepare,
 	.finish = acpi_hibernation_finish,
diff -puN include/linux/suspend.h~pm-rename-hibernation_ops-to-platform_hibernation_ops include/linux/suspend.h
--- a/include/linux/suspend.h~pm-rename-hibernation_ops-to-platform_hibernation_ops
+++ a/include/linux/suspend.h
@@ -126,7 +126,7 @@ extern void drain_local_pages(void);
 extern void mark_free_pages(struct zone *zone);
 
 /**
- * struct hibernation_ops - hibernation platform support
+ * struct platform_hibernation_ops - hibernation platform support
  *
  * The methods in this structure allow a platform to override the default
  * mechanism of shutting down the machine during a hibernation transition.
@@ -163,7 +163,7 @@ extern void mark_free_pages(struct zone 
  *	Called right after the nonboot CPUs have been enabled and before
  *	thawing devices (runs with IRQs on).
  */
-struct hibernation_ops {
+struct platform_hibernation_ops {
 	int (*start)(void);
 	int (*pre_snapshot)(void);
 	void (*finish)(void);
@@ -190,14 +190,14 @@ extern void swsusp_set_page_free(struct 
 extern void swsusp_unset_page_free(struct page *);
 extern unsigned long get_safe_page(gfp_t gfp_mask);
 
-extern void hibernation_set_ops(struct hibernation_ops *ops);
+extern void hibernation_set_ops(struct platform_hibernation_ops *ops);
 extern int hibernate(void);
 #else /* CONFIG_SOFTWARE_SUSPEND */
 static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
 static inline void swsusp_set_page_free(struct page *p) {}
 static inline void swsusp_unset_page_free(struct page *p) {}
 
-static inline void hibernation_set_ops(struct hibernation_ops *ops) {}
+static inline void hibernation_set_ops(struct platform_hibernation_ops *ops) {}
 static inline int hibernate(void) { return -ENOSYS; }
 #endif /* CONFIG_SOFTWARE_SUSPEND */
 
diff -puN kernel/power/disk.c~pm-rename-hibernation_ops-to-platform_hibernation_ops kernel/power/disk.c
--- a/kernel/power/disk.c~pm-rename-hibernation_ops-to-platform_hibernation_ops
+++ a/kernel/power/disk.c
@@ -45,14 +45,14 @@ enum {
 
 static int hibernation_mode = HIBERNATION_SHUTDOWN;
 
-static struct hibernation_ops *hibernation_ops;
+static struct platform_hibernation_ops *hibernation_ops;
 
 /**
  * hibernation_set_ops - set the global hibernate operations
  * @ops: the hibernation operations to use in subsequent hibernation transitions
  */
 
-void hibernation_set_ops(struct hibernation_ops *ops)
+void hibernation_set_ops(struct platform_hibernation_ops *ops)
 {
 	if (ops && !(ops->start && ops->pre_snapshot && ops->finish
 	    && ops->prepare && ops->enter && ops->pre_restore
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
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
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

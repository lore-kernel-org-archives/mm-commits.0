From: akpm@linux-foundation.org
Subject: + mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix.patch added to -mm tree
Date: Wed, 07 Jul 2010 14:36:16 -0700
Message-ID: <201007072136.o67LaGUv027942__1554.11573728106$1278538606$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757457Ab0GGVg1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jul 2010 17:36:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, david-b@pacbell.net, linux-mmc@vger.kernel.org, maximlevitsky@gmail.com, randy.dunlap@oracle.com, stern@rowland.harvard.edu


The patch titled
     mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix
has been added to the -mm tree.  Its filename is
     mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix CONFIG_PM-n linkage, small cleanups

Cc: <linux-mmc@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c  |    7 +++----
 include/linux/mmc/host.h |    4 ++++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff -puN drivers/mmc/core/core.c~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix
+++ a/drivers/mmc/core/core.c
@@ -1316,11 +1316,12 @@ int mmc_resume_host(struct mmc_host *hos
 
 	return err;
 }
+EXPORT_SYMBOL(mmc_resume_host);
 
 /* Do the card removal on suspend if card is assumed removeable
  * Do that in pm notifier while userspace isn't yet frozen, so we will be able
-   to sync the card.
-*/
+ * to sync the card.
+ */
 int mmc_pm_notify(struct notifier_block *notify_block,
 					unsigned long mode, void *unused)
 {
@@ -1348,8 +1349,6 @@ int mmc_pm_notify(struct notifier_block 
 	return 0;
 }
 
-EXPORT_SYMBOL(mmc_resume_host);
-
 #endif
 
 static int __init mmc_init(void)
diff -puN include/linux/mmc/host.h~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix include/linux/mmc/host.h
--- a/include/linux/mmc/host.h~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix
+++ a/include/linux/mmc/host.h
@@ -258,8 +258,12 @@ int mmc_card_can_sleep(struct mmc_host *
 int mmc_host_enable(struct mmc_host *host);
 int mmc_host_disable(struct mmc_host *host);
 int mmc_host_lazy_disable(struct mmc_host *host);
+#ifdef CONFIG_PM
 int mmc_pm_notify(struct notifier_block *notify_block, unsigned long mode,
 		  void *unused);
+#else
+#define mmc_pm_notify NULL
+#endif
 
 static inline void mmc_set_disable_delay(struct mmc_host *host,
 					 unsigned int disable_delay)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ipc-semc-bugfix-for-semop-not-reporting-successful-operation.patch
mm-vmap-area-cache-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-ed5aa19b93da2c094b6647762774a8022e4e1d6c.patch
revert-9652e31db6d841e291531547b3f4f12b5aeb42a9.patch
revert-fdc8302019d9bc10729cd3e8d348571e833388aa.patch
revert-324d76561842e551051e2a897b958b0539f6867b.patch
revert-e92e80797e7eaaf2a9bbd586c63f7c6bd3177276.patch
revert-d04ab5241f301bdcad2f6beb0ecd326bd82100a7.patch
revert-3ab7269a6058c136795ce9417f7051a0edde60db.patch
revert-4624469822455b4accc886557f6c997ccdd59066.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
acpi-fix-bogus-preemption-logic-fix.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
gcc-46-btrfs-clean-up-unused-variables-bugs-fix.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
arch-um-drivers-remove-duplicate-structure-field-initialization.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation-checkpatch-fixes.patch
vmscan-simplify-shrink_inactive_list-checkpatch-fixes.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages-checkpatch-fixes.patch
oom-dont-try-to-kill-oom_unkillable-child-checkpatch-fixes.patch
oom-move-badness-declaration-into-oomh.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update-checkpatch-fixes.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix.patch
mmc-add-jz4740-mmc-driver-checkpatch-fixes.patch
mmc-add-jz4740-mmc-driver-fix.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
drivers-video-via-via-gpioc-fix-warning.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
lib-bugc-make-warn-implementation-match-the-kernel-panicc-one-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch


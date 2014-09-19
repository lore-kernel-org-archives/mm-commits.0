From: akpm@linux-foundation.org
Subject: + rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
 added to -mm tree
Date: Fri, 19 Sep 2014 16:08:30 -0700
Message-ID: <541cb76e.2hYXyLwI5755sdy+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaISXIc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Sep 2014 19:08:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, joshc@codeaurora.org, sboyd@codeaurora.org, svarbanov@mm-sol.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes

WARNING: Statements terminations use 1 semicolon
#159: FILE: drivers/rtc/rtc-pm8xxx.c:143:
+		ctrl_reg |= regs->alarm_en;;

WARNING: Statements terminations use 1 semicolon
#313: FILE: drivers/rtc/rtc-pm8xxx.c:348:
+	ctrl_reg &= ~regs->alarm_en;;

WARNING: DT compatible string "qcom,pm8941-rtc" appears un-documented -- check ./Documentation/devicetree/bindings/
#414: FILE: drivers/rtc/rtc-pm8xxx.c:435:
+	{ .compatible = "qcom,pm8941-rtc", .data = &pm8941_regs },

total: 0 errors, 3 warnings, 418 lines checked

./patches/rtc-pm8xxx-rework-to-support-pm8941-rtc.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Josh Cartwright <joshc@codeaurora.org>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pm8xxx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-pm8xxx.c~rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes drivers/rtc/rtc-pm8xxx.c
--- a/drivers/rtc/rtc-pm8xxx.c~rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes
+++ a/drivers/rtc/rtc-pm8xxx.c
@@ -140,7 +140,7 @@ static int pm8xxx_rtc_set_time(struct de
 	}
 
 	if (alarm_enabled) {
-		ctrl_reg |= regs->alarm_en;;
+		ctrl_reg |= regs->alarm_en;
 		rc = regmap_write(rtc_dd->regmap, regs->ctrl, ctrl_reg);
 		if (rc) {
 			dev_err(dev, "Write to RTC control register failed\n");
@@ -345,7 +345,7 @@ static irqreturn_t pm8xxx_alarm_trigger(
 		goto rtc_alarm_handled;
 	}
 
-	ctrl_reg &= ~regs->alarm_en;;
+	ctrl_reg &= ~regs->alarm_en;
 
 	rc = regmap_write(rtc_dd->regmap, regs->alarm_ctrl, ctrl_reg);
 	if (rc) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
nilfs2-fix-data-loss-with-mmap-fix.patch
fs-notify-groupc-make-fsnotify_final_destroy_group-static.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private-fix.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes.patch
mm-slab_commonc-suppress-warning.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3-fix.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch
include-linux-migrateh-remove-migratepage-define.patch
mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path-fix.patch
mm-introduce-common-page-state-for-ballooned-memory-fix.patch
mm-balloon_compaction-use-common-page-ballooning-fix.patch
introduce-dump_vma-fix.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes.patch
mm-mmapc-clean-up-config_debug_vm_rb-checks.patch
mm-introduce-vm_bug_on_mm-checkpatch-fixes.patch
mm-debugc-use-pr_emerg.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
zram-zram-memory-size-limitation-fix.patch
zram-zram-memory-size-limitation-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
acct-eliminate-compile-warning-fix.patch
checkpatch-fix-spello.patch
rtc-rk808-add-rtc-driver-for-rk808-fix.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-checkpatch-fixes.patch
rtc-max77686-use-ffs-to-calculate-tm_wday-fix.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10-fix.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
init-resolve-shadow-warnings-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
lib-string_helpers-introduce-string_escape_mem-fix.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix-2.patch
watchdog-control-hard-lockup-detection-default-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch


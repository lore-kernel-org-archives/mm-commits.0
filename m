From: akpm@linux-foundation.org
Subject: [folded-merged]
 rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 29 Oct 2014 14:46:13 -0700
Message-ID: <54516025.XdEnczCcpvX2ztDp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbaJ2VqM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Oct 2014 17:46:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, joshc@codeaurora.org, sboyd@codeaurora.org, svarbanov@mm-sol.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch

This patch was dropped because it was folded into rtc-pm8xxx-rework-to-support-pm8941-rtc.patch

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

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-fix.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
sysctl-terminate-strings-also-on-r-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
arch-x86-vdso-vmac-fix-build-with-older-gcc.patch
arch-x86-include-asm-io_apich-fix-build.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch


From: akpm@linux-foundation.org
Subject: + pm-rework-struct-platform_suspend_ops-fixup.patch added to -mm tree
Date: Mon, 15 Oct 2007 14:16:38 -0700
Message-ID: <200710152116.l9FLGce8025436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60225 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751677AbXJOVRq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 17:17:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, domen.puncer@telargo.com, jfannin@gmail.com, lenb@kernel.org, paulus@samba.org, pavel@ucw.cz


The patch titled
     PM: Rework struct platform_suspend_ops fixup
has been added to the -mm tree.  Its filename is
     pm-rework-struct-platform_suspend_ops-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PM: Rework struct platform_suspend_ops fixup
From: Rafael J. Wysocki <rjw@sisk.pl>

A recently merged powerpc update has overlapped with the changes introduced by
the following patches:

pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch

As a result, mpc5200 and lite5200 need to be modified to follow the reworked
suspend core.

Thanks to Joseph Fannin <jfannin@gmail.com> for reporting the problem and
helping to fix it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Joseph Fannin <jfannin@gmail.com>
Cc: Domen Puncer <domen.puncer@telargo.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/52xx/lite5200_pm.c |   33 +++++++++++++-------
 arch/powerpc/platforms/52xx/mpc52xx_pm.c  |    4 +-
 include/asm-powerpc/mpc52xx.h             |    6 ++-
 3 files changed, 28 insertions(+), 15 deletions(-)

diff -puN arch/powerpc/platforms/52xx/lite5200_pm.c~pm-rework-struct-platform_suspend_ops-fixup arch/powerpc/platforms/52xx/lite5200_pm.c
--- a/arch/powerpc/platforms/52xx/lite5200_pm.c~pm-rework-struct-platform_suspend_ops-fixup
+++ a/arch/powerpc/platforms/52xx/lite5200_pm.c
@@ -1,5 +1,5 @@
 #include <linux/init.h>
-#include <linux/pm.h>
+#include <linux/suspend.h>
 #include <asm/io.h>
 #include <asm/time.h>
 #include <asm/mpc52xx.h>
@@ -18,6 +18,8 @@ static void __iomem *sram;
 static const int sram_size = 0x4000;	/* 16 kBytes */
 static void __iomem *mbar;
 
+static suspend_state_t lite5200_pm_target_state;
+
 static int lite5200_pm_valid(suspend_state_t state)
 {
 	switch (state) {
@@ -29,13 +31,22 @@ static int lite5200_pm_valid(suspend_sta
 	}
 }
 
-static int lite5200_pm_prepare(suspend_state_t state)
+static int lite5200_pm_set_target(suspend_state_t state)
+{
+	if (lite5200_pm_valid(state)) {
+		lite5200_pm_target_state = state;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static int lite5200_pm_prepare(void)
 {
 	/* deep sleep? let mpc52xx code handle that */
-	if (state == PM_SUSPEND_STANDBY)
-		return mpc52xx_pm_prepare(state);
+	if (lite5200_pm_target_state == PM_SUSPEND_STANDBY)
+		return mpc52xx_pm_prepare();
 
-	if (state != PM_SUSPEND_MEM)
+	if (lite5200_pm_target_state != PM_SUSPEND_MEM)
 		return -EINVAL;
 
 	/* map registers */
@@ -190,17 +201,17 @@ static int lite5200_pm_enter(suspend_sta
 	return 0;
 }
 
-static int lite5200_pm_finish(suspend_state_t state)
+static void lite5200_pm_finish(void)
 {
 	/* deep sleep? let mpc52xx code handle that */
-	if (state == PM_SUSPEND_STANDBY) {
-		return mpc52xx_pm_finish(state);
+	if (lite5200_pm_target_state == PM_SUSPEND_STANDBY) {
+		mpc52xx_pm_finish();
 	}
-	return 0;
 }
 
-static struct pm_ops lite5200_pm_ops = {
+static struct platform_suspend_ops lite5200_pm_ops = {
 	.valid		= lite5200_pm_valid,
+	.set_target	= lite5200_pm_set_target,
 	.prepare	= lite5200_pm_prepare,
 	.enter		= lite5200_pm_enter,
 	.finish		= lite5200_pm_finish,
@@ -208,6 +219,6 @@ static struct pm_ops lite5200_pm_ops = {
 
 int __init lite5200_pm_init(void)
 {
-	pm_set_ops(&lite5200_pm_ops);
+	suspend_set_ops(&lite5200_pm_ops);
 	return 0;
 }
diff -puN arch/powerpc/platforms/52xx/mpc52xx_pm.c~pm-rework-struct-platform_suspend_ops-fixup arch/powerpc/platforms/52xx/mpc52xx_pm.c
--- a/arch/powerpc/platforms/52xx/mpc52xx_pm.c~pm-rework-struct-platform_suspend_ops-fixup
+++ a/arch/powerpc/platforms/52xx/mpc52xx_pm.c
@@ -57,7 +57,7 @@ int mpc52xx_set_wakeup_gpio(u8 pin, u8 l
 	return 0;
 }
 
-static int mpc52xx_pm_prepare(void)
+int mpc52xx_pm_prepare(void)
 {
 	/* map the whole register space */
 	mbar = mpc52xx_find_and_map("mpc5200");
@@ -163,7 +163,7 @@ int mpc52xx_pm_enter(suspend_state_t sta
 	return 0;
 }
 
-static void mpc52xx_pm_finish(void)
+void mpc52xx_pm_finish(void)
 {
 	/* call board resume code */
 	if (mpc52xx_suspend.board_resume_finish)
diff -puN include/asm-powerpc/mpc52xx.h~pm-rework-struct-platform_suspend_ops-fixup include/asm-powerpc/mpc52xx.h
--- a/include/asm-powerpc/mpc52xx.h~pm-rework-struct-platform_suspend_ops-fixup
+++ a/include/asm-powerpc/mpc52xx.h
@@ -18,6 +18,8 @@
 #include <asm/prom.h>
 #endif /* __ASSEMBLY__ */
 
+#include <linux/suspend.h>
+
 
 /* ======================================================================== */
 /* Structures mapping of some unit register set                             */
@@ -267,9 +269,9 @@ extern int mpc52xx_set_wakeup_gpio(u8 pi
 extern int __init lite5200_pm_init(void);
 
 /* lite5200 calls mpc5200 suspend functions, so here they are */
-extern int mpc52xx_pm_prepare(suspend_state_t);
+extern int mpc52xx_pm_prepare(void);
 extern int mpc52xx_pm_enter(suspend_state_t);
-extern int mpc52xx_pm_finish(suspend_state_t);
+extern void mpc52xx_pm_finish(void);
 extern char saved_sram[0x4000]; /* reuse buffer from mpc52xx suspend */
 #endif
 #endif /* CONFIG_PM */
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
revert-x86_64-mm-cpa-einval.patch
make-kernel-power-maincsuspend_enter-static.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-rework-struct-platform_suspend_ops-fixup.patch
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
freezer-measure-freezing-time.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
s2ram-kill-old-debugging-junk.patch
hibernation-arbitrary-boot-kernel-support-generic-code-rev-2.patch
hibernation-arbitrary-boot-kernel-support-on-x86_64-rev-2.patch
hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2.patch
hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64.patch
hibernation-check-if-acpi-is-enabled-during-restore-in-the-right-place.patch
hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4.patch
hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4-fix.patch
pnp-make-pnpacpi_suspend-handle-errors.patch
shrink_slab-handle-bad-shrinkers.patch

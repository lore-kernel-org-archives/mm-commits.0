From: akpm@osdl.org
Subject: + sky2-fix-msi-related-resume-breakage.patch added to -mm tree
Date: Mon, 29 Jan 2007 18:29:32 -0800
Message-ID: <200701300229.l0U2TW0W006908@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38630 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932874AbXA3C3g (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 21:29:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de


The patch titled
     sky2: fix MSI related resume breakage
has been added to the -mm tree.  Its filename is
     sky2-fix-msi-related-resume-breakage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sky2: fix MSI related resume breakage
From: Thomas Gleixner <tglx@linutronix.de>

commmit 44ade178249fe53d055fd92113eaa271e06acddd breaks sane
MSI/ACPI/BIOS combinations. It's impossible to keep broken and sane
MSI/ACPI/BIOSes happy at the same time.

Revert the patch and disable MSI for sky2 when CONFIG_PM is enabled.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/sky2.c |   29 +++++------------------------
 1 file changed, 5 insertions(+), 24 deletions(-)

diff -puN drivers/net/sky2.c~sky2-fix-msi-related-resume-breakage drivers/net/sky2.c
--- a/drivers/net/sky2.c~sky2-fix-msi-related-resume-breakage
+++ a/drivers/net/sky2.c
@@ -91,7 +91,11 @@ static int copybreak __read_mostly = 128
 module_param(copybreak, int, 0);
 MODULE_PARM_DESC(copybreak, "Receive copy threshold");
 
+#ifdef CONFIG_PM
+static int disable_msi = 1;
+#else
 static int disable_msi = 0;
+#endif
 module_param(disable_msi, int, 0);
 MODULE_PARM_DESC(disable_msi, "Disable Message Signaled Interrupt (MSI)");
 
@@ -3601,6 +3605,7 @@ static int sky2_suspend(struct pci_dev *
 	sky2_write32(hw, B0_IMSK, 0);
 	pci_save_state(pdev);
 	sky2_set_power_state(hw, pstate);
+
 	return 0;
 }
 
@@ -3640,28 +3645,6 @@ out:
 	return err;
 }
 
-/* BIOS resume runs after device (it's a bug in PM)
- * as a temporary workaround on suspend/resume leave MSI disabled
- */
-static int sky2_suspend_late(struct pci_dev *pdev, pm_message_t state)
-{
-	struct sky2_hw *hw = pci_get_drvdata(pdev);
-
-	free_irq(pdev->irq, hw);
-	if (hw->msi) {
-		pci_disable_msi(pdev);
-		hw->msi = 0;
-	}
-	return 0;
-}
-
-static int sky2_resume_early(struct pci_dev *pdev)
-{
-	struct sky2_hw *hw = pci_get_drvdata(pdev);
-	struct net_device *dev = hw->dev[0];
-
-	return request_irq(pdev->irq, sky2_intr, IRQF_SHARED, dev->name, hw);
-}
 #endif
 
 static struct pci_driver sky2_driver = {
@@ -3672,8 +3655,6 @@ static struct pci_driver sky2_driver = {
 #ifdef CONFIG_PM
 	.suspend = sky2_suspend,
 	.resume = sky2_resume,
-	.suspend_late = sky2_suspend_late,
-	.resume_early = sky2_resume_early,
 #endif
 };
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

sky2-fix-msi-related-resume-breakage.patch
bugfixes-pci-devices-get-assigned-redundant-irqs.patch
git-block.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
add-irq-flag-to-disable-balancing-for-an-interrupt.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch
hz-free-ntp.patch
uninline-jiffiesh-functions.patch
fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
fix-timeout-overflow-with-jiffies.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
i386-remove-useless-code-in-tscc.patch
simplify-the-registration-of-clocksources.patch
x86-rewrite-smp-tsc-sync-code.patch
clocksource-replace-is_continuous-by-a-flag-field.patch
clocksource-replace-is_continuous-by-a-flag-field-fix.patch
clocksource-fixup-is_continous-changes-on-arm.patch
clocksource-fixup-is_continous-changes-on-avr32.patch
clocksource-fixup-is_continous-changes-on-s390.patch
clocksource-fixup-is_continous-changes-on-mips.patch
clocksource-remove-the-update-callback.patch
clocksource-add-verification-watchdog-helper.patch
mark-tsc-on-geodelx-reliable.patch
uninline-irq_enter.patch
fix-cascade-lookup-of-next_timer_interrupt.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-fix-missing-include-for-up.patch
acpi-keep-track-of-timer-broadcasting.patch
allow-early-access-to-the-power-management-timer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-add-core-functionality.patch
tick-management-core-functionality.patch
tick-management-broadcast-functionality.patch
tick-management-dyntick--highres-functionality.patch
tick-management-dyntick--highres-functionality-fix.patch
tick-management-dyntick--highres-functionality-fix-2.patch
clockevents-i383-drivers.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-for-dyntick.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
hrtimers-add-high-resolution-timer-support.patch
hrtimers-prevent-possible-itimer-dos.patch
add-debugging-feature-proc-timer_stat.patch
add-debugging-feature-proc-timer_list.patch
add-sysrq-q-to-print-timer_list-debug-info.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-hpet-fixup-clocksource-changes.patch
time-x86_64-tsc-fixup-clocksource-changes.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch

From: akpm@linux-foundation.org
Subject: + mmc-add-jz4740-mmc-driver-checkpatch-fixes.patch added to -mm tree
Date: Wed, 30 Jun 2010 13:55:42 -0700
Message-ID: <201006302055.o5UKtg6H025863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753416Ab0F3Uzt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jun 2010 16:55:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, lars@metafoo.de, matt@console-pimps.org


The patch titled
     mmc-add-jz4740-mmc-driver-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mmc-add-jz4740-mmc-driver-checkpatch-fixes.patch

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
Subject: mmc-add-jz4740-mmc-driver-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#269: FILE: drivers/mmc/host/jz4740_mmc.c:220:
+			timeout = jz4740_mmc_wait_irq(host, JZ_MMC_IRQ_TXFIFO_WR_REQ);

WARNING: line over 80 characters
#287: FILE: drivers/mmc/host/jz4740_mmc.c:238:
+			timeout = jz4740_mmc_wait_irq(host, JZ_MMC_IRQ_TXFIFO_WR_REQ);

WARNING: line over 80 characters
#348: FILE: drivers/mmc/host/jz4740_mmc.c:299:
+			timeout = jz4740_mmc_wait_irq(host, JZ_MMC_IRQ_RXFIFO_RD_REQ);

WARNING: line over 80 characters
#368: FILE: drivers/mmc/host/jz4740_mmc.c:319:
+			timeout = jz4740_mmc_wait_irq(host, JZ_MMC_IRQ_RXFIFO_RD_REQ);

WARNING: line over 80 characters
#383: FILE: drivers/mmc/host/jz4740_mmc.c:334:
+		/* This can go away once MIPS implements flush_kernel_dcache_page */

WARNING: line over 80 characters
#436: FILE: drivers/mmc/host/jz4740_mmc.c:387:
+			cmd->resp[i] |= readw(host->base + JZ_REG_MMC_RESP_FIFO) << 8;

WARNING: suspect code indent for conditional statements (8, 12)
#560: FILE: drivers/mmc/host/jz4740_mmc.c:511:
+	if (test_and_clear_bit(0, &host->waiting)) {
+	    del_timer(&host->timeout_timer);

WARNING: line over 80 characters
#720: FILE: drivers/mmc/host/jz4740_mmc.c:671:
+		ret = gpio_request(pdata->gpio_card_detect, "MMC detect change");

WARNING: line over 80 characters
#722: FILE: drivers/mmc/host/jz4740_mmc.c:673:
+			dev_err(&pdev->dev, "Failed to request detect change gpio\n");

WARNING: line over 80 characters
#731: FILE: drivers/mmc/host/jz4740_mmc.c:682:
+			dev_err(&pdev->dev, "Failed to request read only gpio: %d\n", ret);

WARNING: line over 80 characters
#740: FILE: drivers/mmc/host/jz4740_mmc.c:691:
+			dev_err(&pdev->dev, "Failed to request power gpio: %d\n", ret);

WARNING: line over 80 characters
#743: FILE: drivers/mmc/host/jz4740_mmc.c:694:
+		gpio_direction_output(pdata->gpio_power, pdata->power_active_low);

WARNING: line over 80 characters
#829: FILE: drivers/mmc/host/jz4740_mmc.c:780:
+	host->base = ioremap_nocache(host->mem->start, resource_size(host->mem));

WARNING: line over 80 characters
#870: FILE: drivers/mmc/host/jz4740_mmc.c:821:
+		dev_warn(&pdev->dev, "Failed to get irq for card detect gpio\n");

WARNING: line over 80 characters
#878: FILE: drivers/mmc/host/jz4740_mmc.c:829:
+			dev_err(&pdev->dev, "Failed to request card detect irq");

WARNING: line over 80 characters
#894: FILE: drivers/mmc/host/jz4740_mmc.c:845:
+	/* It is not that important when it times out, it just needs to timeout. */

total: 0 errors, 16 warnings, 1005 lines checked

./patches/mmc-add-jz4740-mmc-driver.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Matt Fleming <matt@console-pimps.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/jz4740_mmc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/mmc/host/jz4740_mmc.c~mmc-add-jz4740-mmc-driver-checkpatch-fixes drivers/mmc/host/jz4740_mmc.c
--- a/drivers/mmc/host/jz4740_mmc.c~mmc-add-jz4740-mmc-driver-checkpatch-fixes
+++ a/drivers/mmc/host/jz4740_mmc.c
@@ -509,16 +509,16 @@ static irqreturn_t jz_mmc_irq(int irq, v
 		goto handled;
 
 	if (test_and_clear_bit(0, &host->waiting)) {
-	    del_timer(&host->timeout_timer);
+		del_timer(&host->timeout_timer);
 
-	    status = readl(host->base + JZ_REG_MMC_STATUS);
+		status = readl(host->base + JZ_REG_MMC_STATUS);
 
-	    if (status & JZ_MMC_STATUS_TIMEOUT_RES) {
+		if (status & JZ_MMC_STATUS_TIMEOUT_RES) {
 			host->cmd->error = -ETIMEDOUT;
 		} else if (status & JZ_MMC_STATUS_CRC_RES_ERR) {
 			host->cmd->error = -EIO;
 		} else if (status & (JZ_MMC_STATUS_CRC_READ_ERROR |
-			    JZ_MMC_STATUS_CRC_WRITE_ERROR)) {
+				JZ_MMC_STATUS_CRC_WRITE_ERROR)) {
 			host->cmd->data->error = -EIO;
 		} else if (status & (JZ_MMC_STATUS_CRC_READ_ERROR |
 				JZ_MMC_STATUS_CRC_WRITE_ERROR)) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-gpio-is-platform-neutral.patch
fs-fcntlc-kill_fasync_rcu-fa_lock-must-be-irq-safe.patch
ipc-semc-bugfix-for-semop-not-reporting-successful-operation.patch
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
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu.patch
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
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
mm-vmap-area-cache-fix.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
radix-tree-implement-function-radix_tree_range_tag_if_tagged-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update-checkpatch-fixes.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
mmc-add-jz4740-mmc-driver-checkpatch-fixes.patch
mmc-add-jz4740-mmc-driver-fix.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
drivers-video-via-via-gpioc-fix-warning.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
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


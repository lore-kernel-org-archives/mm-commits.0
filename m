From: akpm@linux-foundation.org
Subject: [to-be-updated] omap_hsmmc-add-debugfs-entry-host-registers.patch removed from -mm tree
Date: Wed, 29 Jul 2009 13:48:59 -0700
Message-ID: <200907292048.n6TKmxfE026127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754176AbZG2Utp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 16:49:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ext-denis.2.karpov@nokia.com, adrian.hunter@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gma


The patch titled
     omap_hsmmc: add debugfs entry (host registers)
has been removed from the -mm tree.  Its filename was
     omap_hsmmc-add-debugfs-entry-host-registers.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omap_hsmmc: add debugfs entry (host registers)
From: Denis Karpov <ext-denis.2.karpov@nokia.com>

Adds <debugfs_root>/kernel/debug/mmc<N>/regs entry, contents show
registers' state and some driver internal state variables.

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |   57 ++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-add-debugfs-entry-host-registers drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-add-debugfs-entry-host-registers
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -17,6 +17,8 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
@@ -974,6 +976,59 @@ static struct mmc_host_ops mmc_omap_ops 
 	/* NYET -- enable_sdio_irq */
 };
 
+#ifdef CONFIG_DEBUG_FS
+
+static int mmc_regs_show(struct seq_file *s, void *data)
+{
+	struct mmc_host *mmc = s->private;
+	struct mmc_omap_host *host = mmc_priv(mmc);
+
+	seq_printf(s, "mmc%d regs:\n", mmc->index);
+
+	seq_printf(s, "SYSCONFIG:\t0x%08x\n",
+			OMAP_HSMMC_READ(host->base, SYSCONFIG));
+	seq_printf(s, "CON:\t\t0x%08x\n",
+			OMAP_HSMMC_READ(host->base, CON));
+	seq_printf(s, "HCTL:\t\t0x%08x\n",
+			OMAP_HSMMC_READ(host->base, HCTL));
+	seq_printf(s, "SYSCTL:\t\t0x%08x\n",
+			OMAP_HSMMC_READ(host->base, SYSCTL));
+	seq_printf(s, "IE:\t\t0x%08x\n",
+			OMAP_HSMMC_READ(host->base, IE));
+	seq_printf(s, "ISE:\t\t0x%08x\n",
+			OMAP_HSMMC_READ(host->base, ISE));
+	seq_printf(s, "CAPA:\t\t0x%08x\n",
+			OMAP_HSMMC_READ(host->base, CAPA));
+	return 0;
+}
+
+static int mmc_regs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mmc_regs_show, inode->i_private);
+}
+
+static const struct file_operations mmc_regs_fops = {
+	.open           = mmc_regs_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = single_release,
+};
+
+static void omap_mmc_debugfs(struct mmc_host *mmc)
+{
+	if (mmc->debugfs_root)
+		debugfs_create_file("regs", S_IRUSR, mmc->debugfs_root,
+			mmc, &mmc_regs_fops);
+}
+
+#else
+
+static void omap_mmc_debugfs(struct mmc_host *mmc)
+{
+}
+
+#endif
+
 static int __init omap_mmc_probe(struct platform_device *pdev)
 {
 	struct omap_mmc_platform_data *pdata = pdev->dev.platform_data;
@@ -1157,6 +1212,8 @@ static int __init omap_mmc_probe(struct 
 			goto err_cover_switch;
 	}
 
+	omap_mmc_debugfs(mmc);
+
 	return 0;
 
 err_cover_switch:
_

Patches currently in -mm which might be from ext-denis.2.karpov@nokia.com are

omap_hsmmc-add-debugfs-entry-host-registers.patch
omap_hsmmc-make-use-of-new-enable-disable-interface.patch
arm-omap-mmc-twl4030-add-context-loss-counter-support.patch
omap_hsmmc-keep-track-of-power-mode.patch
omap_hsmmc-context-save-restore-support.patch
omap_hsmmc-set-open-drain-bit-correctly.patch
omap_hsmmc-ensure-workqueues-are-empty-before-suspend.patch
omap_hsmmc-fix-scatter-gather-list-sanity-checking.patch
omap_hsmmc-make-use-of-new-mmc_cap_nonremovable-host-capability.patch
omap_hsmmc-support-for-deeper-power-saving-states.patch
arm-omap-mmc-twl4030-add-regulator-sleep-wake-function.patch
omap_hsmmc-put-mmc-regulator-to-sleep.patch
omap_hsmmc-add-mmc-card-sleep-and-awake-support.patch
omap_hsmmc-fix-null-pointer-dereference.patch
omap_hsmmc-cleanup-macro-usage.patch
omap_hsmmc-clear-interrupt-status-after-init-sequence.patch
omap_hsmmc-cater-for-weird-cmd6-behaviour.patch
omap_hsmmc-prevent-races-with-irq-handler.patch
omap_hsmmc-pass-host-capabilities-for-sd-only-and-mmc-only.patch
omap_hsmmc-code-refactoring.patch
omap_hsmmc-protect-the-card-when-the-cover-is-open.patch
omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired.patch
omap_hsmmc-set-a-large-data-timeout-for-commands-with-busy-signal.patch
arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch


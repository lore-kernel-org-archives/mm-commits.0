From: akpm@linux-foundation.org
Subject: [merged] s3cmci-add-debugfs-support-for-examining-driver-and-hardware-state.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:38:58 -0700
Message-ID: <200910051838.n95Icwf0018043__3280.63527490503$1254768070$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754649AbZJESjr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:39:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@simtec.co.uk, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     s3cmci: add debugfs support for examining driver and hardware state
has been removed from the -mm tree.  Its filename was
     s3cmci-add-debugfs-support-for-examining-driver-and-hardware-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s3cmci: add debugfs support for examining driver and hardware state
From: Ben Dooks <ben@simtec.co.uk>

Export driver state and hardware register state via debugfs entries
created under a directory formed from dev_name() on the probed device when
CONFIG_DEBUG_FS is set.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/s3cmci.c |  126 ++++++++++++++++++++++++++++++++++++
 drivers/mmc/host/s3cmci.h |    6 +
 2 files changed, 132 insertions(+)

diff -puN drivers/mmc/host/s3cmci.c~s3cmci-add-debugfs-support-for-examining-driver-and-hardware-state drivers/mmc/host/s3cmci.c
--- a/drivers/mmc/host/s3cmci.c~s3cmci-add-debugfs-support-for-examining-driver-and-hardware-state
+++ a/drivers/mmc/host/s3cmci.c
@@ -17,6 +17,8 @@
 #include <linux/mmc/host.h>
 #include <linux/platform_device.h>
 #include <linux/cpufreq.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
 #include <linux/gpio.h>
 #include <linux/irq.h>
 #include <linux/io.h>
@@ -1244,6 +1246,127 @@ static inline void s3cmci_cpufreq_deregi
 #endif
 
 
+#ifdef CONFIG_DEBUG_FS
+
+static int s3cmci_state_show(struct seq_file *seq, void *v)
+{
+	struct s3cmci_host *host = seq->private;
+
+	seq_printf(seq, "Register base = 0x%08x\n", (u32)host->base);
+	seq_printf(seq, "Clock rate = %ld\n", host->clk_rate);
+	seq_printf(seq, "Prescale = %d\n", host->prescaler);
+	seq_printf(seq, "is2440 = %d\n", host->is2440);
+	seq_printf(seq, "IRQ = %d\n", host->irq);
+	seq_printf(seq, "CD IRQ = %d\n", host->irq_cd);
+	seq_printf(seq, "Do DMA = %d\n", host->dodma);
+	seq_printf(seq, "SDIIMSK at %d\n", host->sdiimsk);
+	seq_printf(seq, "SDIDATA at %d\n", host->sdidata);
+
+	return 0;
+}
+
+static int s3cmci_state_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, s3cmci_state_show, inode->i_private);
+}
+
+static const struct file_operations s3cmci_fops_state = {
+	.owner		= THIS_MODULE,
+	.open		= s3cmci_state_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+#define DBG_REG(_r) { .addr = S3C2410_SDI##_r, .name = #_r }
+
+struct s3cmci_reg {
+	unsigned short	addr;
+	unsigned char	*name;
+} debug_regs[] = {
+	DBG_REG(CON),
+	DBG_REG(PRE),
+	DBG_REG(CMDARG),
+	DBG_REG(CMDCON),
+	DBG_REG(CMDSTAT),
+	DBG_REG(RSP0),
+	DBG_REG(RSP1),
+	DBG_REG(RSP2),
+	DBG_REG(RSP3),
+	DBG_REG(TIMER),
+	DBG_REG(BSIZE),
+	DBG_REG(DCON),
+	DBG_REG(DCNT),
+	DBG_REG(DSTA),
+	DBG_REG(FSTA),
+	{}
+};
+
+static int s3cmci_regs_show(struct seq_file *seq, void *v)
+{
+	struct s3cmci_host *host = seq->private;
+	struct s3cmci_reg *rptr = debug_regs;
+
+	for (; rptr->name; rptr++)
+		seq_printf(seq, "SDI%s\t=0x%08x\n", rptr->name,
+			   readl(host->base + rptr->addr));
+
+	seq_printf(seq, "SDIIMSK\t=0x%08x\n", readl(host->base + host->sdiimsk));
+
+	return 0;
+}
+
+static int s3cmci_regs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, s3cmci_regs_show, inode->i_private);
+}
+
+static const struct file_operations s3cmci_fops_regs = {
+	.owner		= THIS_MODULE,
+	.open		= s3cmci_regs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static void s3cmci_debugfs_attach(struct s3cmci_host *host)
+{
+	struct device *dev = &host->pdev->dev;
+
+	host->debug_root = debugfs_create_dir(dev_name(dev), NULL);
+	if (IS_ERR(host->debug_root)) {
+		dev_err(dev, "failed to create debugfs root\n");
+		return;
+	}
+
+	host->debug_state = debugfs_create_file("state", 0444,
+						host->debug_root, host,
+						&s3cmci_fops_state);
+
+	if (IS_ERR(host->debug_state))
+		dev_err(dev, "failed to create debug state file\n");
+
+	host->debug_regs = debugfs_create_file("regs", 0444,
+					       host->debug_root, host,
+					       &s3cmci_fops_regs);
+
+	if (IS_ERR(host->debug_regs))
+		dev_err(dev, "failed to create debug regs file\n");
+}
+
+static void s3cmci_debugfs_remove(struct s3cmci_host *host)
+{
+	debugfs_remove(host->debug_regs);
+	debugfs_remove(host->debug_state);
+	debugfs_remove(host->debug_root);
+}
+
+#else
+static inline void s3cmci_debugfs_attach(struct s3cmci_host *host) { }
+static inline void s3cmci_debugfs_remove(struct s3cmci_host *host) { }
+
+#endif /* CONFIG_DEBUG_FS */
+
 static int __devinit s3cmci_probe(struct platform_device *pdev)
 {
 	struct s3cmci_host *host;
@@ -1435,6 +1558,8 @@ static int __devinit s3cmci_probe(struct
 		goto free_cpufreq;
 	}
 
+	s3cmci_debugfs_attach(host);
+
 	platform_set_drvdata(pdev, mmc);
 	dev_info(&pdev->dev, "initialisation done.\n");
 
@@ -1489,6 +1614,7 @@ static void s3cmci_shutdown(struct platf
 	if (host->irq_cd >= 0)
 		free_irq(host->irq_cd, host);
 
+	s3cmci_debugfs_remove(host);
 	s3cmci_cpufreq_deregister(host);
 	mmc_remove_host(mmc);
 	clk_disable(host->clk);
diff -puN drivers/mmc/host/s3cmci.h~s3cmci-add-debugfs-support-for-examining-driver-and-hardware-state drivers/mmc/host/s3cmci.h
--- a/drivers/mmc/host/s3cmci.h~s3cmci-add-debugfs-support-for-examining-driver-and-hardware-state
+++ a/drivers/mmc/host/s3cmci.h
@@ -68,6 +68,12 @@ struct s3cmci_host {
 	unsigned int		ccnt, dcnt;
 	struct tasklet_struct	pio_tasklet;
 
+#ifdef CONFIG_DEBUG_FS
+	struct dentry		*debug_root;
+	struct dentry		*debug_state;
+	struct dentry		*debug_regs;
+#endif
+
 #ifdef CONFIG_CPU_FREQ
 	struct notifier_block	freq_transition;
 #endif
_

Patches currently in -mm which might be from ben@simtec.co.uk are

gpiolib-add-names-file-in-gpio-chip-sysfs.patch


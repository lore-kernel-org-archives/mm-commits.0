From: akpm@linux-foundation.org
Subject: - edac-add-e752x-parameter-for-sysbus_parity-selection.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:41 -0700
Message-ID: <200804300548.m3U5mfw9029900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758704AbYD3FtQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:49:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ptyser@xes-inc.com, alan@lxorguk.ukuu.org.uk, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac: add e752x parameter for sysbus_parity selection
has been removed from the -mm tree.  Its filename was
     edac-add-e752x-parameter-for-sysbus_parity-selection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: add e752x parameter for sysbus_parity selection
From: Peter Tyser <ptyser@xes-inc.com>

Add a module parameter "sysbus_parity" to allow forcing system bus parity
error checking on or off.  Also add support to automatically disable system
bus parity errors for processors which do not support it.

If the sysbus_parity parameter is specified, sysbus parity detection will be
forced on or off.  If it is not specified, the driver will attempt to look at
the CPU identifier string and determine if the CPU supports system bus parity.
 A blacklist was used instead of a whitelist so that system bus parity would
be enabled by default and to minimize the chances of breaking things for those
people already using the driver which for some reason have a processor that
does not have a valid CPU identifier string.

[akpm@linux-foundation.org: coding-style fixes]
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/e752x_edac.c |   40 +++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff -puN drivers/edac/e752x_edac.c~edac-add-e752x-parameter-for-sysbus_parity-selection drivers/edac/e752x_edac.c
--- a/drivers/edac/e752x_edac.c~edac-add-e752x-parameter-for-sysbus_parity-selection
+++ a/drivers/edac/e752x_edac.c
@@ -29,6 +29,7 @@
 #define EDAC_MOD_STR	"e752x_edac"
 
 static int force_function_unhide;
+static int sysbus_parity = -1;
 
 static struct edac_pci_ctl_info *e752x_pci;
 
@@ -1049,6 +1050,37 @@ fail:
 	return 1;
 }
 
+/* Setup system bus parity mask register.
+ * Sysbus parity supported on:
+ *   e7320/e7520/e7525 + Xeon
+ *   i3100 + Xeon/Celeron
+ * Sysbus parity not supported on:
+ *   i3100 + Pentium M/Celeron M/Core Duo/Core2 Duo
+ */
+static void e752x_init_sysbus_parity_mask(struct e752x_pvt *pvt)
+{
+	char *cpu_id = cpu_data(0).x86_model_id;
+	struct pci_dev *dev = pvt->dev_d0f1;
+	int enable = 1;
+
+	/* Allow module paramter override, else see if CPU supports parity */
+	if (sysbus_parity != -1) {
+		enable = sysbus_parity;
+	} else if (cpu_id[0] &&
+		   ((strstr(cpu_id, "Pentium") && strstr(cpu_id, " M ")) ||
+		    (strstr(cpu_id, "Celeron") && strstr(cpu_id, " M ")) ||
+		    (strstr(cpu_id, "Core") && strstr(cpu_id, "Duo")))) {
+		e752x_printk(KERN_INFO, "System Bus Parity not "
+			     "supported by CPU, disabling\n");
+		enable = 0;
+	}
+
+	if (enable)
+		pci_write_config_word(dev, E752X_SYSBUS_ERRMASK, 0x0000);
+	else
+		pci_write_config_word(dev, E752X_SYSBUS_ERRMASK, 0x0309);
+}
+
 static void e752x_init_error_reporting_regs(struct e752x_pvt *pvt)
 {
 	struct pci_dev *dev;
@@ -1062,7 +1094,9 @@ static void e752x_init_error_reporting_r
 		pci_write_config_byte(dev, E752X_HI_ERRMASK, 0x00);
 		pci_write_config_byte(dev, E752X_HI_SMICMD, 0x00);
 	}
-	pci_write_config_word(dev, E752X_SYSBUS_ERRMASK, 0x00);
+
+	e752x_init_sysbus_parity_mask(pvt);
+
 	pci_write_config_word(dev, E752X_SYSBUS_SMICMD, 0x00);
 	pci_write_config_byte(dev, E752X_BUF_ERRMASK, 0x00);
 	pci_write_config_byte(dev, E752X_BUF_SMICMD, 0x00);
@@ -1291,3 +1325,7 @@ MODULE_PARM_DESC(force_function_unhide, 
 		 " 1=force unhide and hope BIOS doesn't fight driver for Dev0:Fun1 access");
 module_param(edac_op_state, int, 0444);
 MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
+
+module_param(sysbus_parity, int, 0444);
+MODULE_PARM_DESC(sysbus_parity, "0=disable system bus parity checking,"
+		" 1=enable system bus parity checking, default=auto-detect");
_

Patches currently in -mm which might be from ptyser@xes-inc.com are

origin.patch


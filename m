From: akpm@linux-foundation.org
Subject: - drivers-edac-mod-pci-poll-names.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:05:58 -0700
Message-ID: <200707192005.l6JK5wLO020092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51520 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762098AbXGSURO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:17:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djiang@mvista.com, dougthompson@xmissin.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: mod PCI poll names
has been removed from the -mm tree.  Its filename was
     drivers-edac-mod-pci-poll-names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: mod PCI poll names
From: Dave Jiang <djiang@mvista.com>

Fixup poll values for MC and PCI.
Also make mc function names unique to mc.

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Douglas Thompson <dougthompson@xmissin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h      |    7 --
 drivers/edac/edac_mc.c        |   21 ++++----
 drivers/edac/edac_mc_sysfs.c  |   76 ++++++++++++++++++--------------
 drivers/edac/edac_module.h    |    7 ++
 drivers/edac/edac_pci.c       |   21 ++------
 drivers/edac/edac_pci_sysfs.c |   56 ++++++++++++++++++-----
 6 files changed, 111 insertions(+), 77 deletions(-)

diff -puN drivers/edac/edac_core.h~drivers-edac-mod-pci-poll-names drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~drivers-edac-mod-pci-poll-names
+++ a/drivers/edac/edac_core.h
@@ -646,13 +646,6 @@ struct edac_pci_ctl_info {
 
 	int pci_idx;
 
-	/* Per instance controls for this edac_device */
-	int check_parity_error;	/* boolean for checking parity errs */
-	int log_parity_error;	/* boolean for logging parity errs */
-	int panic_on_pe;	/* boolean for panic'ing on a PE */
-	unsigned poll_msec;	/* number of milliseconds to poll interval */
-	unsigned long delay;	/* number of jiffies for poll_msec */
-
 	struct sysdev_class *edac_class;	/* pointer to class */
 
 	/* the internal state of this controller instance */
diff -puN drivers/edac/edac_mc.c~drivers-edac-mod-pci-poll-names drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~drivers-edac-mod-pci-poll-names
+++ a/drivers/edac/edac_mc.c
@@ -263,7 +263,8 @@ static void edac_mc_workq_function(void 
 	mutex_unlock(&mem_ctls_mutex);
 
 	/* Reschedule */
-	queue_delayed_work(edac_workqueue, &mci->work, edac_mc_get_poll_msec());
+	queue_delayed_work(edac_workqueue, &mci->work,
+			msecs_to_jiffies(edac_mc_get_poll_msec()));
 }
 
 /*
@@ -611,7 +612,7 @@ void edac_mc_handle_ce(struct mem_ctl_in
 		return;
 	}
 
-	if (edac_get_log_ce())
+	if (edac_mc_get_log_ce())
 		/* FIXME - put in DIMM location */
 		edac_mc_printk(mci, KERN_WARNING,
 			"CE page 0x%lx, offset 0x%lx, grain %d, syndrome "
@@ -646,7 +647,7 @@ EXPORT_SYMBOL_GPL(edac_mc_handle_ce);
 
 void edac_mc_handle_ce_no_info(struct mem_ctl_info *mci, const char *msg)
 {
-	if (edac_get_log_ce())
+	if (edac_mc_get_log_ce())
 		edac_mc_printk(mci, KERN_WARNING,
 			"CE - no information available: %s\n", msg);
 
@@ -690,14 +691,14 @@ void edac_mc_handle_ue(struct mem_ctl_in
 		pos += chars;
 	}
 
-	if (edac_get_log_ue())
+	if (edac_mc_get_log_ue())
 		edac_mc_printk(mci, KERN_EMERG,
 			"UE page 0x%lx, offset 0x%lx, grain %d, row %d, "
 			"labels \"%s\": %s\n", page_frame_number,
 			offset_in_page, mci->csrows[row].grain, row, labels,
 			msg);
 
-	if (edac_get_panic_on_ue())
+	if (edac_mc_get_panic_on_ue())
 		panic("EDAC MC%d: UE page 0x%lx, offset 0x%lx, grain %d, "
 			"row %d, labels \"%s\": %s\n", mci->mc_idx,
 			page_frame_number, offset_in_page,
@@ -710,10 +711,10 @@ EXPORT_SYMBOL_GPL(edac_mc_handle_ue);
 
 void edac_mc_handle_ue_no_info(struct mem_ctl_info *mci, const char *msg)
 {
-	if (edac_get_panic_on_ue())
+	if (edac_mc_get_panic_on_ue())
 		panic("EDAC MC%d: Uncorrected Error", mci->mc_idx);
 
-	if (edac_get_log_ue())
+	if (edac_mc_get_log_ue())
 		edac_mc_printk(mci, KERN_WARNING,
 			"UE - no information available: %s\n", msg);
 	mci->ue_noinfo_count++;
@@ -776,13 +777,13 @@ void edac_mc_handle_fbd_ue(struct mem_ct
 	chars = snprintf(pos, len + 1, "-%s",
 			 mci->csrows[csrow].channels[channelb].label);
 
-	if (edac_get_log_ue())
+	if (edac_mc_get_log_ue())
 		edac_mc_printk(mci, KERN_EMERG,
 			"UE row %d, channel-a= %d channel-b= %d "
 			"labels \"%s\": %s\n", csrow, channela, channelb,
 			labels, msg);
 
-	if (edac_get_panic_on_ue())
+	if (edac_mc_get_panic_on_ue())
 		panic("UE row %d, channel-a= %d channel-b= %d "
 				"labels \"%s\": %s\n", csrow, channela,
 				channelb, labels, msg);
@@ -817,7 +818,7 @@ void edac_mc_handle_fbd_ce(struct mem_ct
 		return;
 	}
 
-	if (edac_get_log_ce())
+	if (edac_mc_get_log_ce())
 		/* FIXME - put in DIMM location */
 		edac_mc_printk(mci, KERN_WARNING,
 			"CE row %d, channel %d, label \"%s\": %s\n",
diff -puN drivers/edac/edac_mc_sysfs.c~drivers-edac-mod-pci-poll-names drivers/edac/edac_mc_sysfs.c
--- a/drivers/edac/edac_mc_sysfs.c~drivers-edac-mod-pci-poll-names
+++ a/drivers/edac/edac_mc_sysfs.c
@@ -16,47 +16,44 @@
 #include "edac_module.h"
 
 /* MC EDAC Controls, setable by module parameter, and sysfs */
-static int log_ue = 1;
-static int log_ce = 1;
-static int panic_on_ue;
-static int poll_msec = 1000;
+static int edac_mc_log_ue = 1;
+static int edac_mc_log_ce = 1;
+static int edac_mc_panic_on_ue = 0;
+static int edac_mc_poll_msec = 1000;
 
 /* Getter functions for above */
-int edac_get_log_ue(void)
+int edac_mc_get_log_ue(void)
 {
-	return log_ue;
+	return edac_mc_log_ue;
 }
 
-int edac_get_log_ce(void)
+int edac_mc_get_log_ce(void)
 {
-	return log_ce;
+	return edac_mc_log_ce;
 }
 
-int edac_get_panic_on_ue(void)
+int edac_mc_get_panic_on_ue(void)
 {
-	return panic_on_ue;
+	return edac_mc_panic_on_ue;
 }
 
 /* this is temporary */
 int edac_mc_get_poll_msec(void)
 {
-	return edac_get_poll_msec();
-}
-
-int edac_get_poll_msec(void)
-{
-	return poll_msec;
+	return edac_mc_poll_msec;
 }
 
 /* Parameter declarations for above */
-module_param(panic_on_ue, int, 0644);
-MODULE_PARM_DESC(panic_on_ue, "Panic on uncorrected error: 0=off 1=on");
-module_param(log_ue, int, 0644);
-MODULE_PARM_DESC(log_ue, "Log uncorrectable error to console: 0=off 1=on");
-module_param(log_ce, int, 0644);
-MODULE_PARM_DESC(log_ce, "Log correctable error to console: 0=off 1=on");
-module_param(poll_msec, int, 0644);
-MODULE_PARM_DESC(poll_msec, "Polling period in milliseconds");
+module_param(edac_mc_panic_on_ue, int, 0644);
+MODULE_PARM_DESC(edac_mc_panic_on_ue, "Panic on uncorrected error: 0=off 1=on");
+module_param(edac_mc_log_ue, int, 0644);
+MODULE_PARM_DESC(edac_mc_log_ue,
+		"Log uncorrectable error to console: 0=off 1=on");
+module_param(edac_mc_log_ce, int, 0644);
+MODULE_PARM_DESC(edac_mc_log_ce,
+		"Log correctable error to console: 0=off 1=on");
+module_param(edac_mc_poll_msec, int, 0644);
+MODULE_PARM_DESC(edac_mc_poll_msec, "Polling period in milliseconds");
 
 
 /*
@@ -187,17 +184,32 @@ static struct memctrl_dev_attribute attr
 };
 
 /* csrow<id> control files */
-MEMCTRL_ATTR(panic_on_ue,S_IRUGO|S_IWUSR,memctrl_int_show,memctrl_int_store);
-MEMCTRL_ATTR(log_ue,S_IRUGO|S_IWUSR,memctrl_int_show,memctrl_int_store);
-MEMCTRL_ATTR(log_ce,S_IRUGO|S_IWUSR,memctrl_int_show,memctrl_int_store);
-MEMCTRL_ATTR(poll_msec,S_IRUGO|S_IWUSR,memctrl_int_show,memctrl_int_store);
+MEMCTRL_ATTR(edac_mc_panic_on_ue,
+		S_IRUGO | S_IWUSR,
+		memctrl_int_show,
+		memctrl_int_store);
+
+MEMCTRL_ATTR(edac_mc_log_ue,
+		S_IRUGO|S_IWUSR,
+		memctrl_int_show,
+		memctrl_int_store);
+
+MEMCTRL_ATTR(edac_mc_log_ce,
+		S_IRUGO|S_IWUSR,
+		memctrl_int_show,
+		memctrl_int_store);
+
+MEMCTRL_ATTR(edac_mc_poll_msec,
+		S_IRUGO|S_IWUSR,
+		memctrl_int_show,
+		memctrl_int_store);
 
 /* Base Attributes of the memory ECC object */
 static struct memctrl_dev_attribute *memctrl_attr[] = {
-	&attr_panic_on_ue,
-	&attr_log_ue,
-	&attr_log_ce,
-	&attr_poll_msec,
+	&attr_edac_mc_panic_on_ue,
+	&attr_edac_mc_log_ue,
+	&attr_edac_mc_log_ce,
+	&attr_edac_mc_poll_msec,
 	NULL,
 };
 
diff -puN drivers/edac/edac_module.h~drivers-edac-mod-pci-poll-names drivers/edac/edac_module.h
--- a/drivers/edac/edac_module.h~drivers-edac-mod-pci-poll-names
+++ a/drivers/edac/edac_module.h
@@ -27,6 +27,9 @@ extern void edac_check_mc_devices(void);
 extern int edac_get_log_ue(void);
 extern int edac_get_log_ce(void);
 extern int edac_get_panic_on_ue(void);
+extern int edac_mc_get_log_ue(void);
+extern int edac_mc_get_log_ce(void);
+extern int edac_mc_get_panic_on_ue(void);
 extern int edac_get_poll_msec(void);
 extern int edac_mc_get_poll_msec(void);
 
@@ -52,12 +55,16 @@ extern void edac_pci_do_parity_check(voi
 extern void edac_pci_clear_parity_errors(void);
 extern int edac_sysfs_pci_setup(void);
 extern void edac_sysfs_pci_teardown(void);
+extern int edac_pci_get_check_errors(void);
+extern int edac_pci_get_poll_msec(void);
 #else   /* CONFIG_PCI */
 /* pre-process these away */
 #define edac_pci_do_parity_check()
 #define edac_pci_clear_parity_errors()
 #define edac_sysfs_pci_setup()  (0)
 #define edac_sysfs_pci_teardown()
+#define edac_pci_get_check_errors()
+#define edac_pci_get_poll_msec()
 #endif  /* CONFIG_PCI */
 
 
diff -puN drivers/edac/edac_pci.c~drivers-edac-mod-pci-poll-names drivers/edac/edac_pci.c
--- a/drivers/edac/edac_pci.c~drivers-edac-mod-pci-poll-names
+++ a/drivers/edac/edac_pci.c
@@ -226,13 +226,14 @@ static void edac_pci_workq_function(void
 
 	if ((pci->op_state == OP_RUNNING_POLL) &&
 		(pci->edac_check != NULL) &&
-		(pci->check_parity_error))
+		(edac_pci_get_check_errors()))
 		pci->edac_check(pci);
 
 	edac_unlock_pci_list();
 
 	/* Reschedule */
-	queue_delayed_work(edac_workqueue, &pci->work, pci->delay);
+	queue_delayed_work(edac_workqueue, &pci->work,
+			msecs_to_jiffies(edac_pci_get_poll_msec()));
 }
 
 /*
@@ -245,15 +246,13 @@ static void edac_pci_workq_setup(struct 
 {
 	debugf0("%s()\n", __func__);
 
-	pci->poll_msec = msec;
-	edac_calc_delay(pci);
-
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 	INIT_DELAYED_WORK(&pci->work, edac_pci_workq_function);
 #else
 	INIT_WORK(&pci->work, edac_pci_workq_function, pci);
 #endif
-	queue_delayed_work(edac_workqueue, &pci->work, pci->delay);
+	queue_delayed_work(edac_workqueue, &pci->work,
+			msecs_to_jiffies(edac_pci_get_poll_msec()));
 }
 
 /*
@@ -390,16 +389,6 @@ struct edac_pci_ctl_info * edac_pci_del_
 }
 EXPORT_SYMBOL_GPL(edac_pci_del_device);
 
-static inline int edac_pci_get_log_pe(struct edac_pci_ctl_info *pci)
-{
-	return pci->log_parity_error;
-}
-
-static inline int edac_pci_get_panic_on_pe(struct edac_pci_ctl_info *pci)
-{
-	return pci->panic_on_pe;
-}
-
 void edac_pci_generic_check(struct edac_pci_ctl_info *pci)
 {
 	edac_pci_do_parity_check();
diff -puN drivers/edac/edac_pci_sysfs.c~drivers-edac-mod-pci-poll-names drivers/edac/edac_pci_sysfs.c
--- a/drivers/edac/edac_pci_sysfs.c~drivers-edac-mod-pci-poll-names
+++ a/drivers/edac/edac_pci_sysfs.c
@@ -19,15 +19,42 @@
 #define EDAC_PCI_SYMLINK	"device"
 
 static int check_pci_errors = 0;	/* default YES check PCI parity */
-static int panic_on_pci_parity = 0;	/* default no panic on PCI Parity */
-static int log_pci_errs = 1;
+static int edac_pci_panic_on_pe = 0;	/* default no panic on PCI Parity */
+static int edac_pci_log_pe = 1;	/* log PCI parity errors */
+static int edac_pci_log_npe = 1;	/* log PCI non-parity error errors */
 static atomic_t pci_parity_count = ATOMIC_INIT(0);
 static atomic_t pci_nonparity_count = ATOMIC_INIT(0);
+static int edac_pci_poll_msec = 1000;
 
 static struct kobject edac_pci_kobj; /* /sys/devices/system/edac/pci */
 static struct completion edac_pci_kobj_complete;
 static atomic_t edac_pci_sysfs_refcount = ATOMIC_INIT(0);
 
+int edac_pci_get_check_errors(void)
+{
+	return check_pci_errors;
+}
+
+int edac_pci_get_log_pe(void)
+{
+	return edac_pci_log_pe;
+}
+
+int edac_pci_get_log_npe(void)
+{
+	return edac_pci_log_npe;
+}
+
+int edac_pci_get_panic_on_pe(void)
+{
+	return edac_pci_panic_on_pe;
+}
+
+int edac_pci_get_poll_msec(void)
+{
+	return edac_pci_poll_msec;
+}
+
 /**************************** EDAC PCI sysfs instance *******************/
 static ssize_t instance_pe_count_show(struct edac_pci_ctl_info *pci, char *data)
 {
@@ -222,9 +249,11 @@ static struct edac_pci_dev_attribute eda
 /* PCI Parity control files */
 EDAC_PCI_ATTR(check_pci_errors, S_IRUGO|S_IWUSR, edac_pci_int_show,
 	edac_pci_int_store);
-EDAC_PCI_ATTR(log_pci_errs, S_IRUGO|S_IWUSR, edac_pci_int_show,
+EDAC_PCI_ATTR(edac_pci_log_pe, S_IRUGO|S_IWUSR, edac_pci_int_show,
+	edac_pci_int_store);
+EDAC_PCI_ATTR(edac_pci_log_npe, S_IRUGO|S_IWUSR, edac_pci_int_show,
 	edac_pci_int_store);
-EDAC_PCI_ATTR(panic_on_pci_parity, S_IRUGO|S_IWUSR, edac_pci_int_show,
+EDAC_PCI_ATTR(edac_pci_panic_on_pe, S_IRUGO|S_IWUSR, edac_pci_int_show,
 	edac_pci_int_store);
 EDAC_PCI_ATTR(pci_parity_count, S_IRUGO, edac_pci_int_show, NULL);
 EDAC_PCI_ATTR(pci_nonparity_count, S_IRUGO, edac_pci_int_show, NULL);
@@ -232,8 +261,9 @@ EDAC_PCI_ATTR(pci_nonparity_count, S_IRU
 /* Base Attributes of the memory ECC object */
 static struct edac_pci_dev_attribute *edac_pci_attr[] = {
 	&edac_pci_attr_check_pci_errors,
-	&edac_pci_attr_log_pci_errs,
-	&edac_pci_attr_panic_on_pci_parity,
+	&edac_pci_attr_edac_pci_log_pe,
+	&edac_pci_attr_edac_pci_log_npe,
+	&edac_pci_attr_edac_pci_panic_on_pe,
 	&edac_pci_attr_pci_parity_count,
 	&edac_pci_attr_pci_nonparity_count,
 	NULL,
@@ -529,7 +559,7 @@ void edac_pci_do_parity_check(void)
 	local_irq_restore(flags);
 
 	/* Only if operator has selected panic on PCI Error */
-	if (panic_on_pci_parity) {
+	if (edac_pci_get_panic_on_pe()) {
 		/* If the count is different 'after' from 'before' */
 		if (before_count != atomic_read(&pci_parity_count))
 			panic("EDAC: PCI Parity Error");
@@ -549,7 +579,7 @@ void edac_pci_handle_pe(struct edac_pci_
 	/* global PE counter incremented by edac_pci_do_parity_check() */
 	atomic_inc(&pci->counters.pe_count);
 
-	if (log_pci_errs)
+	if (edac_pci_get_log_pe())
 		edac_pci_printk(pci, KERN_WARNING,
 				"Parity Error ctl: %s %d: %s\n",
 				pci->ctl_name, pci->pci_idx, msg);
@@ -568,7 +598,7 @@ void edac_pci_handle_npe(struct edac_pci
 	/* global NPE counter incremented by edac_pci_do_parity_check() */
 	atomic_inc(&pci->counters.npe_count);
 
-	if (log_pci_errs)
+	if (edac_pci_get_log_npe())
 		edac_pci_printk(pci, KERN_WARNING,
 				"Non-Parity Error ctl: %s %d: %s\n",
 				pci->ctl_name, pci->pci_idx, msg);
@@ -585,8 +615,10 @@ EXPORT_SYMBOL_GPL(edac_pci_handle_npe);
  * Define the PCI parameter to the module
  */
 module_param(check_pci_errors, int, 0644);
-MODULE_PARM_DESC(check_pci_errors, "Check for PCI bus parity errors: 0=off 1=on");
-module_param(panic_on_pci_parity, int, 0644);
-MODULE_PARM_DESC(panic_on_pci_parity, "Panic on PCI Bus Parity error: 0=off 1=on");
+MODULE_PARM_DESC(check_pci_errors,
+		"Check for PCI bus parity errors: 0=off 1=on");
+module_param(edac_pci_panic_on_pe, int, 0644);
+MODULE_PARM_DESC(edac_pci_panic_on_pe,
+		"Panic on PCI Bus Parity error: 0=off 1=on");
 
 #endif	/* CONFIG_PCI */
_

Patches currently in -mm which might be from djiang@mvista.com are

origin.patch

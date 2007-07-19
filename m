From: akpm@linux-foundation.org
Subject: - drivers-edac-updated-pci-monitoring.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:05:53 -0700
Message-ID: <200707192005.l6JK5rNE020082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33954 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761414AbXGSUQR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djiang@mvista.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: updated PCI monitoring
has been removed from the -mm tree.  Its filename was
     drivers-edac-updated-pci-monitoring.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: updated PCI monitoring
From: Dave Jiang <djiang@mvista.com>

Moving PCI to a per-instance device model

This should include the correct sysfs setup as well. Please review.

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Makefile         |    5 
 drivers/edac/e752x_edac.c     |   16 +
 drivers/edac/edac_core.h      |  120 ++++++++
 drivers/edac/edac_device.c    |   23 -
 drivers/edac/edac_module.c    |   32 +-
 drivers/edac/edac_pci.c       |  451 ++++++++++++++++++++++++++++++++
 drivers/edac/edac_pci_sysfs.c |  281 ++++++++++++++++++-
 7 files changed, 862 insertions(+), 66 deletions(-)

diff -puN drivers/edac/Makefile~drivers-edac-updated-pci-monitoring drivers/edac/Makefile
--- a/drivers/edac/Makefile~drivers-edac-updated-pci-monitoring
+++ a/drivers/edac/Makefile
@@ -11,9 +11,12 @@ obj-$(CONFIG_EDAC)			:= edac_stub.o
 obj-$(CONFIG_EDAC_MM_EDAC)		+= edac_core.o
 
 edac_core-objs	:= edac_mc.o edac_device.o edac_mc_sysfs.o edac_pci_sysfs.o
-
 edac_core-objs	+= edac_module.o edac_device_sysfs.o
 
+ifdef CONFIG_PCI
+edac_core-objs	+= edac_pci.o edac_pci_sysfs.o
+endif
+
 obj-$(CONFIG_EDAC_AMD76X)		+= amd76x_edac.o
 obj-$(CONFIG_EDAC_I5000)		+= i5000_edac.o
 obj-$(CONFIG_EDAC_E7XXX)		+= e7xxx_edac.o
diff -puN drivers/edac/e752x_edac.c~drivers-edac-updated-pci-monitoring drivers/edac/e752x_edac.c
--- a/drivers/edac/e752x_edac.c~drivers-edac-updated-pci-monitoring
+++ a/drivers/edac/e752x_edac.c
@@ -30,6 +30,8 @@
 
 static int force_function_unhide;
 
+static struct edac_pci_ctl_info *e752x_pci;
+
 #define e752x_printk(level, fmt, arg...) \
 	edac_printk(level, "e752x", fmt, ##arg)
 
@@ -1040,6 +1042,17 @@ static int e752x_probe1(struct pci_dev *
 	e752x_init_error_reporting_regs(pvt);
 	e752x_get_error_info(mci, &discard); /* clear other MCH errors */
 
+	/* allocating generic PCI control info */
+	e752x_pci = edac_pci_create_generic_ctl(&pdev->dev, EDAC_MOD_STR);
+	if (!e752x_pci) {
+		printk(KERN_WARNING
+			"%s(): Unable to create PCI control\n",
+			__func__);
+		printk(KERN_WARNING
+			"%s(): PCI error report via EDAC not setup\n",
+			__func__);
+	}
+
 	/* get this far and it's successful */
 	debugf3("%s(): success\n", __func__);
 	return 0;
@@ -1073,6 +1086,9 @@ static void __devexit e752x_remove_one(s
 
 	debugf0("%s()\n", __func__);
 
+	if (e752x_pci)
+		edac_pci_release_generic_ctl(e752x_pci);
+
 	if ((mci = edac_mc_del_mc(&pdev->dev)) == NULL)
 		return;
 
diff -puN drivers/edac/edac_core.h~drivers-edac-updated-pci-monitoring drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~drivers-edac-updated-pci-monitoring
+++ a/drivers/edac/edac_core.h
@@ -60,6 +60,10 @@
 #define edac_device_printk(ctl, level, fmt, arg...) \
 	printk(level "EDAC DEVICE%d: " fmt, ctl->dev_idx, ##arg)
 
+/* edac_pci printk */
+#define edac_pci_printk(ctl, level, fmt, arg...) \
+	printk(level "EDAC PCI%d: " fmt, ctl->pci_idx, ##arg)
+
 /* prefixes for edac_printk() and edac_mc_printk() */
 #define EDAC_MC "MC"
 #define EDAC_PCI "PCI"
@@ -200,6 +204,13 @@ enum scrub_type {
 
 /* FIXME - should have notify capabilities: NMI, LOG, PROC, etc */
 
+/* EDAC internal operation states */
+#define	OP_ALLOC		0x100
+#define OP_RUNNING_POLL		0x201
+#define OP_RUNNING_INTERRUPT	0x202
+#define OP_RUNNING_POLL_INTR	0x203
+#define OP_OFFLINE		0x300
+
 extern char * edac_align_ptr(void *ptr, unsigned size);
 
 /*
@@ -520,12 +531,6 @@ struct edac_device_ctl_info {
 
 	/* the internal state of this controller instance */
 	int op_state;
-#define	OP_ALLOC		0x100
-#define OP_RUNNING_POLL		0x201
-#define OP_RUNNING_INTERRUPT	0x202
-#define OP_RUNNING_POLL_INTR	0x203
-#define OP_OFFLINE		0x300
-
 	/* work struct for this instance */
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 	struct delayed_work work;
@@ -626,6 +631,84 @@ extern void edac_device_free_ctl_info( s
 
 #ifdef CONFIG_PCI
 
+struct edac_pci_counter {
+	atomic_t	pe_count;
+	atomic_t	npe_count;
+};
+
+/*
+ * Abstract edac_pci control info structure
+ *
+ */
+struct edac_pci_ctl_info {
+	/* for global list of edac_pci_ctl_info structs */
+	struct list_head link;
+
+	int pci_idx;
+
+	/* Per instance controls for this edac_device */
+	int check_parity_error;	/* boolean for checking parity errs */
+	int log_parity_error;	/* boolean for logging parity errs */
+	int panic_on_pe;	/* boolean for panic'ing on a PE */
+	unsigned poll_msec;	/* number of milliseconds to poll interval */
+	unsigned long delay;	/* number of jiffies for poll_msec */
+
+	struct sysdev_class *edac_class;	/* pointer to class */
+
+	/* the internal state of this controller instance */
+	int op_state;
+	/* work struct for this instance */
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
+	struct delayed_work work;
+#else
+	struct work_struct work;
+#endif
+
+	/* pointer to edac polling checking routine:
+	 *	If NOT NULL: points to polling check routine
+	 *	If NULL: Then assumes INTERRUPT operation, where
+	 *		MC driver will receive events
+	 */
+	void (*edac_check) (struct edac_pci_ctl_info * edac_dev);
+
+	struct device *dev;	/* pointer to device structure */
+
+	const char *mod_name;	/* module name */
+	const char *ctl_name;	/* edac controller  name */
+	const char *dev_name;	/* pci/platform/etc... name */
+
+	void *pvt_info;		/* pointer to 'private driver' info */
+
+	unsigned long start_time;/* edac_pci load start time (jiffies)*/
+
+	/* these are for safe removal of devices from global list while
+	 * NMI handlers may be traversing list
+	 */
+	struct rcu_head rcu;
+	struct completion complete;
+
+	/* sysfs top name under 'edac' directory
+	 * and instance name:
+	 *	cpu/cpu0/...
+	 *	cpu/cpu1/...
+	 *	cpu/cpu2/...
+	 *	...
+	 */
+	char name[EDAC_DEVICE_NAME_LEN + 1];
+
+	/* Event counters for the this whole EDAC Device */
+	struct edac_pci_counter counters;
+
+	/* edac sysfs device control for the 'name'
+	 * device this structure controls
+	 */
+	struct kobject kobj;
+	struct completion kobj_complete;
+};
+
+#define to_edac_pci_ctl_work(w) \
+		container_of(w, struct edac_pci_ctl_info,work)
+
 /* write all or some bits in a byte-register*/
 static inline void pci_write_bits8(struct pci_dev *pdev, int offset, u8 value,
 		u8 mask)
@@ -726,5 +809,30 @@ extern void edac_device_handle_ue(struct
 extern void edac_device_handle_ce(struct edac_device_ctl_info *edac_dev,
 		int inst_nr, int block_nr, const char *msg);
 
+/*
+ * edac_pci APIs
+ */
+extern struct edac_pci_ctl_info *
+edac_pci_alloc_ctl_info(unsigned int sz_pvt, const char *edac_pci_name);
+
+extern void edac_pci_free_ctl_info(struct edac_pci_ctl_info *pci);
+
+extern void
+edac_pci_reset_delay_period(struct edac_pci_ctl_info *pci, unsigned long value);
+
+extern int edac_pci_add_device(struct edac_pci_ctl_info *pci, int edac_idx);
+extern struct edac_pci_ctl_info * edac_pci_del_device(struct device *dev);
+
+extern struct edac_pci_ctl_info *
+edac_pci_create_generic_ctl(struct device *dev, const char *mod_name);
+
+extern void edac_pci_release_generic_ctl(struct edac_pci_ctl_info *pci);
+extern int edac_pci_create_sysfs(struct edac_pci_ctl_info *pci);
+extern void edac_pci_remove_sysfs(struct edac_pci_ctl_info *pci);
+
+/*
+ * edac misc APIs
+ */
+extern char * edac_op_state_toString(int op_state);
 
 #endif				/* _EDAC_CORE_H_ */
diff -puN drivers/edac/edac_device.c~drivers-edac-updated-pci-monitoring drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~drivers-edac-updated-pci-monitoring
+++ a/drivers/edac/edac_device.c
@@ -418,27 +418,6 @@ void edac_device_reset_delay_period(
 	unlock_device_list();
 }
 
-/*
- * edac_op_state_toString(edac_dev)
- */
-static char *edac_op_state_toString(struct edac_device_ctl_info *edac_dev)
-{
-	int opstate = edac_dev->op_state;
-
-	if (opstate == OP_RUNNING_POLL)
-		return "POLLED";
-	else if (opstate == OP_RUNNING_INTERRUPT)
-		return "INTERRUPT";
-	else if (opstate == OP_RUNNING_POLL_INTR)
-		return "POLL-INTR";
-	else if (opstate == OP_ALLOC)
-		return "ALLOC";
-	else if (opstate == OP_OFFLINE)
-		return "OFFLINE";
-
-	return "UNKNOWN";
-}
-
 /**
  * edac_device_add_device: Insert the 'edac_dev' structure into the
  * edac_device global list and create sysfs entries associated with
@@ -496,7 +475,7 @@ int edac_device_add_device(struct edac_d
 		edac_dev->mod_name,
 		edac_dev->ctl_name,
 		dev_name(edac_dev),
-		edac_op_state_toString(edac_dev)
+		edac_op_state_toString(edac_dev->op_state)
 		);
 
 	unlock_device_list();
diff -puN drivers/edac/edac_module.c~drivers-edac-updated-pci-monitoring drivers/edac/edac_module.c
--- a/drivers/edac/edac_module.c~drivers-edac-updated-pci-monitoring
+++ a/drivers/edac/edac_module.c
@@ -35,6 +35,25 @@ static struct sysdev_class edac_class = 
 static int edac_class_valid = 0;
 
 /*
+ * edac_op_state_toString()
+ */
+char * edac_op_state_toString(int opstate)
+{
+	if (opstate == OP_RUNNING_POLL)
+		return "POLLED";
+	else if (opstate == OP_RUNNING_INTERRUPT)
+		return "INTERRUPT";
+	else if (opstate == OP_RUNNING_POLL_INTR)
+		return "POLL-INTR";
+	else if (opstate == OP_ALLOC)
+		return "ALLOC";
+	else if (opstate == OP_OFFLINE)
+		return "OFFLINE";
+
+	return "UNKNOWN";
+}
+
+/*
  * edac_get_edac_class()
  *
  *	return pointer to the edac class of 'edac'
@@ -153,26 +172,16 @@ static int __init edac_init(void)
 		goto error_sysfs;
 	}
 
-	/* Create the PCI parity sysfs entries */
-	if (edac_sysfs_pci_setup()) {
-		edac_printk(KERN_ERR, EDAC_MC,
-			"PCI: Error initializing sysfs code\n");
-		err = -ENODEV;
-		goto error_mem;
-	}
-
 	/* Setup/Initialize the edac_device system */
 	err = edac_workqueue_setup();
 	if (err) {
 		edac_printk(KERN_ERR, EDAC_MC, "init WorkQueue failure\n");
-		goto error_pci;
+		goto error_mem;
 	}
 
 	return 0;
 
 	/* Error teardown stack */
-error_pci:
-	edac_sysfs_pci_teardown();
 error_mem:
 	edac_sysfs_memctrl_teardown();
 error_sysfs:
@@ -192,7 +201,6 @@ static void __exit edac_exit(void)
 	/* tear down the various subsystems*/
 	edac_workqueue_teardown();
 	edac_sysfs_memctrl_teardown();
-	edac_sysfs_pci_teardown();
 	edac_unregister_sysfs_edac_name();
 }
 
diff -puN /dev/null drivers/edac/edac_pci.c
--- /dev/null
+++ a/drivers/edac/edac_pci.c
@@ -0,0 +1,451 @@
+/*
+ * EDAC PCI component
+ *
+ * Author: Dave Jiang <djiang@mvista.com>
+ *
+ * 2007 (c) MontaVista Software, Inc. This file is licensed under
+ * the terms of the GNU General Public License version 2. This program
+ * is licensed "as is" without any warranty of any kind, whether express
+ * or implied.
+ *
+ */
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/smp.h>
+#include <linux/init.h>
+#include <linux/sysctl.h>
+#include <linux/highmem.h>
+#include <linux/timer.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+#include <linux/sysdev.h>
+#include <linux/ctype.h>
+#include <linux/workqueue.h>
+#include <asm/uaccess.h>
+#include <asm/page.h>
+
+#include "edac_core.h"
+#include "edac_module.h"
+
+static DEFINE_MUTEX(edac_pci_ctls_mutex);
+static struct list_head edac_pci_list = LIST_HEAD_INIT(edac_pci_list);
+
+static inline void edac_lock_pci_list(void)
+{
+	mutex_lock(&edac_pci_ctls_mutex);
+}
+
+static inline void edac_unlock_pci_list(void)
+{
+	mutex_unlock(&edac_pci_ctls_mutex);
+}
+
+/*
+ * The alloc() and free() functions for the 'edac_pci' control info
+ * structure. The chip driver will allocate one of these for each
+ * edac_pci it is going to control/register with the EDAC CORE.
+ */
+struct edac_pci_ctl_info * edac_pci_alloc_ctl_info(
+	unsigned int sz_pvt,
+	const char *edac_pci_name)
+{
+	struct edac_pci_ctl_info *pci;
+	void *pvt;
+	unsigned int size;
+
+	pci = (struct edac_pci_ctl_info *)0;
+	pvt = edac_align_ptr(&pci[1], sz_pvt);
+	size = ((unsigned long)pvt) + sz_pvt;
+
+	if ((pci = kzalloc(size, GFP_KERNEL)) == NULL)
+		return NULL;
+
+	pvt = sz_pvt ? ((char *)pci) + ((unsigned long)pvt) : NULL;
+
+	pci->pvt_info = pvt;
+
+	pci->op_state = OP_ALLOC;
+
+	snprintf(pci->name, strlen(edac_pci_name)+1, "%s", edac_pci_name);
+
+	return pci;
+}
+EXPORT_SYMBOL_GPL(edac_pci_alloc_ctl_info);
+
+/*
+ * edac_pci_free_ctl_info()
+ * 	frees the memory allocated by edac_pci_alloc_ctl_info() function
+ */
+void edac_pci_free_ctl_info(struct edac_pci_ctl_info *pci)
+{
+	kfree(pci);
+}
+EXPORT_SYMBOL_GPL(edac_pci_free_ctl_info);
+
+/*
+ * find_edac_pci_by_dev()
+ * 	scans the edac_pci list for a specific 'struct device *'
+ */
+static struct edac_pci_ctl_info * find_edac_pci_by_dev(struct device *dev)
+{
+	struct edac_pci_ctl_info *pci;
+	struct list_head *item;
+
+	debugf3("%s()\n", __func__);
+
+	list_for_each(item, &edac_pci_list) {
+		pci = list_entry(item, struct edac_pci_ctl_info, link);
+
+		if (pci->dev == dev)
+			return pci;
+	}
+
+	return NULL;
+}
+
+/*
+ * add_edac_pci_to_global_list
+ * 	Before calling this function, caller must assign a unique value to
+ * 	edac_dev->pci_idx.
+ * 	Return:
+ * 		0 on success
+ * 		1 on failure
+ */
+static int add_edac_pci_to_global_list(struct edac_pci_ctl_info *pci)
+{
+	struct list_head *item, *insert_before;
+	struct edac_pci_ctl_info *rover;
+
+	insert_before = &edac_pci_list;
+
+	/* Determine if already on the list */
+	if (unlikely((rover = find_edac_pci_by_dev(pci->dev)) != NULL))
+		goto fail0;
+
+	/* Insert in ascending order by 'pci_idx', so find position */
+	list_for_each(item, &edac_pci_list) {
+		rover = list_entry(item, struct edac_pci_ctl_info, link);
+
+		if (rover->pci_idx >= pci->pci_idx) {
+			if (unlikely(rover->pci_idx == pci->pci_idx))
+				goto fail1;
+
+			insert_before = item;
+			break;
+		}
+	}
+
+	list_add_tail_rcu(&pci->link, insert_before);
+	return 0;
+
+fail0:
+	edac_printk(KERN_WARNING, EDAC_PCI,
+		"%s (%s) %s %s already assigned %d\n",
+		rover->dev->bus_id, dev_name(rover),
+		rover->mod_name, rover->ctl_name, rover->pci_idx);
+	return 1;
+
+fail1:
+	edac_printk(KERN_WARNING, EDAC_PCI,
+		"but in low-level driver: attempt to assign\n"
+		"\tduplicate pci_idx %d in %s()\n", rover->pci_idx, __func__);
+	return 1;
+}
+
+/*
+ * complete_edac_pci_list_del
+ */
+static void complete_edac_pci_list_del(struct rcu_head *head)
+{
+	struct edac_pci_ctl_info *pci;
+
+	pci = container_of(head, struct edac_pci_ctl_info, rcu);
+	INIT_LIST_HEAD(&pci->link);
+	complete(&pci->complete);
+}
+
+/*
+ * del_edac_pci_from_global_list
+ */
+static void del_edac_pci_from_global_list(struct edac_pci_ctl_info *pci)
+{
+	list_del_rcu(&pci->link);
+	init_completion(&pci->complete);
+	call_rcu(&pci->rcu, complete_edac_pci_list_del);
+	wait_for_completion(&pci->complete);
+}
+
+/*
+ * edac_pci_find()
+ * 	Search for an edac_pci_ctl_info structure whose index is 'idx'
+ *
+ * If found, return a pointer to the structure
+ * Else return NULL.
+ *
+ * Caller must hold pci_ctls_mutex.
+ */
+struct edac_pci_ctl_info * edac_pci_find(int idx)
+{
+	struct list_head *item;
+	struct edac_pci_ctl_info *pci;
+
+	/* Iterage over list, looking for exact match of ID */
+	list_for_each(item, &edac_pci_list) {
+		pci = list_entry(item, struct edac_pci_ctl_info, link);
+
+		if (pci->pci_idx >= idx) {
+			if (pci->pci_idx == idx)
+				return pci;
+
+		/* not on list, so terminate early */
+			break;
+		}
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(edac_pci_find);
+
+/*
+ * edac_pci_workq_function()
+ * 	performs the operation scheduled by a workq request
+ */
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
+static void edac_pci_workq_function(struct work_struct *work_req)
+{
+	struct delayed_work *d_work = (struct delayed_work *)work_req;
+	struct edac_pci_ctl_info *pci = to_edac_pci_ctl_work(d_work);
+#else
+static void edac_pci_workq_function(void *ptr)
+{
+	struct edac_pci_ctl_info *pci = ptr;
+#endif
+
+	edac_lock_pci_list();
+
+	if ((pci->op_state == OP_RUNNING_POLL) &&
+		(pci->edac_check != NULL) &&
+		(pci->check_parity_error))
+		pci->edac_check(pci);
+
+	edac_unlock_pci_list();
+
+	/* Reschedule */
+	queue_delayed_work(edac_workqueue, &pci->work, pci->delay);
+}
+
+/*
+ * edac_pci_workq_setup()
+ * 	initialize a workq item for this edac_pci instance
+ * 	passing in the new delay period in msec
+ */
+static void edac_pci_workq_setup(struct edac_pci_ctl_info *pci,
+		unsigned int msec)
+{
+	debugf0("%s()\n", __func__);
+
+	pci->poll_msec = msec;
+	edac_calc_delay(pci);
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
+	INIT_DELAYED_WORK(&pci->work, edac_pci_workq_function);
+#else
+	INIT_WORK(&pci->work, edac_pci_workq_function, pci);
+#endif
+	queue_delayed_work(edac_workqueue, &pci->work, pci->delay);
+}
+
+/*
+ * edac_pci_workq_teardown()
+ * 	stop the workq processing on this edac_pci instance
+ */
+static void edac_pci_workq_teardown(struct edac_pci_ctl_info *pci)
+{
+	int status;
+
+	status = cancel_delayed_work(&pci->work);
+	if (status == 0)
+		flush_workqueue(edac_workqueue);
+}
+
+/*
+ * edac_pci_reset_delay_period
+ */
+void edac_pci_reset_delay_period(struct edac_pci_ctl_info *pci,
+		unsigned long value)
+{
+	edac_lock_pci_list();
+
+	edac_pci_workq_teardown(pci);
+
+	edac_pci_workq_setup(pci, value);
+
+	edac_unlock_pci_list();
+}
+EXPORT_SYMBOL_GPL(edac_pci_reset_delay_period);
+
+/*
+ * edac_pci_add_device: Insert the 'edac_dev' structure into the
+ * edac_pci global list and create sysfs entries associated with
+ * edac_pci structure.
+ * @pci: pointer to the edac_device structure to be added to the list
+ * @edac_idx: A unique numeric identifier to be assigned to the
+ * 'edac_pci' structure.
+ *
+ * Return:
+ *      0       Success
+ *      !0      Failure
+ */
+int edac_pci_add_device(struct edac_pci_ctl_info *pci, int edac_idx)
+{
+	debugf0("%s()\n", __func__);
+
+	pci->pci_idx = edac_idx;
+
+	edac_lock_pci_list();
+
+	if (add_edac_pci_to_global_list(pci))
+		goto fail0;
+
+	pci->start_time = jiffies;
+
+	if (edac_pci_create_sysfs(pci)) {
+		edac_pci_printk(pci, KERN_WARNING,
+				"failed to create sysfs pci\n");
+		goto fail1;
+	}
+
+	if (pci->edac_check != NULL) {
+		pci->op_state = OP_RUNNING_POLL;
+
+		edac_pci_workq_setup(pci, 1000);
+	} else {
+		pci->op_state = OP_RUNNING_INTERRUPT;
+	}
+
+	edac_pci_printk(pci, KERN_INFO,
+		"Giving out device to module '%s' controller '%s':"
+		" DEV '%s' (%s)\n",
+		pci->mod_name,
+		pci->ctl_name,
+		dev_name(pci),
+		edac_op_state_toString(pci->op_state));
+
+	edac_unlock_pci_list();
+	return 0;
+
+fail1:
+	del_edac_pci_from_global_list(pci);
+fail0:
+	edac_unlock_pci_list();
+	return 1;
+}
+EXPORT_SYMBOL_GPL(edac_pci_add_device);
+
+/*
+ * edac_pci_del_device()
+ * 	Remove sysfs entries for specified edac_pci structure and
+ * 	then remove edac_pci structure from global list
+ *
+ * @dev:
+ * 	Pointer to 'struct device' representing edac_pci structure
+ * 	to remove
+ *
+ * Return:
+ * 	Pointer to removed edac_pci structure,
+ * 	or NULL if device not found
+ */
+struct edac_pci_ctl_info * edac_pci_del_device(struct device *dev)
+{
+	struct edac_pci_ctl_info *pci;
+
+	debugf0("%s()\n", __func__);
+
+	edac_lock_pci_list();
+
+	if ((pci = find_edac_pci_by_dev(dev)) == NULL) {
+		edac_unlock_pci_list();
+		return NULL;
+	}
+
+	pci->op_state = OP_OFFLINE;
+
+	edac_pci_workq_teardown(pci);
+
+	edac_pci_remove_sysfs(pci);
+
+	del_edac_pci_from_global_list(pci);
+
+	edac_unlock_pci_list();
+
+	edac_printk(KERN_INFO, EDAC_PCI,
+		"Removed device %d for %s %s: DEV %s\n",
+		pci->pci_idx,
+		pci->mod_name,
+		pci->ctl_name,
+		dev_name(pci));
+
+	return pci;
+}
+EXPORT_SYMBOL_GPL(edac_pci_del_device);
+
+static inline int edac_pci_get_log_pe(struct edac_pci_ctl_info *pci)
+{
+	return pci->log_parity_error;
+}
+
+static inline int edac_pci_get_panic_on_pe(struct edac_pci_ctl_info *pci)
+{
+	return pci->panic_on_pe;
+}
+
+void edac_pci_generic_check(struct edac_pci_ctl_info *pci)
+{
+	edac_pci_do_parity_check();
+}
+
+static int edac_pci_idx = 0;
+#define EDAC_PCI_GENCTL_NAME	"EDAC PCI controller"
+
+struct edac_pci_gen_data {
+	int edac_idx;
+};
+
+struct edac_pci_ctl_info *
+edac_pci_create_generic_ctl(struct device *dev, const char *mod_name)
+{
+	struct edac_pci_ctl_info *pci;
+	struct edac_pci_gen_data *pdata;
+
+	pci = edac_pci_alloc_ctl_info(sizeof(*pdata), EDAC_PCI_GENCTL_NAME);
+	if (!pci)
+		return NULL;
+
+	pdata = pci->pvt_info;
+	pci->dev = dev;
+	dev_set_drvdata(pci->dev, pci);
+	pci->dev_name = pci_name(to_pci_dev(dev));
+
+	pci->mod_name = mod_name;
+	pci->ctl_name = EDAC_PCI_GENCTL_NAME;
+	pci->edac_check = edac_pci_generic_check;
+
+	pdata->edac_idx = edac_pci_idx++;
+
+	if (edac_pci_add_device(pci, pdata->edac_idx) > 0) {
+		debugf3("%s(): failed edac_pci_add_device()\n", __func__);
+		edac_pci_free_ctl_info(pci);
+		return NULL;
+	}
+
+	return pci;
+}
+EXPORT_SYMBOL_GPL(edac_pci_create_generic_ctl);
+
+void edac_pci_release_generic_ctl(struct edac_pci_ctl_info *pci)
+{
+	edac_pci_del_device(pci->dev);
+	edac_pci_free_ctl_info(pci);
+}
+EXPORT_SYMBOL_GPL(edac_pci_release_generic_ctl);
diff -puN drivers/edac/edac_pci_sysfs.c~drivers-edac-updated-pci-monitoring drivers/edac/edac_pci_sysfs.c
--- a/drivers/edac/edac_pci_sysfs.c~drivers-edac-updated-pci-monitoring
+++ a/drivers/edac/edac_pci_sysfs.c
@@ -15,13 +15,142 @@
 
 
 #ifdef CONFIG_PCI
-static int check_pci_parity = 0;	/* default YES check PCI parity */
-static int panic_on_pci_parity;		/* default no panic on PCI Parity */
+
+#define EDAC_PCI_SYMLINK	"device"
+
+static int check_pci_errors = 0;	/* default YES check PCI parity */
+static int panic_on_pci_parity = 0;	/* default no panic on PCI Parity */
+static int log_pci_errs = 1;
 static atomic_t pci_parity_count = ATOMIC_INIT(0);
+static atomic_t pci_nonparity_count = ATOMIC_INIT(0);
 
 static struct kobject edac_pci_kobj; /* /sys/devices/system/edac/pci */
 static struct completion edac_pci_kobj_complete;
+static atomic_t edac_pci_sysfs_refcount = ATOMIC_INIT(0);
+
+/**************************** EDAC PCI sysfs instance *******************/
+static ssize_t instance_pe_count_show(struct edac_pci_ctl_info *pci, char *data)
+{
+        return sprintf(data,"%u\n", atomic_read(&pci->counters.pe_count));
+}
+
+static ssize_t instance_npe_count_show(struct edac_pci_ctl_info *pci,
+		char *data)
+{
+        return sprintf(data,"%u\n", atomic_read(&pci->counters.npe_count));
+}
+
+#define to_instance(k) container_of(k, struct edac_pci_ctl_info, kobj)
+#define to_instance_attr(a) container_of(a, struct instance_attribute, attr)
+
+/* DEVICE instance kobject release() function */
+static void edac_pci_instance_release(struct kobject *kobj)
+{
+	struct edac_pci_ctl_info *pci;
+
+	debugf1("%s()\n", __func__);
+
+	pci = to_instance(kobj);
+	complete(&pci->kobj_complete);
+}
+
+/* instance specific attribute structure */
+struct instance_attribute {
+        struct attribute attr;
+        ssize_t (*show)(struct edac_pci_ctl_info *, char *);
+        ssize_t (*store)(struct edac_pci_ctl_info *, const char *, size_t);
+};
+
+/* Function to 'show' fields from the edac_pci 'instance' structure */
+static ssize_t edac_pci_instance_show(struct kobject *kobj,
+                        struct attribute *attr,
+                        char *buffer)
+{
+        struct edac_pci_ctl_info *pci = to_instance(kobj);
+        struct instance_attribute *instance_attr = to_instance_attr(attr);
+
+        if (instance_attr->show)
+                return instance_attr->show(pci, buffer);
+        return -EIO;
+}
+
+
+/* Function to 'store' fields into the edac_pci 'instance' structure */
+static ssize_t edac_pci_instance_store(struct kobject *kobj,
+                        struct attribute *attr,
+                	const char *buffer, size_t count)
+{
+        struct edac_pci_ctl_info *pci = to_instance(kobj);
+        struct instance_attribute *instance_attr = to_instance_attr(attr);
+
+        if (instance_attr->store)
+                return instance_attr->store(pci, buffer, count);
+        return -EIO;
+}
+
+static struct sysfs_ops pci_instance_ops = {
+	.show = edac_pci_instance_show,
+	.store = edac_pci_instance_store
+};
+
+#define INSTANCE_ATTR(_name, _mode, _show, _store)	\
+static struct instance_attribute attr_instance_##_name = {	\
+	.attr	= {.name = __stringify(_name), .mode = _mode },	\
+	.show	= _show,					\
+	.store	= _store,					\
+};
+
+INSTANCE_ATTR(pe_count, S_IRUGO, instance_pe_count_show, NULL);
+INSTANCE_ATTR(npe_count, S_IRUGO, instance_npe_count_show, NULL);
+
+/* pci instance attributes */
+static struct instance_attribute *pci_instance_attr[] = {
+	&attr_instance_pe_count,
+	&attr_instance_npe_count,
+	NULL
+};
+
+/* the ktype for pci instance */
+static struct kobj_type ktype_pci_instance = {
+	.release = edac_pci_instance_release,
+	.sysfs_ops = &pci_instance_ops,
+	.default_attrs = (struct attribute **)pci_instance_attr,
+};
+
+static int edac_pci_create_instance_kobj(struct edac_pci_ctl_info *pci, int idx)
+{
+	int err;
+
+	pci->kobj.parent = &edac_pci_kobj;
+	pci->kobj.ktype = &ktype_pci_instance;
+
+	err = kobject_set_name(&pci->kobj, "pci%d", idx);
+	if (err)
+		return err;
+
+	err = kobject_register(&pci->kobj);
+	if (err != 0) {
+		debugf2("%s() failed to register instance pci%d\n",
+				__func__, idx);
+		return err;
+	}
+
+	debugf1("%s() Register instance 'pci%d' kobject\n", __func__, idx);
+
+	return 0;
+}
+
+static void
+edac_pci_delete_instance_kobj(struct edac_pci_ctl_info *pci, int idx)
+{
+	init_completion(&pci->kobj_complete);
+	kobject_unregister(&pci->kobj);
+	wait_for_completion(&pci->kobj_complete);
+}
 
+/***************************** EDAC PCI sysfs root **********************/
+#define to_edacpci(k) container_of(k, struct edac_pci_ctl_info, kobj)
+#define to_edacpci_attr(a) container_of(a, struct edac_pci_attr, attr)
 
 static ssize_t edac_pci_int_show(void *ptr, char *buffer)
 {
@@ -91,25 +220,34 @@ static struct edac_pci_dev_attribute eda
 };
 
 /* PCI Parity control files */
-EDAC_PCI_ATTR(check_pci_parity, S_IRUGO|S_IWUSR, edac_pci_int_show,
+EDAC_PCI_ATTR(check_pci_errors, S_IRUGO|S_IWUSR, edac_pci_int_show,
+	edac_pci_int_store);
+EDAC_PCI_ATTR(log_pci_errs, S_IRUGO|S_IWUSR, edac_pci_int_show,
 	edac_pci_int_store);
 EDAC_PCI_ATTR(panic_on_pci_parity, S_IRUGO|S_IWUSR, edac_pci_int_show,
 	edac_pci_int_store);
 EDAC_PCI_ATTR(pci_parity_count, S_IRUGO, edac_pci_int_show, NULL);
+EDAC_PCI_ATTR(pci_nonparity_count, S_IRUGO, edac_pci_int_show, NULL);
 
 /* Base Attributes of the memory ECC object */
 static struct edac_pci_dev_attribute *edac_pci_attr[] = {
-	&edac_pci_attr_check_pci_parity,
+	&edac_pci_attr_check_pci_errors,
+	&edac_pci_attr_log_pci_errs,
 	&edac_pci_attr_panic_on_pci_parity,
 	&edac_pci_attr_pci_parity_count,
+	&edac_pci_attr_pci_nonparity_count,
 	NULL,
 };
 
 /* No memory to release */
 static void edac_pci_release(struct kobject *kobj)
 {
+	struct edac_pci_ctl_info *pci;
+
+	pci = to_edacpci(kobj);
+
 	debugf1("%s()\n", __func__);
-	complete(&edac_pci_kobj_complete);
+	complete(&pci->kobj_complete);
 }
 
 static struct kobj_type ktype_edac_pci = {
@@ -124,7 +262,7 @@ static struct kobj_type ktype_edac_pci =
  *	setup the sysfs for EDAC PCI attributes
  *	assumes edac_class has already been initialized
  */
-int edac_sysfs_pci_setup(void)
+int edac_pci_register_main_kobj(void)
 {
 	int err;
 	struct sysdev_class *edac_class;
@@ -132,32 +270,39 @@ int edac_sysfs_pci_setup(void)
 	debugf1("%s()\n", __func__);
 
 	edac_class = edac_get_edac_class();
+	if (edac_class == NULL) {
+		debugf1("%s() no edac_class\n", __func__);
+		return -ENODEV;
+	}
 
-	memset(&edac_pci_kobj, 0, sizeof(edac_pci_kobj));
-	edac_pci_kobj.parent = &edac_class->kset.kobj;
 	edac_pci_kobj.ktype = &ktype_edac_pci;
+
+	edac_pci_kobj.parent = &edac_class->kset.kobj;
+
 	err = kobject_set_name(&edac_pci_kobj, "pci");
+	if(err)
+		return err;
 
-	if (!err) {
-		/* Instanstiate the pci object */
-		/* FIXME: maybe new sysdev_create_subdir() */
-		err = kobject_register(&edac_pci_kobj);
-
-		if (err)
-			debugf1("Failed to register '.../edac/pci'\n");
-		else
-			debugf1("Registered '.../edac/pci' kobject\n");
+	/* Instanstiate the pci object */
+	/* FIXME: maybe new sysdev_create_subdir() */
+	err = kobject_register(&edac_pci_kobj);
+
+	if (err) {
+		debugf1("Failed to register '.../edac/pci'\n");
+		return err;
 	}
 
-	return err;
+	debugf1("Registered '.../edac/pci' kobject\n");
+
+	return 0;
 }
 
 /*
- * edac_sysfs_pci_teardown
+ * edac_pci_unregister_main_kobj()
  *
  *	perform the sysfs teardown for the PCI attributes
  */
-void edac_sysfs_pci_teardown(void)
+void edac_pci_unregister_main_kobj(void)
 {
 	debugf0("%s()\n", __func__);
 	init_completion(&edac_pci_kobj_complete);
@@ -165,7 +310,53 @@ void edac_sysfs_pci_teardown(void)
 	wait_for_completion(&edac_pci_kobj_complete);
 }
 
+int edac_pci_create_sysfs(struct edac_pci_ctl_info *pci)
+{
+	int err;
+	struct kobject *edac_kobj = &pci->kobj;
+
+	if (atomic_inc_return(&edac_pci_sysfs_refcount) == 1) {
+		err = edac_pci_register_main_kobj();
+		if (err) {
+			atomic_dec(&edac_pci_sysfs_refcount);
+			return err;
+		}
+	}
+
+	err = edac_pci_create_instance_kobj(pci, pci->pci_idx);
+	if (err) {
+		if (atomic_dec_return(&edac_pci_sysfs_refcount) == 0)
+			edac_pci_unregister_main_kobj();
+	}
 
+
+	debugf0("%s() idx=%d\n", __func__, pci->pci_idx);
+
+	err = sysfs_create_link(edac_kobj,
+			&pci->dev->kobj,
+			EDAC_PCI_SYMLINK);
+	if (err) {
+		debugf0("%s() sysfs_create_link() returned err= %d\n",
+				__func__, err);
+		return err;
+	}
+
+	return 0;
+}
+
+void edac_pci_remove_sysfs(struct edac_pci_ctl_info *pci)
+{
+	debugf0("%s()\n", __func__);
+
+	edac_pci_delete_instance_kobj(pci, pci->pci_idx);
+
+	sysfs_remove_link(&pci->kobj, EDAC_PCI_SYMLINK);
+
+	if (atomic_dec_return(&edac_pci_sysfs_refcount) == 0)
+		edac_pci_unregister_main_kobj();
+}
+
+/************************ PCI error handling *************************/
 static u16 get_pci_parity_status(struct pci_dev *dev, int secondary)
 {
 	int where;
@@ -231,10 +422,12 @@ static void edac_pci_dev_parity_test(str
 
 	/* check the status reg for errors */
 	if (status) {
-		if (status & (PCI_STATUS_SIG_SYSTEM_ERROR))
+		if (status & (PCI_STATUS_SIG_SYSTEM_ERROR)) {
 			edac_printk(KERN_CRIT, EDAC_PCI,
 				"Signaled System Error on %s\n",
 				pci_name(dev));
+			atomic_inc(&pci_nonparity_count);
+		}
 
 		if (status & (PCI_STATUS_PARITY)) {
 			edac_printk(KERN_CRIT, EDAC_PCI,
@@ -267,10 +460,12 @@ static void edac_pci_dev_parity_test(str
 
 		/* check the secondary status reg for errors */
 		if (status) {
-			if (status & (PCI_STATUS_SIG_SYSTEM_ERROR))
+			if (status & (PCI_STATUS_SIG_SYSTEM_ERROR)) {
 				edac_printk(KERN_CRIT, EDAC_PCI, "Bridge "
 					"Signaled System Error on %s\n",
 					pci_name(dev));
+				atomic_inc(&pci_nonparity_count);
+			}
 
 			if (status & (PCI_STATUS_PARITY)) {
 				edac_printk(KERN_CRIT, EDAC_PCI, "Bridge "
@@ -321,7 +516,7 @@ void edac_pci_do_parity_check(void)
 
 	debugf3("%s()\n", __func__);
 
-	if (!check_pci_parity)
+	if (!check_pci_errors)
 		return;
 
 	before_count = atomic_read(&pci_parity_count);
@@ -348,13 +543,49 @@ void edac_pci_clear_parity_errors(void)
 	 */
 	edac_pci_dev_parity_iterator(edac_pci_dev_parity_clear);
 }
+void edac_pci_handle_pe(struct edac_pci_ctl_info *pci, const char *msg)
+{
+
+	/* global PE counter incremented by edac_pci_do_parity_check() */
+	atomic_inc(&pci->counters.pe_count);
+
+	if (log_pci_errs)
+		edac_pci_printk(pci, KERN_WARNING,
+				"Parity Error ctl: %s %d: %s\n",
+				pci->ctl_name, pci->pci_idx, msg);
+
+	/*
+	 * poke all PCI devices and see which one is the troublemaker
+	 * panic() is called if set
+	 */
+	edac_pci_do_parity_check();
+}
+EXPORT_SYMBOL_GPL(edac_pci_handle_pe);
 
+void edac_pci_handle_npe(struct edac_pci_ctl_info *pci, const char *msg)
+{
+
+	/* global NPE counter incremented by edac_pci_do_parity_check() */
+	atomic_inc(&pci->counters.npe_count);
+
+	if (log_pci_errs)
+		edac_pci_printk(pci, KERN_WARNING,
+				"Non-Parity Error ctl: %s %d: %s\n",
+				pci->ctl_name, pci->pci_idx, msg);
+
+	/*
+	 * poke all PCI devices and see which one is the troublemaker
+	 * panic() is called if set
+	 */
+	edac_pci_do_parity_check();
+}
+EXPORT_SYMBOL_GPL(edac_pci_handle_npe);
 
 /*
  * Define the PCI parameter to the module
  */
-module_param(check_pci_parity, int, 0644);
-MODULE_PARM_DESC(check_pci_parity, "Check for PCI bus parity errors: 0=off 1=on");
+module_param(check_pci_errors, int, 0644);
+MODULE_PARM_DESC(check_pci_errors, "Check for PCI bus parity errors: 0=off 1=on");
 module_param(panic_on_pci_parity, int, 0644);
 MODULE_PARM_DESC(panic_on_pci_parity, "Panic on PCI Bus Parity error: 0=off 1=on");
 
_

Patches currently in -mm which might be from djiang@mvista.com are

origin.patch

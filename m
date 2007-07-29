From: akpm@linux-foundation.org
Subject: - drivers-edac-fix-edac_pci-sysfs.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:12:18 -0700
Message-ID: <200707290612.l6T6CIlq011115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58201 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757618AbXG2GXu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: fix edac_pci sysfs
has been removed from the -mm tree.  Its filename was
     drivers-edac-fix-edac_pci-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: fix edac_pci sysfs
From: Doug Thompson <dougthompson@xmission.com>

This patch fixes sysfs exit code for the EDAC PCI device in a similiar manner
and the previous fixes for EDAC_MC and EDAC_DEVICE.

It removes the old (and incorrect) completion model and uses reference counts
on per instance kobjects and on the edac core module.

This pattern was applied to the edac_mc and edac_device code, but the EDAC PCI
code was missed.  In addition, this fixes a system hang after a low level
driver was unloaded.  (A cleanup function was called twice, which really
screwed things up)

Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by:  Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_module.h    |    6 
 drivers/edac/edac_pci.c       |  162 +++++++++++------
 drivers/edac/edac_pci_sysfs.c |  297 +++++++++++++++++++++++---------
 3 files changed, 337 insertions(+), 128 deletions(-)

diff -puN drivers/edac/edac_module.h~drivers-edac-fix-edac_pci-sysfs drivers/edac/edac_module.h
--- a/drivers/edac/edac_module.h~drivers-edac-fix-edac_pci-sysfs
+++ a/drivers/edac/edac_module.h
@@ -66,6 +66,10 @@ extern int edac_sysfs_pci_setup(void);
 extern void edac_sysfs_pci_teardown(void);
 extern int edac_pci_get_check_errors(void);
 extern int edac_pci_get_poll_msec(void);
+extern void edac_pci_remove_sysfs(struct edac_pci_ctl_info *pci);
+extern void edac_pci_handle_pe(struct edac_pci_ctl_info *pci, const char *msg);
+extern void edac_pci_handle_npe(struct edac_pci_ctl_info *pci,
+				const char *msg);
 #else				/* CONFIG_PCI */
 /* pre-process these away */
 #define edac_pci_do_parity_check()
@@ -74,6 +78,8 @@ extern int edac_pci_get_poll_msec(void);
 #define edac_sysfs_pci_teardown()
 #define edac_pci_get_check_errors()
 #define edac_pci_get_poll_msec()
+#define edac_pci_handle_pe()
+#define edac_pci_handle_npe()
 #endif				/* CONFIG_PCI */
 
 #endif				/* __EDAC_MODULE_H__ */
diff -puN drivers/edac/edac_pci.c~drivers-edac-fix-edac_pci-sysfs drivers/edac/edac_pci.c
--- a/drivers/edac/edac_pci.c~drivers-edac-fix-edac_pci-sysfs
+++ a/drivers/edac/edac_pci.c
@@ -31,20 +31,12 @@
 static DEFINE_MUTEX(edac_pci_ctls_mutex);
 static struct list_head edac_pci_list = LIST_HEAD_INIT(edac_pci_list);
 
-static inline void edac_lock_pci_list(void)
-{
-	mutex_lock(&edac_pci_ctls_mutex);
-}
-
-static inline void edac_unlock_pci_list(void)
-{
-	mutex_unlock(&edac_pci_ctls_mutex);
-}
-
 /*
- * The alloc() and free() functions for the 'edac_pci' control info
- * structure. The chip driver will allocate one of these for each
- * edac_pci it is going to control/register with the EDAC CORE.
+ * edac_pci_alloc_ctl_info
+ *
+ *	The alloc() function for the 'edac_pci' control info
+ *	structure. The chip driver will allocate one of these for each
+ *	edac_pci it is going to control/register with the EDAC CORE.
  */
 struct edac_pci_ctl_info *edac_pci_alloc_ctl_info(unsigned int sz_pvt,
 						const char *edac_pci_name)
@@ -53,47 +45,59 @@ struct edac_pci_ctl_info *edac_pci_alloc
 	void *pvt;
 	unsigned int size;
 
+	debugf1("%s()\n", __func__);
+
 	pci = (struct edac_pci_ctl_info *)0;
 	pvt = edac_align_ptr(&pci[1], sz_pvt);
 	size = ((unsigned long)pvt) + sz_pvt;
 
-	if ((pci = kzalloc(size, GFP_KERNEL)) == NULL)
+	/* Alloc the needed control struct memory */
+	pci = kzalloc(size, GFP_KERNEL);
+	if (pci  == NULL)
 		return NULL;
 
+	/* Now much private space */
 	pvt = sz_pvt ? ((char *)pci) + ((unsigned long)pvt) : NULL;
 
 	pci->pvt_info = pvt;
-
 	pci->op_state = OP_ALLOC;
 
 	snprintf(pci->name, strlen(edac_pci_name) + 1, "%s", edac_pci_name);
 
 	return pci;
 }
-
 EXPORT_SYMBOL_GPL(edac_pci_alloc_ctl_info);
 
 /*
  * edac_pci_free_ctl_info()
- * 	frees the memory allocated by edac_pci_alloc_ctl_info() function
+ *
+ *	Last action on the pci control structure.
+ *
+ *	call the remove sysfs informaton, which will unregister
+ *	this control struct's kobj. When that kobj's ref count
+ *	goes to zero, its release function will be call and then
+ *	kfree() the memory.
  */
 void edac_pci_free_ctl_info(struct edac_pci_ctl_info *pci)
 {
-	kfree(pci);
-}
+	debugf1("%s()\n", __func__);
 
+	edac_pci_remove_sysfs(pci);
+}
 EXPORT_SYMBOL_GPL(edac_pci_free_ctl_info);
 
 /*
  * find_edac_pci_by_dev()
  * 	scans the edac_pci list for a specific 'struct device *'
+ *
+ *	return NULL if not found, or return control struct pointer
  */
 static struct edac_pci_ctl_info *find_edac_pci_by_dev(struct device *dev)
 {
 	struct edac_pci_ctl_info *pci;
 	struct list_head *item;
 
-	debugf3("%s()\n", __func__);
+	debugf1("%s()\n", __func__);
 
 	list_for_each(item, &edac_pci_list) {
 		pci = list_entry(item, struct edac_pci_ctl_info, link);
@@ -118,10 +122,13 @@ static int add_edac_pci_to_global_list(s
 	struct list_head *item, *insert_before;
 	struct edac_pci_ctl_info *rover;
 
+	debugf1("%s()\n", __func__);
+
 	insert_before = &edac_pci_list;
 
 	/* Determine if already on the list */
-	if (unlikely((rover = find_edac_pci_by_dev(pci->dev)) != NULL))
+	rover = find_edac_pci_by_dev(pci->dev);
+	if (unlikely(rover != NULL))
 		goto fail0;
 
 	/* Insert in ascending order by 'pci_idx', so find position */
@@ -157,6 +164,8 @@ fail1:
 
 /*
  * complete_edac_pci_list_del
+ *
+ *	RCU completion callback to indicate item is deleted
  */
 static void complete_edac_pci_list_del(struct rcu_head *head)
 {
@@ -169,6 +178,8 @@ static void complete_edac_pci_list_del(s
 
 /*
  * del_edac_pci_from_global_list
+ *
+ *	remove the PCI control struct from the global list
  */
 static void del_edac_pci_from_global_list(struct edac_pci_ctl_info *pci)
 {
@@ -207,35 +218,52 @@ struct edac_pci_ctl_info *edac_pci_find(
 
 	return NULL;
 }
-
 EXPORT_SYMBOL_GPL(edac_pci_find);
 
 /*
  * edac_pci_workq_function()
- * 	performs the operation scheduled by a workq request
+ *
+ * 	periodic function that performs the operation
+ *	scheduled by a workq request, for a given PCI control struct
  */
 static void edac_pci_workq_function(struct work_struct *work_req)
 {
 	struct delayed_work *d_work = (struct delayed_work *)work_req;
 	struct edac_pci_ctl_info *pci = to_edac_pci_ctl_work(d_work);
+	int msec;
+	unsigned long delay;
 
-	edac_lock_pci_list();
+	debugf3("%s() checking\n", __func__);
 
-	if ((pci->op_state == OP_RUNNING_POLL) &&
-		(pci->edac_check != NULL) && (edac_pci_get_check_errors()))
-		pci->edac_check(pci);
+	mutex_lock(&edac_pci_ctls_mutex);
 
-	edac_unlock_pci_list();
+	if (pci->op_state == OP_RUNNING_POLL) {
+		/* we might be in POLL mode, but there may NOT be a poll func
+		 */
+		if ((pci->edac_check != NULL) && edac_pci_get_check_errors())
+			pci->edac_check(pci);
+
+		/* if we are on a one second period, then use round */
+		msec = edac_pci_get_poll_msec();
+		if (msec == 1000)
+			delay = round_jiffies(msecs_to_jiffies(msec));
+		else
+			delay = msecs_to_jiffies(msec);
 
-	/* Reschedule */
-	queue_delayed_work(edac_workqueue, &pci->work,
-			msecs_to_jiffies(edac_pci_get_poll_msec()));
+		/* Reschedule only if we are in POLL mode */
+		queue_delayed_work(edac_workqueue, &pci->work, delay);
+	}
+
+	mutex_unlock(&edac_pci_ctls_mutex);
 }
 
 /*
  * edac_pci_workq_setup()
  * 	initialize a workq item for this edac_pci instance
  * 	passing in the new delay period in msec
+ *
+ *	locking model:
+ *		called when 'edac_pci_ctls_mutex' is locked
  */
 static void edac_pci_workq_setup(struct edac_pci_ctl_info *pci,
 				 unsigned int msec)
@@ -255,6 +283,8 @@ static void edac_pci_workq_teardown(stru
 {
 	int status;
 
+	debugf0("%s()\n", __func__);
+
 	status = cancel_delayed_work(&pci->work);
 	if (status == 0)
 		flush_workqueue(edac_workqueue);
@@ -262,19 +292,25 @@ static void edac_pci_workq_teardown(stru
 
 /*
  * edac_pci_reset_delay_period
+ *
+ *	called with a new period value for the workq period
+ *	a) stop current workq timer
+ *	b) restart workq timer with new value
  */
 void edac_pci_reset_delay_period(struct edac_pci_ctl_info *pci,
 				 unsigned long value)
 {
-	edac_lock_pci_list();
+	debugf0("%s()\n", __func__);
 
 	edac_pci_workq_teardown(pci);
 
+	/* need to lock for the setup */
+	mutex_lock(&edac_pci_ctls_mutex);
+
 	edac_pci_workq_setup(pci, value);
 
-	edac_unlock_pci_list();
+	mutex_unlock(&edac_pci_ctls_mutex);
 }
-
 EXPORT_SYMBOL_GPL(edac_pci_reset_delay_period);
 
 /*
@@ -294,14 +330,13 @@ int edac_pci_add_device(struct edac_pci_
 	debugf0("%s()\n", __func__);
 
 	pci->pci_idx = edac_idx;
+	pci->start_time = jiffies;
 
-	edac_lock_pci_list();
+	mutex_lock(&edac_pci_ctls_mutex);
 
 	if (add_edac_pci_to_global_list(pci))
 		goto fail0;
 
-	pci->start_time = jiffies;
-
 	if (edac_pci_create_sysfs(pci)) {
 		edac_pci_printk(pci, KERN_WARNING,
 				"failed to create sysfs pci\n");
@@ -323,16 +358,16 @@ int edac_pci_add_device(struct edac_pci_
 			pci->ctl_name,
 			dev_name(pci), edac_op_state_to_string(pci->op_state));
 
-	edac_unlock_pci_list();
+	mutex_unlock(&edac_pci_ctls_mutex);
 	return 0;
 
+	/* error unwind stack */
 fail1:
 	del_edac_pci_from_global_list(pci);
 fail0:
-	edac_unlock_pci_list();
+	mutex_unlock(&edac_pci_ctls_mutex);
 	return 1;
 }
-
 EXPORT_SYMBOL_GPL(edac_pci_add_device);
 
 /*
@@ -354,22 +389,25 @@ struct edac_pci_ctl_info *edac_pci_del_d
 
 	debugf0("%s()\n", __func__);
 
-	edac_lock_pci_list();
+	mutex_lock(&edac_pci_ctls_mutex);
 
-	if ((pci = find_edac_pci_by_dev(dev)) == NULL) {
-		edac_unlock_pci_list();
+	/* ensure the control struct is on the global list
+	 * if not, then leave
+	 */
+	pci = find_edac_pci_by_dev(dev);
+	if (pci  == NULL) {
+		mutex_unlock(&edac_pci_ctls_mutex);
 		return NULL;
 	}
 
 	pci->op_state = OP_OFFLINE;
 
-	edac_pci_workq_teardown(pci);
-
-	edac_pci_remove_sysfs(pci);
-
 	del_edac_pci_from_global_list(pci);
 
-	edac_unlock_pci_list();
+	mutex_unlock(&edac_pci_ctls_mutex);
+
+	/* stop the workq timer */
+	edac_pci_workq_teardown(pci);
 
 	edac_printk(KERN_INFO, EDAC_PCI,
 		"Removed device %d for %s %s: DEV %s\n",
@@ -377,14 +415,20 @@ struct edac_pci_ctl_info *edac_pci_del_d
 
 	return pci;
 }
-
 EXPORT_SYMBOL_GPL(edac_pci_del_device);
 
+/*
+ * edac_pci_generic_check
+ *
+ *	a Generic parity check API
+ */
 void edac_pci_generic_check(struct edac_pci_ctl_info *pci)
 {
+	debugf4("%s()\n", __func__);
 	edac_pci_do_parity_check();
 }
 
+/* free running instance index counter */
 static int edac_pci_idx;
 #define EDAC_PCI_GENCTL_NAME	"EDAC PCI controller"
 
@@ -392,6 +436,17 @@ struct edac_pci_gen_data {
 	int edac_idx;
 };
 
+/*
+ * edac_pci_create_generic_ctl
+ *
+ *	A generic constructor for a PCI parity polling device
+ *	Some systems have more than one domain of PCI busses.
+ *	For systems with one domain, then this API will
+ *	provide for a generic poller.
+ *
+ *	This routine calls the edac_pci_alloc_ctl_info() for
+ *	the generic device, with default values
+ */
 struct edac_pci_ctl_info *edac_pci_create_generic_ctl(struct device *dev,
 						const char *mod_name)
 {
@@ -421,13 +476,18 @@ struct edac_pci_ctl_info *edac_pci_creat
 
 	return pci;
 }
-
 EXPORT_SYMBOL_GPL(edac_pci_create_generic_ctl);
 
+/*
+ * edac_pci_release_generic_ctl
+ *
+ *	The release function of a generic EDAC PCI polling device
+ */
 void edac_pci_release_generic_ctl(struct edac_pci_ctl_info *pci)
 {
+	debugf0("%s() pci mod=%s\n", __func__, pci->mod_name);
+
 	edac_pci_del_device(pci->dev);
 	edac_pci_free_ctl_info(pci);
 }
-
 EXPORT_SYMBOL_GPL(edac_pci_release_generic_ctl);
diff -puN drivers/edac/edac_pci_sysfs.c~drivers-edac-fix-edac_pci-sysfs drivers/edac/edac_pci_sysfs.c
--- a/drivers/edac/edac_pci_sysfs.c~drivers-edac-fix-edac_pci-sysfs
+++ a/drivers/edac/edac_pci_sysfs.c
@@ -13,22 +13,25 @@
 #include "edac_core.h"
 #include "edac_module.h"
 
+/* Turn off this whole feature if PCI is not configured */
 #ifdef CONFIG_PCI
 
 #define EDAC_PCI_SYMLINK	"device"
 
-static int check_pci_errors;	/* default YES check PCI parity */
-static int edac_pci_panic_on_pe;	/* default no panic on PCI Parity */
-static int edac_pci_log_pe = 1;	/* log PCI parity errors */
+/* data variables exported via sysfs */
+static int check_pci_errors;		/* default NO check PCI parity */
+static int edac_pci_panic_on_pe;	/* default NO panic on PCI Parity */
+static int edac_pci_log_pe = 1;		/* log PCI parity errors */
 static int edac_pci_log_npe = 1;	/* log PCI non-parity error errors */
+static int edac_pci_poll_msec = 1000;	/* one second workq period */
+
 static atomic_t pci_parity_count = ATOMIC_INIT(0);
 static atomic_t pci_nonparity_count = ATOMIC_INIT(0);
-static int edac_pci_poll_msec = 1000;
 
-static struct kobject edac_pci_kobj;	/* /sys/devices/system/edac/pci */
-static struct completion edac_pci_kobj_complete;
+static struct kobject edac_pci_top_main_kobj;
 static atomic_t edac_pci_sysfs_refcount = ATOMIC_INIT(0);
 
+/* getter functions for the data variables */
 int edac_pci_get_check_errors(void)
 {
 	return check_pci_errors;
@@ -74,17 +77,22 @@ static void edac_pci_instance_release(st
 {
 	struct edac_pci_ctl_info *pci;
 
-	debugf1("%s()\n", __func__);
+	debugf0("%s()\n", __func__);
 
+	/* Form pointer to containing struct, the pci control struct */
 	pci = to_instance(kobj);
-	complete(&pci->kobj_complete);
+
+	/* decrement reference count on top main kobj */
+	kobject_put(&edac_pci_top_main_kobj);
+
+	kfree(pci);	/* Free the control struct */
 }
 
 /* instance specific attribute structure */
 struct instance_attribute {
 	struct attribute attr;
-	 ssize_t(*show) (struct edac_pci_ctl_info *, char *);
-	 ssize_t(*store) (struct edac_pci_ctl_info *, const char *, size_t);
+	ssize_t(*show) (struct edac_pci_ctl_info *, char *);
+	ssize_t(*store) (struct edac_pci_ctl_info *, const char *, size_t);
 };
 
 /* Function to 'show' fields from the edac_pci 'instance' structure */
@@ -112,6 +120,7 @@ static ssize_t edac_pci_instance_store(s
 	return -EIO;
 }
 
+/* fs_ops table */
 static struct sysfs_ops pci_instance_ops = {
 	.show = edac_pci_instance_show,
 	.store = edac_pci_instance_store
@@ -134,48 +143,82 @@ static struct instance_attribute *pci_in
 	NULL
 };
 
-/* the ktype for pci instance */
+/* the ktype for a pci instance */
 static struct kobj_type ktype_pci_instance = {
 	.release = edac_pci_instance_release,
 	.sysfs_ops = &pci_instance_ops,
 	.default_attrs = (struct attribute **)pci_instance_attr,
 };
 
+/*
+ * edac_pci_create_instance_kobj
+ *
+ *	construct one EDAC PCI instance's kobject for use
+ */
 static int edac_pci_create_instance_kobj(struct edac_pci_ctl_info *pci, int idx)
 {
+	struct kobject *main_kobj;
 	int err;
 
-	pci->kobj.parent = &edac_pci_kobj;
+	debugf0("%s()\n", __func__);
+
+	/* Set the parent and the instance's ktype */
+	pci->kobj.parent = &edac_pci_top_main_kobj;
 	pci->kobj.ktype = &ktype_pci_instance;
 
 	err = kobject_set_name(&pci->kobj, "pci%d", idx);
 	if (err)
 		return err;
 
+	/* First bump the ref count on the top main kobj, which will
+	 * track the number of PCI instances we have, and thus nest
+	 * properly on keeping the module loaded
+	 */
+	main_kobj = kobject_get(&edac_pci_top_main_kobj);
+	if (!main_kobj) {
+		err = -ENODEV;
+		goto error_out;
+	}
+
+	/* And now register this new kobject under the main kobj */
 	err = kobject_register(&pci->kobj);
 	if (err != 0) {
 		debugf2("%s() failed to register instance pci%d\n",
 			__func__, idx);
-		return err;
+		kobject_put(&edac_pci_top_main_kobj);
+		goto error_out;
 	}
 
 	debugf1("%s() Register instance 'pci%d' kobject\n", __func__, idx);
 
 	return 0;
+
+	/* Error unwind statck */
+error_out:
+	return err;
 }
 
-static void
-edac_pci_delete_instance_kobj(struct edac_pci_ctl_info *pci, int idx)
+/*
+ * edac_pci_unregister_sysfs_instance_kobj
+ *
+ *	unregister the kobj for the EDAC PCI instance
+ */
+void edac_pci_unregister_sysfs_instance_kobj(struct edac_pci_ctl_info *pci)
 {
-	init_completion(&pci->kobj_complete);
+	debugf0("%s()\n", __func__);
+
+	/* Unregister the instance kobject and allow its release
+	 * function release the main reference count and then
+	 * kfree the memory
+	 */
 	kobject_unregister(&pci->kobj);
-	wait_for_completion(&pci->kobj_complete);
 }
 
 /***************************** EDAC PCI sysfs root **********************/
 #define to_edacpci(k) container_of(k, struct edac_pci_ctl_info, kobj)
 #define to_edacpci_attr(a) container_of(a, struct edac_pci_attr, attr)
 
+/* simple show/store functions for attributes */
 static ssize_t edac_pci_int_show(void *ptr, char *buffer)
 {
 	int *value = ptr;
@@ -267,118 +310,189 @@ static struct edac_pci_dev_attribute *ed
 	NULL,
 };
 
-/* No memory to release */
-static void edac_pci_release(struct kobject *kobj)
+/*
+ * edac_pci_release_main_kobj
+ *
+ *	This release function is called when the reference count to the
+ *	passed kobj goes to zero.
+ *
+ *	This kobj is the 'main' kobject that EDAC PCI instances
+ *	link to, and thus provide for proper nesting counts
+ */
+static void edac_pci_release_main_kobj(struct kobject *kobj)
 {
-	struct edac_pci_ctl_info *pci;
 
-	pci = to_edacpci(kobj);
+	debugf0("%s() here to module_put(THIS_MODULE)\n", __func__);
 
-	debugf1("%s()\n", __func__);
-	complete(&pci->kobj_complete);
+	/* last reference to top EDAC PCI kobject has been removed,
+	 * NOW release our ref count on the core module
+	 */
+	module_put(THIS_MODULE);
 }
 
-static struct kobj_type ktype_edac_pci = {
-	.release = edac_pci_release,
+/* ktype struct for the EDAC PCI main kobj */
+static struct kobj_type ktype_edac_pci_main_kobj = {
+	.release = edac_pci_release_main_kobj,
 	.sysfs_ops = &edac_pci_sysfs_ops,
 	.default_attrs = (struct attribute **)edac_pci_attr,
 };
 
 /**
- * edac_sysfs_pci_setup()
+ * edac_pci_main_kobj_setup()
  *
  *	setup the sysfs for EDAC PCI attributes
  *	assumes edac_class has already been initialized
  */
-int edac_pci_register_main_kobj(void)
+int edac_pci_main_kobj_setup(void)
 {
 	int err;
 	struct sysdev_class *edac_class;
 
-	debugf1("%s()\n", __func__);
+	debugf0("%s()\n", __func__);
+
+	/* check and count if we have already created the main kobject */
+	if (atomic_inc_return(&edac_pci_sysfs_refcount) != 1)
+		return 0;
 
+	/* First time, so create the main kobject and its
+	 * controls and atributes
+	 */
 	edac_class = edac_get_edac_class();
 	if (edac_class == NULL) {
 		debugf1("%s() no edac_class\n", __func__);
-		return -ENODEV;
+		err = -ENODEV;
+		goto decrement_count_fail;
 	}
 
-	edac_pci_kobj.ktype = &ktype_edac_pci;
+	/* Need the kobject hook ups, and name setting */
+	edac_pci_top_main_kobj.ktype = &ktype_edac_pci_main_kobj;
+	edac_pci_top_main_kobj.parent = &edac_class->kset.kobj;
 
-	edac_pci_kobj.parent = &edac_class->kset.kobj;
-
-	err = kobject_set_name(&edac_pci_kobj, "pci");
+	err = kobject_set_name(&edac_pci_top_main_kobj, "pci");
 	if (err)
-		return err;
+		goto decrement_count_fail;
+
+	/* Bump the reference count on this module to ensure the
+	 * modules isn't unloaded until we deconstruct the top
+	 * level main kobj for EDAC PCI
+	 */
+	if (!try_module_get(THIS_MODULE)) {
+		debugf1("%s() try_module_get() failed\n", __func__);
+		err = -ENODEV;
+		goto decrement_count_fail;
+	}
 
 	/* Instanstiate the pci object */
 	/* FIXME: maybe new sysdev_create_subdir() */
-	err = kobject_register(&edac_pci_kobj);
-
+	err = kobject_register(&edac_pci_top_main_kobj);
 	if (err) {
 		debugf1("Failed to register '.../edac/pci'\n");
-		return err;
+		goto kobject_register_fail;
 	}
 
+	/* At this point, to 'release' the top level kobject
+	 * for EDAC PCI, then edac_pci_main_kobj_teardown()
+	 * must be used, for resources to be cleaned up properly
+	 */
 	debugf1("Registered '.../edac/pci' kobject\n");
 
 	return 0;
+
+	/* Error unwind statck */
+kobject_register_fail:
+	module_put(THIS_MODULE);
+
+decrement_count_fail:
+	/* if are on this error exit, nothing to tear down */
+	atomic_dec(&edac_pci_sysfs_refcount);
+
+	return err;
 }
 
 /*
- * edac_pci_unregister_main_kobj()
+ * edac_pci_main_kobj_teardown()
  *
- *	perform the sysfs teardown for the PCI attributes
+ *	if no longer linked (needed) remove the top level EDAC PCI
+ *	kobject with its controls and attributes
  */
-void edac_pci_unregister_main_kobj(void)
+static void edac_pci_main_kobj_teardown(void)
 {
 	debugf0("%s()\n", __func__);
-	init_completion(&edac_pci_kobj_complete);
-	kobject_unregister(&edac_pci_kobj);
-	wait_for_completion(&edac_pci_kobj_complete);
+
+	/* Decrement the count and only if no more controller instances
+	 * are connected perform the unregisteration of the top level
+	 * main kobj
+	 */
+	if (atomic_dec_return(&edac_pci_sysfs_refcount) == 0) {
+		debugf0("%s() called kobject_unregister on main kobj\n",
+			__func__);
+		kobject_unregister(&edac_pci_top_main_kobj);
+	}
 }
 
+/*
+ *
+ * edac_pci_create_sysfs
+ *
+ *	Create the controls/attributes for the specified EDAC PCI device
+ */
 int edac_pci_create_sysfs(struct edac_pci_ctl_info *pci)
 {
 	int err;
 	struct kobject *edac_kobj = &pci->kobj;
 
-	if (atomic_inc_return(&edac_pci_sysfs_refcount) == 1) {
-		err = edac_pci_register_main_kobj();
-		if (err) {
-			atomic_dec(&edac_pci_sysfs_refcount);
-			return err;
-		}
-	}
+	debugf0("%s() idx=%d\n", __func__, pci->pci_idx);
 
-	err = edac_pci_create_instance_kobj(pci, pci->pci_idx);
-	if (err) {
-		if (atomic_dec_return(&edac_pci_sysfs_refcount) == 0)
-			edac_pci_unregister_main_kobj();
-	}
+	/* create the top main EDAC PCI kobject, IF needed */
+	err = edac_pci_main_kobj_setup();
+	if (err)
+		return err;
 
-	debugf0("%s() idx=%d\n", __func__, pci->pci_idx);
+	/* Create this instance's kobject under the MAIN kobject */
+	err = edac_pci_create_instance_kobj(pci, pci->pci_idx);
+	if (err)
+		goto unregister_cleanup;
 
 	err = sysfs_create_link(edac_kobj, &pci->dev->kobj, EDAC_PCI_SYMLINK);
 	if (err) {
 		debugf0("%s() sysfs_create_link() returned err= %d\n",
 			__func__, err);
-		return err;
+		goto symlink_fail;
 	}
 
 	return 0;
+
+	/* Error unwind stack */
+symlink_fail:
+	edac_pci_unregister_sysfs_instance_kobj(pci);
+
+unregister_cleanup:
+	edac_pci_main_kobj_teardown();
+
+	return err;
 }
 
+/*
+ * edac_pci_remove_sysfs
+ *
+ *	remove the controls and attributes for this EDAC PCI device
+ */
 void edac_pci_remove_sysfs(struct edac_pci_ctl_info *pci)
 {
-	debugf0("%s()\n", __func__);
-
-	edac_pci_delete_instance_kobj(pci, pci->pci_idx);
+	debugf0("%s() index=%d\n", __func__, pci->pci_idx);
 
+	/* Remove the symlink */
 	sysfs_remove_link(&pci->kobj, EDAC_PCI_SYMLINK);
 
-	if (atomic_dec_return(&edac_pci_sysfs_refcount) == 0)
-		edac_pci_unregister_main_kobj();
+	/* remove this PCI instance's sysfs entries */
+	edac_pci_unregister_sysfs_instance_kobj(pci);
+
+	/* Call the main unregister function, which will determine
+	 * if this 'pci' is the last instance.
+	 * If it is, the main kobject will be unregistered as a result
+	 */
+	debugf0("%s() calling edac_pci_main_kobj_teardown()\n", __func__);
+	edac_pci_main_kobj_teardown();
 }
 
 /************************ PCI error handling *************************/
@@ -414,13 +528,14 @@ static u16 get_pci_parity_status(struct 
 	return status;
 }
 
-typedef void (*pci_parity_check_fn_t) (struct pci_dev * dev);
 
 /* Clear any PCI parity errors logged by this device. */
 static void edac_pci_dev_parity_clear(struct pci_dev *dev)
 {
 	u8 header_type;
 
+	debugf0("%s()\n", __func__);
+
 	get_pci_parity_status(dev, 0);
 
 	/* read the device TYPE, looking for bridges */
@@ -433,17 +548,28 @@ static void edac_pci_dev_parity_clear(st
 /*
  *  PCI Parity polling
  *
+ *	Fucntion to retrieve the current parity status
+ *	and decode it
+ *
  */
 static void edac_pci_dev_parity_test(struct pci_dev *dev)
 {
+	unsigned long flags;
 	u16 status;
 	u8 header_type;
 
-	/* read the STATUS register on this device
-	 */
+	/* stop any interrupts until we can acquire the status */
+	local_irq_save(flags);
+
+	/* read the STATUS register on this device */
 	status = get_pci_parity_status(dev, 0);
 
-	debugf2("PCI STATUS= 0x%04x %s\n", status, dev->dev.bus_id);
+	/* read the device TYPE, looking for bridges */
+	pci_read_config_byte(dev, PCI_HEADER_TYPE, &header_type);
+
+	local_irq_restore(flags);
+
+	debugf4("PCI STATUS= 0x%04x %s\n", status, dev->dev.bus_id);
 
 	/* check the status reg for errors */
 	if (status) {
@@ -471,16 +597,14 @@ static void edac_pci_dev_parity_test(str
 		}
 	}
 
-	/* read the device TYPE, looking for bridges */
-	pci_read_config_byte(dev, PCI_HEADER_TYPE, &header_type);
 
-	debugf2("PCI HEADER TYPE= 0x%02x %s\n", header_type, dev->dev.bus_id);
+	debugf4("PCI HEADER TYPE= 0x%02x %s\n", header_type, dev->dev.bus_id);
 
 	if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
 		/* On bridges, need to examine secondary status register  */
 		status = get_pci_parity_status(dev, 1);
 
-		debugf2("PCI SEC_STATUS= 0x%04x %s\n", status, dev->dev.bus_id);
+		debugf4("PCI SEC_STATUS= 0x%04x %s\n", status, dev->dev.bus_id);
 
 		/* check the secondary status reg for errors */
 		if (status) {
@@ -510,9 +634,12 @@ static void edac_pci_dev_parity_test(str
 	}
 }
 
+/* reduce some complexity in definition of the iterator */
+typedef void (*pci_parity_check_fn_t) (struct pci_dev *dev);
+
 /*
  * pci_dev parity list iterator
- *	Scan the PCI device list for one iteration, looking for SERRORs
+ *	Scan the PCI device list for one pass, looking for SERRORs
  *	Master Parity ERRORS or Parity ERRORs on primary or secondary devices
  */
 static inline void edac_pci_dev_parity_iterator(pci_parity_check_fn_t fn)
@@ -535,22 +662,22 @@ static inline void edac_pci_dev_parity_i
  */
 void edac_pci_do_parity_check(void)
 {
-	unsigned long flags;
 	int before_count;
 
 	debugf3("%s()\n", __func__);
 
+	/* if policy has PCI check off, leave now */
 	if (!check_pci_errors)
 		return;
 
 	before_count = atomic_read(&pci_parity_count);
 
 	/* scan all PCI devices looking for a Parity Error on devices and
-	 * bridges
+	 * bridges.
+	 * The iterator calls pci_get_device() which might sleep, thus
+	 * we cannot disable interrupts in this scan.
 	 */
-	local_irq_save(flags);
 	edac_pci_dev_parity_iterator(edac_pci_dev_parity_test);
-	local_irq_restore(flags);
 
 	/* Only if operator has selected panic on PCI Error */
 	if (edac_pci_get_panic_on_pe()) {
@@ -560,6 +687,12 @@ void edac_pci_do_parity_check(void)
 	}
 }
 
+/*
+ * edac_pci_clear_parity_errors
+ *
+ *	function to perform an iteration over the PCI devices
+ *	and clearn their current status
+ */
 void edac_pci_clear_parity_errors(void)
 {
 	/* Clear any PCI bus parity errors that devices initially have logged
@@ -567,6 +700,12 @@ void edac_pci_clear_parity_errors(void)
 	 */
 	edac_pci_dev_parity_iterator(edac_pci_dev_parity_clear);
 }
+
+/*
+ * edac_pci_handle_pe
+ *
+ *	Called to handle a PARITY ERROR event
+ */
 void edac_pci_handle_pe(struct edac_pci_ctl_info *pci, const char *msg)
 {
 
@@ -584,9 +723,14 @@ void edac_pci_handle_pe(struct edac_pci_
 	 */
 	edac_pci_do_parity_check();
 }
-
 EXPORT_SYMBOL_GPL(edac_pci_handle_pe);
 
+
+/*
+ * edac_pci_handle_npe
+ *
+ *	Called to handle a NON-PARITY ERROR event
+ */
 void edac_pci_handle_npe(struct edac_pci_ctl_info *pci, const char *msg)
 {
 
@@ -604,7 +748,6 @@ void edac_pci_handle_npe(struct edac_pci
 	 */
 	edac_pci_do_parity_check();
 }
-
 EXPORT_SYMBOL_GPL(edac_pci_handle_npe);
 
 /*
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch

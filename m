From: akpm@linux-foundation.org
Subject: + drivers-edac-fix-edac_mc-sysfs-completion-code.patch added to -mm tree
Date: Fri, 13 Jul 2007 11:30:49 -0700
Message-ID: <200707131830.l6DIUn63011041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52456 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757971AbXGMSbb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 14:31:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com, greg@kroah.com


The patch titled
     drivers edac: fix edac_mc sysfs completion code
has been added to the -mm tree.  Its filename is
     drivers-edac-fix-edac_mc-sysfs-completion-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers edac: fix edac_mc sysfs completion code
From: Doug Thompson <dougthompson@xmission.com>

This patch refactors the 'releasing' of kobjects for the edac_mc type of
device.  The correct pattern of kobject release is followed.

As internal kobjs are allocated they bump a ref count on the top level kobj. 
It in turn has a module ref count on the edac_core module.  When internal
kobjects are released, they dec the ref count on the top level kobj.  When the
top level kobj reaches zero, it decrements the ref count on the edac_core
object, allow it to be unloaded, as all resources have all now been released.

Cc: Alan Cox alan@lxorguk.ukuu.org.uk
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h     |    4 
 drivers/edac/edac_mc.c       |   36 +-
 drivers/edac/edac_mc_sysfs.c |  568 ++++++++++++++++++++-------------
 drivers/edac/edac_module.c   |   32 -
 drivers/edac/edac_module.h   |    8 
 5 files changed, 399 insertions(+), 249 deletions(-)

diff -puN drivers/edac/edac_core.h~drivers-edac-fix-edac_mc-sysfs-completion-code drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~drivers-edac-fix-edac_mc-sysfs-completion-code
+++ a/drivers/edac/edac_core.h
@@ -317,9 +317,8 @@ struct csrow_info {
 	struct mem_ctl_info *mci;	/* the parent */
 
 	struct kobject kobj;	/* sysfs kobject for this csrow */
-	struct completion kobj_complete;
 
-	/* FIXME the number of CHANNELs might need to become dynamic */
+	/* channel information for this csrow */
 	u32 nr_channels;
 	struct channel_info *channels;
 };
@@ -403,7 +402,6 @@ struct mem_ctl_info {
 
 	/* edac sysfs device control */
 	struct kobject edac_mci_kobj;
-	struct completion kobj_complete;
 
 	/* Additional top controller level attributes, but specified
 	 * by the low level driver.
diff -puN drivers/edac/edac_mc.c~drivers-edac-fix-edac_mc-sysfs-completion-code drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~drivers-edac-fix-edac_mc-sysfs-completion-code
+++ a/drivers/edac/edac_mc.c
@@ -137,6 +137,7 @@ struct mem_ctl_info *edac_mc_alloc(unsig
 	void *pvt;
 	unsigned size;
 	int row, chn;
+	int err;
 
 	/* Figure out the offsets of the various items from the start of an mc
 	 * structure.  We want the alignment of each item to be at least as
@@ -149,7 +150,8 @@ struct mem_ctl_info *edac_mc_alloc(unsig
 	pvt = edac_align_ptr(&chi[nr_chans * nr_csrows], sz_pvt);
 	size = ((unsigned long)pvt) + sz_pvt;
 
-	if ((mci = kmalloc(size, GFP_KERNEL)) == NULL)
+	mci = kzalloc(size, GFP_KERNEL);
+	if (mci == NULL)
 		return NULL;
 
 	/* Adjust pointers so they point within the memory we just allocated
@@ -182,20 +184,34 @@ struct mem_ctl_info *edac_mc_alloc(unsig
 
 	mci->op_state = OP_ALLOC;
 
+	/*
+	 * Initialize the 'root' kobj for the edac_mc controller
+	 */
+	err = edac_mc_register_sysfs_main_kobj(mci);
+	if (err) {
+		kfree(mci);
+		return NULL;
+	}
+
+	/* at this point, the root kobj is valid, and in order to
+	 * 'free' the object, then the function:
+	 *      edac_mc_unregister_sysfs_main_kobj() must be called
+	 * which will perform kobj unregistration and the actual free
+	 * will occur during the kobject callback operation
+	 */
 	return mci;
 }
-
 EXPORT_SYMBOL_GPL(edac_mc_alloc);
 
 /**
- * edac_mc_free:  Free a previously allocated 'mci' structure
+ * edac_mc_free
+ *	'Free' a previously allocated 'mci' structure
  * @mci: pointer to a struct mem_ctl_info structure
  */
 void edac_mc_free(struct mem_ctl_info *mci)
 {
-	kfree(mci);
+	edac_mc_unregister_sysfs_main_kobj(mci);
 }
-
 EXPORT_SYMBOL_GPL(edac_mc_free);
 
 static struct mem_ctl_info *find_mci_by_dev(struct device *dev)
@@ -391,7 +407,6 @@ struct mem_ctl_info *edac_mc_find(int id
 
 	return NULL;
 }
-
 EXPORT_SYMBOL(edac_mc_find);
 
 /**
@@ -465,7 +480,6 @@ fail0:
 	mutex_unlock(&mem_ctls_mutex);
 	return 1;
 }
-
 EXPORT_SYMBOL_GPL(edac_mc_add_mc);
 
 /**
@@ -501,7 +515,6 @@ struct mem_ctl_info *edac_mc_del_mc(stru
 		mci->mod_name, mci->ctl_name, dev_name(mci));
 	return mci;
 }
-
 EXPORT_SYMBOL_GPL(edac_mc_del_mc);
 
 static void edac_mc_scrub_block(unsigned long page, unsigned long offset,
@@ -571,7 +584,6 @@ int edac_mc_find_csrow_by_page(struct me
 
 	return row;
 }
-
 EXPORT_SYMBOL_GPL(edac_mc_find_csrow_by_page);
 
 /* FIXME - setable log (warning/emerg) levels */
@@ -636,7 +648,6 @@ void edac_mc_handle_ce(struct mem_ctl_in
 				mci->csrows[row].grain);
 	}
 }
-
 EXPORT_SYMBOL_GPL(edac_mc_handle_ce);
 
 void edac_mc_handle_ce_no_info(struct mem_ctl_info *mci, const char *msg)
@@ -648,7 +659,6 @@ void edac_mc_handle_ce_no_info(struct me
 	mci->ce_noinfo_count++;
 	mci->ce_count++;
 }
-
 EXPORT_SYMBOL_GPL(edac_mc_handle_ce_no_info);
 
 void edac_mc_handle_ue(struct mem_ctl_info *mci,
@@ -702,7 +712,6 @@ void edac_mc_handle_ue(struct mem_ctl_in
 	mci->ue_count++;
 	mci->csrows[row].ue_count++;
 }
-
 EXPORT_SYMBOL_GPL(edac_mc_handle_ue);
 
 void edac_mc_handle_ue_no_info(struct mem_ctl_info *mci, const char *msg)
@@ -716,7 +725,6 @@ void edac_mc_handle_ue_no_info(struct me
 	mci->ue_noinfo_count++;
 	mci->ue_count++;
 }
-
 EXPORT_SYMBOL_GPL(edac_mc_handle_ue_no_info);
 
 /*************************************************************
@@ -784,7 +792,6 @@ void edac_mc_handle_fbd_ue(struct mem_ct
 			"labels \"%s\": %s\n", csrow, channela,
 			channelb, labels, msg);
 }
-
 EXPORT_SYMBOL(edac_mc_handle_fbd_ue);
 
 /*************************************************************
@@ -824,7 +831,6 @@ void edac_mc_handle_fbd_ce(struct mem_ct
 	mci->csrows[csrow].ce_count++;
 	mci->csrows[csrow].channels[channel].ce_count++;
 }
-
 EXPORT_SYMBOL(edac_mc_handle_fbd_ce);
 
 /*
diff -puN drivers/edac/edac_mc_sysfs.c~drivers-edac-fix-edac_mc-sysfs-completion-code drivers/edac/edac_mc_sysfs.c
--- a/drivers/edac/edac_mc_sysfs.c~drivers-edac-fix-edac_mc-sysfs-completion-code
+++ a/drivers/edac/edac_mc_sysfs.c
@@ -10,10 +10,12 @@
  */
 
 #include <linux/ctype.h>
+#include <linux/bug.h>
 
 #include "edac_core.h"
 #include "edac_module.h"
 
+
 /* MC EDAC Controls, setable by module parameter, and sysfs */
 static int edac_mc_log_ue = 1;
 static int edac_mc_log_ce = 1;
@@ -98,15 +100,7 @@ static const char *edac_caps[] = {
 	[EDAC_S16ECD16ED] = "S16ECD16ED"
 };
 
-/* sysfs object:
- *	/sys/devices/system/edac/mc
- */
-static struct kobject edac_memctrl_kobj;
 
-/* We use these to wait for the reference counts on edac_memctrl_kobj and
- * edac_pci_kobj to reach 0.
- */
-static struct completion edac_memctrl_kobj_complete;
 
 /*
  * /sys/devices/system/edac/mc;
@@ -128,153 +122,6 @@ static ssize_t memctrl_int_store(void *p
 	return count;
 }
 
-struct memctrl_dev_attribute {
-	struct attribute attr;
-	void *value;
-	 ssize_t(*show) (void *, char *);
-	 ssize_t(*store) (void *, const char *, size_t);
-};
-
-/* Set of show/store abstract level functions for memory control object */
-static ssize_t memctrl_dev_show(struct kobject *kobj,
-				struct attribute *attr, char *buffer)
-{
-	struct memctrl_dev_attribute *memctrl_dev;
-	memctrl_dev = (struct memctrl_dev_attribute *)attr;
-
-	if (memctrl_dev->show)
-		return memctrl_dev->show(memctrl_dev->value, buffer);
-
-	return -EIO;
-}
-
-static ssize_t memctrl_dev_store(struct kobject *kobj, struct attribute *attr,
-				 const char *buffer, size_t count)
-{
-	struct memctrl_dev_attribute *memctrl_dev;
-	memctrl_dev = (struct memctrl_dev_attribute *)attr;
-
-	if (memctrl_dev->store)
-		return memctrl_dev->store(memctrl_dev->value, buffer, count);
-
-	return -EIO;
-}
-
-static struct sysfs_ops memctrlfs_ops = {
-	.show = memctrl_dev_show,
-	.store = memctrl_dev_store
-};
-
-#define MEMCTRL_ATTR(_name,_mode,_show,_store)			\
-static struct memctrl_dev_attribute attr_##_name = {			\
-	.attr = {.name = __stringify(_name), .mode = _mode },	\
-	.value  = &_name,					\
-	.show   = _show,					\
-	.store  = _store,					\
-};
-
-#define MEMCTRL_STRING_ATTR(_name,_data,_mode,_show,_store)	\
-static struct memctrl_dev_attribute attr_##_name = {			\
-	.attr = {.name = __stringify(_name), .mode = _mode },	\
-	.value  = _data,					\
-	.show   = _show,					\
-	.store  = _store,					\
-};
-
-/* csrow<id> control files */
-MEMCTRL_ATTR(edac_mc_panic_on_ue,
-	S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
-
-MEMCTRL_ATTR(edac_mc_log_ue,
-	S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
-
-MEMCTRL_ATTR(edac_mc_log_ce,
-	S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
-
-MEMCTRL_ATTR(edac_mc_poll_msec,
-	S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
-
-/* Base Attributes of the memory ECC object */
-static struct memctrl_dev_attribute *memctrl_attr[] = {
-	&attr_edac_mc_panic_on_ue,
-	&attr_edac_mc_log_ue,
-	&attr_edac_mc_log_ce,
-	&attr_edac_mc_poll_msec,
-	NULL,
-};
-
-/* Main MC kobject release() function */
-static void edac_memctrl_master_release(struct kobject *kobj)
-{
-	debugf1("%s()\n", __func__);
-	complete(&edac_memctrl_kobj_complete);
-}
-
-static struct kobj_type ktype_memctrl = {
-	.release = edac_memctrl_master_release,
-	.sysfs_ops = &memctrlfs_ops,
-	.default_attrs = (struct attribute **)memctrl_attr,
-};
-
-/* Initialize the main sysfs entries for edac:
- *   /sys/devices/system/edac
- *
- * and children
- *
- * Return:  0 SUCCESS
- *         !0 FAILURE
- */
-int edac_sysfs_memctrl_setup(void)
-{
-	int err = 0;
-	struct sysdev_class *edac_class;
-
-	debugf1("%s()\n", __func__);
-
-	/* get the /sys/devices/system/edac class reference */
-	edac_class = edac_get_edac_class();
-	if (edac_class == NULL) {
-		debugf1("%s() no edac_class error=%d\n", __func__, err);
-		return err;
-	}
-
-	/* Init the MC's kobject */
-	memset(&edac_memctrl_kobj, 0, sizeof(edac_memctrl_kobj));
-	edac_memctrl_kobj.parent = &edac_class->kset.kobj;
-	edac_memctrl_kobj.ktype = &ktype_memctrl;
-
-	/* generate sysfs "..../edac/mc"   */
-	err = kobject_set_name(&edac_memctrl_kobj, "mc");
-	if (err) {
-		debugf1("%s() Failed to set name '.../edac/mc'\n", __func__);
-		return err;
-	}
-
-	/* FIXME: maybe new sysdev_create_subdir() */
-	err = kobject_register(&edac_memctrl_kobj);
-	if (err) {
-		debugf1("%s() Failed to register '.../edac/mc'\n", __func__);
-		return err;
-	}
-
-	debugf1("%s() Registered '.../edac/mc' kobject\n", __func__);
-	return 0;
-}
-
-/*
- * MC teardown:
- *	the '..../edac/mc' kobject followed by '..../edac' itself
- */
-void edac_sysfs_memctrl_teardown(void)
-{
-	debugf0("MC: " __FILE__ ": %s()\n", __func__);
-
-	/* Unregister the MC's kobject and wait for reference count to reach 0.
-	 */
-	init_completion(&edac_memctrl_kobj_complete);
-	kobject_unregister(&edac_memctrl_kobj);
-	wait_for_completion(&edac_memctrl_kobj_complete);
-}
 
 /* EDAC sysfs CSROW data structures and methods
  */
@@ -486,10 +333,15 @@ static int edac_create_channel_files(str
 /* No memory to release for this kobj */
 static void edac_csrow_instance_release(struct kobject *kobj)
 {
+	struct mem_ctl_info *mci;
 	struct csrow_info *cs;
 
+	debugf1("%s()\n", __func__);
+
 	cs = container_of(kobj, struct csrow_info, kobj);
-	complete(&cs->kobj_complete);
+	mci = cs->mci;
+
+	kobject_put(&mci->edac_mci_kobj);
 }
 
 /* the kobj_type instance for a CSROW */
@@ -500,38 +352,61 @@ static struct kobj_type ktype_csrow = {
 };
 
 /* Create a CSROW object under specifed edac_mc_device */
-static int edac_create_csrow_object(struct kobject *edac_mci_kobj,
-				struct csrow_info *csrow, int index)
+static int edac_create_csrow_object(struct mem_ctl_info *mci,
+					struct csrow_info *csrow, int index)
 {
-	int err = 0;
+	struct kobject *kobj_mci = &mci->edac_mci_kobj;
+	struct kobject *kobj;
 	int chan;
-
-	memset(&csrow->kobj, 0, sizeof(csrow->kobj));
+	int err;
 
 	/* generate ..../edac/mc/mc<id>/csrow<index>   */
-
-	csrow->kobj.parent = edac_mci_kobj;
+	memset(&csrow->kobj, 0, sizeof(csrow->kobj));
+	csrow->mci = mci;	/* include container up link */
+	csrow->kobj.parent = kobj_mci;
 	csrow->kobj.ktype = &ktype_csrow;
 
 	/* name this instance of csrow<id> */
 	err = kobject_set_name(&csrow->kobj, "csrow%d", index);
 	if (err)
-		goto error_exit;
+		goto err_out;
+
+	/* bump the mci instance's kobject's ref count */
+	kobj = kobject_get(&mci->edac_mci_kobj);
+	if (!kobj) {
+		err = -ENODEV;
+		goto err_out;
+	}
 
 	/* Instanstiate the csrow object */
 	err = kobject_register(&csrow->kobj);
-	if (!err) {
-		/* Create the dyanmic attribute files on this csrow,
-		 * namely, the DIMM labels and the channel ce_count
-		 */
-		for (chan = 0; chan < csrow->nr_channels; chan++) {
-			err = edac_create_channel_files(&csrow->kobj, chan);
-			if (err)
-				break;
+	if (err)
+		goto err_release_top_kobj;
+
+	/* At this point, to release a csrow kobj, one must
+	 * call the kobject_unregister and allow that tear down
+	 * to work the releasing
+	 */
+
+	/* Create the dyanmic attribute files on this csrow,
+	 * namely, the DIMM labels and the channel ce_count
+	 */
+	for (chan = 0; chan < csrow->nr_channels; chan++) {
+		err = edac_create_channel_files(&csrow->kobj, chan);
+		if (err) {
+			/* special case the unregister here */
+			kobject_unregister(&csrow->kobj);
+			goto err_out;
 		}
 	}
 
-error_exit:
+	return 0;
+
+	/* error unwind stack */
+err_release_top_kobj:
+	kobject_put(&mci->edac_mci_kobj);
+
+err_out:
 	return err;
 }
 
@@ -688,6 +563,7 @@ static ssize_t mcidev_store(struct kobje
 	return -EIO;
 }
 
+/* Intermediate show/store table */
 static struct sysfs_ops mci_ops = {
 	.show = mcidev_show,
 	.store = mcidev_store
@@ -729,32 +605,213 @@ static struct mcidev_sysfs_attribute *mc
 	NULL
 };
 
+
 /*
  * Release of a MC controlling instance
+ *
+ *	each MC control instance has the following resources upon entry:
+ *		a) a ref count on the top memctl kobj
+ *		b) a ref count on this module
+ *
+ *	this function must decrement those ref counts and then
+ *	issue a free on the instance's memory
  */
-static void edac_mci_instance_release(struct kobject *kobj)
+static void edac_mci_control_release(struct kobject *kobj)
 {
 	struct mem_ctl_info *mci;
 
 	mci = to_mci(kobj);
-	debugf0("%s() idx=%d\n", __func__, mci->mc_idx);
-	complete(&mci->kobj_complete);
+
+	debugf0("%s() mci instance idx=%d releasing\n", __func__, mci->mc_idx);
+
+	/* decrement the module ref count */
+	module_put(mci->owner);
+
+	/* free the mci instance memory here */
+	kfree(mci);
 }
 
 static struct kobj_type ktype_mci = {
-	.release = edac_mci_instance_release,
+	.release = edac_mci_control_release,
 	.sysfs_ops = &mci_ops,
 	.default_attrs = (struct attribute **)mci_attr,
 };
 
+/* show/store, tables, etc for the MC kset */
+
+
+struct memctrl_dev_attribute {
+	struct attribute attr;
+	void *value;
+	 ssize_t(*show) (void *, char *);
+	 ssize_t(*store) (void *, const char *, size_t);
+};
+
+/* Set of show/store abstract level functions for memory control object */
+static ssize_t memctrl_dev_show(struct kobject *kobj,
+				struct attribute *attr, char *buffer)
+{
+	struct memctrl_dev_attribute *memctrl_dev;
+	memctrl_dev = (struct memctrl_dev_attribute *)attr;
+
+	if (memctrl_dev->show)
+		return memctrl_dev->show(memctrl_dev->value, buffer);
+
+	return -EIO;
+}
+
+static ssize_t memctrl_dev_store(struct kobject *kobj, struct attribute *attr,
+				 const char *buffer, size_t count)
+{
+	struct memctrl_dev_attribute *memctrl_dev;
+	memctrl_dev = (struct memctrl_dev_attribute *)attr;
+
+	if (memctrl_dev->store)
+		return memctrl_dev->store(memctrl_dev->value, buffer, count);
+
+	return -EIO;
+}
+
+static struct sysfs_ops memctrlfs_ops = {
+	.show = memctrl_dev_show,
+	.store = memctrl_dev_store
+};
+
+#define MEMCTRL_ATTR(_name, _mode, _show, _store)			\
+static struct memctrl_dev_attribute attr_##_name = {			\
+	.attr = {.name = __stringify(_name), .mode = _mode },	\
+	.value  = &_name,					\
+	.show   = _show,					\
+	.store  = _store,					\
+};
+
+#define MEMCTRL_STRING_ATTR(_name, _data, _mode, _show, _store)	\
+static struct memctrl_dev_attribute attr_##_name = {			\
+	.attr = {.name = __stringify(_name), .mode = _mode },	\
+	.value  = _data,					\
+	.show   = _show,					\
+	.store  = _store,					\
+};
+
+/* csrow<id> control files */
+MEMCTRL_ATTR(edac_mc_panic_on_ue,
+	S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
+
+MEMCTRL_ATTR(edac_mc_log_ue,
+	S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
+
+MEMCTRL_ATTR(edac_mc_log_ce,
+	S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
+
+MEMCTRL_ATTR(edac_mc_poll_msec,
+	S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
+
+/* Base Attributes of the memory ECC object */
+static struct memctrl_dev_attribute *memctrl_attr[] = {
+	&attr_edac_mc_panic_on_ue,
+	&attr_edac_mc_log_ue,
+	&attr_edac_mc_log_ce,
+	&attr_edac_mc_poll_msec,
+	NULL,
+};
+
+
+/* the ktype for the mc_kset internal kobj */
+static struct kobj_type ktype_mc_set_attribs = {
+	.sysfs_ops = &memctrlfs_ops,
+	.default_attrs = (struct attribute **)memctrl_attr,
+};
+
+/* EDAC memory controller sysfs kset:
+ *	/sys/devices/system/edac/mc
+ */
+static struct kset mc_kset = {
+	.kobj = {.name = "mc", .ktype = &ktype_mc_set_attribs },
+	.ktype = &ktype_mci,
+};
+
+
+/*
+ * edac_mc_register_sysfs_main_kobj
+ *
+ *	setups and registers the main kobject for each mci
+ */
+int edac_mc_register_sysfs_main_kobj(struct mem_ctl_info *mci)
+{
+	struct kobject *kobj_mci;
+	int err;
+
+	debugf1("%s()\n", __func__);
+
+	kobj_mci = &mci->edac_mci_kobj;
+
+	/* Init the mci's kobject */
+	memset(kobj_mci, 0, sizeof(*kobj_mci));
+
+	/* this instance become part of the mc_kset */
+	kobj_mci->kset = &mc_kset;
+
+	/* set the name of the mc<id> object */
+	err = kobject_set_name(kobj_mci, "mc%d", mci->mc_idx);
+	if (err)
+		goto fail_out;
+
+	/* Record which module 'owns' this control structure
+	 * and bump the ref count of the module
+	 */
+	mci->owner = THIS_MODULE;
+
+	/* bump ref count on this module */
+	if (!try_module_get(mci->owner)) {
+		err = -ENODEV;
+		goto fail_out;
+	}
+
+	/* register the mc<id> kobject to the mc_kset */
+	err = kobject_register(kobj_mci);
+	if (err) {
+		debugf1("%s()Failed to register '.../edac/mc%d'\n",
+			__func__, mci->mc_idx);
+		goto kobj_reg_fail;
+	}
+
+	/* At this point, to 'free' the control struct,
+	 * edac_mc_unregister_sysfs_main_kobj() must be used
+	 */
+
+	debugf1("%s() Registered '.../edac/mc%d' kobject\n",
+		__func__, mci->mc_idx);
+
+	return 0;
+
+	/* Error exit stack */
+
+kobj_reg_fail:
+	module_put(mci->owner);
+
+fail_out:
+	return err;
+}
+
+/*
+ * edac_mc_register_sysfs_main_kobj
+ *
+ *	tears down and the main mci kobject from the mc_kset
+ */
+void edac_mc_unregister_sysfs_main_kobj(struct mem_ctl_info *mci)
+{
+	/* delete the kobj from the mc_kset */
+	kobject_unregister(&mci->edac_mci_kobj);
+}
+
 #define EDAC_DEVICE_SYMLINK	"device"
 
 /*
- * edac_create_driver_attributes
+ * edac_create_mci_instance_attributes
  *	create MC driver specific attributes at the topmost level
  *	directory of this mci instance.
  */
-static int edac_create_driver_attributes(struct mem_ctl_info *mci)
+static int edac_create_mci_instance_attributes(struct mem_ctl_info *mci)
 {
 	int err;
 	struct mcidev_sysfs_attribute *sysfs_attrib;
@@ -764,7 +821,7 @@ static int edac_create_driver_attributes
 	 */
 	sysfs_attrib = mci->mc_driver_sysfs_attributes;
 
-	while (sysfs_attrib->attr.name != NULL) {
+	while (sysfs_attrib && sysfs_attrib->attr.name) {
 		err = sysfs_create_file(&mci->edac_mci_kobj,
 					(struct attribute*) sysfs_attrib);
 		if (err) {
@@ -778,6 +835,29 @@ static int edac_create_driver_attributes
 }
 
 /*
+ * edac_remove_mci_instance_attributes
+ *	remove MC driver specific attributes at the topmost level
+ *	directory of this mci instance.
+ */
+static void edac_remove_mci_instance_attributes(struct mem_ctl_info *mci)
+{
+	struct mcidev_sysfs_attribute *sysfs_attrib;
+
+	/* point to the start of the array and iterate over it
+	 * adding each attribute listed to this mci instance's kobject
+	 */
+	sysfs_attrib = mci->mc_driver_sysfs_attributes;
+
+	/* loop if there are attributes and until we hit a NULL entry */
+	while (sysfs_attrib && sysfs_attrib->attr.name) {
+		sysfs_remove_file(&mci->edac_mci_kobj,
+					(struct attribute *) sysfs_attrib);
+		sysfs_attrib++;
+	}
+}
+
+
+/*
  * Create a new Memory Controller kobject instance,
  *	mc<id> under the 'mc' directory
  *
@@ -790,51 +870,43 @@ int edac_create_sysfs_mci_device(struct 
 	int i;
 	int err;
 	struct csrow_info *csrow;
-	struct kobject *edac_mci_kobj = &mci->edac_mci_kobj;
+	struct kobject *kobj_mci = &mci->edac_mci_kobj;
 
 	debugf0("%s() idx=%d\n", __func__, mci->mc_idx);
-	memset(edac_mci_kobj, 0, sizeof(*edac_mci_kobj));
-
-	/* set the name of the mc<id> object */
-	err = kobject_set_name(edac_mci_kobj, "mc%d", mci->mc_idx);
-	if (err)
-		return err;
-
-	/* link to our parent the '..../edac/mc' object */
-	edac_mci_kobj->parent = &edac_memctrl_kobj;
-	edac_mci_kobj->ktype = &ktype_mci;
-
-	/* register the mc<id> kobject */
-	err = kobject_register(edac_mci_kobj);
-	if (err)
-		return err;
 
 	/* create a symlink for the device */
-	err = sysfs_create_link(edac_mci_kobj, &mci->dev->kobj,
+	err = sysfs_create_link(kobj_mci, &mci->dev->kobj,
 				EDAC_DEVICE_SYMLINK);
-	if (err)
+	if (err) {
+		debugf1("%s() failure to create symlink\n", __func__);
 		goto fail0;
+	}
 
 	/* If the low level driver desires some attributes,
 	 * then create them now for the driver.
 	 */
 	if (mci->mc_driver_sysfs_attributes) {
-		err = edac_create_driver_attributes(mci);
-		if (err)
+		err = edac_create_mci_instance_attributes(mci);
+		if (err) {
+			debugf1("%s() failure to create mci attributes\n",
+				__func__);
 			goto fail0;
+		}
 	}
 
-	/* Make directories for each CSROW object
-	 * under the mc<id> kobject
+	/* Make directories for each CSROW object under the mc<id> kobject
 	 */
 	for (i = 0; i < mci->nr_csrows; i++) {
 		csrow = &mci->csrows[i];
 
 		/* Only expose populated CSROWs */
 		if (csrow->nr_pages > 0) {
-			err = edac_create_csrow_object(edac_mci_kobj, csrow, i);
-			if (err)
+			err = edac_create_csrow_object(mci, csrow, i);
+			if (err) {
+				debugf1("%s() failure: create csrow %d obj\n",
+					__func__, i);
 				goto fail1;
+			}
 		}
 	}
 
@@ -844,16 +916,17 @@ int edac_create_sysfs_mci_device(struct 
 fail1:
 	for (i--; i >= 0; i--) {
 		if (csrow->nr_pages > 0) {
-			init_completion(&csrow->kobj_complete);
 			kobject_unregister(&mci->csrows[i].kobj);
-			wait_for_completion(&csrow->kobj_complete);
 		}
 	}
 
+	/* remove the mci instance's attributes, if any */
+	edac_remove_mci_instance_attributes(mci);
+
+	/* remove the symlink */
+	sysfs_remove_link(kobj_mci, EDAC_DEVICE_SYMLINK);
+
 fail0:
-	init_completion(&mci->kobj_complete);
-	kobject_unregister(edac_mci_kobj);
-	wait_for_completion(&mci->kobj_complete);
 	return err;
 }
 
@@ -869,14 +942,83 @@ void edac_remove_sysfs_mci_device(struct
 	/* remove all csrow kobjects */
 	for (i = 0; i < mci->nr_csrows; i++) {
 		if (mci->csrows[i].nr_pages > 0) {
-			init_completion(&mci->csrows[i].kobj_complete);
+			debugf0("%s()  unreg csrow-%d\n", __func__, i);
 			kobject_unregister(&mci->csrows[i].kobj);
-			wait_for_completion(&mci->csrows[i].kobj_complete);
 		}
 	}
 
+	debugf0("%s()  remove_link\n", __func__);
+
+	/* remove the symlink */
 	sysfs_remove_link(&mci->edac_mci_kobj, EDAC_DEVICE_SYMLINK);
-	init_completion(&mci->kobj_complete);
+
+	debugf0("%s()  remove_mci_instance\n", __func__);
+
+	/* remove this mci instance's attribtes */
+	edac_remove_mci_instance_attributes(mci);
+
+	debugf0("%s()  unregister this mci kobj\n", __func__);
+
+	/* unregister this instance's kobject */
 	kobject_unregister(&mci->edac_mci_kobj);
-	wait_for_completion(&mci->kobj_complete);
 }
+
+
+
+
+/*
+ * edac_setup_sysfs_mc_kset(void)
+ *
+ * Initialize the mc_kset for the 'mc' entry
+ *	This requires creating the top 'mc' directory with a kset
+ *	and its controls/attributes.
+ *
+ *	To this 'mc' kset, instance 'mci' will be grouped as children.
+ *
+ * Return:  0 SUCCESS
+ *         !0 FAILURE error code
+ */
+int edac_sysfs_setup_mc_kset(void)
+{
+	int err = 0;
+	struct sysdev_class *edac_class;
+
+	debugf1("%s()\n", __func__);
+
+	/* get the /sys/devices/system/edac class reference */
+	edac_class = edac_get_edac_class();
+	if (edac_class == NULL) {
+		debugf1("%s() no edac_class error=%d\n", __func__, err);
+		goto fail_out;
+	}
+
+	/* Init the MC's kobject */
+	mc_kset.kobj.parent = &edac_class->kset.kobj;
+
+	/* register the mc_kset */
+	err = kset_register(&mc_kset);
+	if (err) {
+		debugf1("%s() Failed to register '.../edac/mc'\n", __func__);
+		goto fail_out;
+	}
+
+	debugf1("%s() Registered '.../edac/mc' kobject\n", __func__);
+
+	return 0;
+
+
+	/* error unwind stack */
+fail_out:
+	return err;
+}
+
+/*
+ * edac_sysfs_teardown_mc_kset
+ *
+ *	deconstruct the mc_ket for memory controllers
+ */
+void edac_sysfs_teardown_mc_kset(void)
+{
+	kset_unregister(&mc_kset);
+}
+
diff -puN drivers/edac/edac_module.c~drivers-edac-fix-edac_mc-sysfs-completion-code drivers/edac/edac_module.c
--- a/drivers/edac/edac_module.c~drivers-edac-fix-edac_mc-sysfs-completion-code
+++ a/drivers/edac/edac_module.c
@@ -14,11 +14,11 @@
 #include "edac_core.h"
 #include "edac_module.h"
 
-#define EDAC_MC_VERSION "Ver: 2.0.4 " __DATE__
+#define EDAC_MC_VERSION "Ver: 2.0.5 " __DATE__
 
 #ifdef CONFIG_EDAC_DEBUG
 /* Values of 0 to 4 will generate output */
-int edac_debug_level = 1;
+int edac_debug_level = 2;
 EXPORT_SYMBOL_GPL(edac_debug_level);
 #endif
 
@@ -153,7 +153,7 @@ static int __init edac_init(void)
 	edac_pci_clear_parity_errors();
 
 	/*
-	 * perform the registration of the /sys/devices/system/edac object
+	 * perform the registration of the /sys/devices/system/edac class object
 	 */
 	if (edac_register_sysfs_edac_name()) {
 		edac_printk(KERN_ERR, EDAC_MC,
@@ -162,29 +162,29 @@ static int __init edac_init(void)
 		goto error;
 	}
 
-	/* Create the MC sysfs entries, must be first
+	/*
+	 * now set up the mc_kset under the edac class object
 	 */
-	if (edac_sysfs_memctrl_setup()) {
-		edac_printk(KERN_ERR, EDAC_MC,
-			"Error initializing sysfs code\n");
-		err = -ENODEV;
-		goto error_sysfs;
-	}
+	err = edac_sysfs_setup_mc_kset();
+	if (err)
+		goto sysfs_setup_fail;
 
-	/* Setup/Initialize the edac_device system */
+	/* Setup/Initialize the workq for this core */
 	err = edac_workqueue_setup();
 	if (err) {
 		edac_printk(KERN_ERR, EDAC_MC, "init WorkQueue failure\n");
-		goto error_mem;
+		goto workq_fail;
 	}
 
 	return 0;
 
 	/* Error teardown stack */
-error_mem:
-	edac_sysfs_memctrl_teardown();
-error_sysfs:
+workq_fail:
+	edac_sysfs_teardown_mc_kset();
+
+sysfs_setup_fail:
 	edac_unregister_sysfs_edac_name();
+
 error:
 	return err;
 }
@@ -199,7 +199,7 @@ static void __exit edac_exit(void)
 
 	/* tear down the various subsystems */
 	edac_workqueue_teardown();
-	edac_sysfs_memctrl_teardown();
+	edac_sysfs_teardown_mc_kset();
 	edac_unregister_sysfs_edac_name();
 }
 
diff -puN drivers/edac/edac_module.h~drivers-edac-fix-edac_mc-sysfs-completion-code drivers/edac/edac_module.h
--- a/drivers/edac/edac_module.h~drivers-edac-fix-edac_mc-sysfs-completion-code
+++ a/drivers/edac/edac_module.h
@@ -18,11 +18,15 @@
  * INTERNAL EDAC MODULE:
  * EDAC memory controller sysfs create/remove functions
  * and setup/teardown functions
+ *
+ * edac_mc objects
  */
+extern int edac_sysfs_setup_mc_kset(void);
+extern void edac_sysfs_teardown_mc_kset(void);
+extern int edac_mc_register_sysfs_main_kobj(struct mem_ctl_info *mci);
+extern void edac_mc_unregister_sysfs_main_kobj(struct mem_ctl_info *mci);
 extern int edac_create_sysfs_mci_device(struct mem_ctl_info *mci);
 extern void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci);
-extern int edac_sysfs_memctrl_setup(void);
-extern void edac_sysfs_memctrl_teardown(void);
 extern void edac_check_mc_devices(void);
 extern int edac_get_log_ue(void);
 extern int edac_get_log_ce(void);
_

Patches currently in -mm which might be from dougthompson@xmission.com are

drivers-edac-add-edac_mc_find-api.patch
drivers-edac-add-rddr2-memory-types.patch
drivers-edac-split-out-functions-to-unique-files.patch
drivers-edac-add-edac_device-class.patch
drivers-edac-mc-sysfs-add-missing-mem-types.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
drivers-edac-coreh-fix-scrubdefs.patch
drivers-edac-new-i82443bxgz-mc-driver.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
drivers-edac-add-new-nmi-rescan.patch
drivers-edac-mod-use-edac_coreh.patch
drivers-edac-add-dev_name-getter-function.patch
drivers-edac-new-inte-30x0-mc-driver.patch
drivers-edac-mod-mc-to-use-workq-instead-of-kthread.patch
drivers-edac-updated-pci-monitoring.patch
drivers-edac-mod-assert_error-check.patch
drivers-edac-core-lindent-cleanup.patch
drivers-edac-edac_device-sysfs-cleanup.patch
drivers-edac-cleanup-workq-ifdefs.patch
drivers-edac-lindent-amd76x.patch
drivers-edac-lindent-i5000.patch
drivers-edac-lindent-e7xxx.patch
drivers-edac-lindent-i3000.patch
drivers-edac-lindent-i82860.patch
drivers-edac-lindent-i82875p.patch
drivers-edac-lindent-e752x.patch
drivers-edac-lindent-i82443bxgx.patch
drivers-edac-lindent-r82600.patch
drivers-edac-drivers-to-use-new-pci-operation.patch
drivers-edac-add-device-sysfs-attributes.patch
drivers-edac-device-output-clenaup.patch
drivers-edac-add-info-kconfig.patch
drivers-edac-update-maintainers-files-for-edac.patch
drivers-edac-cleanup-spaces-gotos-after-lindent-messup.patch
driver-edac-add-mips-and-ppc-visibility.patch
driver-edac-mod-race-fix-i82875p.patch
driver-edac-fix-ignored-return-i82875p.patch
include-linux-pci_id-h-add-amd-northbridge-defines.patch
driver-edac-i5000-define-typo.patch
driver-edac-remove-null-from-statics.patch
driver-edac-i5000-code-tidying.patch
driver-edac-edac_device-code-tidying.patch
driver-edac-mod-edac_align_ptr-function.patch
driver-edac-mod-edac_opt_state_to_string-function.patch
driver-edac-remove-file-edac_mc-h.patch
drivers-edac-fix-edac_device-semaphore-to-mutex.patch
drivers-edac-fix-e752x-reversed-csrows.patch
drivers-edac-new-pasemi-driver.patch
drivers-edac-fix-leaf-sysfs-attribute.patch
drivers-edac-fix-edac_mc-init-apis.patch
drivers-edac-fix-edac_device-init-apis.patch
drivers-edac-fix-edac_mc-sysfs-completion-code.patch
drivers-edac-fix-edac_device-sysfs-completion-code.patch

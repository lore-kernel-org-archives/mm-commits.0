From: akpm@linux-foundation.org
Subject: + drivers-base-replace-remaining-__function__-occurrences.patch added to -mm tree
Date: Wed, 05 Mar 2008 15:42:30 -0800
Message-ID: <200803052342.m25NgU9P027749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756882AbYCEXmd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 18:42:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, greg@kroah.com


The patch titled
     drivers/base: replace remaining __FUNCTION__ occurrences
has been added to the -mm tree.  Its filename is
     drivers-base-replace-remaining-__function__-occurrences.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/base: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/bus.c            |    8 ++++----
 drivers/base/class.c          |    8 ++++----
 drivers/base/core.c           |   18 +++++++++---------
 drivers/base/dd.c             |   14 +++++++-------
 drivers/base/firmware_class.c |   18 +++++++++---------
 drivers/base/memory.c         |    4 ++--
 drivers/base/sys.c            |    2 +-
 7 files changed, 36 insertions(+), 36 deletions(-)

diff -puN drivers/base/bus.c~drivers-base-replace-remaining-__function__-occurrences drivers/base/bus.c
--- a/drivers/base/bus.c~drivers-base-replace-remaining-__function__-occurrences
+++ a/drivers/base/bus.c
@@ -79,7 +79,7 @@ static void driver_release(struct kobjec
 {
 	struct driver_private *drv_priv = to_driver(kobj);
 
-	pr_debug("driver: '%s': %s\n", kobject_name(kobj), __FUNCTION__);
+	pr_debug("driver: '%s': %s\n", kobject_name(kobj), __func__);
 	kfree(drv_priv);
 }
 
@@ -682,19 +682,19 @@ int bus_add_driver(struct device_driver 
 	error = driver_create_file(drv, &driver_attr_uevent);
 	if (error) {
 		printk(KERN_ERR "%s: uevent attr (%s) failed\n",
-			__FUNCTION__, drv->name);
+			__func__, drv->name);
 	}
 	error = driver_add_attrs(bus, drv);
 	if (error) {
 		/* How the hell do we get out of this pickle? Give up */
 		printk(KERN_ERR "%s: driver_add_attrs(%s) failed\n",
-			__FUNCTION__, drv->name);
+			__func__, drv->name);
 	}
 	error = add_bind_files(drv);
 	if (error) {
 		/* Ditto */
 		printk(KERN_ERR "%s: add_bind_files(%s) failed\n",
-			__FUNCTION__, drv->name);
+			__func__, drv->name);
 	}
 
 	kobject_uevent(&priv->kobj, KOBJ_ADD);
diff -puN drivers/base/class.c~drivers-base-replace-remaining-__function__-occurrences drivers/base/class.c
--- a/drivers/base/class.c~drivers-base-replace-remaining-__function__-occurrences
+++ a/drivers/base/class.c
@@ -175,13 +175,13 @@ void class_unregister(struct class *cls)
 
 static void class_create_release(struct class *cls)
 {
-	pr_debug("%s called for %s\n", __FUNCTION__, cls->name);
+	pr_debug("%s called for %s\n", __func__, cls->name);
 	kfree(cls);
 }
 
 static void class_device_create_release(struct class_device *class_dev)
 {
-	pr_debug("%s called for %s\n", __FUNCTION__, class_dev->class_id);
+	pr_debug("%s called for %s\n", __func__, class_dev->class_id);
 	kfree(class_dev);
 }
 
@@ -189,7 +189,7 @@ static void class_device_create_release(
 static int class_device_create_uevent(struct class_device *class_dev,
 				      struct kobj_uevent_env *env)
 {
-	pr_debug("%s called for %s\n", __FUNCTION__, class_dev->class_id);
+	pr_debug("%s called for %s\n", __func__, class_dev->class_id);
 	return 0;
 }
 
@@ -415,7 +415,7 @@ static int class_uevent(struct kset *kse
 	struct device *dev = class_dev->dev;
 	int retval = 0;
 
-	pr_debug("%s - name = %s\n", __FUNCTION__, class_dev->class_id);
+	pr_debug("%s - name = %s\n", __func__, class_dev->class_id);
 
 	if (MAJOR(class_dev->devt)) {
 		add_uevent_var(env, "MAJOR=%u", MAJOR(class_dev->devt));
diff -puN drivers/base/core.c~drivers-base-replace-remaining-__function__-occurrences drivers/base/core.c
--- a/drivers/base/core.c~drivers-base-replace-remaining-__function__-occurrences
+++ a/drivers/base/core.c
@@ -207,7 +207,7 @@ static int dev_uevent(struct kset *kset,
 		retval = dev->bus->uevent(dev, env);
 		if (retval)
 			pr_debug("device: '%s': %s: bus uevent() returned %d\n",
-				 dev->bus_id, __FUNCTION__, retval);
+				 dev->bus_id, __func__, retval);
 	}
 
 	/* have the class specific function add its stuff */
@@ -216,7 +216,7 @@ static int dev_uevent(struct kset *kset,
 		if (retval)
 			pr_debug("device: '%s': %s: class uevent() "
 				 "returned %d\n", dev->bus_id,
-				 __FUNCTION__, retval);
+				 __func__, retval);
 	}
 
 	/* have the device type specific fuction add its stuff */
@@ -225,7 +225,7 @@ static int dev_uevent(struct kset *kset,
 		if (retval)
 			pr_debug("device: '%s': %s: dev_type uevent() "
 				 "returned %d\n", dev->bus_id,
-				 __FUNCTION__, retval);
+				 __func__, retval);
 	}
 
 	return retval;
@@ -783,7 +783,7 @@ int device_add(struct device *dev)
 		goto Done;
 	}
 
-	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
+	pr_debug("device: '%s': %s\n", dev->bus_id, __func__);
 
 	parent = get_device(dev->parent);
 	setup_parent(dev, parent);
@@ -982,7 +982,7 @@ void device_del(struct device *dev)
  */
 void device_unregister(struct device *dev)
 {
-	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
+	pr_debug("device: '%s': %s\n", dev->bus_id, __func__);
 	device_del(dev);
 	put_device(dev);
 }
@@ -1077,7 +1077,7 @@ EXPORT_SYMBOL_GPL(device_remove_file);
 
 static void device_create_release(struct device *dev)
 {
-	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
+	pr_debug("device: '%s': %s\n", dev->bus_id, __func__);
 	kfree(dev);
 }
 
@@ -1211,7 +1211,7 @@ int device_rename(struct device *dev, ch
 		return -EINVAL;
 
 	pr_debug("device: '%s': %s: renaming to '%s'\n", dev->bus_id,
-		 __FUNCTION__, new_name);
+		 __func__, new_name);
 
 #ifdef CONFIG_SYSFS_DEPRECATED
 	if ((dev->class) && (dev->parent))
@@ -1250,7 +1250,7 @@ int device_rename(struct device *dev, ch
 					  dev->bus_id);
 		if (error) {
 			dev_err(dev, "%s: sysfs_create_symlink failed (%d)\n",
-				__FUNCTION__, error);
+				__func__, error);
 		}
 	}
 #endif
@@ -1326,7 +1326,7 @@ int device_move(struct device *dev, stru
 	new_parent_kobj = get_device_parent(dev, new_parent);
 
 	pr_debug("device: '%s': %s: moving to '%s'\n", dev->bus_id,
-		 __FUNCTION__, new_parent ? new_parent->bus_id : "<NULL>");
+		 __func__, new_parent ? new_parent->bus_id : "<NULL>");
 	error = kobject_move(&dev->kobj, new_parent_kobj);
 	if (error) {
 		cleanup_glue_dir(dev, new_parent_kobj);
diff -puN drivers/base/dd.c~drivers-base-replace-remaining-__function__-occurrences drivers/base/dd.c
--- a/drivers/base/dd.c~drivers-base-replace-remaining-__function__-occurrences
+++ a/drivers/base/dd.c
@@ -30,12 +30,12 @@ static void driver_bound(struct device *
 {
 	if (klist_node_attached(&dev->knode_driver)) {
 		printk(KERN_WARNING "%s: device %s already bound\n",
-			__FUNCTION__, kobject_name(&dev->kobj));
+			__func__, kobject_name(&dev->kobj));
 		return;
 	}
 
 	pr_debug("driver: '%s': %s: bound to device '%s'\n", dev->bus_id,
-		 __FUNCTION__, dev->driver->name);
+		 __func__, dev->driver->name);
 
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
@@ -104,13 +104,13 @@ static int really_probe(struct device *d
 
 	atomic_inc(&probe_count);
 	pr_debug("bus: '%s': %s: probing driver %s with device %s\n",
-		 drv->bus->name, __FUNCTION__, drv->name, dev->bus_id);
+		 drv->bus->name, __func__, drv->name, dev->bus_id);
 	WARN_ON(!list_empty(&dev->devres_head));
 
 	dev->driver = drv;
 	if (driver_sysfs_add(dev)) {
 		printk(KERN_ERR "%s: driver_sysfs_add(%s) failed\n",
-			__FUNCTION__, dev->bus_id);
+			__func__, dev->bus_id);
 		goto probe_failed;
 	}
 
@@ -127,7 +127,7 @@ static int really_probe(struct device *d
 	driver_bound(dev);
 	ret = 1;
 	pr_debug("bus: '%s': %s: bound device %s to driver %s\n",
-		 drv->bus->name, __FUNCTION__, dev->bus_id, drv->name);
+		 drv->bus->name, __func__, dev->bus_id, drv->name);
 	goto done;
 
 probe_failed:
@@ -160,7 +160,7 @@ done:
  */
 int driver_probe_done(void)
 {
-	pr_debug("%s: probe_count = %d\n", __FUNCTION__,
+	pr_debug("%s: probe_count = %d\n", __func__,
 		 atomic_read(&probe_count));
 	if (atomic_read(&probe_count))
 		return -EBUSY;
@@ -194,7 +194,7 @@ int driver_probe_device(struct device_dr
 		goto done;
 
 	pr_debug("bus: '%s': %s: matched device %s with driver %s\n",
-		 drv->bus->name, __FUNCTION__, dev->bus_id, drv->name);
+		 drv->bus->name, __func__, dev->bus_id, drv->name);
 
 	ret = really_probe(dev, drv);
 
diff -puN drivers/base/firmware_class.c~drivers-base-replace-remaining-__function__-occurrences drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c~drivers-base-replace-remaining-__function__-occurrences
+++ a/drivers/base/firmware_class.c
@@ -156,7 +156,7 @@ static ssize_t firmware_loading_store(st
 		}
 		/* fallthrough */
 	default:
-		printk(KERN_ERR "%s: unexpected value (%d)\n", __FUNCTION__,
+		printk(KERN_ERR "%s: unexpected value (%d)\n", __func__,
 		       loading);
 		/* fallthrough */
 	case -1:
@@ -209,7 +209,7 @@ fw_realloc_buffer(struct firmware_priv *
 	new_size = ALIGN(min_size, PAGE_SIZE);
 	new_data = vmalloc(new_size);
 	if (!new_data) {
-		printk(KERN_ERR "%s: unable to alloc buffer\n", __FUNCTION__);
+		printk(KERN_ERR "%s: unable to alloc buffer\n", __func__);
 		/* Make sure that we don't keep incomplete data */
 		fw_load_abort(fw_priv);
 		return -ENOMEM;
@@ -307,7 +307,7 @@ static int fw_register_device(struct dev
 	*dev_p = NULL;
 
 	if (!fw_priv || !f_dev) {
-		printk(KERN_ERR "%s: kmalloc failed\n", __FUNCTION__);
+		printk(KERN_ERR "%s: kmalloc failed\n", __func__);
 		retval = -ENOMEM;
 		goto error_kfree;
 	}
@@ -328,7 +328,7 @@ static int fw_register_device(struct dev
 	retval = device_register(f_dev);
 	if (retval) {
 		printk(KERN_ERR "%s: device_register failed\n",
-		       __FUNCTION__);
+		       __func__);
 		goto error_kfree;
 	}
 	*dev_p = f_dev;
@@ -362,14 +362,14 @@ static int fw_setup_device(struct firmwa
 	retval = sysfs_create_bin_file(&f_dev->kobj, &fw_priv->attr_data);
 	if (retval) {
 		printk(KERN_ERR "%s: sysfs_create_bin_file failed\n",
-		       __FUNCTION__);
+		       __func__);
 		goto error_unreg;
 	}
 
 	retval = device_create_file(f_dev, &dev_attr_loading);
 	if (retval) {
 		printk(KERN_ERR "%s: device_create_file failed\n",
-		       __FUNCTION__);
+		       __func__);
 		goto error_unreg;
 	}
 
@@ -399,7 +399,7 @@ _request_firmware(const struct firmware 
 	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
 	if (!firmware) {
 		printk(KERN_ERR "%s: kmalloc(struct firmware) failed\n",
-		       __FUNCTION__);
+		       __func__);
 		retval = -ENOMEM;
 		goto out;
 	}
@@ -570,13 +570,13 @@ firmware_class_init(void)
 	int error;
 	error = class_register(&firmware_class);
 	if (error) {
-		printk(KERN_ERR "%s: class_register failed\n", __FUNCTION__);
+		printk(KERN_ERR "%s: class_register failed\n", __func__);
 		return error;
 	}
 	error = class_create_file(&firmware_class, &class_attr_timeout);
 	if (error) {
 		printk(KERN_ERR "%s: class_create_file failed\n",
-		       __FUNCTION__);
+		       __func__);
 		class_unregister(&firmware_class);
 	}
 	return error;
diff -puN drivers/base/memory.c~drivers-base-replace-remaining-__function__-occurrences drivers/base/memory.c
--- a/drivers/base/memory.c~drivers-base-replace-remaining-__function__-occurrences
+++ a/drivers/base/memory.c
@@ -186,7 +186,7 @@ memory_block_action(struct memory_block 
 			break;
 		default:
 			printk(KERN_WARNING "%s(%p, %ld) unknown action: %ld\n",
-					__FUNCTION__, mem, action, action);
+					__func__, mem, action, action);
 			WARN_ON(1);
 			ret = -EINVAL;
 	}
@@ -444,6 +444,6 @@ int __init memory_dev_init(void)
 		ret = err;
 out:
 	if (ret)
-		printk(KERN_ERR "%s() failed: %d\n", __FUNCTION__, ret);
+		printk(KERN_ERR "%s() failed: %d\n", __func__, ret);
 	return ret;
 }
diff -puN drivers/base/sys.c~drivers-base-replace-remaining-__function__-occurrences drivers/base/sys.c
--- a/drivers/base/sys.c~drivers-base-replace-remaining-__function__-occurrences
+++ a/drivers/base/sys.c
@@ -183,7 +183,7 @@ int sysdev_driver_register(struct sysdev
 		}
 	} else {
 		err = -EINVAL;
-		printk(KERN_ERR "%s: invalid device class\n", __FUNCTION__);
+		printk(KERN_ERR "%s: invalid device class\n", __func__);
 		WARN_ON(1);
 	}
 	mutex_unlock(&sysdev_drivers_lock);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-x86.patch
git-alsa.patch
sound-replace-remaining-__function__-occurences.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
arm-replace-remaining-__function__-occurences.patch
cifs-remove-global_extern-macro.patch
cifs-replace-remaining-__function__-occurrences.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
drivers-base-replace-remaining-__function__-occurrences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
infiniband-replace-remaining-__function__-occurrences.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
mips-replace-remaining-__function__-occurences.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
blackfin-replace-remaining-__function__-occurences.patch
nfs-replace-remaining-__function__-occurrences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
drivers-s390-replace-remaining-__function__-occurrences.patch
sh-replace-remaining-__function__-occurences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
xfs-replace-remaining-__function__-occurrences.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
ext2-replace-remaining-__function__-occurrences.patch
jbd-sparse-warnings-in-revokec-journalc.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
reiserfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
security-replace-remaining-__function__-occurences.patch
security-replace-remaining-__function__-occurences-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch


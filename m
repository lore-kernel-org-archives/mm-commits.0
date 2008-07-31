From: akpm@linux-foundation.org
Subject: + w1-fix-deadlocks-and-remove-w1_control_thread.patch added to -mm tree
Date: Wed, 30 Jul 2008 20:15:57 -0700
Message-ID: <200807310315.m6V3Fv3Z001118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755091AbYGaD0e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:26:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fries.net, johnpol@2ka.mipt.ru


The patch titled
     W1: fix deadlocks and remove w1_control_thread
has been added to the -mm tree.  Its filename is
     w1-fix-deadlocks-and-remove-w1_control_thread.patch

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
Subject: W1: fix deadlocks and remove w1_control_thread
From: David Fries <david@fries.net>

w1_control_thread was removed which would wake up every second and process
newly registered family codes and complete some final cleanup for a
removed master.  Those routines were moved to the threads that were
previously requesting those operations.  A new function
w1_reconnect_slaves takes care of reconnecting existing slave devices when
a new family code is registered or removed.  The removal case was missing
and would cause a deadlock waiting for the family code reference count to
decrease, which will now happen.  A problem with registering a family code
was fixed.  A slave device would be unattached if it wasn't yet claimed,
then attached at the end of the list, two unclaimed slaves would cause an
infinite loop.

The struct w1_bus_master.search now takes a pointer to the struct
w1_master device to avoid searching for it, which would have caused a
lock ordering deadlock with the removal of w1_control_thread.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds1wm.c |    6 -
 drivers/w1/w1.c            |  146 ++++++++---------------------------
 drivers/w1/w1.h            |   19 +++-
 drivers/w1/w1_family.c     |    6 +
 drivers/w1/w1_family.h     |    1 
 drivers/w1/w1_int.c        |   12 ++
 drivers/w1/w1_io.c         |    3 
 7 files changed, 71 insertions(+), 122 deletions(-)

diff -puN drivers/w1/masters/ds1wm.c~w1-fix-deadlocks-and-remove-w1_control_thread drivers/w1/masters/ds1wm.c
--- a/drivers/w1/masters/ds1wm.c~w1-fix-deadlocks-and-remove-w1_control_thread
+++ a/drivers/w1/masters/ds1wm.c
@@ -274,8 +274,8 @@ static u8 ds1wm_reset_bus(void *data)
 	return 0;
 }
 
-static void ds1wm_search(void *data, u8 search_type,
-			 w1_slave_found_callback slave_found)
+static void ds1wm_search(void *data, struct w1_master *master_dev,
+			u8 search_type, w1_slave_found_callback slave_found)
 {
 	struct ds1wm_data *ds1wm_data = data;
 	int i;
@@ -313,7 +313,7 @@ static void ds1wm_search(void *data, u8 
 	ds1wm_write_register(ds1wm_data, DS1WM_CMD, ~DS1WM_CMD_SRA);
 	ds1wm_reset(ds1wm_data);
 
-	slave_found(ds1wm_data, rom_id);
+	slave_found(master_dev, rom_id);
 }
 
 /* --------------------------------------------------------------------- */
diff -puN drivers/w1/w1.c~w1-fix-deadlocks-and-remove-w1_control_thread drivers/w1/w1.c
--- a/drivers/w1/w1.c~w1-fix-deadlocks-and-remove-w1_control_thread
+++ a/drivers/w1/w1.c
@@ -46,20 +46,16 @@ MODULE_AUTHOR("Evgeniy Polyakov <johnpol
 MODULE_DESCRIPTION("Driver for 1-wire Dallas network protocol.");
 
 static int w1_timeout = 10;
-static int w1_control_timeout = 1;
 int w1_max_slave_count = 10;
 int w1_max_slave_ttl = 10;
 
 module_param_named(timeout, w1_timeout, int, 0);
-module_param_named(control_timeout, w1_control_timeout, int, 0);
 module_param_named(max_slave_count, w1_max_slave_count, int, 0);
 module_param_named(slave_ttl, w1_max_slave_ttl, int, 0);
 
 DEFINE_MUTEX(w1_mlock);
 LIST_HEAD(w1_masters);
 
-static struct task_struct *w1_control_thread;
-
 static int w1_master_match(struct device *dev, struct device_driver *drv)
 {
 	return 1;
@@ -390,7 +386,7 @@ int w1_create_master_attributes(struct w
 	return sysfs_create_group(&master->dev.kobj, &w1_master_defattr_group);
 }
 
-static void w1_destroy_master_attributes(struct w1_master *master)
+void w1_destroy_master_attributes(struct w1_master *master)
 {
 	sysfs_remove_group(&master->dev.kobj, &w1_master_defattr_group);
 }
@@ -567,7 +563,7 @@ static int w1_attach_slave_device(struct
 	return 0;
 }
 
-static void w1_slave_detach(struct w1_slave *sl)
+void w1_slave_detach(struct w1_slave *sl)
 {
 	struct w1_netlink_msg msg;
 
@@ -591,24 +587,6 @@ static void w1_slave_detach(struct w1_sl
 	kfree(sl);
 }
 
-static struct w1_master *w1_search_master(void *data)
-{
-	struct w1_master *dev;
-	int found = 0;
-
-	mutex_lock(&w1_mlock);
-	list_for_each_entry(dev, &w1_masters, w1_master_entry) {
-		if (dev->bus_master->data == data) {
-			found = 1;
-			atomic_inc(&dev->refcnt);
-			break;
-		}
-	}
-	mutex_unlock(&w1_mlock);
-
-	return (found)?dev:NULL;
-}
-
 struct w1_master *w1_search_master_id(u32 id)
 {
 	struct w1_master *dev;
@@ -656,34 +634,49 @@ struct w1_slave *w1_search_slave(struct 
 	return (found)?sl:NULL;
 }
 
-void w1_reconnect_slaves(struct w1_family *f)
+void w1_reconnect_slaves(struct w1_family *f, int attach)
 {
+	struct w1_slave *sl, *sln;
 	struct w1_master *dev;
 
 	mutex_lock(&w1_mlock);
 	list_for_each_entry(dev, &w1_masters, w1_master_entry) {
-		dev_dbg(&dev->dev, "Reconnecting slaves in %s into new family %02x.\n",
-				dev->name, f->fid);
-		set_bit(W1_MASTER_NEED_RECONNECT, &dev->flags);
+		dev_dbg(&dev->dev, "Reconnecting slaves in device %s "
+			"for family %02x.\n", dev->name, f->fid);
+		mutex_lock(&dev->mutex);
+		list_for_each_entry_safe(sl, sln, &dev->slist, w1_slave_entry) {
+			/* If it is a new family, slaves with the default
+			 * family driver and are that family will be
+			 * connected.  If the family is going away, devices
+			 * matching that family are reconneced.
+			 */
+			if ((attach && sl->family->fid == W1_FAMILY_DEFAULT
+				&& sl->reg_num.family == f->fid) ||
+				(!attach && sl->family->fid == f->fid)) {
+				struct w1_reg_num rn;
+
+				memcpy(&rn, &sl->reg_num, sizeof(rn));
+				w1_slave_detach(sl);
+
+				w1_attach_slave_device(dev, &rn);
+			}
+		}
+		dev_dbg(&dev->dev, "Reconnecting slaves in device %s "
+			"has been finished.\n", dev->name);
+		mutex_unlock(&dev->mutex);
 	}
 	mutex_unlock(&w1_mlock);
 }
 
-static void w1_slave_found(void *data, u64 rn)
+static void w1_slave_found(struct w1_master *dev, u64 rn)
 {
 	int slave_count;
 	struct w1_slave *sl;
 	struct list_head *ent;
 	struct w1_reg_num *tmp;
-	struct w1_master *dev;
 	u64 rn_le = cpu_to_le64(rn);
 
-	dev = w1_search_master(data);
-	if (!dev) {
-		printk(KERN_ERR "Failed to find w1 master device for data %p, "
-		       "it is impossible.\n", data);
-		return;
-	}
+	atomic_inc(&dev->refcnt);
 
 	tmp = (struct w1_reg_num *) &rn;
 
@@ -785,74 +778,9 @@ void w1_search(struct w1_master *dev, u8
 			if ( (desc_bit == last_zero) || (last_zero < 0))
 				last_device = 1;
 			desc_bit = last_zero;
-			cb(dev->bus_master->data, rn);
-		}
-	}
-}
-
-static int w1_control(void *data)
-{
-	struct w1_slave *sl, *sln;
-	struct w1_master *dev, *n;
-	int have_to_wait = 0;
-
-	set_freezable();
-	while (!kthread_should_stop() || have_to_wait) {
-		have_to_wait = 0;
-
-		try_to_freeze();
-		msleep_interruptible(w1_control_timeout * 1000);
-
-		list_for_each_entry_safe(dev, n, &w1_masters, w1_master_entry) {
-			if (!kthread_should_stop() && !dev->flags)
-				continue;
-			/*
-			 * Little race: we can create thread but not set the flag.
-			 * Get a chance for external process to set flag up.
-			 */
-			if (!dev->initialized) {
-				have_to_wait = 1;
-				continue;
-			}
-
-			if (kthread_should_stop() || test_bit(W1_MASTER_NEED_EXIT, &dev->flags)) {
-				set_bit(W1_MASTER_NEED_EXIT, &dev->flags);
-
-				mutex_lock(&w1_mlock);
-				list_del(&dev->w1_master_entry);
-				mutex_unlock(&w1_mlock);
-
-				mutex_lock(&dev->mutex);
-				list_for_each_entry_safe(sl, sln, &dev->slist, w1_slave_entry) {
-					w1_slave_detach(sl);
-				}
-				w1_destroy_master_attributes(dev);
-				mutex_unlock(&dev->mutex);
-				atomic_dec(&dev->refcnt);
-				continue;
-			}
-
-			if (test_bit(W1_MASTER_NEED_RECONNECT, &dev->flags)) {
-				dev_dbg(&dev->dev, "Reconnecting slaves in device %s.\n", dev->name);
-				mutex_lock(&dev->mutex);
-				list_for_each_entry_safe(sl, sln, &dev->slist, w1_slave_entry) {
-					if (sl->family->fid == W1_FAMILY_DEFAULT) {
-						struct w1_reg_num rn;
-
-						memcpy(&rn, &sl->reg_num, sizeof(rn));
-						w1_slave_detach(sl);
-
-						w1_attach_slave_device(dev, &rn);
-					}
-				}
-				dev_dbg(&dev->dev, "Reconnecting slaves in device %s has been finished.\n", dev->name);
-				clear_bit(W1_MASTER_NEED_RECONNECT, &dev->flags);
-				mutex_unlock(&dev->mutex);
-			}
+			cb(dev, rn);
 		}
 	}
-
-	return 0;
 }
 
 void w1_search_process(struct w1_master *dev, u8 search_type)
@@ -932,18 +860,13 @@ static int w1_init(void)
 		goto err_out_master_unregister;
 	}
 
-	w1_control_thread = kthread_run(w1_control, NULL, "w1_control");
-	if (IS_ERR(w1_control_thread)) {
-		retval = PTR_ERR(w1_control_thread);
-		printk(KERN_ERR "Failed to create control thread. err=%d\n",
-			retval);
-		goto err_out_slave_unregister;
-	}
-
 	return 0;
 
+#if 0
+/* For undoing the slave register if there was a step after it. */
 err_out_slave_unregister:
 	driver_unregister(&w1_slave_driver);
+#endif
 
 err_out_master_unregister:
 	driver_unregister(&w1_master_driver);
@@ -959,13 +882,12 @@ static void w1_fini(void)
 {
 	struct w1_master *dev;
 
+	/* Set netlink removal messages and some cleanup */
 	list_for_each_entry(dev, &w1_masters, w1_master_entry)
 		__w1_remove_master_device(dev);
 
 	w1_fini_netlink();
 
-	kthread_stop(w1_control_thread);
-
 	driver_unregister(&w1_slave_driver);
 	driver_unregister(&w1_master_driver);
 	bus_unregister(&w1_bus_type);
diff -puN drivers/w1/w1.h~w1-fix-deadlocks-and-remove-w1_control_thread drivers/w1/w1.h
--- a/drivers/w1/w1.h~w1-fix-deadlocks-and-remove-w1_control_thread
+++ a/drivers/w1/w1.h
@@ -77,7 +77,7 @@ struct w1_slave
 	struct completion	released;
 };
 
-typedef void (* w1_slave_found_callback)(void *, u64);
+typedef void (*w1_slave_found_callback)(struct w1_master *, u64);
 
 
 /**
@@ -142,12 +142,14 @@ struct w1_bus_master
 	 */
 	u8		(*reset_bus)(void *);
 
-	/** Really nice hardware can handles the different types of ROM search */
-	void		(*search)(void *, u8, w1_slave_found_callback);
+	/** Really nice hardware can handles the different types of ROM search
+	 *  w1_master* is passed to the slave found callback.
+	 */
+	void		(*search)(void *, struct w1_master *,
+		u8, w1_slave_found_callback);
 };
 
 #define W1_MASTER_NEED_EXIT		0
-#define W1_MASTER_NEED_RECONNECT	1
 
 struct w1_master
 {
@@ -181,12 +183,21 @@ struct w1_master
 };
 
 int w1_create_master_attributes(struct w1_master *);
+void w1_destroy_master_attributes(struct w1_master *master);
 void w1_search(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb);
 void w1_search_devices(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb);
 struct w1_slave *w1_search_slave(struct w1_reg_num *id);
 void w1_search_process(struct w1_master *dev, u8 search_type);
 struct w1_master *w1_search_master_id(u32 id);
 
+/* Disconnect and reconnect devices in the given family.  Used for finding
+ * unclaimed devices after a family has been registered or releasing devices
+ * after a family has been unregistered.  Set attach to 1 when a new family
+ * has just been registered, to 0 when it has been unregistered.
+ */
+void w1_reconnect_slaves(struct w1_family *f, int attach);
+void w1_slave_detach(struct w1_slave *sl);
+
 u8 w1_triplet(struct w1_master *dev, int bdir);
 void w1_write_8(struct w1_master *, u8);
 int w1_reset_bus(struct w1_master *);
diff -puN drivers/w1/w1_family.c~w1-fix-deadlocks-and-remove-w1_control_thread drivers/w1/w1_family.c
--- a/drivers/w1/w1_family.c~w1-fix-deadlocks-and-remove-w1_control_thread
+++ a/drivers/w1/w1_family.c
@@ -53,7 +53,8 @@ int w1_register_family(struct w1_family 
 	}
 	spin_unlock(&w1_flock);
 
-	w1_reconnect_slaves(newf);
+	/* check default devices against the new set of drivers */
+	w1_reconnect_slaves(newf, 1);
 
 	return ret;
 }
@@ -77,6 +78,9 @@ void w1_unregister_family(struct w1_fami
 
 	spin_unlock(&w1_flock);
 
+	/* deatch devices using this family code */
+	w1_reconnect_slaves(fent, 0);
+
 	while (atomic_read(&fent->refcnt)) {
 		printk(KERN_INFO "Waiting for family %u to become free: refcnt=%d.\n",
 				fent->fid, atomic_read(&fent->refcnt));
diff -puN drivers/w1/w1_family.h~w1-fix-deadlocks-and-remove-w1_control_thread drivers/w1/w1_family.h
--- a/drivers/w1/w1_family.h~w1-fix-deadlocks-and-remove-w1_control_thread
+++ a/drivers/w1/w1_family.h
@@ -63,6 +63,5 @@ void __w1_family_get(struct w1_family *)
 struct w1_family * w1_family_registered(u8);
 void w1_unregister_family(struct w1_family *);
 int w1_register_family(struct w1_family *);
-void w1_reconnect_slaves(struct w1_family *f);
 
 #endif /* __W1_FAMILY_H */
diff -puN drivers/w1/w1_int.c~w1-fix-deadlocks-and-remove-w1_control_thread drivers/w1/w1_int.c
--- a/drivers/w1/w1_int.c~w1-fix-deadlocks-and-remove-w1_control_thread
+++ a/drivers/w1/w1_int.c
@@ -148,10 +148,22 @@ err_out_free_dev:
 void __w1_remove_master_device(struct w1_master *dev)
 {
 	struct w1_netlink_msg msg;
+	struct w1_slave *sl, *sln;
 
 	set_bit(W1_MASTER_NEED_EXIT, &dev->flags);
 	kthread_stop(dev->thread);
 
+	mutex_lock(&w1_mlock);
+	list_del(&dev->w1_master_entry);
+	mutex_unlock(&w1_mlock);
+
+	mutex_lock(&dev->mutex);
+	list_for_each_entry_safe(sl, sln, &dev->slist, w1_slave_entry)
+		w1_slave_detach(sl);
+	w1_destroy_master_attributes(dev);
+	mutex_unlock(&dev->mutex);
+	atomic_dec(&dev->refcnt);
+
 	while (atomic_read(&dev->refcnt)) {
 		dev_info(&dev->dev, "Waiting for %s to become free: refcnt=%d.\n",
 				dev->name, atomic_read(&dev->refcnt));
diff -puN drivers/w1/w1_io.c~w1-fix-deadlocks-and-remove-w1_control_thread drivers/w1/w1_io.c
--- a/drivers/w1/w1_io.c~w1-fix-deadlocks-and-remove-w1_control_thread
+++ a/drivers/w1/w1_io.c
@@ -277,7 +277,8 @@ void w1_search_devices(struct w1_master 
 {
 	dev->attempts++;
 	if (dev->bus_master->search)
-		dev->bus_master->search(dev->bus_master->data, search_type, cb);
+		dev->bus_master->search(dev->bus_master->data, dev,
+			search_type, cb);
 	else
 		w1_search(dev, search_type, cb);
 }
_

Patches currently in -mm which might be from david@fries.net are

w1-fix-deadlocks-and-remove-w1_control_thread.patch
w1-abort-search-early-on-on-exit.patch
w1-dont-delay-search-start.patch
w1-w1_process-block-or-sleep.patch
w1-feature-enable-hardware-strong-pullup.patch
w1-feature-w1_thermc-use-strong-pullup-and-documentation.patch
w1-be-able-to-manually-add-and-remove-slaves.patch
w1-recode-w1_slave_found-logic.patch
w1-new-module-parameter-search_count.patch
w1-document-add-remove-search_count-and-pullup.patch
w1-w1_slave_read_id-read-bug-use-device_attribute.patch
w1-w1_therm-fix-user-buffer-overflow-and-cat.patch
w1-w1_family-remove-unused-variable-need_exit.patch
w1-w1_therm-consistent-mutex-access-code-cleanup.patch
w1-w1_intc-use-first-available-master-number.patch
w1-w1c-s-printk-dev_dbg.patch
w1-w1_ioc-reset-comments-and-msleep.patch
w1-ds1wmc-msleep-for-reset.patch
w1-ds2490c-correct-print-message.patch
w1-ds2490c-add-support-for-strong-pullup.patch
w1-ds2490c-ds_write_bit-grouping-error-disable-readback.patch
w1-ds2490c-disable-bit-read-and-write.patch
w1-ds2490c-simplify-and-fix-ds_touch_bit.patch
w1-ds2490c-ds_dump_status-rework.patch
w1-ds2490c-ds_reset-remove-ds_wait_status.patch
w1-ds2490c-reset-ds2490-in-init.patch
w1-ds2490c-magic-number-work.patch
w1-ds2490c-ds_write_block-remove-extra-ds_wait_status.patch
w1-documentation-w1-masters-ds2490-update.patch
w1-ds2490c-optimize-ds_set_pullup.patch


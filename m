From: akpm@linux-foundation.org
Subject: + w1-w1_intc-use-first-available-master-number.patch added to -mm tree
Date: Wed, 30 Jul 2008 20:16:24 -0700
Message-ID: <200807310316.m6V3GODm001173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756096AbYGaDXi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:23:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fries.net, johnpol@2ka.mipt.ru


The patch titled
     W1: w1_int.c use first available master number
has been added to the -mm tree.  Its filename is
     w1-w1_intc-use-first-available-master-number.patch

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
Subject: W1: w1_int.c use first available master number
From: David Fries <david@fries.net>

Follow the example of other devices (like the joystick device).  Pick the
first available id for each detected device.  Currently for USB devices,
suspending and resuming would cause the number to increment.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1_int.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff -puN drivers/w1/w1_int.c~w1-w1_intc-use-first-available-master-number drivers/w1/w1_int.c
--- a/drivers/w1/w1_int.c~w1-w1_intc-use-first-available-master-number
+++ a/drivers/w1/w1_int.c
@@ -29,7 +29,6 @@
 #include "w1_netlink.h"
 #include "w1_int.h"
 
-static u32 w1_ids = 1;
 static int w1_search_count = -1; /* Default is continual scan */
 module_param_named(search_count, w1_search_count, int, 0);
 
@@ -102,9 +101,10 @@ static void w1_free_dev(struct w1_master
 
 int w1_add_master_device(struct w1_bus_master *master)
 {
-	struct w1_master *dev;
+	struct w1_master *dev, *entry;
 	int retval = 0;
 	struct w1_netlink_msg msg;
+	int id, found;
 
         /* validate minimum functionality */
         if (!(master->touch_bit && master->reset_bus) &&
@@ -126,13 +126,33 @@ int w1_add_master_device(struct w1_bus_m
 		master->set_pullup = NULL;
 	}
 
-	dev = w1_alloc_dev(w1_ids++, w1_max_slave_count, w1_max_slave_ttl, &w1_master_driver, &w1_master_device);
-	if (!dev)
+	/* Lock until the device is added (or not) to w1_masters. */
+	mutex_lock(&w1_mlock);
+	/* Search for the first available id (starting at 1). */
+	id = 0;
+	do {
+		++id;
+		found = 0;
+		list_for_each_entry(entry, &w1_masters, w1_master_entry) {
+			if (entry->id == id) {
+				found = 1;
+				break;
+			}
+		}
+	} while (found);
+
+	dev = w1_alloc_dev(id, w1_max_slave_count, w1_max_slave_ttl,
+		&w1_master_driver, &w1_master_device);
+	if (!dev) {
+		mutex_unlock(&w1_mlock);
 		return -ENOMEM;
+	}
 
 	retval =  w1_create_master_attributes(dev);
-	if (retval)
+	if (retval) {
+		mutex_unlock(&w1_mlock);
 		goto err_out_free_dev;
+	}
 
 	memcpy(dev->bus_master, master, sizeof(struct w1_bus_master));
 
@@ -144,10 +164,10 @@ int w1_add_master_device(struct w1_bus_m
 		dev_err(&dev->dev,
 			 "Failed to create new kernel thread. err=%d\n",
 			 retval);
+		mutex_unlock(&w1_mlock);
 		goto err_out_rm_attr;
 	}
 
-	mutex_lock(&w1_mlock);
 	list_add(&dev->w1_master_entry, &w1_masters);
 	mutex_unlock(&w1_mlock);
 
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


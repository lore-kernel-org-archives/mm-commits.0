From: akpm@linux-foundation.org
Subject: + pm-use-kobject_name-to-access-kobject-names.patch added to -mm tree
Date: Tue, 10 Apr 2007 23:40:23 -0700
Message-ID: <200704110640.l3B6eNlu030490@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33646 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbXDKGkf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 02:40:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dtor@insightbb.com, dtor@mail.ru, greg@kroah.com


The patch titled
     PM: use kobject_name() to access kobject names
has been added to the -mm tree.  Its filename is
     pm-use-kobject_name-to-access-kobject-names.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PM: use kobject_name() to access kobject names
From: Dmitry Torokhov <dtor@insightbb.com>

Noone should use kobj.name directly since it may contain garbage.  Objects
with longer names have them stored in separately allocated memory pointed
to by kobj->k_name.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/base/power/main.c~pm-use-kobject_name-to-access-kobject-names drivers/base/power/main.c
--- a/drivers/base/power/main.c~pm-use-kobject_name-to-access-kobject-names
+++ a/drivers/base/power/main.c
@@ -54,7 +54,8 @@ int device_pm_add(struct device * dev)
 	int error;
 
 	pr_debug("PM: Adding info for %s:%s\n",
-		 dev->bus ? dev->bus->name : "No Bus", dev->kobj.name);
+		 dev->bus ? dev->bus->name : "No Bus",
+		 kobject_name(&dev->kobj));
 	down(&dpm_list_sem);
 	list_add_tail(&dev->power.entry, &dpm_active);
 	device_pm_set_parent(dev, dev->parent);
@@ -67,7 +68,8 @@ int device_pm_add(struct device * dev)
 void device_pm_remove(struct device * dev)
 {
 	pr_debug("PM: Removing info for %s:%s\n",
-		 dev->bus ? dev->bus->name : "No Bus", dev->kobj.name);
+		 dev->bus ? dev->bus->name : "No Bus",
+		 kobject_name(&dev->kobj));
 	down(&dpm_list_sem);
 	dpm_sysfs_remove(dev);
 	put_device(dev->power.pm_parent);
_

Patches currently in -mm which might be from dtor@insightbb.com are

pm-use-kobject_name-to-access-kobject-names.patch
git-input.patch
convert-input-core-to-struct-device.patch
add-locking-to-evdev.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-fix.patch

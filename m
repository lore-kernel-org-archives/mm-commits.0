From: akpm@linux-foundation.org
Subject: - use-warn-in-drivers-base.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:16:22 -0700
Message-ID: <200807262116.m6QLGMur019824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757680AbYGZVQY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:16:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, greg@kroah.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Use WARN() in drivers/base/
has been removed from the -mm tree.  Its filename was
     use-warn-in-drivers-base.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use WARN() in drivers/base/
From: Arjan van de Ven <arjan@linux.intel.com>

Use WARN() instead of a printk+WARN_ON() pair; this way the message
becomes part of the warning section for better reporting/collection.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c   |    6 ++----
 drivers/base/memory.c |    3 +--
 drivers/base/sys.c    |   12 ++++--------
 3 files changed, 7 insertions(+), 14 deletions(-)

diff -puN drivers/base/core.c~use-warn-in-drivers-base drivers/base/core.c
--- a/drivers/base/core.c~use-warn-in-drivers-base
+++ a/drivers/base/core.c
@@ -116,12 +116,10 @@ static void device_release(struct kobjec
 		dev->type->release(dev);
 	else if (dev->class && dev->class->dev_release)
 		dev->class->dev_release(dev);
-	else {
-		printk(KERN_ERR "Device '%s' does not have a release() "
+	else
+		WARN(1, KERN_ERR "Device '%s' does not have a release() "
 			"function, it is broken and must be fixed.\n",
 			dev->bus_id);
-		WARN_ON(1);
-	}
 }
 
 static struct kobj_type device_ktype = {
diff -puN drivers/base/memory.c~use-warn-in-drivers-base drivers/base/memory.c
--- a/drivers/base/memory.c~use-warn-in-drivers-base
+++ a/drivers/base/memory.c
@@ -204,9 +204,8 @@ memory_block_action(struct memory_block 
 			}
 			break;
 		default:
-			printk(KERN_WARNING "%s(%p, %ld) unknown action: %ld\n",
+			WARN(1, KERN_WARNING "%s(%p, %ld) unknown action: %ld\n",
 					__func__, mem, action, action);
-			WARN_ON(1);
 			ret = -EINVAL;
 	}
 
diff -puN drivers/base/sys.c~use-warn-in-drivers-base drivers/base/sys.c
--- a/drivers/base/sys.c~use-warn-in-drivers-base
+++ a/drivers/base/sys.c
@@ -168,19 +168,16 @@ int sysdev_driver_register(struct sysdev
 	int err = 0;
 
 	if (!cls) {
-		printk(KERN_WARNING "sysdev: invalid class passed to "
+		WARN(1, KERN_WARNING "sysdev: invalid class passed to "
 			"sysdev_driver_register!\n");
-		WARN_ON(1);
 		return -EINVAL;
 	}
 
 	/* Check whether this driver has already been added to a class. */
-	if (drv->entry.next && !list_empty(&drv->entry)) {
-		printk(KERN_WARNING "sysdev: class %s: driver (%p) has already"
+	if (drv->entry.next && !list_empty(&drv->entry))
+		WARN(1, KERN_WARNING "sysdev: class %s: driver (%p) has already"
 			" been registered to a class, something is wrong, but "
 			"will forge on!\n", cls->name, drv);
-		WARN_ON(1);
-	}
 
 	mutex_lock(&sysdev_drivers_lock);
 	if (cls && kset_get(&cls->kset)) {
@@ -194,8 +191,7 @@ int sysdev_driver_register(struct sysdev
 		}
 	} else {
 		err = -EINVAL;
-		printk(KERN_ERR "%s: invalid device class\n", __func__);
-		WARN_ON(1);
+		WARN(1, KERN_ERR "%s: invalid device class\n", __func__);
 	}
 	mutex_unlock(&sysdev_drivers_lock);
 	return err;
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
via-velocity-fix-sleep-with-spinlock-bug-during-mtu-change.patch
modules-extend-initcall_debug-functionality-to-the-module-loader.patch
use-warn-in-kernel-lockdepc.patch
use-warn-in-arch-x86-mm-ioremapc.patch
use-warn-in-arch-x86-mm-pageattrc.patch
use-warn-in-arch-x86-kernel.patch


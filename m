From: akpm@linux-foundation.org
Subject: + drivers-base-attribute_containerc-use-mutex-instead-of-binary-semaphore.patch added to -mm tree
Date: Sat, 21 Apr 2007 19:19:12 -0700
Message-ID: <200704220219.l3M2JCGV017749@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753990AbXDVCTP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Apr 2007 22:19:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, greg@kroah.com


The patch titled
     drivers/base/attribute_container.c: use mutex instead of binary semaphore
has been added to the -mm tree.  Its filename is
     drivers-base-attribute_containerc-use-mutex-instead-of-binary-semaphore.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/base/attribute_container.c: use mutex instead of binary semaphore
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

use mutex instead of binary semaphore in
drivers/base/attribute_container.c

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/attribute_container.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/base/attribute_container.c~drivers-base-attribute_containerc-use-mutex-instead-of-binary-semaphore drivers/base/attribute_container.c
--- a/drivers/base/attribute_container.c~drivers-base-attribute_containerc-use-mutex-instead-of-binary-semaphore
+++ a/drivers/base/attribute_container.c
@@ -62,7 +62,7 @@ EXPORT_SYMBOL_GPL(attribute_container_cl
 
 static struct list_head attribute_container_list;
 
-static DECLARE_MUTEX(attribute_container_mutex);
+static DEFINE_MUTEX(attribute_container_mutex);
 
 /**
  * attribute_container_register - register an attribute container
@@ -77,9 +77,9 @@ attribute_container_register(struct attr
 	klist_init(&cont->containers,internal_container_klist_get,
 		   internal_container_klist_put);
 		
-	down(&attribute_container_mutex);
+	mutex_lock(&attribute_container_mutex);
 	list_add_tail(&cont->node, &attribute_container_list);
-	up(&attribute_container_mutex);
+	mutex_unlock(&attribute_container_mutex);
 
 	return 0;
 }
@@ -94,7 +94,7 @@ int
 attribute_container_unregister(struct attribute_container *cont)
 {
 	int retval = -EBUSY;
-	down(&attribute_container_mutex);
+	mutex_lock(&attribute_container_mutex);
 	spin_lock(&cont->containers.k_lock);
 	if (!list_empty(&cont->containers.k_list))
 		goto out;
@@ -102,7 +102,7 @@ attribute_container_unregister(struct at
 	list_del(&cont->node);
  out:
 	spin_unlock(&cont->containers.k_lock);
-	up(&attribute_container_mutex);
+	mutex_unlock(&attribute_container_mutex);
 	return retval;
 		
 }
@@ -145,7 +145,7 @@ attribute_container_add_device(struct de
 {
 	struct attribute_container *cont;
 
-	down(&attribute_container_mutex);
+	mutex_lock(&attribute_container_mutex);
 	list_for_each_entry(cont, &attribute_container_list, node) {
 		struct internal_container *ic;
 
@@ -173,7 +173,7 @@ attribute_container_add_device(struct de
 			attribute_container_add_class_device(&ic->classdev);
 		klist_add_tail(&ic->node, &cont->containers);
 	}
-	up(&attribute_container_mutex);
+	mutex_unlock(&attribute_container_mutex);
 }
 
 /* FIXME: can't break out of this unless klist_iter_exit is also
@@ -211,7 +211,7 @@ attribute_container_remove_device(struct
 {
 	struct attribute_container *cont;
 
-	down(&attribute_container_mutex);
+	mutex_lock(&attribute_container_mutex);
 	list_for_each_entry(cont, &attribute_container_list, node) {
 		struct internal_container *ic;
 		struct klist_iter iter;
@@ -234,7 +234,7 @@ attribute_container_remove_device(struct
 			}
 		}
 	}
-	up(&attribute_container_mutex);
+	mutex_unlock(&attribute_container_mutex);
 }
 
 /**
@@ -255,7 +255,7 @@ attribute_container_device_trigger(struc
 {
 	struct attribute_container *cont;
 
-	down(&attribute_container_mutex);
+	mutex_lock(&attribute_container_mutex);
 	list_for_each_entry(cont, &attribute_container_list, node) {
 		struct internal_container *ic;
 		struct klist_iter iter;
@@ -273,7 +273,7 @@ attribute_container_device_trigger(struc
 				fn(cont, dev, &ic->classdev);
 		}
 	}
-	up(&attribute_container_mutex);
+	mutex_unlock(&attribute_container_mutex);
 }
 
 /**
@@ -295,12 +295,12 @@ attribute_container_trigger(struct devic
 {
 	struct attribute_container *cont;
 
-	down(&attribute_container_mutex);
+	mutex_lock(&attribute_container_mutex);
 	list_for_each_entry(cont, &attribute_container_list, node) {
 		if (cont->match(cont, dev))
 			fn(cont, dev);
 	}
-	up(&attribute_container_mutex);
+	mutex_unlock(&attribute_container_mutex);
 }
 
 /**
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
drivers-base-attribute_containerc-use-mutex-instead-of-binary-semaphore.patch
irda_device_dongle_init-fix-kzallocgfp_kernel-in-spinlock.patch
use-mutex-instead-of-binary-semaphore-in-fore-systems-200e-series-driver-for-atm.patch
qla1280-use-dma_64bit_mask-instead-of-0ull.patch
include-kern_-constant-in-printk-calls-in-mm-slabc.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
fix-spinlock-usage-in-hysdn_log_close.patch

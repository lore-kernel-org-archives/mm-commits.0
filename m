From: akpm@linux-foundation.org
Subject: - isapnp-driver-semaphore-to-mutex.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:30:20 -0800
Message-ID: <200802070030.m170U1Kw007344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60161 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934423AbYBGAsE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:48:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, bjorn.helgaas@hp.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     isapnp driver semaphore to mutex
has been removed from the -mm tree.  Its filename was
     isapnp-driver-semaphore-to-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isapnp driver semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>

Changed the isapnp semaphore to a mutex.

[akpm@linux-foundation.org: no externs-in-c]
[akpm@linux-foundation.org: build fix]
Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/interface.c |   13 +++++++------
 drivers/pnp/manager.c   |   19 ++++++++++---------
 include/linux/pnp.h     |    1 +
 3 files changed, 18 insertions(+), 15 deletions(-)

diff -puN drivers/pnp/interface.c~isapnp-driver-semaphore-to-mutex drivers/pnp/interface.c
--- a/drivers/pnp/interface.c~isapnp-driver-semaphore-to-mutex
+++ a/drivers/pnp/interface.c
@@ -10,9 +10,12 @@
 #include <linux/errno.h>
 #include <linux/list.h>
 #include <linux/types.h>
+#include <linux/pnp.h>
 #include <linux/stat.h>
 #include <linux/ctype.h>
 #include <linux/slab.h>
+#include <linux/mutex.h>
+
 #include <asm/uaccess.h>
 
 #include "base.h"
@@ -315,8 +318,6 @@ static ssize_t pnp_show_current_resource
 	return ret;
 }
 
-extern struct semaphore pnp_res_mutex;
-
 static ssize_t
 pnp_set_current_resources(struct device *dmdev, struct device_attribute *attr,
 			  const char *ubuf, size_t count)
@@ -361,10 +362,10 @@ pnp_set_current_resources(struct device 
 		goto done;
 	}
 	if (!strnicmp(buf, "get", 3)) {
-		down(&pnp_res_mutex);
+		mutex_lock(&pnp_res_mutex);
 		if (pnp_can_read(dev))
 			dev->protocol->get(dev, &dev->res);
-		up(&pnp_res_mutex);
+		mutex_unlock(&pnp_res_mutex);
 		goto done;
 	}
 	if (!strnicmp(buf, "set", 3)) {
@@ -373,7 +374,7 @@ pnp_set_current_resources(struct device 
 			goto done;
 		buf += 3;
 		pnp_init_resource_table(&dev->res);
-		down(&pnp_res_mutex);
+		mutex_lock(&pnp_res_mutex);
 		while (1) {
 			while (isspace(*buf))
 				++buf;
@@ -455,7 +456,7 @@ pnp_set_current_resources(struct device 
 			}
 			break;
 		}
-		up(&pnp_res_mutex);
+		mutex_unlock(&pnp_res_mutex);
 		goto done;
 	}
 
diff -puN drivers/pnp/manager.c~isapnp-driver-semaphore-to-mutex drivers/pnp/manager.c
--- a/drivers/pnp/manager.c~isapnp-driver-semaphore-to-mutex
+++ a/drivers/pnp/manager.c
@@ -12,9 +12,10 @@
 #include <linux/pnp.h>
 #include <linux/slab.h>
 #include <linux/bitmap.h>
+#include <linux/mutex.h>
 #include "base.h"
 
-DECLARE_MUTEX(pnp_res_mutex);
+DEFINE_MUTEX(pnp_res_mutex);
 
 static int pnp_assign_port(struct pnp_dev *dev, struct pnp_port *rule, int idx)
 {
@@ -297,7 +298,7 @@ static int pnp_assign_resources(struct p
 	if (!pnp_can_configure(dev))
 		return -ENODEV;
 
-	down(&pnp_res_mutex);
+	mutex_lock(&pnp_res_mutex);
 	pnp_clean_resource_table(&dev->res);	/* start with a fresh slate */
 	if (dev->independent) {
 		port = dev->independent->port;
@@ -366,12 +367,12 @@ static int pnp_assign_resources(struct p
 	} else if (dev->dependent)
 		goto fail;
 
-	up(&pnp_res_mutex);
+	mutex_unlock(&pnp_res_mutex);
 	return 1;
 
 fail:
 	pnp_clean_resource_table(&dev->res);
-	up(&pnp_res_mutex);
+	mutex_unlock(&pnp_res_mutex);
 	return 0;
 }
 
@@ -396,7 +397,7 @@ int pnp_manual_config_dev(struct pnp_dev
 		return -ENOMEM;
 	*bak = dev->res;
 
-	down(&pnp_res_mutex);
+	mutex_lock(&pnp_res_mutex);
 	dev->res = *res;
 	if (!(mode & PNP_CONFIG_FORCE)) {
 		for (i = 0; i < PNP_MAX_PORT; i++) {
@@ -416,14 +417,14 @@ int pnp_manual_config_dev(struct pnp_dev
 				goto fail;
 		}
 	}
-	up(&pnp_res_mutex);
+	mutex_unlock(&pnp_res_mutex);
 
 	kfree(bak);
 	return 0;
 
 fail:
 	dev->res = *bak;
-	up(&pnp_res_mutex);
+	mutex_unlock(&pnp_res_mutex);
 	kfree(bak);
 	return -EINVAL;
 }
@@ -547,9 +548,9 @@ int pnp_disable_dev(struct pnp_dev *dev)
 	dev->active = 0;
 
 	/* release the resources so that other devices can use them */
-	down(&pnp_res_mutex);
+	mutex_lock(&pnp_res_mutex);
 	pnp_clean_resource_table(&dev->res);
-	up(&pnp_res_mutex);
+	mutex_unlock(&pnp_res_mutex);
 
 	return 0;
 }
diff -puN include/linux/pnp.h~isapnp-driver-semaphore-to-mutex include/linux/pnp.h
--- a/include/linux/pnp.h~isapnp-driver-semaphore-to-mutex
+++ a/include/linux/pnp.h
@@ -258,6 +258,7 @@ extern struct pnp_protocol isapnp_protoc
 #else
 #define pnp_device_is_isapnp(dev) 0
 #endif
+extern struct mutex pnp_res_mutex;
 
 #ifdef CONFIG_PNPBIOS
 extern struct pnp_protocol pnpbios_protocol;
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
driver-base-memory-semaphore-to-mutex.patch
usb-microtek-remove-unused-semaphore.patch
usb-libusual-locking-cleanup.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch

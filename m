From: akpm@linux-foundation.org
Subject: + isapnp-driver-semaphore-to-mutex.patch added to -mm tree
Date: Mon, 03 Dec 2007 21:55:38 -0800
Message-ID: <200712040555.lB45tcjd003451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39445 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475AbXLDF4m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 00:56:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, bjorn.helgaas@hp.com, mingo@elte.hu


The patch titled
     isapnp driver semaphore to mutex
has been added to the -mm tree.  Its filename is
     isapnp-driver-semaphore-to-mutex.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: isapnp driver semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>

Changed the isapnp semaphore to a mutex.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/interface.c |   11 ++++++-----
 drivers/pnp/manager.c   |   19 ++++++++++---------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff -puN drivers/pnp/interface.c~isapnp-driver-semaphore-to-mutex drivers/pnp/interface.c
--- a/drivers/pnp/interface.c~isapnp-driver-semaphore-to-mutex
+++ a/drivers/pnp/interface.c
@@ -13,6 +13,7 @@
 #include <linux/stat.h>
 #include <linux/ctype.h>
 #include <linux/slab.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 
 #include "base.h"
@@ -315,7 +316,7 @@ static ssize_t pnp_show_current_resource
 	return ret;
 }
 
-extern struct semaphore pnp_res_mutex;
+extern struct mutex pnp_res_mutex;
 
 static ssize_t
 pnp_set_current_resources(struct device *dmdev, struct device_attribute *attr,
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
_

Patches currently in -mm which might be from dwalker@mvista.com are

isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch

From: akpm@linux-foundation.org
Subject: + uevent-improve-error-checking-and-handling.patch added to -mm tree
Date: Wed, 07 Mar 2007 14:18:02 -0800
Message-ID: <200703072218.l27MI2B2010877@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34265 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965698AbXCGWSH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 17:18:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.rannaud@gmail.com, greg@kroah.com


The patch titled
     uevent: improve error checking and handling
has been added to the -mm tree.  Its filename is
     uevent-improve-error-checking-and-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uevent: improve error checking and handling
From: Eric Rannaud <eric.rannaud@gmail.com>

add_uevent_var() is used w/o checking for its return value, even though it
is possible for those calls to return -ENOMEM.

Signed-off-by: Eric Rannaud <eric.rannaud@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |   89 ++++++++++++++++++++++++++----------------
 1 files changed, 57 insertions(+), 32 deletions(-)

diff -puN drivers/base/core.c~uevent-improve-error-checking-and-handling drivers/base/core.c
--- a/drivers/base/core.c~uevent-improve-error-checking-and-handling
+++ a/drivers/base/core.c
@@ -162,18 +162,25 @@ static int dev_uevent(struct kset *kset,
 
 	/* add the major/minor if present */
 	if (MAJOR(dev->devt)) {
-		add_uevent_var(envp, num_envp, &i,
-			       buffer, buffer_size, &length,
-			       "MAJOR=%u", MAJOR(dev->devt));
-		add_uevent_var(envp, num_envp, &i,
-			       buffer, buffer_size, &length,
-			       "MINOR=%u", MINOR(dev->devt));
+		retval = add_uevent_var(envp, num_envp, &i,
+					buffer, buffer_size, &length,
+					"MAJOR=%u", MAJOR(dev->devt));
+		if (retval)
+			return retval;
+		retval = add_uevent_var(envp, num_envp, &i,
+					buffer, buffer_size, &length,
+					"MINOR=%u", MINOR(dev->devt));
+		if (retval)
+			return retval;
 	}
 
-	if (dev->driver)
-		add_uevent_var(envp, num_envp, &i,
-			       buffer, buffer_size, &length,
-			       "DRIVER=%s", dev->driver->name);
+	if (dev->driver) {
+		retval = add_uevent_var(envp, num_envp, &i,
+					buffer, buffer_size, &length,
+					"DRIVER=%s", dev->driver->name);
+		if (retval)
+			return retval;
+	}
 
 #ifdef CONFIG_SYSFS_DEPRECATED
 	if (dev->class) {
@@ -186,29 +193,41 @@ static int dev_uevent(struct kset *kset,
 			const char *path;
 
 			path = kobject_get_path(&parent->kobj, GFP_KERNEL);
-			add_uevent_var(envp, num_envp, &i,
-				       buffer, buffer_size, &length,
-				       "PHYSDEVPATH=%s", path);
+			retval = add_uevent_var(envp, num_envp, &i,
+						buffer, buffer_size, &length,
+						"PHYSDEVPATH=%s", path);
 			kfree(path);
+			if (retval)
+				return retval;
 
-			add_uevent_var(envp, num_envp, &i,
-				       buffer, buffer_size, &length,
-				       "PHYSDEVBUS=%s", parent->bus->name);
-
-			if (parent->driver)
-				add_uevent_var(envp, num_envp, &i,
-					       buffer, buffer_size, &length,
-					       "PHYSDEVDRIVER=%s", parent->driver->name);
+			retval = add_uevent_var(envp, num_envp, &i,
+						buffer, buffer_size, &length,
+						"PHYSDEVBUS=%s", parent->bus->name);
+			if (retval)
+				return retval;
+
+			if (parent->driver) {
+				retval = add_uevent_var(envp, num_envp, &i,
+							buffer, buffer_size, &length,
+							"PHYSDEVDRIVER=%s", parent->driver->name);
+				if (retval)
+					return retval;
+			}
 		}
 	} else if (dev->bus) {
-		add_uevent_var(envp, num_envp, &i,
-			       buffer, buffer_size, &length,
-			       "PHYSDEVBUS=%s", dev->bus->name);
+		retval = add_uevent_var(envp, num_envp, &i,
+					buffer, buffer_size, &length,
+					"PHYSDEVBUS=%s", dev->bus->name);
+		if (retval)
+			return retval;
 
-		if (dev->driver)
-			add_uevent_var(envp, num_envp, &i,
-				       buffer, buffer_size, &length,
-				       "PHYSDEVDRIVER=%s", dev->driver->name);
+		if (dev->driver) {
+			retval = add_uevent_var(envp, num_envp, &i,
+						buffer, buffer_size, &length,
+						"PHYSDEVDRIVER=%s", dev->driver->name);
+			if (retval)
+				return retval;
+		}
 	}
 #endif
 
@@ -222,27 +241,33 @@ static int dev_uevent(struct kset *kset,
 	if (dev->bus && dev->bus->uevent) {
 		/* have the bus specific function add its stuff */
 		retval = dev->bus->uevent(dev, envp, num_envp, buffer, buffer_size);
-		if (retval)
+		if (retval) {
 			pr_debug ("%s: bus uevent() returned %d\n",
 				  __FUNCTION__, retval);
+			goto out;
+		}
 	}
 
 	if (dev->class && dev->class->dev_uevent) {
 		/* have the class specific function add its stuff */
 		retval = dev->class->dev_uevent(dev, envp, num_envp, buffer, buffer_size);
-		if (retval)
+		if (retval) {
 			pr_debug("%s: class uevent() returned %d\n",
 				 __FUNCTION__, retval);
+			goto out;
+		}
 	}
 
 	if (dev->type && dev->type->uevent) {
 		/* have the device type specific fuction add its stuff */
 		retval = dev->type->uevent(dev, envp, num_envp, buffer, buffer_size);
-		if (retval)
+		if (retval) {
 			pr_debug("%s: dev_type uevent() returned %d\n",
 				 __FUNCTION__, retval);
+			goto out;
+		}
 	}
-
+out:
 	return retval;
 }
 
_

Patches currently in -mm which might be from eric.rannaud@gmail.com are

uevent-improve-error-checking-and-handling.patch
uevent-use-add_uevent_var-instead-of-open-coding-it.patch

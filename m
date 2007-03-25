From: akpm@linux-foundation.org
Subject: + ibmebus-change-probe-remove-interface-from-using-loc-code-to-dt-path.patch added to -mm tree
Date: Sat, 24 Mar 2007 23:28:41 -0800
Message-ID: <200703250728.l2P7SfpS022801@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34970 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbXCYH25 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 03:28:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fenkes@de.ibm.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     ibmebus: change probe/remove interface from using loc-code to DT path
has been added to the -mm tree.  Its filename is
     ibmebus-change-probe-remove-interface-from-using-loc-code-to-dt-path.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ibmebus: change probe/remove interface from using loc-code to DT path
From: Joachim Fenkes <fenkes@de.ibm.com>

In some cases, multiple OFDT nodes might share the same location code, so
the location code is not a unique identifier for an OFDT node.  Changed the
ibmebus probe/remove interface to use the DT path of the device node
instead of the location code.

The DT path must be written into probe/remove right as it would appear in
the "devspec" attribute of the ebus device: relative to the DT root, with a
leading slash and without a trailing slash.  One trailing newline will not
hurt; multiple newlines will (like perl's chomp()).

Example:

 Add a device "/proc/device-tree/foo@12345678" to ibmebus like this:
    echo /foo@12345678 > /sys/bus/ibmebus/probe

 Remove the device like this:
    echo /foo@12345678 > /sys/bus/ibmebus/remove

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/ibmebus.c |  118 ++++++++++++++++----------------
 1 file changed, 61 insertions(+), 57 deletions(-)

diff -puN arch/powerpc/kernel/ibmebus.c~ibmebus-change-probe-remove-interface-from-using-loc-code-to-dt-path arch/powerpc/kernel/ibmebus.c
--- a/arch/powerpc/kernel/ibmebus.c~ibmebus-change-probe-remove-interface-from-using-loc-code-to-dt-path
+++ a/arch/powerpc/kernel/ibmebus.c
@@ -44,8 +44,6 @@
 #include <asm/ibmebus.h>
 #include <asm/abs_addr.h>
 
-#define MAX_LOC_CODE_LENGTH 80
-
 static struct device ibmebus_bus_device = { /* fake "parent" device */
 	.bus_id = "ibmebus",
 };
@@ -253,7 +251,7 @@ static void ibmebus_add_devices_by_id(st
 	return;
 }
 
-static int ibmebus_match_helper_name(struct device *dev, void *data)
+static int ibmebus_match_name(struct device *dev, void *data)
 {
 	const struct ibmebus_dev *ebus_dev = to_ibmebus_dev(dev);
 	char *name;
@@ -281,7 +279,7 @@ static void ibmebus_remove_devices_by_id
 	while (strlen(idt->name) > 0) {
 		while ((dev = bus_find_device(&ibmebus_bus_type, NULL,
 					      (void*)idt->name,
-					      ibmebus_match_helper_name))) {
+					      ibmebus_match_name))) {
 			ibmebus_unregister_device(dev);
 		}
 		idt++;
@@ -372,18 +370,30 @@ static struct device_attribute ibmebus_d
 	__ATTR_NULL
 };
 
-static int ibmebus_match_helper_loc_code(struct device *dev, void *data)
+static int ibmebus_match_path(struct device *dev, void *data)
 {
-	const struct ibmebus_dev *ebus_dev = to_ibmebus_dev(dev);
-	char *loc_code;
+	int rc;
+	struct device_node *dn =
+		of_node_get(to_ibmebus_dev(dev)->ofdev.node);
 
-	loc_code = (char*)get_property(
-		ebus_dev->ofdev.node, "ibm,loc-code", NULL);
+	rc = (dn->full_name && (strcasecmp((char*)data, dn->full_name) == 0));
 
-	if (loc_code && (strcmp((char*)data, loc_code) == 0))
-		return 1;
+	of_node_put(dn);
+	return rc;
+}
 
-	return 0;
+static char *ibmebus_chomp(const char *in, size_t count)
+{
+	char *out = (char*)kmalloc(count + 1, GFP_KERNEL);
+	if (!out)
+		return NULL;
+
+	memcpy(out, in, count);
+	out[count] = '\0';
+	if (out[count - 1] == '\n')
+		out[count - 1] = '\0';
+
+	return out;
 }
 
 static ssize_t ibmebus_store_probe(struct bus_type *bus,
@@ -391,65 +401,59 @@ static ssize_t ibmebus_store_probe(struc
 {
 	struct device_node *dn = NULL;
 	struct ibmebus_dev *dev;
-	char *loc_code;
-	char parm[MAX_LOC_CODE_LENGTH];
-
-	if (count >= MAX_LOC_CODE_LENGTH)
-		return -EINVAL;
-	memcpy(parm, buf, count);
-	parm[count] = '\0';
-	if (parm[count-1] == '\n')
-		parm[count-1] = '\0';
-
-	if (bus_find_device(&ibmebus_bus_type, NULL, parm,
-			     ibmebus_match_helper_loc_code)) {
-		printk(KERN_WARNING "%s: loc_code %s has already been probed\n",
-		       __FUNCTION__, parm);
-		return -EINVAL;
-	}
+	char *path;
+	ssize_t rc;
 
-	while ((dn = of_find_all_nodes(dn))) {
-		loc_code = (char *)get_property(dn, "ibm,loc-code", NULL);
-		if (loc_code && (strncmp(loc_code, parm, count) == 0)) {
-			dev = ibmebus_register_device_node(dn);
-			if (IS_ERR(dev)) {
-				of_node_put(dn);
-				return PTR_ERR(dev);
-			} else
-				return count; /* success */
-		}
+	path = ibmebus_chomp(buf, count);
+	if (!path)
+		return -ENOMEM;
+
+	if (bus_find_device(&ibmebus_bus_type, NULL, path,
+			     ibmebus_match_path)) {
+		printk(KERN_WARNING "%s: %s has already been probed\n",
+		       __FUNCTION__, path);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if ((dn = of_find_node_by_path(path))) {
+		dev = ibmebus_register_device_node(dn);
+		of_node_put(dn);
+		rc = IS_ERR(dev) ? PTR_ERR(dev) : count;
+	} else {
+		printk(KERN_WARNING "%s: no such device node: %s",
+		       __FUNCTION__, path);
+		rc = -ENODEV;
 	}
 
-	/* if we drop out of the loop, the loc code was invalid */
-	printk(KERN_WARNING "%s: no device with loc_code %s found\n",
-	       __FUNCTION__, parm);
-	return -ENODEV;
+out:
+	kfree(path);
+	return rc;
 }
 
 static ssize_t ibmebus_store_remove(struct bus_type *bus,
 				    const char *buf, size_t count)
 {
 	struct device *dev;
-	char parm[MAX_LOC_CODE_LENGTH];
+	char *path;
 
-	if (count >= MAX_LOC_CODE_LENGTH)
-		return -EINVAL;
-	memcpy(parm, buf, count);
-	parm[count] = '\0';
-	if (parm[count-1] == '\n')
-		parm[count-1] = '\0';
-
-	/* The location code is unique, so we will find one device at most */
-	if ((dev = bus_find_device(&ibmebus_bus_type, NULL, parm,
-				   ibmebus_match_helper_loc_code))) {
+	path = ibmebus_chomp(buf, count);
+	if (!path)
+		return -ENOMEM;
+
+	if ((dev = bus_find_device(&ibmebus_bus_type, NULL, path,
+				   ibmebus_match_path))) {
 		ibmebus_unregister_device(dev);
+
+		kfree(path);
+		return count;
 	} else {
-		printk(KERN_WARNING "%s: loc_code %s not on the bus\n",
-		       __FUNCTION__, parm);
+		printk(KERN_WARNING "%s: %s not on the bus\n",
+		       __FUNCTION__, path);
+
+		kfree(path);
 		return -ENODEV;
 	}
-
-	return count;
 }
 
 static struct bus_attribute ibmebus_bus_attrs[] = {
_

Patches currently in -mm which might be from fenkes@de.ibm.com are

origin.patch
git-powerpc.patch
ibmebus-uevent-support.patch
ibmebus-change-probe-remove-interface-from-using-loc-code-to-dt-path.patch

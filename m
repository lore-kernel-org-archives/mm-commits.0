From: akpm@linux-foundation.org
Subject: - uevent-use-add_uevent_var-instead-of-open-coding-it.patch removed from -mm tree
Date: Thu, 19 Apr 2007 13:02:18 -0700
Message-ID: <200704192002.l3JK2IXs029376@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766987AbXDSUC3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 16:02:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.rannaud@gmail.com, cornelia.huck@de.ibm.com, greg@kroah.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     uevent: use add_uevent_var() instead of open coding it
has been removed from the -mm tree.  Its filename was
     uevent-use-add_uevent_var-instead-of-open-coding-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uevent: use add_uevent_var() instead of open coding it
From: Eric Rannaud <eric.rannaud@gmail.com>

Make use of add_uevent_var() instead of (often incorrectly) open coding it.

Signed-off-by: Eric Rannaud <eric.rannaud@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 aoa/soundbus/core.c          |    0 
 drivers/amba/bus.c           |   13 ++++++-------
 drivers/ieee1394/nodemgr.c   |   14 ++++++--------
 drivers/mmc/mmc_sysfs.c      |   25 ++++++++++---------------
 drivers/s390/crypto/ap_bus.c |   28 +++++++++++++---------------
 net/core/net-sysfs.c         |   27 ++++++++++++++-------------
 6 files changed, 49 insertions(+), 58 deletions(-)

diff -puN drivers/amba/bus.c~uevent-use-add_uevent_var-instead-of-open-coding-it drivers/amba/bus.c
--- a/drivers/amba/bus.c~uevent-use-add_uevent_var-instead-of-open-coding-it
+++ a/drivers/amba/bus.c
@@ -47,14 +47,13 @@ static int amba_match(struct device *dev
 static int amba_uevent(struct device *dev, char **envp, int nr_env, char *buf, int bufsz)
 {
 	struct amba_device *pcdev = to_amba_device(dev);
+	int retval = 0, i = 0, len = 0;
 
-	if (nr_env < 2)
-		return -ENOMEM;
-
-	snprintf(buf, bufsz, "AMBA_ID=%08x", pcdev->periphid);
-	*envp++ = buf;
-	*envp++ = NULL;
-	return 0;
+	retval = add_uevent_var(envp, nr_env, &i,
+				buf, bufsize, &len,
+				"AMBA_ID=%08x", pcdev->periphid);
+	envp[i] = NULL;
+	return retval;
 }
 #else
 #define amba_uevent NULL
diff -puN drivers/ieee1394/nodemgr.c~uevent-use-add_uevent_var-instead-of-open-coding-it drivers/ieee1394/nodemgr.c
--- a/drivers/ieee1394/nodemgr.c~uevent-use-add_uevent_var-instead-of-open-coding-it
+++ a/drivers/ieee1394/nodemgr.c
@@ -1161,6 +1161,7 @@ static int nodemgr_uevent(struct class_d
 	struct unit_directory *ud;
 	int i = 0;
 	int length = 0;
+	int retval = 0;
 	/* ieee1394:venNmoNspNverN */
 	char buf[8 + 1 + 3 + 8 + 2 + 8 + 2 + 8 + 3 + 8 + 1];
 
@@ -1174,14 +1175,11 @@ static int nodemgr_uevent(struct class_d
 
 #define PUT_ENVP(fmt,val) 					\
 do {								\
-    	int printed;						\
-	envp[i++] = buffer;					\
-	printed = snprintf(buffer, buffer_size - length,	\
-			   fmt, val);				\
-	if ((buffer_size - (length+printed) <= 0) || (i >= num_envp))	\
-		return -ENOMEM;					\
-	length += printed+1;					\
-	buffer += printed+1;					\
+	retval = add_uevent_var(envp, num_envp, &i,		\
+				buffer, buffer_size, &length,	\
+				fmt, val);			\
+	if (retval)						\
+		return retval;					\
 } while (0)
 
 	PUT_ENVP("VENDOR_ID=%06x", ud->vendor_id);
diff -puN drivers/mmc/mmc_sysfs.c~uevent-use-add_uevent_var-instead-of-open-coding-it drivers/mmc/mmc_sysfs.c
--- a/drivers/mmc/mmc_sysfs.c~uevent-use-add_uevent_var-instead-of-open-coding-it
+++ a/drivers/mmc/mmc_sysfs.c
@@ -86,31 +86,26 @@ mmc_bus_uevent(struct device *dev, char 
 {
 	struct mmc_card *card = dev_to_mmc_card(dev);
 	char ccc[13];
-	int i = 0;
+	int retval = 0, i = 0, length = 0;
 
-#define add_env(fmt,val)						\
-	({								\
-		int len, ret = -ENOMEM;					\
-		if (i < num_envp) {					\
-			envp[i++] = buf;				\
-			len = snprintf(buf, buf_size, fmt, val) + 1;	\
-			buf_size -= len;				\
-			buf += len;					\
-			if (buf_size >= 0)				\
-				ret = 0;				\
-		}							\
-		ret;							\
-	})
+#define add_env(fmt,val) do {					\
+	retval = add_uevent_var(envp, num_envp, &i,		\
+				buf, buf_size, &length,		\
+				fmt, val);			\
+	if (retval)						\
+		return retval;					\
+} while (0);
 
 	for (i = 0; i < 12; i++)
 		ccc[i] = card->csd.cmdclass & (1 << i) ? '1' : '0';
 	ccc[12] = '\0';
 
-	i = 0;
 	add_env("MMC_CCC=%s", ccc);
 	add_env("MMC_MANFID=%06x", card->cid.manfid);
 	add_env("MMC_NAME=%s", mmc_card_name(card));
 	add_env("MMC_OEMID=%04x", card->cid.oemid);
+#undef add_env
+	envp[i] = NULL;
 
 	return 0;
 }
diff -puN drivers/s390/crypto/ap_bus.c~uevent-use-add_uevent_var-instead-of-open-coding-it drivers/s390/crypto/ap_bus.c
--- a/drivers/s390/crypto/ap_bus.c~uevent-use-add_uevent_var-instead-of-open-coding-it
+++ a/drivers/s390/crypto/ap_bus.c
@@ -423,27 +423,25 @@ static int ap_uevent (struct device *dev
 		       char *buffer, int buffer_size)
 {
 	struct ap_device *ap_dev = to_ap_dev(dev);
-	int length;
+	int retval = 0, length = 0, i = 0;
 
 	if (!ap_dev)
 		return -ENODEV;
 
 	/* Set up DEV_TYPE environment variable. */
-	envp[0] = buffer;
-	length = scnprintf(buffer, buffer_size, "DEV_TYPE=%04X",
-			   ap_dev->device_type);
-	if (buffer_size - length <= 0)
-		return -ENOMEM;
-	buffer += length;
-	buffer_size -= length;
+	retval = add_uevent_var(envp, num_envp, &i,
+				buffer, buffer_size, &length,
+				"DEV_TYPE=%04X", ap_dev->device_type);
+	if (retval)
+		return retval;
+
 	/* Add MODALIAS= */
-	envp[1] = buffer;
-	length = scnprintf(buffer, buffer_size, "MODALIAS=ap:t%02X",
-			   ap_dev->device_type);
-	if (buffer_size - length <= 0)
-		return -ENOMEM;
-	envp[2] = NULL;
-	return 0;
+	retval = add_uevent_var(envp, num_envp, &i,
+				buffer, buffer_size, &length,
+				"MODALIAS=ap:t%02X", ap_dev->device_type);
+
+	envp[i] = NULL;
+	return retval;
 }
 
 static struct bus_type ap_bus_type = {


Patches currently in -mm which might be from eric.rannaud@gmail.com are

s390-cio-delay-uevents-for-subchannels.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch

From: akpm@linux-foundation.org
Subject: - ipmi-add-09-support.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:46:24 -0700
Message-ID: <200710190346.l9J3kOG9013328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50768 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966106AbXJSDzp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cminyard@mvista.com, liste@jordet.net, mm-commits@vger.kernel.org


The patch titled
     IPMI: add 0.9 support
has been removed from the -mm tree.  Its filename was
     ipmi-add-09-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IPMI: add 0.9 support
From: Corey Minyard <cminyard@mvista.com>

Add support for IPMI 0.9 systems to the IPMI driver.  Just handle a shorter
get device ID command with less information.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Stian Jordet <liste@jordet.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |   15 +-----------
 include/linux/ipmi_smi.h         |   36 ++++++++++++++++++++++-------
 2 files changed, 30 insertions(+), 21 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-add-09-support drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-add-09-support
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -2380,20 +2380,9 @@ static int try_get_dev_id(struct smi_inf
 	/* Otherwise, we got some data. */
 	resp_len = smi_info->handlers->get_result(smi_info->si_sm,
 						  resp, IPMI_MAX_MSG_LENGTH);
-	if (resp_len < 14) {
-		/* That's odd, it should be longer. */
-		rv = -EINVAL;
-		goto out;
-	}
-
-	if ((resp[1] != IPMI_GET_DEVICE_ID_CMD) || (resp[2] != 0)) {
-		/* That's odd, it shouldn't be able to fail. */
-		rv = -EINVAL;
-		goto out;
-	}
 
-	/* Record info from the get device id, in case we need it. */
-	ipmi_demangle_device_id(resp+3, resp_len-3, &smi_info->device_id);
+	/* Check and record info from the get device id, in case we need it. */
+	rv = ipmi_demangle_device_id(resp, resp_len, &smi_info->device_id);
 
  out:
 	kfree(resp);
diff -puN include/linux/ipmi_smi.h~ipmi-add-09-support include/linux/ipmi_smi.h
--- a/include/linux/ipmi_smi.h~ipmi-add-09-support
+++ a/include/linux/ipmi_smi.h
@@ -148,26 +148,46 @@ struct ipmi_device_id {
 
 /* Take a pointer to a raw data buffer and a length and extract device
    id information from it.  The first byte of data must point to the
-   byte from the get device id response after the completion code.
-   The caller is responsible for making sure the length is at least
-   11 and the command completed without error. */
-static inline void ipmi_demangle_device_id(unsigned char *data,
-					   unsigned int  data_len,
-					   struct ipmi_device_id *id)
+   netfn << 2, the data should be of the format:
+      netfn << 2, cmd, completion code, data
+   as normally comes from a device interface. */
+static inline int ipmi_demangle_device_id(const unsigned char *data,
+					  unsigned int data_len,
+					  struct ipmi_device_id *id)
 {
+	if (data_len < 9)
+		return -EINVAL;
+	if (data[0] != IPMI_NETFN_APP_RESPONSE << 2 ||
+	    data[1] != IPMI_GET_DEVICE_ID_CMD)
+		/* Strange, didn't get the response we expected. */
+		return -EINVAL;
+	if (data[2] != 0)
+		/* That's odd, it shouldn't be able to fail. */
+		return -EINVAL;
+
+	data += 3;
+	data_len -= 3;
 	id->device_id = data[0];
 	id->device_revision = data[1];
 	id->firmware_revision_1 = data[2];
 	id->firmware_revision_2 = data[3];
 	id->ipmi_version = data[4];
 	id->additional_device_support = data[5];
-	id->manufacturer_id = data[6] | (data[7] << 8) | (data[8] << 16);
-	id->product_id = data[9] | (data[10] << 8);
+	if (data_len >= 6) {
+		id->manufacturer_id = (data[6] | (data[7] << 8) |
+				       (data[8] << 16));
+		id->product_id = data[9] | (data[10] << 8);
+	} else {
+		id->manufacturer_id = 0;
+		id->product_id = 0;
+	}
 	if (data_len >= 15) {
 		memcpy(id->aux_firmware_revision, data+11, 4);
 		id->aux_firmware_revision_set = 1;
 	} else
 		id->aux_firmware_revision_set = 0;
+
+	return 0;
 }
 
 /* Add a low-level interface to the IPMI driver.  Note that if the
_

Patches currently in -mm which might be from cminyard@mvista.com are

origin.patch

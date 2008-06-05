From: akpm@linux-foundation.org
Subject: + dell_rbu-use-memory_read_from_buffer.patch added to -mm tree
Date: Wed, 04 Jun 2008 17:30:01 -0700
Message-ID: <200806050030.m550U2Wh016966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754720AbYFEAaF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 20:30:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, Abhay_Salunke@dell.com, Matt_Domsch@dell.com, rui.zhang@intel.com


The patch titled
     dell_rbu: use memory_read_from_buffer()
has been added to the -mm tree.  Its filename is
     dell_rbu-use-memory_read_from_buffer.patch

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
Subject: dell_rbu: use memory_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Abhay Salunke <Abhay_Salunke@dell.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dell_rbu.c |   29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff -puN drivers/firmware/dell_rbu.c~dell_rbu-use-memory_read_from_buffer drivers/firmware/dell_rbu.c
--- a/drivers/firmware/dell_rbu.c~dell_rbu-use-memory_read_from_buffer
+++ a/drivers/firmware/dell_rbu.c
@@ -44,6 +44,7 @@
 #include <linux/moduleparam.h>
 #include <linux/firmware.h>
 #include <linux/dma-mapping.h>
+#include <linux/fs.h>
 
 MODULE_AUTHOR("Abhay Salunke <abhay_salunke@dell.com>");
 MODULE_DESCRIPTION("Driver for updating BIOS image on DELL systems");
@@ -507,11 +508,6 @@ static ssize_t read_packet_data(char *bu
 
 static ssize_t read_rbu_mono_data(char *buffer, loff_t pos, size_t count)
 {
-	unsigned char *ptemp = NULL;
-	size_t bytes_left = 0;
-	size_t data_length = 0;
-	ssize_t ret_count = 0;
-
 	/* check to see if we have something to return */
 	if ((rbu_data.image_update_buffer == NULL) ||
 		(rbu_data.bios_image_size == 0)) {
@@ -519,28 +515,11 @@ static ssize_t read_rbu_mono_data(char *
 			"bios_image_size %lu\n",
 			rbu_data.image_update_buffer,
 			rbu_data.bios_image_size);
-		ret_count = -ENOMEM;
-		goto read_rbu_data_exit;
-	}
-
-	if (pos > rbu_data.bios_image_size) {
-		ret_count = 0;
-		goto read_rbu_data_exit;
+		return -ENOMEM;
 	}
 
-	bytes_left = rbu_data.bios_image_size - pos;
-	data_length = min(bytes_left, count);
-
-	ptemp = rbu_data.image_update_buffer;
-	memcpy(buffer, (ptemp + pos), data_length);
-
-	if ((pos + count) > rbu_data.bios_image_size)
-		/* this was the last copy */
-		ret_count = bytes_left;
-	else
-		ret_count = count;
-      read_rbu_data_exit:
-	return ret_count;
+	return memory_read_from_buffer(buffer, count, &pos,
+			rbu_data.image_update_buffer, rbu_data.bios_image_size);
 }
 
 static ssize_t read_rbu_data(struct kobject *kobj,
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

lib-export-bitrev16.patch
bluetooth-hci_bcspc-small-cleanups-api-users.patch
bluetooth-hci_bcspc-small-cleanups-api-users-fix.patch
binfmt_misc-use-simple_read_from_buffer.patch
ocfs2-use-simple_read_from_buffer.patch
ipc-use-simple_read_from_buffer.patch
isdn-use-simple_read_from_buffer.patch
s390-vmcp-use-simple_read_from_buffer.patch
s390-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
usbmon-use-simple_read_from_buffer.patch
ttusb-use-simple_read_from_buffer.patch
airo-use-simple_read_from_buffer.patch
cris-use-simple_read_from_buffer.patch
introduce-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer.patch
firmware-use-memory_read_from_buffer.patch
acpi-use-memory_read_from_buffer.patch
aty-use-memory_read_from_buffer.patch
zorro-use-memory_read_from_buffer.patch
s390-cio-use-memory_read_from_buffer.patch
s390-use-memory_read_from_buffer.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch


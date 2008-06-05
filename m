From: akpm@linux-foundation.org
Subject: + firmware-use-memory_read_from_buffer.patch added to -mm tree
Date: Wed, 04 Jun 2008 17:30:03 -0700
Message-ID: <200806050030.m550U3OA016969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755099AbYFEAaL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 20:30:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, gregkh@suse.de, kay.sievers@vrfy.org, markus.rechberger@amd.com


The patch titled
     firmware: use memory_read_from_buffer()
has been added to the -mm tree.  Its filename is
     firmware-use-memory_read_from_buffer.patch

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
Subject: firmware: use memory_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Markus Rechberger <markus.rechberger@amd.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/firmware_class.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN drivers/base/firmware_class.c~firmware-use-memory_read_from_buffer drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c~firmware-use-memory_read_from_buffer
+++ a/drivers/base/firmware_class.c
@@ -17,6 +17,7 @@
 #include <linux/bitops.h>
 #include <linux/mutex.h>
 #include <linux/kthread.h>
+#include <linux/fs.h>
 
 #include <linux/firmware.h>
 #include "base.h"
@@ -176,7 +177,7 @@ firmware_data_read(struct kobject *kobj,
 	struct device *dev = to_dev(kobj);
 	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
 	struct firmware *fw;
-	ssize_t ret_count = count;
+	ssize_t ret_count;
 
 	mutex_lock(&fw_lock);
 	fw = fw_priv->fw;
@@ -184,14 +185,8 @@ firmware_data_read(struct kobject *kobj,
 		ret_count = -ENODEV;
 		goto out;
 	}
-	if (offset > fw->size) {
-		ret_count = 0;
-		goto out;
-	}
-	if (offset + ret_count > fw->size)
-		ret_count = fw->size - offset;
-
-	memcpy(buffer, fw->data + offset, ret_count);
+	ret_count = memory_read_from_buffer(buffer, count, &offset,
+						fw->data, fw->size);
 out:
 	mutex_unlock(&fw_lock);
 	return ret_count;
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


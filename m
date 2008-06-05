From: akpm@linux-foundation.org
Subject: + dcdbas-use-memory_read_from_buffer.patch added to -mm tree
Date: Wed, 04 Jun 2008 17:29:59 -0700
Message-ID: <200806050029.m550Txx6016957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754486AbYFEAaK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 20:30:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, Douglas_Warzecha@dell.com, Matt_Domsch@dell.com, rui.zhang@intel.com


The patch titled
     dcdbas: use memory_read_from_buffer()
has been added to the -mm tree.  Its filename is
     dcdbas-use-memory_read_from_buffer.patch

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
Subject: dcdbas: use memory_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Doug Warzecha <Douglas_Warzecha@dell.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dcdbas.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff -puN drivers/firmware/dcdbas.c~dcdbas-use-memory_read_from_buffer drivers/firmware/dcdbas.c
--- a/drivers/firmware/dcdbas.c~dcdbas-use-memory_read_from_buffer
+++ a/drivers/firmware/dcdbas.c
@@ -34,6 +34,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/mutex.h>
+#include <linux/fs.h>
 #include <asm/io.h>
 
 #include "dcdbas.h"
@@ -152,20 +153,11 @@ static ssize_t smi_data_read(struct kobj
 			     struct bin_attribute *bin_attr,
 			     char *buf, loff_t pos, size_t count)
 {
-	size_t max_read;
 	ssize_t ret;
 
 	mutex_lock(&smi_data_lock);
-
-	if (pos >= smi_data_buf_size) {
-		ret = 0;
-		goto out;
-	}
-
-	max_read = smi_data_buf_size - pos;
-	ret = min(max_read, count);
-	memcpy(buf, smi_data_buf + pos, ret);
-out:
+	ret = memory_read_from_buffer(buf, count, &pos, smi_data_buf,
+					smi_data_buf_size);
 	mutex_unlock(&smi_data_lock);
 	return ret;
 }
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


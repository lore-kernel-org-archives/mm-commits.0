From: akpm@linux-foundation.org
Subject: + zorro-use-memory_read_from_buffer.patch added to -mm tree
Date: Wed, 04 Jun 2008 17:30:09 -0700
Message-ID: <200806050030.m550U91H016978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756230AbYFEAaY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 20:30:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, geert@linux-m68k.org


The patch titled
     zorro: use memory_read_from_buffer()
has been added to the -mm tree.  Its filename is
     zorro-use-memory_read_from_buffer.patch

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
Subject: zorro: use memory_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/zorro/zorro-sysfs.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/zorro/zorro-sysfs.c~zorro-use-memory_read_from_buffer drivers/zorro/zorro-sysfs.c
--- a/drivers/zorro/zorro-sysfs.c~zorro-use-memory_read_from_buffer
+++ a/drivers/zorro/zorro-sysfs.c
@@ -15,6 +15,7 @@
 #include <linux/zorro.h>
 #include <linux/stat.h>
 #include <linux/string.h>
+#include <linux/fs.h>
 
 #include "zorro.h"
 
@@ -56,12 +57,6 @@ static ssize_t zorro_read_config(struct 
 	struct zorro_dev *z = to_zorro_dev(container_of(kobj, struct device,
 					   kobj));
 	struct ConfigDev cd;
-	unsigned int size = sizeof(cd);
-
-	if (off > size)
-		return 0;
-	if (off+count > size)
-		count = size-off;
 
 	/* Construct a ConfigDev */
 	memset(&cd, 0, sizeof(cd));
@@ -71,8 +66,7 @@ static ssize_t zorro_read_config(struct 
 	cd.cd_BoardAddr = (void *)zorro_resource_start(z);
 	cd.cd_BoardSize = zorro_resource_len(z);
 
-	memcpy(buf, (void *)&cd+off, count);
-	return count;
+	return memory_read_from_buffer(buf, count, &off, &cd, sizeof(cd));
 }
 
 static struct bin_attribute zorro_config_attr = {
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


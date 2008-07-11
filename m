From: akpm@linux-foundation.org
Subject: - s390-cio-use-memory_read_from_buffer.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:51:28 -0700
Message-ID: <200807112351.m6BNpSna011043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754660AbYGKXvd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:51:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, heiko.carstens@de.ibm.com, peter.oberparleiter@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390/cio: use memory_read_from_buffer()
has been removed from the -mm tree.  Its filename was
     s390-cio-use-memory_read_from_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s390/cio: use memory_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/cio/chp.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN drivers/s390/cio/chp.c~s390-cio-use-memory_read_from_buffer drivers/s390/cio/chp.c
--- a/drivers/s390/cio/chp.c~s390-cio-use-memory_read_from_buffer
+++ a/drivers/s390/cio/chp.c
@@ -15,6 +15,7 @@
 #include <linux/wait.h>
 #include <linux/mutex.h>
 #include <linux/errno.h>
+#include <linux/fs.h>
 #include <asm/chpid.h>
 #include <asm/sclp.h>
 
@@ -140,21 +141,14 @@ static ssize_t chp_measurement_chars_rea
 {
 	struct channel_path *chp;
 	struct device *device;
-	unsigned int size;
 
 	device = container_of(kobj, struct device, kobj);
 	chp = to_channelpath(device);
 	if (!chp->cmg_chars)
 		return 0;
 
-	size = sizeof(struct cmg_chars);
-
-	if (off > size)
-		return 0;
-	if (off + count > size)
-		count = size - off;
-	memcpy(buf, chp->cmg_chars + off, count);
-	return count;
+	return memory_read_from_buffer(buf, count, &off,
+				chp->cmg_chars, sizeof(struct cmg_chars));
 }
 
 static struct bin_attribute chp_measurement_chars_attr = {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
ttusb-use-simple_read_from_buffer.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch
pm-hibernation-simplify-memory-bitmap.patch
cris-use-simple_read_from_buffer.patch
binfmt_misc-use-simple_read_from_buffer.patch
aty-use-memory_read_from_buffer.patch
ipc-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
firmware-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer.patch


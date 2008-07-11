From: akpm@linux-foundation.org
Subject: - s390-use-memory_read_from_buffer.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:51:30 -0700
Message-ID: <200807112351.m6BNpUH4011046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757455AbYGKXwu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:52:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, heiko.carstens@de.ibm.com, holzheu@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390: use memory_read_from_buffer()
has been removed from the -mm tree.  Its filename was
     s390-use-memory_read_from_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s390: use memory_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Michael Holzheu <holzheu@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/ipl.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff -puN arch/s390/kernel/ipl.c~s390-use-memory_read_from_buffer arch/s390/kernel/ipl.c
--- a/arch/s390/kernel/ipl.c~s390-use-memory_read_from_buffer
+++ a/arch/s390/kernel/ipl.c
@@ -14,6 +14,7 @@
 #include <linux/delay.h>
 #include <linux/reboot.h>
 #include <linux/ctype.h>
+#include <linux/fs.h>
 #include <asm/ipl.h>
 #include <asm/smp.h>
 #include <asm/setup.h>
@@ -338,14 +339,8 @@ static struct kobj_attribute sys_ipl_dev
 static ssize_t ipl_parameter_read(struct kobject *kobj, struct bin_attribute *attr,
 				  char *buf, loff_t off, size_t count)
 {
-	unsigned int size = IPL_PARMBLOCK_SIZE;
-
-	if (off > size)
-		return 0;
-	if (off + count > size)
-		count = size - off;
-	memcpy(buf, (void *)IPL_PARMBLOCK_START + off, count);
-	return count;
+	return memory_read_from_buffer(buf, count, &off, IPL_PARMBLOCK_START,
+					IPL_PARMBLOCK_SIZE);
 }
 
 static struct bin_attribute ipl_parameter_attr = {
@@ -363,12 +358,7 @@ static ssize_t ipl_scp_data_read(struct 
 	unsigned int size = IPL_PARMBLOCK_START->ipl_info.fcp.scp_data_len;
 	void *scp_data = &IPL_PARMBLOCK_START->ipl_info.fcp.scp_data;
 
-	if (off > size)
-		return 0;
-	if (off + count > size)
-		count = size - off;
-	memcpy(buf, scp_data + off, count);
-	return count;
+	return memory_read_from_buffer(buf, count, &off, scp_data, size);
 }
 
 static struct bin_attribute ipl_scp_data_attr = {
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


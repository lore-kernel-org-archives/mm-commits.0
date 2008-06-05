From: akpm@linux-foundation.org
Subject: + s390-vmcp-use-simple_read_from_buffer.patch added to -mm tree
Date: Wed, 04 Jun 2008 17:29:38 -0700
Message-ID: <200806050029.m550TcXT016933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757455AbYFEAbO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 20:31:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, borntraeger@de.ibm.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com


The patch titled
     s390/vmcp: use simple_read_from_buffer()
has been added to the -mm tree.  Its filename is
     s390-vmcp-use-simple_read_from_buffer.patch

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
Subject: s390/vmcp: use simple_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/char/vmcp.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff -puN drivers/s390/char/vmcp.c~s390-vmcp-use-simple_read_from_buffer drivers/s390/char/vmcp.c
--- a/drivers/s390/char/vmcp.c~s390-vmcp-use-simple_read_from_buffer
+++ a/drivers/s390/char/vmcp.c
@@ -65,30 +65,24 @@ static int vmcp_release(struct inode *in
 static ssize_t
 vmcp_read(struct file *file, char __user *buff, size_t count, loff_t *ppos)
 {
-	size_t tocopy;
+	ssize_t ret;
+	size_t size;
 	struct vmcp_session *session;
 
-	session = (struct vmcp_session *)file->private_data;
+	session = file->private_data;
 	if (mutex_lock_interruptible(&session->mutex))
 		return -ERESTARTSYS;
 	if (!session->response) {
 		mutex_unlock(&session->mutex);
 		return 0;
 	}
-	if (*ppos > session->resp_size) {
-		mutex_unlock(&session->mutex);
-		return 0;
-	}
-	tocopy = min(session->resp_size - (size_t) (*ppos), count);
-	tocopy = min(tocopy, session->bufsize - (size_t) (*ppos));
+	size = min_t(size_t, session->resp_size, session->bufsize);
+	ret = simple_read_from_buffer(buff, count, ppos,
+					session->response, size);
 
-	if (copy_to_user(buff, session->response + (*ppos), tocopy)) {
-		mutex_unlock(&session->mutex);
-		return -EFAULT;
-	}
 	mutex_unlock(&session->mutex);
-	*ppos += tocopy;
-	return tocopy;
+
+	return ret;
 }
 
 static ssize_t
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


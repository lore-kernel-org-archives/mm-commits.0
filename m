From: akpm@linux-foundation.org
Subject: - ocfs2-use-simple_read_from_buffer.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:37:08 -0700
Message-ID: <200806122037.m5CKb8VY005404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756051AbYFLUhV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:37:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, joel.becker@oracle.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     ocfs2: use simple_read_from_buffer()
has been removed from the -mm tree.  Its filename was
     ocfs2-use-simple_read_from_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ocfs2: use simple_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_user.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff -puN fs/ocfs2/stack_user.c~ocfs2-use-simple_read_from_buffer fs/ocfs2/stack_user.c
--- a/fs/ocfs2/stack_user.c~ocfs2-use-simple_read_from_buffer
+++ a/fs/ocfs2/stack_user.c
@@ -550,26 +550,17 @@ static ssize_t ocfs2_control_read(struct
 				  size_t count,
 				  loff_t *ppos)
 {
-	char *proto_string = OCFS2_CONTROL_PROTO;
-	size_t to_write = 0;
+	ssize_t ret;
 
-	if (*ppos >= OCFS2_CONTROL_PROTO_LEN)
-		return 0;
-
-	to_write = OCFS2_CONTROL_PROTO_LEN - *ppos;
-	if (to_write > count)
-		to_write = count;
-	if (copy_to_user(buf, proto_string + *ppos, to_write))
-		return -EFAULT;
-
-	*ppos += to_write;
+	ret = simple_read_from_buffer(buf, count, ppos,
+			OCFS2_CONTROL_PROTO, OCFS2_CONTROL_PROTO_LEN);
 
 	/* Have we read the whole protocol list? */
-	if (*ppos >= OCFS2_CONTROL_PROTO_LEN)
+	if (ret > 0 && *ppos >= OCFS2_CONTROL_PROTO_LEN)
 		ocfs2_control_set_handshake_state(file,
 						  OCFS2_CONTROL_HANDSHAKE_READ);
 
-	return to_write;
+	return ret;
 }
 
 static int ocfs2_control_release(struct inode *inode, struct file *file)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ttusb-use-simple_read_from_buffer.patch
s390-vmcp-use-simple_read_from_buffer.patch
s390-use-simple_read_from_buffer.patch
s390-cio-use-memory_read_from_buffer.patch
s390-use-memory_read_from_buffer.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch
usbmon-use-simple_read_from_buffer.patch
airo-use-simple_read_from_buffer.patch
cris-use-simple_read_from_buffer.patch
binfmt_misc-use-simple_read_from_buffer.patch
aty-use-memory_read_from_buffer.patch
ipc-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
firmware-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer.patch


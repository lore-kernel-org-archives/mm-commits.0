From: akpm@linux-foundation.org
Subject: + ocfs2-use-simple_read_from_buffer.patch added to -mm tree
Date: Wed, 04 Jun 2008 17:29:31 -0700
Message-ID: <200806050029.m550TV86016921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754003AbYFEA3q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 20:29:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, joel.becker@oracle.com, mfasheh@suse.com


The patch titled
     ocfs2: use simple_read_from_buffer()
has been added to the -mm tree.  Its filename is
     ocfs2-use-simple_read_from_buffer.patch

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


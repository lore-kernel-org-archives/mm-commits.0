From: akpm@linux-foundation.org
Subject: + ipc-use-simple_read_from_buffer.patch added to -mm tree
Date: Wed, 04 Jun 2008 17:29:33 -0700
Message-ID: <200806050029.m550TXxu016924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755099AbYFEAaP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 20:30:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, Nadia.Derbey@bull.net, manfred@colorfullife.com, peifferp@gmail.com


The patch titled
     ipc: use simple_read_from_buffer()
has been added to the -mm tree.  Its filename is
     ipc-use-simple_read_from_buffer.patch

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
Subject: ipc: use simple_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Also this patch kills unneccesary trailing NULL character.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff -puN ipc/mqueue.c~ipc-use-simple_read_from_buffer ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-use-simple_read_from_buffer
+++ a/ipc/mqueue.c
@@ -314,15 +314,11 @@ static int mqueue_unlink(struct inode *d
 *	through std routines)
 */
 static ssize_t mqueue_read_file(struct file *filp, char __user *u_data,
-				size_t count, loff_t * off)
+				size_t count, loff_t *off)
 {
 	struct mqueue_inode_info *info = MQUEUE_I(filp->f_path.dentry->d_inode);
 	char buffer[FILENT_SIZE];
-	size_t slen;
-	loff_t o;
-
-	if (!count)
-		return 0;
+	ssize_t ret;
 
 	spin_lock(&info->lock);
 	snprintf(buffer, sizeof(buffer),
@@ -335,21 +331,14 @@ static ssize_t mqueue_read_file(struct f
 			pid_vnr(info->notify_owner));
 	spin_unlock(&info->lock);
 	buffer[sizeof(buffer)-1] = '\0';
-	slen = strlen(buffer)+1;
-
-	o = *off;
-	if (o > slen)
-		return 0;
-
-	if (o + count > slen)
-		count = slen - o;
 
-	if (copy_to_user(u_data, buffer + o, count))
-		return -EFAULT;
+	ret = simple_read_from_buffer(u_data, count, off, buffer,
+				strlen(buffer));
+	if (ret <= 0)
+		return ret;
 
-	*off = o + count;
 	filp->f_path.dentry->d_inode->i_atime = filp->f_path.dentry->d_inode->i_ctime = CURRENT_TIME;
-	return count;
+	return ret;
 }
 
 static int mqueue_flush_file(struct file *filp, fl_owner_t id)
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


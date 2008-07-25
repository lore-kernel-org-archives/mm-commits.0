From: akpm@linux-foundation.org
Subject: - ipc-use-simple_read_from_buffer.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:00 -0700
Message-ID: <200807252301.m6PN10k7003649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412AbYGYXCH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:02:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, Nadia.Derbey@bull.net, manfred@colorfullife.com, peifferp@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ipc: use simple_read_from_buffer()
has been removed from the -mm tree.  Its filename was
     ipc-use-simple_read_from_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer-fix.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch


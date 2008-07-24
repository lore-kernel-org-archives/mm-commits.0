From: akpm@linux-foundation.org
Subject: - binfmt_misc-use-simple_read_from_buffer.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:27:04 -0700
Message-ID: <200807242327.m6ONR4bO011136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755885AbYGXX1H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:27:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     binfmt_misc: use simple_read_from_buffer()
has been removed from the -mm tree.  Its filename was
     binfmt_misc-use-simple_read_from_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: binfmt_misc: use simple_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff -puN fs/binfmt_misc.c~binfmt_misc-use-simple_read_from_buffer fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~binfmt_misc-use-simple_read_from_buffer
+++ a/fs/binfmt_misc.c
@@ -27,6 +27,7 @@
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/syscalls.h>
+#include <linux/fs.h>
 
 #include <asm/uaccess.h>
 
@@ -535,31 +536,16 @@ static ssize_t
 bm_entry_read(struct file * file, char __user * buf, size_t nbytes, loff_t *ppos)
 {
 	Node *e = file->f_path.dentry->d_inode->i_private;
-	loff_t pos = *ppos;
 	ssize_t res;
 	char *page;
-	int len;
 
 	if (!(page = (char*) __get_free_page(GFP_KERNEL)))
 		return -ENOMEM;
 
 	entry_status(e, page);
-	len = strlen(page);
 
-	res = -EINVAL;
-	if (pos < 0)
-		goto out;
-	res = 0;
-	if (pos >= len)
-		goto out;
-	if (len < pos + nbytes)
-		nbytes = len - pos;
-	res = -EFAULT;
-	if (copy_to_user(buf, page + pos, nbytes))
-		goto out;
-	*ppos = pos + nbytes;
-	res = nbytes;
-out:
+	res = simple_read_from_buffer(buf, nbytes, ppos, page, strlen(page));
+
 	free_page((unsigned long) page);
 	return res;
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer-fix.patch
workqueues-do-cpu_up_canceled-if-cpu_up_prepare-fails.patch
ipc-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
firmware-use-memory_read_from_buffer.patch
firmware-use-memory_read_from_buffer-fix.patch
dcdbas-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer-fix.patch
dell_rbu-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer-fix.patch


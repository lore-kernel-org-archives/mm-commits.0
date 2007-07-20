From: akpm@linux-foundation.org
Subject: + coda-breakage.patch added to -mm tree
Date: Thu, 19 Jul 2007 17:01:29 -0700
Message-ID: <200707200001.l6K01TYr029700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58858 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761540AbXGTABu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 20:01:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ftp.linux.org.uk, jaharkes@cs.cmu.edu, jdike@addtoit.com, viro@zeniv.linux.org.uk


The patch titled
     coda breakage
has been added to the -mm tree.  Its filename is
     coda-breakage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: coda breakage
From: Al Viro <viro@ftp.linux.org.uk>

a) switch by loff_t == __cmpdi2 use.  Replaced with a couple of obvious
   ifs; update of ->f_pos in the first one makes sure that we do the right
   thing in all cases.

b) block_signals() and unblock_signals() are globals on UML.  Renamed
   coda ones; in principle UML probably ought to do rename as well, but
   that's another story.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/dir.c    |   18 +++++++++---------
 fs/coda/upcall.c |   10 +++++-----
 2 files changed, 14 insertions(+), 14 deletions(-)

diff -puN fs/coda/dir.c~coda-breakage fs/coda/dir.c
--- a/fs/coda/dir.c~coda-breakage
+++ a/fs/coda/dir.c
@@ -510,20 +510,20 @@ static int coda_venus_readdir(struct fil
 	vdir = kmalloc(sizeof(*vdir), GFP_KERNEL);
 	if (!vdir) return -ENOMEM;
 
-	switch (coda_file->f_pos) {
-	case 0:
+	if (coda_file->f_pos == 0) {
 		ret = filldir(buf, ".", 1, 0, de->d_inode->i_ino, DT_DIR);
-		if (ret < 0) break;
+		if (ret < 0)
+			goto out;
 		result++;
 		coda_file->f_pos++;
-		/* fallthrough */
-	case 1:
+	}
+	if (coda_file->f_pos == 1) {
 		ret = filldir(buf, "..", 2, 1, de->d_parent->d_inode->i_ino, DT_DIR);
-		if (ret < 0) break;
+		if (ret < 0)
+			goto out;
 		result++;
 		coda_file->f_pos++;
-		/* fallthrough */
-	default:
+	}
 	while (1) {
 		/* read entries from the directory file */
 		ret = kernel_read(host_file, coda_file->f_pos - 2, (char *)vdir,
@@ -578,7 +578,7 @@ static int coda_venus_readdir(struct fil
 		 * we've already established it is non-zero. */
 		coda_file->f_pos += vdir->d_reclen;
 	}
-	}
+out:
 	kfree(vdir);
 	return result ? result : ret;
 }
diff -puN fs/coda/upcall.c~coda-breakage fs/coda/upcall.c
--- a/fs/coda/upcall.c~coda-breakage
+++ a/fs/coda/upcall.c
@@ -632,7 +632,7 @@ int venus_statfs(struct dentry *dentry, 
 /*
  * coda_upcall and coda_downcall routines.
  */
-static void block_signals(sigset_t *old)
+static void coda_block_signals(sigset_t *old)
 {
 	spin_lock_irq(&current->sighand->siglock);
 	*old = current->blocked;
@@ -646,7 +646,7 @@ static void block_signals(sigset_t *old)
 	spin_unlock_irq(&current->sighand->siglock);
 }
 
-static void unblock_signals(sigset_t *old)
+static void coda_unblock_signals(sigset_t *old)
 {
 	spin_lock_irq(&current->sighand->siglock);
 	current->blocked = *old;
@@ -672,7 +672,7 @@ static inline void coda_waitfor_upcall(s
 	sigset_t old;
 	int blocked;
 
-	block_signals(&old);
+	coda_block_signals(&old);
 	blocked = 1;
 
 	add_wait_queue(&req->uc_sleep, &wait);
@@ -689,7 +689,7 @@ static inline void coda_waitfor_upcall(s
 		if (blocked && time_after(jiffies, timeout) &&
 		    CODA_INTERRUPTIBLE(req))
 		{
-			unblock_signals(&old);
+			coda_unblock_signals(&old);
 			blocked = 0;
 		}
 
@@ -704,7 +704,7 @@ static inline void coda_waitfor_upcall(s
 			schedule();
 	}
 	if (blocked)
-		unblock_signals(&old);
+		coda_unblock_signals(&old);
 
 	remove_wait_queue(&req->uc_sleep, &wait);
 	set_current_state(TASK_RUNNING);
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

origin.patch
coda-breakage.patch
introduce-i_sync.patch
slab-leaks3-default-y.patch

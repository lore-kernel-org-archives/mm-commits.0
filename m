From: akpm@linux-foundation.org
Subject: [merged] fasync-move-bit-handling-to-f_op-fasync.patch removed from -mm tree
Date: Wed, 11 Feb 2009 11:22:14 -0800
Message-ID: <200902111922.n1BJMEdv019410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756941AbZBKT0l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 14:26:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, hch@lst.de, mpm@selenic.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fasync: move bit handling to f_op->fasync()
has been removed from the -mm tree.  Its filename was
     fasync-move-bit-handling-to-f_op-fasync.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fasync: move bit handling to f_op->fasync()
From: Jonathan Corbet <corbet@lwn.net>

Removing the BKL from FASYNC handling ran into the challenge of keeping
the setting of the FASYNC bit in filp->f_flags atomic with regard to calls
to the underlying fasync() function.  Andi Kleen suggested moving the
handling of that bit into fasync(); this patch does exactly that.  As a
result, we have a couple of internal API changes: fasync() must now manage
the FASYNC bit, and it will be called without the BKL held.

As it happens, every fasync() implementation in the kernel with one
exception calls fasync_helper().  So, if we make fasync_helper() set the
FASYNC bit, we can avoid making any changes to the other fasync()
functions - as long as those functions, themselves, have proper locking. 
Most fasync() implementations do nothing but call fasync_helper() - which
has its own lock - so they are easily verified as correct.  The BKL had
already been pushed down into the rest.

The networking code has its own version of fasync_helper(), so that code
has been augmented with explicit FASYNC bit handling.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Acked-by: Matt Mackall <mpm@selenic.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fcntl.c   |   29 ++++++++++++++++-------------
 fs/ioctl.c   |   13 +------------
 net/socket.c |    8 ++++++++
 3 files changed, 25 insertions(+), 25 deletions(-)

diff -puN fs/fcntl.c~fasync-move-bit-handling-to-f_op-fasync fs/fcntl.c
--- a/fs/fcntl.c~fasync-move-bit-handling-to-f_op-fasync
+++ a/fs/fcntl.c
@@ -141,7 +141,7 @@ SYSCALL_DEFINE1(dup, unsigned int, filde
 	return ret;
 }
 
-#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | FASYNC | O_DIRECT | O_NOATIME)
+#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOATIME)
 
 static int setfl(int fd, struct file * filp, unsigned long arg)
 {
@@ -177,23 +177,19 @@ static int setfl(int fd, struct file * f
 		return error;
 
 	/*
-	 * We still need a lock here for now to keep multiple FASYNC calls
-	 * from racing with each other.
+	 * ->fasync() is responsible for setting the FASYNC bit.
 	 */
-	lock_kernel();
-	if ((arg ^ filp->f_flags) & FASYNC) {
-		if (filp->f_op && filp->f_op->fasync) {
-			error = filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0);
-			if (error < 0)
-				goto out;
-		}
+	if (((arg ^ filp->f_flags) & FASYNC) && filp->f_op &&
+			filp->f_op->fasync) {
+		error = filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0);
+		if (error < 0)
+			goto out;
 	}
-
 	spin_lock(&filp->f_lock);
 	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
 	spin_unlock(&filp->f_lock);
+
  out:
-	unlock_kernel();
 	return error;
 }
 
@@ -518,7 +514,7 @@ static DEFINE_RWLOCK(fasync_lock);
 static struct kmem_cache *fasync_cache __read_mostly;
 
 /*
- * fasync_helper() is used by some character device drivers (mainly mice)
+ * fasync_helper() is used by almost all character device drivers
  * to set up the fasync queue. It returns negative on error, 0 if it did
  * no changes and positive if it added/deleted the entry.
  */
@@ -557,6 +553,13 @@ int fasync_helper(int fd, struct file * 
 		result = 1;
 	}
 out:
+	/* Fix up FASYNC bit while still holding fasync_lock */
+	spin_lock(&filp->f_lock);
+	if (on)
+		filp->f_flags |= FASYNC;
+	else
+		filp->f_flags &= ~FASYNC;
+	spin_unlock(&filp->f_lock);
 	write_unlock_irq(&fasync_lock);
 	return result;
 }
diff -puN fs/ioctl.c~fasync-move-bit-handling-to-f_op-fasync fs/ioctl.c
--- a/fs/ioctl.c~fasync-move-bit-handling-to-f_op-fasync
+++ a/fs/ioctl.c
@@ -427,19 +427,11 @@ static int ioctl_fioasync(unsigned int f
 	/* Did FASYNC state change ? */
 	if ((flag ^ filp->f_flags) & FASYNC) {
 		if (filp->f_op && filp->f_op->fasync)
+			/* fasync() adjusts filp->f_flags */
 			error = filp->f_op->fasync(fd, filp, on);
 		else
 			error = -ENOTTY;
 	}
-	if (error)
-		return error;
-
-	spin_lock(&filp->f_lock);
-	if (on)
-		filp->f_flags |= FASYNC;
-	else
-		filp->f_flags &= ~FASYNC;
-	spin_unlock(&filp->f_lock);
 	return error;
 }
 
@@ -507,10 +499,7 @@ int do_vfs_ioctl(struct file *filp, unsi
 		break;
 
 	case FIOASYNC:
-		/* BKL needed to avoid races tweaking f_flags */
-		lock_kernel();
 		error = ioctl_fioasync(fd, filp, argp);
-		unlock_kernel();
 		break;
 
 	case FIOQSIZE:
diff -puN net/socket.c~fasync-move-bit-handling-to-f_op-fasync net/socket.c
--- a/net/socket.c~fasync-move-bit-handling-to-f_op-fasync
+++ a/net/socket.c
@@ -1030,6 +1030,14 @@ static int sock_fasync(int fd, struct fi
 
 	lock_sock(sk);
 
+	/* Maintaining the FASYNC bit is our job now */
+	spin_lock(&filp->f_lock);
+	if (on)
+		filp->f_flags |= FASYNC;
+	else
+		filp->f_flags &= ~FASYNC;
+	spin_unlock(&filp->f_lock);
+
 	prev = &(sock->fasync_list);
 
 	for (fa = *prev; fa != NULL; prev = &fa->fa_next, fa = *prev)
_

Patches currently in -mm which might be from corbet@lwn.net are

linux-next.patch
pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch


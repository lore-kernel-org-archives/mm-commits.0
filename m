From: akpm@linux-foundation.org
Subject: + removal-of-futex_fd.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:17:42 -0800
Message-ID: <200801270517.m0R5HdX6031138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49043 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044AbYA0FSi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:18:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: snakebyte@gmx.de, drepper@redhat.com, jakub@redhat.com, mingo@elte.hu, roland@redhat.com, rusty@rustcorp.com.au


The patch titled
     Removal of FUTEX_FD
has been added to the -mm tree.  Its filename is
     removal-of-futex_fd.patch

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
Subject: Removal of FUTEX_FD
From: Eric Sesterhenn <snakebyte@gmx.de>

Since FUTEX_FD was scheduled for removal in June 2007 lets remove it. 
Google Code search found no users for it and NGPT was abandoned in 2003
according to IBM.  futex.h is left untouched to make sure the id does not
get reassigned.  Since queue_me() has no users left it is commented out to
avoid a warning, i didnt remove it completely since it is part of the
internal api (matching unqueue_me())

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |   87 +----------------------------------------------
 1 file changed, 2 insertions(+), 85 deletions(-)

diff -puN kernel/futex.c~removal-of-futex_fd kernel/futex.c
--- a/kernel/futex.c~removal-of-futex_fd
+++ a/kernel/futex.c
@@ -1026,6 +1026,7 @@ queue_unlock(struct futex_q *q, struct f
  * exactly once.  They are called with the hashed spinlock held.
  */
 
+#if 0
 /* The key must be already stored in q->key. */
 static void queue_me(struct futex_q *q, int fd, struct file *filp)
 {
@@ -1034,6 +1035,7 @@ static void queue_me(struct futex_q *q, 
 	hb = queue_lock(q, fd, filp);
 	__queue_me(q, hb);
 }
+#endif
 
 /* Return 1 if we were still queued (ie. 0 means we were woken) */
 static int unqueue_me(struct futex_q *q)
@@ -1750,87 +1752,6 @@ static const struct file_operations fute
 };
 
 /*
- * Signal allows caller to avoid the race which would occur if they
- * set the sigio stuff up afterwards.
- */
-static int futex_fd(u32 __user *uaddr, int signal)
-{
-	struct futex_q *q;
-	struct file *filp;
-	int ret, err;
-	struct rw_semaphore *fshared;
-	static unsigned long printk_interval;
-
-	if (printk_timed_ratelimit(&printk_interval, 60 * 60 * 1000)) {
-		printk(KERN_WARNING "Process `%s' used FUTEX_FD, which "
-		       "will be removed from the kernel in June 2007\n",
-		       current->comm);
-	}
-
-	ret = -EINVAL;
-	if (!valid_signal(signal))
-		goto out;
-
-	ret = get_unused_fd();
-	if (ret < 0)
-		goto out;
-	filp = get_empty_filp();
-	if (!filp) {
-		put_unused_fd(ret);
-		ret = -ENFILE;
-		goto out;
-	}
-	filp->f_op = &futex_fops;
-	filp->f_path.mnt = mntget(futex_mnt);
-	filp->f_path.dentry = dget(futex_mnt->mnt_root);
-	filp->f_mapping = filp->f_path.dentry->d_inode->i_mapping;
-
-	if (signal) {
-		err = __f_setown(filp, task_pid(current), PIDTYPE_PID, 1);
-		if (err < 0) {
-			goto error;
-		}
-		filp->f_owner.signum = signal;
-	}
-
-	q = kmalloc(sizeof(*q), GFP_KERNEL);
-	if (!q) {
-		err = -ENOMEM;
-		goto error;
-	}
-	q->pi_state = NULL;
-
-	fshared = &current->mm->mmap_sem;
-	down_read(fshared);
-	err = get_futex_key(uaddr, fshared, &q->key);
-
-	if (unlikely(err != 0)) {
-		up_read(fshared);
-		kfree(q);
-		goto error;
-	}
-
-	/*
-	 * queue_me() must be called before releasing mmap_sem, because
-	 * key->shared.inode needs to be referenced while holding it.
-	 */
-	filp->private_data = q;
-
-	queue_me(q, ret, filp);
-	up_read(fshared);
-
-	/* Now we map fd to filp, so userspace can access it */
-	fd_install(ret, filp);
-out:
-	return ret;
-error:
-	put_unused_fd(ret);
-	put_filp(filp);
-	ret = err;
-	goto out;
-}
-
-/*
  * Support for robust futexes: the kernel cleans up held futexes at
  * thread exit time.
  *
@@ -2048,10 +1969,6 @@ long do_futex(u32 __user *uaddr, int op,
 	case FUTEX_WAKE:
 		ret = futex_wake(uaddr, fshared, val);
 		break;
-	case FUTEX_FD:
-		/* non-zero val means F_SETOWN(getpid()) & F_SETSIG(val) */
-		ret = futex_fd(uaddr, val);
-		break;
 	case FUTEX_REQUEUE:
 		ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, NULL);
 		break;
_

Patches currently in -mm which might be from snakebyte@gmx.de are

git-kvm.patch
removal-of-futex_fd.patch

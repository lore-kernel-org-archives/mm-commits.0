From: akpm@linux-foundation.org
Subject: [nacked] epoll-fix-for-epoll_wait-sometimes-returning-events-on-closed-fds.patch removed from -mm tree
Date: Tue, 24 Feb 2009 14:25:56 -0800
Message-ID: <200902242225.n1OMPuQD016330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761284AbZBXW0i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 17:26:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tonyb@cybernetics.com, corbet@lwn.net, davidel@xmailserver.org, mtk.manpages@googlemail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     epoll: fix for epoll_wait() sometimes returning events on closed fds
has been removed from the -mm tree.  Its filename was
     epoll-fix-for-epoll_wait-sometimes-returning-events-on-closed-fds.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll: fix for epoll_wait() sometimes returning events on closed fds
From: Tony Battersby <tonyb@cybernetics.com>

The epoll manpage:

Q: Will closing a file descriptor cause it to be removed from all
   epoll sets automatically?
A: Yes

sys_close() calls filp_close(), which calls fput().  If no one else holds
a reference to the file, then fput() calls __fput(), and __fput() calls
eventpoll_release(), which prevents epoll_wait() from returning events on
the fd to userspace.  In the rare case that sys_close() doesn't call
__fput() because someone else has a reference to the file, a subsequent
epoll_wait() may still unexpectedly return events on the fd after it has
been closed.  This can end up confusing or crashing a userspace program
that doesn't do epoll_ctl(EPOLL_CTL_DEL) before closing the fd.  I have
reports of this actually happening under heavy load with a program using
epoll with network sockets on 2.6.27.

This patch fixes the problem by calling eventpoll_release_file() from
filp_close() instead of from __fput().

The locking in eventpoll_release() and eventpoll_release_file() needs to
be changed because previously it relied on the fact that no one else could
have a reference to the file when called from __fput(), and this is no
longer true.  The new locking is admittedly ugly, but I believe it works.

ep_insert() now also needs to check if the file has been closed to avoid
races in multi-threaded programs where one thread is doing
epoll_ctl(EPOLL_CTL_ADD) and another thread is closing the fd.  This is
done by checking that fget_light still returns the same struct file * as
before.

Note that the list_del_init(&epi->fllink) previously done in
eventpoll_release_file() was unnecessary because it is also done by
ep_remove().

Userspace programs that might run on kernels with this bug can work around
the problem by doing epoll_ctl(EPOLL_CTL_DEL) before close().

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Cc: <stable@kernel.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c            |   66 ++++++++++++++++++++++++++++--------
 fs/file_table.c           |    5 --
 fs/open.c                 |    2 +
 include/linux/eventpoll.h |   16 ++++----
 4 files changed, 64 insertions(+), 25 deletions(-)

diff -puN fs/eventpoll.c~epoll-fix-for-epoll_wait-sometimes-returning-events-on-closed-fds fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-fix-for-epoll_wait-sometimes-returning-events-on-closed-fds
+++ a/fs/eventpoll.c
@@ -538,27 +538,40 @@ void eventpoll_release_file(struct file 
 	struct epitem *epi;
 
 	/*
-	 * We don't want to get "file->f_ep_lock" because it is not
-	 * necessary. It is not necessary because we're in the "struct file"
-	 * cleanup path, and this means that noone is using this file anymore.
-	 * So, for example, epoll_ctl() cannot hit here sicne if we reach this
-	 * point, the file counter already went to zero and fget() would fail.
-	 * The only hit might come from ep_free() but by holding the mutex
-	 * will correctly serialize the operation. We do need to acquire
-	 * "ep->mtx" after "epmutex" because ep_remove() requires it when called
-	 * from anywhere but ep_free().
+	 * epmutex makes it safe to use *ep by preventing ep_free() from
+	 * running.
 	 */
 	mutex_lock(&epmutex);
 
+	spin_lock(&file->f_ep_lock);
 	while (!list_empty(lsthead)) {
-		epi = list_first_entry(lsthead, struct epitem, fllink);
+		ep = list_first_entry(lsthead, struct epitem, fllink)->ep;
+		spin_unlock(&file->f_ep_lock);
 
-		ep = epi->ep;
-		list_del_init(&epi->fllink);
+		/*
+		 * ep->mtx protects against epoll_ctl() and is required for
+		 * calling ep_remove().
+		 */
 		mutex_lock(&ep->mtx);
-		ep_remove(ep, epi);
+
+		spin_lock(&file->f_ep_lock);
+		epi = list_first_entry(lsthead, struct epitem, fllink);
+		spin_unlock(&file->f_ep_lock);
+
+		/*
+		 * epoll_ctl(EPOLL_CTL_DEL) may have modified the list before
+		 * we locked ep->mtx, so it is necessary to check that the
+		 * first entry still exists and belongs to the ep whose mtx we
+		 * are holding.
+		 */
+		if (epi && epi->ep == ep)
+			ep_remove(ep, epi);
+
 		mutex_unlock(&ep->mtx);
+
+		spin_lock(&file->f_ep_lock);
 	}
+	spin_unlock(&file->f_ep_lock);
 
 	mutex_unlock(&epmutex);
 }
@@ -736,6 +749,22 @@ static void ep_rbtree_insert(struct even
 }
 
 /*
+ * Returns true if the fd has been closed or false if not.
+ */
+static bool ep_is_file_closed(struct file *file, int fd)
+{
+	struct file *file2;
+	int needs_fput;
+	bool closed;
+
+	file2 = fget_light(fd, &needs_fput);
+	closed = (file2 != file);
+	if (file2)
+		fput_light(file2, needs_fput);
+	return closed;
+}
+
+/*
  * Must be called with "mtx" held.
  */
 static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
@@ -786,6 +815,17 @@ static int ep_insert(struct eventpoll *e
 
 	/* Add the current item to the list of active epoll hook for this file */
 	spin_lock(&tfile->f_ep_lock);
+	/*
+	 * Don't add the fd to the epoll set if it was closed in between the
+	 * initial fget() and the time we get here.  This check must be done
+	 * while holding f_ep_lock to prevent races with
+	 * eventpoll_release_file().
+	 */
+	if (ep_is_file_closed(tfile, fd)) {
+		spin_unlock(&tfile->f_ep_lock);
+		error = -EBADF;
+		goto error_unregister;
+	}
 	list_add_tail(&epi->fllink, &tfile->f_ep_links);
 	spin_unlock(&tfile->f_ep_lock);
 
diff -puN fs/file_table.c~epoll-fix-for-epoll_wait-sometimes-returning-events-on-closed-fds fs/file_table.c
--- a/fs/file_table.c~epoll-fix-for-epoll_wait-sometimes-returning-events-on-closed-fds
+++ a/fs/file_table.c
@@ -266,11 +266,6 @@ void __fput(struct file *file)
 	might_sleep();
 
 	fsnotify_close(file);
-	/*
-	 * The function eventpoll_release() should be the first called
-	 * in the file cleanup chain.
-	 */
-	eventpoll_release(file);
 	locks_remove_flock(file);
 
 	if (unlikely(file->f_flags & FASYNC)) {
diff -puN fs/open.c~epoll-fix-for-epoll_wait-sometimes-returning-events-on-closed-fds fs/open.c
--- a/fs/open.c~epoll-fix-for-epoll_wait-sometimes-returning-events-on-closed-fds
+++ a/fs/open.c
@@ -29,6 +29,7 @@
 #include <linux/rcupdate.h>
 #include <linux/audit.h>
 #include <linux/falloc.h>
+#include <linux/eventpoll.h>
 
 int vfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
@@ -1104,6 +1105,7 @@ int filp_close(struct file *filp, fl_own
 
 	dnotify_flush(filp, id);
 	locks_remove_posix(filp, id);
+	eventpoll_release(filp);
 	fput(filp);
 	return retval;
 }
diff -puN include/linux/eventpoll.h~epoll-fix-for-epoll_wait-sometimes-returning-events-on-closed-fds include/linux/eventpoll.h
--- a/include/linux/eventpoll.h~epoll-fix-for-epoll_wait-sometimes-returning-events-on-closed-fds
+++ a/include/linux/eventpoll.h
@@ -69,23 +69,25 @@ static inline void eventpoll_init_file(s
 void eventpoll_release_file(struct file *file);
 
 /*
- * This is called from inside fs/file_table.c:__fput() to unlink files
+ * This is called from inside fs/open.c:filp_close() to unlink files
  * from the eventpoll interface. We need to have this facility to cleanup
  * correctly files that are closed without being removed from the eventpoll
  * interface.
  */
 static inline void eventpoll_release(struct file *file)
 {
+	bool empty;
 
 	/*
-	 * Fast check to avoid the get/release of the semaphore. Since
-	 * we're doing this outside the semaphore lock, it might return
+	 * Fast check to avoid the get/release of the mutex. Since
+	 * we're doing this outside the mutex lock, it might return
 	 * false negatives, but we don't care. It'll help in 99.99% of cases
-	 * to avoid the semaphore lock. False positives simply cannot happen
-	 * because the file in on the way to be removed and nobody ( but
-	 * eventpoll ) has still a reference to this file.
+	 * to avoid the mutex lock.
 	 */
-	if (likely(list_empty(&file->f_ep_links)))
+	spin_lock(&file->f_ep_lock);
+	empty = list_empty(&file->f_ep_links);
+	spin_unlock(&file->f_ep_lock);
+	if (likely(empty))
 		return;
 
 	/*
_

Patches currently in -mm which might be from tonyb@cybernetics.com are

linux-next.patch
vfs-improve-comment-describing-fget_light.patch
epoll-fix-for-epoll_wait-sometimes-returning-events-on-closed-fds.patch
make-shm_get_stat-more-robust.patch


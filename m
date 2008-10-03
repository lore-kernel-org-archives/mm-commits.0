From: akpm@linux-foundation.org
Subject: - inotify-fix-lock-ordering-wrt-do_page_faults-mmap_sem.patch removed from -mm tree
Date: Fri, 03 Oct 2008 14:28:41 -0700
Message-ID: <200810032128.m93LSfaE016633@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753245AbYJCV3C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 17:29:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl, daniel.blueman@gmail.com, mingo@elte.hu, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     inotify: fix lock ordering wrt do_page_fault's mmap_sem
has been removed from the -mm tree.  Its filename was
     inotify-fix-lock-ordering-wrt-do_page_faults-mmap_sem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: inotify: fix lock ordering wrt do_page_fault's mmap_sem
From: Nick Piggin <nickpiggin@yahoo.com.au>

Fix inotify lock order reversal with mmap_sem due to holding locks over
copy_to_user.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Reported-by: "Daniel J Blueman" <daniel.blueman@gmail.com>
Tested-by: "Daniel J Blueman" <daniel.blueman@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inotify_user.c            |   27 ++++++++++++++++++++-------
 include/asm-x86/uaccess_64.h |    1 +
 2 files changed, 21 insertions(+), 7 deletions(-)

diff -puN fs/inotify_user.c~inotify-fix-lock-ordering-wrt-do_page_faults-mmap_sem fs/inotify_user.c
--- a/fs/inotify_user.c~inotify-fix-lock-ordering-wrt-do_page_faults-mmap_sem
+++ a/fs/inotify_user.c
@@ -323,7 +323,7 @@ out:
 }
 
 /*
- * remove_kevent - cleans up and ultimately frees the given kevent
+ * remove_kevent - cleans up the given kevent
  *
  * Caller must hold dev->ev_mutex.
  */
@@ -334,7 +334,13 @@ static void remove_kevent(struct inotify
 
 	dev->event_count--;
 	dev->queue_size -= sizeof(struct inotify_event) + kevent->event.len;
+}
 
+/*
+ * free_kevent - frees the given kevent.
+ */
+static void free_kevent(struct inotify_kernel_event *kevent)
+{
 	kfree(kevent->name);
 	kmem_cache_free(event_cachep, kevent);
 }
@@ -350,6 +356,7 @@ static void inotify_dev_event_dequeue(st
 		struct inotify_kernel_event *kevent;
 		kevent = inotify_dev_get_event(dev);
 		remove_kevent(dev, kevent);
+		free_kevent(kevent);
 	}
 }
 
@@ -433,17 +440,15 @@ static ssize_t inotify_read(struct file 
 	dev = file->private_data;
 
 	while (1) {
-		int events;
 
 		prepare_to_wait(&dev->wq, &wait, TASK_INTERRUPTIBLE);
 
 		mutex_lock(&dev->ev_mutex);
-		events = !list_empty(&dev->events);
-		mutex_unlock(&dev->ev_mutex);
-		if (events) {
+		if (!list_empty(&dev->events)) {
 			ret = 0;
 			break;
 		}
+		mutex_unlock(&dev->ev_mutex);
 
 		if (file->f_flags & O_NONBLOCK) {
 			ret = -EAGAIN;
@@ -462,7 +467,6 @@ static ssize_t inotify_read(struct file 
 	if (ret)
 		return ret;
 
-	mutex_lock(&dev->ev_mutex);
 	while (1) {
 		struct inotify_kernel_event *kevent;
 
@@ -481,6 +485,13 @@ static ssize_t inotify_read(struct file 
 			}
 			break;
 		}
+		remove_kevent(dev, kevent);
+
+		/*
+		 * Must perform the copy_to_user outside the mutex in order
+		 * to avoid a lock order reversal with mmap_sem.
+		 */
+		mutex_unlock(&dev->ev_mutex);
 
 		if (copy_to_user(buf, &kevent->event, event_size)) {
 			ret = -EFAULT;
@@ -498,7 +509,9 @@ static ssize_t inotify_read(struct file 
 			count -= kevent->event.len;
 		}
 
-		remove_kevent(dev, kevent);
+		free_kevent(kevent);
+
+		mutex_lock(&dev->ev_mutex);
 	}
 	mutex_unlock(&dev->ev_mutex);
 
diff -puN include/asm-x86/uaccess_64.h~inotify-fix-lock-ordering-wrt-do_page_faults-mmap_sem include/asm-x86/uaccess_64.h
--- a/include/asm-x86/uaccess_64.h~inotify-fix-lock-ordering-wrt-do_page_faults-mmap_sem
+++ a/include/asm-x86/uaccess_64.h
@@ -7,6 +7,7 @@
 #include <linux/compiler.h>
 #include <linux/errno.h>
 #include <linux/prefetch.h>
+#include <linux/lockdep.h>
 #include <asm/page.h>
 
 /*
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

origin.patch
git-x86.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
mm-rewrite-vmap-layer-fix-fix-fix-fix.patch
powerpc-hugetlb-pgtable-cache-access-cleanup.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch


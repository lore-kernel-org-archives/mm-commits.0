From: akpm@linux-foundation.org
Subject: [to-be-updated] eventfd-revised-interface-and-cleanups-2nd-rev.patch removed from -mm tree
Date: Wed, 24 Jun 2009 20:33:03 -0700
Message-ID: <200906250333.n5P3X3WA030339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751679AbZFYDd0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 23:33:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, avi@redhat.com, bcrl@kvack.org, ghaskins@novell.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     eventfd: revised interface and cleanups
has been removed from the -mm tree.  Its filename was
     eventfd-revised-interface-and-cleanups-2nd-rev.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eventfd: revised interface and cleanups
From: Davide Libenzi <davidel@xmailserver.org>

Change the eventfd interface to de-couple the eventfd memory context, from
the file pointer instance.

Without such change, there is no clean way to racely free handle the
POLLHUP event sent when the last instance of the file* goes away.  Also,
now the internal eventfd APIs are using the eventfd context instead of the
file*.

Another cleanup this patch does is to make AIO select EVENTFD, instead of
adding a bunch of empty function stubs inside eventfd.h in order to handle
the (AIO && !EVENTFD) case.

This patch is required by KVM's IRQfd code, which is still under
development.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Gregory Haskins <ghaskins@novell.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Avi Kivity <avi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lg.h          |    2 
 drivers/lguest/lguest_user.c |    4 -
 fs/aio.c                     |   24 ++----
 fs/eventfd.c                 |  115 +++++++++++++++++++++++++++++----
 include/linux/aio.h          |    4 -
 include/linux/eventfd.h      |   18 +----
 init/Kconfig                 |    1 
 7 files changed, 122 insertions(+), 46 deletions(-)

diff -puN drivers/lguest/lg.h~eventfd-revised-interface-and-cleanups-2nd-rev drivers/lguest/lg.h
--- a/drivers/lguest/lg.h~eventfd-revised-interface-and-cleanups-2nd-rev
+++ a/drivers/lguest/lg.h
@@ -82,7 +82,7 @@ struct lg_cpu {
 
 struct lg_eventfd {
 	unsigned long addr;
-	struct file *event;
+	struct eventfd_ctx *event;
 };
 
 struct lg_eventfd_map {
diff -puN drivers/lguest/lguest_user.c~eventfd-revised-interface-and-cleanups-2nd-rev drivers/lguest/lguest_user.c
--- a/drivers/lguest/lguest_user.c~eventfd-revised-interface-and-cleanups-2nd-rev
+++ a/drivers/lguest/lguest_user.c
@@ -50,7 +50,7 @@ static int add_eventfd(struct lguest *lg
 
 	/* Now append new entry. */
 	new->map[new->num].addr = addr;
-	new->map[new->num].event = eventfd_fget(fd);
+	new->map[new->num].event = eventfd_ctx_fdget(fd);
 	if (IS_ERR(new->map[new->num].event)) {
 		kfree(new);
 		return PTR_ERR(new->map[new->num].event);
@@ -357,7 +357,7 @@ static int close(struct inode *inode, st
 
 	/* Release any eventfds they registered. */
 	for (i = 0; i < lg->eventfds->num; i++)
-		fput(lg->eventfds->map[i].event);
+		eventfd_ctx_put(lg->eventfds->map[i].event);
 	kfree(lg->eventfds);
 
 	/* If lg->dead doesn't contain an error code it will be NULL or a
diff -puN fs/aio.c~eventfd-revised-interface-and-cleanups-2nd-rev fs/aio.c
--- a/fs/aio.c~eventfd-revised-interface-and-cleanups-2nd-rev
+++ a/fs/aio.c
@@ -485,6 +485,8 @@ static inline void really_put_req(struct
 {
 	assert_spin_locked(&ctx->ctx_lock);
 
+	if (req->ki_eventfd != NULL)
+		eventfd_ctx_put(req->ki_eventfd);
 	if (req->ki_dtor)
 		req->ki_dtor(req);
 	if (req->ki_iovec != &req->ki_inline_vec)
@@ -509,8 +511,6 @@ static void aio_fput_routine(struct work
 		/* Complete the fput(s) */
 		if (req->ki_filp != NULL)
 			__fput(req->ki_filp);
-		if (req->ki_eventfd != NULL)
-			__fput(req->ki_eventfd);
 
 		/* Link the iocb into the context's free list */
 		spin_lock_irq(&ctx->ctx_lock);
@@ -528,8 +528,6 @@ static void aio_fput_routine(struct work
  */
 static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 {
-	int schedule_putreq = 0;
-
 	dprintk(KERN_DEBUG "aio_put(%p): f_count=%ld\n",
 		req, atomic_long_read(&req->ki_filp->f_count));
 
@@ -549,24 +547,16 @@ static int __aio_put_req(struct kioctx *
 	 * we would not be holding the last reference to the file*, so
 	 * this function will be executed w/out any aio kthread wakeup.
 	 */
-	if (unlikely(atomic_long_dec_and_test(&req->ki_filp->f_count)))
-		schedule_putreq++;
-	else
-		req->ki_filp = NULL;
-	if (req->ki_eventfd != NULL) {
-		if (unlikely(atomic_long_dec_and_test(&req->ki_eventfd->f_count)))
-			schedule_putreq++;
-		else
-			req->ki_eventfd = NULL;
-	}
-	if (unlikely(schedule_putreq)) {
+	if (unlikely(atomic_long_dec_and_test(&req->ki_filp->f_count))) {
 		get_ioctx(ctx);
 		spin_lock(&fput_lock);
 		list_add(&req->ki_list, &fput_head);
 		spin_unlock(&fput_lock);
 		queue_work(aio_wq, &fput_work);
-	} else
+	} else {
+		req->ki_filp = NULL;
 		really_put_req(ctx, req);
+	}
 	return 1;
 }
 
@@ -1622,7 +1612,7 @@ static int io_submit_one(struct kioctx *
 		 * an eventfd() fd, and will be signaled for each completed
 		 * event using the eventfd_signal() function.
 		 */
-		req->ki_eventfd = eventfd_fget((int) iocb->aio_resfd);
+		req->ki_eventfd = eventfd_ctx_fdget((int) iocb->aio_resfd);
 		if (IS_ERR(req->ki_eventfd)) {
 			ret = PTR_ERR(req->ki_eventfd);
 			req->ki_eventfd = NULL;
diff -puN fs/eventfd.c~eventfd-revised-interface-and-cleanups-2nd-rev fs/eventfd.c
--- a/fs/eventfd.c~eventfd-revised-interface-and-cleanups-2nd-rev
+++ a/fs/eventfd.c
@@ -14,35 +14,41 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/anon_inodes.h>
-#include <linux/eventfd.h>
 #include <linux/syscalls.h>
 #include <linux/module.h>
+#include <linux/kref.h>
+#include <linux/eventfd.h>
 
 struct eventfd_ctx {
+	struct kref kref;
 	wait_queue_head_t wqh;
 	/*
 	 * Every time that a write(2) is performed on an eventfd, the
 	 * value of the __u64 being written is added to "count" and a
 	 * wakeup is performed on "wqh". A read(2) will return the "count"
 	 * value to userspace, and will reset "count" to zero. The kernel
-	 * size eventfd_signal() also, adds to the "count" counter and
+	 * side eventfd_signal() also, adds to the "count" counter and
 	 * issue a wakeup.
 	 */
 	__u64 count;
 	unsigned int flags;
 };
 
-/*
- * Adds "n" to the eventfd counter "count". Returns "n" in case of
- * success, or a value lower then "n" in case of coutner overflow.
- * This function is supposed to be called by the kernel in paths
- * that do not allow sleeping. In this function we allow the counter
- * to reach the ULLONG_MAX value, and we signal this as overflow
- * condition by returining a POLLERR to poll(2).
+/**
+ * eventfd_signal - Adds @n to the eventfd counter.
+ * @ctx: [in] Pointer to the eventfd context.
+ * @n: [in] Value of the counter to be added to the eventfd internal counter.
+ *
+ * This function is supposed to be called by the kernel in paths that do not
+ * allow sleeping. In this function we allow the counter to reach the ULLONG_MAX
+ * value, and we signal this as overflow condition by returining a POLLERR
+ * to poll(2).
+ *
+ * Returns: In case of success, it returns @n, otherwise (in case of overflow
+ *          of the eventfd 64bit internal counter) a value lower than @n.
  */
-int eventfd_signal(struct file *file, int n)
+int eventfd_signal(struct eventfd_ctx *ctx, int n)
 {
-	struct eventfd_ctx *ctx = file->private_data;
 	unsigned long flags;
 
 	if (n < 0)
@@ -59,9 +65,48 @@ int eventfd_signal(struct file *file, in
 }
 EXPORT_SYMBOL_GPL(eventfd_signal);
 
+static void eventfd_free(struct kref *kref)
+{
+	struct eventfd_ctx *ctx = container_of(kref, struct eventfd_ctx, kref);
+
+	kfree(ctx);
+}
+
+/**
+ * eventfd_ctx_get - Acquires a reference to the internal eventfd context.
+ * @ctx: [in] Pointer to the eventfd context.
+ *
+ * Returns: In case of success, returns a pointer to the eventfd context,
+ *          otherwise a proper error code.
+ */
+struct eventfd_ctx *eventfd_ctx_get(struct eventfd_ctx *ctx)
+{
+	kref_get(&ctx->kref);
+	return ctx;
+}
+EXPORT_SYMBOL_GPL(eventfd_ctx_get);
+
+/**
+ * eventfd_ctx_put - Releases a reference to the internal eventfd context.
+ * @ctx: [in] Pointer to eventfd context.
+ *
+ * The eventfd context reference must have been previously acquired either
+ * with eventfd_ctx_get() or eventfd_ctx_fdget()).
+ *
+ * Returns: Nothing.
+ */
+void eventfd_ctx_put(struct eventfd_ctx *ctx)
+{
+	kref_put(&ctx->kref, eventfd_free);
+}
+EXPORT_SYMBOL_GPL(eventfd_ctx_put);
+
 static int eventfd_release(struct inode *inode, struct file *file)
 {
-	kfree(file->private_data);
+	struct eventfd_ctx *ctx = file->private_data;
+
+	wake_up_poll(&ctx->wqh, POLLHUP);
+	eventfd_ctx_put(ctx);
 	return 0;
 }
 
@@ -185,6 +230,13 @@ static const struct file_operations even
 	.write		= eventfd_write,
 };
 
+/**
+ * eventfd_fget - Acquire a reference of an eventfd file descriptor.
+ * @fd: [in] Eventfd file descriptor.
+ *
+ * Returns: A pointer to the eventfd file structure in case of success, or a
+ *          proper error pointer in case of failure.
+ */
 struct file *eventfd_fget(int fd)
 {
 	struct file *file;
@@ -201,6 +253,44 @@ struct file *eventfd_fget(int fd)
 }
 EXPORT_SYMBOL_GPL(eventfd_fget);
 
+/**
+ * eventfd_ctx_fdget - Acquires a reference to the internal eventfd context.
+ * @fd: [in] Eventfd file descriptor.
+ *
+ * Returns: In case of success, it returns a pointer to the internal eventfd
+ *          context, otherwise a proper error code.
+ */
+struct eventfd_ctx *eventfd_ctx_fdget(int fd)
+{
+	struct file *file;
+	struct eventfd_ctx *ctx;
+
+	file = eventfd_fget(fd);
+	if (IS_ERR(file))
+		return (struct eventfd_ctx *) file;
+	ctx = eventfd_ctx_get(file->private_data);
+	fput(file);
+
+	return ctx;
+}
+EXPORT_SYMBOL_GPL(eventfd_ctx_fdget);
+
+/**
+ * eventfd_ctx_fileget - Acquires a reference to the internal eventfd context.
+ * @file: [in] Eventfd file pointer.
+ *
+ * Returns: In case of success, it returns a pointer to the internal eventfd
+ *          context, otherwise a proper error code.
+ */
+struct eventfd_ctx *eventfd_ctx_fileget(struct file *file)
+{
+	if (file->f_op != &eventfd_fops)
+		return ERR_PTR(-EINVAL);
+
+	return eventfd_ctx_get(file->private_data);
+}
+EXPORT_SYMBOL_GPL(eventfd_ctx_fileget);
+
 SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
 {
 	int fd;
@@ -217,6 +307,7 @@ SYSCALL_DEFINE2(eventfd2, unsigned int, 
 	if (!ctx)
 		return -ENOMEM;
 
+	kref_init(&ctx->kref);
 	init_waitqueue_head(&ctx->wqh);
 	ctx->count = count;
 	ctx->flags = flags;
diff -puN include/linux/aio.h~eventfd-revised-interface-and-cleanups-2nd-rev include/linux/aio.h
--- a/include/linux/aio.h~eventfd-revised-interface-and-cleanups-2nd-rev
+++ a/include/linux/aio.h
@@ -121,9 +121,9 @@ struct kiocb {
 
 	/*
 	 * If the aio_resfd field of the userspace iocb is not zero,
-	 * this is the underlying file* to deliver event to.
+	 * this is the underlying eventfd context to deliver events to.
 	 */
-	struct file		*ki_eventfd;
+	struct eventfd_ctx	*ki_eventfd;
 };
 
 #define is_sync_kiocb(iocb)	((iocb)->ki_key == KIOCB_SYNC_KEY)
diff -puN include/linux/eventfd.h~eventfd-revised-interface-and-cleanups-2nd-rev include/linux/eventfd.h
--- a/include/linux/eventfd.h~eventfd-revised-interface-and-cleanups-2nd-rev
+++ a/include/linux/eventfd.h
@@ -8,10 +8,8 @@
 #ifndef _LINUX_EVENTFD_H
 #define _LINUX_EVENTFD_H
 
-#ifdef CONFIG_EVENTFD
-
-/* For O_CLOEXEC and O_NONBLOCK */
 #include <linux/fcntl.h>
+#include <linux/file.h>
 
 /*
  * CAREFUL: Check include/asm-generic/fcntl.h when defining
@@ -27,16 +25,12 @@
 #define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
 #define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
 
+struct eventfd_ctx *eventfd_ctx_get(struct eventfd_ctx *ctx);
+void eventfd_ctx_put(struct eventfd_ctx *ctx);
 struct file *eventfd_fget(int fd);
-int eventfd_signal(struct file *file, int n);
-
-#else /* CONFIG_EVENTFD */
-
-#define eventfd_fget(fd) ERR_PTR(-ENOSYS)
-static inline int eventfd_signal(struct file *file, int n)
-{ return 0; }
-
-#endif /* CONFIG_EVENTFD */
+struct eventfd_ctx *eventfd_ctx_fdget(int fd);
+struct eventfd_ctx *eventfd_ctx_fileget(struct file *file);
+int eventfd_signal(struct eventfd_ctx *ctx, int n);
 
 #endif /* _LINUX_EVENTFD_H */
 
diff -puN init/Kconfig~eventfd-revised-interface-and-cleanups-2nd-rev init/Kconfig
--- a/init/Kconfig~eventfd-revised-interface-and-cleanups-2nd-rev
+++ a/init/Kconfig
@@ -925,6 +925,7 @@ config SHMEM
 
 config AIO
 	bool "Enable AIO support" if EMBEDDED
+	select EVENTFD
 	default y
 	help
 	  This option enables POSIX asynchronous I/O which may by used
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
eventfd-revised-interface-and-cleanups-4th-rev.patch
eventfd-revised-interface-and-cleanups-2nd-rev.patch
linux-next.patch


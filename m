From: akpm@linux-foundation.org
Subject: - signal-timer-event-fds-v9-eventfd-core.patch removed from -mm tree
Date: Fri, 11 May 2007 22:35:14 -0700
Message-ID: <200705120535.l4C5ZE5p002273@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754620AbXELFfR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:35:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     signal/timer/event: eventfd core
has been removed from the -mm tree.  Its filename was
     signal-timer-event-fds-v9-eventfd-core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: signal/timer/event: eventfd core
From: Davide Libenzi <davidel@xmailserver.org>

This is a very simple and light file descriptor, that can be used as event
wait/dispatch by userspace (both wait and dispatch) and by the kernel
(dispatch only).  It can be used instead of pipe(2) in all cases where those
would simply be used to signal events.  Their kernel overhead is much lower
than pipes, and they do not consume two fds.  When used in the kernel, it can
offer an fd-bridge to enable, for example, functionalities like KAIO or
syslets/threadlets to signal to an fd the completion of certain operations. 
But more in general, an eventfd can be used by the kernel to signal readiness,
in a POSIX poll/select way, of interfaces that would otherwise be incompatible
with it.  The API is:

int eventfd(unsigned int count);

The eventfd API accepts an initial "count" parameter, and returns an eventfd
fd.  It supports poll(2) (POLLIN, POLLOUT, POLLERR), read(2) and write(2).

The POLLIN flag is raised when the internal counter is greater than zero.

The POLLOUT flag is raised when at least a value of "1" can be written to the
internal counter.

The POLLERR flag is raised when an overflow in the counter value is detected.

The write(2) operation can never overflow the counter, since it blocks (unless
O_NONBLOCK is set, in which case -EAGAIN is returned).

But the eventfd_signal() function can do it, since it's supposed to not sleep
during its operation.

The read(2) function reads the __u64 counter value, and reset the internal
value to zero.  If the value read is equal to (__u64) -1, an overflow happened
on the internal counter (due to 2^64 eventfd_signal() posts that has never
been retired - unlickely, but possible).

The write(2) call writes an __u64 count value, and adds it to the current
counter.  The eventfd fd supports O_NONBLOCK also.

On the kernel side, we have:

struct file *eventfd_fget(int fd);
int eventfd_signal(struct file *file, unsigned int n);

The eventfd_fget() should be called to get a struct file* from an eventfd fd
(this is an fget() + check of f_op being an eventfd fops pointer).

The kernel can then call eventfd_signal() every time it wants to post an event
to userspace.  The eventfd_signal() function can be called from any context. 
An eventfd() simple test and bench is available here:

http://www.xmailserver.org/eventfd-bench.c

This is the eventfd-based version of pipetest-4 (pipe(2) based):

http://www.xmailserver.org/pipetest-4.c

Not that performance matters much in the eventfd case, but eventfd-bench
shows almost as double as performance than pipetest-4.

[akpm@linux-foundation.org: fix i386 build]
[akpm@linux-foundation.org: add sys_eventfd to sys_ni.c]
Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Makefile              |    1 
 fs/eventfd.c             |  228 +++++++++++++++++++++++++++++++++++++
 include/linux/eventfd.h  |   29 ++++
 include/linux/syscalls.h |    1 
 init/Kconfig             |   10 +
 kernel/sys_ni.c          |    1 
 6 files changed, 270 insertions(+)

diff -puN fs/Makefile~signal-timer-event-fds-v9-eventfd-core fs/Makefile
--- a/fs/Makefile~signal-timer-event-fds-v9-eventfd-core
+++ a/fs/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_EPOLL)		+= eventpoll.o
 obj-$(CONFIG_ANON_INODES)	+= anon_inodes.o
 obj-$(CONFIG_SIGNALFD)		+= signalfd.o
 obj-$(CONFIG_TIMERFD)		+= timerfd.o
+obj-$(CONFIG_EVENTFD)		+= eventfd.o
 obj-$(CONFIG_COMPAT)		+= compat.o compat_ioctl.o
 
 nfsd-$(CONFIG_NFSD)		:= nfsctl.o
diff -puN /dev/null fs/eventfd.c
--- /dev/null
+++ a/fs/eventfd.c
@@ -0,0 +1,228 @@
+/*
+ *  fs/eventfd.c
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#include <linux/file.h>
+#include <linux/poll.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/anon_inodes.h>
+#include <linux/eventfd.h>
+
+struct eventfd_ctx {
+	spinlock_t lock;
+	wait_queue_head_t wqh;
+	/*
+	 * Every time that a write(2) is performed on an eventfd, the
+	 * value of the __u64 being written is added to "count" and a
+	 * wakeup is performed on "wqh". A read(2) will return the "count"
+	 * value to userspace, and will reset "count" to zero. The kernel
+	 * size eventfd_signal() also, adds to the "count" counter and
+	 * issue a wakeup.
+	 */
+	__u64 count;
+};
+
+/*
+ * Adds "n" to the eventfd counter "count". Returns "n" in case of
+ * success, or a value lower then "n" in case of coutner overflow.
+ * This function is supposed to be called by the kernel in paths
+ * that do not allow sleeping. In this function we allow the counter
+ * to reach the ULLONG_MAX value, and we signal this as overflow
+ * condition by returining a POLLERR to poll(2).
+ */
+int eventfd_signal(struct file *file, int n)
+{
+	struct eventfd_ctx *ctx = file->private_data;
+	unsigned long flags;
+
+	if (n < 0)
+		return -EINVAL;
+	spin_lock_irqsave(&ctx->lock, flags);
+	if (ULLONG_MAX - ctx->count < n)
+		n = (int) (ULLONG_MAX - ctx->count);
+	ctx->count += n;
+	if (waitqueue_active(&ctx->wqh))
+		wake_up_locked(&ctx->wqh);
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	return n;
+}
+
+static int eventfd_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	return 0;
+}
+
+static unsigned int eventfd_poll(struct file *file, poll_table *wait)
+{
+	struct eventfd_ctx *ctx = file->private_data;
+	unsigned int events = 0;
+	unsigned long flags;
+
+	poll_wait(file, &ctx->wqh, wait);
+
+	spin_lock_irqsave(&ctx->lock, flags);
+	if (ctx->count > 0)
+		events |= POLLIN;
+	if (ctx->count == ULLONG_MAX)
+		events |= POLLERR;
+	if (ULLONG_MAX - 1 > ctx->count)
+		events |= POLLOUT;
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	return events;
+}
+
+static ssize_t eventfd_read(struct file *file, char __user *buf, size_t count,
+			    loff_t *ppos)
+{
+	struct eventfd_ctx *ctx = file->private_data;
+	ssize_t res;
+	__u64 ucnt;
+	DECLARE_WAITQUEUE(wait, current);
+
+	if (count < sizeof(ucnt))
+		return -EINVAL;
+	spin_lock_irq(&ctx->lock);
+	res = -EAGAIN;
+	ucnt = ctx->count;
+	if (ucnt > 0)
+		res = sizeof(ucnt);
+	else if (!(file->f_flags & O_NONBLOCK)) {
+		__add_wait_queue(&ctx->wqh, &wait);
+		for (res = 0;;) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			if (ctx->count > 0) {
+				ucnt = ctx->count;
+				res = sizeof(ucnt);
+				break;
+			}
+			if (signal_pending(current)) {
+				res = -ERESTARTSYS;
+				break;
+			}
+			spin_unlock_irq(&ctx->lock);
+			schedule();
+			spin_lock_irq(&ctx->lock);
+		}
+		__remove_wait_queue(&ctx->wqh, &wait);
+		__set_current_state(TASK_RUNNING);
+	}
+	if (res > 0) {
+		ctx->count = 0;
+		if (waitqueue_active(&ctx->wqh))
+			wake_up_locked(&ctx->wqh);
+	}
+	spin_unlock_irq(&ctx->lock);
+	if (res > 0 && put_user(ucnt, (__u64 __user *) buf))
+		return -EFAULT;
+
+	return res;
+}
+
+static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t count,
+			     loff_t *ppos)
+{
+	struct eventfd_ctx *ctx = file->private_data;
+	ssize_t res;
+	__u64 ucnt;
+	DECLARE_WAITQUEUE(wait, current);
+
+	if (count < sizeof(ucnt))
+		return -EINVAL;
+	if (copy_from_user(&ucnt, buf, sizeof(ucnt)))
+		return -EFAULT;
+	if (ucnt == ULLONG_MAX)
+		return -EINVAL;
+	spin_lock_irq(&ctx->lock);
+	res = -EAGAIN;
+	if (ULLONG_MAX - ctx->count > ucnt)
+		res = sizeof(ucnt);
+	else if (!(file->f_flags & O_NONBLOCK)) {
+		__add_wait_queue(&ctx->wqh, &wait);
+		for (res = 0;;) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			if (ULLONG_MAX - ctx->count > ucnt) {
+				res = sizeof(ucnt);
+				break;
+			}
+			if (signal_pending(current)) {
+				res = -ERESTARTSYS;
+				break;
+			}
+			spin_unlock_irq(&ctx->lock);
+			schedule();
+			spin_lock_irq(&ctx->lock);
+		}
+		__remove_wait_queue(&ctx->wqh, &wait);
+		__set_current_state(TASK_RUNNING);
+	}
+	if (res > 0) {
+		ctx->count += ucnt;
+		if (waitqueue_active(&ctx->wqh))
+			wake_up_locked(&ctx->wqh);
+	}
+	spin_unlock_irq(&ctx->lock);
+
+	return res;
+}
+
+static const struct file_operations eventfd_fops = {
+	.release	= eventfd_release,
+	.poll		= eventfd_poll,
+	.read		= eventfd_read,
+	.write		= eventfd_write,
+};
+
+struct file *eventfd_fget(int fd)
+{
+	struct file *file;
+
+	file = fget(fd);
+	if (!file)
+		return ERR_PTR(-EBADF);
+	if (file->f_op != &eventfd_fops) {
+		fput(file);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return file;
+}
+
+asmlinkage long sys_eventfd(unsigned int count)
+{
+	int error, fd;
+	struct eventfd_ctx *ctx;
+	struct file *file;
+	struct inode *inode;
+
+	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	init_waitqueue_head(&ctx->wqh);
+	spin_lock_init(&ctx->lock);
+	ctx->count = count;
+
+	/*
+	 * When we call this, the initialization must be complete, since
+	 * anon_inode_getfd() will install the fd.
+	 */
+	error = anon_inode_getfd(&fd, &inode, &file, "[eventfd]",
+				 &eventfd_fops, ctx);
+	if (!error)
+		return fd;
+
+	kfree(ctx);
+	return error;
+}
+
diff -puN /dev/null include/linux/eventfd.h
--- /dev/null
+++ a/include/linux/eventfd.h
@@ -0,0 +1,29 @@
+/*
+ *  include/linux/eventfd.h
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#ifndef _LINUX_EVENTFD_H
+#define _LINUX_EVENTFD_H
+
+
+#ifdef __KERNEL__
+
+#ifdef CONFIG_EVENTFD
+
+struct file *eventfd_fget(int fd);
+int eventfd_signal(struct file *file, int n);
+
+#else /* CONFIG_EVENTFD */
+
+#define eventfd_fget(fd) ERR_PTR(-ENOSYS)
+#define eventfd_signal(f, n) 0
+
+#endif /* CONFIG_EVENTFD */
+
+#endif /* __KERNEL__ */
+
+#endif /* _LINUX_EVENTFD_H */
+
diff -puN include/linux/syscalls.h~signal-timer-event-fds-v9-eventfd-core include/linux/syscalls.h
--- a/include/linux/syscalls.h~signal-timer-event-fds-v9-eventfd-core
+++ a/include/linux/syscalls.h
@@ -607,6 +607,7 @@ asmlinkage long sys_getcpu(unsigned __us
 asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemask);
 asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
 			    const struct itimerspec __user *utmr);
+asmlinkage long sys_eventfd(unsigned int count);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
diff -puN init/Kconfig~signal-timer-event-fds-v9-eventfd-core init/Kconfig
--- a/init/Kconfig~signal-timer-event-fds-v9-eventfd-core
+++ a/init/Kconfig
@@ -512,6 +512,16 @@ config TIMERFD
 
 	  If unsure, say Y.
 
+config EVENTFD
+	bool "Enable eventfd() system call" if EMBEDDED
+	depends on ANON_INODES
+	default y
+	help
+	  Enable the eventfd() system call that allows to receive both
+	  kernel notification (ie. KAIO) or userspace notifications.
+
+	  If unsure, say Y.
+
 config SHMEM
 	bool "Use full shmem filesystem" if EMBEDDED
 	default y
diff -puN kernel/sys_ni.c~signal-timer-event-fds-v9-eventfd-core kernel/sys_ni.c
--- a/kernel/sys_ni.c~signal-timer-event-fds-v9-eventfd-core
+++ a/kernel/sys_ni.c
@@ -145,3 +145,4 @@ cond_syscall(sys_ioprio_get);
 /* New file descriptors */
 cond_syscall(sys_signalfd);
 cond_syscall(sys_timerfd);
+cond_syscall(sys_eventfd);
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
compat-signalfd-and-timerfd-are-cond-syscalls.patch
x86_64-use-signalfd-and-timerfd-compat-syscalls.patch

From: akpm@linux-foundation.org
Subject: - signal-timer-event-fds-v9-timerfd-core.patch removed from -mm tree
Date: Fri, 11 May 2007 22:35:06 -0700
Message-ID: <200705120535.l4C5Z6A8002250@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754620AbXELFfJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:35:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     signal/timer/event: timerfd core
has been removed from the -mm tree.  Its filename was
     signal-timer-event-fds-v9-timerfd-core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: signal/timer/event: timerfd core
From: Davide Libenzi <davidel@xmailserver.org>

This patch introduces a new system call for timers events delivered though
file descriptors.  This allows timer event to be used with standard POSIX
poll(2), select(2) and read(2).  As a consequence of supporting the Linux
f_op->poll subsystem, they can be used with epoll(2) too.

The system call is defined as:

int timerfd(int ufd, int clockid, int flags, const struct itimerspec *utmr);

The "ufd" parameter allows for re-use (re-programming) of an existing timerfd
w/out going through the close/open cycle (same as signalfd).  If "ufd" is -1,
s new file descriptor will be created, otherwise the existing "ufd" will be
re-programmed.

The "clockid" parameter is either CLOCK_MONOTONIC or CLOCK_REALTIME.  The time
specified in the "utmr->it_value" parameter is the expiry time for the timer.

If the TFD_TIMER_ABSTIME flag is set in "flags", this is an absolute time,
otherwise it's a relative time.

If the time specified in the "utmr->it_interval" is not zero (.tv_sec == 0,
tv_nsec == 0), this is the period at which the following ticks should be
generated.

The "utmr->it_interval" should be set to zero if only one tick is requested. 
Setting the "utmr->it_value" to zero will disable the timer, or will create a
timerfd without the timer enabled.

The function returns the new (or same, in case "ufd" is a valid timerfd
descriptor) file, or -1 in case of error.

As stated before, the timerfd file descriptor supports poll(2), select(2) and
epoll(2).  When a timer event happened on the timerfd, a POLLIN mask will be
returned.

The read(2) call can be used, and it will return a u32 variable holding the
number of "ticks" that happened on the interface since the last call to
read(2).  The read(2) call supportes the O_NONBLOCK flag too, and EAGAIN will
be returned if no ticks happened.

A quick test program, shows timerfd working correctly on my amd64 box:

http://www.xmailserver.org/timerfd-test.c

[akpm@linux-foundation.org: add sys_timerfd to sys_ni.c]
Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Makefile              |    1 
 fs/timerfd.c             |  227 +++++++++++++++++++++++++++++++++++++
 include/linux/syscalls.h |    2 
 include/linux/timerfd.h  |   17 ++
 init/Kconfig             |   10 +
 kernel/sys_ni.c          |    1 
 6 files changed, 258 insertions(+)

diff -puN fs/Makefile~signal-timer-event-fds-v9-timerfd-core fs/Makefile
--- a/fs/Makefile~signal-timer-event-fds-v9-timerfd-core
+++ a/fs/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_INOTIFY_USER)	+= inotify_us
 obj-$(CONFIG_EPOLL)		+= eventpoll.o
 obj-$(CONFIG_ANON_INODES)	+= anon_inodes.o
 obj-$(CONFIG_SIGNALFD)		+= signalfd.o
+obj-$(CONFIG_TIMERFD)		+= timerfd.o
 obj-$(CONFIG_COMPAT)		+= compat.o compat_ioctl.o
 
 nfsd-$(CONFIG_NFSD)		:= nfsctl.o
diff -puN /dev/null fs/timerfd.c
--- /dev/null
+++ a/fs/timerfd.c
@@ -0,0 +1,227 @@
+/*
+ *  fs/timerfd.c
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ *
+ *  Thanks to Thomas Gleixner for code reviews and useful comments.
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
+#include <linux/time.h>
+#include <linux/hrtimer.h>
+#include <linux/anon_inodes.h>
+#include <linux/timerfd.h>
+
+struct timerfd_ctx {
+	struct hrtimer tmr;
+	ktime_t tintv;
+	spinlock_t lock;
+	wait_queue_head_t wqh;
+	int expired;
+};
+
+/*
+ * This gets called when the timer event triggers. We set the "expired"
+ * flag, but we do not re-arm the timer (in case it's necessary,
+ * tintv.tv64 != 0) until the timer is read.
+ */
+static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
+{
+	struct timerfd_ctx *ctx = container_of(htmr, struct timerfd_ctx, tmr);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->lock, flags);
+	ctx->expired = 1;
+	wake_up_locked(&ctx->wqh);
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	return HRTIMER_NORESTART;
+}
+
+static void timerfd_setup(struct timerfd_ctx *ctx, int clockid, int flags,
+			  const struct itimerspec *ktmr)
+{
+	enum hrtimer_mode htmode;
+	ktime_t texp;
+
+	htmode = (flags & TFD_TIMER_ABSTIME) ?
+		HRTIMER_MODE_ABS: HRTIMER_MODE_REL;
+
+	texp = timespec_to_ktime(ktmr->it_value);
+	ctx->expired = 0;
+	ctx->tintv = timespec_to_ktime(ktmr->it_interval);
+	hrtimer_init(&ctx->tmr, clockid, htmode);
+	ctx->tmr.expires = texp;
+	ctx->tmr.function = timerfd_tmrproc;
+	if (texp.tv64 != 0)
+		hrtimer_start(&ctx->tmr, texp, htmode);
+}
+
+static int timerfd_release(struct inode *inode, struct file *file)
+{
+	struct timerfd_ctx *ctx = file->private_data;
+
+	hrtimer_cancel(&ctx->tmr);
+	kfree(ctx);
+	return 0;
+}
+
+static unsigned int timerfd_poll(struct file *file, poll_table *wait)
+{
+	struct timerfd_ctx *ctx = file->private_data;
+	unsigned int events = 0;
+	unsigned long flags;
+
+	poll_wait(file, &ctx->wqh, wait);
+
+	spin_lock_irqsave(&ctx->lock, flags);
+	if (ctx->expired)
+		events |= POLLIN;
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	return events;
+}
+
+static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
+			    loff_t *ppos)
+{
+	struct timerfd_ctx *ctx = file->private_data;
+	ssize_t res;
+	u32 ticks = 0;
+	DECLARE_WAITQUEUE(wait, current);
+
+	if (count < sizeof(ticks))
+		return -EINVAL;
+	spin_lock_irq(&ctx->lock);
+	res = -EAGAIN;
+	if (!ctx->expired && !(file->f_flags & O_NONBLOCK)) {
+		__add_wait_queue(&ctx->wqh, &wait);
+		for (res = 0;;) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			if (ctx->expired) {
+				res = 0;
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
+	if (ctx->expired) {
+		ctx->expired = 0;
+		if (ctx->tintv.tv64 != 0) {
+			/*
+			 * If tintv.tv64 != 0, this is a periodic timer that
+			 * needs to be re-armed. We avoid doing it in the timer
+			 * callback to avoid DoS attacks specifying a very
+			 * short timer period.
+			 */
+			ticks = (u32)
+				hrtimer_forward(&ctx->tmr,
+						hrtimer_cb_get_time(&ctx->tmr),
+						ctx->tintv);
+			hrtimer_restart(&ctx->tmr);
+		} else
+			ticks = 1;
+	}
+	spin_unlock_irq(&ctx->lock);
+	if (ticks)
+		res = put_user(ticks, buf) ? -EFAULT: sizeof(ticks);
+	return res;
+}
+
+static const struct file_operations timerfd_fops = {
+	.release	= timerfd_release,
+	.poll		= timerfd_poll,
+	.read		= timerfd_read,
+};
+
+asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
+			    const struct itimerspec __user *utmr)
+{
+	int error;
+	struct timerfd_ctx *ctx;
+	struct file *file;
+	struct inode *inode;
+	struct itimerspec ktmr;
+
+	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
+		return -EFAULT;
+
+	if (clockid != CLOCK_MONOTONIC &&
+	    clockid != CLOCK_REALTIME)
+		return -EINVAL;
+	if (!timespec_valid(&ktmr.it_value) ||
+	    !timespec_valid(&ktmr.it_interval))
+		return -EINVAL;
+
+	if (ufd == -1) {
+		ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
+		if (!ctx)
+			return -ENOMEM;
+
+		init_waitqueue_head(&ctx->wqh);
+		spin_lock_init(&ctx->lock);
+
+		timerfd_setup(ctx, clockid, flags, &ktmr);
+
+		/*
+		 * When we call this, the initialization must be complete, since
+		 * anon_inode_getfd() will install the fd.
+		 */
+		error = anon_inode_getfd(&ufd, &inode, &file, "[timerfd]",
+					 &timerfd_fops, ctx);
+		if (error)
+			goto err_tmrcancel;
+	} else {
+		file = fget(ufd);
+		if (!file)
+			return -EBADF;
+		ctx = file->private_data;
+		if (file->f_op != &timerfd_fops) {
+			fput(file);
+			return -EINVAL;
+		}
+		/*
+		 * We need to stop the existing timer before reprogramming
+		 * it to the new values.
+		 */
+		for (;;) {
+			spin_lock_irq(&ctx->lock);
+			if (hrtimer_try_to_cancel(&ctx->tmr) >= 0)
+				break;
+			spin_unlock_irq(&ctx->lock);
+			cpu_relax();
+		}
+		/*
+		 * Re-program the timer to the new value ...
+		 */
+		timerfd_setup(ctx, clockid, flags, &ktmr);
+
+		spin_unlock_irq(&ctx->lock);
+		fput(file);
+	}
+
+	return ufd;
+
+err_tmrcancel:
+	hrtimer_cancel(&ctx->tmr);
+	kfree(ctx);
+	return error;
+}
+
diff -puN include/linux/syscalls.h~signal-timer-event-fds-v9-timerfd-core include/linux/syscalls.h
--- a/include/linux/syscalls.h~signal-timer-event-fds-v9-timerfd-core
+++ a/include/linux/syscalls.h
@@ -605,6 +605,8 @@ asmlinkage long sys_set_robust_list(stru
 				    size_t len);
 asmlinkage long sys_getcpu(unsigned __user *cpu, unsigned __user *node, struct getcpu_cache __user *cache);
 asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemask);
+asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
+			    const struct itimerspec __user *utmr);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
diff -puN /dev/null include/linux/timerfd.h
--- /dev/null
+++ a/include/linux/timerfd.h
@@ -0,0 +1,17 @@
+/*
+ *  include/linux/timerfd.h
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#ifndef _LINUX_TIMERFD_H
+#define _LINUX_TIMERFD_H
+
+
+#define TFD_TIMER_ABSTIME (1 << 0)
+
+
+
+#endif /* _LINUX_TIMERFD_H */
+
diff -puN init/Kconfig~signal-timer-event-fds-v9-timerfd-core init/Kconfig
--- a/init/Kconfig~signal-timer-event-fds-v9-timerfd-core
+++ a/init/Kconfig
@@ -502,6 +502,16 @@ config SIGNALFD
 
 	  If unsure, say Y.
 
+config TIMERFD
+	bool "Enable timerfd() system call" if EMBEDDED
+	depends on ANON_INODES
+	default y
+	help
+	  Enable the timerfd() system call that allows to receive timer
+	  events on a file descriptor.
+
+	  If unsure, say Y.
+
 config SHMEM
 	bool "Use full shmem filesystem" if EMBEDDED
 	default y
diff -puN kernel/sys_ni.c~signal-timer-event-fds-v9-timerfd-core kernel/sys_ni.c
--- a/kernel/sys_ni.c~signal-timer-event-fds-v9-timerfd-core
+++ a/kernel/sys_ni.c
@@ -144,3 +144,4 @@ cond_syscall(sys_ioprio_get);
 
 /* New file descriptors */
 cond_syscall(sys_signalfd);
+cond_syscall(sys_timerfd);
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
compat-signalfd-and-timerfd-are-cond-syscalls.patch
x86_64-use-signalfd-and-timerfd-compat-syscalls.patch

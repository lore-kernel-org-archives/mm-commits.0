From: akpm@linux-foundation.org
Subject: - timerfd-v3-new-timerfd-api.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:26:40 -0800
Message-ID: <200802052226.m15MQLnH011619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54050 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760446AbYBEW0n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:26:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, heiko.carstens@de.ibm.com, mtk-manpages@gmx.net, mtk.manpages@gmail.com, schwidefsky@de.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     timerfd: new timerfd API
has been removed from the -mm tree.  Its filename was
     timerfd-v3-new-timerfd-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: timerfd: new timerfd API
From: Davide Libenzi <davidel@xmailserver.org>

This is the new timerfd API as it is implemented by the following patch:

int timerfd_create(int clockid, int flags);
int timerfd_settime(int ufd, int flags,
		    const struct itimerspec *utmr,
		    struct itimerspec *otmr);
int timerfd_gettime(int ufd, struct itimerspec *otmr);

The timerfd_create() API creates an un-programmed timerfd fd.  The "clockid"
parameter can be either CLOCK_MONOTONIC or CLOCK_REALTIME.

The timerfd_settime() API give new settings by the timerfd fd, by optionally
retrieving the previous expiration time (in case the "otmr" parameter is not
NULL).

The time value specified in "utmr" is absolute, if the TFD_TIMER_ABSTIME bit
is set in the "flags" parameter.  Otherwise it's a relative time.

The timerfd_gettime() API returns the next expiration time of the timer, or
{0, 0} if the timerfd has not been set yet.

Like the previous timerfd API implementation, read(2) and poll(2) are
supported (with the same interface).  Here's a simple test program I used to
exercise the new timerfd APIs:

http://www.xmailserver.org/timerfd-test2.c

[akpm@linux-foundation.org: coding-style cleanups]
[akpm@linux-foundation.org: fix ia64 build]
[akpm@linux-foundation.org: fix m68k build]
[akpm@linux-foundation.org: fix mips build]
[akpm@linux-foundation.org: fix alpha, arm, blackfin, cris, m68k, s390, sparc and sparc64 builds]
[heiko.carstens@de.ibm.com: fix s390]
[akpm@linux-foundation.org: fix powerpc build]
[akpm@linux-foundation.org: fix sparc64 more]
Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/systbls.S          |    2 
 arch/arm/kernel/calls.S              |    2 
 arch/blackfin/mach-common/entry.S    |    2 
 arch/cris/arch-v10/kernel/entry.S    |    2 
 arch/ia64/kernel/entry.S             |    2 
 arch/m68k/kernel/entry.S             |    2 
 arch/m68knommu/kernel/syscalltable.S |    2 
 arch/mips/kernel/scall32-o32.S       |    2 
 arch/mips/kernel/scall64-64.S        |    2 
 arch/mips/kernel/scall64-n32.S       |    2 
 arch/mips/kernel/scall64-o32.S       |    2 
 arch/s390/kernel/compat_wrapper.S    |    8 
 arch/s390/kernel/syscalls.S          |    2 
 arch/sparc/kernel/systbls.S          |    2 
 arch/sparc64/kernel/systbls.S        |    4 
 fs/compat.c                          |   32 +++
 fs/timerfd.c                         |  209 ++++++++++++++++---------
 include/asm-powerpc/systbl.h         |    2 
 include/linux/compat.h               |    7 
 include/linux/hrtimer.h              |   10 -
 include/linux/syscalls.h             |    7 
 kernel/hrtimer.c                     |    9 -
 kernel/posix-timers.c                |    9 -
 kernel/sys_ni.c                      |    7 
 24 files changed, 211 insertions(+), 119 deletions(-)

diff -puN arch/alpha/kernel/systbls.S~timerfd-v3-new-timerfd-api arch/alpha/kernel/systbls.S
--- a/arch/alpha/kernel/systbls.S~timerfd-v3-new-timerfd-api
+++ a/arch/alpha/kernel/systbls.S
@@ -495,7 +495,7 @@ sys_call_table:
 	.quad sys_epoll_pwait
 	.quad sys_utimensat			/* 475 */
 	.quad sys_signalfd
-	.quad sys_timerfd
+	.quad sys_ni_syscall
 	.quad sys_eventfd
 
 	.size sys_call_table, . - sys_call_table
diff -puN arch/arm/kernel/calls.S~timerfd-v3-new-timerfd-api arch/arm/kernel/calls.S
--- a/arch/arm/kernel/calls.S~timerfd-v3-new-timerfd-api
+++ a/arch/arm/kernel/calls.S
@@ -359,7 +359,7 @@
 		CALL(sys_kexec_load)
 		CALL(sys_utimensat)
 		CALL(sys_signalfd)
-/* 350 */	CALL(sys_timerfd)
+/* 350 */	CALL(sys_ni_syscall)
 		CALL(sys_eventfd)
 		CALL(sys_fallocate)
 #ifndef syscalls_counted
diff -puN arch/blackfin/mach-common/entry.S~timerfd-v3-new-timerfd-api arch/blackfin/mach-common/entry.S
--- a/arch/blackfin/mach-common/entry.S~timerfd-v3-new-timerfd-api
+++ a/arch/blackfin/mach-common/entry.S
@@ -1373,7 +1373,7 @@ ENTRY(_sys_call_table)
 	.long _sys_epoll_pwait
 	.long _sys_utimensat
 	.long _sys_signalfd
-	.long _sys_timerfd
+	.long _sys_ni_syscall
 	.long _sys_eventfd	/* 350 */
 	.long _sys_pread64
 	.long _sys_pwrite64
diff -puN arch/cris/arch-v10/kernel/entry.S~timerfd-v3-new-timerfd-api arch/cris/arch-v10/kernel/entry.S
--- a/arch/cris/arch-v10/kernel/entry.S~timerfd-v3-new-timerfd-api
+++ a/arch/cris/arch-v10/kernel/entry.S
@@ -1167,7 +1167,7 @@ sys_call_table:	
 	.long sys_epoll_pwait
 	.long sys_utimensat		/* 320 */
 	.long sys_signalfd
-	.long sys_timerfd
+	.long sys_ni_syscall
 	.long sys_eventfd
 	.long sys_fallocate
 
diff -puN arch/ia64/kernel/entry.S~timerfd-v3-new-timerfd-api arch/ia64/kernel/entry.S
--- a/arch/ia64/kernel/entry.S~timerfd-v3-new-timerfd-api
+++ a/arch/ia64/kernel/entry.S
@@ -1586,7 +1586,7 @@ sys_call_table:
 	data8 sys_epoll_pwait			// 1305
 	data8 sys_utimensat
 	data8 sys_signalfd
-	data8 sys_timerfd
+	data8 sys_ni_syscall
 	data8 sys_eventfd
 
 	.org sys_call_table + 8*NR_syscalls	// guard against failures to increase NR_syscalls
diff -puN arch/m68k/kernel/entry.S~timerfd-v3-new-timerfd-api arch/m68k/kernel/entry.S
--- a/arch/m68k/kernel/entry.S~timerfd-v3-new-timerfd-api
+++ a/arch/m68k/kernel/entry.S
@@ -742,7 +742,7 @@ sys_call_table:
 	.long sys_epoll_pwait		/* 315 */
 	.long sys_utimensat
 	.long sys_signalfd
-	.long sys_timerfd
+	.long sys_ni_syscall
 	.long sys_eventfd
 	.long sys_fallocate		/* 320 */
 
diff -puN arch/m68knommu/kernel/syscalltable.S~timerfd-v3-new-timerfd-api arch/m68knommu/kernel/syscalltable.S
--- a/arch/m68knommu/kernel/syscalltable.S~timerfd-v3-new-timerfd-api
+++ a/arch/m68knommu/kernel/syscalltable.S
@@ -336,7 +336,7 @@ ENTRY(sys_call_table)
 	.long sys_epoll_pwait		/* 315 */
 	.long sys_utimensat
 	.long sys_signalfd
-	.long sys_timerfd
+	.long sys_ni_syscall
 	.long sys_eventfd
 	.long sys_fallocate		/* 320 */
 
diff -puN arch/mips/kernel/scall32-o32.S~timerfd-v3-new-timerfd-api arch/mips/kernel/scall32-o32.S
--- a/arch/mips/kernel/scall32-o32.S~timerfd-v3-new-timerfd-api
+++ a/arch/mips/kernel/scall32-o32.S
@@ -660,7 +660,7 @@ einval:	li	v0, -EINVAL
 	sys	sys_ioprio_get		2	/* 4315 */
 	sys	sys_utimensat		4
 	sys	sys_signalfd		3
-	sys	sys_timerfd		4
+	sys	sys_ni_syscall		0
 	sys	sys_eventfd		1
 	sys	sys_fallocate		6	/* 4320 */
 	.endm
diff -puN arch/mips/kernel/scall64-64.S~timerfd-v3-new-timerfd-api arch/mips/kernel/scall64-64.S
--- a/arch/mips/kernel/scall64-64.S~timerfd-v3-new-timerfd-api
+++ a/arch/mips/kernel/scall64-64.S
@@ -475,7 +475,7 @@ sys_call_table:
 	PTR	sys_ioprio_get
 	PTR	sys_utimensat			/* 5275 */
 	PTR	sys_signalfd
-	PTR	sys_timerfd
+	PTR	sys_ni_syscall
 	PTR	sys_eventfd
 	PTR	sys_fallocate
 	.size	sys_call_table,.-sys_call_table
diff -puN arch/mips/kernel/scall64-n32.S~timerfd-v3-new-timerfd-api arch/mips/kernel/scall64-n32.S
--- a/arch/mips/kernel/scall64-n32.S~timerfd-v3-new-timerfd-api
+++ a/arch/mips/kernel/scall64-n32.S
@@ -401,7 +401,7 @@ EXPORT(sysn32_call_table)
 	PTR	sys_ioprio_get
 	PTR	compat_sys_utimensat
 	PTR	compat_sys_signalfd		/* 5280 */
-	PTR	compat_sys_timerfd
+	PTR	sys_ni_syscall
 	PTR	sys_eventfd
 	PTR	sys_fallocate
 	.size	sysn32_call_table,.-sysn32_call_table
diff -puN arch/mips/kernel/scall64-o32.S~timerfd-v3-new-timerfd-api arch/mips/kernel/scall64-o32.S
--- a/arch/mips/kernel/scall64-o32.S~timerfd-v3-new-timerfd-api
+++ a/arch/mips/kernel/scall64-o32.S
@@ -523,7 +523,7 @@ sys_call_table:
 	PTR	sys_ioprio_get			/* 4315 */
 	PTR	compat_sys_utimensat
 	PTR	compat_sys_signalfd
-	PTR	compat_sys_timerfd
+	PTR	sys_ni_syscall
 	PTR	sys_eventfd
 	PTR	sys32_fallocate			/* 4320 */
 	.size	sys_call_table,.-sys_call_table
diff -puN arch/s390/kernel/compat_wrapper.S~timerfd-v3-new-timerfd-api arch/s390/kernel/compat_wrapper.S
--- a/arch/s390/kernel/compat_wrapper.S~timerfd-v3-new-timerfd-api
+++ a/arch/s390/kernel/compat_wrapper.S
@@ -1698,14 +1698,6 @@ compat_sys_signalfd_wrapper:
 	llgfr	%r4,%r4			# compat_size_t
 	jg	compat_sys_signalfd
 
-	.globl	compat_sys_timerfd_wrapper
-compat_sys_timerfd_wrapper:
-	lgfr	%r2,%r2			# int
-	lgfr	%r3,%r3			# int
-	lgfr	%r4,%r4			# int
-	llgtr	%r5,%r5			# struct compat_itimerspec *
-	jg	compat_sys_timerfd
-
 	.globl	sys_eventfd_wrapper
 sys_eventfd_wrapper:
 	llgfr	%r2,%r2			# unsigned int
diff -puN arch/s390/kernel/syscalls.S~timerfd-v3-new-timerfd-api arch/s390/kernel/syscalls.S
--- a/arch/s390/kernel/syscalls.S~timerfd-v3-new-timerfd-api
+++ a/arch/s390/kernel/syscalls.S
@@ -325,5 +325,5 @@ SYSCALL(sys_utimes,sys_utimes,compat_sys
 SYSCALL(s390_fallocate,sys_fallocate,sys_fallocate_wrapper)
 SYSCALL(sys_utimensat,sys_utimensat,compat_sys_utimensat_wrapper)	/* 315 */
 SYSCALL(sys_signalfd,sys_signalfd,compat_sys_signalfd_wrapper)
-SYSCALL(sys_timerfd,sys_timerfd,compat_sys_timerfd_wrapper)
+NI_SYSCALL						/* 317 old sys_timer_fd */
 SYSCALL(sys_eventfd,sys_eventfd,sys_eventfd_wrapper)
diff -puN arch/sparc/kernel/systbls.S~timerfd-v3-new-timerfd-api arch/sparc/kernel/systbls.S
--- a/arch/sparc/kernel/systbls.S~timerfd-v3-new-timerfd-api
+++ a/arch/sparc/kernel/systbls.S
@@ -79,7 +79,7 @@ sys_call_table:
 /*295*/	.long sys_fchmodat, sys_faccessat, sys_pselect6, sys_ppoll, sys_unshare
 /*300*/	.long sys_set_robust_list, sys_get_robust_list, sys_migrate_pages, sys_mbind, sys_get_mempolicy
 /*305*/	.long sys_set_mempolicy, sys_kexec_load, sys_move_pages, sys_getcpu, sys_epoll_pwait
-/*310*/	.long sys_utimensat, sys_signalfd, sys_timerfd, sys_eventfd, sys_fallocate
+/*310*/	.long sys_utimensat, sys_signalfd, sys_ni_syscall, sys_eventfd, sys_fallocate
 
 #ifdef CONFIG_SUNOS_EMUL
 	/* Now the SunOS syscall table. */
diff -puN arch/sparc64/kernel/systbls.S~timerfd-v3-new-timerfd-api arch/sparc64/kernel/systbls.S
--- a/arch/sparc64/kernel/systbls.S~timerfd-v3-new-timerfd-api
+++ a/arch/sparc64/kernel/systbls.S
@@ -80,7 +80,7 @@ sys_call_table32:
 	.word sys_fchmodat, sys_faccessat, compat_sys_pselect6, compat_sys_ppoll, sys_unshare
 /*300*/	.word compat_sys_set_robust_list, compat_sys_get_robust_list, compat_sys_migrate_pages, compat_sys_mbind, compat_sys_get_mempolicy
 	.word compat_sys_set_mempolicy, compat_sys_kexec_load, compat_sys_move_pages, sys_getcpu, compat_sys_epoll_pwait
-/*310*/	.word compat_sys_utimensat, compat_sys_signalfd, compat_sys_timerfd, sys_eventfd, compat_sys_fallocate
+/*310*/	.word compat_sys_utimensat, compat_sys_signalfd, sys_ni_syscall, sys_eventfd, compat_sys_fallocate
 
 #endif /* CONFIG_COMPAT */
 
@@ -152,7 +152,7 @@ sys_call_table:
 	.word sys_fchmodat, sys_faccessat, sys_pselect6, sys_ppoll, sys_unshare
 /*300*/	.word sys_set_robust_list, sys_get_robust_list, sys_migrate_pages, sys_mbind, sys_get_mempolicy
 	.word sys_set_mempolicy, sys_kexec_load, sys_move_pages, sys_getcpu, sys_epoll_pwait
-/*310*/	.word sys_utimensat, sys_signalfd, sys_timerfd, sys_eventfd, sys_fallocate
+/*310*/	.word sys_utimensat, sys_signalfd, sys_ni_syscall, sys_eventfd, sys_fallocate
 
 #if defined(CONFIG_SUNOS_EMUL) || defined(CONFIG_SOLARIS_EMUL) || \
     defined(CONFIG_SOLARIS_EMUL_MODULE)
diff -puN fs/compat.c~timerfd-v3-new-timerfd-api fs/compat.c
--- a/fs/compat.c~timerfd-v3-new-timerfd-api
+++ a/fs/compat.c
@@ -2206,19 +2206,41 @@ asmlinkage long compat_sys_signalfd(int 
 
 #ifdef CONFIG_TIMERFD
 
-asmlinkage long compat_sys_timerfd(int ufd, int clockid, int flags,
-				   const struct compat_itimerspec __user *utmr)
+asmlinkage long compat_sys_timerfd_settime(int ufd, int flags,
+				   const struct compat_itimerspec __user *utmr,
+				   struct compat_itimerspec __user *otmr)
 {
+	int error;
 	struct itimerspec t;
 	struct itimerspec __user *ut;
 
 	if (get_compat_itimerspec(&t, utmr))
 		return -EFAULT;
-	ut = compat_alloc_user_space(sizeof(*ut));
-	if (copy_to_user(ut, &t, sizeof(t)))
+	ut = compat_alloc_user_space(2 * sizeof(struct itimerspec));
+	if (copy_to_user(&ut[0], &t, sizeof(t)))
 		return -EFAULT;
+	error = sys_timerfd_settime(ufd, flags, &ut[0], &ut[1]);
+	if (!error && otmr)
+		error = (copy_from_user(&t, &ut[1], sizeof(struct itimerspec)) ||
+			 put_compat_itimerspec(otmr, &t)) ? -EFAULT: 0;
 
-	return sys_timerfd(ufd, clockid, flags, ut);
+	return error;
+}
+
+asmlinkage long compat_sys_timerfd_gettime(int ufd,
+				   struct compat_itimerspec __user *otmr)
+{
+	int error;
+	struct itimerspec t;
+	struct itimerspec __user *ut;
+
+	ut = compat_alloc_user_space(sizeof(struct itimerspec));
+	error = sys_timerfd_gettime(ufd, ut);
+	if (!error)
+		error = (copy_from_user(&t, ut, sizeof(struct itimerspec)) ||
+			 put_compat_itimerspec(otmr, &t)) ? -EFAULT: 0;
+
+	return error;
 }
 
 #endif /* CONFIG_TIMERFD */
diff -puN fs/timerfd.c~timerfd-v3-new-timerfd-api fs/timerfd.c
--- a/fs/timerfd.c~timerfd-v3-new-timerfd-api
+++ a/fs/timerfd.c
@@ -25,13 +25,15 @@ struct timerfd_ctx {
 	struct hrtimer tmr;
 	ktime_t tintv;
 	wait_queue_head_t wqh;
+	u64 ticks;
 	int expired;
+	int clockid;
 };
 
 /*
  * This gets called when the timer event triggers. We set the "expired"
  * flag, but we do not re-arm the timer (in case it's necessary,
- * tintv.tv64 != 0) until the timer is read.
+ * tintv.tv64 != 0) until the timer is accessed.
  */
 static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
 {
@@ -40,13 +42,24 @@ static enum hrtimer_restart timerfd_tmrp
 
 	spin_lock_irqsave(&ctx->wqh.lock, flags);
 	ctx->expired = 1;
+	ctx->ticks++;
 	wake_up_locked(&ctx->wqh);
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return HRTIMER_NORESTART;
 }
 
-static void timerfd_setup(struct timerfd_ctx *ctx, int clockid, int flags,
+static ktime_t timerfd_get_remaining(struct timerfd_ctx *ctx)
+{
+	ktime_t now, remaining;
+
+	now = ctx->tmr.base->get_time();
+	remaining = ktime_sub(ctx->tmr.expires, now);
+
+	return remaining.tv64 < 0 ? ktime_set(0, 0): remaining;
+}
+
+static void timerfd_setup(struct timerfd_ctx *ctx, int flags,
 			  const struct itimerspec *ktmr)
 {
 	enum hrtimer_mode htmode;
@@ -57,8 +70,9 @@ static void timerfd_setup(struct timerfd
 
 	texp = timespec_to_ktime(ktmr->it_value);
 	ctx->expired = 0;
+	ctx->ticks = 0;
 	ctx->tintv = timespec_to_ktime(ktmr->it_interval);
-	hrtimer_init(&ctx->tmr, clockid, htmode);
+	hrtimer_init(&ctx->tmr, ctx->clockid, htmode);
 	ctx->tmr.expires = texp;
 	ctx->tmr.function = timerfd_tmrproc;
 	if (texp.tv64 != 0)
@@ -83,7 +97,7 @@ static unsigned int timerfd_poll(struct 
 	poll_wait(file, &ctx->wqh, wait);
 
 	spin_lock_irqsave(&ctx->wqh.lock, flags);
-	if (ctx->expired)
+	if (ctx->ticks)
 		events |= POLLIN;
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
@@ -102,11 +116,11 @@ static ssize_t timerfd_read(struct file 
 		return -EINVAL;
 	spin_lock_irq(&ctx->wqh.lock);
 	res = -EAGAIN;
-	if (!ctx->expired && !(file->f_flags & O_NONBLOCK)) {
+	if (!ctx->ticks && !(file->f_flags & O_NONBLOCK)) {
 		__add_wait_queue(&ctx->wqh, &wait);
 		for (res = 0;;) {
 			set_current_state(TASK_INTERRUPTIBLE);
-			if (ctx->expired) {
+			if (ctx->ticks) {
 				res = 0;
 				break;
 			}
@@ -121,22 +135,21 @@ static ssize_t timerfd_read(struct file 
 		__remove_wait_queue(&ctx->wqh, &wait);
 		__set_current_state(TASK_RUNNING);
 	}
-	if (ctx->expired) {
-		ctx->expired = 0;
-		if (ctx->tintv.tv64 != 0) {
+	if (ctx->ticks) {
+		ticks = ctx->ticks;
+		if (ctx->expired && ctx->tintv.tv64) {
 			/*
 			 * If tintv.tv64 != 0, this is a periodic timer that
 			 * needs to be re-armed. We avoid doing it in the timer
 			 * callback to avoid DoS attacks specifying a very
 			 * short timer period.
 			 */
-			ticks = (u64)
-				hrtimer_forward(&ctx->tmr,
-						hrtimer_cb_get_time(&ctx->tmr),
-						ctx->tintv);
+			ticks += hrtimer_forward_now(&ctx->tmr,
+						     ctx->tintv) - 1;
 			hrtimer_restart(&ctx->tmr);
-		} else
-			ticks = 1;
+		}
+		ctx->expired = 0;
+		ctx->ticks = 0;
 	}
 	spin_unlock_irq(&ctx->wqh.lock);
 	if (ticks)
@@ -150,76 +163,132 @@ static const struct file_operations time
 	.read		= timerfd_read,
 };
 
-asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
-			    const struct itimerspec __user *utmr)
+static struct file *timerfd_fget(int fd)
+{
+	struct file *file;
+
+	file = fget(fd);
+	if (!file)
+		return ERR_PTR(-EBADF);
+	if (file->f_op != &timerfd_fops) {
+		fput(file);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return file;
+}
+
+asmlinkage long sys_timerfd_create(int clockid, int flags)
 {
-	int error;
+	int error, ufd;
 	struct timerfd_ctx *ctx;
 	struct file *file;
 	struct inode *inode;
-	struct itimerspec ktmr;
-
-	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
-		return -EFAULT;
 
+	if (flags)
+		return -EINVAL;
 	if (clockid != CLOCK_MONOTONIC &&
 	    clockid != CLOCK_REALTIME)
 		return -EINVAL;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	init_waitqueue_head(&ctx->wqh);
+	ctx->clockid = clockid;
+	hrtimer_init(&ctx->tmr, clockid, HRTIMER_MODE_ABS);
+
+	error = anon_inode_getfd(&ufd, &inode, &file, "[timerfd]",
+				 &timerfd_fops, ctx);
+	if (error) {
+		kfree(ctx);
+		return error;
+	}
+
+	return ufd;
+}
+
+asmlinkage long sys_timerfd_settime(int ufd, int flags,
+				    const struct itimerspec __user *utmr,
+				    struct itimerspec __user *otmr)
+{
+	struct file *file;
+	struct timerfd_ctx *ctx;
+	struct itimerspec ktmr, kotmr;
+
+	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
+		return -EFAULT;
+
 	if (!timespec_valid(&ktmr.it_value) ||
 	    !timespec_valid(&ktmr.it_interval))
 		return -EINVAL;
 
-	if (ufd == -1) {
-		ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
-		if (!ctx)
-			return -ENOMEM;
-
-		init_waitqueue_head(&ctx->wqh);
-
-		timerfd_setup(ctx, clockid, flags, &ktmr);
-
-		/*
-		 * When we call this, the initialization must be complete, since
-		 * anon_inode_getfd() will install the fd.
-		 */
-		error = anon_inode_getfd(&ufd, &inode, &file, "[timerfd]",
-					 &timerfd_fops, ctx);
-		if (error)
-			goto err_tmrcancel;
-	} else {
-		file = fget(ufd);
-		if (!file)
-			return -EBADF;
-		ctx = file->private_data;
-		if (file->f_op != &timerfd_fops) {
-			fput(file);
-			return -EINVAL;
-		}
-		/*
-		 * We need to stop the existing timer before reprogramming
-		 * it to the new values.
-		 */
-		for (;;) {
-			spin_lock_irq(&ctx->wqh.lock);
-			if (hrtimer_try_to_cancel(&ctx->tmr) >= 0)
-				break;
-			spin_unlock_irq(&ctx->wqh.lock);
-			cpu_relax();
-		}
-		/*
-		 * Re-program the timer to the new value ...
-		 */
-		timerfd_setup(ctx, clockid, flags, &ktmr);
-
+	file = timerfd_fget(ufd);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+	ctx = file->private_data;
+
+	/*
+	 * We need to stop the existing timer before reprogramming
+	 * it to the new values.
+	 */
+	for (;;) {
+		spin_lock_irq(&ctx->wqh.lock);
+		if (hrtimer_try_to_cancel(&ctx->tmr) >= 0)
+			break;
 		spin_unlock_irq(&ctx->wqh.lock);
-		fput(file);
+		cpu_relax();
 	}
 
-	return ufd;
+	/*
+	 * If the timer is expired and it's periodic, we need to advance it
+	 * because the caller may want to know the previous expiration time.
+	 * We do not update "ticks" and "expired" since the timer will be
+	 * re-programmed again in the following timerfd_setup() call.
+	 */
+	if (ctx->expired && ctx->tintv.tv64)
+		hrtimer_forward_now(&ctx->tmr, ctx->tintv);
+
+	kotmr.it_value = ktime_to_timespec(timerfd_get_remaining(ctx));
+	kotmr.it_interval = ktime_to_timespec(ctx->tintv);
+
+	/*
+	 * Re-program the timer to the new value ...
+	 */
+	timerfd_setup(ctx, flags, &ktmr);
 
-err_tmrcancel:
-	hrtimer_cancel(&ctx->tmr);
-	kfree(ctx);
-	return error;
+	spin_unlock_irq(&ctx->wqh.lock);
+	fput(file);
+	if (otmr && copy_to_user(otmr, &kotmr, sizeof(kotmr)))
+		return -EFAULT;
+
+	return 0;
+}
+
+asmlinkage long sys_timerfd_gettime(int ufd, struct itimerspec __user *otmr)
+{
+	struct file *file;
+	struct timerfd_ctx *ctx;
+	struct itimerspec kotmr;
+
+	file = timerfd_fget(ufd);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+	ctx = file->private_data;
+
+	spin_lock_irq(&ctx->wqh.lock);
+	if (ctx->expired && ctx->tintv.tv64) {
+		ctx->expired = 0;
+		ctx->ticks +=
+			hrtimer_forward_now(&ctx->tmr, ctx->tintv) - 1;
+		hrtimer_restart(&ctx->tmr);
+	}
+	kotmr.it_value = ktime_to_timespec(timerfd_get_remaining(ctx));
+	kotmr.it_interval = ktime_to_timespec(ctx->tintv);
+	spin_unlock_irq(&ctx->wqh.lock);
+	fput(file);
+
+	return copy_to_user(otmr, &kotmr, sizeof(kotmr)) ? -EFAULT: 0;
 }
 
diff -puN include/asm-powerpc/systbl.h~timerfd-v3-new-timerfd-api include/asm-powerpc/systbl.h
--- a/include/asm-powerpc/systbl.h~timerfd-v3-new-timerfd-api
+++ a/include/asm-powerpc/systbl.h
@@ -309,7 +309,7 @@ SYSCALL_SPU(getcpu)
 COMPAT_SYS(epoll_pwait)
 COMPAT_SYS_SPU(utimensat)
 COMPAT_SYS_SPU(signalfd)
-COMPAT_SYS_SPU(timerfd)
+SYSCALL(ni_syscall)
 SYSCALL_SPU(eventfd)
 COMPAT_SYS_SPU(sync_file_range2)
 COMPAT_SYS(fallocate)
diff -puN include/linux/compat.h~timerfd-v3-new-timerfd-api include/linux/compat.h
--- a/include/linux/compat.h~timerfd-v3-new-timerfd-api
+++ a/include/linux/compat.h
@@ -279,8 +279,11 @@ asmlinkage long compat_sys_utimensat(uns
 asmlinkage long compat_sys_signalfd(int ufd,
 				const compat_sigset_t __user *sigmask,
                                 compat_size_t sigsetsize);
-asmlinkage long compat_sys_timerfd(int ufd, int clockid, int flags,
-				const struct compat_itimerspec __user *utmr);
+asmlinkage long compat_sys_timerfd_settime(int ufd, int flags,
+				   const struct compat_itimerspec __user *utmr,
+				   struct compat_itimerspec __user *otmr);
+asmlinkage long compat_sys_timerfd_gettime(int ufd,
+				   struct compat_itimerspec __user *otmr);
 
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
diff -puN include/linux/hrtimer.h~timerfd-v3-new-timerfd-api include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~timerfd-v3-new-timerfd-api
+++ a/include/linux/hrtimer.h
@@ -301,12 +301,12 @@ static inline int hrtimer_is_queued(stru
 }
 
 /* Forward a hrtimer so it expires after now: */
-extern unsigned long
+extern u64
 hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval);
 
 /* Forward a hrtimer so it expires after the hrtimer's current now */
-static inline unsigned long hrtimer_forward_now(struct hrtimer *timer,
-						ktime_t interval)
+static inline u64 hrtimer_forward_now(struct hrtimer *timer,
+				      ktime_t interval)
 {
 	return hrtimer_forward(timer, timer->base->get_time(), interval);
 }
@@ -329,9 +329,9 @@ extern void hrtimer_run_pending(void);
 extern void __init hrtimers_init(void);
 
 #if BITS_PER_LONG < 64
-extern unsigned long ktime_divns(const ktime_t kt, s64 div);
+extern u64 ktime_divns(const ktime_t kt, s64 div);
 #else /* BITS_PER_LONG < 64 */
-# define ktime_divns(kt, div)		(unsigned long)((kt).tv64 / (div))
+# define ktime_divns(kt, div)		(u64)((kt).tv64 / (div))
 #endif
 
 /* Show pending timers: */
diff -puN include/linux/syscalls.h~timerfd-v3-new-timerfd-api include/linux/syscalls.h
--- a/include/linux/syscalls.h~timerfd-v3-new-timerfd-api
+++ a/include/linux/syscalls.h
@@ -607,8 +607,11 @@ asmlinkage long sys_set_robust_list(stru
 				    size_t len);
 asmlinkage long sys_getcpu(unsigned __user *cpu, unsigned __user *node, struct getcpu_cache __user *cache);
 asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemask);
-asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
-			    const struct itimerspec __user *utmr);
+asmlinkage long sys_timerfd_create(int clockid, int flags);
+asmlinkage long sys_timerfd_settime(int ufd, int flags,
+				    const struct itimerspec __user *utmr,
+				    struct itimerspec __user *otmr);
+asmlinkage long sys_timerfd_gettime(int ufd, struct itimerspec __user *otmr);
 asmlinkage long sys_eventfd(unsigned int count);
 asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
 
diff -puN kernel/hrtimer.c~timerfd-v3-new-timerfd-api kernel/hrtimer.c
--- a/kernel/hrtimer.c~timerfd-v3-new-timerfd-api
+++ a/kernel/hrtimer.c
@@ -306,7 +306,7 @@ EXPORT_SYMBOL_GPL(ktime_sub_ns);
 /*
  * Divide a ktime value by a nanosecond value
  */
-unsigned long ktime_divns(const ktime_t kt, s64 div)
+u64 ktime_divns(const ktime_t kt, s64 div)
 {
 	u64 dclc, inc, dns;
 	int sft = 0;
@@ -321,7 +321,7 @@ unsigned long ktime_divns(const ktime_t 
 	dclc >>= sft;
 	do_div(dclc, (unsigned long) div);
 
-	return (unsigned long) dclc;
+	return dclc;
 }
 #endif /* BITS_PER_LONG >= 64 */
 
@@ -656,10 +656,9 @@ void unlock_hrtimer_base(const struct hr
  * Forward the timer expiry so it will expire in the future.
  * Returns the number of overruns.
  */
-unsigned long
-hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval)
+u64 hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval)
 {
-	unsigned long orun = 1;
+	u64 orun = 1;
 	ktime_t delta;
 
 	delta = ktime_sub(now, timer->expires);
diff -puN kernel/posix-timers.c~timerfd-v3-new-timerfd-api kernel/posix-timers.c
--- a/kernel/posix-timers.c~timerfd-v3-new-timerfd-api
+++ a/kernel/posix-timers.c
@@ -256,8 +256,9 @@ static void schedule_next_timer(struct k
 	if (timr->it.real.interval.tv64 == 0)
 		return;
 
-	timr->it_overrun += hrtimer_forward(timer, timer->base->get_time(),
-					    timr->it.real.interval);
+	timr->it_overrun += (unsigned int) hrtimer_forward(timer,
+						timer->base->get_time(),
+						timr->it.real.interval);
 
 	timr->it_overrun_last = timr->it_overrun;
 	timr->it_overrun = -1;
@@ -386,7 +387,7 @@ static enum hrtimer_restart posix_timer_
 					now = ktime_add(now, kj);
 			}
 #endif
-			timr->it_overrun +=
+			timr->it_overrun += (unsigned int)
 				hrtimer_forward(timer, now,
 						timr->it.real.interval);
 			ret = HRTIMER_RESTART;
@@ -662,7 +663,7 @@ common_timer_get(struct k_itimer *timr, 
 	 */
 	if (iv.tv64 && (timr->it_requeue_pending & REQUEUE_PENDING ||
 	    (timr->it_sigev_notify & ~SIGEV_THREAD_ID) == SIGEV_NONE))
-		timr->it_overrun += hrtimer_forward(timer, now, iv);
+		timr->it_overrun += (unsigned int) hrtimer_forward(timer, now, iv);
 
 	remaining = ktime_sub(timer->expires, now);
 	/* Return 0 only, when the timer is expired and not pending */
diff -puN kernel/sys_ni.c~timerfd-v3-new-timerfd-api kernel/sys_ni.c
--- a/kernel/sys_ni.c~timerfd-v3-new-timerfd-api
+++ a/kernel/sys_ni.c
@@ -154,7 +154,10 @@ cond_syscall(sys_ioprio_get);
 
 /* New file descriptors */
 cond_syscall(sys_signalfd);
-cond_syscall(sys_timerfd);
 cond_syscall(compat_sys_signalfd);
-cond_syscall(compat_sys_timerfd);
+cond_syscall(sys_timerfd_create);
+cond_syscall(sys_timerfd_settime);
+cond_syscall(sys_timerfd_gettime);
+cond_syscall(compat_sys_timerfd_settime);
+cond_syscall(compat_sys_timerfd_gettime);
 cond_syscall(sys_eventfd);
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
timerfd-fix-remaining-architectures.patch
git-kvm.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch
fix-group-stop-with-exit-race.patch
move-the-related-code-from-exit_notify-to-exit_signals.patch
uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch
uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch
itimer_real-convert-to-use-struct-pid.patch

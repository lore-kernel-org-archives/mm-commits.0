From: akpm@linux-foundation.org
Subject: + add-epoll-compat_-code-to-fs-compatc.patch added to -mm tree
Date: Mon, 05 Mar 2007 23:03:12 -0800
Message-ID: <200703060703.l2673CL0015037@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53326 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965826AbXCFHDu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 02:03:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, davem@davemloft.net, dwmw2@infradead.org, rmk@arm.linux.org.uk, sfr@canb.auug.org.au, tony.luck@intel.com


The patch titled
     Add epoll compat_ code to fs/compat.c
has been added to the -mm tree.  Its filename is
     add-epoll-compat_-code-to-fs-compatc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add epoll compat_ code to fs/compat.c
From: Davide Libenzi <davidel@xmailserver.org>

IA64 and ARM-OABI are currently using their own version of epoll compat_
code.

An architecture needs epoll_event translation if alignof(u64) in 32 bit
mode is different from alignof(u64) in 64 bit mode.  If an architecture
needs epoll_event translation, it must define struct compat_epoll_event in
asm/compat.h and set CONFIG_HAVE_COMPAT_EPOLL_EVENT and use
compat_sys_epoll_ctl and compat_sys_epoll_wait.

All 64 bit architecture should use compat_sys_epoll_pwait.

[sfr: restructure and move to fs/compat.c, remove MIPS version
of compat_sys_epoll_pwait, use __put_user_unaligned]

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/linux32.c |   46 ----------------
 fs/compat.c                |  100 +++++++++++++++++++++++++++++++++++
 include/linux/compat.h     |   19 ++++++
 3 files changed, 119 insertions(+), 46 deletions(-)

diff -puN arch/mips/kernel/linux32.c~add-epoll-compat_-code-to-fs-compatc arch/mips/kernel/linux32.c
--- a/arch/mips/kernel/linux32.c~add-epoll-compat_-code-to-fs-compatc
+++ a/arch/mips/kernel/linux32.c
@@ -564,49 +564,3 @@ _sys32_clone(nabi_no_regargs struct pt_r
 	return do_fork(clone_flags, newsp, &regs, 0,
 	               parent_tidptr, child_tidptr);
 }
-
-/*
- * Implement the event wait interface for the eventpoll file. It is the kernel
- * part of the user space epoll_pwait(2).
- */
-asmlinkage long compat_sys_epoll_pwait(int epfd,
-	struct epoll_event __user *events, int maxevents, int timeout,
-	const compat_sigset_t __user *sigmask, size_t sigsetsize)
-{
-	int error;
-	sigset_t ksigmask, sigsaved;
-
-	/*
-	 * If the caller wants a certain signal mask to be set during the wait,
-	 * we apply it here.
-	 */
-	if (sigmask) {
-		if (sigsetsize != sizeof(sigset_t))
-			return -EINVAL;
-		if (!access_ok(VERIFY_READ, sigmask, sizeof(ksigmask)))
-			return -EFAULT;
-		if (__copy_conv_sigset_from_user(&ksigmask, sigmask))
-			return -EFAULT;
-		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
-		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
-	}
-
-	error = sys_epoll_wait(epfd, events, maxevents, timeout);
-
-	/*
-	 * If we changed the signal mask, we need to restore the original one.
-	 * In case we've got a signal while waiting, we do not restore the
-	 * signal mask yet, and we allow do_signal() to deliver the signal on
-	 * the way back to userspace, before the signal mask is restored.
-	 */
-	if (sigmask) {
-		if (error == -EINTR) {
-			memcpy(&current->saved_sigmask, &sigsaved,
-				sizeof(sigsaved));
-			set_thread_flag(TIF_RESTORE_SIGMASK);
-		} else
-			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
-	}
-
-	return error;
-}
diff -puN fs/compat.c~add-epoll-compat_-code-to-fs-compatc fs/compat.c
--- a/fs/compat.c~add-epoll-compat_-code-to-fs-compatc
+++ a/fs/compat.c
@@ -48,6 +48,7 @@
 #include <linux/highmem.h>
 #include <linux/poll.h>
 #include <linux/mm.h>
+#include <linux/eventpoll.h>
 
 #include <net/sock.h>		/* siocdevprivate_ioctl */
 
@@ -2235,3 +2236,102 @@ long asmlinkage compat_sys_nfsservctl(in
 	return sys_ni_syscall();
 }
 #endif
+
+#ifdef CONFIG_EPOLL
+
+#ifdef CONFIG_HAS_COMPAT_EPOLL_EVENT
+asmlinkage long compat_sys_epoll_ctl(int epfd, int op, int fd,
+			struct compat_epoll_event __user *event)
+{
+	long err = 0;
+	struct compat_epoll_event user;
+	struct epoll_event __user *kernel = NULL;
+
+	if (event) {
+		if (copy_from_user(&user, event, sizeof(user)))
+			return -EFAULT;
+		kernel = compat_alloc_user_space(sizeof(struct epoll_event));
+		err |= __put_user(user.events, &kernel->events);
+		err |= __put_user(user.data, &kernel->data);
+	}
+
+	return err ? err : sys_epoll_ctl(epfd, op, fd, kernel);
+}
+
+
+asmlinkage long compat_sys_epoll_wait(int epfd,
+			struct compat_epoll_event __user *events,
+			int maxevents, int timeout)
+{
+	long i, ret, err = 0;
+	struct epoll_event __user *kbuf;
+	struct epoll_event ev;
+
+	if ((maxevents <= 0) ||
+			(maxevents > (INT_MAX / sizeof(struct epoll_event))))
+		return -EINVAL;
+	kbuf = compat_alloc_user_space(sizeof(struct epoll_event) * maxevents);
+	ret = sys_epoll_wait(epfd, kbuf, maxevents, timeout);
+	for (i = 0; i < ret; i++) {
+		err |= __get_user(ev.events, &kbuf[i].events);
+		err |= __get_user(ev.data, &kbuf[i].data);
+		err |= __put_user(ev.events, &events->events);
+		err |= __put_user_unaligned(ev.data, &events->data);
+		events++;
+	}
+
+	return err ? -EFAULT: ret;
+}
+#endif	/* CONFIG_HAS_COMPAT_EPOLL_EVENT */
+
+#ifdef TIF_RESTORE_SIGMASK
+asmlinkage long compat_sys_epoll_pwait(int epfd,
+			struct compat_epoll_event __user *events,
+			int maxevents, int timeout,
+			const compat_sigset_t __user *sigmask,
+			compat_size_t sigsetsize)
+{
+	long err;
+	compat_sigset_t csigmask;
+	sigset_t ksigmask, sigsaved;
+
+	/*
+	 * If the caller wants a certain signal mask to be set during the wait,
+	 * we apply it here.
+	 */
+	if (sigmask) {
+		if (sigsetsize != sizeof(compat_sigset_t))
+			return -EINVAL;
+		if (copy_from_user(&csigmask, sigmask, sizeof(csigmask)))
+			return -EFAULT;
+		sigset_from_compat(&ksigmask, &csigmask);
+		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
+		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
+	}
+
+#ifdef CONFIG_HAS_COMPAT_EPOLL_EVENT
+	err = compat_sys_epoll_wait(epfd, events, maxevents, timeout);
+#else
+	err = sys_epoll_wait(epfd, events, maxevents, timeout);
+#endif
+
+	/*
+	 * If we changed the signal mask, we need to restore the original one.
+	 * In case we've got a signal while waiting, we do not restore the
+	 * signal mask yet, and we allow do_signal() to deliver the signal on
+	 * the way back to userspace, before the signal mask is restored.
+	 */
+	if (sigmask) {
+		if (err == -EINTR) {
+			memcpy(&current->saved_sigmask, &sigsaved,
+			       sizeof(sigsaved));
+			set_thread_flag(TIF_RESTORE_SIGMASK);
+		} else
+			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
+	}
+
+	return err;
+}
+#endif /* TIF_RESTORE_SIGMASK */
+
+#endif /* CONFIG_EPOLL */
diff -puN include/linux/compat.h~add-epoll-compat_-code-to-fs-compatc include/linux/compat.h
--- a/include/linux/compat.h~add-epoll-compat_-code-to-fs-compatc
+++ a/include/linux/compat.h
@@ -234,5 +234,24 @@ asmlinkage long compat_sys_migrate_pages
 		compat_ulong_t maxnode, const compat_ulong_t __user *old_nodes,
 		const compat_ulong_t __user *new_nodes);
 
+/*
+ * epoll (fs/eventpoll.c) compat bits follow ...
+ */
+#ifndef CONFIG_HAS_COMPAT_EPOLL_EVENT
+struct epoll_event;
+#define compat_epoll_event	epoll_event
+#else
+asmlinkage long compat_sys_epoll_ctl(int epfd, int op, int fd,
+			struct compat_epoll_event __user *event);
+asmlinkage long compat_sys_epoll_wait(int epfd,
+			struct compat_epoll_event __user *events,
+			int maxevents, int timeout);
+#endif
+asmlinkage long compat_sys_epoll_pwait(int epfd,
+			struct compat_epoll_event __user *events,
+			int maxevents, int timeout,
+			const compat_sigset_t __user *sigmask,
+			compat_size_t sigsetsize);
+
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
_

Patches currently in -mm which might be from davidel@xmailserver.org are

add-epoll-compat_-code-to-fs-compatc.patch

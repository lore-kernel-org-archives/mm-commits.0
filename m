From: akpm@linux-foundation.org
Subject: + add-epoll-compat-code-to-kernel-compatc-tidy.patch added to -mm tree
Date: Mon, 12 Feb 2007 22:17:54 -0800
Message-ID: <200702130617.l1D6Hs6J023697@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56100 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161097AbXBMGR4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 01:17:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davidel@xmailserver.org


The patch titled
     add-epoll-compat-code-to-kernel-compatc-tidy
has been added to the -mm tree.  Its filename is
     add-epoll-compat-code-to-kernel-compatc-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add-epoll-compat-code-to-kernel-compatc-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c         |    6 ++-
 include/linux/compat.h |   26 +++++++++-------
 kernel/compat.c        |   61 +++++++++++++++++++++------------------
 3 files changed, 52 insertions(+), 41 deletions(-)

diff -puN fs/eventpoll.c~add-epoll-compat-code-to-kernel-compatc-tidy fs/eventpoll.c
--- a/fs/eventpoll.c~add-epoll-compat-code-to-kernel-compatc-tidy
+++ a/fs/eventpoll.c
@@ -544,7 +544,8 @@ eexit_1:
  * file descriptors inside the interest set.  It represents
  * the kernel part of the user space epoll_ctl(2).
  */
-asmlinkage long sys_epoll_ctl(int epfd, int op, int fd, struct epoll_event __user *event)
+asmlinkage long sys_epoll_ctl(int epfd, int op, int fd,
+				struct epoll_event __user *event)
 {
 	int error;
 	struct file *file, *tfile;
@@ -706,7 +707,8 @@ eexit_1:
  * part of the user space epoll_pwait(2).
  */
 asmlinkage long sys_epoll_pwait(int epfd, struct epoll_event __user *events,
-				int maxevents, int timeout, const sigset_t __user *sigmask,
+				int maxevents, int timeout,
+				const sigset_t __user *sigmask,
 				size_t sigsetsize)
 {
 	int error;
diff -puN include/linux/compat.h~add-epoll-compat-code-to-kernel-compatc-tidy include/linux/compat.h
--- a/include/linux/compat.h~add-epoll-compat-code-to-kernel-compatc-tidy
+++ a/include/linux/compat.h
@@ -245,9 +245,11 @@ struct compat_epoll_event {
 };
 
 asmlinkage long compat_sys_epoll_ctl(int epfd, int op, int fd,
-				     struct compat_epoll_event __user *event);
-asmlinkage long compat_sys_epoll_wait(int epfd, struct compat_epoll_event __user *events,
-				      int maxevents, int timeout);
+				struct compat_epoll_event __user *event);
+asmlinkage long compat_sys_epoll_wait(int epfd,
+				struct compat_epoll_event __user *events,
+				int maxevents, int timeout);
+
 /*
  * Architectures that does not need "struct epoll_event" translation
  * should wire compat_sys_epoll_pwait. The ones that needs "struct epoll_event"
@@ -255,14 +257,16 @@ asmlinkage long compat_sys_epoll_wait(in
  * "struct epoll_event" translation is alignof(u64) in 32 bits mode is 4, and
  * alignof(u64) in 64 bits mode is 8.
  */
-asmlinkage long compat_sys_epoll_pwait(int epfd, struct epoll_event __user *events,
-				       int maxevents, int timeout,
-				       const compat_sigset_t __user *sigmask,
-				       compat_size_t sigsetsize);
-asmlinkage long compat_sys_epoll_pwait2(int epfd, struct compat_epoll_event __user *events,
-					int maxevents, int timeout,
-					const compat_sigset_t __user *sigmask,
-					compat_size_t sigsetsize);
+asmlinkage long compat_sys_epoll_pwait(int epfd,
+				struct epoll_event __user *events,
+				int maxevents, int timeout,
+				const compat_sigset_t __user *sigmask,
+				compat_size_t sigsetsize);
+asmlinkage long compat_sys_epoll_pwait2(int epfd,
+				struct compat_epoll_event __user *events,
+				int maxevents, int timeout,
+				const compat_sigset_t __user *sigmask,
+				compat_size_t sigsetsize);
 
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
diff -puN kernel/compat.c~add-epoll-compat-code-to-kernel-compatc-tidy kernel/compat.c
--- a/kernel/compat.c~add-epoll-compat-code-to-kernel-compatc-tidy
+++ a/kernel/compat.c
@@ -1021,8 +1021,7 @@ asmlinkage long compat_sys_migrate_pages
 #ifdef CONFIG_EPOLL
 
 /*
-
- epoll (fs/eventpoll.c) compat functions follow ...
+ * epoll (fs/eventpoll.c) compat functions follow ...
  */
 
 asmlinkage long compat_sys_epoll_ctl(int epfd, int op, int fd,
@@ -1050,8 +1049,9 @@ asmlinkage long compat_sys_epoll_ctl(int
 }
 
 
-asmlinkage long compat_sys_epoll_wait(int epfd, struct compat_epoll_event __user *events,
-				      int maxevents, int timeout)
+asmlinkage long compat_sys_epoll_wait(int epfd,
+				struct compat_epoll_event __user *events,
+				int maxevents, int timeout)
 {
 	long i, ret, err = 0;
 	struct epoll_event __user *kbuf;
@@ -1061,9 +1061,11 @@ asmlinkage long compat_sys_epoll_wait(in
 		u32 d[2];
 	} mux;
 
-	if (maxevents <= 0 || maxevents > (INT_MAX / sizeof(struct epoll_event)))
+		if (maxevents <= 0 || maxevents > (INT_MAX /
+						sizeof(struct epoll_event)))
 		return -EINVAL;
-	kbuf = compat_alloc_user_space(sizeof(struct epoll_event) * maxevents);
+		kbuf = compat_alloc_user_space(sizeof(struct epoll_event) *
+						maxevents);
 	ret = sys_epoll_wait(epfd, kbuf, maxevents, timeout);
 	for (i = 0; i < ret; i++) {
 		err |= __get_user(ev.events, &kbuf[i].events);
@@ -1082,9 +1084,9 @@ asmlinkage long compat_sys_epoll_wait(in
 #ifdef TIF_RESTORE_SIGMASK
 
 static long __sys_epoll_pwait(int epfd, void __user *events, int maxevents,
-			      int timeout, const compat_sigset_t __user *sigmask,
-			      compat_size_t sigsetsize,
-			      long (asmlinkage *proc)(int, void __user *, int, int))
+			int timeout, const compat_sigset_t __user *sigmask,
+			compat_size_t sigsetsize,
+			long (asmlinkage *proc)(int, void __user *, int, int))
 {
 	long err;
 	compat_sigset_t ss32;
@@ -1109,8 +1111,8 @@ static long __sys_epoll_pwait(int epfd, 
 	/*
 	 * If we changed the signal mask, we need to restore the original one.
 	 * In case we've got a signal while waiting, we do not restore the
-	 * signal mask yet, and we allow do_signal() to deliver the signal on the way
-	 * back to userspace, before the signal mask is restored.
+	 * signal mask yet, and we allow do_signal() to deliver the signal on
+	 * the way back to userspace, before the signal mask is restored.
 	 */
 	if (sigmask) {
 		if (err == -EINTR) {
@@ -1124,7 +1126,6 @@ static long __sys_epoll_pwait(int epfd, 
 	return err;
 }
 
-
 /*
  * Architectures that does not need "struct epoll_event" translation
  * should wire compat_sys_epoll_pwait. The ones that needs "struct epoll_event"
@@ -1132,28 +1133,33 @@ static long __sys_epoll_pwait(int epfd, 
  * "struct epoll_event" translation is alignof(u64) in 32 bits mode is 4, and
  * alignof(u64) in 64 bits mode is 8.
  */
-asmlinkage long compat_sys_epoll_pwait(int epfd, struct epoll_event __user *events,
-				       int maxevents, int timeout,
-				       const compat_sigset_t __user *sigmask,
-				       compat_size_t sigsetsize)
+asmlinkage long compat_sys_epoll_pwait(int epfd,
+				struct epoll_event __user *events,
+				int maxevents, int timeout,
+				const compat_sigset_t __user *sigmask,
+				compat_size_t sigsetsize)
 {
-	return __sys_epoll_pwait(epfd, events, maxevents, timeout, sigmask, sigsetsize,
-				 (long (asmlinkage *)(int, void __user *, int, int)) sys_epoll_wait);
+	return __sys_epoll_pwait(epfd, events, maxevents, timeout, sigmask,
+			sigsetsize,
+			(long (asmlinkage *)(int, void __user *, int, int))
+				sys_epoll_wait);
 }
 
 
-asmlinkage long compat_sys_epoll_pwait2(int epfd, struct compat_epoll_event __user *events,
-				       int maxevents, int timeout,
-				       const compat_sigset_t __user *sigmask,
-				       compat_size_t sigsetsize)
+asmlinkage long compat_sys_epoll_pwait2(int epfd,
+				struct compat_epoll_event __user *events,
+				int maxevents, int timeout,
+				const compat_sigset_t __user *sigmask,
+				compat_size_t sigsetsize)
 {
-	return __sys_epoll_pwait(epfd, events, maxevents, timeout, sigmask, sigsetsize,
-				 (long (asmlinkage *)(int, void __user *, int, int)) compat_sys_epoll_wait);
+	return __sys_epoll_pwait(epfd, events, maxevents, timeout, sigmask,
+			sigsetsize,
+			(long (asmlinkage *)(int, void __user *, int, int))
+				compat_sys_epoll_wait);
 }
 
-#endif /* #ifdef TIF_RESTORE_SIGMASK */
-
-#endif /* #ifdef CONFIG_EPOLL */
+#endif /* TIF_RESTORE_SIGMASK */
+#endif /* CONFIG_EPOLL */
 
 struct compat_sysinfo {
 	s32 uptime;
@@ -1219,4 +1225,3 @@ compat_sys_sysinfo(struct compat_sysinfo
 
 	return 0;
 }
-
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-acpi-fixup.patch
git-agpgart.patch
git-arm.patch
git-cifs-fix.patch
git-cpufreq.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
git-infiniband.patch
sis-warning-fixes.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-backlight.patch
git-backlight-sony-fix.patch
git-nfs-fixup.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-unionfs-fixup.patch
git-watchdog.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
revert-x86_64-mm-putreg-check.patch
git-gccbug-fixup.patch

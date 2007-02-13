From: akpm@linux-foundation.org
Subject: + add-epoll-compat-code-to-kernel-compatc-tidy.patch added to -mm tree
Date: Mon, 12 Feb 2007 22:09:33 -0800
Message-ID: <200702130609.l1D69X0U023504@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55935 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbXBMGJf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 01:09:35 -0500
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
 include/linux/compat.h |   14 ++++----
 kernel/compat.c        |   67 +++++++++++++++++++++------------------
 3 files changed, 49 insertions(+), 38 deletions(-)

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
@@ -244,12 +244,14 @@ struct compat_epoll_event {
 
 asmlinkage long compat_sys_epoll_ctl(int epfd, int op, int fd,
 				     struct compat_epoll_event __user *event);
-asmlinkage long compat_sys_epoll_wait(int epfd, struct compat_epoll_event __user *events,
-				      int maxevents, int timeout);
-asmlinkage long compat_sys_epoll_pwait(int epfd, struct compat_epoll_event __user *events,
-				       int maxevents, int timeout,
-				       const compat_sigset_t __user *sigmask,
-				       compat_size_t sigsetsize);
+asmlinkage long compat_sys_epoll_wait(int epfd,
+				struct compat_epoll_event __user *events,
+				int maxevents, int timeout);
+asmlinkage long compat_sys_epoll_pwait(int epfd,
+				struct compat_epoll_event __user *events,
+				int maxevents, int timeout,
+				const compat_sigset_t __user *sigmask,
+				compat_size_t sigsetsize);
 
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
diff -puN kernel/compat.c~add-epoll-compat-code-to-kernel-compatc-tidy kernel/compat.c
--- a/kernel/compat.c~add-epoll-compat-code-to-kernel-compatc-tidy
+++ a/kernel/compat.c
@@ -1025,8 +1025,8 @@ asmlinkage long compat_sys_migrate_pages
  *
  *
  * We need the compat layer over the epoll_event structure, only if the offset
- * of the __u64 data member is not 4 (size of the events member that precedes the
- * data one).
+ * of the __u64 data member is not 4 (size of the events member that precedes
+ * the data one).
  */
 #define EPOLL_NEED_EVENT_COMPAT() (offsetof(struct epoll_event, data) != 4)
 
@@ -1037,12 +1037,13 @@ asmlinkage long compat_sys_epoll_ctl(int
 	long ret;
 
 	/*
-	 * If compat is not needed, this simply map to a jump to sys_epoll_ctl(),
-	 * with the "else" code being dropped by GCC.
+	 * If compat is not needed, this simply map to a jump to
+	 * sys_epoll_ctl(), with the "else" code being dropped by GCC.
 	 */
-	if (!EPOLL_NEED_EVENT_COMPAT() || op == EPOLL_CTL_DEL)
-		ret = sys_epoll_ctl(epfd, op, fd, (struct epoll_event __user *) event);
-	else {
+	if (!EPOLL_NEED_EVENT_COMPAT() || op == EPOLL_CTL_DEL) {
+		ret = sys_epoll_ctl(epfd, op, fd,
+					(struct epoll_event __user *) event);
+	} else {
 		struct compat_epoll_event user;
 		struct epoll_event __user *kernel;
 		union {
@@ -1069,20 +1070,23 @@ asmlinkage long compat_sys_epoll_ctl(int
 }
 
 
-asmlinkage long compat_sys_epoll_wait(int epfd, struct compat_epoll_event __user *events,
-				      int maxevents, int timeout)
+asmlinkage long compat_sys_epoll_wait(int epfd,
+				struct compat_epoll_event __user *events,
+				int maxevents, int timeout)
 {
 	long ret;
 
 	/*
-	 * The compat_sys_epoll_pwait() function is calling this one. We do need a
-	 * compat function for sys_epoll_pwait() due to the sigset_t size, but not
-	 * every architecture might need a compat layer over sys_epoll_wait().
-	 * With the compile-time test below, a call to compat_sys_epoll_wait() that does
-	 * not need a translation, will map directly to sys_epoll_wait() avoiding the
-	 * double buffer copy for events (that might indeed blow cache and kill
-	 * performance). GCC takes care of removing the unused code (being the condition
-	 * known at compile-time), and issues a simple jump to sys_epoll_wait().
+	 * The compat_sys_epoll_pwait() function is calling this one. We do need
+	 * a compat function for sys_epoll_pwait() due to the sigset_t size, but
+	 * not every architecture might need a compat layer over
+	 * sys_epoll_wait().
+	 * With the compile-time test below, a call to compat_sys_epoll_wait()
+	 * that does not need a translation, will map directly to
+	 * sys_epoll_wait() avoiding the double buffer copy for events (that
+	 * might indeed blow cache and kill performance). GCC takes care of
+	 * removing the unused code (being the condition known at compile-time),
+	 * and issues a simple jump to sys_epoll_wait().
 	 */
 	if (EPOLL_NEED_EVENT_COMPAT()) {
 		struct epoll_event __user *kbuf;
@@ -1093,9 +1097,11 @@ asmlinkage long compat_sys_epoll_wait(in
 			u32 d[2];
 		} mux;
 
-		if (maxevents <= 0 || maxevents > (INT_MAX / sizeof(struct epoll_event)))
+		if (maxevents <= 0 || maxevents > (INT_MAX /
+						sizeof(struct epoll_event)))
 			return -EINVAL;
-		kbuf = compat_alloc_user_space(sizeof(struct epoll_event) * maxevents);
+		kbuf = compat_alloc_user_space(sizeof(struct epoll_event) *
+						maxevents);
 		ret = sys_epoll_wait(epfd, kbuf, maxevents, timeout);
 		err = 0;
 		for (i = 0; i < ret; i++) {
@@ -1118,10 +1124,11 @@ asmlinkage long compat_sys_epoll_wait(in
 
 #ifdef TIF_RESTORE_SIGMASK
 
-asmlinkage long compat_sys_epoll_pwait(int epfd, struct compat_epoll_event __user *events,
-				       int maxevents, int timeout,
-				       const compat_sigset_t __user *sigmask,
-				       compat_size_t sigsetsize)
+asmlinkage long compat_sys_epoll_pwait(int epfd,
+				struct compat_epoll_event __user *events,
+				int maxevents, int timeout,
+				const compat_sigset_t __user *sigmask,
+				compat_size_t sigsetsize)
 {
 	int error;
 	compat_sigset_t ss32;
@@ -1145,14 +1152,15 @@ asmlinkage long compat_sys_epoll_pwait(i
 	if (EPOLL_NEED_EVENT_COMPAT())
 		error = compat_sys_epoll_wait(epfd, events, maxevents, timeout);
 	else
-		error = sys_epoll_wait(epfd, (struct epoll_event __user *) events,
-				       maxevents, timeout);
+		error = sys_epoll_wait(epfd,
+					(struct epoll_event __user *)events,
+					maxevents, timeout);
 
 	/*
 	 * If we changed the signal mask, we need to restore the original one.
 	 * In case we've got a signal while waiting, we do not restore the
-	 * signal mask yet, and we allow do_signal() to deliver the signal on the way
-	 * back to userspace, before the signal mask is restored.
+	 * signal mask yet, and we allow do_signal() to deliver the signal on
+	 * the way back to userspace, before the signal mask is restored.
 	 */
 	if (sigmask) {
 		if (error == -EINTR) {
@@ -1166,9 +1174,8 @@ asmlinkage long compat_sys_epoll_pwait(i
 	return error;
 }
 
-#endif /* #ifdef TIF_RESTORE_SIGMASK */
-
-#endif /* #ifdef CONFIG_EPOLL */
+#endif /* TIF_RESTORE_SIGMASK */
+#endif /* CONFIG_EPOLL */
 
 struct compat_sysinfo {
 	s32 uptime;
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

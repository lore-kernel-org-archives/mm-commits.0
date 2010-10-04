From: akpm@linux-foundation.org
Subject: + ptrace-change-signature-of-sys_ptrace-and-friends.patch added to -mm tree
Date: Mon, 04 Oct 2010 16:41:31 -0700
Message-ID: <201010042341.o94NfVbs022690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756923Ab0JDXmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 19:42:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, arnd@arndb.de, roland@redhat.com


The patch titled
     ptrace: change signature of sys_ptrace() and friends
has been added to the -mm tree.  Its filename is
     ptrace-change-signature-of-sys_ptrace-and-friends.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: change signature of sys_ptrace() and friends
From: Namhyung Kim <namhyung@gmail.com>

Since userspace API of ptrace syscall defines @addr and @data as void
pointers, it would be more appropriate to define them as unsigned long in
kernel.  Therefore related functions are changed also.

'unsigned long' is typically used in other places in kernel as an opaque
data type and that using this helps cleaning up a lot of warnings from
sparse.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h   |    9 ++++++---
 include/linux/syscalls.h |    3 ++-
 kernel/ptrace.c          |   16 ++++++++++------
 3 files changed, 18 insertions(+), 10 deletions(-)

diff -puN include/linux/ptrace.h~ptrace-change-signature-of-sys_ptrace-and-friends include/linux/ptrace.h
--- a/include/linux/ptrace.h~ptrace-change-signature-of-sys_ptrace-and-friends
+++ a/include/linux/ptrace.h
@@ -108,7 +108,8 @@ extern int ptrace_attach(struct task_str
 extern int ptrace_detach(struct task_struct *, unsigned int);
 extern void ptrace_disable(struct task_struct *);
 extern int ptrace_check_attach(struct task_struct *task, int kill);
-extern int ptrace_request(struct task_struct *child, long request, long addr, long data);
+extern int ptrace_request(struct task_struct *child, long request,
+			  unsigned long addr, unsigned long data);
 extern void ptrace_notify(int exit_code);
 extern void __ptrace_link(struct task_struct *child,
 			  struct task_struct *new_parent);
@@ -132,8 +133,10 @@ static inline void ptrace_unlink(struct 
 		__ptrace_unlink(child);
 }
 
-int generic_ptrace_peekdata(struct task_struct *tsk, long addr, long data);
-int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data);
+int generic_ptrace_peekdata(struct task_struct *tsk, unsigned long addr,
+			    unsigned long data);
+int generic_ptrace_pokedata(struct task_struct *tsk, unsigned long addr,
+			    unsigned long data);
 
 /**
  * task_ptrace - return %PT_* flags that apply to a task
diff -puN include/linux/syscalls.h~ptrace-change-signature-of-sys_ptrace-and-friends include/linux/syscalls.h
--- a/include/linux/syscalls.h~ptrace-change-signature-of-sys_ptrace-and-friends
+++ a/include/linux/syscalls.h
@@ -701,7 +701,8 @@ asmlinkage long sys_nfsservctl(int cmd,
 asmlinkage long sys_syslog(int type, char __user *buf, int len);
 asmlinkage long sys_uselib(const char __user *library);
 asmlinkage long sys_ni_syscall(void);
-asmlinkage long sys_ptrace(long request, long pid, long addr, long data);
+asmlinkage long sys_ptrace(long request, long pid, unsigned long addr,
+			   unsigned long data);
 
 asmlinkage long sys_add_key(const char __user *_type,
 			    const char __user *_description,
diff -puN kernel/ptrace.c~ptrace-change-signature-of-sys_ptrace-and-friends kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-change-signature-of-sys_ptrace-and-friends
+++ a/kernel/ptrace.c
@@ -404,7 +404,7 @@ int ptrace_writedata(struct task_struct 
 	return copied;
 }
 
-static int ptrace_setoptions(struct task_struct *child, long data)
+static int ptrace_setoptions(struct task_struct *child, unsigned long data)
 {
 	child->ptrace &= ~PT_TRACE_MASK;
 
@@ -483,7 +483,8 @@ static int ptrace_setsiginfo(struct task
 #define is_sysemu_singlestep(request)	0
 #endif
 
-static int ptrace_resume(struct task_struct *child, long request, long data)
+static int ptrace_resume(struct task_struct *child, long request,
+			 unsigned long data)
 {
 	if (!valid_signal(data))
 		return -EIO;
@@ -560,7 +561,7 @@ static int ptrace_regset(struct task_str
 #endif
 
 int ptrace_request(struct task_struct *child, long request,
-		   long addr, long data)
+		   unsigned long addr, unsigned long data)
 {
 	int ret = -EIO;
 	siginfo_t siginfo;
@@ -693,7 +694,8 @@ static struct task_struct *ptrace_get_ta
 #define arch_ptrace_attach(child)	do { } while (0)
 #endif
 
-SYSCALL_DEFINE4(ptrace, long, request, long, pid, long, addr, long, data)
+SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsigned long, addr,
+		unsigned long, data)
 {
 	struct task_struct *child;
 	long ret;
@@ -734,7 +736,8 @@ SYSCALL_DEFINE4(ptrace, long, request, l
 	return ret;
 }
 
-int generic_ptrace_peekdata(struct task_struct *tsk, long addr, long data)
+int generic_ptrace_peekdata(struct task_struct *tsk, unsigned long addr,
+			    unsigned long data)
 {
 	unsigned long tmp;
 	int copied;
@@ -745,7 +748,8 @@ int generic_ptrace_peekdata(struct task_
 	return put_user(tmp, (unsigned long __user *)data);
 }
 
-int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data)
+int generic_ptrace_pokedata(struct task_struct *tsk, unsigned long addr,
+			    unsigned long data)
 {
 	int copied;
 
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch
linux-next.patch
vfs-remove-a-warning-on-open_fmode.patch
vfs-add-__fmode_exec.patch
mm-cleanup-gfp_zone-fix-sparse-warnings.patch
init-mark-__user-address-space-on-string-literals.patch
kernel-userc-add-lock-release-annotation-on-free_user.patch
printk-fixup-declaration-of-kmsg_reasons.patch
printk-add-lock-context-annotation.patch
printk-change-type-of-boot_delay-to-int.patch
printk-declare-printk_ratelimit_state-in-ratelimith.patch
printk-declare-printk_ratelimit_state-in-ratelimith-fix.patch
ptrace-annotate-lock-context-change-on-exit_ptrace.patch
signals-annotate-lock_task_sighand.patch
signals-annotate-lock-context-change-on-ptrace_stop.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch
ptrace-change-signature-of-sys_ptrace-and-friends.patch
ptrace-cleanup-ptrace_request.patch
ptrace-change-signature-of-arch_ptrace.patch
ptrace-cleanup-arch_ptrace-on-x86.patch
ptrace-cleanup-arch_ptrace-on-arm.patch
ptrace-cleanup-arch_ptrace-on-avr32.patch
ptrace-cleanup-arch_ptrace-and-friends-on-blackfin.patch
ptrace-cleanup-arch_ptrace-on-cris.patch
ptrace-cleanup-arch_ptrace-on-frv.patch
ptrace-cleanup-arch_ptrace-on-h8300.patch
ptrace-cleanup-arch_ptrace-on-m32r.patch
ptrace-cleanup-arch_ptrace-on-m68k.patch
ptrace-cleanup-arch_ptrace-on-microblaze.patch
ptrace-cleanup-arch_ptrace-on-mips.patch
ptrace-cleanup-arch_ptrace-on-mn10300.patch
ptrace-cleanup-arch_ptrace-on-parisc.patch
ptrace-cleanup-arch_ptrace-on-powerpc.patch
ptrace-cleanup-arch_ptrace-on-score.patch
ptrace-cleanup-arch_ptrace-on-sh.patch
ptrace-cleanup-arch_ptrace-on-sparc.patch
ptrace-cleanup-arch_ptrace-on-tile.patch
ptrace-cleanup-arch_ptrace-on-um.patch
ptrace-cleanup-arch_ptrace-on-xtensa.patch


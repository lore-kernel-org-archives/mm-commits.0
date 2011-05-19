From: akpm@linux-foundation.org
Subject: + include-linux-compath-coding-style-fixes.patch added to -mm tree
Date: Thu, 19 May 2011 15:28:27 -0700
Message-ID: <201105192228.p4JMSRWN031938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754087Ab1ESW2a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 May 2011 18:28:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cmetcalf@tilera.com


The patch titled
     include/linux/compat.h: coding-style fixes
has been added to the -mm tree.  Its filename is
     include-linux-compath-coding-style-fixes.patch

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
Subject: include/linux/compat.h: coding-style fixes
From: Chris Metcalf <cmetcalf@tilera.com>

I touched this file when adding support for the "tilegx" sub-architecture,
and Andrew Morton observed "The file's a mismash of old-style, wrong-style
and right-style.  There's no point in doing mishmash preservation!  May as
well fix things up when we touch them."

Accordingly, this change makes <linux/compat.h> as checkpatch-clean as
possible.  It makes no semantic changes whatsoever.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h |   51 ++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff -puN include/linux/compat.h~include-linux-compath-coding-style-fixes include/linux/compat.h
--- a/include/linux/compat.h~include-linux-compath-coding-style-fixes
+++ a/include/linux/compat.h
@@ -27,7 +27,7 @@ typedef __compat_gid32_t	compat_gid_t;
 struct compat_sel_arg_struct;
 struct rusage;
 
-struct compat_itimerspec { 
+struct compat_itimerspec {
 	struct compat_timespec it_interval;
 	struct compat_timespec it_value;
 };
@@ -71,9 +71,9 @@ struct compat_timex {
 	compat_long_t stbcnt;
 	compat_int_t tai;
 
-	compat_int_t :32; compat_int_t :32; compat_int_t :32; compat_int_t :32;
-	compat_int_t :32; compat_int_t :32; compat_int_t :32; compat_int_t :32;
-	compat_int_t :32; compat_int_t :32; compat_int_t :32;
+	compat_int_t:32; compat_int_t:32; compat_int_t:32; compat_int_t:32;
+	compat_int_t:32; compat_int_t:32; compat_int_t:32; compat_int_t:32;
+	compat_int_t:32; compat_int_t:32; compat_int_t:32;
 };
 
 #define _COMPAT_NSIG_WORDS	(_COMPAT_NSIG / _COMPAT_NSIG_BPW)
@@ -82,8 +82,10 @@ typedef struct {
 	compat_sigset_word	sig[_COMPAT_NSIG_WORDS];
 } compat_sigset_t;
 
-extern int get_compat_timespec(struct timespec *, const struct compat_timespec __user *);
-extern int put_compat_timespec(const struct timespec *, struct compat_timespec __user *);
+extern int get_compat_timespec(struct timespec *,
+			       const struct compat_timespec __user *);
+extern int put_compat_timespec(const struct timespec *,
+			       struct compat_timespec __user *);
 
 struct compat_iovec {
 	compat_uptr_t	iov_base;
@@ -114,7 +116,8 @@ struct compat_rusage {
 	compat_long_t	ru_nivcsw;
 };
 
-extern int put_compat_rusage(const struct rusage *, struct compat_rusage __user *);
+extern int put_compat_rusage(const struct rusage *,
+			     struct compat_rusage __user *);
 
 struct compat_siginfo;
 
@@ -167,8 +170,7 @@ struct compat_ifmap {
 	unsigned char port;
 };
 
-struct compat_if_settings
-{
+struct compat_if_settings {
 	unsigned int type;	/* Type of physical device or protocol */
 	unsigned int size;	/* Size of the data allocated by the caller */
 	compat_uptr_t ifs_ifsu;	/* union of pointers */
@@ -196,8 +198,8 @@ struct compat_ifreq {
 };
 
 struct compat_ifconf {
-        compat_int_t	ifc_len;                        /* size of buffer       */
-        compat_caddr_t  ifcbuf;
+	compat_int_t	ifc_len;                /* size of buffer */
+	compat_caddr_t  ifcbuf;
 };
 
 struct compat_robust_list {
@@ -256,8 +258,8 @@ asmlinkage ssize_t compat_sys_pwritev(un
 		const struct compat_iovec __user *vec,
 		unsigned long vlen, u32 pos_low, u32 pos_high);
 
-int compat_do_execve(char * filename, compat_uptr_t __user *argv,
-	        compat_uptr_t __user *envp, struct pt_regs * regs);
+int compat_do_execve(char *filename, compat_uptr_t __user *argv,
+		     compat_uptr_t __user *envp, struct pt_regs *regs);
 
 asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
 		compat_ulong_t __user *outp, compat_ulong_t __user *exp,
@@ -346,14 +348,16 @@ asmlinkage long compat_sys_epoll_pwait(i
 
 asmlinkage long compat_sys_utime(const char __user *filename,
 				 struct compat_utimbuf __user *t);
-asmlinkage long compat_sys_utimensat(unsigned int dfd, const char __user *filename,
-				struct compat_timespec __user *t, int flags);
+asmlinkage long compat_sys_utimensat(unsigned int dfd,
+				     const char __user *filename,
+				     struct compat_timespec __user *t,
+				     int flags);
 
 asmlinkage long compat_sys_time(compat_time_t __user *tloc);
 asmlinkage long compat_sys_stime(compat_time_t __user *tptr);
 asmlinkage long compat_sys_signalfd(int ufd,
-				const compat_sigset_t __user *sigmask,
-                                compat_size_t sigsetsize);
+				    const compat_sigset_t __user *sigmask,
+				    compat_size_t sigsetsize);
 asmlinkage long compat_sys_timerfd_settime(int ufd, int flags,
 				   const struct compat_itimerspec __user *utmr,
 				   struct compat_itimerspec __user *otmr);
@@ -365,7 +369,8 @@ asmlinkage long compat_sys_move_pages(pi
 				      const int __user *nodes,
 				      int __user *status,
 				      int flags);
-asmlinkage long compat_sys_futimesat(unsigned int dfd, const char __user *filename,
+asmlinkage long compat_sys_futimesat(unsigned int dfd,
+				     const char __user *filename,
 				     struct compat_timeval __user *t);
 asmlinkage long compat_sys_utimes(const char __user *filename,
 				  struct compat_timeval __user *t);
@@ -378,7 +383,7 @@ asmlinkage long compat_sys_newfstatat(un
 				      struct compat_stat __user *statbuf,
 				      int flag);
 asmlinkage long compat_sys_newfstat(unsigned int fd,
-				    struct compat_stat __user * statbuf);
+				    struct compat_stat __user *statbuf);
 asmlinkage long compat_sys_statfs(const char __user *pathname,
 				  struct compat_statfs __user *buf);
 asmlinkage long compat_sys_fstatfs(unsigned int fd,
@@ -433,14 +438,15 @@ asmlinkage long compat_sys_ppoll(struct 
 				 struct compat_timespec __user *tsp,
 				 const compat_sigset_t __user *sigmask,
 				 compat_size_t sigsetsize);
-#if (defined(CONFIG_NFSD) || defined(CONFIG_NFSD_MODULE)) && !defined(CONFIG_NFSD_DEPRECATED)
+#if (defined(CONFIG_NFSD) || defined(CONFIG_NFSD_MODULE)) && \
+	!defined(CONFIG_NFSD_DEPRECATED)
 union compat_nfsctl_res;
 struct compat_nfsctl_arg;
 asmlinkage long compat_sys_nfsservctl(int cmd,
 				      struct compat_nfsctl_arg __user *arg,
 				      union compat_nfsctl_res __user *res);
 #else
-long asmlinkage compat_sys_nfsservctl(int cmd, void *notused, void *notused2);
+asmlinkage long compat_sys_nfsservctl(int cmd, void *notused, void *notused2);
 #endif
 asmlinkage long compat_sys_signalfd4(int ufd,
 				     const compat_sigset_t __user *sigmask,
@@ -546,7 +552,8 @@ asmlinkage long compat_sys_socketcall(in
 asmlinkage long compat_sys_sysctl(struct compat_sysctl_args __user *args);
 
 extern ssize_t compat_rw_copy_check_uvector(int type,
-		const struct compat_iovec __user *uvector, unsigned long nr_segs,
+		const struct compat_iovec __user *uvector,
+		unsigned long nr_segs,
 		unsigned long fast_segs, struct iovec *fast_pointer,
 		struct iovec **ret_pointer);
 
_

Patches currently in -mm which might be from cmetcalf@tilera.com are

linux-next.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix.patch
mn10300-convert-old-cpumask-api-into-new-one.patch
lib-consolidate-debug_stack_usage-option.patch
compat-fixes-to-allow-working-with-tile-arch.patch
compat-fixes-to-allow-working-with-tile-arch-checkpatch-fixes.patch
include-linux-compath-coding-style-fixes.patch


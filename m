From: akpm@linux-foundation.org
Subject: - h8300-syscall-update.patch removed from -mm tree
Date: Fri, 11 May 2007 22:32:59 -0700
Message-ID: <200705120533.l4C5WxhK002075@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750930AbXELFdQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:33:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     h8300 syscall update
has been removed from the -mm tree.  Its filename was
     h8300-syscall-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: h8300 syscall update
From: Yoshinori Sato <ysato@users.sourceforge.jp>

h8300 systemcall entry table update.

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/syscalls.S |   78 ++++++++++++++++++++++-----------
 include/asm-h8300/unistd.h   |   66 +++++++++++++++++++++------
 2 files changed, 102 insertions(+), 42 deletions(-)

diff -puN arch/h8300/kernel/syscalls.S~h8300-syscall-update arch/h8300/kernel/syscalls.S
--- a/arch/h8300/kernel/syscalls.S~h8300-syscall-update
+++ a/arch/h8300/kernel/syscalls.S
@@ -31,7 +31,7 @@ SYMBOL_NAME_LABEL(sys_call_table)	
 	.long SYMBOL_NAME(sys_mknod)
 	.long SYMBOL_NAME(sys_chmod)		/* 15 */
 	.long SYMBOL_NAME(sys_chown16)
-	.long SYMBOL_NAME(sys_ni_syscall)				/* old break syscall holder */
+	.long SYMBOL_NAME(sys_ni_syscall)	/* old break syscall holder */
 	.long SYMBOL_NAME(sys_stat)
 	.long SYMBOL_NAME(sys_lseek)
 	.long SYMBOL_NAME(sys_getpid)		/* 20 */
@@ -45,11 +45,11 @@ SYMBOL_NAME_LABEL(sys_call_table)	
 	.long SYMBOL_NAME(sys_fstat)
 	.long SYMBOL_NAME(sys_pause)
 	.long SYMBOL_NAME(sys_utime)		/* 30 */
-	.long SYMBOL_NAME(sys_ni_syscall)				/* old stty syscall holder */
-	.long SYMBOL_NAME(sys_ni_syscall)				/* old gtty syscall holder */
+	.long SYMBOL_NAME(sys_ni_syscall)	/* old stty syscall holder */
+	.long SYMBOL_NAME(sys_ni_syscall)	/* old gtty syscall holder */
 	.long SYMBOL_NAME(sys_access)
 	.long SYMBOL_NAME(sys_nice)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* 35 */		/* old ftime syscall holder */
+	.long SYMBOL_NAME(sys_ni_syscall)	/* 35 old ftime syscall holder */
 	.long SYMBOL_NAME(sys_sync)
 	.long SYMBOL_NAME(sys_kill)
 	.long SYMBOL_NAME(sys_rename)
@@ -58,7 +58,7 @@ SYMBOL_NAME_LABEL(sys_call_table)	
 	.long SYMBOL_NAME(sys_dup)
 	.long SYMBOL_NAME(sys_pipe)
 	.long SYMBOL_NAME(sys_times)
-	.long SYMBOL_NAME(sys_ni_syscall)				/* old prof syscall holder */
+	.long SYMBOL_NAME(sys_ni_syscall)	/* old prof syscall holder */
 	.long SYMBOL_NAME(sys_brk)		/* 45 */
 	.long SYMBOL_NAME(sys_setgid16)
 	.long SYMBOL_NAME(sys_getgid16)
@@ -66,13 +66,13 @@ SYMBOL_NAME_LABEL(sys_call_table)	
 	.long SYMBOL_NAME(sys_geteuid16)
 	.long SYMBOL_NAME(sys_getegid16)	/* 50 */
 	.long SYMBOL_NAME(sys_acct)
-	.long SYMBOL_NAME(sys_umount)					/* recycled never used phys() */
-	.long SYMBOL_NAME(sys_ni_syscall)				/* old lock syscall holder */
+	.long SYMBOL_NAME(sys_umount)		/* recycled never used phys() */
+	.long SYMBOL_NAME(sys_ni_syscall)	/* old lock syscall holder */
 	.long SYMBOL_NAME(sys_ioctl)
 	.long SYMBOL_NAME(sys_fcntl)		/* 55 */
-	.long SYMBOL_NAME(sys_ni_syscall)				/* old mpx syscall holder */
+	.long SYMBOL_NAME(sys_ni_syscall)	/* old mpx syscall holder */
 	.long SYMBOL_NAME(sys_setpgid)
-	.long SYMBOL_NAME(sys_ni_syscall)				/* old ulimit syscall holder */
+	.long SYMBOL_NAME(sys_ni_syscall)	/* old ulimit syscall holder */
 	.long SYMBOL_NAME(sys_ni_syscall)
 	.long SYMBOL_NAME(sys_umask)		/* 60 */
 	.long SYMBOL_NAME(sys_chroot)
@@ -112,7 +112,7 @@ SYMBOL_NAME_LABEL(sys_call_table)	
 	.long SYMBOL_NAME(sys_fchown16)		/* 95 */
 	.long SYMBOL_NAME(sys_getpriority)
 	.long SYMBOL_NAME(sys_setpriority)
-	.long SYMBOL_NAME(sys_ni_syscall)				/* old profil syscall holder */
+	.long SYMBOL_NAME(sys_ni_syscall)	/* old profil syscall holder */
 	.long SYMBOL_NAME(sys_statfs)
 	.long SYMBOL_NAME(sys_fstatfs)		/* 100 */
 	.long SYMBOL_NAME(sys_ni_syscall)	/* ioperm for i386 */
@@ -202,8 +202,8 @@ SYMBOL_NAME_LABEL(sys_call_table)	
 	.long SYMBOL_NAME(sys_capset)           /* 185 */
 	.long SYMBOL_NAME(sys_sigaltstack)
 	.long SYMBOL_NAME(sys_sendfile)
-	.long SYMBOL_NAME(sys_ni_syscall)		/* streams1 */
-	.long SYMBOL_NAME(sys_ni_syscall)		/* streams2 */
+	.long SYMBOL_NAME(sys_ni_syscall)	/* streams1 */
+	.long SYMBOL_NAME(sys_ni_syscall)	/* streams2 */
 	.long SYMBOL_NAME(sys_vfork)            /* 190 */
 	.long SYMBOL_NAME(sys_getrlimit)
 	.long SYMBOL_NAME(sys_mmap2)
@@ -236,10 +236,10 @@ SYMBOL_NAME_LABEL(sys_call_table)	
 	.long SYMBOL_NAME(sys_ni_syscall)
 	.long SYMBOL_NAME(sys_getdents64)	/* 220 */
 	.long SYMBOL_NAME(sys_fcntl64)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* reserved for TUX */
-	.long SYMBOL_NAME(sys_ni_syscall)
+	.long SYMBOL_NAME(sys_ni_syscall)	/* reserved TUX */
+	.long SYMBOL_NAME(sys_ni_syscall)	/* reserved Security */
 	.long SYMBOL_NAME(sys_gettid)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* 225 */ /* sys_readahead */
+	.long SYMBOL_NAME(sys_readahead)	/* 225 */
 	.long SYMBOL_NAME(sys_setxattr)
 	.long SYMBOL_NAME(sys_lsetxattr)
 	.long SYMBOL_NAME(sys_fsetxattr)
@@ -257,8 +257,8 @@ SYMBOL_NAME_LABEL(sys_call_table)	
 	.long SYMBOL_NAME(sys_futex)		/* 240 */
 	.long SYMBOL_NAME(sys_sched_setaffinity)
 	.long SYMBOL_NAME(sys_sched_getaffinity)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_set_thread_area */
-	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_get_thread_area */
+	.long SYMBOL_NAME(sys_ni_syscall)
+	.long SYMBOL_NAME(sys_ni_syscall)
 	.long SYMBOL_NAME(sys_io_setup)		/* 245 */
 	.long SYMBOL_NAME(sys_io_destroy)
 	.long SYMBOL_NAME(sys_io_getevents)
@@ -288,8 +288,8 @@ SYMBOL_NAME_LABEL(sys_call_table)	
 	.long SYMBOL_NAME(sys_utimes)
  	.long SYMBOL_NAME(sys_fadvise64_64)
 	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_vserver */
-	.long SYMBOL_NAME(sys_mbind)
-	.long SYMBOL_NAME(sys_get_mempolicy)
+	.long SYMBOL_NAME(sys_ni_syscall)
+	.long SYMBOL_NAME(sys_get_mempolicy)	/* 275 */
 	.long SYMBOL_NAME(sys_set_mempolicy)
 	.long SYMBOL_NAME(sys_mq_open)
 	.long SYMBOL_NAME(sys_mq_unlink)
@@ -297,16 +297,42 @@ SYMBOL_NAME_LABEL(sys_call_table)	
 	.long SYMBOL_NAME(sys_mq_timedreceive)	/* 280 */
 	.long SYMBOL_NAME(sys_mq_notify)
 	.long SYMBOL_NAME(sys_mq_getsetattr)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* reserved for kexec */
 	.long SYMBOL_NAME(sys_waitid)
-	.long SYMBOL_NAME(sys_ni_syscall)	/* 285 */ /* available */
-	.long SYMBOL_NAME(sys_add_key)
+	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_kexec_load */
+	.long SYMBOL_NAME(sys_add_key) 		/* 285 */
 	.long SYMBOL_NAME(sys_request_key)
 	.long SYMBOL_NAME(sys_keyctl)
-
-	.rept NR_syscalls-(.-SYMBOL_NAME(sys_call_table))/4
-		.long SYMBOL_NAME(sys_ni_syscall)
-	.endr
+	.long SYMBOL_NAME(sys_ioprio_set)
+	.long SYMBOL_NAME(sys_ioprio_get)	/* 290 */
+	.long SYMBOL_NAME(sys_inotify_init)
+	.long SYMBOL_NAME(sys_inotify_add_watch)
+	.long SYMBOL_NAME(sys_inotify_rm_watch)
+	.long SYMBOL_NAME(sys_migrate_pages)
+	.long SYMBOL_NAME(sys_openat)		/* 295 */
+	.long SYMBOL_NAME(sys_mkdirat)
+	.long SYMBOL_NAME(sys_mknodat)
+	.long SYMBOL_NAME(sys_fchownat)
+	.long SYMBOL_NAME(sys_futimesat)
+	.long SYMBOL_NAME(sys_fstatat64)	/* 300 */
+	.long SYMBOL_NAME(sys_unlinkat)
+	.long SYMBOL_NAME(sys_renameat)
+	.long SYMBOL_NAME(sys_linkat)
+	.long SYMBOL_NAME(sys_symlinkat)
+	.long SYMBOL_NAME(sys_readlinkat)	/* 305 */
+	.long SYMBOL_NAME(sys_fchmodat)
+	.long SYMBOL_NAME(sys_faccessat)
+	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_pselect6 */
+	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_ppoll */
+	.long SYMBOL_NAME(sys_unshare)		/* 310 */
+	.long SYMBOL_NAME(sys_set_robust_list)
+	.long SYMBOL_NAME(sys_get_robust_list)
+	.long SYMBOL_NAME(sys_splice)
+	.long SYMBOL_NAME(sys_sync_file_range)
+	.long SYMBOL_NAME(sys_tee)		/* 315 */
+	.long SYMBOL_NAME(sys_vmsplice)
+	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_move_pages */
+	.long SYMBOL_NAME(sys_getcpu)
+	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_epoll_pwait */
 
 	.macro	call_sp addr
 	mov.l	#SYMBOL_NAME(\addr),er6
diff -puN include/asm-h8300/unistd.h~h8300-syscall-update include/asm-h8300/unistd.h
--- a/include/asm-h8300/unistd.h~h8300-syscall-update
+++ a/include/asm-h8300/unistd.h
@@ -21,7 +21,7 @@
 #define __NR_time		 13
 #define __NR_mknod		 14
 #define __NR_chmod		 15
-#define __NR_chown		 16
+#define __NR_lchown		 16
 #define __NR_break		 17
 #define __NR_oldstat		 18
 #define __NR_lseek		 19
@@ -115,10 +115,10 @@
 #define __NR_lstat		107
 #define __NR_fstat		108
 #define __NR_olduname		109
-#define __NR_iopl		/* 110 */ not supported
+#define __NR_iopl		110
 #define __NR_vhangup		111
-#define __NR_idle		/* 112 */ Obsolete
-#define __NR_vm86		/* 113 */ not supported
+#define __NR_idle		112
+#define __NR_vm86old		113
 #define __NR_wait4		114
 #define __NR_swapoff		115
 #define __NR_sysinfo		116
@@ -128,7 +128,7 @@
 #define __NR_clone		120
 #define __NR_setdomainname	121
 #define __NR_uname		122
-#define __NR_cacheflush		123
+#define __NR_modify_ldt		123
 #define __NR_adjtimex		124
 #define __NR_mprotect		125
 #define __NR_sigprocmask	126
@@ -171,7 +171,7 @@
 #define __NR_mremap		163
 #define __NR_setresuid		164
 #define __NR_getresuid		165
-#define __NR_getpagesize	166
+#define __NR_vm86		166
 #define __NR_query_module	167
 #define __NR_poll		168
 #define __NR_nfsservctl		169
@@ -187,7 +187,7 @@
 #define __NR_rt_sigsuspend	179
 #define __NR_pread64		180
 #define __NR_pwrite64		181
-#define __NR_lchown		182
+#define __NR_chown		182
 #define __NR_getcwd		183
 #define __NR_capget		184
 #define __NR_capset		185
@@ -203,7 +203,7 @@
 #define __NR_stat64		195
 #define __NR_lstat64		196
 #define __NR_fstat64		197
-#define __NR_chown32		198
+#define __NR_lchown32		198
 #define __NR_getuid32		199
 #define __NR_getgid32		200
 #define __NR_geteuid32		201
@@ -217,15 +217,18 @@
 #define __NR_getresuid32	209
 #define __NR_setresgid32	210
 #define __NR_getresgid32	211
-#define __NR_lchown32		212
+#define __NR_chown32		212
 #define __NR_setuid32		213
 #define __NR_setgid32		214
 #define __NR_setfsuid32		215
 #define __NR_setfsgid32		216
 #define __NR_pivot_root		217
+#define __NR_mincore		218
+#define __NR_madvise		219
+#define __NR_madvise1		219
 #define __NR_getdents64		220
 #define __NR_fcntl64		221
-#define __NR_security		223
+/* 223 is unused */
 #define __NR_gettid		224
 #define __NR_readahead		225
 #define __NR_setxattr		226
@@ -252,13 +255,13 @@
 #define __NR_io_getevents	247
 #define __NR_io_submit		248
 #define __NR_io_cancel		249
-#define __NR_alloc_hugepages	250
-#define __NR_free_hugepages	251
+#define __NR_fadvise64		250
+/* 251 is available for reuse (was briefly sys_set_zone_reclaim) */
 #define __NR_exit_group		252
 #define __NR_lookup_dcookie	253
-#define __NR_sys_epoll_create	254
-#define __NR_sys_epoll_ctl	255
-#define __NR_sys_epoll_wait	256
+#define __NR_epoll_create	254
+#define __NR_epoll_ctl		255
+#define __NR_epoll_wait		256
 #define __NR_remap_file_pages	257
 #define __NR_set_tid_address	258
 #define __NR_timer_create	259
@@ -291,10 +294,41 @@
 #define __NR_add_key		286
 #define __NR_request_key	287
 #define __NR_keyctl		288
+#define __NR_ioprio_set		289
+#define __NR_ioprio_get		290
+#define __NR_inotify_init	291
+#define __NR_inotify_add_watch	292
+#define __NR_inotify_rm_watch	293
+#define __NR_migrate_pages	294
+#define __NR_openat		295
+#define __NR_mkdirat		296
+#define __NR_mknodat		297
+#define __NR_fchownat		298
+#define __NR_futimesat		299
+#define __NR_fstatat64		300
+#define __NR_unlinkat		301
+#define __NR_renameat		302
+#define __NR_linkat		303
+#define __NR_symlinkat		304
+#define __NR_readlinkat		305
+#define __NR_fchmodat		306
+#define __NR_faccessat		307
+#define __NR_pselect6		308
+#define __NR_ppoll		309
+#define __NR_unshare		310
+#define __NR_set_robust_list	311
+#define __NR_get_robust_list	312
+#define __NR_splice		313
+#define __NR_sync_file_range	314
+#define __NR_tee		315
+#define __NR_vmsplice		316
+#define __NR_move_pages		317
+#define __NR_getcpu		318
+#define __NR_epoll_pwait	319
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 289
+#define NR_syscalls 320
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
_

Patches currently in -mm which might be from ysato@users.sourceforge.jp are

origin.patch

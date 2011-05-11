From: akpm@linux-foundation.org
Subject: + compat-fixes-to-allow-working-with-tile-arch.patch added to -mm tree
Date: Wed, 11 May 2011 14:17:26 -0700
Message-ID: <201105112117.p4BLHQKU026126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754026Ab1EKVSd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 May 2011 17:18:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cmetcalf@tilera.com, arnd@arndb.de, benh@kernel.crashing.org, davem@davemloft.net, jmoyer@redhat.com, johnstul@us.ibm.com, tglx@linutronix.de


The patch titled
     compat: fixes to allow working with tile arch
has been added to the -mm tree.  Its filename is
     compat-fixes-to-allow-working-with-tile-arch.patch

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
Subject: compat: fixes to allow working with tile arch
From: Chris Metcalf <cmetcalf@tilera.com>

The existing <asm-generic/unistd.h> mechanism doesn't really provide
enough to create the 64-bit "compat" ABI properly in a generic way, since
the compat ABI is a mix of things were you can re-use the 64-bit versions
of syscalls and things where you need a compat wrapper.

To provide this in the most direct way possible, I added two new macros to
go along with the existing __SYSCALL and __SC_3264 macros: __SC_COMP and
SC_COMP_3264.  These macros take an additional argument, typically a
"compat_sys_xxx" function, which is passed to __SYSCALL if you define
__SYSCALL_COMPAT when including the header, resulting in a pointer to the
compat function being placed in the generated syscall table.

The change also adds some missing definitions to <linux/compat.h> so that
it actually has declarations for all the compat syscalls, since the "[nr]
= ##call" approach requires proper C declarations for all the functions
included in the syscall table.

Finally, compat.c defines compat_sys_sigpending() and
compat_sys_sigprocmask() even if the underlying architecture doesn't
request it, which tries to pull in undefined compat_old_sigset_t defines. 
We need to guard those compat syscall definitions with appropriate
__ARCH_WANT_SYS_xxx ifdefs.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/kernel/compat.c    |    2 
 include/asm-generic/unistd.h |  221 ++++++++++++++++++---------------
 include/linux/compat.h       |  187 +++++++++++++++++++++++++++
 kernel/compat.c              |    8 +
 4 files changed, 320 insertions(+), 98 deletions(-)

diff -puN arch/tile/kernel/compat.c~compat-fixes-to-allow-working-with-tile-arch arch/tile/kernel/compat.c
--- a/arch/tile/kernel/compat.c~compat-fixes-to-allow-working-with-tile-arch
+++ a/arch/tile/kernel/compat.c
@@ -135,7 +135,7 @@ long tile_compat_sys_msgrcv(int msqid,
 
 /* Provide the compat syscall number to call mapping. */
 #undef __SYSCALL
-#define __SYSCALL(nr, call) [nr] = (compat_##call),
+#define __SYSCALL(nr, call) [nr] = (call),
 
 /* The generic versions of these don't work for Tile. */
 #define compat_sys_msgrcv tile_compat_sys_msgrcv
diff -puN include/asm-generic/unistd.h~compat-fixes-to-allow-working-with-tile-arch include/asm-generic/unistd.h
--- a/include/asm-generic/unistd.h~compat-fixes-to-allow-working-with-tile-arch
+++ a/include/asm-generic/unistd.h
@@ -24,16 +24,24 @@
 #define __SC_3264(_nr, _32, _64) __SYSCALL(_nr, _64)
 #endif
 
+#ifdef __SYSCALL_COMPAT
+#define __SC_COMP(_nr, _sys, _comp) __SYSCALL(_nr, _comp)
+#define __SC_COMP_3264(_nr, _32, _64, _comp) __SYSCALL(_nr, _comp)
+#else
+#define __SC_COMP(_nr, _sys, _comp) __SYSCALL(_nr, _sys)
+#define __SC_COMP_3264(_nr, _32, _64, _comp) __SC_3264(_nr, _32, _64)
+#endif
+
 #define __NR_io_setup 0
-__SYSCALL(__NR_io_setup, sys_io_setup)
+__SC_COMP(__NR_io_setup, sys_io_setup, compat_sys_io_setup)
 #define __NR_io_destroy 1
 __SYSCALL(__NR_io_destroy, sys_io_destroy)
 #define __NR_io_submit 2
-__SYSCALL(__NR_io_submit, sys_io_submit)
+__SC_COMP(__NR_io_submit, sys_io_submit, compat_sys_io_submit)
 #define __NR_io_cancel 3
 __SYSCALL(__NR_io_cancel, sys_io_cancel)
 #define __NR_io_getevents 4
-__SYSCALL(__NR_io_getevents, sys_io_getevents)
+__SC_COMP(__NR_io_getevents, sys_io_getevents, compat_sys_io_getevents)
 
 /* fs/xattr.c */
 #define __NR_setxattr 5
@@ -67,7 +75,7 @@ __SYSCALL(__NR_getcwd, sys_getcwd)
 
 /* fs/cookies.c */
 #define __NR_lookup_dcookie 18
-__SYSCALL(__NR_lookup_dcookie, sys_lookup_dcookie)
+__SC_COMP(__NR_lookup_dcookie, sys_lookup_dcookie, compat_sys_lookup_dcookie)
 
 /* fs/eventfd.c */
 #define __NR_eventfd2 19
@@ -79,7 +87,7 @@ __SYSCALL(__NR_epoll_create1, sys_epoll_
 #define __NR_epoll_ctl 21
 __SYSCALL(__NR_epoll_ctl, sys_epoll_ctl)
 #define __NR_epoll_pwait 22
-__SYSCALL(__NR_epoll_pwait, sys_epoll_pwait)
+__SC_COMP(__NR_epoll_pwait, sys_epoll_pwait, compat_sys_epoll_pwait)
 
 /* fs/fcntl.c */
 #define __NR_dup 23
@@ -87,7 +95,7 @@ __SYSCALL(__NR_dup, sys_dup)
 #define __NR_dup3 24
 __SYSCALL(__NR_dup3, sys_dup3)
 #define __NR3264_fcntl 25
-__SC_3264(__NR3264_fcntl, sys_fcntl64, sys_fcntl)
+__SC_COMP_3264(__NR3264_fcntl, sys_fcntl64, sys_fcntl, compat_sys_fcntl64)
 
 /* fs/inotify_user.c */
 #define __NR_inotify_init1 26
@@ -99,7 +107,7 @@ __SYSCALL(__NR_inotify_rm_watch, sys_ino
 
 /* fs/ioctl.c */
 #define __NR_ioctl 29
-__SYSCALL(__NR_ioctl, sys_ioctl)
+__SC_COMP(__NR_ioctl, sys_ioctl, compat_sys_ioctl)
 
 /* fs/ioprio.c */
 #define __NR_ioprio_set 30
@@ -129,26 +137,30 @@ __SYSCALL(__NR_renameat, sys_renameat)
 #define __NR_umount2 39
 __SYSCALL(__NR_umount2, sys_umount)
 #define __NR_mount 40
-__SYSCALL(__NR_mount, sys_mount)
+__SC_COMP(__NR_mount, sys_mount, compat_sys_mount)
 #define __NR_pivot_root 41
 __SYSCALL(__NR_pivot_root, sys_pivot_root)
 
 /* fs/nfsctl.c */
 #define __NR_nfsservctl 42
-__SYSCALL(__NR_nfsservctl, sys_nfsservctl)
+__SC_COMP(__NR_nfsservctl, sys_nfsservctl, compat_sys_nfsservctl)
 
 /* fs/open.c */
 #define __NR3264_statfs 43
-__SC_3264(__NR3264_statfs, sys_statfs64, sys_statfs)
+__SC_COMP_3264(__NR3264_statfs, sys_statfs64, sys_statfs, \
+	       compat_sys_statfs64)
 #define __NR3264_fstatfs 44
-__SC_3264(__NR3264_fstatfs, sys_fstatfs64, sys_fstatfs)
+__SC_COMP_3264(__NR3264_fstatfs, sys_fstatfs64, sys_fstatfs, \
+	       compat_sys_fstatfs64)
 #define __NR3264_truncate 45
-__SC_3264(__NR3264_truncate, sys_truncate64, sys_truncate)
+__SC_COMP_3264(__NR3264_truncate, sys_truncate64, sys_truncate, \
+	       compat_sys_truncate64)
 #define __NR3264_ftruncate 46
-__SC_3264(__NR3264_ftruncate, sys_ftruncate64, sys_ftruncate)
+__SC_COMP_3264(__NR3264_ftruncate, sys_ftruncate64, sys_ftruncate, \
+	       compat_sys_ftruncate64)
 
 #define __NR_fallocate 47
-__SYSCALL(__NR_fallocate, sys_fallocate)
+__SC_COMP(__NR_fallocate, sys_fallocate, compat_sys_fallocate)
 #define __NR_faccessat 48
 __SYSCALL(__NR_faccessat, sys_faccessat)
 #define __NR_chdir 49
@@ -166,7 +178,7 @@ __SYSCALL(__NR_fchownat, sys_fchownat)
 #define __NR_fchown 55
 __SYSCALL(__NR_fchown, sys_fchown)
 #define __NR_openat 56
-__SYSCALL(__NR_openat, sys_openat)
+__SC_COMP(__NR_openat, sys_openat, compat_sys_openat)
 #define __NR_close 57
 __SYSCALL(__NR_close, sys_close)
 #define __NR_vhangup 58
@@ -182,7 +194,7 @@ __SYSCALL(__NR_quotactl, sys_quotactl)
 
 /* fs/readdir.c */
 #define __NR_getdents64 61
-__SYSCALL(__NR_getdents64, sys_getdents64)
+__SC_COMP(__NR_getdents64, sys_getdents64, compat_sys_getdents64)
 
 /* fs/read_write.c */
 #define __NR3264_lseek 62
@@ -192,17 +204,17 @@ __SYSCALL(__NR_read, sys_read)
 #define __NR_write 64
 __SYSCALL(__NR_write, sys_write)
 #define __NR_readv 65
-__SYSCALL(__NR_readv, sys_readv)
+__SC_COMP(__NR_readv, sys_readv, compat_sys_readv)
 #define __NR_writev 66
-__SYSCALL(__NR_writev, sys_writev)
+__SC_COMP(__NR_writev, sys_writev, compat_sys_writev)
 #define __NR_pread64 67
-__SYSCALL(__NR_pread64, sys_pread64)
+__SC_COMP(__NR_pread64, sys_pread64, compat_sys_pread64)
 #define __NR_pwrite64 68
-__SYSCALL(__NR_pwrite64, sys_pwrite64)
+__SC_COMP(__NR_pwrite64, sys_pwrite64, compat_sys_pwrite64)
 #define __NR_preadv 69
-__SYSCALL(__NR_preadv, sys_preadv)
+__SC_COMP(__NR_preadv, sys_preadv, compat_sys_preadv)
 #define __NR_pwritev 70
-__SYSCALL(__NR_pwritev, sys_pwritev)
+__SC_COMP(__NR_pwritev, sys_pwritev, compat_sys_pwritev)
 
 /* fs/sendfile.c */
 #define __NR3264_sendfile 71
@@ -210,17 +222,17 @@ __SC_3264(__NR3264_sendfile, sys_sendfil
 
 /* fs/select.c */
 #define __NR_pselect6 72
-__SYSCALL(__NR_pselect6, sys_pselect6)
+__SC_COMP(__NR_pselect6, sys_pselect6, compat_sys_pselect6)
 #define __NR_ppoll 73
-__SYSCALL(__NR_ppoll, sys_ppoll)
+__SC_COMP(__NR_ppoll, sys_ppoll, compat_sys_ppoll)
 
 /* fs/signalfd.c */
 #define __NR_signalfd4 74
-__SYSCALL(__NR_signalfd4, sys_signalfd4)
+__SC_COMP(__NR_signalfd4, sys_signalfd4, compat_sys_signalfd4)
 
 /* fs/splice.c */
 #define __NR_vmsplice 75
-__SYSCALL(__NR_vmsplice, sys_vmsplice)
+__SC_COMP(__NR_vmsplice, sys_vmsplice, compat_sys_vmsplice)
 #define __NR_splice 76
 __SYSCALL(__NR_splice, sys_splice)
 #define __NR_tee 77
@@ -243,23 +255,27 @@ __SYSCALL(__NR_fsync, sys_fsync)
 __SYSCALL(__NR_fdatasync, sys_fdatasync)
 #ifdef __ARCH_WANT_SYNC_FILE_RANGE2
 #define __NR_sync_file_range2 84
-__SYSCALL(__NR_sync_file_range2, sys_sync_file_range2)
+__SC_COMP(__NR_sync_file_range2, sys_sync_file_range2, \
+	  compat_sys_sync_file_range2)
 #else
 #define __NR_sync_file_range 84
-__SYSCALL(__NR_sync_file_range, sys_sync_file_range)
+__SC_COMP(__NR_sync_file_range, sys_sync_file_range, \
+	  compat_sys_sync_file_range)
 #endif
 
 /* fs/timerfd.c */
 #define __NR_timerfd_create 85
 __SYSCALL(__NR_timerfd_create, sys_timerfd_create)
 #define __NR_timerfd_settime 86
-__SYSCALL(__NR_timerfd_settime, sys_timerfd_settime)
+__SC_COMP(__NR_timerfd_settime, sys_timerfd_settime, \
+	  compat_sys_timerfd_settime)
 #define __NR_timerfd_gettime 87
-__SYSCALL(__NR_timerfd_gettime, sys_timerfd_gettime)
+__SC_COMP(__NR_timerfd_gettime, sys_timerfd_gettime, \
+	  compat_sys_timerfd_gettime)
 
 /* fs/utimes.c */
 #define __NR_utimensat 88
-__SYSCALL(__NR_utimensat, sys_utimensat)
+__SC_COMP(__NR_utimensat, sys_utimensat, compat_sys_utimensat)
 
 /* kernel/acct.c */
 #define __NR_acct 89
@@ -281,7 +297,7 @@ __SYSCALL(__NR_exit, sys_exit)
 #define __NR_exit_group 94
 __SYSCALL(__NR_exit_group, sys_exit_group)
 #define __NR_waitid 95
-__SYSCALL(__NR_waitid, sys_waitid)
+__SC_COMP(__NR_waitid, sys_waitid, compat_sys_waitid)
 
 /* kernel/fork.c */
 #define __NR_set_tid_address 96
@@ -291,25 +307,27 @@ __SYSCALL(__NR_unshare, sys_unshare)
 
 /* kernel/futex.c */
 #define __NR_futex 98
-__SYSCALL(__NR_futex, sys_futex)
+__SC_COMP(__NR_futex, sys_futex, compat_sys_futex)
 #define __NR_set_robust_list 99
-__SYSCALL(__NR_set_robust_list, sys_set_robust_list)
+__SC_COMP(__NR_set_robust_list, sys_set_robust_list, \
+	  compat_sys_set_robust_list)
 #define __NR_get_robust_list 100
-__SYSCALL(__NR_get_robust_list, sys_get_robust_list)
+__SC_COMP(__NR_get_robust_list, sys_get_robust_list, \
+	  compat_sys_get_robust_list)
 
 /* kernel/hrtimer.c */
 #define __NR_nanosleep 101
-__SYSCALL(__NR_nanosleep, sys_nanosleep)
+__SC_COMP(__NR_nanosleep, sys_nanosleep, compat_sys_nanosleep)
 
 /* kernel/itimer.c */
 #define __NR_getitimer 102
-__SYSCALL(__NR_getitimer, sys_getitimer)
+__SC_COMP(__NR_getitimer, sys_getitimer, compat_sys_getitimer)
 #define __NR_setitimer 103
-__SYSCALL(__NR_setitimer, sys_setitimer)
+__SC_COMP(__NR_setitimer, sys_setitimer, compat_sys_setitimer)
 
 /* kernel/kexec.c */
 #define __NR_kexec_load 104
-__SYSCALL(__NR_kexec_load, sys_kexec_load)
+__SC_COMP(__NR_kexec_load, sys_kexec_load, compat_sys_kexec_load)
 
 /* kernel/module.c */
 #define __NR_init_module 105
@@ -319,23 +337,24 @@ __SYSCALL(__NR_delete_module, sys_delete
 
 /* kernel/posix-timers.c */
 #define __NR_timer_create 107
-__SYSCALL(__NR_timer_create, sys_timer_create)
+__SC_COMP(__NR_timer_create, sys_timer_create, compat_sys_timer_create)
 #define __NR_timer_gettime 108
-__SYSCALL(__NR_timer_gettime, sys_timer_gettime)
+__SC_COMP(__NR_timer_gettime, sys_timer_gettime, compat_sys_timer_gettime)
 #define __NR_timer_getoverrun 109
 __SYSCALL(__NR_timer_getoverrun, sys_timer_getoverrun)
 #define __NR_timer_settime 110
-__SYSCALL(__NR_timer_settime, sys_timer_settime)
+__SC_COMP(__NR_timer_settime, sys_timer_settime, compat_sys_timer_settime)
 #define __NR_timer_delete 111
 __SYSCALL(__NR_timer_delete, sys_timer_delete)
 #define __NR_clock_settime 112
-__SYSCALL(__NR_clock_settime, sys_clock_settime)
+__SC_COMP(__NR_clock_settime, sys_clock_settime, compat_sys_clock_settime)
 #define __NR_clock_gettime 113
-__SYSCALL(__NR_clock_gettime, sys_clock_gettime)
+__SC_COMP(__NR_clock_gettime, sys_clock_gettime, compat_sys_clock_gettime)
 #define __NR_clock_getres 114
-__SYSCALL(__NR_clock_getres, sys_clock_getres)
+__SC_COMP(__NR_clock_getres, sys_clock_getres, compat_sys_clock_getres)
 #define __NR_clock_nanosleep 115
-__SYSCALL(__NR_clock_nanosleep, sys_clock_nanosleep)
+__SC_COMP(__NR_clock_nanosleep, sys_clock_nanosleep, \
+	  compat_sys_clock_nanosleep)
 
 /* kernel/printk.c */
 #define __NR_syslog 116
@@ -355,9 +374,11 @@ __SYSCALL(__NR_sched_getscheduler, sys_s
 #define __NR_sched_getparam 121
 __SYSCALL(__NR_sched_getparam, sys_sched_getparam)
 #define __NR_sched_setaffinity 122
-__SYSCALL(__NR_sched_setaffinity, sys_sched_setaffinity)
+__SC_COMP(__NR_sched_setaffinity, sys_sched_setaffinity, \
+	  compat_sys_sched_setaffinity)
 #define __NR_sched_getaffinity 123
-__SYSCALL(__NR_sched_getaffinity, sys_sched_getaffinity)
+__SC_COMP(__NR_sched_getaffinity, sys_sched_getaffinity, \
+	  compat_sys_sched_getaffinity)
 #define __NR_sched_yield 124
 __SYSCALL(__NR_sched_yield, sys_sched_yield)
 #define __NR_sched_get_priority_max 125
@@ -365,7 +386,8 @@ __SYSCALL(__NR_sched_get_priority_max, s
 #define __NR_sched_get_priority_min 126
 __SYSCALL(__NR_sched_get_priority_min, sys_sched_get_priority_min)
 #define __NR_sched_rr_get_interval 127
-__SYSCALL(__NR_sched_rr_get_interval, sys_sched_rr_get_interval)
+__SC_COMP(__NR_sched_rr_get_interval, sys_sched_rr_get_interval, \
+	  compat_sys_sched_rr_get_interval)
 
 /* kernel/signal.c */
 #define __NR_restart_syscall 128
@@ -377,21 +399,23 @@ __SYSCALL(__NR_tkill, sys_tkill)
 #define __NR_tgkill 131
 __SYSCALL(__NR_tgkill, sys_tgkill)
 #define __NR_sigaltstack 132
-__SYSCALL(__NR_sigaltstack, sys_sigaltstack)
+__SC_COMP(__NR_sigaltstack, sys_sigaltstack, compat_sys_sigaltstack)
 #define __NR_rt_sigsuspend 133
-__SYSCALL(__NR_rt_sigsuspend, sys_rt_sigsuspend) /* __ARCH_WANT_SYS_RT_SIGSUSPEND */
+__SC_COMP(__NR_rt_sigsuspend, sys_rt_sigsuspend, compat_sys_rt_sigsuspend)
 #define __NR_rt_sigaction 134
-__SYSCALL(__NR_rt_sigaction, sys_rt_sigaction) /* __ARCH_WANT_SYS_RT_SIGACTION */
+__SC_COMP(__NR_rt_sigaction, sys_rt_sigaction, compat_sys_rt_sigaction)
 #define __NR_rt_sigprocmask 135
 __SYSCALL(__NR_rt_sigprocmask, sys_rt_sigprocmask)
 #define __NR_rt_sigpending 136
 __SYSCALL(__NR_rt_sigpending, sys_rt_sigpending)
 #define __NR_rt_sigtimedwait 137
-__SYSCALL(__NR_rt_sigtimedwait, sys_rt_sigtimedwait)
+__SC_COMP(__NR_rt_sigtimedwait, sys_rt_sigtimedwait, \
+	  compat_sys_rt_sigtimedwait)
 #define __NR_rt_sigqueueinfo 138
-__SYSCALL(__NR_rt_sigqueueinfo, sys_rt_sigqueueinfo)
+__SC_COMP(__NR_rt_sigqueueinfo, sys_rt_sigqueueinfo, \
+	  compat_sys_rt_sigqueueinfo)
 #define __NR_rt_sigreturn 139
-__SYSCALL(__NR_rt_sigreturn, sys_rt_sigreturn) /* sys_rt_sigreturn_wrapper, */
+__SC_COMP(__NR_rt_sigreturn, sys_rt_sigreturn, compat_sys_rt_sigreturn)
 
 /* kernel/sys.c */
 #define __NR_setpriority 140
@@ -421,7 +445,7 @@ __SYSCALL(__NR_setfsuid, sys_setfsuid)
 #define __NR_setfsgid 152
 __SYSCALL(__NR_setfsgid, sys_setfsgid)
 #define __NR_times 153
-__SYSCALL(__NR_times, sys_times)
+__SC_COMP(__NR_times, sys_times, compat_sys_times)
 #define __NR_setpgid 154
 __SYSCALL(__NR_setpgid, sys_setpgid)
 #define __NR_getpgid 155
@@ -441,11 +465,11 @@ __SYSCALL(__NR_sethostname, sys_sethostn
 #define __NR_setdomainname 162
 __SYSCALL(__NR_setdomainname, sys_setdomainname)
 #define __NR_getrlimit 163
-__SYSCALL(__NR_getrlimit, sys_getrlimit)
+__SC_COMP(__NR_getrlimit, sys_getrlimit, compat_sys_getrlimit)
 #define __NR_setrlimit 164
-__SYSCALL(__NR_setrlimit, sys_setrlimit)
+__SC_COMP(__NR_setrlimit, sys_setrlimit, compat_sys_setrlimit)
 #define __NR_getrusage 165
-__SYSCALL(__NR_getrusage, sys_getrusage)
+__SC_COMP(__NR_getrusage, sys_getrusage, compat_sys_getrusage)
 #define __NR_umask 166
 __SYSCALL(__NR_umask, sys_umask)
 #define __NR_prctl 167
@@ -455,11 +479,11 @@ __SYSCALL(__NR_getcpu, sys_getcpu)
 
 /* kernel/time.c */
 #define __NR_gettimeofday 169
-__SYSCALL(__NR_gettimeofday, sys_gettimeofday)
+__SC_COMP(__NR_gettimeofday, sys_gettimeofday, compat_sys_gettimeofday)
 #define __NR_settimeofday 170
-__SYSCALL(__NR_settimeofday, sys_settimeofday)
+__SC_COMP(__NR_settimeofday, sys_settimeofday, compat_sys_settimeofday)
 #define __NR_adjtimex 171
-__SYSCALL(__NR_adjtimex, sys_adjtimex)
+__SC_COMP(__NR_adjtimex, sys_adjtimex, compat_sys_adjtimex)
 
 /* kernel/timer.c */
 #define __NR_getpid 172
@@ -477,39 +501,40 @@ __SYSCALL(__NR_getegid, sys_getegid)
 #define __NR_gettid 178
 __SYSCALL(__NR_gettid, sys_gettid)
 #define __NR_sysinfo 179
-__SYSCALL(__NR_sysinfo, sys_sysinfo)
+__SC_COMP(__NR_sysinfo, sys_sysinfo, compat_sys_sysinfo)
 
 /* ipc/mqueue.c */
 #define __NR_mq_open 180
-__SYSCALL(__NR_mq_open, sys_mq_open)
+__SC_COMP(__NR_mq_open, sys_mq_open, compat_sys_mq_open)
 #define __NR_mq_unlink 181
 __SYSCALL(__NR_mq_unlink, sys_mq_unlink)
 #define __NR_mq_timedsend 182
-__SYSCALL(__NR_mq_timedsend, sys_mq_timedsend)
+__SC_COMP(__NR_mq_timedsend, sys_mq_timedsend, compat_sys_mq_timedsend)
 #define __NR_mq_timedreceive 183
-__SYSCALL(__NR_mq_timedreceive, sys_mq_timedreceive)
+__SC_COMP(__NR_mq_timedreceive, sys_mq_timedreceive, \
+	  compat_sys_mq_timedreceive)
 #define __NR_mq_notify 184
-__SYSCALL(__NR_mq_notify, sys_mq_notify)
+__SC_COMP(__NR_mq_notify, sys_mq_notify, compat_sys_mq_notify)
 #define __NR_mq_getsetattr 185
-__SYSCALL(__NR_mq_getsetattr, sys_mq_getsetattr)
+__SC_COMP(__NR_mq_getsetattr, sys_mq_getsetattr, compat_sys_mq_getsetattr)
 
 /* ipc/msg.c */
 #define __NR_msgget 186
 __SYSCALL(__NR_msgget, sys_msgget)
 #define __NR_msgctl 187
-__SYSCALL(__NR_msgctl, sys_msgctl)
+__SC_COMP(__NR_msgctl, sys_msgctl, compat_sys_msgctl)
 #define __NR_msgrcv 188
-__SYSCALL(__NR_msgrcv, sys_msgrcv)
+__SC_COMP(__NR_msgrcv, sys_msgrcv, compat_sys_msgrcv)
 #define __NR_msgsnd 189
-__SYSCALL(__NR_msgsnd, sys_msgsnd)
+__SC_COMP(__NR_msgsnd, sys_msgsnd, compat_sys_msgsnd)
 
 /* ipc/sem.c */
 #define __NR_semget 190
 __SYSCALL(__NR_semget, sys_semget)
 #define __NR_semctl 191
-__SYSCALL(__NR_semctl, sys_semctl)
+__SC_COMP(__NR_semctl, sys_semctl, compat_sys_semctl)
 #define __NR_semtimedop 192
-__SYSCALL(__NR_semtimedop, sys_semtimedop)
+__SC_COMP(__NR_semtimedop, sys_semtimedop, compat_sys_semtimedop)
 #define __NR_semop 193
 __SYSCALL(__NR_semop, sys_semop)
 
@@ -517,9 +542,9 @@ __SYSCALL(__NR_semop, sys_semop)
 #define __NR_shmget 194
 __SYSCALL(__NR_shmget, sys_shmget)
 #define __NR_shmctl 195
-__SYSCALL(__NR_shmctl, sys_shmctl)
+__SC_COMP(__NR_shmctl, sys_shmctl, compat_sys_shmctl)
 #define __NR_shmat 196
-__SYSCALL(__NR_shmat, sys_shmat)
+__SC_COMP(__NR_shmat, sys_shmat, compat_sys_shmat)
 #define __NR_shmdt 197
 __SYSCALL(__NR_shmdt, sys_shmdt)
 
@@ -543,21 +568,21 @@ __SYSCALL(__NR_getpeername, sys_getpeern
 #define __NR_sendto 206
 __SYSCALL(__NR_sendto, sys_sendto)
 #define __NR_recvfrom 207
-__SYSCALL(__NR_recvfrom, sys_recvfrom)
+__SC_COMP(__NR_recvfrom, sys_recvfrom, compat_sys_recvfrom)
 #define __NR_setsockopt 208
-__SYSCALL(__NR_setsockopt, sys_setsockopt)
+__SC_COMP(__NR_setsockopt, sys_setsockopt, compat_sys_setsockopt)
 #define __NR_getsockopt 209
-__SYSCALL(__NR_getsockopt, sys_getsockopt)
+__SC_COMP(__NR_getsockopt, sys_getsockopt, compat_sys_getsockopt)
 #define __NR_shutdown 210
 __SYSCALL(__NR_shutdown, sys_shutdown)
 #define __NR_sendmsg 211
-__SYSCALL(__NR_sendmsg, sys_sendmsg)
+__SC_COMP(__NR_sendmsg, sys_sendmsg, compat_sys_sendmsg)
 #define __NR_recvmsg 212
-__SYSCALL(__NR_recvmsg, sys_recvmsg)
+__SC_COMP(__NR_recvmsg, sys_recvmsg, compat_sys_recvmsg)
 
 /* mm/filemap.c */
 #define __NR_readahead 213
-__SYSCALL(__NR_readahead, sys_readahead)
+__SC_COMP(__NR_readahead, sys_readahead, compat_sys_readahead)
 
 /* mm/nommu.c, also with MMU */
 #define __NR_brk 214
@@ -573,19 +598,19 @@ __SYSCALL(__NR_add_key, sys_add_key)
 #define __NR_request_key 218
 __SYSCALL(__NR_request_key, sys_request_key)
 #define __NR_keyctl 219
-__SYSCALL(__NR_keyctl, sys_keyctl)
+__SC_COMP(__NR_keyctl, sys_keyctl, compat_sys_keyctl)
 
 /* arch/example/kernel/sys_example.c */
 #define __NR_clone 220
-__SYSCALL(__NR_clone, sys_clone)	/* .long sys_clone_wrapper */
+__SYSCALL(__NR_clone, sys_clone)
 #define __NR_execve 221
-__SYSCALL(__NR_execve, sys_execve)	/* .long sys_execve_wrapper */
+__SC_COMP(__NR_execve, sys_execve, compat_sys_execve)
 
 #define __NR3264_mmap 222
 __SC_3264(__NR3264_mmap, sys_mmap2, sys_mmap)
 /* mm/fadvise.c */
 #define __NR3264_fadvise64 223
-__SYSCALL(__NR3264_fadvise64, sys_fadvise64_64)
+__SC_COMP(__NR3264_fadvise64, sys_fadvise64_64, compat_sys_fadvise64_64)
 
 /* mm/, CONFIG_MMU only */
 #ifndef __ARCH_NOMMU
@@ -612,25 +637,26 @@ __SYSCALL(__NR_madvise, sys_madvise)
 #define __NR_remap_file_pages 234
 __SYSCALL(__NR_remap_file_pages, sys_remap_file_pages)
 #define __NR_mbind 235
-__SYSCALL(__NR_mbind, sys_mbind)
+__SC_COMP(__NR_mbind, sys_mbind, compat_sys_mbind)
 #define __NR_get_mempolicy 236
-__SYSCALL(__NR_get_mempolicy, sys_get_mempolicy)
+__SC_COMP(__NR_get_mempolicy, sys_get_mempolicy, compat_sys_get_mempolicy)
 #define __NR_set_mempolicy 237
-__SYSCALL(__NR_set_mempolicy, sys_set_mempolicy)
+__SC_COMP(__NR_set_mempolicy, sys_set_mempolicy, compat_sys_set_mempolicy)
 #define __NR_migrate_pages 238
-__SYSCALL(__NR_migrate_pages, sys_migrate_pages)
+__SC_COMP(__NR_migrate_pages, sys_migrate_pages, compat_sys_migrate_pages)
 #define __NR_move_pages 239
-__SYSCALL(__NR_move_pages, sys_move_pages)
+__SC_COMP(__NR_move_pages, sys_move_pages, compat_sys_move_pages)
 #endif
 
 #define __NR_rt_tgsigqueueinfo 240
-__SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
+__SC_COMP(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo, \
+	  compat_sys_rt_tgsigqueueinfo)
 #define __NR_perf_event_open 241
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
 #define __NR_accept4 242
 __SYSCALL(__NR_accept4, sys_accept4)
 #define __NR_recvmmsg 243
-__SYSCALL(__NR_recvmmsg, sys_recvmmsg)
+__SC_COMP(__NR_recvmmsg, sys_recvmmsg, compat_sys_recvmmsg)
 
 /*
  * Architectures may provide up to 16 syscalls of their own
@@ -639,19 +665,20 @@ __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
 #define __NR_arch_specific_syscall 244
 
 #define __NR_wait4 260
-__SYSCALL(__NR_wait4, sys_wait4)
+__SC_COMP(__NR_wait4, sys_wait4, compat_sys_wait4)
 #define __NR_prlimit64 261
 __SYSCALL(__NR_prlimit64, sys_prlimit64)
 #define __NR_fanotify_init 262
 __SYSCALL(__NR_fanotify_init, sys_fanotify_init)
 #define __NR_fanotify_mark 263
 __SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
-#define __NR_name_to_handle_at		264
+#define __NR_name_to_handle_at         264
 __SYSCALL(__NR_name_to_handle_at, sys_name_to_handle_at)
-#define __NR_open_by_handle_at		265
-__SYSCALL(__NR_open_by_handle_at, sys_open_by_handle_at)
+#define __NR_open_by_handle_at         265
+__SC_COMP(__NR_open_by_handle_at, sys_open_by_handle_at, \
+	  compat_sys_open_by_handle_at)
 #define __NR_clock_adjtime 266
-__SYSCALL(__NR_clock_adjtime, sys_clock_adjtime)
+__SC_COMP(__NR_clock_adjtime, sys_clock_adjtime, compat_sys_clock_adjtime)
 #define __NR_syncfs 267
 __SYSCALL(__NR_syncfs, sys_syncfs)
 
diff -puN include/linux/compat.h~compat-fixes-to-allow-working-with-tile-arch include/linux/compat.h
--- a/include/linux/compat.h~compat-fixes-to-allow-working-with-tile-arch
+++ a/include/linux/compat.h
@@ -12,6 +12,7 @@
 #include <linux/sem.h>
 #include <linux/socket.h>
 #include <linux/if.h>
+#include <linux/fs.h>
 
 #include <asm/compat.h>
 #include <asm/siginfo.h>
@@ -209,6 +210,18 @@ struct compat_robust_list_head {
 	compat_uptr_t			list_op_pending;
 };
 
+struct compat_statfs;
+struct compat_statfs64;
+struct compat_old_linux_dirent;
+struct compat_linux_dirent;
+struct linux_dirent64;
+struct compat_msghdr;
+struct compat_mmsghdr;
+struct compat_sysinfo;
+struct compat_sysctl_args;
+struct compat_kexec_segment;
+struct compat_mq_attr;
+
 extern void compat_exit_robust_list(struct task_struct *curr);
 
 asmlinkage long
@@ -331,9 +344,13 @@ asmlinkage long compat_sys_epoll_pwait(i
 			const compat_sigset_t __user *sigmask,
 			compat_size_t sigsetsize);
 
+asmlinkage long compat_sys_utime(const char __user *filename,
+				 struct compat_utimbuf __user *t);
 asmlinkage long compat_sys_utimensat(unsigned int dfd, const char __user *filename,
 				struct compat_timespec __user *t, int flags);
 
+asmlinkage long compat_sys_time(compat_time_t __user *tloc);
+asmlinkage long compat_sys_stime(compat_time_t __user *tptr);
 asmlinkage long compat_sys_signalfd(int ufd,
 				const compat_sigset_t __user *sigmask,
                                 compat_size_t sigsetsize);
@@ -350,11 +367,181 @@ asmlinkage long compat_sys_move_pages(pi
 				      int flags);
 asmlinkage long compat_sys_futimesat(unsigned int dfd, const char __user *filename,
 				     struct compat_timeval __user *t);
+asmlinkage long compat_sys_utimes(const char __user *filename,
+				  struct compat_timeval __user *t);
+asmlinkage long compat_sys_newstat(const char __user * filename,
+				   struct compat_stat __user *statbuf);
+asmlinkage long compat_sys_newlstat(const char __user * filename,
+				    struct compat_stat __user *statbuf);
 asmlinkage long compat_sys_newfstatat(unsigned int dfd, const char __user * filename,
 				      struct compat_stat __user *statbuf,
 				      int flag);
+asmlinkage long compat_sys_newfstat(unsigned int fd,
+				    struct compat_stat __user * statbuf);
+asmlinkage long compat_sys_statfs(const char __user *pathname,
+				  struct compat_statfs __user *buf);
+asmlinkage long compat_sys_fstatfs(unsigned int fd,
+				   struct compat_statfs __user *buf);
+asmlinkage long compat_sys_statfs64(const char __user *pathname,
+				    compat_size_t sz,
+				    struct compat_statfs64 __user *buf);
+asmlinkage long compat_sys_fstatfs64(unsigned int fd, compat_size_t sz,
+				     struct compat_statfs64 __user *buf);
+asmlinkage long compat_sys_fcntl64(unsigned int fd, unsigned int cmd,
+				   unsigned long arg);
+asmlinkage long compat_sys_fcntl(unsigned int fd, unsigned int cmd,
+				 unsigned long arg);
+asmlinkage long compat_sys_io_setup(unsigned nr_reqs, u32 __user *ctx32p);
+asmlinkage long compat_sys_io_getevents(aio_context_t ctx_id,
+					unsigned long min_nr,
+					unsigned long nr,
+					struct io_event __user *events,
+					struct compat_timespec __user *timeout);
+asmlinkage long compat_sys_io_submit(aio_context_t ctx_id, int nr,
+				     u32 __user *iocb);
+asmlinkage long compat_sys_mount(const char __user * dev_name,
+				 const char __user * dir_name,
+				 const char __user * type, unsigned long flags,
+				 const void __user * data);
+asmlinkage long compat_sys_old_readdir(unsigned int fd,
+				       struct compat_old_linux_dirent __user *,
+				       unsigned int count);
+asmlinkage long compat_sys_getdents(unsigned int fd,
+				    struct compat_linux_dirent __user *dirent,
+				    unsigned int count);
+asmlinkage long compat_sys_getdents64(unsigned int fd,
+				      struct linux_dirent64 __user * dirent,
+				      unsigned int count);
+asmlinkage long compat_sys_vmsplice(int fd, const struct compat_iovec __user *,
+				    unsigned int nr_segs, unsigned int flags);
+asmlinkage long compat_sys_open(const char __user *filename, int flags,
+				int mode);
 asmlinkage long compat_sys_openat(unsigned int dfd, const char __user *filename,
 				  int flags, int mode);
+asmlinkage long compat_sys_open_by_handle_at(int mountdirfd,
+                                             struct file_handle __user *handle,
+                                             int flags);
+asmlinkage long compat_sys_pselect6(int n, compat_ulong_t __user *inp,
+				    compat_ulong_t __user *outp,
+				    compat_ulong_t __user *exp,
+				    struct compat_timespec __user *tsp,
+				    void __user *sig);
+asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
+				 unsigned int nfds,
+				 struct compat_timespec __user *tsp,
+				 const compat_sigset_t __user *sigmask,
+				 compat_size_t sigsetsize);
+#if (defined(CONFIG_NFSD) || defined(CONFIG_NFSD_MODULE)) && !defined(CONFIG_NFSD_DEPRECATED)
+union compat_nfsctl_res;
+struct compat_nfsctl_arg;
+asmlinkage long compat_sys_nfsservctl(int cmd,
+				      struct compat_nfsctl_arg __user *arg,
+				      union compat_nfsctl_res __user *res);
+#else
+long asmlinkage compat_sys_nfsservctl(int cmd, void *notused, void *notused2);
+#endif
+asmlinkage long compat_sys_signalfd4(int ufd,
+				     const compat_sigset_t __user *sigmask,
+				     compat_size_t sigsetsize, int flags);
+asmlinkage long compat_sys_get_mempolicy(int __user *policy,
+					 compat_ulong_t __user *nmask,
+					 compat_ulong_t maxnode,
+					 compat_ulong_t addr,
+					 compat_ulong_t flags);
+asmlinkage long compat_sys_set_mempolicy(int mode, compat_ulong_t __user *nmask,
+					 compat_ulong_t maxnode);
+asmlinkage long compat_sys_mbind(compat_ulong_t start, compat_ulong_t len,
+				 compat_ulong_t mode,
+				 compat_ulong_t __user *nmask,
+				 compat_ulong_t maxnode, compat_ulong_t flags);
+
+asmlinkage long compat_sys_setsockopt(int fd, int level, int optname,
+				      char __user *optval, unsigned int optlen);
+asmlinkage long compat_sys_sendmsg(int fd, struct compat_msghdr __user *msg,
+				   unsigned flags);
+asmlinkage long compat_sys_recvmsg(int fd, struct compat_msghdr __user *msg,
+				   unsigned int flags);
+asmlinkage long compat_sys_recv(int fd, void __user *buf, size_t len,
+				unsigned flags);
+asmlinkage long compat_sys_recvfrom(int fd, void __user *buf, size_t len,
+			    unsigned flags, struct sockaddr __user *addr,
+			    int __user *addrlen);
+asmlinkage long compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
+				    unsigned vlen, unsigned int flags,
+				    struct compat_timespec __user *timeout);
+asmlinkage long compat_sys_nanosleep(struct compat_timespec __user *rqtp,
+				     struct compat_timespec __user *rmtp);
+asmlinkage long compat_sys_getitimer(int which,
+				     struct compat_itimerval __user *it);
+asmlinkage long compat_sys_setitimer(int which,
+				     struct compat_itimerval __user *in,
+				     struct compat_itimerval __user *out);
+asmlinkage long compat_sys_times(struct compat_tms __user *tbuf);
+asmlinkage long compat_sys_setrlimit(unsigned int resource,
+				     struct compat_rlimit __user *rlim);
+asmlinkage long compat_sys_getrlimit (unsigned int resource,
+				      struct compat_rlimit __user *rlim);
+asmlinkage long compat_sys_getrusage(int who, struct compat_rusage __user *ru);
+asmlinkage long compat_sys_sched_setaffinity(compat_pid_t pid,
+				     unsigned int len,
+				     compat_ulong_t __user *user_mask_ptr);
+asmlinkage long compat_sys_sched_getaffinity(compat_pid_t pid,
+				     unsigned int len,
+				     compat_ulong_t __user *user_mask_ptr);
+asmlinkage long compat_sys_timer_create(clockid_t which_clock,
+			struct compat_sigevent __user *timer_event_spec,
+			timer_t __user *created_timer_id);
+asmlinkage long compat_sys_timer_settime(timer_t timer_id, int flags,
+					 struct compat_itimerspec __user *new,
+					 struct compat_itimerspec __user *old);
+asmlinkage long compat_sys_timer_gettime(timer_t timer_id,
+				 struct compat_itimerspec __user *setting);
+asmlinkage long compat_sys_clock_settime(clockid_t which_clock,
+					 struct compat_timespec __user *tp);
+asmlinkage long compat_sys_clock_gettime(clockid_t which_clock,
+					 struct compat_timespec __user *tp);
+asmlinkage long compat_sys_clock_adjtime(clockid_t which_clock,
+					 struct compat_timex __user *tp);
+asmlinkage long compat_sys_clock_getres(clockid_t which_clock,
+					struct compat_timespec __user *tp);
+asmlinkage long compat_sys_clock_nanosleep(clockid_t which_clock, int flags,
+					   struct compat_timespec __user *rqtp,
+					   struct compat_timespec __user *rmtp);
+asmlinkage long compat_sys_rt_sigtimedwait (compat_sigset_t __user *uthese,
+		struct compat_siginfo __user *uinfo,
+		struct compat_timespec __user *uts, compat_size_t sigsetsize);
+asmlinkage long compat_sys_rt_sigsuspend(compat_sigset_t __user *unewset,
+					 compat_size_t sigsetsize);
+asmlinkage long compat_sys_sysinfo(struct compat_sysinfo __user *info);
+asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
+				 unsigned long arg);
+asmlinkage long compat_sys_futex(u32 __user *uaddr, int op, u32 val,
+		struct compat_timespec __user *utime, u32 __user *uaddr2,
+		u32 val3);
+asmlinkage long compat_sys_getsockopt(int fd, int level, int optname,
+				      char __user *optval, int __user *optlen);
+asmlinkage long compat_sys_kexec_load(unsigned long entry,
+				      unsigned long nr_segments,
+				      struct compat_kexec_segment __user *,
+				      unsigned long flags);
+asmlinkage long compat_sys_mq_getsetattr(mqd_t mqdes,
+			const struct compat_mq_attr __user *u_mqstat,
+			struct compat_mq_attr __user *u_omqstat);
+asmlinkage long compat_sys_mq_notify(mqd_t mqdes,
+			const struct compat_sigevent __user *u_notification);
+asmlinkage long compat_sys_mq_open(const char __user *u_name,
+			int oflag, compat_mode_t mode,
+			struct compat_mq_attr __user *u_attr);
+asmlinkage long compat_sys_mq_timedsend(mqd_t mqdes,
+			const char __user *u_msg_ptr,
+			size_t msg_len, unsigned int msg_prio,
+			const struct compat_timespec __user *u_abs_timeout);
+asmlinkage ssize_t compat_sys_mq_timedreceive(mqd_t mqdes,
+			char __user *u_msg_ptr,
+			size_t msg_len, unsigned int __user *u_msg_prio,
+			const struct compat_timespec __user *u_abs_timeout);
+asmlinkage long compat_sys_socketcall(int call, u32 __user *args);
+asmlinkage long compat_sys_sysctl(struct compat_sysctl_args __user *args);
 
 extern ssize_t compat_rw_copy_check_uvector(int type,
 		const struct compat_iovec __user *uvector, unsigned long nr_segs,
diff -puN kernel/compat.c~compat-fixes-to-allow-working-with-tile-arch kernel/compat.c
--- a/kernel/compat.c~compat-fixes-to-allow-working-with-tile-arch
+++ a/kernel/compat.c
@@ -293,6 +293,8 @@ asmlinkage long compat_sys_times(struct 
 	return compat_jiffies_to_clock_t(jiffies);
 }
 
+#ifdef __ARCH_WANT_SYS_SIGPENDING
+
 /*
  * Assumption: old_sigset_t and compat_old_sigset_t are both
  * types that can be passed to put_user()/get_user().
@@ -312,6 +314,10 @@ asmlinkage long compat_sys_sigpending(co
 	return ret;
 }
 
+#endif
+
+#ifdef __ARCH_WANT_SYS_SIGPROCMASK
+
 asmlinkage long compat_sys_sigprocmask(int how, compat_old_sigset_t __user *set,
 		compat_old_sigset_t __user *oset)
 {
@@ -333,6 +339,8 @@ asmlinkage long compat_sys_sigprocmask(i
 	return ret;
 }
 
+#endif
+
 asmlinkage long compat_sys_setrlimit(unsigned int resource,
 		struct compat_rlimit __user *rlim)
 {
_

Patches currently in -mm which might be from cmetcalf@tilera.com are

linux-next.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix.patch
mn10300-convert-old-cpumask-api-into-new-one.patch
lib-consolidate-debug_stack_usage-option.patch
compat-fixes-to-allow-working-with-tile-arch.patch


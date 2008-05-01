From: akpm@linux-foundation.org
Subject: - signals-add-set_restore_sigmask.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:13 -0700
Message-ID: <200805010927.m419RD1X030399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758590AbYEAJqi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:46:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, heiko.carstens@de.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     signals: add set_restore_sigmask
has been removed from the -mm tree.  Its filename was
     signals-add-set_restore_sigmask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: add set_restore_sigmask
From: Roland McGrath <roland@redhat.com>

This adds the set_restore_sigmask() inline in <linux/thread_info.h> and
replaces every set_thread_flag(TIF_RESTORE_SIGMASK) with a call to it.  No
change, but abstracts the details of the flag protocol from all the calls.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c                 |    6 +++---
 fs/eventpoll.c              |    3 +--
 fs/select.c                 |    4 ++--
 include/linux/thread_info.h |   15 ++++++++++++++-
 kernel/compat.c             |    3 +--
 kernel/signal.c             |    2 +-
 6 files changed, 22 insertions(+), 11 deletions(-)

diff -puN fs/compat.c~signals-add-set_restore_sigmask fs/compat.c
--- a/fs/compat.c~signals-add-set_restore_sigmask
+++ a/fs/compat.c
@@ -1720,7 +1720,7 @@ sticky:
 		if (sigmask) {
 			memcpy(&current->saved_sigmask, &sigsaved,
 					sizeof(sigsaved));
-			set_thread_flag(TIF_RESTORE_SIGMASK);
+			set_restore_sigmask();
 		}
 	} else if (sigmask)
 		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
@@ -1791,7 +1791,7 @@ asmlinkage long compat_sys_ppoll(struct 
 		if (sigmask) {
 			memcpy(&current->saved_sigmask, &sigsaved,
 				sizeof(sigsaved));
-			set_thread_flag(TIF_RESTORE_SIGMASK);
+			set_restore_sigmask();
 		}
 		ret = -ERESTARTNOHAND;
 	} else if (sigmask)
@@ -2117,7 +2117,7 @@ asmlinkage long compat_sys_epoll_pwait(i
 		if (err == -EINTR) {
 			memcpy(&current->saved_sigmask, &sigsaved,
 			       sizeof(sigsaved));
-			set_thread_flag(TIF_RESTORE_SIGMASK);
+			set_restore_sigmask();
 		} else
 			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
 	}
diff -puN fs/eventpoll.c~signals-add-set_restore_sigmask fs/eventpoll.c
--- a/fs/eventpoll.c~signals-add-set_restore_sigmask
+++ a/fs/eventpoll.c
@@ -1279,7 +1279,7 @@ asmlinkage long sys_epoll_pwait(int epfd
 		if (error == -EINTR) {
 			memcpy(&current->saved_sigmask, &sigsaved,
 			       sizeof(sigsaved));
-			set_thread_flag(TIF_RESTORE_SIGMASK);
+			set_restore_sigmask();
 		} else
 			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
 	}
@@ -1309,4 +1309,3 @@ static int __init eventpoll_init(void)
 	return 0;
 }
 fs_initcall(eventpoll_init);
-
diff -puN fs/select.c~signals-add-set_restore_sigmask fs/select.c
--- a/fs/select.c~signals-add-set_restore_sigmask
+++ a/fs/select.c
@@ -498,7 +498,7 @@ sticky:
 		if (sigmask) {
 			memcpy(&current->saved_sigmask, &sigsaved,
 					sizeof(sigsaved));
-			set_thread_flag(TIF_RESTORE_SIGMASK);
+			set_restore_sigmask();
 		}
 	} else if (sigmask)
 		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
@@ -805,7 +805,7 @@ asmlinkage long sys_ppoll(struct pollfd 
 		if (sigmask) {
 			memcpy(&current->saved_sigmask, &sigsaved,
 					sizeof(sigsaved));
-			set_thread_flag(TIF_RESTORE_SIGMASK);
+			set_restore_sigmask();
 		}
 		ret = -ERESTARTNOHAND;
 	} else if (sigmask)
diff -puN include/linux/thread_info.h~signals-add-set_restore_sigmask include/linux/thread_info.h
--- a/include/linux/thread_info.h~signals-add-set_restore_sigmask
+++ a/include/linux/thread_info.h
@@ -92,6 +92,19 @@ static inline int test_ti_thread_flag(st
 #define set_need_resched()	set_thread_flag(TIF_NEED_RESCHED)
 #define clear_need_resched()	clear_thread_flag(TIF_NEED_RESCHED)
 
-#endif
+#ifdef TIF_RESTORE_SIGMASK
+/**
+ * set_restore_sigmask() - make sure saved_sigmask processing gets done
+ *
+ * This sets TIF_RESTORE_SIGMASK and ensures that the arch signal code
+ * will run before returning to user mode, to process the flag.
+ */
+static inline void set_restore_sigmask(void)
+{
+	set_thread_flag(TIF_RESTORE_SIGMASK);
+}
+#endif	/* TIF_RESTORE_SIGMASK */
+
+#endif	/* __KERNEL__ */
 
 #endif /* _LINUX_THREAD_INFO_H */
diff -puN kernel/compat.c~signals-add-set_restore_sigmask kernel/compat.c
--- a/kernel/compat.c~signals-add-set_restore_sigmask
+++ a/kernel/compat.c
@@ -898,7 +898,7 @@ asmlinkage long compat_sys_rt_sigsuspend
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
-	set_thread_flag(TIF_RESTORE_SIGMASK);
+	set_restore_sigmask();
 	return -ERESTARTNOHAND;
 }
 #endif /* __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND */
@@ -1080,4 +1080,3 @@ compat_sys_sysinfo(struct compat_sysinfo
 
 	return 0;
 }

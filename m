From: akpm@linux-foundation.org
Subject: + container-freezer-add-tif_freeze-flag-to-all-architectures.patch added to -mm tree
Date: Tue, 12 Aug 2008 15:56:30 -0700
Message-ID: <200808122256.m7CMuUdh017879@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706AbYHLW5c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 18:57:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthltc@us.ibm.com, clg@fr.ibm.com, nigel@tuxonice.net, pavel@suse.cz, rjw@sisk.pl, serue@us.ibm.com


The patch titled
     container freezer: add TIF_FREEZE flag to all architectures
has been added to the -mm tree.  Its filename is
     container-freezer-add-tif_freeze-flag-to-all-architectures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: container freezer: add TIF_FREEZE flag to all architectures
From: Matt Helsley <matthltc@us.ibm.com>

This patch series introduces a cgroup subsystem that utilizes the swsusp
freezer to freeze a group of tasks.  It's immediately useful for batch job
management scripts.  It should also be useful in the future for
implementing container checkpoint/restart.

The freezer subsystem in the container filesystem defines a cgroup file
named freezer.state.  Reading freezer.state will return the current state
of the cgroup.  Writing "FROZEN" to the state file will freeze all tasks
in the cgroup.  Subsequently writing "RUNNING" will unfreeze the tasks in
the cgroup.  

* Examples of usage :

   # mkdir /containers/freezer
   # mount -t cgroup -ofreezer freezer  /containers
   # mkdir /containers/0
   # echo $some_pid > /containers/0/tasks

to get status of the freezer subsystem :

   # cat /containers/0/freezer.state
   RUNNING

to freeze all tasks in the container :

   # echo FROZEN > /containers/0/freezer.state
   # cat /containers/0/freezer.state
   FREEZING
   # cat /containers/0/freezer.state
   FROZEN

to unfreeze all tasks in the container :

   # echo RUNNING > /containers/0/freezer.state
   # cat /containers/0/freezer.state
   RUNNING



This patch:

The first step in making the refrigerator() available to all
architectures, even for those without power management.

The purpose of such a change is to be able to use the refrigerator() in a
new control group subsystem which will implement a control group freezer.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Acked-by: Pavel Machek <pavel@suse.cz>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Nigel Cunningham <nigel@tuxonice.net>
Tested-by: Matt Helsley <matthltc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/include/asm/thread_info.h     |    1 +
 arch/m68knommu/include/asm/thread_info.h |    2 ++
 arch/parisc/include/asm/thread_info.h    |    2 ++
 arch/s390/include/asm/thread_info.h      |    2 ++
 arch/sparc/include/asm/thread_info_32.h  |    2 ++
 arch/sparc/include/asm/thread_info_64.h  |    2 ++
 include/asm-alpha/thread_info.h          |    2 ++
 include/asm-cris/thread_info.h           |    2 ++
 include/asm-h8300/thread_info.h          |    2 ++
 include/asm-m68k/thread_info.h           |    1 +
 include/asm-um/thread_info.h             |    2 ++
 include/asm-xtensa/thread_info.h         |    2 ++
 12 files changed, 22 insertions(+)

diff -puN arch/avr32/include/asm/thread_info.h~container-freezer-add-tif_freeze-flag-to-all-architectures arch/avr32/include/asm/thread_info.h
--- a/arch/avr32/include/asm/thread_info.h~container-freezer-add-tif_freeze-flag-to-all-architectures
+++ a/arch/avr32/include/asm/thread_info.h
@@ -96,6 +96,7 @@ static inline struct thread_info *curren
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_CPU_GOING_TO_SLEEP (1 << TIF_CPU_GOING_TO_SLEEP)
+#define _TIF_FREEZE		(1 << TIF_FREEZE)
 
 /* Note: The masks below must never span more than 16 bits! */
 
diff -puN arch/m68knommu/include/asm/thread_info.h~container-freezer-add-tif_freeze-flag-to-all-architectures arch/m68knommu/include/asm/thread_info.h
--- a/arch/m68knommu/include/asm/thread_info.h~container-freezer-add-tif_freeze-flag-to-all-architectures
+++ a/arch/m68knommu/include/asm/thread_info.h
@@ -84,12 +84,14 @@ static inline struct thread_info *curren
 #define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
 #define TIF_MEMDIE		4
+#define TIF_FREEZE		16	/* is freezing for suspend */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
+#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 
diff -puN arch/parisc/include/asm/thread_info.h~container-freezer-add-tif_freeze-flag-to-all-architectures arch/parisc/include/asm/thread_info.h
--- a/arch/parisc/include/asm/thread_info.h~container-freezer-add-tif_freeze-flag-to-all-architectures
+++ a/arch/parisc/include/asm/thread_info.h
@@ -58,6 +58,7 @@ struct thread_info {
 #define TIF_32BIT               4       /* 32 bit binary */
 #define TIF_MEMDIE		5
 #define TIF_RESTORE_SIGMASK	6	/* restore saved signal mask */
+#define TIF_FREEZE		7	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -65,6 +66,7 @@ struct thread_info {
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_32BIT		(1 << TIF_32BIT)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
+#define _TIF_FREEZE		(1 << TIF_FREEZE)
 
 #define _TIF_USER_WORK_MASK     (_TIF_SIGPENDING | \
                                  _TIF_NEED_RESCHED | _TIF_RESTORE_SIGMASK)
diff -puN arch/s390/include/asm/thread_info.h~container-freezer-add-tif_freeze-flag-to-all-architectures arch/s390/include/asm/thread_info.h
--- a/arch/s390/include/asm/thread_info.h~container-freezer-add-tif_freeze-flag-to-all-architectures
+++ a/arch/s390/include/asm/thread_info.h
@@ -98,6 +98,7 @@ static inline struct thread_info *curren
 #define TIF_31BIT		18	/* 32bit process */ 
 #define TIF_MEMDIE		19
 #define TIF_RESTORE_SIGMASK	20	/* restore signal mask in do_signal() */
+#define TIF_FREEZE		21	/* thread is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
@@ -110,6 +111,7 @@ static inline struct thread_info *curren
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_31BIT		(1<<TIF_31BIT)
+#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #endif /* __KERNEL__ */
 
diff -puN arch/sparc/include/asm/thread_info_32.h~container-freezer-add-tif_freeze-flag-to-all-architectures arch/sparc/include/asm/thread_info_32.h
--- a/arch/sparc/include/asm/thread_info_32.h~container-freezer-add-tif_freeze-flag-to-all-architectures
+++ a/arch/sparc/include/asm/thread_info_32.h
@@ -139,6 +139,7 @@ BTFIXUPDEF_CALL(void, free_thread_info, 
 #define TIF_POLLING_NRFLAG	9	/* true if poll_idle() is polling
 					 * TIF_NEED_RESCHED */
 #define TIF_MEMDIE		10
+#define TIF_FREEZE		11	/* is freezing for suspend */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -152,6 +153,7 @@ BTFIXUPDEF_CALL(void, free_thread_info, 
 #define _TIF_DO_NOTIFY_RESUME_MASK	(_TIF_NOTIFY_RESUME | \
 					 _TIF_SIGPENDING | \
 					 _TIF_RESTORE_SIGMASK)
+#define TIF_FREEZE		(1<<TIF_FREEZE)
 
 #endif /* __KERNEL__ */
 
diff -puN arch/sparc/include/asm/thread_info_64.h~container-freezer-add-tif_freeze-flag-to-all-architectures arch/sparc/include/asm/thread_info_64.h
--- a/arch/sparc/include/asm/thread_info_64.h~container-freezer-add-tif_freeze-flag-to-all-architectures
+++ a/arch/sparc/include/asm/thread_info_64.h
@@ -237,6 +237,7 @@ register struct thread_info *current_thr
 #define TIF_ABI_PENDING		12
 #define TIF_MEMDIE		13
 #define TIF_POLLING_NRFLAG	14
+#define TIF_FREEZE		15	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
@@ -249,6 +250,7 @@ register struct thread_info *current_thr
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
+#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #define _TIF_USER_WORK_MASK	((0xff << TI_FLAG_WSAVED_SHIFT) | \
 				 _TIF_DO_NOTIFY_RESUME_MASK | \
diff -puN include/asm-alpha/thread_info.h~container-freezer-add-tif_freeze-flag-to-all-architectures include/asm-alpha/thread_info.h
--- a/include/asm-alpha/thread_info.h~container-freezer-add-tif_freeze-flag-to-all-architectures
+++ a/include/asm-alpha/thread_info.h
@@ -74,12 +74,14 @@ register struct thread_info *__current_t
 #define TIF_UAC_SIGBUS		7
 #define TIF_MEMDIE		8
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal */
+#define TIF_FREEZE		16	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
+#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 /* Work to do on interrupt/exception return.  */
 #define _TIF_WORK_MASK		(_TIF_SIGPENDING | _TIF_NEED_RESCHED)
diff -puN include/asm-cris/thread_info.h~container-freezer-add-tif_freeze-flag-to-all-architectures include/asm-cris/thread_info.h
--- a/include/asm-cris/thread_info.h~container-freezer-add-tif_freeze-flag-to-all-architectures
+++ a/include/asm-cris/thread_info.h
@@ -88,6 +88,7 @@ struct thread_info {
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17
+#define TIF_FREEZE		18	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
@@ -95,6 +96,7 @@ struct thread_info {
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
+#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
diff -puN include/asm-h8300/thread_info.h~container-freezer-add-tif_freeze-flag-to-all-architectures include/asm-h8300/thread_info.h
--- a/include/asm-h8300/thread_info.h~container-freezer-add-tif_freeze-flag-to-all-architectures
+++ a/include/asm-h8300/thread_info.h
@@ -89,6 +89,7 @@ static inline struct thread_info *curren
 					   TIF_NEED_RESCHED */
 #define TIF_MEMDIE		4
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
+#define TIF_FREEZE		16	/* is freezing for suspend */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -96,6 +97,7 @@ static inline struct thread_info *curren
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
+#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 
diff -puN include/asm-m68k/thread_info.h~container-freezer-add-tif_freeze-flag-to-all-architectures include/asm-m68k/thread_info.h
--- a/include/asm-m68k/thread_info.h~container-freezer-add-tif_freeze-flag-to-all-architectures
+++ a/include/asm-m68k/thread_info.h
@@ -52,5 +52,6 @@ struct thread_info {
 #define TIF_DELAYED_TRACE	14	/* single step a syscall */
 #define TIF_SYSCALL_TRACE	15	/* syscall trace active */
 #define TIF_MEMDIE		16
+#define TIF_FREEZE		17	/* thread is freezing for suspend */
 
 #endif	/* _ASM_M68K_THREAD_INFO_H */
diff -puN include/asm-um/thread_info.h~container-freezer-add-tif_freeze-flag-to-all-architectures include/asm-um/thread_info.h
--- a/include/asm-um/thread_info.h~container-freezer-add-tif_freeze-flag-to-all-architectures
+++ a/include/asm-um/thread_info.h
@@ -69,6 +69,7 @@ static inline struct thread_info *curren
 #define TIF_MEMDIE	 	5
 #define TIF_SYSCALL_AUDIT	6
 #define TIF_RESTORE_SIGMASK	7
+#define TIF_FREEZE		16	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -77,5 +78,6 @@ static inline struct thread_info *curren
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
+#define _TIF_FREEZE		(1 << TIF_FREEZE)
 
 #endif
diff -puN include/asm-xtensa/thread_info.h~container-freezer-add-tif_freeze-flag-to-all-architectures include/asm-xtensa/thread_info.h
--- a/include/asm-xtensa/thread_info.h~container-freezer-add-tif_freeze-flag-to-all-architectures
+++ a/include/asm-xtensa/thread_info.h
@@ -134,6 +134,7 @@ static inline struct thread_info *curren
 #define TIF_MEMDIE		5
 #define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
+#define TIF_FREEZE		17	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
@@ -142,6 +143,7 @@ static inline struct thread_info *curren
 #define _TIF_IRET		(1<<TIF_IRET)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
+#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
_

Patches currently in -mm which might be from matthltc@us.ibm.com are

container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-make-refrigerator-always-available.patch
container-freezer-implement-freezer-cgroup-subsystem.patch
container-freezer-skip-frozen-cgroups-during-power-management-resume.patch
container-freezer-prevent-frozen-tasks-or-cgroups-from-changing.patch


From: akpm@linux-foundation.org
Subject: - uml-simplify-interval-setting.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:38:40 -0700
Message-ID: <200710162038.l9GKcedN015469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50299 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933195AbXJPVXA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:23:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     uml: simplify interval setting
has been removed from the -mm tree.  Its filename was
     uml-simplify-interval-setting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: simplify interval setting
From: Jeff Dike <jdike@addtoit.com>

set_interval took a timer type as an argument, but it always specified a
virtual timer.  So, it is not needed, and it is gone, and set_interval is
simplified appropriately.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h            |    2 +-
 arch/um/kernel/time.c           |    2 +-
 arch/um/os-Linux/skas/process.c |    2 +-
 arch/um/os-Linux/time.c         |    5 ++---
 4 files changed, 5 insertions(+), 6 deletions(-)

diff -puN arch/um/include/os.h~uml-simplify-interval-setting arch/um/include/os.h
--- a/arch/um/include/os.h~uml-simplify-interval-setting
+++ a/arch/um/include/os.h
@@ -252,7 +252,7 @@ extern void os_dump_core(void);
 
 extern int switch_timers(int to_real);
 extern void idle_sleep(int secs);
-extern int set_interval(int is_virtual);
+extern int set_interval(void);
 extern void disable_timer(void);
 extern void uml_idle_timer(void);
 extern unsigned long long os_nsecs(void);
diff -puN arch/um/kernel/time.c~uml-simplify-interval-setting arch/um/kernel/time.c
--- a/arch/um/kernel/time.c~uml-simplify-interval-setting
+++ a/arch/um/kernel/time.c
@@ -102,7 +102,7 @@ static void register_timer(void)
 		printk(KERN_ERR "register_timer : request_irq failed - "
 		       "errno = %d\n", -err);
 
-	err = set_interval(1);
+	err = set_interval();
 	if (err != 0)
 		printk(KERN_ERR "register_timer : set_interval failed - "
 		       "errno = %d\n", -err);
diff -puN arch/um/os-Linux/skas/process.c~uml-simplify-interval-setting arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-simplify-interval-setting
+++ a/arch/um/os-Linux/skas/process.c
@@ -178,7 +178,7 @@ static int userspace_tramp(void *stack)
 	ptrace(PTRACE_TRACEME, 0, 0, 0);
 
 	init_new_thread_signals();
-	err = set_interval(1);
+	err = set_interval();
 	if (err)
 		panic("userspace_tramp - setting timer failed, errno = %d\n",
 		      err);
diff -puN arch/um/os-Linux/time.c~uml-simplify-interval-setting arch/um/os-Linux/time.c
--- a/arch/um/os-Linux/time.c~uml-simplify-interval-setting
+++ a/arch/um/os-Linux/time.c
@@ -14,14 +14,13 @@
 
 static int is_real_timer = 0;
 
-int set_interval(int is_virtual)
+int set_interval(void)
 {
 	int usec = 1000000/UM_HZ;
-	int timer_type = is_virtual ? ITIMER_VIRTUAL : ITIMER_REAL;
 	struct itimerval interval = ((struct itimerval) { { 0, usec },
 							  { 0, usec } });
 
-	if (setitimer(timer_type, &interval, NULL) == -1)
+	if (setitimer(ITIMER_VIRTUAL, &interval, NULL) == -1)
 		return -errno;
 
 	return 0;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch

From: akpm@linux-foundation.org
Subject: + whitespace-fixes-time-syscalls.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:18:36 -0700
Message-ID: <200707210018.l6L0IaMX023846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50145 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757262AbXGUAUJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:20:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     whitespace fixes: time syscalls
has been added to the -mm tree.  Its filename is
     whitespace-fixes-time-syscalls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: whitespace fixes: time syscalls
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff -puN kernel/time.c~whitespace-fixes-time-syscalls kernel/time.c
--- a/kernel/time.c~whitespace-fixes-time-syscalls
+++ a/kernel/time.c
@@ -9,9 +9,9 @@
  */
 /*
  * Modification history kernel/time.c
- * 
+ *
  * 1993-09-02    Philip Gladstone
- *      Created file with time related functions from sched.c and adjtimex() 
+ *      Created file with time related functions from sched.c and adjtimex()
  * 1993-10-08    Torsten Duwe
  *      adjtime interface update and CMOS clock write code
  * 1995-08-13    Torsten Duwe
@@ -39,7 +39,7 @@
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 
-/* 
+/*
  * The timezone where the local system is located.  Used as a default by some
  * programs who obtain this value by using gettimeofday.
  */
@@ -79,7 +79,7 @@ asmlinkage long sys_time(time_t __user *
  * why not move it into the appropriate arch directory (for those
  * architectures that need it).
  */
- 
+
 asmlinkage long sys_stime(time_t __user *tptr)
 {
 	struct timespec tv;
@@ -118,10 +118,10 @@ asmlinkage long sys_gettimeofday(struct 
 /*
  * Adjust the time obtained from the CMOS to be UTC time instead of
  * local time.
- * 
+ *
  * This is ugly, but preferable to the alternatives.  Otherwise we
  * would either need to write a program to do it in /etc/rc (and risk
- * confusion if the program gets run more than once; it would also be 
+ * confusion if the program gets run more than once; it would also be
  * hard to make the program warp the clock precisely n hours)  or
  * compile in the timezone information into the kernel.  Bad, bad....
  *
@@ -221,16 +221,16 @@ asmlinkage long sys_adjtimex(struct time
 
 inline struct timespec current_kernel_time(void)
 {
-        struct timespec now;
-        unsigned long seq;
+	struct timespec now;
+	unsigned long seq;
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-		
+
 		now = xtime;
 	} while (read_seqretry(&xtime_lock, seq));
 
-	return now; 
+	return now;
 }
 
 EXPORT_SYMBOL(current_kernel_time);
_

Patches currently in -mm which might be from dwalker@mvista.com are

whitespace-fixes-time-syscalls.patch
whitespace-fixes-process-accounting.patch
whitespace-fixes-cpuset.patch
whitespace-fixes-relayfs.patch
whitespace-fixes-audit-filtering.patch
whitespace-fixes-dma-channel-allocator.patch
whitespace-fixes-fork.patch
whitespace-fixes-module-loading.patch
whitespace-fixes-panic-handling.patch
whitespace-fixes-capability-syscalls.patch
whitespace-fixes-syscall-auditing.patch
whitespace-fixes-compat-syscalls.patch
whitespace-fixes-system-auditing.patch
whitespace-fixes-execution-domains.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch

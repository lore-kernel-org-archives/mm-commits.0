From: akpm@linux-foundation.org
Subject: - uml-time-build-fix.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:38:54 -0700
Message-ID: <200710162038.l9GKcsnc015492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57402 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936116AbXJPVHu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: time build fix
has been removed from the -mm tree.  Its filename was
     uml-time-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: time build fix
From: Jeff Dike <jdike@addtoit.com>

Put back an implementation of timeval_to_ns in arch/um/os-Linux/time.c. 
tglx pointed out in his review of tickless support that there was a
perfectly good implementation of it in linux/time.h.  The problem is that
this is userspace code which can't pull in kernel headers and there doesn't
seem to be a libc version.

So, I'm copying the version from linux/time.h rather than resurrecting my
version.  This causes some declaration changes as it now returns a signed
value rather than an unsigned value.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h    |    4 ++--
 arch/um/os-Linux/time.c |   22 +++++++++++++++++++---
 2 files changed, 21 insertions(+), 5 deletions(-)

diff -puN arch/um/include/os.h~uml-time-build-fix arch/um/include/os.h
--- a/arch/um/include/os.h~uml-time-build-fix
+++ a/arch/um/include/os.h
@@ -254,9 +254,9 @@ extern void os_dump_core(void);
 extern void idle_sleep(unsigned long long nsecs);
 extern int set_interval(void);
 extern int timer_one_shot(int ticks);
-extern unsigned long long disable_timer(void);
+extern long long disable_timer(void);
 extern void uml_idle_timer(void);
-extern unsigned long long os_nsecs(void);
+extern long long os_nsecs(void);
 
 /* skas/mem.c */
 extern long run_syscall_stub(struct mm_id * mm_idp,
diff -puN arch/um/os-Linux/time.c~uml-time-build-fix arch/um/os-Linux/time.c
--- a/arch/um/os-Linux/time.c~uml-time-build-fix
+++ a/arch/um/os-Linux/time.c
@@ -39,7 +39,23 @@ int timer_one_shot(int ticks)
 	return 0;
 }
 
-unsigned long long disable_timer(void)
+/**
+ * timeval_to_ns - Convert timeval to nanoseconds
+ * @ts:		pointer to the timeval variable to be converted
+ *
+ * Returns the scalar nanosecond representation of the timeval
+ * parameter.
+ *
+ * Ripped from linux/time.h because it's a kernel header, and thus
+ * unusable from here.
+ */
+static inline long long timeval_to_ns(const struct timeval *tv)
+{
+	return ((long long) tv->tv_sec * UM_NSEC_PER_SEC) +
+		tv->tv_usec * UM_NSEC_PER_USEC;
+}
+
+long long disable_timer(void)
 {
 	struct itimerval time = ((struct itimerval) { { 0, 0 }, { 0, 0 } });
 
@@ -47,10 +63,10 @@ unsigned long long disable_timer(void)
 		printk(UM_KERN_ERR "disable_timer - setitimer failed, "
 		       "errno = %d\n", errno);
 
-	return tv_to_nsec(&time.it_value);
+	return timeval_to_ns(&time.it_value);
 }
 
-unsigned long long os_nsecs(void)
+long long os_nsecs(void)
 {
 	struct timeval tv;
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch

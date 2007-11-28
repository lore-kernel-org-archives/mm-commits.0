From: akpm@linux-foundation.org
Subject: + uml-fix-no_hz-busy-loop.patch added to -mm tree
Date: Tue, 27 Nov 2007 16:23:22 -0800
Message-ID: <200711280023.lAS0NRW6007086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59566 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752648AbXK1AXq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 19:23:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, miklos@szeredi.hu


The patch titled
     uml: fix !NO_HZ busy-loop
has been added to the -mm tree.  Its filename is
     uml-fix-no_hz-busy-loop.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix !NO_HZ busy-loop
From: Jeff Dike <jdike@addtoit.com>

With NO_HZ disabled, the UML idle loop effectively becomes a busy loop, as
it will sleep for no time.

The cause was forgetting to restart the tick after waking up from sleep. 
It was disabled before sleeping, and the remaining time used as the
interval to sleep.  So, the tick needs to be restarted when nanosleep
finishes.

This is done by introducing after_sleep_interval, which is empty in the
NO_HZ case, but which sets the tick starting in the !NO_HZ case.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/time.c |   54 +++++++++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 3 deletions(-)

diff -puN arch/um/os-Linux/time.c~uml-fix-no_hz-busy-loop arch/um/os-Linux/time.c
--- a/arch/um/os-Linux/time.c~uml-fix-no_hz-busy-loop
+++ a/arch/um/os-Linux/time.c
@@ -59,7 +59,7 @@ long long disable_timer(void)
 {
 	struct itimerval time = ((struct itimerval) { { 0, 0 }, { 0, 0 } });
 
-	if(setitimer(ITIMER_VIRTUAL, &time, &time) < 0)
+	if (setitimer(ITIMER_VIRTUAL, &time, &time) < 0)
 		printk(UM_KERN_ERR "disable_timer - setitimer failed, "
 		       "errno = %d\n", errno);
 
@@ -74,13 +74,61 @@ long long os_nsecs(void)
 	return timeval_to_ns(&tv);
 }
 
+#ifdef UML_CONFIG_NO_HZ
+static int after_sleep_interval(struct timespec *ts)
+{
+}
+#else
+static inline long long timespec_to_us(const struct timespec *ts)
+{
+	return ((long long) ts->tv_sec * UM_USEC_PER_SEC) +
+		ts->tv_nsec / UM_NSEC_PER_USEC;
+}
+
+static int after_sleep_interval(struct timespec *ts)
+{
+	int usec = UM_USEC_PER_SEC / UM_HZ;
+	long long start_usecs = timespec_to_us(ts);
+	struct timeval tv;
+	struct itimerval interval;
+
+	/*
+	 * It seems that rounding can increase the value returned from
+	 * setitimer to larger than the one passed in.  Over time,
+	 * this will cause the remaining time to be greater than the
+	 * tick interval.  If this happens, then just reduce the first
+	 * tick to the interval value.
+	 */
+	if (start_usecs > usec)
+		start_usecs = usec;
+	tv = ((struct timeval) { .tv_sec  = start_usecs / UM_USEC_PER_SEC,
+				 .tv_usec = start_usecs % UM_USEC_PER_SEC });
+	interval = ((struct itimerval) { { 0, usec }, tv });
+
+	if (setitimer(ITIMER_VIRTUAL, &interval, NULL) == -1)
+		return -errno;
+
+	return 0;
+}
+#endif
+
 extern void alarm_handler(int sig, struct sigcontext *sc);
 
 void idle_sleep(unsigned long long nsecs)
 {
-	struct timespec ts = { .tv_sec	= nsecs / UM_NSEC_PER_SEC,
-			       .tv_nsec = nsecs % UM_NSEC_PER_SEC };
+	struct timespec ts;
+
+	/*
+	 * nsecs can come in as zero, in which case, this starts a
+	 * busy loop.  To prevent this, reset nsecs to the tick
+	 * interval if it is zero.
+	 */
+	if (nsecs == 0)
+		nsecs = UM_NSEC_PER_SEC / UM_HZ;
+	ts = ((struct timespec) { .tv_sec	= nsecs / UM_NSEC_PER_SEC,
+				  .tv_nsec	= nsecs % UM_NSEC_PER_SEC });
 
 	if (nanosleep(&ts, &ts) == 0)
 		alarm_handler(SIGVTALRM, NULL);
+	after_sleep_interval(&ts);
 }
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-fix-no_hz-busy-loop.patch
git-kvm.patch
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
uml-host-tls-diagnostics.patch
uml-move-um_virt_to_phys.patch
uml-header-untangling.patch
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-add-virt_to_pte.patch
uml-simplify-sigsegv-handling.patch
uml-use-ptrace-directly-in-libc-code.patch
uml-kill-processes-instead-of-panicing-kernel.patch
uml-clean-up-task_size-usage.patch
uml-cover-stubs-with-a-vma.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch

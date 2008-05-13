From: akpm@linux-foundation.org
Subject: - uml-track-and-make-up-lost-ticks.patch removed from -mm tree
Date: Tue, 13 May 2008 14:32:55 -0700
Message-ID: <200805132132.m4DLWtRv000762@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759214AbYEMVdK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:33:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, nix@esperi.org.uk, mm-commits@vger.kernel.org


The patch titled
     uml: track and make up lost ticks
has been removed from the -mm tree.  Its filename was
     uml-track-and-make-up-lost-ticks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: track and make up lost ticks
From: Jeff Dike <jdike@addtoit.com>

Alarm delivery could be noticably late in the !CONFIG_NOHZ case because lost
ticks weren't being taken into account.  This is now treated more carefully,
with the time between ticks being calculated and the appropriate number of
ticks delivered to the timekeeping system.

Cc: Nix <nix@esperi.org.uk>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/process.h |    4 +-
 arch/um/os-Linux/signal.c |    1 
 arch/um/os-Linux/time.c   |   54 +++++++++++++++++++++++++++++++++---
 3 files changed, 53 insertions(+), 6 deletions(-)

diff -puN arch/um/include/process.h~uml-track-and-make-up-lost-ticks arch/um/include/process.h
--- a/arch/um/include/process.h~uml-track-and-make-up-lost-ticks
+++ a/arch/um/include/process.h
@@ -11,7 +11,7 @@
 /* Copied from linux/compiler-gcc.h since we can't include it directly */
 #define barrier() __asm__ __volatile__("": : :"memory")
 
-extern void sig_handler(int sig, struct sigcontext sc);
-extern void alarm_handler(int sig, struct sigcontext sc);
+extern void sig_handler(int sig, struct sigcontext *sc);
+extern void alarm_handler(int sig, struct sigcontext *sc);
 
 #endif
diff -puN arch/um/os-Linux/signal.c~uml-track-and-make-up-lost-ticks arch/um/os-Linux/signal.c
--- a/arch/um/os-Linux/signal.c~uml-track-and-make-up-lost-ticks
+++ a/arch/um/os-Linux/signal.c
@@ -12,6 +12,7 @@
 #include "as-layout.h"
 #include "kern_util.h"
 #include "os.h"
+#include "process.h"
 #include "sysdep/barrier.h"
 #include "sysdep/sigcontext.h"
 #include "user.h"
diff -puN arch/um/os-Linux/time.c~uml-track-and-make-up-lost-ticks arch/um/os-Linux/time.c
--- a/arch/um/os-Linux/time.c~uml-track-and-make-up-lost-ticks
+++ a/arch/um/os-Linux/time.c
@@ -9,7 +9,9 @@
 #include <time.h>
 #include <sys/time.h>
 #include "kern_constants.h"
+#include "kern_util.h"
 #include "os.h"
+#include "process.h"
 #include "user.h"
 
 int set_interval(void)
@@ -58,12 +60,17 @@ static inline long long timeval_to_ns(co
 long long disable_timer(void)
 {
 	struct itimerval time = ((struct itimerval) { { 0, 0 }, { 0, 0 } });
+	int remain, max = UM_NSEC_PER_SEC / UM_HZ;
 
 	if (setitimer(ITIMER_VIRTUAL, &time, &time) < 0)
 		printk(UM_KERN_ERR "disable_timer - setitimer failed, "
 		       "errno = %d\n", errno);
 
-	return timeval_to_ns(&time.it_value);
+	remain = timeval_to_ns(&time.it_value);
+	if (remain > max)
+		remain = max;
+
+	return remain;
 }
 
 long long os_nsecs(void)
@@ -79,7 +86,44 @@ static int after_sleep_interval(struct t
 {
 	return 0;
 }
+
+static void deliver_alarm(void)
+{
+	alarm_handler(SIGVTALRM, NULL);
+}
+
+static unsigned long long sleep_time(unsigned long long nsecs)
+{
+	return nsecs;
+}
+
 #else
+unsigned long long last_tick;
+unsigned long long skew;
+
+static void deliver_alarm(void)
+{
+	unsigned long long this_tick = os_nsecs();
+	int one_tick = UM_NSEC_PER_SEC / UM_HZ;
+
+	if (last_tick == 0)
+		last_tick = this_tick - one_tick;
+
+	skew += this_tick - last_tick;
+
+	while (skew >= one_tick) {
+		alarm_handler(SIGVTALRM, NULL);
+		skew -= one_tick;
+	}
+
+	last_tick = this_tick;
+}
+
+static unsigned long long sleep_time(unsigned long long nsecs)
+{
+	return nsecs > skew ? nsecs - skew : 0;
+}
+
 static inline long long timespec_to_us(const struct timespec *ts)
 {
 	return ((long long) ts->tv_sec * UM_USEC_PER_SEC) +
@@ -102,6 +146,8 @@ static int after_sleep_interval(struct t
 	 */
 	if (start_usecs > usec)
 		start_usecs = usec;
+
+	start_usecs -= skew / UM_NSEC_PER_USEC;
 	tv = ((struct timeval) { .tv_sec  = start_usecs / UM_USEC_PER_SEC,
 				 .tv_usec = start_usecs % UM_USEC_PER_SEC });
 	interval = ((struct itimerval) { { 0, usec }, tv });
@@ -113,8 +159,6 @@ static int after_sleep_interval(struct t
 }
 #endif
 
-extern void alarm_handler(int sig, struct sigcontext *sc);
-
 void idle_sleep(unsigned long long nsecs)
 {
 	struct timespec ts;
@@ -126,10 +170,12 @@ void idle_sleep(unsigned long long nsecs
 	 */
 	if (nsecs == 0)
 		nsecs = UM_NSEC_PER_SEC / UM_HZ;
+
+	nsecs = sleep_time(nsecs);
 	ts = ((struct timespec) { .tv_sec	= nsecs / UM_NSEC_PER_SEC,
 				  .tv_nsec	= nsecs % UM_NSEC_PER_SEC });
 
 	if (nanosleep(&ts, &ts) == 0)
-		alarm_handler(SIGVTALRM, NULL);
+		deliver_alarm();
 	after_sleep_interval(&ts);
 }
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
linux-next.patch
asm-alphah8300umv850xtensa-paramh-unbreak-hz-for-userspace.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch


From: akpm@linux-foundation.org
Subject: + documentation-cpu-load-calculation-description.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:54:00 -0800
Message-ID: <200702272054.l1RKs4uG028205@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51532 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbXB0Uyq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:54:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: av1474@comtv.ru


The patch titled
     Documentation: CPU load calculation description
has been added to the -mm tree.  Its filename is
     documentation-cpu-load-calculation-description.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Documentation: CPU load calculation description
From: Vassili Karpov <av1474@comtv.ru>

Describes how/when the information exported to `/proc/stat' is calculated,
and possible problems with this approach.

Signed-off-by: Vassili Karpov <av1474@comtv.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpu-load.txt |  113 +++++++++++++++++++++++++++++++++++
 1 file changed, 113 insertions(+)

diff -puN /dev/null Documentation/cpu-load.txt
--- /dev/null
+++ a/Documentation/cpu-load.txt
@@ -0,0 +1,113 @@
+CPU load
+--------
+
+Linux exports various bits of information via `/proc/stat' and
+`/proc/uptime' that userland tools, such as top(1), use to calculate
+the average time system spent in a particular state, for example:
+
+    $ iostat
+    Linux 2.6.18.3-exp (linmac)     02/20/2007
+
+    avg-cpu:  %user   %nice %system %iowait  %steal   %idle
+              10.01    0.00    2.92    5.44    0.00   81.63
+
+    ...
+
+Here the system thinks that over the default sampling period the
+system spent 10.01% of the time doing work in user space, 2.92% in the
+kernel, and was overall 81.63% of the time idle.
+
+In most cases the `/proc/stat' information reflects the reality quite
+closely, however due to the nature of how/when the kernel collects
+this data sometimes it can not be trusted at all.
+
+So how is this information collected?  Whenever timer interrupt is
+signalled the kernel looks what kind of task was running at this
+moment and increments the counter that corresponds to this tasks
+kind/state.  The problem with this is that the system could have
+switched between various states multiple times between two timer
+interrupts yet the counter is incremented only for the last state.
+
+
+Example
+-------
+
+If we imagine the system with one task that periodically burns cycles
+in the following manner:
+
+ time line between two timer interrupts
+|--------------------------------------|
+ ^                                    ^
+ |_ something begins working          |
+                                      |_ something goes to sleep
+                                     (only to be awaken quite soon)
+
+In the above situation the system will be 0% loaded according to the
+`/proc/stat' (since the timer interrupt will always happen when the
+system is executing the idle handler), but in reality the load is
+closer to 99%.
+
+One can imagine many more situations where this behavior of the kernel
+will lead to quite erratic information inside `/proc/stat'.
+
+
+/* gcc -o hog smallhog.c */
+#include <time.h>
+#include <limits.h>
+#include <signal.h>
+#include <sys/time.h>
+#define HIST 10
+
+static volatile sig_atomic_t stop;
+
+static void sighandler (int signr)
+{
+     (void) signr;
+     stop = 1;
+}
+static unsigned long hog (unsigned long niters)
+{
+     stop = 0;
+     while (!stop && --niters);
+     return niters;
+}
+int main (void)
+{
+     int i;
+     struct itimerval it = { .it_interval = { .tv_sec = 0, .tv_usec = 1 },
+                             .it_value = { .tv_sec = 0, .tv_usec = 1 } };
+     sigset_t set;
+     unsigned long v[HIST];
+     double tmp = 0.0;
+     unsigned long n;
+     signal (SIGALRM, &sighandler);
+     setitimer (ITIMER_REAL, &it, NULL);
+
+     hog (ULONG_MAX);
+     for (i = 0; i < HIST; ++i) v[i] = ULONG_MAX - hog (ULONG_MAX);
+     for (i = 0; i < HIST; ++i) tmp += v[i];
+     tmp /= HIST;
+     n = tmp - (tmp / 3.0);
+
+     sigemptyset (&set);
+     sigaddset (&set, SIGALRM);
+
+     for (;;) {
+         hog (n);
+         sigwait (&set, &i);
+     }
+     return 0;
+}
+
+
+References
+----------
+
+http://lkml.org/lkml/2007/2/12/6
+Documentation/filesystems/proc.txt (1.8)
+
+
+Thanks
+------
+
+Con Kolivas, Pavel Machek
_

Patches currently in -mm which might be from av1474@comtv.ru are

documentation-cpu-load-calculation-description.patch

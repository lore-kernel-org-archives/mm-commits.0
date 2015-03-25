From: akpm@linux-foundation.org
Subject: + kernel-forkc-avoid-division-by-zero.patch added to -mm tree
Date: Wed, 25 Mar 2015 13:55:14 -0700
Message-ID: <551320b2.O7/MISeWa9tRPu8+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbbCYUzP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Mar 2015 16:55:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xypron.glpk@gmx.de, linux@roeck-us.net, mingo@kernel.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/fork.c: avoid division by zero
has been added to the -mm tree.  Its filename is
     kernel-forkc-avoid-division-by-zero.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-forkc-avoid-division-by-zero.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-forkc-avoid-division-by-zero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: kernel/fork.c: avoid division by zero

PAGE_SIZE is not guaranteed to be equal to or less than 8 times the
THREAD_SIZE.

E.g.  architecture hexagon may have page size 1M and thread size 4096. 
This would lead to a division by zero in the calculation of max_threads.

With 32-bit calculation there is no solution which delivers valid results
for all possible combinations of the parameters.  The code is only called
once.  Hence a 64-bit calculation can be used as solution.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff -puN kernel/fork.c~kernel-forkc-avoid-division-by-zero kernel/fork.c
--- a/kernel/fork.c~kernel-forkc-avoid-division-by-zero
+++ a/kernel/fork.c
@@ -88,6 +88,16 @@
 #include <trace/events/task.h>
 
 /*
+ * Minimum number of threads to boot the kernel
+ */
+#define MIN_THREADS 20
+
+/*
+ * Maximum number of threads
+ */
+#define MAX_THREADS FUTEX_TID_MASK
+
+/*
  * Protected counters by write_lock_irq(&tasklist_lock)
  */
 unsigned long total_forks;	/* Handle normal Linux uptimes. */
@@ -258,18 +268,25 @@ void __init __weak arch_task_cache_init(
  */
 static void set_max_threads(void)
 {
-	/*
-	 * The default maximum number of threads is set to a safe
-	 * value: the thread structures can take up at most one
-	 * eighth of the memory.
-	 */
-	max_threads = totalram_pages / (8 * THREAD_SIZE / PAGE_SIZE);
+	u64 threads;
 
 	/*
-	 * we need to allow at least 20 threads to boot a system
+	 * The number of threads shall be limited such that the thread
+	 * structures may only consume a small part of the available memory.
 	 */
-	if (max_threads < 20)
-		max_threads = 20;
+	if (fls64(totalram_pages) + fls64(PAGE_SIZE) > 64)
+		threads = MAX_THREADS;
+	else
+		threads = div64_u64((u64) totalram_pages * (u64) PAGE_SIZE,
+				    (u64) THREAD_SIZE * 8UL);
+
+	if (threads > MAX_THREADS)
+		threads = MAX_THREADS;
+
+	if (threads < MIN_THREADS)
+		threads = MIN_THREADS;
+
+	max_threads = (int) threads;
 }
 
 void __init fork_init(void)
_

Patches currently in -mm which might be from xypron.glpk@gmx.de are

kernel-forkc-new-function-for-max_threads.patch
kernel-forkc-avoid-division-by-zero.patch
kernel-forkc-avoid-division-by-zero-fix.patch
kernel-sysctlc-threads-max-observe-limits.patch
doc-sysctl-kerneltxt-document-threads-max.patch
doc-sysctl-kerneltxt-document-threads-max-fix.patch
linux-next.patch


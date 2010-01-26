From: akpm@linux-foundation.org
Subject: + kernel-timekeeping-move-xtime_cache-to-be-in-the-same-cache-line-as-the-lock.patch added to -mm tree
Date: Tue, 26 Jan 2010 15:28:32 -0800
Message-ID: <201001262328.o0QNSWHe028341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752112Ab0AZX3m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 18:29:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@rsk.demon.co.uk, johnstul@us.ibm.com, mingo@elte.hu, schwidefsky@de.ibm.com, tglx@linutronix.de


The patch titled
     kernel/timekeeping: move xtime_cache to be in the same cache line as the lock
has been added to the -mm tree.  Its filename is
     kernel-timekeeping-move-xtime_cache-to-be-in-the-same-cache-line-as-the-lock.patch

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
Subject: kernel/timekeeping: move xtime_cache to be in the same cache line as the lock
From: Richard Kennedy <richard@rsk.demon.co.uk>

Move xtime_cache to be in the same cache line as the lock, allowing
current_kernel_time() to access only one cache line

When running fio write tests on a 2 core machine, on some of the runs
'perf record -e cache_misses' shows current_kernel_time near the top of
the list of cache_misses with 5.5%.

On the other runs it's down at 0.05% so I'm assuming that the difference
is just down to which core the test client get run on.

This patch moves the xtime_cache variable near to the lock so that it only
need to access one cache line.  With this applied it drops the
current_kernel_time cache_misses in the slow case to 4.5%

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timekeeping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/timekeeping.c~kernel-timekeeping-move-xtime_cache-to-be-in-the-same-cache-line-as-the-lock kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~kernel-timekeeping-move-xtime_cache-to-be-in-the-same-cache-line-as-the-lock
+++ a/kernel/time/timekeeping.c
@@ -137,6 +137,7 @@ static inline s64 timekeeping_get_ns_raw
  */
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
 
+static struct timespec xtime_cache __attribute__ ((aligned (16)));
 
 /*
  * The current time
@@ -165,7 +166,6 @@ struct timespec raw_time;
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
-static struct timespec xtime_cache __attribute__ ((aligned (16)));
 void update_xtime_cache(u64 nsec)
 {
 	xtime_cache = xtime;
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

kernel-timekeeping-move-xtime_cache-to-be-in-the-same-cache-line-as-the-lock.patch


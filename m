From: akpm@linux-foundation.org
Subject: + taskstats-use-real-microsecond-granularity-for-cpu-times.patch added to -mm tree
Date: Mon, 11 Oct 2010 12:57:19 -0700
Message-ID: <201010111957.o9BJvJZE014744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753573Ab0JKT5v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Oct 2010 15:57:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holzheu@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, nagar1234@in.ibm.com, nagar@us.ibm.com, oleg@redhat.com, schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     taskstats: use real microsecond granularity for CPU times
has been added to the -mm tree.  Its filename is
     taskstats-use-real-microsecond-granularity-for-cpu-times.patch

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
Subject: taskstats: use real microsecond granularity for CPU times
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

The taskstats interface uses microsecond granularity for the user and
system time values.  The conversion from cputime to the taskstats values
uses the cputime_to_msecs primitive which effectively limits the
granularity to milliseconds.  Add the cputime_to_usecs primitive for
architectures that have better, more precise CPU time values.  Remove
cputime_to_msecs primitive because there are no more users left.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Luck Tony <tony.luck@intel.com>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Shailabh Nagar <nagar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/cputime.h    |    6 +++---
 arch/powerpc/include/asm/cputime.h |   12 ++++++------
 arch/s390/include/asm/cputime.h    |   10 +++++-----
 include/asm-generic/cputime.h      |    6 +++---
 kernel/tsacct.c                    |   10 ++++------
 5 files changed, 21 insertions(+), 23 deletions(-)

diff -puN arch/ia64/include/asm/cputime.h~taskstats-use-real-microsecond-granularity-for-cpu-times arch/ia64/include/asm/cputime.h
--- a/arch/ia64/include/asm/cputime.h~taskstats-use-real-microsecond-granularity-for-cpu-times
+++ a/arch/ia64/include/asm/cputime.h
@@ -56,10 +56,10 @@ typedef u64 cputime64_t;
 #define jiffies64_to_cputime64(__jif)	((__jif) * (NSEC_PER_SEC / HZ))
 
 /*
- * Convert cputime <-> milliseconds
+ * Convert cputime <-> microseconds
  */
-#define cputime_to_msecs(__ct)		((__ct) / NSEC_PER_MSEC)
-#define msecs_to_cputime(__msecs)	((__msecs) * NSEC_PER_MSEC)
+#define cputime_to_usecs(__ct)		((__ct) / NSEC_PER_USEC)
+#define usecs_to_cputime(__usecs)	((__usecs) * NSEC_PER_USEC)
 
 /*
  * Convert cputime <-> seconds
diff -puN arch/powerpc/include/asm/cputime.h~taskstats-use-real-microsecond-granularity-for-cpu-times arch/powerpc/include/asm/cputime.h
--- a/arch/powerpc/include/asm/cputime.h~taskstats-use-real-microsecond-granularity-for-cpu-times
+++ a/arch/powerpc/include/asm/cputime.h
@@ -124,23 +124,23 @@ static inline u64 cputime64_to_jiffies64
 }
 
 /*
- * Convert cputime <-> milliseconds
+ * Convert cputime <-> microseconds
  */
 extern u64 __cputime_msec_factor;
 
-static inline unsigned long cputime_to_msecs(const cputime_t ct)
+static inline unsigned long cputime_to_usecs(const cputime_t ct)
 {
-	return mulhdu(ct, __cputime_msec_factor);
+	return mulhdu(ct, __cputime_msec_factor) * USEC_PER_MSEC;
 }
 
-static inline cputime_t msecs_to_cputime(const unsigned long ms)
+static inline cputime_t usecs_to_cputime(const unsigned long us)
 {
 	cputime_t ct;
 	unsigned long sec;
 
 	/* have to be a little careful about overflow */
-	ct = ms % 1000;
-	sec = ms / 1000;
+	ct = us % 1000000;
+	sec = us / 1000000;
 	if (ct) {
 		ct *= tb_ticks_per_sec;
 		do_div(ct, 1000);
diff -puN arch/s390/include/asm/cputime.h~taskstats-use-real-microsecond-granularity-for-cpu-times arch/s390/include/asm/cputime.h
--- a/arch/s390/include/asm/cputime.h~taskstats-use-real-microsecond-granularity-for-cpu-times
+++ a/arch/s390/include/asm/cputime.h
@@ -73,18 +73,18 @@ cputime64_to_jiffies64(cputime64_t cputi
 }
 
 /*
- * Convert cputime to milliseconds and back.
+ * Convert cputime to microseconds and back.
  */
 static inline unsigned int
-cputime_to_msecs(const cputime_t cputime)
+cputime_to_usecs(const cputime_t cputime)
 {
-	return cputime_div(cputime, 4096000);
+	return cputime_div(cputime, 4096);
 }
 
 static inline cputime_t
-msecs_to_cputime(const unsigned int m)
+usecs_to_cputime(const unsigned int m)
 {
-	return (cputime_t) m * 4096000;
+	return (cputime_t) m * 4096;
 }
 
 /*
diff -puN include/asm-generic/cputime.h~taskstats-use-real-microsecond-granularity-for-cpu-times include/asm-generic/cputime.h
--- a/include/asm-generic/cputime.h~taskstats-use-real-microsecond-granularity-for-cpu-times
+++ a/include/asm-generic/cputime.h
@@ -33,10 +33,10 @@ typedef u64 cputime64_t;
 
 
 /*
- * Convert cputime to milliseconds and back.
+ * Convert cputime to microseconds and back.
  */
-#define cputime_to_msecs(__ct)		jiffies_to_msecs(__ct)
-#define msecs_to_cputime(__msecs)	msecs_to_jiffies(__msecs)
+#define cputime_to_usecs(__ct)		jiffies_to_usecs(__ct);
+#define usecs_to_cputime(__msecs)	usecs_to_jiffies(__msecs);
 
 /*
  * Convert cputime to seconds and back.
diff -puN kernel/tsacct.c~taskstats-use-real-microsecond-granularity-for-cpu-times kernel/tsacct.c
--- a/kernel/tsacct.c~taskstats-use-real-microsecond-granularity-for-cpu-times
+++ a/kernel/tsacct.c
@@ -63,12 +63,10 @@ void bacct_add_tsk(struct taskstats *sta
 	stats->ac_ppid	 = pid_alive(tsk) ?
 				rcu_dereference(tsk->real_parent)->tgid : 0;
 	rcu_read_unlock();
-	stats->ac_utime	 = cputime_to_msecs(tsk->utime) * USEC_PER_MSEC;
-	stats->ac_stime	 = cputime_to_msecs(tsk->stime) * USEC_PER_MSEC;
-	stats->ac_utimescaled =
-		cputime_to_msecs(tsk->utimescaled) * USEC_PER_MSEC;
-	stats->ac_stimescaled =
-		cputime_to_msecs(tsk->stimescaled) * USEC_PER_MSEC;
+	stats->ac_utime = cputime_to_usecs(tsk->utime);
+	stats->ac_stime = cputime_to_usecs(tsk->stime);
+	stats->ac_utimescaled = cputime_to_usecs(tsk->utimescaled);
+	stats->ac_stimescaled = cputime_to_usecs(tsk->stimescaled);
 	stats->ac_minflt = tsk->min_flt;
 	stats->ac_majflt = tsk->maj_flt;
 
_

Patches currently in -mm which might be from holzheu@linux.vnet.ibm.com are

linux-next.patch
taskstats-separate-taskstats-commands.patch
taskstats-split-fill_pid-function.patch
taskstats-use-real-microsecond-granularity-for-cpu-times.patch


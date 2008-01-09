From: akpm@linux-foundation.org
Subject: + provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc.patch added to -mm tree
Date: Tue, 08 Jan 2008 22:17:08 -0800
Message-ID: <200801090616.m096GmA6019905@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41269 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961AbYAIGRt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2008 01:17:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlim@sgi.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Provide u64 version of jiffies_to_usecs() in kernel/tsacct.c
has been added to the -mm tree.  Its filename is
     provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Provide u64 version of jiffies_to_usecs() in kernel/tsacct.c
From: Jonathan Lim <jlim@sgi.com>

It's possible that the values used in and returned from jiffies_to_usecs()
are incorrect because of truncation when variables of type u64 are
involved.  So a function specific to that type is used instead.

Signed-off-by: Jonathan Lim <jlim@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jiffies.h |    5 +++--
 kernel/time.c           |    6 ++++++
 kernel/tsacct.c         |    4 ++--
 3 files changed, 11 insertions(+), 4 deletions(-)

diff -puN include/linux/jiffies.h~provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc include/linux/jiffies.h
--- a/include/linux/jiffies.h~provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc
+++ a/include/linux/jiffies.h
@@ -36,7 +36,7 @@
 /* LATCH is used in the interval timer and ftape setup. */
 #define LATCH  ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
 
-/* Suppose we want to devide two numbers NOM and DEN: NOM/DEN, then we can
+/* Suppose we want to divide two numbers NOM and DEN: NOM/DEN, then we can
  * improve accuracy by shifting LSH bits, hence calculating:
  *     (NOM << LSH) / DEN
  * This however means trouble for large NOM, because (NOM << LSH) may no
@@ -198,7 +198,7 @@ extern unsigned long preset_lpj;
  * operator if the result is a long long AND at least one of the
  * operands is cast to long long (usually just prior to the "*" so as
  * not to confuse it into thinking it really has a 64-bit operand,
- * which, buy the way, it can do, but it takes more code and at least 2
+ * which, by the way, it can do, but it takes more code and at least 2
  * mpys).
 
  * We also need to be aware that one second in nanoseconds is only a
@@ -263,6 +263,7 @@ extern unsigned long preset_lpj;
  */
 extern unsigned int jiffies_to_msecs(const unsigned long j);
 extern unsigned int jiffies_to_usecs(const unsigned long j);
+extern u64 jiffies_64_to_usecs(const u64 j);
 extern unsigned long msecs_to_jiffies(const unsigned int m);
 extern unsigned long usecs_to_jiffies(const unsigned int u);
 extern unsigned long timespec_to_jiffies(const struct timespec *value);
diff -puN kernel/time.c~provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc kernel/time.c
--- a/kernel/time.c~provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc
+++ a/kernel/time.c
@@ -267,6 +267,12 @@ unsigned int inline jiffies_to_usecs(con
 }
 EXPORT_SYMBOL(jiffies_to_usecs);
 
+u64 inline jiffies_64_to_usecs(const u64 j)
+{
+	return (j*HZ_TO_USEC_NUM + HZ_TO_USEC_DEN-1) / HZ_TO_USEC_DEN;
+}
+EXPORT_SYMBOL(jiffies_64_to_usecs);
+
 /**
  * timespec_trunc - Truncate timespec to a granularity
  * @t: Timespec
diff -puN kernel/tsacct.c~provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc kernel/tsacct.c
--- a/kernel/tsacct.c~provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc
+++ a/kernel/tsacct.c
@@ -85,8 +85,8 @@ void xacct_add_tsk(struct taskstats *sta
 	struct mm_struct *mm;
 
 	/* convert pages-jiffies to Mbyte-usec */
-	stats->coremem = jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
-	stats->virtmem = jiffies_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
+	stats->coremem = jiffies_64_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
+	stats->virtmem = jiffies_64_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
 	mm = get_task_mm(p);
 	if (mm) {
 		/* adjust to KB unit */
_

Patches currently in -mm which might be from jlim@sgi.com are

provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc.patch

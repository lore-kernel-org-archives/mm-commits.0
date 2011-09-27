From: akpm@google.com
Subject: [merged] kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch removed from -mm tree
Date: Tue, 27 Sep 2011 12:03:10 -0700
Message-ID: <201109271903.p8RJ3CCf001033@hpaq13.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:41325 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1I0TEG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Sep 2011 15:04:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pyu@redhat.com, john.stultz@linaro.org, stable@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/time.c: change jiffies_to_clock_t() input parameter's type to unsigned long
has been removed from the -mm tree.  Its filename was
     kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: hank <pyu@redhat.com>
Subject: kernel/time.c: change jiffies_to_clock_t() input parameter's type to unsigned long

The parameter's origin type is long.  On an i386 architecture, it can
easily be larger than 0x80000000, causing this function to convert it to a
sign-extended u64 type.  Change the type to unsigned long so we get the
correct result.

[akpm@linux-foundation.org: build fix]
Signed-off-by: hank <pyu@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jiffies.h |    2 +-
 kernel/time.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/jiffies.h~kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long include/linux/jiffies.h
--- a/include/linux/jiffies.h~kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long
+++ a/include/linux/jiffies.h
@@ -303,7 +303,7 @@ extern void jiffies_to_timespec(const un
 extern unsigned long timeval_to_jiffies(const struct timeval *value);
 extern void jiffies_to_timeval(const unsigned long jiffies,
 			       struct timeval *value);
-extern clock_t jiffies_to_clock_t(long x);
+extern clock_t jiffies_to_clock_t(unsigned long x);
 extern unsigned long clock_t_to_jiffies(unsigned long x);
 extern u64 jiffies_64_to_clock_t(u64 x);
 extern u64 nsec_to_clock_t(u64 x);
diff -puN kernel/time.c~kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long kernel/time.c
--- a/kernel/time.c~kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long
+++ a/kernel/time.c
@@ -575,7 +575,7 @@ EXPORT_SYMBOL(jiffies_to_timeval);
 /*
  * Convert jiffies/jiffies_64 to clock_t and back.
  */
-clock_t jiffies_to_clock_t(long x)
+clock_t jiffies_to_clock_t(unsigned long x)
 {
 #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
 # if HZ < USER_HZ
_

Patches currently in -mm which might be from pyu@redhat.com are

linux-next.patch


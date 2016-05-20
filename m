From: akpm@linux-foundation.org
Subject: [merged]
 time-add-missing-implementation-for-timespec64_add_safe.patch removed from
 -mm tree
Date: Fri, 20 May 2016 14:02:19 -0700
Message-ID: <573f7b5b.4YVLlr2NsdXN/bbE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETVCU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:02:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deepa.kernel@gmail.com, arnd@arndb.de, john.stultz@linaro.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: time: add missing implementation for timespec64_add_safe()
has been removed from the -mm tree.  Its filename was
     time-add-missing-implementation-for-timespec64_add_safe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: time: add missing implementation for timespec64_add_safe()

timespec64_add_safe() has been defined in time64.h for 64 bit systems. 
But, 32 bit systems only have an extern function prototype defined. 
Provide a definition for the above function.

The function will be necessary as part of y2038 changes.  struct timespec
is not y2038 safe.  All references to timespec will be replaced by struct
timespec64.  The function is meant to be a replacement for
timespec_add_safe().

The implementation is similar to timespec_add_safe().

Link: http://lkml.kernel.org/r/1461947989-21926-2-git-send-email-deepa.kernel@gmail.com
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Acked-by: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/time64.h |    4 +---
 kernel/time/time.c     |   25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 3 deletions(-)

diff -puN include/linux/time64.h~time-add-missing-implementation-for-timespec64_add_safe include/linux/time64.h
--- a/include/linux/time64.h~time-add-missing-implementation-for-timespec64_add_safe
+++ a/include/linux/time64.h
@@ -136,13 +136,11 @@ extern void set_normalized_timespec64(st
 
 /*
  * timespec64_add_safe assumes both values are positive and checks for
- * overflow. It will return TIME_T_MAX if the returned value would be
- * smaller then either of the arguments.
+ * overflow. It will return TIME64_MAX in case of overflow.
  */
 extern struct timespec64 timespec64_add_safe(const struct timespec64 lhs,
 					 const struct timespec64 rhs);
 
-
 static inline struct timespec64 timespec64_add(struct timespec64 lhs,
 						struct timespec64 rhs)
 {
diff -puN kernel/time/time.c~time-add-missing-implementation-for-timespec64_add_safe kernel/time/time.c
--- a/kernel/time/time.c~time-add-missing-implementation-for-timespec64_add_safe
+++ a/kernel/time/time.c
@@ -769,3 +769,28 @@ struct timespec timespec_add_safe(const
 
 	return res;
 }
+
+#if __BITS_PER_LONG != 64
+
+/*
+ * Add two timespec64 values and do a safety check for overflow.
+ * It's assumed that both values are valid (>= 0).
+ * And, each timespec64 is in normalized form.
+ */
+struct timespec64 timespec64_add_safe(const struct timespec64 lhs,
+				const struct timespec64 rhs)
+{
+	struct timespec64 res;
+
+	set_normalized_timespec64(&res, lhs.tv_sec + rhs.tv_sec,
+			lhs.tv_nsec + rhs.tv_nsec);
+
+	if (unlikely(res.tv_sec < lhs.tv_sec || res.tv_sec < rhs.tv_sec)) {
+		res.tv_sec = TIME64_MAX;
+		res.tv_nsec = 0;
+	}
+
+	return res;
+}
+
+#endif
_

Patches currently in -mm which might be from deepa.kernel@gmail.com are



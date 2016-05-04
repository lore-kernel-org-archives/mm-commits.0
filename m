From: akpm@linux-foundation.org
Subject: + time-remove-timespec_add_safe.patch added to -mm tree
Date: Wed, 04 May 2016 16:51:30 -0700
Message-ID: <572a8b02.ilGnVsdq5TeXVWs1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42257 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397AbcEDXvb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 May 2016 19:51:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deepa.kernel@gmail.com, arnd@arndb.de, john.stultz@linaro.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: time: remove timespec_add_safe()
has been added to the -mm tree.  Its filename is
     time-remove-timespec_add_safe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/time-remove-timespec_add_safe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/time-remove-timespec_add_safe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: time: remove timespec_add_safe()

All references to timespec_add_safe() now use timespec64_add_safe().

The plan is to replace struct timespec references with struct timespec64
throughout the kernel as timespec is not y2038 safe.

Drop timespec_add_safe() and use timespec64_add_safe() for all
architectures.

Link: http://lkml.kernel.org/r/1461947989-21926-4-git-send-email-deepa.kernel@gmail.com
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/time64.h |   15 +++++++--------
 kernel/time/time.c     |    4 ----
 2 files changed, 7 insertions(+), 12 deletions(-)

diff -puN include/linux/time64.h~time-remove-timespec_add_safe include/linux/time64.h
--- a/include/linux/time64.h~time-remove-timespec_add_safe
+++ a/include/linux/time64.h
@@ -65,7 +65,6 @@ static inline struct itimerspec64 itimer
 # define timespec64_equal		timespec_equal
 # define timespec64_compare		timespec_compare
 # define set_normalized_timespec64	set_normalized_timespec
-# define timespec64_add_safe		timespec_add_safe
 # define timespec64_add			timespec_add
 # define timespec64_sub			timespec_sub
 # define timespec64_valid		timespec_valid
@@ -134,13 +133,6 @@ static inline int timespec64_compare(con
 
 extern void set_normalized_timespec64(struct timespec64 *ts, time64_t sec, s64 nsec);
 
-/*
- * timespec64_add_safe assumes both values are positive and checks for
- * overflow. It will return TIME64_MAX in case of overflow.
- */
-extern struct timespec64 timespec64_add_safe(const struct timespec64 lhs,
-					 const struct timespec64 rhs);
-
 static inline struct timespec64 timespec64_add(struct timespec64 lhs,
 						struct timespec64 rhs)
 {
@@ -222,4 +214,11 @@ static __always_inline void timespec64_a
 
 #endif
 
+/*
+ * timespec64_add_safe assumes both values are positive and checks for
+ * overflow. It will return TIME64_MAX in case of overflow.
+ */
+extern struct timespec64 timespec64_add_safe(const struct timespec64 lhs,
+					 const struct timespec64 rhs);
+
 #endif /* _LINUX_TIME64_H */
diff -puN kernel/time/time.c~time-remove-timespec_add_safe kernel/time/time.c
--- a/kernel/time/time.c~time-remove-timespec_add_safe
+++ a/kernel/time/time.c
@@ -770,8 +770,6 @@ struct timespec timespec_add_safe(const
 	return res;
 }
 
-#if __BITS_PER_LONG != 64
-
 /*
  * Add two timespec64 values and do a safety check for overflow.
  * It's assumed that both values are valid (>= 0).
@@ -792,5 +790,3 @@ struct timespec64 timespec64_add_safe(co
 
 	return res;
 }

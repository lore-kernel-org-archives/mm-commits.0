From: akpm@linux-foundation.org
Subject: [merged]
 y2038-remove-ktime-to-from-timespec-timeval-conversion.patch removed from
 -mm tree
Date: Sun, 23 Feb 2020 16:44:29 -0800
Message-ID: <20200224004429.jRSIKyIQQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgBXAoa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 23 Feb 2020 19:44:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, deepa.kernel@gmail.com, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: y2038: remove ktime to/from timespec/timeval conversion
has been removed from the -mm tree.  Its filename was
     y2038-remove-ktime-to-from-timespec-timeval-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: y2038: remove ktime to/from timespec/timeval conversion

A couple of helpers are now obsolete and can be removed, so drivers can no
longer start using them and instead use y2038-safe interfaces.

Link: http://lkml.kernel.org/r/20200110154232.4104492-2-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ktime.h |   37 -------------------------------------
 1 file changed, 37 deletions(-)

--- a/include/linux/ktime.h~y2038-remove-ktime-to-from-timespec-timeval-conversion
+++ a/include/linux/ktime.h
@@ -66,33 +66,15 @@ static inline ktime_t ktime_set(const s6
  */
 #define ktime_sub_ns(kt, nsval)		((kt) - (nsval))
 
-/* convert a timespec to ktime_t format: */
-static inline ktime_t timespec_to_ktime(struct timespec ts)
-{
-	return ktime_set(ts.tv_sec, ts.tv_nsec);
-}
-
 /* convert a timespec64 to ktime_t format: */
 static inline ktime_t timespec64_to_ktime(struct timespec64 ts)
 {
 	return ktime_set(ts.tv_sec, ts.tv_nsec);
 }
 
-/* convert a timeval to ktime_t format: */
-static inline ktime_t timeval_to_ktime(struct timeval tv)
-{
-	return ktime_set(tv.tv_sec, tv.tv_usec * NSEC_PER_USEC);
-}
-
-/* Map the ktime_t to timespec conversion to ns_to_timespec function */
-#define ktime_to_timespec(kt)		ns_to_timespec((kt))
-
 /* Map the ktime_t to timespec conversion to ns_to_timespec function */
 #define ktime_to_timespec64(kt)		ns_to_timespec64((kt))
 
-/* Map the ktime_t to timeval conversion to ns_to_timeval function */
-#define ktime_to_timeval(kt)		ns_to_timeval((kt))
-
 /* Convert ktime_t to nanoseconds */
 static inline s64 ktime_to_ns(const ktime_t kt)
 {
@@ -216,25 +198,6 @@ static inline ktime_t ktime_sub_ms(const
 extern ktime_t ktime_add_safe(const ktime_t lhs, const ktime_t rhs);
 
 /**
- * ktime_to_timespec_cond - convert a ktime_t variable to timespec
- *			    format only if the variable contains data
- * @kt:		the ktime_t variable to convert
- * @ts:		the timespec variable to store the result in
- *
- * Return: %true if there was a successful conversion, %false if kt was 0.
- */
-static inline __must_check bool ktime_to_timespec_cond(const ktime_t kt,
-						       struct timespec *ts)
-{
-	if (kt) {
-		*ts = ktime_to_timespec(kt);
-		return true;
-	} else {
-		return false;
-	}
-}

From: akpm@linux-foundation.org
Subject: + ktime_set-fix-arg-type.patch added to -mm tree
Date: Fri, 16 Mar 2007 13:39:42 -0700
Message-ID: <200703162041.l2GKfZvd021087@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35131 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbXCPUnK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 16:43:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, stable@kernel.org, tglx@linutronix.de


The patch titled
     ktime_set() fix arg type
has been added to the -mm tree.  Its filename is
     ktime_set-fix-arg-type.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ktime_set() fix arg type
From: Andrew Morton <akpm@linux-foundation.org>

We need to pass in a 64-bit value here to be able to handle KTIME_SEC_MAX on
32-bit machines.  This is needed for
hrtimer-prevent-overrun-dos-in-hrtimer_forward.patch.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ktime.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/ktime.h~ktime_set-fix-arg-type include/linux/ktime.h
--- a/include/linux/ktime.h~ktime_set-fix-arg-type
+++ a/include/linux/ktime.h
@@ -72,13 +72,13 @@ typedef union {
  *
  * Return the ktime_t representation of the value
  */
-static inline ktime_t ktime_set(const long secs, const unsigned long nsecs)
+static inline ktime_t ktime_set(const s64 secs, const unsigned long nsecs)
 {
 #if (BITS_PER_LONG == 64)
 	if (unlikely(secs >= KTIME_SEC_MAX))
 		return (ktime_t){ .tv64 = KTIME_MAX };
 #endif
-	return (ktime_t) { .tv64 = (s64)secs * NSEC_PER_SEC + (s64)nsecs };
+	return (ktime_t) { .tv64 = secs * NSEC_PER_SEC + (s64)nsecs };
 }
 
 /* Subtract two ktime_t variables. rem = lhs -rhs: */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ktime_set-fix-arg-type.patch
software-suspend-fix-suspend-when-console-is-in-tidy.patch

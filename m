From: akpm@linux-foundation.org
Subject: - time-prevent-the-loop-in-timespec_add_ns-from-being-optimised-away.patch removed from -mm tree
Date: Mon, 10 Mar 2008 11:05:41 -0700
Message-ID: <200803101805.m2AI5f3S030120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751400AbYCJSMV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 14:12:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segher@kernel.crashing.org, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     time: prevent the loop in timespec_add_ns() from being optimised away
has been removed from the -mm tree.  Its filename was
     time-prevent-the-loop-in-timespec_add_ns-from-being-optimised-away.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: time: prevent the loop in timespec_add_ns() from being optimised away
From: Segher Boessenkool <segher@kernel.crashing.org>

Since some architectures don't support __udivdi3().

Signed-off-by: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/time.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/time.h~time-prevent-the-loop-in-timespec_add_ns-from-being-optimised-away include/linux/time.h
--- a/include/linux/time.h~time-prevent-the-loop-in-timespec_add_ns-from-being-optimised-away
+++ a/include/linux/time.h
@@ -174,6 +174,10 @@ static inline void timespec_add_ns(struc
 {
 	ns += a->tv_nsec;
 	while(unlikely(ns >= NSEC_PER_SEC)) {
+		/* The following asm() prevents the compiler from
+		 * optimising this loop into a modulo operation.  */
+		asm("" : "+r"(ns));
+
 		ns -= NSEC_PER_SEC;
 		a->tv_sec++;
 	}
_

Patches currently in -mm which might be from segher@kernel.crashing.org are

powerpc-8xx-fix-swap.patch


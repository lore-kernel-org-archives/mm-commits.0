From: akpm@linux-foundation.org
Subject: + time-prevent-the-loop-in-timespec_add_ns-from-being-optimised-away.patch added to -mm tree
Date: Wed, 27 Feb 2008 15:43:45 -0800
Message-ID: <200802272343.m1RNhjnR004693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758797AbYB0XoM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 18:44:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segher@kernel.crashing.org, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     time: prevent the loop in timespec_add_ns() from being optimised away
has been added to the -mm tree.  Its filename is
     time-prevent-the-loop-in-timespec_add_ns-from-being-optimised-away.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

time-prevent-the-loop-in-timespec_add_ns-from-being-optimised-away.patch

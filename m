From: akpm@linux-foundation.org
Subject: + always_inline-timespec_add_ns.patch added to -mm tree
Date: Thu, 15 May 2008 16:03:32 -0700
Message-ID: <200805152303.m4FN3Ww6015049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754938AbYEOXF2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 19:05:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, andi@firstfloor.org, hancockr@shaw.ca, jeremy.fitzhardinge@citrix.com, johnstul@us.ibm.com, lists@nerdbynature.de, mingo@elte.hu, segher@kernel.crashing.org, tglx@linutronix.de


The patch titled
     always_inline timespec_add_ns
has been added to the -mm tree.  Its filename is
     always_inline-timespec_add_ns.patch

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
Subject: always_inline timespec_add_ns
From: Jeremy Fitzhardinge <jeremy@goop.org>

timespec_add_ns is used from the x86-64 vdso, which cannot call out to
other kernel code.  Make sure that timespec_add_ns is always inlined (and
only uses always_inlined functions) to make sure there are no unexpected
calls.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Robert Hancock <hancockr@shaw.ca>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/time.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN include/linux/time.h~always_inline-timespec_add_ns include/linux/time.h
--- a/include/linux/time.h~always_inline-timespec_add_ns
+++ a/include/linux/time.h
@@ -170,10 +170,13 @@ extern struct timeval ns_to_timeval(cons
  * timespec_add_ns - Adds nanoseconds to a timespec
  * @a:		pointer to timespec to be incremented
  * @ns:		unsigned nanoseconds value to be added
+ *
+ * This must always be inlined because its used from the x86-64 vdso,
+ * which cannot call other kernel functions.
  */
-static inline void timespec_add_ns(struct timespec *a, u64 ns)
+static __always_inline void timespec_add_ns(struct timespec *a, u64 ns)
 {
-	a->tv_sec += iter_div_u64_rem(a->tv_nsec + ns, NSEC_PER_SEC, &ns);
+	a->tv_sec += __iter_div_u64_rem(a->tv_nsec + ns, NSEC_PER_SEC, &ns);
 	a->tv_nsec = ns;
 }
 #endif /* __KERNEL__ */
_

Patches currently in -mm which might be from jeremy@goop.org are

x86-use-explicit-copy-in-vdso_gettimeofday.patch
common-implementation-of-iterative-div-mod.patch
add-an-inlined-version-of-iter_div_u64_rem.patch
always_inline-timespec_add_ns.patch


From: akpm@linux-foundation.org
Subject: + sched-prevent-compiler-from-optimising-sched_avg_update-loop.patch added to -mm tree
Date: Fri, 26 Mar 2010 14:03:53 -0700
Message-ID: <201003262103.o2QL3sdp020492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752125Ab0CZVFD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 17:05:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.deacon@arm.com, catalin.marinas@arm.com, mingo@elte.hu, peterz@infradead.org, rmk@arm.linux.org.uk


The patch titled
     sched: prevent compiler from optimising sched_avg_update loop
has been added to the -mm tree.  Its filename is
     sched-prevent-compiler-from-optimising-sched_avg_update-loop.patch

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
Subject: sched: prevent compiler from optimising sched_avg_update loop
From: Will Deacon <will.deacon@arm.com>

GCC 4.4.1 on ARM has been observed to replace the while loop in
sched_avg_update with a call to uldivmod, resulting in the following build
failure at link-time:

kernel/built-in.o: In function `sched_avg_update':
/linux-2.6/kernel/sched.c:1261: undefined reference to `__aeabi_uldivmod'
/linux-2.6/kernel/sched.c:1261: undefined reference to `__aeabi_uldivmod'
make: *** [.tmp_vmlinux1] Error 1

This patch introduces a fake data hazard to the loop body to prevent the
compiler optimising the loop away.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN kernel/sched.c~sched-prevent-compiler-from-optimising-sched_avg_update-loop kernel/sched.c
--- a/kernel/sched.c~sched-prevent-compiler-from-optimising-sched_avg_update-loop
+++ a/kernel/sched.c
@@ -1240,6 +1240,12 @@ static void sched_avg_update(struct rq *
 	s64 period = sched_avg_period();
 
 	while ((s64)(rq->clock - rq->age_stamp) > period) {
+		/*
+		 * Inline assembly required to prevent the compiler
+		 * optimising this loop into a divmod call.
+		 * See __iter_div_u64_rem() for another example of this.
+		 */
+		asm("" : "+rm" (rq->age_stamp));
 		rq->age_stamp += period;
 		rq->rt_avg /= 2;
 	}
_

Patches currently in -mm which might be from will.deacon@arm.com are

linux-next.patch
sched-prevent-compiler-from-optimising-sched_avg_update-loop.patch


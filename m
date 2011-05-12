From: akpm@linux-foundation.org
Subject: + seqlock-dont-smp_rmb-in-seqlock-reader-spin-loop.patch added to -mm tree
Date: Thu, 12 May 2011 12:42:06 -0700
Message-ID: <201105121942.p4CJg6RF029226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754971Ab1ELTmn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 May 2011 15:42:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miltonm@bga.com, andi@firstfloor.org, anton@samba.org, benh@kernel.crashing.org, dhowells@redhat.com, eric.dumazet@gmail.com, mingo@elte.hu, npiggin@kernel.dk, paulmck@us.ibm.com, stable@kernel.org, tglx@linutronix.de


The patch titled
     seqlock: don't smp_rmb in seqlock reader spin loop
has been added to the -mm tree.  Its filename is
     seqlock-dont-smp_rmb-in-seqlock-reader-spin-loop.patch

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
Subject: seqlock: don't smp_rmb in seqlock reader spin loop
From: Milton Miller <miltonm@bga.com>

Move the smp_rmb after cpu_relax loop in read_seqlock and add ACCESS_ONCE
to make sure the test and return are consistent.

A multi-threaded core in the lab didn't like the update from 2.6.35 to
2.6.36, to the point it would hang during boot when multiple threads were
active.  Bisection showed af5ab277ded04bd9bc6b048c5a2f0e7d70ef0867
("clockevents: Remove the per cpu tick skew") as the culprit and it is
supported with stack traces showing xtime_lock waits including
tick_do_update_jiffies64 and/or update_vsyscall.

Experimentation showed the combination of cpu_relax and smp_rmb was
significantly slowing the progress of other threads sharing the core, and
this patch is effective in avoiding the hang.

A theory is the rmb is affecting the whole core while the cpu_relax is
causing a resource rebalance flush, together they cause an interfernce
cadance that is unbroken when the seqlock reader has interrupts disabled.

At first I was confused why the refactor in
3c22cd5709e8143444a6d08682a87f4c57902df3 ("kernel: optimise seqlock")
didn't affect this patch application, but after some study that affected
seqcount not seqlock.  The new seqcount was not factored back into the
seqlock.  I defer that the future.

While the removal of the timer interrupt offset created contention for the
xtime lock while a cpu does the additonal work to update the system clock,
the seqlock implementation with the tight rmb spin loop goes back much
further, and is just waiting for the right trigger.

Signed-off-by: Milton Miller <miltonm@bga.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Howells <dhowells@redhat.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/seqlock.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/seqlock.h~seqlock-dont-smp_rmb-in-seqlock-reader-spin-loop include/linux/seqlock.h
--- a/include/linux/seqlock.h~seqlock-dont-smp_rmb-in-seqlock-reader-spin-loop
+++ a/include/linux/seqlock.h
@@ -88,12 +88,12 @@ static __always_inline unsigned read_seq
 	unsigned ret;
 
 repeat:
-	ret = sl->sequence;
-	smp_rmb();
+	ret = ACCESS_ONCE(sl->sequence);
 	if (unlikely(ret & 1)) {
 		cpu_relax();
 		goto repeat;
 	}
+	smp_rmb();
 
 	return ret;
 }
_

Patches currently in -mm which might be from miltonm@bga.com are

seqlock-dont-smp_rmb-in-seqlock-reader-spin-loop.patch


From: akpm@linux-foundation.org
Subject: + fix-fixpoint-divide-exception-in-acct_update_integrals.patch added to -mm tree
Date: Mon, 09 Mar 2009 14:59:03 -0700
Message-ID: <200903092159.n29Lx3OO011663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752270AbZCIWAe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Mar 2009 18:00:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, elendil@planet.nl, schwidefsky@de.ibm.com, stable@kernel.org


The patch titled
     kernel/tsacct.c: fix fixpoint divide exception in acct_update_integrals
has been added to the -mm tree.  Its filename is
     fix-fixpoint-divide-exception-in-acct_update_integrals.patch

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
Subject: kernel/tsacct.c: fix fixpoint divide exception in acct_update_integrals
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Frans Pop reported the crash below when running an s390 kernel under
Hercules:

 17180168.889947! Kernel BUG at 000738b4  verbose debug info unavailable!
 17180168.890213! fixpoint divide exception: 0009  #1! SMP
 17180168.890487! Modules linked in: nfs lockd nfs_acl sunrpc ctcm fsm tape_34xx
    cu3088 tape ccwgroup tape_class ext3 jbd mbcache dm_mirror dm_log dm_snapshot
    dm_mod dasd_eckd_mod dasd_mod
 17180168.891891! CPU: 0 Not tainted 2.6.27.19 #13
 17180168.892116! Process awk (pid: 2069, task: 0f9ed9b8, ksp: 0f4f7d18)
 17180168.892371! Krnl PSW : 070c1000 800738b4 (acct_update_integrals+0x4c/0x118)
 17180168.892830!            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:1 PM:0
 17180168.893115! Krnl GPRS: 00000000 000007d0 7fffffff fffff830
 17180168.893376!            00000000 ffffffff 00000002 0f9ed9b8
 17180168.893621!            00000000 00008ca0 00000000 0f9ed9b8
 17180168.893873!            0f9edda4 8007386e 0f4f7ec8 0f4f7e98
 17180168.894881! Krnl Code: 800738aa: a71807d0         lhi     %r1,2000
 17180168.895245!            800738ae: 8c200001         srdl    %r2,1
 17180168.895563!            800738b2: 1d21             dr      %r2,%r1
 17180168.895936!           >800738b4: 5810d10e         l       %r1,270(%r13)
 17180168.896246!            800738b8: 1823             lr      %r2,%r3
 17180168.896598!            800738ba: 4130f060         la      %r3,96(%r15)
 17180168.896913!            800738be: 0de1             basr    %r14,%r1
 17180168.897283!            800738c0: 5800f060         l       %r0,96(%r15)
 17180168.897517! Call Trace:
 17180168.897656! ( <000000000004fdea>! blocking_notifier_call_chain+0x1e/0x2c)
 17180168.897987!   <0000000000038502>! do_exit+0x106/0x7c0
 17180168.898275!   <0000000000038c36>! do_group_exit+0x7a/0xb4
 17180168.898570!   <0000000000038c8e>! SyS_exit_group+0x1e/0x30
 17180168.898869!   <0000000000021c28>! sysc_do_restart+0x12/0x16
 17180168.899173!   <0000000077e7e924>! 0x77e7e924

Reason for this is that cpu time accounting usually only happens from
interrupt context, but acct_update_integrals gets also called from process
context with interrupts enabled.

So in acct_update_integrals we may end up with the following scenario:

Between reading tsk->stime/tsk->utime and tsk->acct_timexpd an interrupt
happens which updates accouting values.  This causes acct_timexpd to be
greater than the former stime + utime.  The subsequent calculation of

dtime = cputime_sub(time, tsk->acct_timexpd);

will be negative and the division performed by

cputime_to_jiffies(dtime)

will generate an exception since the result won't fit into a 32 bit
register.

In order to fix this just always disable interrupts while accessing any
of the accounting values.

Reported by: Frans Pop <elendil@planet.nl>
Tested by: Frans Pop <elendil@planet.nl>
Cc: <stable@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/tsacct.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN kernel/tsacct.c~fix-fixpoint-divide-exception-in-acct_update_integrals kernel/tsacct.c
--- a/kernel/tsacct.c~fix-fixpoint-divide-exception-in-acct_update_integrals
+++ a/kernel/tsacct.c
@@ -122,8 +122,10 @@ void acct_update_integrals(struct task_s
 	if (likely(tsk->mm)) {
 		cputime_t time, dtime;
 		struct timeval value;
+		unsigned long flags;
 		u64 delta;
 
+		local_irq_save(flags);
 		time = tsk->stime + tsk->utime;
 		dtime = cputime_sub(time, tsk->acct_timexpd);
 		jiffies_to_timeval(cputime_to_jiffies(dtime), &value);
@@ -131,10 +133,12 @@ void acct_update_integrals(struct task_s
 		delta = delta * USEC_PER_SEC + value.tv_usec;
 
 		if (delta == 0)
-			return;
+			goto out;
 		tsk->acct_timexpd = time;
 		tsk->acct_rss_mem1 += delta * get_mm_rss(tsk->mm);
 		tsk->acct_vm_mem1 += delta * tsk->mm->total_vm;
+	out:
+		local_irq_restore(flags);
 	}
 }
 
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

fix-fixpoint-divide-exception-in-acct_update_integrals.patch
linux-next.patch
s390-use-kzfree.patch


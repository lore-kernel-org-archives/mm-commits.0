From: akpm@linux-foundation.org
Subject: + sched-remove-arch-specific-fpu_counter-from-task_struct.patch
 added to -mm tree
Date: Thu, 10 Oct 2013 14:40:14 -0700
Message-ID: <52571ebe.G+pAtZy6t+6NRwvc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589Ab3JJVkP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Oct 2013 17:40:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgupta@synopsys.com, paul.mundt@gmail.com, mingo@kernel.org, Vineet.Gupta1@synopsys.com

Subject: + sched-remove-arch-specific-fpu_counter-from-task_struct.patch added to -mm tree
To: Vineet.Gupta1@synopsys.com,mingo@kernel.org,paul.mundt@gmail.com,vgupta@synopsys.com
From: akpm@linux-foundation.org
Date: Thu, 10 Oct 2013 14:40:14 -0700


The patch titled
     Subject: sched: remove ARCH specific fpu_counter from task_struct
has been added to the -mm tree.  Its filename is
     sched-remove-arch-specific-fpu_counter-from-task_struct.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sched-remove-arch-specific-fpu_counter-from-task_struct.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sched-remove-arch-specific-fpu_counter-from-task_struct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: sched: remove ARCH specific fpu_counter from task_struct

fpu_counter in task_struct was used only by sh/x86.  Both of these now
carry it in ARCH specific thread_struct, hence this can now be removed
from generic task_struct, shrinking it slightly for other arches.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mundt <paul.mundt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN include/linux/sched.h~sched-remove-arch-specific-fpu_counter-from-task_struct include/linux/sched.h
--- a/include/linux/sched.h~sched-remove-arch-specific-fpu_counter-from-task_struct
+++ a/include/linux/sched.h
@@ -1046,15 +1046,6 @@ struct task_struct {
 	struct hlist_head preempt_notifiers;
 #endif
 
-	/*
-	 * fpu_counter contains the number of consecutive context switches
-	 * that the FPU is used. If this is over a threshold, the lazy fpu
-	 * saving becomes unlazy to save the trap. This is an unsigned char
-	 * so that after 256 times the counter wraps and the behavior turns
-	 * lazy again; this to deal with bursty apps that only use FPU for
-	 * a short time
-	 */
-	unsigned char fpu_counter;
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	unsigned int btrace_seq;
 #endif
_

Patches currently in -mm which might be from Vineet.Gupta1@synopsys.com are

sh-move-fpu_counter-into-arch-specific-thread_struct.patch
x86-move-fpu_counter-into-arch-specific-thread_struct.patch
sched-remove-arch-specific-fpu_counter-from-task_struct.patch


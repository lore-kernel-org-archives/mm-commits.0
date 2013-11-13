From: akpm@linux-foundation.org
Subject: [merged]
 sched-remove-arch-specific-fpu_counter-from-task_struct.patch removed from
 -mm tree
Date: Wed, 13 Nov 2013 12:40:10 -0800
Message-ID: <5283e3aa.eQZAbIha34YOq4eI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab3KMUkK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgupta@synopsys.com, paul.mundt@gmail.com, mingo@kernel.org, Vineet.Gupta1@synopsys.com

Subject: [merged] sched-remove-arch-specific-fpu_counter-from-task_struct.patch removed from -mm tree
To: Vineet.Gupta1@synopsys.com,mingo@kernel.org,paul.mundt@gmail.com,vgupta@synopsys.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:10 -0800


The patch titled
     Subject: sched: remove ARCH specific fpu_counter from task_struct
has been removed from the -mm tree.  Its filename was
     sched-remove-arch-specific-fpu_counter-from-task_struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1062,15 +1062,6 @@ struct task_struct {
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

origin.patch


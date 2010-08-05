From: akpm@linux-foundation.org
Subject: + stop_machine-struct-cpu_stopper-remove-alignment-padding-on-64-bits.patch added to -mm tree
Date: Thu, 05 Aug 2010 15:07:05 -0700
Message-ID: <201008052207.o75M75GM007687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934492Ab0HEWHq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Aug 2010 18:07:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@rsk.demon.co.uk, mingo@elte.hu, peterz@infradead.org, rusty@rustcorp.com.au, tj@kernel.org


The patch titled
     stop_machine: struct cpu_stopper, remove alignment padding on 64 bits
has been added to the -mm tree.  Its filename is
     stop_machine-struct-cpu_stopper-remove-alignment-padding-on-64-bits.patch

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
Subject: stop_machine: struct cpu_stopper, remove alignment padding on 64 bits
From: Richard Kennedy <richard@rsk.demon.co.uk>

Reorder elements in structure cpu_stopper to remove alignment padding on
64 bit builds, this shrinks its size from 40 to 32 bytes saving 8 bytes
per cpu.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/stop_machine.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/stop_machine.c~stop_machine-struct-cpu_stopper-remove-alignment-padding-on-64-bits kernel/stop_machine.c
--- a/kernel/stop_machine.c~stop_machine-struct-cpu_stopper-remove-alignment-padding-on-64-bits
+++ a/kernel/stop_machine.c
@@ -35,9 +35,9 @@ struct cpu_stop_done {
 /* the actual stopper, one per every possible cpu, enabled on online cpus */
 struct cpu_stopper {
 	spinlock_t		lock;
+	bool			enabled;	/* is this stopper enabled? */
 	struct list_head	works;		/* list of pending works */
 	struct task_struct	*thread;	/* stopper thread */
-	bool			enabled;	/* is this stopper enabled? */
 };
 
 static DEFINE_PER_CPU(struct cpu_stopper, cpu_stopper);
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

origin.patch
linux-next.patch
timer_list-remove-alignment-padding-on-64-bit-when-config_timer_stats.patch
buffer_head-remove-redundant-test-from-wait_on_buffer.patch
writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages.patch
stop_machine-struct-cpu_stopper-remove-alignment-padding-on-64-bits.patch


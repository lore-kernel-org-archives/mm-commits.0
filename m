From: akpm@google.com
Subject: + stop_machine-make-stop_machine-safe-and-efficient-to-call-early.patch added to -mm tree
Date: Fri, 30 Sep 2011 14:06:52 -0700
Message-ID: <201109302106.p8UL6rhd023108@hpaq13.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:48997 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab1I3VH1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Sep 2011 17:07:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, a.p.zijlstra@chello.nl, hpa@linux.intel.com, htejun@gmail.com, jeremy.fitzhardinge@citrix.com, mingo@redhat.com, rostedt@goodmis.org, rusty@rustcorp.com.au


The patch titled
     Subject: stop_machine: make stop_machine safe and efficient to call early
has been added to the -mm tree.  Its filename is
     stop_machine-make-stop_machine-safe-and-efficient-to-call-early.patch

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
From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: stop_machine: make stop_machine safe and efficient to call early

Make stop_machine() safe to call early in boot, before SMP has been set
up, by simply calling the callback function directly if there's only one
CPU online.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 kernel/stop_machine.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN kernel/stop_machine.c~stop_machine-make-stop_machine-safe-and-efficient-to-call-early kernel/stop_machine.c
--- a/kernel/stop_machine.c~stop_machine-make-stop_machine-safe-and-efficient-to-call-early
+++ a/kernel/stop_machine.c
@@ -485,6 +485,17 @@ int __stop_machine(int (*fn)(void *), vo
 					    .num_threads = num_online_cpus(),
 					    .active_cpus = cpus };
 
+	if (smdata.num_threads == 1) {
+		unsigned long flags;
+		int ret;
+
+		local_save_flags(flags);
+		ret = (*fn)(data);
+		local_irq_restore(flags);
+
+		return ret;
+	}
+
 	/* Set the initial state and stop all online cpus. */
 	set_state(&smdata, STOPMACHINE_PREPARE);
 	return stop_cpus(cpu_online_mask, stop_machine_cpu_stop, &smdata);
_
Subject: Subject: stop_machine: make stop_machine safe and efficient to call early

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
linux-next.patch
stop_machine-make-stop_machine-safe-and-efficient-to-call-early.patch
stop_machine-make-stop_machine-safe-and-efficient-to-call-early-fix.patch


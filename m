From: akpm@google.com
Subject: [to-be-updated] stop_machine-make-stop_machine-safe-and-efficient-to-call-early.patch removed from -mm tree
Date: Tue, 04 Oct 2011 14:03:28 -0700
Message-ID: <201110042103.p94L3S7n000978@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:36611 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933795Ab1JDVDq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2011 17:03:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, a.p.zijlstra@chello.nl, akpm@google.com, hpa@linux.intel.com, htejun@gmail.com, jeremy.fitzhardinge@citrix.com, mingo@redhat.com, rostedt@goodmis.org, rusty@rustcorp.


The patch titled
     Subject: stop_machine: make stop_machine safe and efficient to call early
has been removed from the -mm tree.  Its filename was
     stop_machine-make-stop_machine-safe-and-efficient-to-call-early.patch

This patch was dropped because an updated version will be merged

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
From: Andrew Morton <akpm@google.com>
Subject: stop_machine-make-stop_machine-safe-and-efficient-to-call-early-fix

- add comment

- s/local_save_flags/local_irq_save/

Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <htejun@gmail.com>
From: Andrew Morton <akpm@google.com>
Subject: stop_machine-make-stop_machine-safe-and-efficient-to-call-early-fix-fix

call hard_irq_disable() too

Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 kernel/stop_machine.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN kernel/stop_machine.c~stop_machine-make-stop_machine-safe-and-efficient-to-call-early kernel/stop_machine.c
--- a/kernel/stop_machine.c~stop_machine-make-stop_machine-safe-and-efficient-to-call-early
+++ a/kernel/stop_machine.c
@@ -485,6 +485,22 @@ int __stop_machine(int (*fn)(void *), vo
 					    .num_threads = num_online_cpus(),
 					    .active_cpus = cpus };
 
+	if (smdata.num_threads == 1) {
+		/*
+		 * Handle the case where stop_machine() is called early in boot
+		 * before SMP startup.
+		 */
+		unsigned long flags;
+		int ret;
+
+		local_irq_save(flags);
+		hard_irq_disable();
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

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
linux-next.patch


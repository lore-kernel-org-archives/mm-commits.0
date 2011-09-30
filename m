From: akpm@google.com
Subject: + stop_machine-make-stop_machine-safe-and-efficient-to-call-early-fix-fix.patch added to -mm tree
Date: Fri, 30 Sep 2011 14:23:52 -0700
Message-ID: <201109302123.p8ULNr1H014560@hpaq6.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:36508 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637Ab1I3VYR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Sep 2011 17:24:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@google.com, a.p.zijlstra@chello.nl, hpa@linux.intel.com, htejun@gmail.com, jeremy.fitzhardinge@citrix.com, jeremy@goop.org, mingo@redhat.com, rostedt@goodmis.org, rusty@rustcorp.com.au


The patch titled
     Subject: stop_machine-make-stop_machine-safe-and-efficient-to-call-early-fix-fix
has been added to the -mm tree.  Its filename is
     stop_machine-make-stop_machine-safe-and-efficient-to-call-early-fix-fix.patch

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

 kernel/stop_machine.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/stop_machine.c~stop_machine-make-stop_machine-safe-and-efficient-to-call-early-fix-fix kernel/stop_machine.c
--- a/kernel/stop_machine.c~stop_machine-make-stop_machine-safe-and-efficient-to-call-early-fix-fix
+++ a/kernel/stop_machine.c
@@ -494,6 +494,7 @@ int __stop_machine(int (*fn)(void *), vo
 		int ret;
 
 		local_irq_save(flags);
+		hard_irq_disable();
 		ret = (*fn)(data);
 		local_irq_restore(flags);
 
_
Subject: Subject: stop_machine-make-stop_machine-safe-and-efficient-to-call-early-fix-fix

Patches currently in -mm which might be from akpm@google.com are

origin.patch
linux-next.patch
drivers-net-ethernet-i825xx-3c505c-fix-build-with-dynamic-debug.patch
brlocks-lglocks-clean-up-code-checkpatch-fixes.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes.patch
loop-cleanup-set_status-interface-checkpatch-fixes.patch
stop_machine-make-stop_machine-safe-and-efficient-to-call-early-fix.patch
stop_machine-make-stop_machine-safe-and-efficient-to-call-early-fix-fix.patch
treewide-use-__printf-not-__attribute__formatprintf-fix.patch


From: akpm@google.com
Subject: [folded] stop_machine-make-stop_machine-safe-and-efficient-to-call-early-fix-fix.patch removed from -mm tree
Date: Tue, 04 Oct 2011 14:03:12 -0700
Message-ID: <201110042103.p94L3DVW010760@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:36510 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757402Ab1JDVDb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2011 17:03:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@google.com, a.p.zijlstra@chello.nl, hpa@linux.intel.com, htejun@gmail.com, jeremy.fitzhardinge@citrix.com, jeremy@goop.org, mingo@redhat.com, rostedt@goodmis.org, rusty@rustcorp.c


The patch titled
     Subject: stop_machine-make-stop_machine-safe-and-efficient-to-call-early-fix-fix
has been removed from the -mm tree.  Its filename was
     stop_machine-make-stop_machine-safe-and-efficient-to-call-early-fix-fix.patch

This patch was dropped because it was folded into stop_machine-make-stop_machine-safe-and-efficient-to-call-early.patch

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

Patches currently in -mm which might be from akpm@google.com are

origin.patch
linux-next.patch
drivers-net-ethernet-i825xx-3c505c-fix-build-with-dynamic-debug.patch
brlocks-lglocks-clean-up-code-checkpatch-fixes.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes.patch
loop-cleanup-set_status-interface-checkpatch-fixes.patch
stop_machine-make-stop_machine-safe-and-efficient-to-call-early.patch
treewide-use-__printf-not-__attribute__formatprintf-fix.patch


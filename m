From: akpm@google.com
Subject: + stop_machine-fixup-cutnpaste-error-in-stopped-thread-name.patch added to -mm tree
Date: Tue, 04 Oct 2011 14:11:43 -0700
Message-ID: <201110042111.p94LBhTk011322@hpaq12.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:40649 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933642Ab1JDVMC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2011 17:12:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Ian.Campbell@citrix.com, eric.dumazet@gmail.com, hpa@linux.intel.com, htejun@gmail.com, ian.campbell@citrix.com, peterz@infradead.org


The patch titled
     From: Ian Campbell <Ian.Campbell@citrix.com>
has been added to the -mm tree.  Its filename is
     stop_machine-fixup-cutnpaste-error-in-stopped-thread-name.patch

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
From: Ian Campbell <Ian.Campbell@citrix.com>
Subject: stop_machine: fixup cut'n'paste error in stopped thread name

Noticed this while poking around.  Seems like the code was lifted a bit
more thoroughly from the migration thread mgmt code than the author of the
preceding comment intended...

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 kernel/stop_machine.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/stop_machine.c~stop_machine-fixup-cutnpaste-error-in-stopped-thread-name kernel/stop_machine.c
--- a/kernel/stop_machine.c~stop_machine-fixup-cutnpaste-error-in-stopped-thread-name
+++ a/kernel/stop_machine.c
@@ -313,7 +313,7 @@ static int __cpuinit cpu_stop_cpu_callba
 		p = kthread_create_on_node(cpu_stopper_thread,
 					   stopper,
 					   cpu_to_node(cpu),
-					   "migration/%d", cpu);
+					   "stopper/%d", cpu);
 		if (IS_ERR(p))
 			return notifier_from_errno(PTR_ERR(p));
 		get_task_struct(p);
_
Subject: From: Ian Campbell <Ian.Campbell@citrix.com>

Patches currently in -mm which might be from Ian.Campbell@citrix.com are

origin.patch
linux-next.patch
stop_machine-fixup-cutnpaste-error-in-stopped-thread-name.patch


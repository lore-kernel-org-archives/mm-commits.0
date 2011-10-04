From: akpm@google.com
Subject: [nacked] stop_machine-fixup-cutnpaste-error-in-stopped-thread-name.patch removed from -mm tree
Date: Tue, 04 Oct 2011 15:30:45 -0700
Message-ID: <201110042230.p94MUjbW022340@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:3140 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933180Ab1JDWbD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2011 18:31:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Ian.Campbell@citrix.com, eric.dumazet@gmail.com, hpa@linux.intel.com, htejun@gmail.com, ian.campbell@citrix.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     From: Ian Campbell <Ian.Campbell@citrix.com>
has been removed from the -mm tree.  Its filename was
     stop_machine-fixup-cutnpaste-error-in-stopped-thread-name.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: stop_machine: fixup cut'n'paste error in stopped thread name
From: Ian Campbell <Ian.Campbell@citrix.com>

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

Patches currently in -mm which might be from Ian.Campbell@citrix.com are

origin.patch
linux-next.patch


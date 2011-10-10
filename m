From: akpm@google.com
Subject: + oom-thaw-threads-if-oom-killed-thread-is-frozen-before-deferring.patch added to -mm tree
Date: Mon, 10 Oct 2011 15:46:25 -0700
Message-ID: <201110102246.p9AMkPVD004527@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:13279 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab1JJWrX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2011 18:47:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, oleg@redhat.com, rjw@sisk.pl


The patch titled
     Subject: oom: thaw threads if oom killed thread is frozen before deferring
has been added to the -mm tree.  Its filename is
     oom-thaw-threads-if-oom-killed-thread-is-frozen-before-deferring.patch

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
From: David Rientjes <rientjes@google.com>
Subject: oom: thaw threads if oom killed thread is frozen before deferring

If a thread has been oom killed and is frozen, thaw it before returning to
the page allocator.  Otherwise, it can stay frozen indefinitely and no
memory will be freed.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Michal Hocko <mhocko@suse.cz>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 mm/oom_kill.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/oom_kill.c~oom-thaw-threads-if-oom-killed-thread-is-frozen-before-deferring mm/oom_kill.c
--- a/mm/oom_kill.c~oom-thaw-threads-if-oom-killed-thread-is-frozen-before-deferring
+++ a/mm/oom_kill.c
@@ -32,6 +32,7 @@
 #include <linux/mempolicy.h>
 #include <linux/security.h>
 #include <linux/ptrace.h>
+#include <linux/freezer.h>
 
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
@@ -320,8 +321,11 @@ static struct task_struct *select_bad_pr
 		 * blocked waiting for another task which itself is waiting
 		 * for memory. Is there a better alternative?
 		 */
-		if (test_tsk_thread_flag(p, TIF_MEMDIE))
+		if (test_tsk_thread_flag(p, TIF_MEMDIE)) {
+			if (unlikely(frozen(p)))
+				thaw_process(p);
 			return ERR_PTR(-1UL);
+		}
 		if (!p->mm)
 			continue;
 
_
Subject: Subject: oom: thaw threads if oom killed thread is frozen before deferring

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
oom-avoid-killing-kthreads-if-they-assume-the-oom-killed-threads-mm.patch
oom-remove-oom_disable_count.patch
oom-fix-race-while-temporarily-setting-currents-oom_score_adj.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
mm-compaction-make-compact_zone_order-static.patch
oom-thaw-threads-if-oom-killed-thread-is-frozen-before-deferring.patch
cpusets-avoid-looping-when-storing-to-mems_allowed-if-one-node-remains-set.patch


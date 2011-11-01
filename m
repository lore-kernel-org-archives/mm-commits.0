From: akpm@linux-foundation.org
Subject: [merged] oom-thaw-threads-if-oom-killed-thread-is-frozen-before-deferring.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:08:13 -0700
Message-ID: <201111012108.pA1L8D5P022389@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:28713 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab1KAVJG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:09:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, khlebnikov@openvz.org, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, oleg@redhat.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: thaw threads if oom killed thread is frozen before deferring
has been removed from the -mm tree.  Its filename was
     oom-thaw-threads-if-oom-killed-thread-is-frozen-before-deferring.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: oom: thaw threads if oom killed thread is frozen before deferring

If a thread has been oom killed and is frozen, thaw it before returning to
the page allocator.  Otherwise, it can stay frozen indefinitely and no
memory will be freed.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
@@ -317,8 +318,11 @@ static struct task_struct *select_bad_pr
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

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
drm-avoid-switching-to-text-console-if-there-is-no-panic-timeout.patch
cpusets-avoid-looping-when-storing-to-mems_allowed-if-one-node-remains-set.patch


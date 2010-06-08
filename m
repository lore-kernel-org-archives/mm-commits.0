From: akpm@linux-foundation.org
Subject: + oom-move-sysctl-declarations-to-oomh.patch added to -mm tree
Date: Tue, 08 Jun 2010 14:27:56 -0700
Message-ID: <201006082127.o58LRuXM025817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932077Ab0FHV2N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jun 2010 17:28:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     oom: move sysctl declarations to oom.h
has been added to the -mm tree.  Its filename is
     oom-move-sysctl-declarations-to-oomh.patch

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
Subject: oom: move sysctl declarations to oom.h
From: David Rientjes <rientjes@google.com>

The three oom killer sysctl variables (sysctl_oom_dump_tasks,
sysctl_oom_kill_allocating_task, and sysctl_panic_on_oom) are better
declared in include/linux/oom.h rather than kernel/sysctl.c.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    5 +++++
 kernel/sysctl.c     |    4 +---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN include/linux/oom.h~oom-move-sysctl-declarations-to-oomh include/linux/oom.h
--- a/include/linux/oom.h~oom-move-sysctl-declarations-to-oomh
+++ a/include/linux/oom.h
@@ -44,5 +44,10 @@ static inline void oom_killer_enable(voi
 {
 	oom_killer_disabled = false;
 }
+
+/* sysctls */
+extern int sysctl_oom_dump_tasks;
+extern int sysctl_oom_kill_allocating_task;
+extern int sysctl_panic_on_oom;
 #endif /* __KERNEL__*/
 #endif /* _INCLUDE_LINUX_OOM_H */
diff -puN kernel/sysctl.c~oom-move-sysctl-declarations-to-oomh kernel/sysctl.c
--- a/kernel/sysctl.c~oom-move-sysctl-declarations-to-oomh
+++ a/kernel/sysctl.c
@@ -55,6 +55,7 @@
 #include <linux/perf_event.h>
 #include <linux/kprobes.h>
 #include <linux/pipe_fs_i.h>
+#include <linux/oom.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -87,9 +88,6 @@
 /* External variables not in a header file. */
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
-extern int sysctl_panic_on_oom;
-extern int sysctl_oom_kill_allocating_task;
-extern int sysctl_oom_dump_tasks;
 extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
_

Patches currently in -mm which might be from rientjes@google.com are

avr32-invoke-oom-killer-from-page-fault.patch
oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-dump_tasks-use-find_lock_task_mm-too.patch
oom-pf_exiting-check-should-take-mm-into-account.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-enable-oom-tasklist-dump-by-default.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-extract-panic-helper-function.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-move-sysctl-declarations-to-oomh.patch


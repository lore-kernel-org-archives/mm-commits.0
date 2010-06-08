From: akpm@linux-foundation.org
Subject: + oom-enable-oom-tasklist-dump-by-default.patch added to -mm tree
Date: Tue, 08 Jun 2010 14:13:48 -0700
Message-ID: <201006082113.o58LDmoo025156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756303Ab0FHVOB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jun 2010 17:14:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     oom: enable oom tasklist dump by default
has been added to the -mm tree.  Its filename is
     oom-enable-oom-tasklist-dump-by-default.patch

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
Subject: oom: enable oom tasklist dump by default
From: David Rientjes <rientjes@google.com>

The oom killer tasklist dump, enabled with the oom_dump_tasks sysctl, is
very helpful information in diagnosing why a user's task has been killed. 
It emits useful information such as each eligible thread's memory usage
that can determine why the system is oom, so it should be enabled by
default.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    2 +-
 mm/oom_kill.c               |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/sysctl/vm.txt~oom-enable-oom-tasklist-dump-by-default Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~oom-enable-oom-tasklist-dump-by-default
+++ a/Documentation/sysctl/vm.txt
@@ -511,7 +511,7 @@ information may not be desired.
 If this is set to non-zero, this information is shown whenever the
 OOM killer actually kills a memory-hogging task.
 
-The default value is 0.
+The default value is 1 (enabled).
 
 ==============================================================
 
diff -puN mm/oom_kill.c~oom-enable-oom-tasklist-dump-by-default mm/oom_kill.c
--- a/mm/oom_kill.c~oom-enable-oom-tasklist-dump-by-default
+++ a/mm/oom_kill.c
@@ -32,7 +32,7 @@
 
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
-int sysctl_oom_dump_tasks;
+int sysctl_oom_dump_tasks = 1;
 static DEFINE_SPINLOCK(zone_scan_lock);
 /* #define DEBUG */
 
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


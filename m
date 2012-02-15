From: akpm@linux-foundation.org
Subject: + mm-oom-introduce-independent-oom-killer-ratelimit-state.patch added to -mm tree
Date: Tue, 14 Feb 2012 16:09:21 -0800
Message-ID: <20120215000921.97D0FA0245@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:52775 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab2BOAJW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2012 19:09:22 -0500
Received: by ggnp1 with SMTP id p1so74919ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2012 16:09:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     Subject: mm, oom: introduce independent oom killer ratelimit state
has been added to the -mm tree.  Its filename is
     mm-oom-introduce-independent-oom-killer-ratelimit-state.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: introduce independent oom killer ratelimit state

printk_ratelimit() uses the global ratelimit state for all printks.  The
oom killer should not be subjected to this state just because another
subsystem or driver may be flooding the kernel log.

This patch introduces printk ratelimiting specifically for the oom killer.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/oom_kill.c~mm-oom-introduce-independent-oom-killer-ratelimit-state mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-introduce-independent-oom-killer-ratelimit-state
+++ a/mm/oom_kill.c
@@ -34,6 +34,7 @@
 #include <linux/ptrace.h>
 #include <linux/freezer.h>
 #include <linux/ftrace.h>
+#include <linux/ratelimit.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/oom.h>
@@ -444,6 +445,8 @@ static void oom_kill_process(struct task
 	struct task_struct *t = p;
 	struct mm_struct *mm;
 	unsigned int victim_points = 0;
+	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
+					      DEFAULT_RATELIMIT_BURST);
 
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
@@ -454,7 +457,7 @@ static void oom_kill_process(struct task
 		return;
 	}
 
-	if (printk_ratelimit())
+	if (__ratelimit(&oom_rs))
 		dump_header(p, gfp_mask, order, memcg, nodemask);
 
 	task_lock(p);
_
Subject: Subject: mm, oom: introduce independent oom killer ratelimit state

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
slab-introduce-kmalloc_array.patch
mm-oom-avoid-looping-when-chosen-thread-detaches-its-mm.patch
mm-oom-fold-oom_kill_task-into-oom_kill_process.patch
mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting.patch
mm-oom-introduce-independent-oom-killer-ratelimit-state.patch
mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch
pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
mm-introduce-pmd_to_pte_t.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch
memcg-remove-unnecessary-thp-check-in-page-stat-accounting.patch
signal-give-send_sig_forced-more-power-to-beat-signal_unkillable.patch
signal-cosmetic-s-from_ancestor_ns-force-in-prepare_signal-paths.patch
signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig.patch
signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced.patch


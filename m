From: akpm@linux-foundation.org
Subject: + mm-correctly-synchronize-rss-counters-at-exit-exec-set-task-exit-code-before-complete_vfork_done.patch added to -mm tree
Date: Thu, 12 Apr 2012 16:34:40 -0700
Message-ID: <20120412233440.A6779A02AD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:63962 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964999Ab2DLXen (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Apr 2012 19:34:43 -0400
Received: by laai8 with SMTP id i8so112114laa.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Apr 2012 16:34:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, markus@trippelsdorf.de, oleg@redhat.com


The patch titled
     Subject: mm: set task exit code before complete_vfork_done()
has been added to the -mm tree.  Its filename is
     mm-correctly-synchronize-rss-counters-at-exit-exec-set-task-exit-code-before-complete_vfork_done.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: set task exit code before complete_vfork_done()

kthread_stop() uses task->vfork_done for synchronization.  The exiting
kthread shouldn't do complete_vfork_done() until it sets ->exit_code.

fix for mm-correctly-synchronize-rss-counters-at-exit-exec.patch

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/exit.c~mm-correctly-synchronize-rss-counters-at-exit-exec-set-task-exit-code-before-complete_vfork_done kernel/exit.c
--- a/kernel/exit.c~mm-correctly-synchronize-rss-counters-at-exit-exec-set-task-exit-code-before-complete_vfork_done
+++ a/kernel/exit.c
@@ -960,6 +960,9 @@ void do_exit(long code)
 
 	acct_update_integrals(tsk);
 
+	/* Set exit_code before complete_vfork_done() in mm_release() */
+	tsk->exit_code = code;
+
 	/* Release mm and sync mm's RSS info before statistics gathering */
 	mm_release(tsk, tsk->mm);
 
@@ -975,7 +978,6 @@ void do_exit(long code)
 		tty_audit_exit();
 	audit_free(tsk);
 
-	tsk->exit_code = code;
 	taskstats_exit(tsk, group_dead);
 
 	exit_mm(tsk);
_
Subject: Subject: mm: set task exit code before complete_vfork_done()

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-fix.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-set-task-exit-code-before-complete_vfork_done.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-remove-reclaim_mode_t.patch
mm-remove-swap-token-code.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
mm-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch


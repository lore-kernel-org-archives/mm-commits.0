From: akpm@linux-foundation.org
Subject: + mm-oom-do-not-schedule-if-current-has-been-killed.patch added to -mm tree
Date: Tue, 19 Jun 2012 15:05:38 -0700
Message-ID: <20120619220538.C3028A0123@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:51398 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab2FSWFl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jun 2012 18:05:41 -0400
Received: by wgbdt11 with SMTP id dt11so384153wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 19 Jun 2012 15:05:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com


The patch titled
     Subject: mm, oom: do not schedule if current has been killed
has been added to the -mm tree.  Its filename is
     mm-oom-do-not-schedule-if-current-has-been-killed.patch

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
Subject: mm, oom: do not schedule if current has been killed

The oom killer currently schedules away from current in an uninterruptible
sleep if it does not have access to memory reserves.  It's possible that
current was killed because it shares memory with the oom killed thread or
because it was killed by the user in the interim, however.

This patch only schedules away from current if it does not have a pending
kill, i.e.  if it does not share memory with the oom killed thread.  It's
possible that it will immediately retry its memory allocation and fail,
but it will immediately be given access to memory reserves if it calls the
oom killer again.

This prevents the delay of memory freeing when threads that share memory
with the oom killed thread get unnecessarily scheduled.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-do-not-schedule-if-current-has-been-killed mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-do-not-schedule-if-current-has-been-killed
+++ a/mm/oom_kill.c
@@ -745,11 +745,11 @@ out:
 	read_unlock(&tasklist_lock);
 
 	/*
-	 * Give "p" a good chance of killing itself before we
-	 * retry to allocate memory unless "p" is current
+	 * Give the killed threads a good chance of exiting before trying to
+	 * allocate memory again.
 	 */
-	if (killed && !test_thread_flag(TIF_MEMDIE))
-		schedule_timeout_uninterruptible(1);
+	if (killed)
+		schedule_timeout_killable(1);
 }
 
 /*
@@ -764,6 +764,5 @@ void pagefault_out_of_memory(void)
 		out_of_memory(NULL, 0, 0, NULL, false);
 		clear_system_oom();
 	}
-	if (!test_thread_flag(TIF_MEMDIE))
-		schedule_timeout_uninterruptible(1);
+	schedule_timeout_killable(1);
 }
_
Subject: Subject: mm, oom: do not schedule if current has been killed

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
mm-oom-fix-and-cleanup-oom-score-calculations.patch
mm-thp-print-useful-information-when-mmap_sem-is-unlocked-in-zap_pmd_range.patch
slab-move-full-state-transition-to-an-initcall.patch
mm-buddy-cleanup-on-should_fail_alloc_page.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch
mm-oom-do-not-schedule-if-current-has-been-killed.patch


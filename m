From: akpm@linux-foundation.org
Subject: [merged] mm-correctly-synchronize-rss-counters-at-exit-exec.patch removed from -mm tree
Date: Thu, 21 Jun 2012 12:25:31 -0700
Message-ID: <20120621192531.6CFB4A00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:46143 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760107Ab2FUTZc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:25:32 -0400
Received: by yenl3 with SMTP id l3so96567yen.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:25:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, markus@trippelsdorf.de, oleg@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: correctly synchronize rss-counters at exit/exec
has been removed from the -mm tree.  Its filename was
     mm-correctly-synchronize-rss-counters-at-exit-exec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: correctly synchronize rss-counters at exit/exec

do_exit() and exec_mmap() call sync_mm_rss() before mm_release() does
put_user(clear_child_tid) which can update task->rss_stat and thus make
mm->rss_stat inconsistent.  This triggers the "BUG:" printk in check_mm().

Let's fix this bug in the safest way, and optimize/cleanup this later.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c     |    2 +-
 kernel/exit.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/exec.c~mm-correctly-synchronize-rss-counters-at-exit-exec fs/exec.c
--- a/fs/exec.c~mm-correctly-synchronize-rss-counters-at-exit-exec
+++ a/fs/exec.c
@@ -819,10 +819,10 @@ static int exec_mmap(struct mm_struct *m
 	/* Notify parent that we're no longer interested in the old VM */
 	tsk = current;
 	old_mm = current->mm;
-	sync_mm_rss(old_mm);
 	mm_release(tsk, old_mm);
 
 	if (old_mm) {
+		sync_mm_rss(old_mm);
 		/*
 		 * Make sure that if there is a core dump in progress
 		 * for the old mm, we get out and die instead of going
diff -puN kernel/exit.c~mm-correctly-synchronize-rss-counters-at-exit-exec kernel/exit.c
--- a/kernel/exit.c~mm-correctly-synchronize-rss-counters-at-exit-exec
+++ a/kernel/exit.c
@@ -643,6 +643,7 @@ static void exit_mm(struct task_struct *
 	mm_release(tsk, mm);
 	if (!mm)
 		return;
+	sync_mm_rss(mm);
 	/*
 	 * Serialize with any possible pending coredump.
 	 * We must hold mmap_sem around checking core_state
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
c-r-prctl-less-paranoid-prctl_set_mm_exe_file.patch


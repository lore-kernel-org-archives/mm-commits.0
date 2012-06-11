From: akpm@linux-foundation.org
Subject: + mm-correctly-synchronize-rss-counters-at-exit-exec.patch added to -mm tree
Date: Mon, 11 Jun 2012 15:48:33 -0700
Message-ID: <20120611224833.AE930A02BF@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:61767 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab2FKWsf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 18:48:35 -0400
Received: by vbnl22 with SMTP id l22so423516vbn.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 15:48:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, markus@trippelsdorf.de, oleg@redhat.com, stable@vger.kernel.org


The patch titled
     From: Konstantin Khlebnikov <khlebnikov@openvz.org>
has been added to the -mm tree.  Its filename is
     mm-correctly-synchronize-rss-counters-at-exit-exec.patch

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
Subject: From: Konstantin Khlebnikov <khlebnikov@openvz.org>

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
memcg-fix-use_hierarchy-css_is_ancestor-oops-regression.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch


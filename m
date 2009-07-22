From: akpm@linux-foundation.org
Subject: + task_struct-cleanup-make-binfmt-module-get-and-put-per-signal_struct.patch added to -mm tree
Date: Wed, 22 Jul 2009 13:23:38 -0700
Message-ID: <200907222023.n6MKNcgH026779@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753131AbZGVUX5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Jul 2009 16:23:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: h-shimamoto@ct.jp.nec.com, oleg@redhat.com, roland@redhat.com


The patch titled
     task_struct cleanup: make binfmt module get and put per signal_struct
has been added to the -mm tree.  Its filename is
     task_struct-cleanup-make-binfmt-module-get-and-put-per-signal_struct.patch

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
Subject: task_struct cleanup: make binfmt module get and put per signal_struct
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

The binfmt is a member of signal_struct, so it can be handled per
signal_struct instead of task_struct.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 --
 kernel/fork.c |   12 ++++++------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff -puN kernel/exit.c~task_struct-cleanup-make-binfmt-module-get-and-put-per-signal_struct kernel/exit.c
--- a/kernel/exit.c~task_struct-cleanup-make-binfmt-module-get-and-put-per-signal_struct
+++ a/kernel/exit.c
@@ -977,8 +977,6 @@ NORET_TYPE void do_exit(long code)
 		disassociate_ctty(1);
 
 	module_put(task_thread_info(tsk)->exec_domain->module);
-	if (tsk->signal->binfmt)
-		module_put(tsk->signal->binfmt->module);
 
 	proc_exit_connector(tsk);
 
diff -puN kernel/fork.c~task_struct-cleanup-make-binfmt-module-get-and-put-per-signal_struct kernel/fork.c
--- a/kernel/fork.c~task_struct-cleanup-make-binfmt-module-get-and-put-per-signal_struct
+++ a/kernel/fork.c
@@ -859,6 +859,10 @@ static int copy_signal(unsigned long clo
 	sig->tty_old_pgrp = NULL;
 	sig->tty = NULL;
 	sig->binfmt = current->signal->binfmt;
+	if (sig->binfmt && !try_module_get(sig->binfmt->module)) {
+		kmem_cache_free(signal_cachep, sig);
+		return -EAGAIN;
+	}
 
 	sig->utime = sig->stime = sig->cutime = sig->cstime = cputime_zero;
 	sig->gtime = cputime_zero;
@@ -888,6 +892,8 @@ void __cleanup_signal(struct signal_stru
 {
 	thread_group_cputime_free(sig);
 	tty_kref_put(sig->tty);
+	if (sig->binfmt)
+		module_put(sig->binfmt->module);
 	kmem_cache_free(signal_cachep, sig);
 }
 
@@ -1027,9 +1033,6 @@ static struct task_struct *copy_process(
 	if (!try_module_get(task_thread_info(p)->exec_domain->module))
 		goto bad_fork_cleanup_count;
 
-	if (p->signal->binfmt && !try_module_get(p->signal->binfmt->module))
-		goto bad_fork_cleanup_put_domain;

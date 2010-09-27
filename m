From: akpm@linux-foundation.org
Subject: + ptrace-annotate-lock-context-change-on-exit_ptrace.patch added to -mm tree
Date: Mon, 27 Sep 2010 14:14:19 -0700
Message-ID: <201009272114.o8RLEJll017034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755887Ab0I0VPG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Sep 2010 17:15:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, mingo@elte.hu, oleg@redhat.com, roland@redhat.com


The patch titled
     ptrace: annotate lock context change on exit_ptrace()
has been added to the -mm tree.  Its filename is
     ptrace-annotate-lock-context-change-on-exit_ptrace.patch

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
Subject: ptrace: annotate lock context change on exit_ptrace()
From: Namhyung Kim <namhyung@gmail.com>

exit_ptrace() releases and regrabs tasklist_lock but was missing proper
annotation.  Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/ptrace.c~ptrace-annotate-lock-context-change-on-exit_ptrace kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-annotate-lock-context-change-on-exit_ptrace
+++ a/kernel/ptrace.c
@@ -329,6 +329,8 @@ int ptrace_detach(struct task_struct *ch
  * and reacquire the lock.
  */
 void exit_ptrace(struct task_struct *tracer)
+	__releases(&tasklist_lock)
+	__acquires(&tasklist_lock)
 {
 	struct task_struct *p, *n;
 	LIST_HEAD(ptrace_dead);
_

Patches currently in -mm which might be from namhyung@gmail.com are

linux-next.patch
init-mark-__user-address-space-on-string-literals.patch
kernel-userc-add-lock-release-annotation-on-free_user.patch
printk-fixup-declaration-of-kmsg_reasons.patch
printk-add-lock-context-annotation.patch
printk-change-type-of-boot_delay-to-int.patch
printk-declare-printk_ratelimit_state-in-ratelimith.patch
printk-declare-printk_ratelimit_state-in-ratelimith-fix.patch
ptrace-annotate-lock-context-change-on-exit_ptrace.patch
signals-annotate-lock_task_sighand.patch
signals-annotate-lock-context-change-on-ptrace_stop.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch


From: akpm@linux-foundation.org
Subject: + exit-add-lock-context-annotation-on-find_new_reaper.patch added to -mm tree
Date: Tue, 07 Sep 2010 15:16:08 -0700
Message-ID: <201009072216.o87MG8gP009651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756049Ab0IGWQo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 18:16:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, roland@redhat.com


The patch titled
     exit: add lock context annotation on find_new_reaper()
has been added to the -mm tree.  Its filename is
     exit-add-lock-context-annotation-on-find_new_reaper.patch

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
Subject: exit: add lock context annotation on find_new_reaper()
From: Namhyung Kim <namhyung@gmail.com>

find_new_reaper() releases and regrabs tasklist_lock but was missing
proper annotations.  Add it.  This remove following sparse warning:

 warning: context imbalance in 'find_new_reaper' - unexpected unlock

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/exit.c~exit-add-lock-context-annotation-on-find_new_reaper kernel/exit.c
--- a/kernel/exit.c~exit-add-lock-context-annotation-on-find_new_reaper
+++ a/kernel/exit.c
@@ -705,6 +705,8 @@ static void exit_mm(struct task_struct *
  * space.
  */
 static struct task_struct *find_new_reaper(struct task_struct *father)
+	__releases(&tasklist_lock)
+	__acquires(&tasklist_lock)
 {
 	struct pid_namespace *pid_ns = task_active_pid_ns(father);
 	struct task_struct *thread;
_

Patches currently in -mm which might be from namhyung@gmail.com are

linux-next.patch
init-mark-__user-address-space-on-string-literals.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch


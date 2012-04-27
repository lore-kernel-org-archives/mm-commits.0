From: akpm@linux-foundation.org
Subject: + um-fix-possible-race-on-task-mm.patch added to -mm tree
Date: Thu, 26 Apr 2012 17:06:08 -0700
Message-ID: <20120427000609.0EB6BA042D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:60768 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758578Ab2D0AGK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Apr 2012 20:06:10 -0400
Received: by mail-qa0-f74.google.com with SMTP id g24so7213qab.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Apr 2012 17:06:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton.vorontsov@linaro.org, oleg@redhat.com, richard@nod.at


The patch titled
     Subject: um: fix possible race on task->mm
has been added to the -mm tree.  Its filename is
     um-fix-possible-race-on-task-mm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: um: fix possible race on task->mm

Checking for task->mm is dangerous as ->mm might disappear (exit_mm()
assigns NULL under task_lock(), so tasklist lock is not enough).

We can't use get_task_mm()/mmput() pair as mmput() might sleep, so let's
take the task lock while we care about its mm.

Note that we should also use find_lock_task_mm() to check all process'
threads for a valid mm, but for uml we'll do it in a separate patch.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/reboot.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN arch/um/kernel/reboot.c~um-fix-possible-race-on-task-mm arch/um/kernel/reboot.c
--- a/arch/um/kernel/reboot.c~um-fix-possible-race-on-task-mm
+++ a/arch/um/kernel/reboot.c
@@ -25,10 +25,13 @@ static void kill_off_processes(void)
 
 		read_lock(&tasklist_lock);
 		for_each_process(p) {
-			if (p->mm == NULL)
+			task_lock(p);
+			if (!p->mm) {
+				task_unlock(p);
 				continue;

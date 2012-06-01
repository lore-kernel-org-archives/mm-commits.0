From: akpm@linux-foundation.org
Subject: [merged] um-fix-possible-race-on-task-mm.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:34:26 -0700
Message-ID: <20120601193426.62D07A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:41153 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804Ab2FATe2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:34:28 -0400
Received: by eeit10 with SMTP id t10so140727eei.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:34:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton.vorontsov@linaro.org, oleg@redhat.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     Subject: um: fix possible race on task->mm
has been removed from the -mm tree.  Its filename was
     um-fix-possible-race-on-task-mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

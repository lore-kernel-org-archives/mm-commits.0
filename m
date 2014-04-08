From: akpm@linux-foundation.org
Subject: [merged] wait-completely-ignore-the-exit_dead-tasks.patch removed from -mm tree
Date: Tue, 08 Apr 2014 14:21:09 -0700
Message-ID: <53446845.hFvqVfTkC7zHhueg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56940 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757295AbaDHVVK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:21:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tj@kernel.org, roland@hack.frob.com, mschmidt@redhat.com, lpoetter@redhat.com, jan.kratochvil@redhat.com, oleg@redhat.com

Subject: [merged] wait-completely-ignore-the-exit_dead-tasks.patch removed from -mm tree
To: oleg@redhat.com,jan.kratochvil@redhat.com,lpoetter@redhat.com,mschmidt@redhat.com,roland@hack.frob.com,tj@kernel.org,viro@ZenIV.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:21:09 -0700


The patch titled
     Subject: wait: completely ignore the EXIT_DEAD tasks
has been removed from the -mm tree.  Its filename was
     wait-completely-ignore-the-exit_dead-tasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: wait: completely ignore the EXIT_DEAD tasks

Now that EXIT_DEAD is the terminal state it doesn't make sense to call
eligible_child() or security_task_wait() if the task is really dead.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Tested-by: Michal Schmidt <mschmidt@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Lennart Poettering <lpoetter@redhat.com>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN kernel/exit.c~wait-completely-ignore-the-exit_dead-tasks kernel/exit.c
--- a/kernel/exit.c~wait-completely-ignore-the-exit_dead-tasks
+++ a/kernel/exit.c
@@ -1329,7 +1329,12 @@ static int wait_task_continued(struct wa
 static int wait_consider_task(struct wait_opts *wo, int ptrace,
 				struct task_struct *p)
 {
-	int ret = eligible_child(wo, p);
+	int ret;
+
+	if (unlikely(p->exit_state == EXIT_DEAD))
+		return 0;
+
+	ret = eligible_child(wo, p);
 	if (!ret)
 		return ret;
 
@@ -1347,10 +1352,6 @@ static int wait_consider_task(struct wai
 		return 0;
 	}
 
-	/* dead body doesn't have much to contribute */
-	if (unlikely(p->exit_state == EXIT_DEAD))
-		return 0;

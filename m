From: akpm@linux-foundation.org
Subject: + wait-completely-ignore-the-exit_dead-tasks.patch added to -mm
 tree
Date: Fri, 21 Feb 2014 13:39:20 -0800
Message-ID: <5307c788.No9m9qlAPOfn+E1S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165AbaBUVjV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 16:39:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tj@kernel.org, roland@hack.frob.com, mschmidt@redhat.com, lpoetter@redhat.com, jan.kratochvil@redhat.com, oleg@redhat.com

Subject: + wait-completely-ignore-the-exit_dead-tasks.patch added to -mm tree
To: oleg@redhat.com,jan.kratochvil@redhat.com,lpoetter@redhat.com,mschmidt@redhat.com,roland@hack.frob.com,tj@kernel.org,viro@ZenIV.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 13:39:20 -0800


The patch titled
     Subject: wait: completely ignore the EXIT_DEAD tasks
has been added to the -mm tree.  Its filename is
     wait-completely-ignore-the-exit_dead-tasks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/wait-completely-ignore-the-exit_dead-tasks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/wait-completely-ignore-the-exit_dead-tasks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1331,7 +1331,12 @@ static int wait_task_continued(struct wa
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
 
@@ -1349,10 +1354,6 @@ static int wait_consider_task(struct wai
 		return 0;
 	}
 
-	/* dead body doesn't have much to contribute */
-	if (unlikely(p->exit_state == EXIT_DEAD))
-		return 0;

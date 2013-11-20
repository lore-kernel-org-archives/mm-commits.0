From: akpm@linux-foundation.org
Subject: + fork-no-need-to-initialize-child-exit_state.patch added to -mm
 tree
Date: Wed, 20 Nov 2013 14:03:54 -0800
Message-ID: <528d31ca.UJasuUgLlEiMGIUh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab3KTWDz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Nov 2013 17:03:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, peterz@infradead.org, mingo@kernel.org, geert@linux-m68k.org, David.Laight@ACULAB.COM, oleg@redhat.com

Subject: + fork-no-need-to-initialize-child-exit_state.patch added to -mm tree
To: oleg@redhat.com,David.Laight@ACULAB.COM,geert@linux-m68k.org,mingo@kernel.org,peterz@infradead.org,tj@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 20 Nov 2013 14:03:54 -0800


The patch titled
     Subject: fork: no need to initialize child->exit_state
has been added to the -mm tree.  Its filename is
     fork-no-need-to-initialize-child-exit_state.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fork-no-need-to-initialize-child-exit_state.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fork-no-need-to-initialize-child-exit_state.patch

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
Subject: fork: no need to initialize child->exit_state

A zombie task obviously can't fork(), remove the unnecessary
initialization of child->exit_state.  It is zero anyway after
dup_task_struct().

Note: copy_process() is huge and it has a lot of chaotic initializations,
probably it makes sense to move them into the new helper called by
dup_task_struct().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/fork.c~fork-no-need-to-initialize-child-exit_state kernel/fork.c
--- a/kernel/fork.c~fork-no-need-to-initialize-child-exit_state
+++ a/kernel/fork.c
@@ -1402,13 +1402,11 @@ static struct task_struct *copy_process(
 		p->tgid = p->pid;
 	}
 
-	p->pdeath_signal = 0;
-	p->exit_state = 0;

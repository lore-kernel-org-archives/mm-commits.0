From: akpm@linux-foundation.org
Subject: [merged] ptrace-wait_task_zombie-do-not-account-traced-sub-threads.patch removed from -mm tree
Date: Mon, 22 Jun 2009 10:00:26 -0700
Message-ID: <200906221700.n5MH0QMn009772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753677AbZFVRB0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 13:01:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, a.p.zijlstra@chello.nl, roland@redhat.com, sgruszka@redhat.com, vmayatsk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: wait_task_zombie: do not account traced sub-threads
has been removed from the -mm tree.  Its filename was
     ptrace-wait_task_zombie-do-not-account-traced-sub-threads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: wait_task_zombie: do not account traced sub-threads
From: Oleg Nesterov <oleg@redhat.com>

The bug is ancient.

If we trace the sub-thread of our natural child and this sub-thread exits,
we update parent->signal->cxxx fields.  But we should not do this until
the whole thread-group exits, otherwise we account this thread (and all
other live threads) twice.

Add the task_detached() check.  No need to check thread_group_empty(),
wait_consider_task()->delay_group_leader() already did this.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Vitaly Mayatskikh <vmayatsk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/exit.c~ptrace-wait_task_zombie-do-not-account-traced-sub-threads kernel/exit.c
--- a/kernel/exit.c~ptrace-wait_task_zombie-do-not-account-traced-sub-threads
+++ a/kernel/exit.c
@@ -1197,8 +1197,11 @@ static int wait_task_zombie(struct wait_
 	}
 
 	traced = ptrace_reparented(p);

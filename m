From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_failure-dont-send-bus_mceerr_ao-for-action-required-error.patch
 removed from -mm tree
Date: Tue, 02 Jun 2020 14:41:15 -0700
Message-ID: <20200602214115.dD-BM67fS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728226AbgFBVlQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:41:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, naoya.horiguchi@nec.com, pankaj.gupta.linux@gmail.com, wetp.zy@linux.alibaba.com


The patch titled
     Subject: mm, memory_failure: don't send BUS_MCEERR_AO for action required error
has been removed from the -mm tree.  Its filename was
     mm-memory_failure-dont-send-bus_mceerr_ao-for-action-required-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wetp Zhang <wetp.zy@linux.alibaba.com>
Subject: mm, memory_failure: don't send BUS_MCEERR_AO for action required error

Some processes dont't want to be killed early, but in "Action Required"
case, those also may be killed by BUS_MCEERR_AO when sharing memory with
other which is accessing the fail memory.  And sending SIGBUS with
BUS_MCEERR_AO for action required error is strange, so ignore the
non-current processes here.

Link: http://lkml.kernel.org/r/1590817116-21281-1-git-send-email-wetp.zy@linux.alibaba.com
Signed-off-by: Wetp Zhang <wetp.zy@linux.alibaba.com>
Suggested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/memory-failure.c~mm-memory_failure-dont-send-bus_mceerr_ao-for-action-required-error
+++ a/mm/memory-failure.c
@@ -210,14 +210,17 @@ static int kill_proc(struct to_kill *tk,
 {
 	struct task_struct *t = tk->tsk;
 	short addr_lsb = tk->size_shift;
-	int ret;
+	int ret = 0;
 
-	pr_err("Memory failure: %#lx: Sending SIGBUS to %s:%d due to hardware memory corruption\n",
-		pfn, t->comm, t->pid);
+	if ((t->mm == current->mm) || !(flags & MF_ACTION_REQUIRED))
+		pr_err("Memory failure: %#lx: Sending SIGBUS to %s:%d due to hardware memory corruption\n",
+			pfn, t->comm, t->pid);
 
-	if ((flags & MF_ACTION_REQUIRED) && t->mm == current->mm) {
-		ret = force_sig_mceerr(BUS_MCEERR_AR, (void __user *)tk->addr,
-				       addr_lsb);
+	if (flags & MF_ACTION_REQUIRED) {
+		if (t->mm == current->mm)
+			ret = force_sig_mceerr(BUS_MCEERR_AR,
+					 (void __user *)tk->addr, addr_lsb);
+		/* send no signal to non-current processes */
 	} else {
 		/*
 		 * Don't use force here, it's convenient if the signal
_

Patches currently in -mm which might be from wetp.zy@linux.alibaba.com are

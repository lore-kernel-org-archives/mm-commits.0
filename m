From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated]
 mm-memory_failure-only-send-bus_mceerr_ao-to-early-kill-process.patch
 removed from -mm tree
Date: Wed, 27 May 2020 20:09:27 -0700
Message-ID: <20200528030927.QZ8x6QbT2%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgE1DJ2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 May 2020 23:09:28 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nao.horiguchi@gmail.com, naoya.horiguchi@nec.com, wetpzy@gmail.com


The patch titled
     Subject: mm, memory_failure: only send BUS_MCEERR_AO to early-kill process
has been removed from the -mm tree.  Its filename was
     mm-memory_failure-only-send-bus_mceerr_ao-to-early-kill-process.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Zhang Yi <wetpzy@gmail.com>
Subject: mm, memory_failure: only send BUS_MCEERR_AO to early-kill process

If a process don't need early-kill, it may not care the BUS_MCEERR_AO. 
Let the process to be killed when it really access the corrupted memory.

Link: http://lkml.kernel.org/r/1590476801-19882-1-git-send-email-wetp.zy@linux.alibaba.com
Signed-off-by: Zhang Yi <wetpzy@gmail.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-memory_failure-only-send-bus_mceerr_ao-to-early-kill-process
+++ a/mm/memory-failure.c
@@ -210,7 +210,7 @@ static int kill_proc(struct to_kill *tk,
 {
 	struct task_struct *t = tk->tsk;
 	short addr_lsb = tk->size_shift;
-	int ret;
+	int ret = 0;
 
 	pr_err("Memory failure: %#lx: Sending SIGBUS to %s:%d due to hardware memory corruption\n",
 		pfn, t->comm, t->pid);
@@ -225,8 +225,9 @@ static int kill_proc(struct to_kill *tk,
 		 * This could cause a loop when the user sets SIGBUS
 		 * to SIG_IGN, but hopefully no one will do that?
 		 */
-		ret = send_sig_mceerr(BUS_MCEERR_AO, (void __user *)tk->addr,
-				      addr_lsb, t);  /* synchronous? */
+		if ((t->flags & PF_MCE_PROCESS) && (t->flags & PF_MCE_EARLY))
+			ret = send_sig_mceerr(BUS_MCEERR_AO,
+				(void __user *)tk->addr, addr_lsb, t);
 	}
 	if (ret < 0)
 		pr_info("Memory failure: Error sending signal to %s:%d: %d\n",
_

Patches currently in -mm which might be from wetpzy@gmail.com are

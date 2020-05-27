From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-memory_failure-only-send-bus_mceerr_ao-to-early-kill-process.patch added
 to -mm tree
Date: Wed, 27 May 2020 16:52:39 -0700
Message-ID: <20200527235239.79ZbRwDPA%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725613AbgE0Xwn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 May 2020 19:52:43 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nao.horiguchi@gmail.com, naoya.horiguchi@nec.com, wetpzy@gmail.com


The patch titled
     Subject: mm, memory_failure: only send BUS_MCEERR_AO to early-kill process
has been added to the -mm tree.  Its filename is
     mm-memory_failure-only-send-bus_mceerr_ao-to-early-kill-process.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_failure-only-send-bus_mceerr_ao-to-early-kill-process.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_failure-only-send-bus_mceerr_ao-to-early-kill-process.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memory_failure-only-send-bus_mceerr_ao-to-early-kill-process.patch

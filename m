From: akpm@linux-foundation.org
Subject: [patch 2/6] kernel/kthread.c: kthread_worker: don't hog the cpu
Date: Thu, 31 Aug 2017 16:15:23 -0700
Message-ID: <59a8988b.D0872Ct61+7L1p9Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52884 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751776AbdHaXPY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Aug 2017 19:15:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, shli@fb.com, mingo@kernel.org, oleg@redhat.com, pmladek@suse.com, tglx@linutronix.de, tj@kernel.org

From: Shaohua Li <shli@fb.com>
Subject: kernel/kthread.c: kthread_worker: don't hog the cpu

If the worker thread continues getting work, it will hog the cpu and rcu
stall complains.  Make it a good citizen.  This is triggered in a loop
block device test.

Link: http://lkml.kernel.org/r/5de0a179b3184e1a2183fc503448b0269f24d75b.1503697127.git.shli@fb.com
Signed-off-by: Shaohua Li <shli@fb.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/kthread.c~kthread_worker-dont-hog-the-cpu kernel/kthread.c
--- a/kernel/kthread.c~kthread_worker-dont-hog-the-cpu
+++ a/kernel/kthread.c
@@ -637,6 +637,7 @@ repeat:
 		schedule();
 
 	try_to_freeze();
+	cond_resched();
 	goto repeat;
 }
 EXPORT_SYMBOL_GPL(kthread_worker_fn);
_

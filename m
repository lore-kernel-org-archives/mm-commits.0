From: akpm@linux-foundation.org
Subject: [merged] kthread_worker-dont-hog-the-cpu.patch removed
 from -mm tree
Date: Tue, 05 Sep 2017 12:51:43 -0700
Message-ID: <20170905195143.uSdJUROSz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37774 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752507AbdIETvo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2017 15:51:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com, pmladek@suse.com, shli@fb.com, tglx@linutronix.de, tj@kernel.org


The patch titled
     Subject: kernel/kthread.c: kthread_worker: don't hog the cpu
has been removed from the -mm tree.  Its filename was
     kthread_worker-dont-hog-the-cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from shli@fb.com are



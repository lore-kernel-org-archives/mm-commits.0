From: akpm@linux-foundation.org
Subject: + kthread_worker-dont-hog-the-cpu.patch added to -mm tree
Date: Fri, 25 Aug 2017 14:55:52 -0700
Message-ID: <59a09ce8.Fkl/E/bmaDy5/3Tg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50620 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932398AbdHYVzx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Aug 2017 17:55:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shli@fb.com, akpm@linux-foundation.org, mingo@kernel.org, oleg@redhat.com, pmladek@suse.com, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/kthread.c: kthread_worker: don't hog the cpu
has been added to the -mm tree.  Its filename is
     kthread_worker-dont-hog-the-cpu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kthread_worker-dont-hog-the-cpu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kthread_worker-dont-hog-the-cpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shaohua Li <shli@fb.com>
Subject: kernel/kthread.c: kthread_worker: don't hog the cpu

If the worker thread continues getting work, it will hog the cpu and rcu
stall complains.  Make it a good citizen.  This is triggered in a loop
block device test.

Link: http://lkml.kernel.org/r/5de0a179b3184e1a2183fc503448b0269f24d75b.1503697127.git.shli@fb.com
Signed-off-by: Shaohua Li <shli@fb.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
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

kthread_worker-dont-hog-the-cpu.patch


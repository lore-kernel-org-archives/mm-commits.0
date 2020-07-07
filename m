From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 kthread-remove-incorrect-comment-in-kthread_create_on_cpu.patch added to
 -mm tree
Date: Tue, 07 Jul 2020 12:36:33 -0700
Message-ID: <20200707193633.Ht7vuwzut%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbgGGTge (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 15:36:34 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pmladek@suse.com, stamatis.iliass@gmail.com


The patch titled
     Subject: kthread: remove incorrect comment in kthread_create_on_cpu()
has been added to the -mm tree.  Its filename is
     kthread-remove-incorrect-comment-in-kthread_create_on_cpu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kthread-remove-incorrect-comment-in-kthread_create_on_cpu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kthread-remove-incorrect-comment-in-kthread_create_on_cpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ilias Stamatis <stamatis.iliass@gmail.com>
Subject: kthread: remove incorrect comment in kthread_create_on_cpu()

Originally kthread_create_on_cpu() parked and woke up the new thread. 
However, since commit a65d40961dc7 ("kthread/smpboot: do not park in
kthread_create_on_cpu()") this is no longer the case.  This patch removes
the comment that has been left behind and is now incorrect / stale.

Link: http://lkml.kernel.org/r/20200611135920.240551-1-stamatis.iliass@gmail.com
Fixes: a65d40961dc7 ("kthread/smpboot: do not park in kthread_create_on_cpu()")
Signed-off-by: Ilias Stamatis <stamatis.iliass@gmail.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/kthread.c~kthread-remove-incorrect-comment-in-kthread_create_on_cpu
+++ a/kernel/kthread.c
@@ -478,7 +478,6 @@ EXPORT_SYMBOL(kthread_bind);
  *	     to "name.*%u". Code fills in cpu number.
  *
  * Description: This helper function creates and names a kernel thread
- * The thread will be woken and put into park mode.
  */
 struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
 					  void *data, unsigned int cpu,
_

Patches currently in -mm which might be from stamatis.iliass@gmail.com are

kthread-remove-incorrect-comment-in-kthread_create_on_cpu.patch

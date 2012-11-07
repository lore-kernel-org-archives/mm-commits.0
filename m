From: akpm@linux-foundation.org
Subject: + irq-tsk-comm-is-an-array.patch added to -mm tree
Date: Tue, 06 Nov 2012 16:27:34 -0800
Message-ID: <20121107002734.8DFA2100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:57389 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab2KGA1f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2012 19:27:35 -0500
Received: by mail-vc0-f202.google.com with SMTP id fy27so120950vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Nov 2012 16:27:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com, rientjes@google.com


The patch titled
     Subject: irq: tsk->comm is an array
has been added to the -mm tree.  Its filename is
     irq-tsk-comm-is-an-array.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: irq: tsk->comm is an array

The array check is useless so remove it.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/irq/manage.c~irq-tsk-comm-is-an-array kernel/irq/manage.c
--- a/kernel/irq/manage.c~irq-tsk-comm-is-an-array
+++ a/kernel/irq/manage.c
@@ -792,8 +792,9 @@ static void irq_thread_dtor(struct callb
 
 	action = kthread_data(tsk);
 
+	/* FIXME: locking */
 	pr_err("exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
-	       tsk->comm ? tsk->comm : "", tsk->pid, action->irq);
+	       tsk->comm, tsk->pid, action->irq);
 
 
 	desc = irq_to_desc(action->irq);
_

Patches currently in -mm which might be from alan@linux.intel.com are

fanotify-fix-missing-break.patch
linux-next.patch
irq-tsk-comm-is-an-array.patch
drivers-message-fusion-mptscsihc-missing-break.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
fork-unshare-remove-dead-code.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch


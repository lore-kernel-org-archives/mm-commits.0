From: akpm@linux-foundation.org
Subject: [merged] irq-tsk-comm-is-an-array.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:39:31 -0800
Message-ID: <20121219203932.1D1C9200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f73.google.com ([209.85.161.73]:54792 "EHLO
	mail-fa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab2LSUje (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:39:34 -0500
Received: by mail-fa0-f73.google.com with SMTP id v1so133745fav.2
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:39:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@linux.intel.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: irq: tsk->comm is an array
has been removed from the -mm tree.  Its filename was
     irq-tsk-comm-is-an-array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: irq: tsk->comm is an array

The array check is useless so remove it.

[akpm@linux-foundation.org: remove comment, per David]
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/irq/manage.c~irq-tsk-comm-is-an-array kernel/irq/manage.c
--- a/kernel/irq/manage.c~irq-tsk-comm-is-an-array
+++ a/kernel/irq/manage.c
@@ -818,7 +818,7 @@ static void irq_thread_dtor(struct callb
 	action = kthread_data(tsk);
 
 	pr_err("exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
-	       tsk->comm ? tsk->comm : "", tsk->pid, action->irq);
+	       tsk->comm, tsk->pid, action->irq);
 
 
 	desc = irq_to_desc(action->irq);
_

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
sendfile-allows-bypassing-of-notifier-events.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
hfsplus-avoid-crash-on-failed-block-map-free.patch
fork-unshare-remove-dead-code.patch


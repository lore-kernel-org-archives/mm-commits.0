From: akpm@linux-foundation.org
Subject: + mutex-subsystem-synchro-test-module-fix-3.patch added to -mm tree
Date: Mon, 15 Oct 2012 16:29:51 -0700
Message-ID: <20121015232952.146115C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:44287 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab2JOX3y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Oct 2012 19:29:54 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so353595lbo.1
        for <mm-commits@vger.kernel.org>; Mon, 15 Oct 2012 16:29:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net


The patch titled
     Subject: kernel: fix synchro-test.c printk format warrnings
has been added to the -mm tree.  Its filename is
     mutex-subsystem-synchro-test-module-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: kernel: fix synchro-test.c printk format warrnings

Fix printk format warnings in kernel/synchro-test.c.
Fixes warnings on i386 and on x86_64.

kernel/synchro-test.c:432:4: warning: format '%u' expects type 'unsigned int', but argument 5 has type 'long unsigned int'
kernel/synchro-test.c:437:4: warning: format '%u' expects type 'unsigned int', but argument 5 has type 'long unsigned int'
kernel/synchro-test.c:442:4: warning: format '%u' expects type 'unsigned int', but argument 5 has type 'long unsigned int'
kernel/synchro-test.c:447:4: warning: format '%u' expects type 'unsigned int', but argument 5 has type 'long unsigned int'
kernel/synchro-test.c:452:4: warning: format '%u' expects type 'unsigned int', but argument 5 has type 'long unsigned int'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/synchro-test.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/synchro-test.c~mutex-subsystem-synchro-test-module-fix-3 kernel/synchro-test.c
--- a/kernel/synchro-test.c~mutex-subsystem-synchro-test-module-fix-3
+++ a/kernel/synchro-test.c
@@ -429,27 +429,27 @@ static int __init do_tests(void)
 	for (loop = 0; loop < MAX_THREADS; loop++) {
 		if (loop < nummx) {
 			init_completion(&mx_comp[loop]);
-			kthread_run(mutexer, (void *) loop, "Mutex%u", loop);
+			kthread_run(mutexer, (void *) loop, "Mutex%lu", loop);
 		}
 
 		if (loop < numsm) {
 			init_completion(&sm_comp[loop]);
-			kthread_run(semaphorer, (void *) loop, "Sem%u", loop);
+			kthread_run(semaphorer, (void *) loop, "Sem%lu", loop);
 		}
 
 		if (loop < numrd) {
 			init_completion(&rd_comp[loop]);
-			kthread_run(reader, (void *) loop, "Read%u", loop);
+			kthread_run(reader, (void *) loop, "Read%lu", loop);
 		}
 
 		if (loop < numwr) {
 			init_completion(&wr_comp[loop]);
-			kthread_run(writer, (void *) loop, "Write%u", loop);
+			kthread_run(writer, (void *) loop, "Write%lu", loop);
 		}
 
 		if (loop < numdg) {
 			init_completion(&dg_comp[loop]);
-			kthread_run(downgrader, (void *) loop, "Down%u", loop);
+			kthread_run(downgrader, (void *) loop, "Down%lu", loop);
 		}
 	}
 
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
olpc-fix-olpc-xo1-scic-build-errors.patch
drm-fix-radeon-printk-format-warnings.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch
mutex-subsystem-synchro-test-module-fix-3.patch


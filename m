From: akpm@linux-foundation.org
Subject: [folded-merged] mutex-subsystem-synchro-test-module-fix-3.patch removed from -mm tree
Date: Wed, 02 Jan 2013 14:36:55 -0800
Message-ID: <20130102223655.D3B91100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:52373 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab3ABWg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jan 2013 17:36:56 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so1555638qcq.1
        for <mm-commits@vger.kernel.org>; Wed, 02 Jan 2013 14:36:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: fix synchro-test.c printk format warrnings
has been removed from the -mm tree.  Its filename was
     mutex-subsystem-synchro-test-module-fix-3.patch

This patch was dropped because it was folded into mutex-subsystem-synchro-test-module.patch

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

linux-next.patch
olpc-fix-olpc-xo1-scic-build-errors.patch
mutex-subsystem-synchro-test-module.patch


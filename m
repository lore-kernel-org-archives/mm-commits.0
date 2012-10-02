From: akpm@linux-foundation.org
Subject: + mutex-subsystem-synchro-test-module-fix-2.patch added to -mm tree
Date: Tue, 02 Oct 2012 13:25:18 -0700
Message-ID: <20121002202518.8C7D7100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:44739 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab2JBUZT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2012 16:25:19 -0400
Received: by ggmi4 with SMTP id i4so167073ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 02 Oct 2012 13:25:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk


The patch titled
     Subject: mutex-subsystem-synchro-test-module-fix-2
has been added to the -mm tree.  Its filename is
     mutex-subsystem-synchro-test-module-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: mutex-subsystem-synchro-test-module-fix-2

BTW, why not just do
	kthread_run(mutexer, (void *)loop, "Mutex%u", loop);
instead of
	kernel_thread(mutexer, (void *)loop, 0);
etc. and kill daemonize() calls in there, while we are at it?



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/synchro-test.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN kernel/synchro-test.c~mutex-subsystem-synchro-test-module-fix-2 kernel/synchro-test.c
--- a/kernel/synchro-test.c~mutex-subsystem-synchro-test-module-fix-2
+++ a/kernel/synchro-test.c
@@ -30,6 +30,7 @@
 #include <linux/timer.h>
 #include <linux/completion.h>
 #include <linux/mutex.h>
+#include <linux/kthread.h>
 
 #define MAX_THREADS 64
 
@@ -224,7 +225,6 @@ static int mutexer(void *arg)
 {
 	unsigned int N = (unsigned long) arg;
 
-	daemonize("Mutex%u", N);
 	set_user_nice(current, 19);
 
 	while (atomic_read(&do_stuff)) {
@@ -246,7 +246,6 @@ static int semaphorer(void *arg)
 {
 	unsigned int N = (unsigned long) arg;
 
-	daemonize("Sem%u", N);
 	set_user_nice(current, 19);
 
 	while (atomic_read(&do_stuff)) {
@@ -268,7 +267,6 @@ static int reader(void *arg)
 {
 	unsigned int N = (unsigned long) arg;
 
-	daemonize("Read%u", N);
 	set_user_nice(current, 19);
 
 	while (atomic_read(&do_stuff)) {
@@ -292,7 +290,6 @@ static int writer(void *arg)
 {
 	unsigned int N = (unsigned long) arg;
 
-	daemonize("Write%u", N);
 	set_user_nice(current, 19);
 
 	while (atomic_read(&do_stuff)) {
@@ -316,7 +313,6 @@ static int downgrader(void *arg)
 {
 	unsigned int N = (unsigned long) arg;
 
-	daemonize("Down%u", N);
 	set_user_nice(current, 19);
 
 	while (atomic_read(&do_stuff)) {
@@ -433,27 +429,27 @@ static int __init do_tests(void)
 	for (loop = 0; loop < MAX_THREADS; loop++) {
 		if (loop < nummx) {
 			init_completion(&mx_comp[loop]);
-			kernel_thread(mutexer, (void *) loop, 0);
+			kthread_run(mutexer, (void *) loop, "Mutex%u", loop);
 		}
 
 		if (loop < numsm) {
 			init_completion(&sm_comp[loop]);
-			kernel_thread(semaphorer, (void *) loop, 0);
+			kthread_run(semaphorer, (void *) loop, "Sem%u", loop);
 		}
 
 		if (loop < numrd) {
 			init_completion(&rd_comp[loop]);
-			kernel_thread(reader, (void *) loop, 0);
+			kthread_run(reader, (void *) loop, "Read%u", loop);
 		}
 
 		if (loop < numwr) {
 			init_completion(&wr_comp[loop]);
-			kernel_thread(writer, (void *) loop, 0);
+			kthread_run(writer, (void *) loop, "Write%u", loop);
 		}
 
 		if (loop < numdg) {
 			init_completion(&dg_comp[loop]);
-			kernel_thread(downgrader, (void *) loop, 0);
+			kthread_run(downgrader, (void *) loop, "Down%u", loop);
 		}
 	}
 
_

Patches currently in -mm which might be from viro@ZenIV.linux.org.uk are

origin.patch
linux-next.patch
mutex-subsystem-synchro-test-module-fix-2.patch


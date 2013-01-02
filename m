From: akpm@linux-foundation.org
Subject: [folded-merged] mutex-subsystem-synchro-test-module-fix-2.patch removed from -mm tree
Date: Wed, 02 Jan 2013 14:36:51 -0800
Message-ID: <20130102223652.40E7520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:38924 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab3ABWgy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jan 2013 17:36:54 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so910027eaa.3
        for <mm-commits@vger.kernel.org>; Wed, 02 Jan 2013 14:36:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mutex-subsystem-synchro-test-module-fix-2
has been removed from the -mm tree.  Its filename was
     mutex-subsystem-synchro-test-module-fix-2.patch

This patch was dropped because it was folded into mutex-subsystem-synchro-test-module.patch

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

mutex-subsystem-synchro-test-module.patch


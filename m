From: akpm@linux-foundation.org
Subject: + make-freezeable-workqueues-singlethread.patch added to -mm tree
Date: Mon, 14 May 2007 19:56:12 -0700
Message-ID: <200705150256.l4F2uCIo032570@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940AbXEOC5H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 22:57:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ego@in.ibm.com, rjw@sisk.pl


The patch titled
     make freezeable workqueues singlethread
has been added to the -mm tree.  Its filename is
     make-freezeable-workqueues-singlethread.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make freezeable workqueues singlethread
From: Oleg Nesterov <oleg@tv-sign.ru>

It is a known fact that freezeable multithreaded workqueues doesn't like
CPU_DEAD. We keep them only for the incoming CPU-hotplug rework.

Sadly, we can't just kill create_freezeable_workqueue() right now, make
them singlethread.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/workqueue.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/workqueue.h~make-freezeable-workqueues-singlethread include/linux/workqueue.h
--- a/include/linux/workqueue.h~make-freezeable-workqueues-singlethread
+++ a/include/linux/workqueue.h
@@ -122,7 +122,7 @@ extern struct workqueue_struct *__create
 						    int singlethread,
 						    int freezeable);
 #define create_workqueue(name) __create_workqueue((name), 0, 0)
-#define create_freezeable_workqueue(name) __create_workqueue((name), 0, 1)
+#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1)
 #define create_singlethread_workqueue(name) __create_workqueue((name), 1, 0)
 #define create_singlethread_freezeable_workqueue(name) \
 		__create_workqueue((name), 1, 1)
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

libata-core-convert-to-use-cancel_rearming_delayed_work.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
make-freezeable-workqueues-singlethread.patch
freezer-close-potential-race-between-refrigerator-and-thaw_tasks.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
freezer-fix-pf_nofreeze-vs-freezeable-race.patch
freezer-move-frozen_process-to-kernel-power-processc.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
tidy-up-usermode-helper-waiting-a-bit.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch

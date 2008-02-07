From: akpm@linux-foundation.org
Subject: - stopmachine-semaphore-to-mutex.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:24:39 -0800
Message-ID: <200802070024.m170OKSQ006598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41904 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934561AbYBGAsC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:48:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     stopmachine: semaphore to mutex
has been removed from the -mm tree.  Its filename was
     stopmachine-semaphore-to-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: stopmachine: semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Daniel Walker <dwalker@mvista.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/stop_machine.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/stop_machine.c~stopmachine-semaphore-to-mutex kernel/stop_machine.c
--- a/kernel/stop_machine.c~stopmachine-semaphore-to-mutex
+++ a/kernel/stop_machine.c
@@ -29,7 +29,6 @@ enum stopmachine_state {
 static enum stopmachine_state stopmachine_state;
 static unsigned int stopmachine_num_threads;
 static atomic_t stopmachine_thread_ack;
-static DECLARE_MUTEX(stopmachine_mutex);
 
 static int stopmachine(void *cpu)
 {
@@ -170,6 +169,7 @@ static int do_stop(void *_smdata)
 struct task_struct *__stop_machine_run(int (*fn)(void *), void *data,
 				       unsigned int cpu)
 {
+	static DEFINE_MUTEX(stopmachine_mutex);
 	struct stop_machine_data smdata;
 	struct task_struct *p;
 
@@ -177,7 +177,7 @@ struct task_struct *__stop_machine_run(i
 	smdata.data = data;
 	init_completion(&smdata.done);
 
-	down(&stopmachine_mutex);
+	mutex_lock(&stopmachine_mutex);
 
 	/* If they don't care which CPU fn runs on, bind to any online one. */
 	if (cpu == NR_CPUS)
@@ -193,7 +193,7 @@ struct task_struct *__stop_machine_run(i
 		wake_up_process(p);
 		wait_for_completion(&smdata.done);
 	}
-	up(&stopmachine_mutex);
+	mutex_unlock(&stopmachine_mutex);
 	return p;
 }
 
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
driver-base-memory-semaphore-to-mutex.patch
usb-microtek-remove-unused-semaphore.patch
usb-libusual-locking-cleanup.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch

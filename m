From: akpm@linux-foundation.org
Subject: + stopmachine-semaphore-to-mutex.patch added to -mm tree
Date: Wed, 12 Dec 2007 00:49:00 -0800
Message-ID: <200712120849.lBC8n0ec001712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34736 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755896AbXLLItj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 03:49:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, mingo@elte.hu


The patch titled
     stopmachine: semaphore to mutex
has been added to the -mm tree.  Its filename is
     stopmachine-semaphore-to-mutex.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: stopmachine: semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/stop_machine.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/stop_machine.c~stopmachine-semaphore-to-mutex kernel/stop_machine.c
--- a/kernel/stop_machine.c~stopmachine-semaphore-to-mutex
+++ a/kernel/stop_machine.c
@@ -29,7 +29,7 @@ enum stopmachine_state {
 static enum stopmachine_state stopmachine_state;
 static unsigned int stopmachine_num_threads;
 static atomic_t stopmachine_thread_ack;
-static DECLARE_MUTEX(stopmachine_mutex);
+static DEFINE_MUTEX(stopmachine_mutex);
 
 static int stopmachine(void *cpu)
 {
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

media-video-usbvision-add-mutex_unlock-to-error-paths.patch
media-video-usbvision-add-mutex_unlock-to-error-paths-fix.patch
media-video-usbvision-remove-ctrlurblock.patch
usb-testing-driver-dont-free-a-locked-mutex.patch
mcheck-mce_64-mce_read_sem-to-mutex.patch
drivers-char-tty_ioc-remove-pty_sem.patch
drivers-isdn-i4l-isdn_ttyc-remove-write_sem.patch
unix98-allocated_ptys_lock-semaphore-to-mutex.patch
docs-kernel-locking-convert-semaphore-references.patch
stopmachine-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch

From: akpm@linux-foundation.org
Subject: + waitqueues-give-waitqueue-spinlocks-their-own-lockdep-classes.patch added to -mm tree
Date: Mon, 10 Aug 2009 22:03:37 -0700
Message-ID: <200908110503.n7B53bSx009506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871AbZHKLys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 07:54:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterz@infradead.org, a.p.zijlstra@chello.nl, dhowells@redhat.com, mingo@elte.hu, tiwai@suse.de


The patch titled
     waitqueues: give waitqueue spinlocks their own lockdep classes
has been added to the -mm tree.  Its filename is
     waitqueues-give-waitqueue-spinlocks-their-own-lockdep-classes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: waitqueues: give waitqueue spinlocks their own lockdep classes
From: Peter Zijlstra <peterz@infradead.org>

Give waitqueue spinlocks their own lockdep classes when they are
initialised from init_waitqueue_head().  This means that struct
wait_queue::func functions can operate other waitqueues.

This is used by CacheFiles to catch the page from a backing fs being
unlocked and to wake up another thread to take a copy of it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Takashi Iwai <tiwai@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/wait.h |    9 ++++++++-
 kernel/wait.c        |    5 +++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff -puN include/linux/wait.h~waitqueues-give-waitqueue-spinlocks-their-own-lockdep-classes include/linux/wait.h
--- a/include/linux/wait.h~waitqueues-give-waitqueue-spinlocks-their-own-lockdep-classes
+++ a/include/linux/wait.h
@@ -77,7 +77,14 @@ struct task_struct;
 #define __WAIT_BIT_KEY_INITIALIZER(word, bit)				\
 	{ .flags = word, .bit_nr = bit, }
 
-extern void init_waitqueue_head(wait_queue_head_t *q);
+extern void __init_waitqueue_head(wait_queue_head_t *q, struct lock_class_key *);
+
+#define init_waitqueue_head(q)				\
+	do {						\
+		static struct lock_class_key __key;	\
+							\
+		__init_waitqueue_head((q), &__key);	\
+	} while (0)
 
 #ifdef CONFIG_LOCKDEP
 # define __WAIT_QUEUE_HEAD_INIT_ONSTACK(name) \
diff -puN kernel/wait.c~waitqueues-give-waitqueue-spinlocks-their-own-lockdep-classes kernel/wait.c
--- a/kernel/wait.c~waitqueues-give-waitqueue-spinlocks-their-own-lockdep-classes
+++ a/kernel/wait.c
@@ -10,13 +10,14 @@
 #include <linux/wait.h>
 #include <linux/hash.h>
 
-void init_waitqueue_head(wait_queue_head_t *q)
+void __init_waitqueue_head(wait_queue_head_t *q, struct lock_class_key *key)
 {
 	spin_lock_init(&q->lock);
+	lockdep_set_class(&q->lock, key);
 	INIT_LIST_HEAD(&q->task_list);
 }
 
-EXPORT_SYMBOL(init_waitqueue_head);
+EXPORT_SYMBOL(__init_waitqueue_head);
 
 void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
 {
_

Patches currently in -mm which might be from peterz@infradead.org are

origin.patch
linux-next.patch
waitqueues-give-waitqueue-spinlocks-their-own-lockdep-classes.patch
tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing.patch
tracing-page-allocator-add-trace-events-for-anti-fragmentation-falling-back-to-other-migratetypes.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch
tracing-page-allocator-add-a-postprocessing-script-for-page-allocator-related-ftrace-events.patch
tracing-documentation-add-a-document-describing-how-to-do-some-performance-analysis-with-tracepoints.patch
tracing-documentation-add-a-document-on-the-kmem-tracepoints.patch
generic-ipi-make-struct-call_function_data-lockless.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
generic-ipi-cleanup-for-generic_smp_call_function_interrupt.patch
kernel-smpc-relocate-some-code.patch
generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch
generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd-fix.patch


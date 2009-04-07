From: akpm@linux-foundation.org
Subject: [merged] mm-fix-pdflush-thread-creation-upper-bound.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:06:07 -0700
Message-ID: <200904071906.n37J67Zu010679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752615AbZDGTIX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:08:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmorreale@novell.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: fix pdflush thread creation upper bound
has been removed from the -mm tree.  Its filename was
     mm-fix-pdflush-thread-creation-upper-bound.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix pdflush thread creation upper bound
From: Peter W Morreale <pmorreale@novell.com>

Fix a race on creating pdflush threads.  Without the patch, it is possible
to create more than MAX_PDFLUSH_THREADS threads, and this has been
observed in practice on IO loaded SMP machines.

The fix involves moving the lock around to protect the check against the
thread count and correctly dealing with thread creation failure.

This fix also _mostly_ repairs a race condition on how quickly the threads
are created.  The original intent was to create a pdflush thread (up to
the max allowed) every second.  Without this patch is is possible to
create NCPUS pdflush threads concurrently.  The 'mostly' caveat is because
an assumption is made that thread creation will be successful.  If we fail
to create the thread, the miss is not considered fatal.  (we will try
again in 1 second)

Signed-off-by: Peter W Morreale <pmorreale@novell.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pdflush.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff -puN mm/pdflush.c~mm-fix-pdflush-thread-creation-upper-bound mm/pdflush.c
--- a/mm/pdflush.c~mm-fix-pdflush-thread-creation-upper-bound
+++ a/mm/pdflush.c
@@ -98,7 +98,6 @@ static int __pdflush(struct pdflush_work
 	INIT_LIST_HEAD(&my_work->list);
 
 	spin_lock_irq(&pdflush_lock);
-	nr_pdflush_threads++;
 	for ( ; ; ) {
 		struct pdflush_work *pdf;
 
@@ -126,20 +125,26 @@ static int __pdflush(struct pdflush_work
 
 		(*my_work->fn)(my_work->arg0);
 
+		spin_lock_irq(&pdflush_lock);
+
 		/*
 		 * Thread creation: For how long have there been zero
 		 * available threads?
+		 *
+		 * To throttle creation, we reset last_empty_jifs.
 		 */
 		if (time_after(jiffies, last_empty_jifs + 1 * HZ)) {
-			/* unlocked list_empty() test is OK here */
 			if (list_empty(&pdflush_list)) {
-				/* unlocked test is OK here */
-				if (nr_pdflush_threads < MAX_PDFLUSH_THREADS)
+				if (nr_pdflush_threads < MAX_PDFLUSH_THREADS) {
+					last_empty_jifs = jiffies;
+					nr_pdflush_threads++;
+					spin_unlock_irq(&pdflush_lock);
 					start_one_pdflush_thread();
+					spin_lock_irq(&pdflush_lock);
+				}
 			}
 		}
 
-		spin_lock_irq(&pdflush_lock);
 		my_work->fn = NULL;
 
 		/*
@@ -236,13 +241,26 @@ int pdflush_operation(void (*fn)(unsigne
 
 static void start_one_pdflush_thread(void)
 {
-	kthread_run(pdflush, NULL, "pdflush");
+	struct task_struct *k;
+
+	k = kthread_run(pdflush, NULL, "pdflush");
+	if (unlikely(IS_ERR(k))) {
+		spin_lock_irq(&pdflush_lock);
+		nr_pdflush_threads--;
+		spin_unlock_irq(&pdflush_lock);
+	}
 }
 
 static int __init pdflush_init(void)
 {
 	int i;
 
+	/*
+	 * Pre-set nr_pdflush_threads...  If we fail to create,
+	 * the count will be decremented.
+	 */
+	nr_pdflush_threads = MIN_PDFLUSH_THREADS;
+
 	for (i = 0; i < MIN_PDFLUSH_THREADS; i++)
 		start_one_pdflush_thread();
 	return 0;
_

Patches currently in -mm which might be from pmorreale@novell.com are

origin.patch


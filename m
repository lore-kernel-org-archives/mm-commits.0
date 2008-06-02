From: akpm@linux-foundation.org
Subject: + ipc-semc-remove-unused-entries-from-struct-sem_queue.patch added to -mm tree
Date: Mon, 02 Jun 2008 14:49:49 -0700
Message-ID: <200806022149.m52LnnP8001704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752308AbYFBVuw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2008 17:50:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manfred@colorfullife.com, Nadia.Derbey@bull.net, peifferp@gmail.com


The patch titled
     ipc/sem.c: remove unused entries from struct sem_queue
has been added to the -mm tree.  Its filename is
     ipc-semc-remove-unused-entries-from-struct-sem_queue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc/sem.c: remove unused entries from struct sem_queue
From: Manfred Spraul <manfred@colorfullife.com>

sem_queue.sma and sem_queue.id were never used, the attached patch removes
them.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Reviewed-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sem.h |    2 --
 ipc/sem.c           |    2 --
 2 files changed, 4 deletions(-)

diff -puN include/linux/sem.h~ipc-semc-remove-unused-entries-from-struct-sem_queue include/linux/sem.h
--- a/include/linux/sem.h~ipc-semc-remove-unused-entries-from-struct-sem_queue
+++ a/include/linux/sem.h
@@ -107,8 +107,6 @@ struct sem_queue {
 	struct sem_undo *	undo;	 /* undo structure */
 	int    			pid;	 /* process id of requesting process */
 	int    			status;	 /* completion status of operation */
-	struct sem_array *	sma;	 /* semaphore array for operations */
-	int			id;	 /* internal sem id */
 	struct sembuf *		sops;	 /* array of pending operations */
 	int			nsops;	 /* number of operations */
 	int			alter;   /* does the operation alter the array? */
diff -puN ipc/sem.c~ipc-semc-remove-unused-entries-from-struct-sem_queue ipc/sem.c
--- a/ipc/sem.c~ipc-semc-remove-unused-entries-from-struct-sem_queue
+++ a/ipc/sem.c
@@ -1160,12 +1160,10 @@ asmlinkage long sys_semtimedop(int semid
 	 * task into the pending queue and go to sleep.
 	 */
 		
-	queue.sma = sma;
 	queue.sops = sops;
 	queue.nsops = nsops;
 	queue.undo = un;
 	queue.pid = task_tgid_vnr(current);
-	queue.id = semid;
 	queue.alter = alter;
 	if (alter)
 		append_to_queue(sma ,&queue);
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-restore-msgpool-original-value.patch
ipc-only-output-msgmni-value-at-boot-time.patch
idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch
ipc-semc-convert-undo-structures-to-struct-list_head.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-remove-unused-entries-from-struct-sem_queue.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head.patch
ipc-semc-rewrite-undo-list-locking.patch
mm-debug-dump-pageframes-on-bad_page.patch
slab-leaks3-default-y.patch


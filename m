From: akpm@linux-foundation.org
Subject: + ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix-2.patch
 added to -mm tree
Date: Wed, 04 Dec 2013 13:27:25 -0800
Message-ID: <529f9e3d.JqKqI4kUZWXIWDKQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab3LDV10 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Dec 2013 16:27:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pmladek@suse.cz, manfred@colorfullife.com, jkosina@suse.cz, davidlohr@hp.com

Subject: + ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix-2.patch added to -mm tree
To: davidlohr@hp.com,jkosina@suse.cz,manfred@colorfullife.com,pmladek@suse.cz
From: akpm@linux-foundation.org
Date: Wed, 04 Dec 2013 13:27:25 -0800


The patch titled
     Subject: ipc,sem: correct header comment for perform_atomic_semop
has been added to the -mm tree.  Its filename is
     ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: ipc,sem: correct header comment for perform_atomic_semop

correct header comment for perform_atomic_semop()

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN ipc/sem.c~ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix-2 ipc/sem.c
--- a/ipc/sem.c~ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix-2
+++ a/ipc/sem.c
@@ -584,10 +584,11 @@ SYSCALL_DEFINE3(semget, key_t, key, int,
 	return ipcget(ns, &sem_ids(ns), &sem_ops, &sem_params);
 }
 
-/** perform_atomic_semop - Perform (if possible) a semaphore operation
+/**
+ * perform_atomic_semop - Perform (if possible) a semaphore operation
  * @sma: semaphore array
  * @sops: array with operations that should be checked
- * @nsems: number of sops
+ * @nsops: number of operations
  * @un: undo array
  * @pid: pid that did the change
  *
@@ -595,7 +596,6 @@ SYSCALL_DEFINE3(semget, key_t, key, int,
  * Returns 1 if the operation is impossible, the caller must sleep.
  * Negative values are error codes.
  */

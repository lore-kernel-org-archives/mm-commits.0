From: akpm@linux-foundation.org
Subject: +
 ipcsem-remove-uneeded-sem_undo_list-lock-usage-in-exit_sem.patch added to
 -mm tree
Date: Tue, 11 Aug 2015 14:07:05 -0700
Message-ID: <55ca63f9.pW5NMCbX22L/gX7o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60596 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbbHKVHG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Aug 2015 17:07:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: herton@redhat.com, aquini@redhat.com, aris@redhat.com, dave@stgolabs.net, djeffery@redhat.com, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc,sem: remove uneeded sem_undo_list lock usage in exit_sem()
has been added to the -mm tree.  Its filename is
     ipcsem-remove-uneeded-sem_undo_list-lock-usage-in-exit_sem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcsem-remove-uneeded-sem_undo_list-lock-usage-in-exit_sem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipcsem-remove-uneeded-sem_undo_list-lock-usage-in-exit_sem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Herton R. Krzesinski" <herton@redhat.com>
Subject: ipc,sem: remove uneeded sem_undo_list lock usage in exit_sem()

After we acquire the sma->sem_perm lock in exit_sem(), we are protected
against a racing IPC_RMID operation.  Also at that point, we are the last
user of sem_undo_list.  Therefore it isn't required that we acquire or use
ulp->lock.

Signed-off-by: Herton R. Krzesinski <herton@redhat.com>
Acked-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Rafael Aquini <aquini@redhat.com>
CC: Aristeu Rozanski <aris@redhat.com>
Cc: David Jeffery <djeffery@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN ipc/sem.c~ipcsem-remove-uneeded-sem_undo_list-lock-usage-in-exit_sem ipc/sem.c
--- a/ipc/sem.c~ipcsem-remove-uneeded-sem_undo_list-lock-usage-in-exit_sem
+++ a/ipc/sem.c
@@ -2123,9 +2123,11 @@ void exit_sem(struct task_struct *tsk)
 		ipc_assert_locked_object(&sma->sem_perm);
 		list_del(&un->list_id);
 
-		spin_lock(&ulp->lock);
+		/* we are the last process using this ulp, acquiring ulp->lock
+		 * isn't required. Besides that, we are also protected against
+		 * IPC_RMID as we hold sma->sem_perm lock now
+		 */
 		list_del_rcu(&un->list_proc);
-		spin_unlock(&ulp->lock);
 
 		/* perform adjustments registered in un */
 		for (i = 0; i < sma->sem_nsems; i++) {
_

Patches currently in -mm which might be from herton@redhat.com are

ipcsem-fix-use-after-free-on-ipc_rmid-after-a-task-using-same-semaphore-set-exits.patch
ipcsem-fix-use-after-free-on-ipc_rmid-after-a-task-using-same-semaphore-set-exits-fix.patch
ipcsem-remove-uneeded-sem_undo_list-lock-usage-in-exit_sem.patch


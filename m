From: akpm@linux-foundation.org
Subject: + idr-make-idr_get_new-rcu-safe-fix.patch added to -mm tree
Date: Wed, 04 Jun 2008 01:08:25 -0700
Message-ID: <200806040808.m5488PfW011615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539AbYFDILU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 04:11:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, paulmck@linux.vnet.ibm.com, peifferp@gmail.com, riel@redhat.com


The patch titled
     Remove useless calls to INIT_RCU_HEAD in the idr code
has been added to the -mm tree.  Its filename is
     idr-make-idr_get_new-rcu-safe-fix.patch

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
Subject: Remove useless calls to INIT_RCU_HEAD in the idr code
From: Nadia Derbey <Nadia.Derbey@bull.net>

This is a trivial patch that removes unneeded calls to INIT_RCU_HEAD() in the
idr api code.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Jim Houston <jim.houston@comcast.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN lib/idr.c~idr-make-idr_get_new-rcu-safe-fix lib/idr.c
--- a/lib/idr.c~idr-make-idr_get_new-rcu-safe-fix
+++ a/lib/idr.c
@@ -172,7 +172,6 @@ static int sub_alloc(struct idr *idp, in
 			new = get_from_free_list(idp);
 			if (!new)
 				return -1;
-			INIT_RCU_HEAD(&new->rcu_head);
 			rcu_assign_pointer(p->ary[m], new);
 			p->count++;
 		}
@@ -198,7 +197,6 @@ build_up:
 	if (unlikely(!p)) {
 		if (!(p = get_from_free_list(idp)))
 			return -1;
-		INIT_RCU_HEAD(&p->rcu_head);
 		layers = 1;
 	}
 	/*
@@ -226,7 +224,6 @@ build_up:
 		}
 		new->ary[0] = p;
 		new->count = 1;
-		INIT_RCU_HEAD(&new->rcu_head);
 		if (p->bitmap == IDR_FULL)
 			__set_bit(0, &new->bitmap);
 		p = new;
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

ipc-restore-msgpool-original-value.patch
ipc-only-output-msgmni-value-at-boot-time.patch
idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_get_new-rcu-safe-fix.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch
ipc-semc-convert-undo-structures-to-struct-list_head.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-remove-unused-entries-from-struct-sem_queue.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch


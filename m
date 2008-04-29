From: akpm@linux-foundation.org
Subject: + idr-fix-idr_remove.patch added to -mm tree
Date: Tue, 29 Apr 2008 11:45:20 -0700
Message-ID: <200804291845.m3TIjKf2003692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755911AbYD2Sqn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 14:46:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, paulmck@us.ibm.com


The patch titled
     idr: fix idr_remove()
has been added to the -mm tree.  Its filename is
     idr-fix-idr_remove.patch

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
Subject: idr: fix idr_remove()
From: Nadia Derbey <Nadia.Derbey@bull.net>

The return inside the loop makes us free only a single layer.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Jim Houston <jim.houston@comcast.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/idr.c~idr-fix-idr_remove lib/idr.c
--- a/lib/idr.c~idr-fix-idr_remove
+++ a/lib/idr.c
@@ -385,8 +385,8 @@ void idr_remove(struct idr *idp, int id)
 	while (idp->id_free_cnt >= IDR_FREE_MAX) {
 		p = alloc_layer(idp);
 		kmem_cache_free(idr_layer_cache, p);
-		return;
 	}
+	return;
 }
 EXPORT_SYMBOL(idr_remove);
 
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

ipc-use-ipc_buildid-directly-from-ipc_addid.patch
ipc-scale-msgmni-to-the-amount-of-lowmem.patch
ipc-scale-msgmni-to-the-number-of-ipc-namespaces.patch
ipc-define-the-slab_memory_callback-priority-as-a-constant.patch
ipc-recompute-msgmni-on-memory-add--remove.patch
ipc-invoke-the-ipcns-notifier-chain-as-a-work-item.patch
ipc-recompute-msgmni-on-ipc-namespace-creation-removal.patch
ipc-do-not-recompute-msgmni-anymore-if-explicitly-set-by-user.patch
ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative.patch
ipc-semaphores-code-factorisation.patch
ipc-shared-memory-introduce-shmctl_down.patch
ipc-message-queues-introduce-msgctl_down.patch
ipc-semaphores-move-the-rwmutex-handling-inside-semctl_down.patch
ipc-semaphores-remove-one-unused-parameter-from-semctl_down.patch
ipc-get-rid-of-the-use-_setbuf-structure.patch
ipc-introduce-ipc_update_perm.patch
ipc-consolidate-all-xxxctl_down-functions.patch
ipc-add-definitions-of-ushort_max-and-others.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
sysvipc-use-non-racy-method-for-proc-entries-creation.patch
idr-fix-idr_remove.patch


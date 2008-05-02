From: akpm@linux-foundation.org
Subject: - idr-fix-idr_remove.patch removed from -mm tree
Date: Fri, 02 May 2008 12:42:49 -0700
Message-ID: <200805021942.m42Jgnu5011228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762051AbYEBTtp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:49:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     idr: fix idr_remove()
has been removed from the -mm tree.  Its filename was
     idr-fix-idr_remove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
idr-introduce-the-ridr-structure.patch
idr-introduce-ridr_pre_get.patch
idr-introduce-ridr_init.patch
idr-introduce-ridr_get_new_above.patch
idr-introduce-ridr_get_new.patch
idr-introduce-ridr_find.patch
idr-introduce-ridr_remove.patch
ipc-integrate-the-ridr-code-into-ipc-code.patch
ipc-get-rid-of-ipc_lock_down.patch


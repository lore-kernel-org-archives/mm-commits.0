From: akpm@linux-foundation.org
Subject: [merged] ipc-utilc-use-kvfree-in-ipc_rcu_free.patch removed from
 -mm tree
Date: Mon, 06 Jul 2015 12:47:20 -0700
Message-ID: <559adb48.cFEAgPhr/totTfkM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbbGFTrU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:47:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/util.c: use kvfree() in ipc_rcu_free()
has been removed from the -mm tree.  Its filename was
     ipc-utilc-use-kvfree-in-ipc_rcu_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pekka Enberg <penberg@kernel.org>
Subject: ipc/util.c: use kvfree() in ipc_rcu_free()

Use kvfree() instead of open-coding it.

Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN ipc/util.c~ipc-utilc-use-kvfree-in-ipc_rcu_free ipc/util.c
--- a/ipc/util.c~ipc-utilc-use-kvfree-in-ipc_rcu_free
+++ a/ipc/util.c
@@ -467,10 +467,7 @@ void ipc_rcu_free(struct rcu_head *head)
 {
 	struct ipc_rcu *p = container_of(head, struct ipc_rcu, rcu);
 
-	if (is_vmalloc_addr(p))
-		vfree(p);
-	else
-		kfree(p);
+	kvfree(p);
 }
 
 /**
_

Patches currently in -mm which might be from penberg@kernel.org are

slab-infrastructure-for-bulk-object-allocation-and-freeing-v3.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch


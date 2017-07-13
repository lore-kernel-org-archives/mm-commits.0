From: akpm@linux-foundation.org
Subject: [merged] ipc-util-drop-ipc_rcu_free.patch removed from -mm
 tree
Date: Thu, 13 Jul 2017 13:41:29 -0700
Message-ID: <20170713204129.oMurib4MO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59202 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753092AbdGMUla (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:41:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, keescook@chromium.org, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/util: drop ipc_rcu_free()
has been removed from the -mm tree.  Its filename was
     ipc-util-drop-ipc_rcu_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ipc/util: drop ipc_rcu_free()

There are no more callers of ipc_rcu_free(), so remove it.

Link: http://lkml.kernel.org/r/20170525185107.12869-9-manfred@colorfullife.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    7 -------
 ipc/util.h |    1 -
 2 files changed, 8 deletions(-)

diff -puN ipc/util.c~ipc-util-drop-ipc_rcu_free ipc/util.c
--- a/ipc/util.c~ipc-util-drop-ipc_rcu_free
+++ a/ipc/util.c
@@ -429,13 +429,6 @@ void ipc_rcu_putref(struct kern_ipc_perm
 	call_rcu(&ptr->rcu, func);
 }
 
-void ipc_rcu_free(struct rcu_head *h)
-{
-	struct kern_ipc_perm *ptr = container_of(h, struct kern_ipc_perm, rcu);
-
-	kvfree(ptr);
-}

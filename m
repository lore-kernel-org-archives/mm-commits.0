From: akpm@linux-foundation.org
Subject: [merged] ipc-util-drop-ipc_rcu_alloc.patch removed from
 -mm tree
Date: Thu, 13 Jul 2017 13:41:37 -0700
Message-ID: <20170713204137.izUEpR6rG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59304 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753092AbdGMUli (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:41:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/util: drop ipc_rcu_alloc()
has been removed from the -mm tree.  Its filename was
     ipc-util-drop-ipc_rcu_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ipc/util: drop ipc_rcu_alloc()

No callers remain for ipc_rcu_alloc(). Drop the function.

[manfred@colorfullife.com: Rediff because the memset was temporarily inside ipc_rcu_free()]
Link: http://lkml.kernel.org/r/20170525185107.12869-13-manfred@colorfullife.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   21 ---------------------
 ipc/util.h |    3 ---
 2 files changed, 24 deletions(-)

diff -puN ipc/util.c~ipc-util-drop-ipc_rcu_alloc ipc/util.c
--- a/ipc/util.c~ipc-util-drop-ipc_rcu_alloc
+++ a/ipc/util.c
@@ -394,27 +394,6 @@ void ipc_rmid(struct ipc_ids *ids, struc
 	ipcp->deleted = true;
 }
 
-/**
- * ipc_rcu_alloc - allocate ipc space
- * @size: size desired
- *
- * Allocate memory for an ipc object.
- * The first member must be struct kern_ipc_perm.
- */
-struct kern_ipc_perm *ipc_rcu_alloc(int size)
-{
-	/*
-	 * We prepend the allocation with the rcu struct
-	 */
-	struct kern_ipc_perm *out = kvmalloc(size, GFP_KERNEL);
-	if (unlikely(!out))
-		return NULL;
-
-	memset(out, 0, size);
-	atomic_set(&out->refcount, 1);
-	return out;
-}

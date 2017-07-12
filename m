From: akpm@linux-foundation.org
Subject: [patch 39/96] ipc/util: drop ipc_rcu_free()
Date: Wed, 12 Jul 2017 14:34:59 -0700
Message-ID: <20170712213459.QSgQYJUe7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53558 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753452AbdGLVfA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:35:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, keescook@chromium.org, manfred@colorfullife.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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

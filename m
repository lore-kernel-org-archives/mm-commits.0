From: akpm@linux-foundation.org
Subject: [merged]
 ipc-utilh-update-documentation-for-ipc_getref-and-ipc_putref.patch removed
 from -mm tree
Date: Thu, 13 Jul 2017 13:41:53 -0700
Message-ID: <20170713204153.m7AHkcBdm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59366 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753092AbdGMUly (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:41:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, keescook@chromium.org, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/util.h: update documentation for ipc_getref() and ipc_putref()
has been removed from the -mm tree.  Its filename was
     ipc-utilh-update-documentation-for-ipc_getref-and-ipc_putref.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/util.h: update documentation for ipc_getref() and ipc_putref()

Now that ipc_rcu_alloc() and ipc_rcu_free() are removed,
document when it is valid to use ipc_getref() and ipc_putref().

Link: http://lkml.kernel.org/r/20170525185107.12869-21-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN ipc/util.h~ipc-utilh-update-documentation-for-ipc_getref-and-ipc_putref ipc/util.h
--- a/ipc/util.h~ipc-utilh-update-documentation-for-ipc_getref-and-ipc_putref
+++ a/ipc/util.h
@@ -112,6 +112,9 @@ int ipcperms(struct ipc_namespace *ns, s
  * Objects are reference counted, they start with reference count 1.
  * getref increases the refcount, the putref call that reduces the recount
  * to 0 schedules the rcu destruction. Caller must guarantee locking.
+ *
+ * refcount is initialized by ipc_addid(), before that point call_rcu()
+ * must be used.
  */
 int ipc_rcu_getref(struct kern_ipc_perm *ptr);
 void ipc_rcu_putref(struct kern_ipc_perm *ptr,
_

Patches currently in -mm which might be from manfred@colorfullife.com are



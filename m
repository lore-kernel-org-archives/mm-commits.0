From: akpm@linux-foundation.org
Subject: [merged]
 ipc-convert-kern_ipc_permrefcount-from-atomic_t-to-refcount_t.patch removed
 from -mm tree
Date: Mon, 11 Sep 2017 12:44:16 -0700
Message-ID: <20170911194416.G0bUa9Mk8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50952 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbdIKToR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:44:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, arozansk@redhat.com, dave@stgolabs.net, dwindsor@gmail.com, ebiederm@xmission.com, elena.reshetova@intel.com, gregkh@linuxfoundation.org, ishkamiel@gmail.com, keescook@chromium.org, manfred@colorfullife.com, mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org, serge@hallyn.com


The patch titled
     Subject: ipc: convert kern_ipc_perm.refcount from atomic_t to refcount_t
has been removed from the -mm tree.  Its filename was
     ipc-convert-kern_ipc_permrefcount-from-atomic_t-to-refcount_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Elena Reshetova <elena.reshetova@intel.com>
Subject: ipc: convert kern_ipc_perm.refcount from atomic_t to refcount_t

refcount_t type and corresponding API should be used instead of atomic_t
when the variable is used as a reference counter.  This allows to avoid
accidental refcounter overflows that might lead to use-after-free
situations.

Link: http://lkml.kernel.org/r/1499417992-3238-4-git-send-email-elena.reshetova@intel.com
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: <arozansk@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc.h |    3 ++-
 ipc/util.c          |    6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN include/linux/ipc.h~ipc-convert-kern_ipc_permrefcount-from-atomic_t-to-refcount_t include/linux/ipc.h
--- a/include/linux/ipc.h~ipc-convert-kern_ipc_permrefcount-from-atomic_t-to-refcount_t
+++ a/include/linux/ipc.h
@@ -4,6 +4,7 @@
 #include <linux/spinlock.h>
 #include <linux/uidgid.h>
 #include <uapi/linux/ipc.h>
+#include <linux/refcount.h>
 
 #define IPCMNI 32768  /* <= MAX_INT limit for ipc arrays (including sysctl changes) */
 
@@ -22,7 +23,7 @@ struct kern_ipc_perm {
 	void		*security;
 
 	struct rcu_head rcu;
-	atomic_t refcount;
+	refcount_t refcount;
 } ____cacheline_aligned_in_smp __randomize_layout;
 
 #endif /* _LINUX_IPC_H */
diff -puN ipc/util.c~ipc-convert-kern_ipc_permrefcount-from-atomic_t-to-refcount_t ipc/util.c
--- a/ipc/util.c~ipc-convert-kern_ipc_permrefcount-from-atomic_t-to-refcount_t
+++ a/ipc/util.c
@@ -232,7 +232,7 @@ int ipc_addid(struct ipc_ids *ids, struc
 
 	idr_preload(GFP_KERNEL);
 
-	atomic_set(&new->refcount, 1);
+	refcount_set(&new->refcount, 1);
 	spin_lock_init(&new->lock);
 	new->deleted = false;
 	rcu_read_lock();
@@ -397,13 +397,13 @@ void ipc_rmid(struct ipc_ids *ids, struc
 
 int ipc_rcu_getref(struct kern_ipc_perm *ptr)
 {
-	return atomic_inc_not_zero(&ptr->refcount);
+	return refcount_inc_not_zero(&ptr->refcount);
 }
 
 void ipc_rcu_putref(struct kern_ipc_perm *ptr,
 			void (*func)(struct rcu_head *head))
 {
-	if (!atomic_dec_and_test(&ptr->refcount))
+	if (!refcount_dec_and_test(&ptr->refcount))
 		return;
 
 	call_rcu(&ptr->rcu, func);
_

Patches currently in -mm which might be from elena.reshetova@intel.com are



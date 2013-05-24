From: akpm@linux-foundation.org
Subject: + ipc-introduce-ipc-object-locking-helpers.patch added to -mm
 tree
Date: Fri, 24 May 2013 13:17:35 -0700
Message-ID: <519fcadf.z87nem8RZO0i6mYK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913Ab3EXURg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 May 2013 16:17:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, andi@firstfloor.org, davidlohr.bueso@hp.com

Subject: + ipc-introduce-ipc-object-locking-helpers.patch added to -mm tree
To: davidlohr.bueso@hp.com,andi@firstfloor.org,riel@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 24 May 2013 13:17:35 -0700


The patch titled
     Subject: ipc: introduce ipc object locking helpers
has been added to the -mm tree.  Its filename is
     ipc-introduce-ipc-object-locking-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc: introduce ipc object locking helpers

Simple helpers around the (kern_ipc_perm *)->lock spinlock.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.h |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN ipc/util.h~ipc-introduce-ipc-object-locking-helpers ipc/util.h
--- a/ipc/util.h~ipc-introduce-ipc-object-locking-helpers
+++ a/ipc/util.h
@@ -159,23 +159,33 @@ static inline int ipc_checkid(struct ker
 	return uid / SEQ_MULTIPLIER != ipcp->seq;
 }
 
-static inline void ipc_lock_by_ptr(struct kern_ipc_perm *perm)
+static inline void ipc_lock_object(struct kern_ipc_perm *perm)
 {
-	rcu_read_lock();
 	spin_lock(&perm->lock);
 }
 
-static inline void ipc_unlock(struct kern_ipc_perm *perm)
+static inline void ipc_unlock_object(struct kern_ipc_perm *perm)
 {
 	spin_unlock(&perm->lock);
-	rcu_read_unlock();
 }
 
-static inline void ipc_lock_object(struct kern_ipc_perm *perm)
+static inline void ipc_assert_locked_object(struct kern_ipc_perm *perm)
 {
+	assert_spin_locked(&perm->lock);
+}
+
+static inline void ipc_lock_by_ptr(struct kern_ipc_perm *perm)
+{
+	rcu_read_lock();
 	spin_lock(&perm->lock);
 }
 
+static inline void ipc_unlock(struct kern_ipc_perm *perm)
+{
+	spin_unlock(&perm->lock);
+	rcu_read_unlock();
+}
+
 struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id);
 struct kern_ipc_perm *ipc_obtain_object_check(struct ipc_ids *ids, int id);
 int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

linux-next.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
softirq-use-_ret_ip_.patch
ipc-move-rcu-lock-out-of-ipc_addid.patch
ipc-introduce-ipc-object-locking-helpers.patch
ipc-close-open-coded-spin-lock-calls.patch
ipc-move-locking-out-of-ipcctl_pre_down_nolock.patch
ipcmsg-shorten-critical-region-in-msgctl_down.patch
ipcmsg-introduce-msgctl_nolock.patch
ipcmsg-introduce-lockless-functions-to-obtain-the-ipc-object.patch
ipcmsg-make-msgctl_nolock-lockless.patch
ipcmsg-shorten-critical-region-in-msgsnd.patch
ipcmsg-shorten-critical-region-in-msgrcv.patch
ipc-remove-unused-functions.patch


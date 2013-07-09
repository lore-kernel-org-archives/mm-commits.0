From: akpm@linux-foundation.org
Subject: [merged] ipc-introduce-ipc-object-locking-helpers.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 16:21:31 -0700
Message-ID: <51dc9afb.Jds9CV9XXiddYIqE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab3GIXVb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, andi@firstfloor.org, davidlohr.bueso@hp.com

Subject: [merged] ipc-introduce-ipc-object-locking-helpers.patch removed from -mm tree
To: davidlohr.bueso@hp.com,andi@firstfloor.org,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:31 -0700


The patch titled
     Subject: ipc: introduce ipc object locking helpers
has been removed from the -mm tree.  Its filename was
     ipc-introduce-ipc-object-locking-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch


From: akpm@linux-foundation.org
Subject: [merged] ipc-change-kern_ipc_permdeleted-type-to-bool.patch
 removed from -mm tree
Date: Tue, 28 Jan 2014 11:09:27 -0800
Message-ID: <52e80067.Z2BI15Y1e5vydeCg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45498 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaA1TJ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, manfred@colorfullife.com, gthelen@google.com, davidlohr@hp.com, aquini@redhat.com

Subject: [merged] ipc-change-kern_ipc_permdeleted-type-to-bool.patch removed from -mm tree
To: aquini@redhat.com,davidlohr@hp.com,gthelen@google.com,manfred@colorfullife.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:27 -0800


The patch titled
     Subject: ipc: change kern_ipc_perm.deleted type to bool
has been removed from the -mm tree.  Its filename was
     ipc-change-kern_ipc_permdeleted-type-to-bool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: ipc: change kern_ipc_perm.deleted type to bool

struct kern_ipc_perm.deleted is meant to be used as a boolean toggle, and
the changes introduced by this patch are just to make the case explicit.

Signed-off-by: Rafael Aquini <aquini@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Acked-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc.h |    2 +-
 ipc/sem.c           |    2 +-
 ipc/util.c          |    6 +++---
 ipc/util.h          |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/ipc.h~ipc-change-kern_ipc_permdeleted-type-to-bool include/linux/ipc.h
--- a/include/linux/ipc.h~ipc-change-kern_ipc_permdeleted-type-to-bool
+++ a/include/linux/ipc.h
@@ -11,7 +11,7 @@
 struct kern_ipc_perm
 {
 	spinlock_t	lock;
-	int		deleted;
+	bool		deleted;
 	int		id;
 	key_t		key;
 	kuid_t		uid;
diff -puN ipc/sem.c~ipc-change-kern_ipc_permdeleted-type-to-bool ipc/sem.c
--- a/ipc/sem.c~ipc-change-kern_ipc_permdeleted-type-to-bool
+++ a/ipc/sem.c
@@ -394,7 +394,7 @@ static inline struct sem_array *sem_obta
 	/* ipc_rmid() may have already freed the ID while sem_lock
 	 * was spinning: verify that the structure is still valid
 	 */
-	if (!ipcp->deleted)
+	if (ipc_valid_object(ipcp))
 		return container_of(ipcp, struct sem_array, sem_perm);
 
 	sem_unlock(sma, *locknum);
diff -puN ipc/util.c~ipc-change-kern_ipc_permdeleted-type-to-bool ipc/util.c
--- a/ipc/util.c~ipc-change-kern_ipc_permdeleted-type-to-bool
+++ a/ipc/util.c
@@ -286,7 +286,7 @@ int ipc_addid(struct ipc_ids* ids, struc
 	idr_preload(GFP_KERNEL);
 
 	spin_lock_init(&new->lock);
-	new->deleted = 0;
+	new->deleted = false;
 	rcu_read_lock();
 	spin_lock(&new->lock);
 
@@ -447,7 +447,7 @@ void ipc_rmid(struct ipc_ids *ids, struc
 
 	ids->in_use--;
 
-	ipcp->deleted = 1;
+	ipcp->deleted = true;
 
 	return;
 }
@@ -657,7 +657,7 @@ struct kern_ipc_perm *ipc_lock(struct ip
 	/* ipc_rmid() may have already freed the ID while ipc_lock
 	 * was spinning: here verify that the structure is still valid
 	 */
-	if (!out->deleted)
+	if (ipc_valid_object(out))
 		return out;
 
 	spin_unlock(&out->lock);
diff -puN ipc/util.h~ipc-change-kern_ipc_permdeleted-type-to-bool ipc/util.h
--- a/ipc/util.h~ipc-change-kern_ipc_permdeleted-type-to-bool
+++ a/ipc/util.h
@@ -195,7 +195,7 @@ static inline void ipc_unlock(struct ker
  */
 static inline bool ipc_valid_object(struct kern_ipc_perm *perm)
 {
-	return perm->deleted == 0;
+	return !perm->deleted;
 }
 
 struct kern_ipc_perm *ipc_obtain_object_check(struct ipc_ids *ids, int id);
_

Patches currently in -mm which might be from aquini@redhat.com are

origin.patch


From: akpm@linux-foundation.org
Subject: [merged] ipc-drop-ipc_lock_by_ptr.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:51:03 -0700
Message-ID: <52321b27.zRz79FdR81I/YdNz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab3ILTvL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:51:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, davidlohr.bueso@hp.com

Subject: [merged] ipc-drop-ipc_lock_by_ptr.patch removed from -mm tree
To: davidlohr.bueso@hp.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:51:03 -0700


The patch titled
     Subject: ipc: drop ipc_lock_by_ptr
has been removed from the -mm tree.  Its filename was
     ipc-drop-ipc_lock_by_ptr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc: drop ipc_lock_by_ptr

After previous cleanups and optimizations, this function is no longer
heavily used and we don't have a good reason to keep it.  Update the few
remaining callers and get rid of it.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/namespace.c |    3 ++-
 ipc/util.c      |    6 ++++--
 ipc/util.h      |    6 ------
 3 files changed, 6 insertions(+), 9 deletions(-)

diff -puN ipc/namespace.c~ipc-drop-ipc_lock_by_ptr ipc/namespace.c
--- a/ipc/namespace.c~ipc-drop-ipc_lock_by_ptr
+++ a/ipc/namespace.c
@@ -89,7 +89,8 @@ void free_ipcs(struct ipc_namespace *ns,
 		perm = idr_find(&ids->ipcs_idr, next_id);
 		if (perm == NULL)
 			continue;
-		ipc_lock_by_ptr(perm);
+		rcu_read_lock();
+		ipc_lock_object(perm);
 		free(ns, perm);
 		total++;
 	}
diff -puN ipc/util.c~ipc-drop-ipc_lock_by_ptr ipc/util.c
--- a/ipc/util.c~ipc-drop-ipc_lock_by_ptr
+++ a/ipc/util.c
@@ -205,7 +205,8 @@ static struct kern_ipc_perm *ipc_findkey
 			continue;
 		}
 
-		ipc_lock_by_ptr(ipc);
+		rcu_read_lock();
+		ipc_lock_object(ipc);
 		return ipc;
 	}
 
@@ -838,7 +839,8 @@ static struct kern_ipc_perm *sysvipc_fin
 		ipc = idr_find(&ids->ipcs_idr, pos);
 		if (ipc != NULL) {
 			*new_pos = pos + 1;
-			ipc_lock_by_ptr(ipc);
+			rcu_read_lock();
+			ipc_lock_object(ipc);
 			return ipc;
 		}
 	}
diff -puN ipc/util.h~ipc-drop-ipc_lock_by_ptr ipc/util.h
--- a/ipc/util.h~ipc-drop-ipc_lock_by_ptr
+++ a/ipc/util.h
@@ -171,12 +171,6 @@ static inline void ipc_assert_locked_obj
 	assert_spin_locked(&perm->lock);
 }
 
-static inline void ipc_lock_by_ptr(struct kern_ipc_perm *perm)
-{
-	rcu_read_lock();
-	ipc_lock_object(perm);
-}

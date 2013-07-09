From: akpm@linux-foundation.org
Subject: [merged] ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:21:51 -0700
Message-ID: <51dc9b0f.Mo+4XGW6nVHqJumG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39196 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab3GIXVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, davidlohr.bueso@hp.com, manfred@colorfullife.com

Subject: [merged] ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation.patch removed from -mm tree
To: manfred@colorfullife.com,davidlohr.bueso@hp.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:51 -0700


The patch titled
     Subject: ipc/util.c, ipc_rcu_alloc: cacheline align allocation
has been removed from the -mm tree.  Its filename was
     ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/util.c, ipc_rcu_alloc: cacheline align allocation

Enforce that ipc_rcu_alloc returns a cacheline aligned pointer on SMP.

Rationale:
The SysV sem code tries to move the main spinlock into a seperate cacheline
(____cacheline_aligned_in_smp). This works only if ipc_rcu_alloc returns
cacheline aligned pointers.
vmalloc and kmalloc return cacheline algined pointers, the implementation
of ipc_rcu_alloc breaks that.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN ipc/util.c~ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation ipc/util.c
--- a/ipc/util.c~ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation
+++ a/ipc/util.c
@@ -468,9 +468,7 @@ void ipc_free(void* ptr, int size)
 struct ipc_rcu {
 	struct rcu_head rcu;
 	atomic_t refcount;
-	/* "void *" makes sure alignment of following data is sane. */
-	void *data[0];
-};
+} ____cacheline_aligned_in_smp;
 
 /**
  *	ipc_rcu_alloc	-	allocate ipc and rcu space 
@@ -488,12 +486,14 @@ void *ipc_rcu_alloc(int size)
 	if (unlikely(!out))
 		return NULL;
 	atomic_set(&out->refcount, 1);
-	return out->data;
+	return out + 1;
 }
 
 int ipc_rcu_getref(void *ptr)
 {
-	return atomic_inc_not_zero(&container_of(ptr, struct ipc_rcu, data)->refcount);
+	struct ipc_rcu *p = ((struct ipc_rcu *)ptr) - 1;
+
+	return atomic_inc_not_zero(&p->refcount);
 }
 
 /**
@@ -507,7 +507,7 @@ static void ipc_schedule_free(struct rcu
 
 void ipc_rcu_putref(void *ptr)
 {
-	struct ipc_rcu *p = container_of(ptr, struct ipc_rcu, data);
+	struct ipc_rcu *p = ((struct ipc_rcu *)ptr) - 1;
 
 	if (!atomic_dec_and_test(&p->refcount))
 		return;
_

Patches currently in -mm which might be from manfred@colorfullife.com are

origin.patch
slab-leaks3-default-y.patch


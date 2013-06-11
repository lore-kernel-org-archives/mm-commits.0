From: akpm@linux-foundation.org
Subject: + ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation.patch added
 to -mm tree
Date: Tue, 11 Jun 2013 15:15:37 -0700
Message-ID: <51b7a189.bP5EIJIdJJn/AwnX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481Ab3FKWPi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 18:15:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, davidlohr.bueso@hp.com, manfred@colorfullife.com

Subject: + ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation.patch added to -mm tree
To: manfred@colorfullife.com,davidlohr.bueso@hp.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 15:15:37 -0700


The patch titled
     Subject: ipc/util.c, ipc_rcu_alloc: cacheline align allocation
has been added to the -mm tree.  Its filename is
     ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -467,9 +467,7 @@ void ipc_free(void* ptr, int size)
 struct ipc_rcu {
 	struct rcu_head rcu;
 	atomic_t refcount;
-	/* "void *" makes sure alignment of following data is sane. */
-	void *data[0];
-};
+} ____cacheline_aligned_in_smp;
 
 /**
  *	ipc_rcu_alloc	-	allocate ipc and rcu space 
@@ -487,12 +485,14 @@ void *ipc_rcu_alloc(int size)
 	if (unlikely(!out))
 		return NULL;
 	atomic_set(&out->refcount, 1);
-	return out->data;
+	return out+1;
 }
 
 int ipc_rcu_getref(void *ptr)
 {
-	return atomic_inc_not_zero(&container_of(ptr, struct ipc_rcu, data)->refcount);
+	struct ipc_rcu *p = ((struct ipc_rcu*)ptr)-1;
+
+	return atomic_inc_not_zero(&p->refcount);
 }
 
 /**
@@ -506,7 +506,7 @@ static void ipc_schedule_free(struct rcu
 
 void ipc_rcu_putref(void *ptr)
 {
-	struct ipc_rcu *p = container_of(ptr, struct ipc_rcu, data);
+	struct ipc_rcu *p = ((struct ipc_rcu*)ptr)-1;
 
 	if (!atomic_dec_and_test(&p->refcount))
 		return;
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation-checkpatch-fixes.patch
ipc-semc-cacheline-align-the-semaphore-structures.patch
ipc-sem-separate-wait-for-zero-and-alter-tasks-into-seperate-queues.patch
ipc-semc-always-use-only-one-queue-for-alter-operations.patch
ipc-semc-replace-shared-sem_otime-with-per-semaphore-value.patch
ipc-semc-rename-try_atomic_semop-to-perform_atomic_semop-docu-update.patch
slab-leaks3-default-y.patch


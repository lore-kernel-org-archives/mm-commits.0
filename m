From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmap-locking-api-add-mmap_read_trylock_non_owner.patch
 added to -mm tree
Date: Wed, 20 May 2020 20:24:40 -0700
Message-ID: <20200521032440.VIuWIBEg_%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728137AbgEUDYm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 23:24:42 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.m.jordan@oracle.com, dbueso@suse.de, hughd@google.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, ldufour@linux.ibm.com, Liam.Howlett@oracle.com, mm-commits@vger.kernel.org, peterz@infradead.org, rientjes@google.com, vbabka@suse.cz, walken@google.com, willy@infradead.org, yinghan@google.com


The patch titled
     Subject: mmap locking API: add mmap_read_trylock_non_owner()
has been added to the -mm tree.  Its filename is
     mmap-locking-api-add-mmap_read_trylock_non_owner.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmap-locking-api-add-mmap_read_trylock_non_owner.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmap-locking-api-add-mmap_read_trylock_non_owner.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mmap locking API: add mmap_read_trylock_non_owner()

Add a couple APIs used by kernel/bpf/stackmap.c only:
- mmap_read_trylock_non_owner()
- mmap_read_unlock_non_owner() (may be called from a work queue).

It's still not ideal that bpf/stackmap subverts the lock ownership in this
way.  Thanks to Peter Zijlstra for suggesting this API as the least-ugly
way of addressing this in the short term.

Link: http://lkml.kernel.org/r/20200520052908.204642-8-walken@google.com
Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |   14 ++++++++++++++
 kernel/bpf/stackmap.c     |   17 +++++------------
 2 files changed, 19 insertions(+), 12 deletions(-)

--- a/include/linux/mmap_lock.h~mmap-locking-api-add-mmap_read_trylock_non_owner
+++ a/include/linux/mmap_lock.h
@@ -56,4 +56,18 @@ static inline void mmap_read_unlock(stru
 	up_read(&mm->mmap_sem);
 }
 
+static inline bool mmap_read_trylock_non_owner(struct mm_struct *mm)
+{
+	if (down_read_trylock(&mm->mmap_sem)) {
+		rwsem_release(&mm->mmap_sem.dep_map, _RET_IP_);
+		return true;
+	}
+	return false;
+}
+
+static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)
+{
+	up_read_non_owner(&mm->mmap_sem);
+}
+
 #endif /* _LINUX_MMAP_LOCK_H */
--- a/kernel/bpf/stackmap.c~mmap-locking-api-add-mmap_read_trylock_non_owner
+++ a/kernel/bpf/stackmap.c
@@ -33,7 +33,7 @@ struct bpf_stack_map {
 /* irq_work to run up_read() for build_id lookup in nmi context */
 struct stack_map_irq_work {
 	struct irq_work irq_work;
-	struct rw_semaphore *sem;
+	struct mm_struct *mm;
 };
 
 static void do_up_read(struct irq_work *entry)
@@ -44,8 +44,7 @@ static void do_up_read(struct irq_work *
 		return;
 
 	work = container_of(entry, struct stack_map_irq_work, irq_work);
-	up_read_non_owner(work->sem);
-	work->sem = NULL;
+	mmap_read_unlock_non_owner(work->mm);
 }
 
 static DEFINE_PER_CPU(struct stack_map_irq_work, up_read_work);
@@ -317,7 +316,7 @@ static void stack_map_get_build_id_offse
 	 * with build_id.
 	 */
 	if (!user || !current || !current->mm || irq_work_busy ||
-	    mmap_read_trylock(current->mm) == 0) {
+	    !mmap_read_trylock_non_owner(current->mm)) {
 		/* cannot access current->mm, fall back to ips */
 		for (i = 0; i < trace_nr; i++) {
 			id_offs[i].status = BPF_STACK_BUILD_ID_IP;
@@ -342,16 +341,10 @@ static void stack_map_get_build_id_offse
 	}
 
 	if (!work) {
-		mmap_read_unlock(current->mm);
+		mmap_read_unlock_non_owner(current->mm);
 	} else {
-		work->sem = &current->mm->mmap_sem;
+		work->mm = current->mm;
 		irq_work_queue(&work->irq_work);
-		/*
-		 * The irq_work will release the mmap_sem with
-		 * up_read_non_owner(). The rwsem_release() is called
-		 * here to release the lock from lockdep's perspective.
-		 */
-		rwsem_release(&current->mm->mmap_sem.dep_map, _RET_IP_);
 	}
 }
 
_

Patches currently in -mm which might be from walken@google.com are

mmap-locking-api-initial-implementation-as-rwsem-wrappers.patch
mmu-notifier-use-the-new-mmap-locking-api.patch
dma-reservations-use-the-new-mmap-locking-api.patch
mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle.patch
mmap-locking-api-convert-nested-write-lock-sites.patch
mmap-locking-api-add-mmap_read_trylock_non_owner.patch
mmap-locking-api-add-mmap_lock_initializer.patch
mmap-locking-api-add-mmap_assert_locked-and-mmap_assert_write_locked.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock.patch
mmap-locking-api-convert-mmap_sem-api-comments.patch
mmap-locking-api-convert-mmap_sem-comments.patch

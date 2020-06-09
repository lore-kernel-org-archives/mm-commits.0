From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 66/93] mmap locking API: add
 mmap_read_trylock_non_owner()
Date: Mon, 08 Jun 2020 21:33:37 -0700
Message-ID: <20200609043337.0WUqyTkKL%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbgFIEdk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:33:40 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.m.jordan@oracle.com, dbueso@suse.de, hughd@google.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, ldufour@linux.ibm.com, Liam.Howlett@oracle.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, peterz@infradead.org, rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz, walken@google.com, willy@infradead.org, yinghan@google.com

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
Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
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

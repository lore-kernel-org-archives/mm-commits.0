From: akpm@linux-foundation.org
Subject: [merged]
 mmap-locking-api-initial-implementation-as-rwsem-wrappers.patch removed
 from -mm tree
Date: Tue, 09 Jun 2020 17:39:14 -0700
Message-ID: <20200610003914.6uwtQvhQ-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbgFJAjP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:39:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.m.jordan@oracle.com, dbueso@suse.de, hughd@google.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, ldufour@linux.ibm.com, Liam.Howlett@oracle.com, mhocko@suse.com, mm-commits@vger.kernel.org, peterz@infradead.org, rientjes@google.com, vbabka@suse.cz, walken@google.com, willy@infradead.org, yinghan@google.com


The patch titled
     Subject: mmap locking API: initial implementation as rwsem wrappers
has been removed from the -mm tree.  Its filename was
     mmap-locking-api-initial-implementation-as-rwsem-wrappers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mmap locking API: initial implementation as rwsem wrappers

This patch series adds a new mmap locking API replacing the existing
mmap_sem lock and unlocks.  Initially the API is just implemente in terms
of inlined rwsem calls, so it doesn't provide any new functionality.

There are two justifications for the new API:

- At first, it provides an easy hooking point to instrument mmap_sem
  locking latencies independently of any other rwsems.

- In the future, it may be a starting point for replacing the rwsem
  implementation with a different one, such as range locks.  This is
  something that is being explored, even though there is no wide concensus
  about this possible direction yet.  (see
  https://patchwork.kernel.org/cover/11401483/)


This patch (of 12):

This change wraps the existing mmap_sem related rwsem calls into a new
mmap locking API.  There are two justifications for the new API:

- At first, it provides an easy hooking point to instrument mmap_sem
  locking latencies independently of any other rwsems.

- In the future, it may be a starting point for replacing the rwsem
  implementation with a different one, such as range locks.

Link: http://lkml.kernel.org/r/20200520052908.204642-1-walken@google.com
Link: http://lkml.kernel.org/r/20200520052908.204642-2-walken@google.com
Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ying Han <yinghan@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h        |    1 
 include/linux/mmap_lock.h |   54 ++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

--- /dev/null
+++ a/include/linux/mmap_lock.h
@@ -0,0 +1,54 @@
+#ifndef _LINUX_MMAP_LOCK_H
+#define _LINUX_MMAP_LOCK_H
+
+static inline void mmap_init_lock(struct mm_struct *mm)
+{
+	init_rwsem(&mm->mmap_sem);
+}
+
+static inline void mmap_write_lock(struct mm_struct *mm)
+{
+	down_write(&mm->mmap_sem);
+}
+
+static inline int mmap_write_lock_killable(struct mm_struct *mm)
+{
+	return down_write_killable(&mm->mmap_sem);
+}
+
+static inline bool mmap_write_trylock(struct mm_struct *mm)
+{
+	return down_write_trylock(&mm->mmap_sem) != 0;
+}
+
+static inline void mmap_write_unlock(struct mm_struct *mm)
+{
+	up_write(&mm->mmap_sem);
+}
+
+static inline void mmap_write_downgrade(struct mm_struct *mm)
+{
+	downgrade_write(&mm->mmap_sem);
+}
+
+static inline void mmap_read_lock(struct mm_struct *mm)
+{
+	down_read(&mm->mmap_sem);
+}
+
+static inline int mmap_read_lock_killable(struct mm_struct *mm)
+{
+	return down_read_killable(&mm->mmap_sem);
+}
+
+static inline bool mmap_read_trylock(struct mm_struct *mm)
+{
+	return down_read_trylock(&mm->mmap_sem) != 0;
+}
+
+static inline void mmap_read_unlock(struct mm_struct *mm)
+{
+	up_read(&mm->mmap_sem);
+}
+
+#endif /* _LINUX_MMAP_LOCK_H */
--- a/include/linux/mm.h~mmap-locking-api-initial-implementation-as-rwsem-wrappers
+++ a/include/linux/mm.h
@@ -15,6 +15,7 @@
 #include <linux/atomic.h>
 #include <linux/debug_locks.h>
 #include <linux/mm_types.h>
+#include <linux/mmap_lock.h>
 #include <linux/range.h>
 #include <linux/pfn.h>
 #include <linux/percpu-refcount.h>
_

Patches currently in -mm which might be from walken@google.com are

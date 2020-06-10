From: akpm@linux-foundation.org
Subject: [merged] mmu-notifier-use-the-new-mmap-locking-api.patch
 removed from -mm tree
Date: Tue, 09 Jun 2020 17:39:17 -0700
Message-ID: <20200610003917.bGdPfQICv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbgFJAjT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:39:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.m.jordan@oracle.com, dbueso@suse.de, hughd@google.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, ldufour@linux.ibm.com, Liam.Howlett@oracle.com, mhocko@suse.com, mm-commits@vger.kernel.org, peterz@infradead.org, rientjes@google.com, vbabka@suse.cz, walken@google.com, willy@infradead.org, yinghan@google.com


The patch titled
     Subject: MMU notifier: use the new mmap locking API
has been removed from the -mm tree.  Its filename was
     mmu-notifier-use-the-new-mmap-locking-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: MMU notifier: use the new mmap locking API

This use is converted manually ahead of the next patch in the series, as
it requires including a new header which the automated conversion would
miss.

Link: http://lkml.kernel.org/r/20200520052908.204642-3-walken@google.com
Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/mmu_notifier.h~mmu-notifier-use-the-new-mmap-locking-api
+++ a/include/linux/mmu_notifier.h
@@ -5,6 +5,7 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/mm_types.h>
+#include <linux/mmap_lock.h>
 #include <linux/srcu.h>
 #include <linux/interval_tree.h>
 
@@ -277,9 +278,9 @@ mmu_notifier_get(const struct mmu_notifi
 {
 	struct mmu_notifier *ret;
 
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 	ret = mmu_notifier_get_locked(ops, mm);
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return ret;
 }
 void mmu_notifier_put(struct mmu_notifier *subscription);
_

Patches currently in -mm which might be from walken@google.com are

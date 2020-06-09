From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 61/93] MMU notifier: use the new mmap locking API
Date: Mon, 08 Jun 2020 21:33:18 -0700
Message-ID: <20200609043318.CMXFHDhdr%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEdU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:33:20 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.m.jordan@oracle.com, dbueso@suse.de, hughd@google.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, ldufour@linux.ibm.com, Liam.Howlett@oracle.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, peterz@infradead.org, rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz, walken@google.com, willy@infradead.org, yinghan@google.com

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

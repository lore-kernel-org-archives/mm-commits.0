From: akpm@linux-foundation.org
Subject: [merged] mm-memory-failure-share-the-i_mmap_rwsem.patch removed
 from -mm tree
Date: Sat, 13 Dec 2014 20:06:38 -0800
Message-ID: <548d0cce.h8032gkbrPudlbya%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaLNEGa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:06:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, hughd@google.com, kirill@shutemov.name, mgorman@suse.de, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: share the i_mmap_rwsem
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-share-the-i_mmap_rwsem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm/memory-failure: share the i_mmap_rwsem

No brainer conversion: collect_procs_file() only schedules a process for
later kill, share the lock, similarly to the anon vma variant.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failure-share-the-i_mmap_rwsem mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failure-share-the-i_mmap_rwsem
+++ a/mm/memory-failure.c
@@ -466,7 +466,7 @@ static void collect_procs_file(struct pa
 	struct task_struct *tsk;
 	struct address_space *mapping = page->mapping;
 
-	i_mmap_lock_write(mapping);
+	i_mmap_lock_read(mapping);
 	read_lock(&tasklist_lock);
 	for_each_process(tsk) {
 		pgoff_t pgoff = page_to_pgoff(page);
@@ -488,7 +488,7 @@ static void collect_procs_file(struct pa
 		}
 	}
 	read_unlock(&tasklist_lock);
-	i_mmap_unlock_write(mapping);
+	i_mmap_unlock_read(mapping);
 }
 
 /*
_

Patches currently in -mm which might be from dave@stgolabs.net are

origin.patch


From: akpm@linux-foundation.org
Subject: [merged]
 mempolicy-do-not-try-to-queue-pages-from-vma_migratable.patch removed from
 -mm tree
Date: Wed, 10 Feb 2016 11:35:41 -0800
Message-ID: <56bb910d.dhhJmsUR7nxxF7mK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbcBJTfm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 14:35:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dvyukov@google.com, hannes@cmpxchg.org, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: do not try to queue pages from !vma_migratable()
has been removed from the -mm tree.  Its filename was
     mempolicy-do-not-try-to-queue-pages-from-vma_migratable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mempolicy: do not try to queue pages from !vma_migratable()

Maybe I miss some point, but I don't see a reason why we try to queue
pages from non migratable VMAs.

This testcase steps on VM_BUG_ON_PAGE() in isolate_lru_page():

	#include <fcntl.h>
	#include <unistd.h>
	#include <stdio.h>
	#include <sys/mman.h>
	#include <numaif.h>

	#define SIZE 0x2000

	int foo;

	int main()
	{
		int fd;
		char *p;
		unsigned long mask = 2;

		fd = open("/dev/sg0", O_RDWR);
		p = mmap(NULL, SIZE, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
		/* Faultin pages */
		foo = p[0] + p[0x1000];
		mbind(p, SIZE, MPOL_BIND, &mask, 4, MPOL_MF_MOVE | MPOL_MF_STRICT);
		return 0;
	}

The only case when we can queue pages from such VMA is MPOL_MF_STRICT plus
MPOL_MF_MOVE or MPOL_MF_MOVE_ALL for VMA which has pages on LRU, but gfp
mask is not sutable for migaration (see mapping_gfp_mask() check in
vma_migratable()).  That's looks like a bug to me.

Let's filter out non-migratable vma at start of queue_pages_test_walk()
and go to queue_pages_pte_range() only if MPOL_MF_MOVE or MPOL_MF_MOVE_ALL
flag is set.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-do-not-try-to-queue-pages-from-vma_migratable mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-do-not-try-to-queue-pages-from-vma_migratable
+++ a/mm/mempolicy.c
@@ -548,8 +548,7 @@ retry:
 			goto retry;
 		}
 
-		if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
-			migrate_page_add(page, qp->pagelist, flags);
+		migrate_page_add(page, qp->pagelist, flags);
 	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
@@ -625,7 +624,7 @@ static int queue_pages_test_walk(unsigne
 	unsigned long endvma = vma->vm_end;
 	unsigned long flags = qp->flags;
 
-	if (vma->vm_flags & VM_PFNMAP)
+	if (!vma_migratable(vma))
 		return 1;
 
 	if (endvma > end)
@@ -644,16 +643,13 @@ static int queue_pages_test_walk(unsigne
 
 	if (flags & MPOL_MF_LAZY) {
 		/* Similar to task_numa_work, skip inaccessible VMAs */
-		if (vma_migratable(vma) &&
-			vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE))
+		if (vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE))
 			change_prot_numa(vma, start, endvma);
 		return 1;
 	}
 
-	if ((flags & MPOL_MF_STRICT) ||
-	    ((flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) &&
-	     vma_migratable(vma)))
-		/* queue pages from current vma */
+	/* queue pages from current vma */
+	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
 		return 0;
 	return 1;
 }
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-dax-check-for-pmd_none-after-split_huge_pmd.patch
ipc-shm-handle-removed-segments-gracefully-in-shm_mmap.patch
thp-cleanup-split_huge_page.patch
thp-vmstats-count-deferred-split-events.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch


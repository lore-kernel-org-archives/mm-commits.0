From: akpm@linux-foundation.org
Subject: + mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
 added to -mm tree
Date: Wed, 17 Dec 2014 13:34:57 -0800
Message-ID: <5491f701.NR64VYY9h7JBCBe1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaLQVe6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Dec 2014 16:34:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, jack@suse.cz, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory: remove ->vm_file check on shared writable vmas
has been added to the -mm tree.  Its filename is
     mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memory: remove ->vm_file check on shared writable vmas

Shared anonymous mmaps are implemented with shmem files, so all VMAs with
shared writable semantics also have an underlying backing file.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN mm/memory.c~mm-memory-remove-vm_file-check-on-shared-writable-vmas mm/memory.c
--- a/mm/memory.c~mm-memory-remove-vm_file-check-on-shared-writable-vmas
+++ a/mm/memory.c
@@ -2155,9 +2155,7 @@ reuse:
 				balance_dirty_pages_ratelimited(mapping);
 			}
 
-			/* file_update_time outside page_lock */
-			if (vma->vm_file)
-				file_update_time(vma->vm_file);
+			file_update_time(vma->vm_file);
 		}
 		put_page(dirty_page);
 		if (page_mkwrite) {
@@ -3019,8 +3017,7 @@ static int do_shared_fault(struct mm_str
 		balance_dirty_pages_ratelimited(mapping);
 	}
 
-	/* file_update_time outside page_lock */
-	if (vma->vm_file && !vma->vm_ops->page_mkwrite)
+	if (!vma->vm_ops->page_mkwrite)
 		file_update_time(vma->vm_file);
 
 	return ret;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask-fix.patch
mm-protect-set_page_dirty-from-ongoing-truncation.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch


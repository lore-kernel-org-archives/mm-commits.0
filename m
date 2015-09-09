From: akpm@linux-foundation.org
Subject: [merged] mm-dax-use-i_mmap_unlock_write-in-do_cow_fault.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:43:39 -0700
Message-ID: <55f08beb.cXUtLQlVh1pcgDDg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38845 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbbIITnk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:43:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dax: use i_mmap_unlock_write() in do_cow_fault()
has been removed from the -mm tree.  Its filename was
     mm-dax-use-i_mmap_unlock_write-in-do_cow_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm, dax: use i_mmap_unlock_write() in do_cow_fault()

__dax_fault() takes i_mmap_lock for write. Let's pair it with write
unlock on do_cow_fault() side.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memory.c~mm-dax-use-i_mmap_unlock_write-in-do_cow_fault mm/memory.c
--- a/mm/memory.c~mm-dax-use-i_mmap_unlock_write-in-do_cow_fault
+++ a/mm/memory.c
@@ -3013,9 +3013,9 @@ static int do_cow_fault(struct mm_struct
 		} else {
 			/*
 			 * The fault handler has no page to lock, so it holds
-			 * i_mmap_lock for read to protect against truncate.
+			 * i_mmap_lock for write to protect against truncate.
 			 */
-			i_mmap_unlock_read(vma->vm_file->f_mapping);
+			i_mmap_unlock_write(vma->vm_file->f_mapping);
 		}
 		goto uncharge_out;
 	}
@@ -3029,9 +3029,9 @@ static int do_cow_fault(struct mm_struct
 	} else {
 		/*
 		 * The fault handler has no page to lock, so it holds
-		 * i_mmap_lock for read to protect against truncate.
+		 * i_mmap_lock for write to protect against truncate.
 		 */
-		i_mmap_unlock_read(vma->vm_file->f_mapping);
+		i_mmap_unlock_write(vma->vm_file->f_mapping);
 	}
 	return ret;
 uncharge_out:
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-mark-most-vm_operations_struct-const.patch
mm-make-sure-all-file-vmas-have-vm_ops-set.patch
mm-use-vma_is_anonymous-in-create_huge_pmd-and-wp_huge_pmd.patch
mm-madvise-use-vma_is_anonymous-to-check-for-anon-vma.patch


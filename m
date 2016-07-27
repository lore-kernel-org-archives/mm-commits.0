From: akpm@linux-foundation.org
Subject: [merged] thp-run-vma_adjust_trans_huge-outside-i_mmap_rwsem.patch removed from -mm tree
Date: Wed, 27 Jul 2016 12:02:34 -0700
Message-ID: <5799054a.3api+5+oCJpkZhlv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757964AbcG0TCf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:02:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: run vma_adjust_trans_huge() outside i_mmap_rwsem
has been removed from the -mm tree.  Its filename was
     thp-run-vma_adjust_trans_huge-outside-i_mmap_rwsem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: run vma_adjust_trans_huge() outside i_mmap_rwsem

vma_addjust_trans_huge() splits pmd if it's crossing VMA boundary.
During split we munlock the huge page which requires rmap walk.
rmap wants to take the lock on its own.

Let's move vma_adjust_trans_huge() outside i_mmap_rwsem to fix this.

Link: http://lkml.kernel.org/r/1466021202-61880-19-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/mmap.c~thp-run-vma_adjust_trans_huge-outside-i_mmap_rwsem mm/mmap.c
--- a/mm/mmap.c~thp-run-vma_adjust_trans_huge-outside-i_mmap_rwsem
+++ a/mm/mmap.c
@@ -675,6 +675,8 @@ again:			remove_next = 1 + (end > next->
 		}
 	}
 
+	vma_adjust_trans_huge(vma, start, end, adjust_next);
+
 	if (file) {
 		mapping = file->f_mapping;
 		root = &mapping->i_mmap;
@@ -695,8 +697,6 @@ again:			remove_next = 1 + (end > next->
 		}
 	}
 
-	vma_adjust_trans_huge(vma, start, end, adjust_next);

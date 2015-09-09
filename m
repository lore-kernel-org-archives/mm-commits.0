From: akpm@linux-foundation.org
Subject: [merged] mm-mmap-check-all-failures-before-set-values.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:53:40 -0700
Message-ID: <55f08e44.Vb5YRduJ0/DkV/Gq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407AbbIITxl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:53:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gang.chen.5i5j@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c:insert_vm_struct(): check for failure before setting values
has been removed from the -mm tree.  Its filename was
     mm-mmap-check-all-failures-before-set-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: mm/mmap.c:insert_vm_struct(): check for failure before setting values

There's no point in initializing vma->vm_pgoff if the insertion attempt
will be failing anyway.  Run the checks before performing the
initialization.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN mm/mmap.c~mm-mmap-check-all-failures-before-set-values mm/mmap.c
--- a/mm/mmap.c~mm-mmap-check-all-failures-before-set-values
+++ a/mm/mmap.c
@@ -2871,6 +2871,13 @@ int insert_vm_struct(struct mm_struct *m
 	struct vm_area_struct *prev;
 	struct rb_node **rb_link, *rb_parent;
 
+	if (find_vma_links(mm, vma->vm_start, vma->vm_end,
+			   &prev, &rb_link, &rb_parent))
+		return -ENOMEM;
+	if ((vma->vm_flags & VM_ACCOUNT) &&
+	     security_vm_enough_memory_mm(mm, vma_pages(vma)))
+		return -ENOMEM;
+
 	/*
 	 * The vm_pgoff of a purely anonymous vma should be irrelevant
 	 * until its first write fault, when page's anon_vma and index
@@ -2887,12 +2894,6 @@ int insert_vm_struct(struct mm_struct *m
 		BUG_ON(vma->anon_vma);
 		vma->vm_pgoff = vma->vm_start >> PAGE_SHIFT;
 	}
-	if (find_vma_links(mm, vma->vm_start, vma->vm_end,
-			   &prev, &rb_link, &rb_parent))
-		return -ENOMEM;
-	if ((vma->vm_flags & VM_ACCOUNT) &&
-	     security_vm_enough_memory_mm(mm, vma_pages(vma)))
-		return -ENOMEM;
 
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 	return 0;
_

Patches currently in -mm which might be from gang.chen.5i5j@gmail.com are



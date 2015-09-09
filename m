From: akpm@linux-foundation.org
Subject: [merged] mm-mmap-simplify-the-failure-return-working-flow.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:53:16 -0700
Message-ID: <55f08e2c.fisQqt/VTblNQw+X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbbIITxR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:53:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gang.chen.5i5j@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: simplify the failure return working flow
has been removed from the -mm tree.  Its filename was
     mm-mmap-simplify-the-failure-return-working-flow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: mm/mmap.c: simplify the failure return working flow

__split_vma() doesn't need out_err label, neither need initializing err.

copy_vma() can return NULL directly when kmem_cache_alloc() fails.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff -puN mm/mmap.c~mm-mmap-simplify-the-failure-return-working-flow mm/mmap.c
--- a/mm/mmap.c~mm-mmap-simplify-the-failure-return-working-flow
+++ a/mm/mmap.c
@@ -2455,7 +2455,7 @@ static int __split_vma(struct mm_struct
 	      unsigned long addr, int new_below)
 {
 	struct vm_area_struct *new;
-	int err = -ENOMEM;
+	int err;
 
 	if (is_vm_hugetlb_page(vma) && (addr &
 					~(huge_page_mask(hstate_vma(vma)))))
@@ -2463,7 +2463,7 @@ static int __split_vma(struct mm_struct
 
 	new = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 	if (!new)
-		goto out_err;
+		return -ENOMEM;
 
 	/* most fields are the same, copy all, and then fixup */
 	*new = *vma;
@@ -2511,7 +2511,6 @@ static int __split_vma(struct mm_struct
 	mpol_put(vma_policy(new));
  out_free_vma:
 	kmem_cache_free(vm_area_cachep, new);
- out_err:
 	return err;
 }
 
@@ -2952,30 +2951,31 @@ struct vm_area_struct *copy_vma(struct v
 		*need_rmap_locks = (new_vma->vm_pgoff <= vma->vm_pgoff);
 	} else {
 		new_vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
-		if (new_vma) {
-			*new_vma = *vma;
-			new_vma->vm_start = addr;
-			new_vma->vm_end = addr + len;
-			new_vma->vm_pgoff = pgoff;
-			if (vma_dup_policy(vma, new_vma))
-				goto out_free_vma;
-			INIT_LIST_HEAD(&new_vma->anon_vma_chain);
-			if (anon_vma_clone(new_vma, vma))
-				goto out_free_mempol;
-			if (new_vma->vm_file)
-				get_file(new_vma->vm_file);
-			if (new_vma->vm_ops && new_vma->vm_ops->open)
-				new_vma->vm_ops->open(new_vma);
-			vma_link(mm, new_vma, prev, rb_link, rb_parent);
-			*need_rmap_locks = false;
-		}
+		if (!new_vma)
+			goto out;
+		*new_vma = *vma;
+		new_vma->vm_start = addr;
+		new_vma->vm_end = addr + len;
+		new_vma->vm_pgoff = pgoff;
+		if (vma_dup_policy(vma, new_vma))
+			goto out_free_vma;
+		INIT_LIST_HEAD(&new_vma->anon_vma_chain);
+		if (anon_vma_clone(new_vma, vma))
+			goto out_free_mempol;
+		if (new_vma->vm_file)
+			get_file(new_vma->vm_file);
+		if (new_vma->vm_ops && new_vma->vm_ops->open)
+			new_vma->vm_ops->open(new_vma);
+		vma_link(mm, new_vma, prev, rb_link, rb_parent);
+		*need_rmap_locks = false;
 	}
 	return new_vma;
 
- out_free_mempol:
+out_free_mempol:
 	mpol_put(vma_policy(new_vma));
- out_free_vma:
+out_free_vma:
 	kmem_cache_free(vm_area_cachep, new_vma);
+out:
 	return NULL;
 }
 
_

Patches currently in -mm which might be from gang.chen.5i5j@gmail.com are



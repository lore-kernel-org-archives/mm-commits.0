From: akpm@linux-foundation.org
Subject: + mm-mmap-simplify-the-failure-return-working-flow.patch added to -mm tree
Date: Tue, 18 Aug 2015 15:57:24 -0700
Message-ID: <55d3b854.xtb1byWd/fClTcGo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbbHRW5Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Aug 2015 18:57:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gang.chen.5i5j@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: simplify the failure return working flow
has been added to the -mm tree.  Its filename is
     mm-mmap-simplify-the-failure-return-working-flow.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-simplify-the-failure-return-working-flow.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-simplify-the-failure-return-working-flow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: mm/mmap.c: simplify the failure return working flow

__split_vma() doesn't need out_err label, neither need initializing err.

copy_vma() can return NULL directly when kmem_cache_alloc() fails.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

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
 
@@ -2952,23 +2951,23 @@ struct vm_area_struct *copy_vma(struct v
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
+			return NULL;
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
 
_

Patches currently in -mm which might be from gang.chen.5i5j@gmail.com are

mm-mmap-simplify-the-failure-return-working-flow.patch
mm-mmap-simplify-the-failure-return-working-flow-fix.patch
linux-next.patch


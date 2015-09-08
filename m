From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mmap-simplify-the-failure-return-working-flow-fix.patch removed from -mm tree
Date: Tue, 08 Sep 2015 14:45:22 -0700
Message-ID: <55ef56f2.myZDGYrwjW0ryNOb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbbIHVpX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 17:45:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gang.chen.5i5j@gmail.com, xili_gchen_5257@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmap-simplify-the-failure-return-working-flow-fix
has been removed from the -mm tree.  Its filename was
     mm-mmap-simplify-the-failure-return-working-flow-fix.patch

This patch was dropped because it was folded into mm-mmap-simplify-the-failure-return-working-flow.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mmap-simplify-the-failure-return-working-flow-fix

Cc: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Chen Gang <xili_gchen_5257@hotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/mmap.c~mm-mmap-simplify-the-failure-return-working-flow-fix mm/mmap.c
--- a/mm/mmap.c~mm-mmap-simplify-the-failure-return-working-flow-fix
+++ a/mm/mmap.c
@@ -2953,7 +2953,7 @@ struct vm_area_struct *copy_vma(struct v
 	} else {
 		new_vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 		if (!new_vma)
-			return NULL;
+			goto out;
 		*new_vma = *vma;
 		new_vma->vm_start = addr;
 		new_vma->vm_end = addr + len;
@@ -2972,10 +2972,11 @@ struct vm_area_struct *copy_vma(struct v
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

Patches currently in -mm which might be from akpm@linux-foundation.org are

dax-revert-userfaultfd-change.patch
mm-mmap-simplify-the-failure-return-working-flow.patch
zswap-dynamic-pool-creation-fix.patch


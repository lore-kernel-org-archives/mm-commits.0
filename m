From: akpm@linux-foundation.org
Subject: [merged] revert-mm-mempolicy-let-vma_merge-and-vma_split-handle-vma-vm_policy-linkages.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:06:45 -0700
Message-ID: <20121009180646.1C60C100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:35405 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISGr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:06:47 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so661698vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:06:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@gmail.com, cl@linux.com, jwboyer@gmail.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: revert "mm: mempolicy: Let vma_merge and vma_split handle vma->vm_policy linkages"
has been removed from the -mm tree.  Its filename was
     revert-mm-mempolicy-let-vma_merge-and-vma_split-handle-vma-vm_policy-linkages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: revert "mm: mempolicy: Let vma_merge and vma_split handle vma->vm_policy linkages"

05f144a0 ("mm: mempolicy: Let vma_merge and vma_split handle
vma->vm_policy linkages") removed vma->vm_policy updates code but it is
the purpose of mbind_range().  Now, mbind_range() is virtually a no-op and
while it does not allow memory corruption it is not the right fix.  This
patch is a revert.

[mgorman@suse.de: Edited changelog]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: Josh Boyer <jwboyer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff -puN mm/mempolicy.c~revert-mm-mempolicy-let-vma_merge-and-vma_split-handle-vma-vm_policy-linkages mm/mempolicy.c
--- a/mm/mempolicy.c~revert-mm-mempolicy-let-vma_merge-and-vma_split-handle-vma-vm_policy-linkages
+++ a/mm/mempolicy.c
@@ -607,6 +607,27 @@ check_range(struct mm_struct *mm, unsign
 	return first;
 }
 
+/* Apply policy to a single VMA */
+static int policy_vma(struct vm_area_struct *vma, struct mempolicy *new)
+{
+	int err = 0;
+	struct mempolicy *old = vma->vm_policy;
+
+	pr_debug("vma %lx-%lx/%lx vm_ops %p vm_file %p set_policy %p\n",
+		 vma->vm_start, vma->vm_end, vma->vm_pgoff,
+		 vma->vm_ops, vma->vm_file,
+		 vma->vm_ops ? vma->vm_ops->set_policy : NULL);
+
+	if (vma->vm_ops && vma->vm_ops->set_policy)
+		err = vma->vm_ops->set_policy(vma, new);
+	if (!err) {
+		mpol_get(new);
+		vma->vm_policy = new;
+		mpol_put(old);
+	}
+	return err;
+}
+
 /* Step 2: apply policy to a range and do splits. */
 static int mbind_range(struct mm_struct *mm, unsigned long start,
 		       unsigned long end, struct mempolicy *new_pol)
@@ -655,23 +676,9 @@ static int mbind_range(struct mm_struct 
 			if (err)
 				goto out;
 		}
-
-		/*
-		 * Apply policy to a single VMA. The reference counting of
-		 * policy for vma_policy linkages has already been handled by
-		 * vma_merge and split_vma as necessary. If this is a shared
-		 * policy then ->set_policy will increment the reference count
-		 * for an sp node.
-		 */
-		pr_debug("vma %lx-%lx/%lx vm_ops %p vm_file %p set_policy %p\n",
-			vma->vm_start, vma->vm_end, vma->vm_pgoff,
-			vma->vm_ops, vma->vm_file,
-			vma->vm_ops ? vma->vm_ops->set_policy : NULL);
-		if (vma->vm_ops && vma->vm_ops->set_policy) {
-			err = vma->vm_ops->set_policy(vma, new_pol);
-			if (err)
-				goto out;
-		}
+		err = policy_vma(vma, new_pol);
+		if (err)
+			goto out;
 	}
 
  out:
_

Patches currently in -mm which might be from kosaki.motohiro@gmail.com are

origin.patch


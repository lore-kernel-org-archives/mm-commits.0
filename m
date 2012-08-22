From: akpm@linux-foundation.org
Subject: + revert-mm-mempolicy-let-vma_merge-and-vma_split-handle-vma-vm_policy-linkages.patch added to -mm tree
Date: Wed, 22 Aug 2012 12:07:52 -0700
Message-ID: <20120822190754.90D605C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:46383 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab2HVTH5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Aug 2012 15:07:57 -0400
Received: by faem1 with SMTP id m1so62907fae.1
        for <mm-commits@vger.kernel.org>; Wed, 22 Aug 2012 12:07:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@gmail.com, cl@linux.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de


The patch titled
     Subject: Revert "mm: mempolicy: Let vma_merge and vma_split handle vma->vm_policy linkages"
has been added to the -mm tree.  Its filename is
     revert-mm-mempolicy-let-vma_merge-and-vma_split-handle-vma-vm_policy-linkages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Revert "mm: mempolicy: Let vma_merge and vma_split handle vma->vm_policy linkages"

05f144a0 ("mm: mempolicy: Let vma_merge and vma_split handle
vma->vm_policy linkages") removed vma->vm_policy updates code but it is
the purpose of mbind_range().  Now, mbind_range() is virtually a no-op and
while it does not allow memory corruption it is not the right fix.  This
patch is a revert.

[mgorman@suse.de: Edited changelog]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>
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

mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
revert-mm-mempolicy-let-vma_merge-and-vma_split-handle-vma-vm_policy-linkages.patch


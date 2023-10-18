Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2297FCDB484
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbjJRVhk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235347AbjJRVgx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E95D11D
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:36:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA63C433C8;
        Wed, 18 Oct 2023 21:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664966;
        bh=LukgdMFYRXpKzDIWjpZxx0Wxy6DFAAWKdB6PKt0xy7c=;
        h=Date:To:From:Subject:From;
        b=oju7Jw4ZLqqjL3rSCrtfVBxTsnDEUaE8Rjj5bqkPHmKEBv3YgVt7B5+5iTSFrRmSS
         4A0oUvMhDJCh6EEWra7O8BlzuXIrGI0x7jis9Bv0lUHeg6BN8o8R6ltvkvKS/NYNuT
         QB0cqp/JylMCv+SArVXm77bK9/XA01D1nWfX0LEU=
Date:   Wed, 18 Oct 2023 14:36:05 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        vbabka@suse.cz, Liam.Howlett@oracle.com, brauner@kernel.org,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-abstract-merge-for-new-vmas-into-vma_merge_new_vma.patch removed from -mm tree
Message-Id: <20231018213605.DCA63C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: abstract merge for new VMAs into vma_merge_new_vma()
has been removed from the -mm tree.  Its filename was
     mm-abstract-merge-for-new-vmas-into-vma_merge_new_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: abstract merge for new VMAs into vma_merge_new_vma()
Date: Wed, 11 Oct 2023 18:04:30 +0100

Only in mmap_region() and copy_vma() do we attempt to merge VMAs which
occupy entirely new regions of virtual memory.

We can abstract this logic and make the intent of this invocations of it
completely explicit, rather than invoking vma_merge() with an inscrutable
 wall of parameters.

This also paves the way for a simplification of the core vma_merge()
implementation, as we seek to make it entirely an implementation detail.

The VMA merge call in mmap_region() occurs only for file-backed mappings,
where each of the parameters previously specified as NULL are defaulted to
NULL in vma_init() (called by vm_area_alloc()).

This matches the previous behaviour of specifying NULL for a number of
fields, however note that prior to this call we pass the VMA to the file
system driver via call_mmap(), which may in theory adjust fields that we
pass in to vma_merge_new_vma().

Therefore we actually resolve an oversight here by allowing for the fact
that the driver may have done this.

Link: https://lkml.kernel.org/r/3dc71d17e307756a54781d4a4ce7315cf8b18bea.1697043508.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/mm/mmap.c~mm-abstract-merge-for-new-vmas-into-vma_merge_new_vma
+++ a/mm/mmap.c
@@ -2486,6 +2486,20 @@ struct vm_area_struct *vma_modify(struct
 }
 
 /*
+ * Attempt to merge a newly mapped VMA with those adjacent to it. The caller
+ * must ensure that [start, end) does not overlap any existing VMA.
+ */
+static struct vm_area_struct
+*vma_merge_new_vma(struct vma_iterator *vmi, struct vm_area_struct *prev,
+		   struct vm_area_struct *vma, unsigned long start,
+		   unsigned long end, pgoff_t pgoff)
+{
+	return vma_merge(vmi, vma->vm_mm, prev, start, end, vma->vm_flags,
+			 vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma),
+			 vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+}
+
+/*
  * do_vmi_align_munmap() - munmap the aligned region from @start to @end.
  * @vmi: The vma iterator
  * @vma: The starting vm_area_struct
@@ -2840,10 +2854,9 @@ cannot_expand:
 		 * vma again as we may succeed this time.
 		 */
 		if (unlikely(vm_flags != vma->vm_flags && prev)) {
-			merge = vma_merge(&vmi, mm, prev, vma->vm_start,
-				    vma->vm_end, vma->vm_flags, NULL,
-				    vma->vm_file, vma->vm_pgoff, NULL,
-				    NULL_VM_UFFD_CTX, NULL);
+			merge = vma_merge_new_vma(&vmi, prev, vma,
+						  vma->vm_start, vma->vm_end,
+						  vma->vm_pgoff);
 			if (merge) {
 				/*
 				 * ->mmap() can change vma->vm_file and fput
@@ -3385,9 +3398,7 @@ struct vm_area_struct *copy_vma(struct v
 	if (new_vma && new_vma->vm_start < addr + len)
 		return NULL;	/* should never get here */
 
-	new_vma = vma_merge(&vmi, mm, prev, addr, addr + len, vma->vm_flags,
-			    vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma),
-			    vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+	new_vma = vma_merge_new_vma(&vmi, prev, vma, addr, addr + len, pgoff);
 	if (new_vma) {
 		/*
 		 * Source vma may have been merged into new_vma
_

Patches currently in -mm which might be from lstoakes@gmail.com are



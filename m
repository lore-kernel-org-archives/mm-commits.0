Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D007BC761A6
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 20:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbjCOURm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 16:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbjCOURg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 16:17:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D12F1CBCA
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 13:17:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B29EBB81F50
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 20:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA80C433D2;
        Wed, 15 Mar 2023 20:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678911452;
        bh=Kv6JqDyQjuLwN/rt1BQjYcG/eGPYcx34I6sGDeJbLPk=;
        h=Date:To:From:Subject:From;
        b=NDOC7bR96cv89qi9Fwt2yo/i5zMKsr2eDwfkhj2l4pRZvu2lvRkJ69K4vgsYfzvFY
         sye7IQfGcIu3tm0lya+qifYC7GS5tX+ausziv6V1OjJwK/wI6qcI4PEaXxO/NtyGwC
         rrAD9sk0HLQdCK+Dw0zOFgSa8vzy55RPNmkafUJ4=
Date:   Wed, 15 Mar 2023 13:17:31 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test.patch added to mm-unstable branch
Message-Id: <20230315201732.4AA80C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: start distinguishing if vma can be removed in mergeability test
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/mmap: start distinguishing if vma can be removed in mergeability test
Date: Thu, 9 Mar 2023 12:12:57 +0100

Since pre-git times, is_mergeable_vma() returns false for a vma with
vm_ops->close, so that no owner assumptions are violated in case the vma
is removed as part of the merge.

This check is currently very conservative and can prevent merging even
situations where vma can't be removed, such as simple expansion of
previous vma, as evidenced by commit d014cd7c1c35 ("mm, mremap: fix
mremap() expanding for vma's with vm_ops->close()")

In order to allow more merging when appropriate and simplify the code that
was made more complex by commit d014cd7c1c35, start distinguishing cases
where the vma can be really removed, and allow merging with vm_ops->close
otherwise.

As a first step, add a may_remove_vma parameter to is_mergeable_vma(). 
can_vma_merge_before() sets it to true, because when called from
vma_merge(), a removal of the vma is possible.

In can_vma_merge_after(), pass the parameter as false, because no
removal can occur in each of its callers:
- vma_merge() calls it on the 'prev' vma, which is never removed
- mmap_region() and do_brk_flags() call it to determine if it can expand
  a vma, which is not removed

As a result, vma's with vm_ops->close may now merge with compatible ranges
in more situations than previously.  We can also revert commit
d014cd7c1c35 as the next step to simplify mremap code again.

Link: https://lkml.kernel.org/r/20230309111258.24079-10-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/mm/mmap.c~mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test
+++ a/mm/mmap.c
@@ -755,12 +755,13 @@ int vma_shrink(struct vma_iterator *vmi,
 
 /*
  * If the vma has a ->close operation then the driver probably needs to release
- * per-vma resources, so we don't attempt to merge those.
+ * per-vma resources, so we don't attempt to merge those in case the caller
+ * indicates the current vma may be removed as part of the merge.
  */
 static inline bool is_mergeable_vma(struct vm_area_struct *vma,
 		struct file *file, unsigned long vm_flags,
 		struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
-		struct anon_vma_name *anon_name)
+		struct anon_vma_name *anon_name, bool may_remove_vma)
 {
 	/*
 	 * VM_SOFTDIRTY should not prevent from VMA merging, if we
@@ -774,7 +775,7 @@ static inline bool is_mergeable_vma(stru
 		return false;
 	if (vma->vm_file != file)
 		return false;
-	if (vma->vm_ops && vma->vm_ops->close)
+	if (may_remove_vma && vma->vm_ops && vma->vm_ops->close)
 		return false;
 	if (!is_mergeable_vm_userfaultfd_ctx(vma, vm_userfaultfd_ctx))
 		return false;
@@ -806,6 +807,8 @@ static inline bool is_mergeable_anon_vma
  * We don't check here for the merged mmap wrapping around the end of pagecache
  * indices (16TB on ia32) because do_mmap() does not permit mmap's which
  * wrap, nor mmaps which cover the final page at index -1UL.
+ *
+ * We assume the vma may be removed as part of the merge.
  */
 static bool
 can_vma_merge_before(struct vm_area_struct *vma, unsigned long vm_flags,
@@ -813,7 +816,7 @@ can_vma_merge_before(struct vm_area_stru
 		pgoff_t vm_pgoff, struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
 		struct anon_vma_name *anon_name)
 {
-	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name) &&
+	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name, true) &&
 	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
 		if (vma->vm_pgoff == vm_pgoff)
 			return true;
@@ -827,6 +830,8 @@ can_vma_merge_before(struct vm_area_stru
  *
  * We cannot merge two vmas if they have differently assigned (non-NULL)
  * anon_vmas, nor if same anon_vma is assigned but offsets incompatible.
+ *
+ * We assume that vma is not removed as part of the merge.
  */
 static bool
 can_vma_merge_after(struct vm_area_struct *vma, unsigned long vm_flags,
@@ -834,7 +839,7 @@ can_vma_merge_after(struct vm_area_struc
 		pgoff_t vm_pgoff, struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
 		struct anon_vma_name *anon_name)
 {
-	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name) &&
+	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name, false) &&
 	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
 		pgoff_t vm_pglen;
 		vm_pglen = vma_pages(vma);
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-reduce-page-alloc-free-sanity-checks.patch
mm-mmap-vma_merge-use-only-primary-pointers-for-preparing-merge.patch
mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-3.patch
mm-mmap-vma_merge-use-the-proper-vma-pointers-in-cases-1-and-6.patch
mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-4.patch
mm-mmap-vma_merge-initialize-mid-and-next-in-natural-order.patch
mm-mmap-vma_merge-set-mid-to-null-if-not-applicable.patch
mm-mmap-vma_merge-rename-adj_next-to-adj_start.patch
mm-mmap-vma_merge-convert-mergeability-checks-to-return-bool.patch
mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test.patch
mm-mremap-simplify-vma-expansion-again.patch


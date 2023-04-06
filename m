Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27942C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbjDFCpZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235132AbjDFCpA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:45:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8068A7A
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF85E6417C
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42316C433EF;
        Thu,  6 Apr 2023 02:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749098;
        bh=G3e7OsePSXysgTca8SoqvA5QVVY38FKCcyXCih6DhQ0=;
        h=Date:To:From:Subject:From;
        b=jdOKo/DnGGTxi4vVcbkoYZNuWaP1iw11/eSEjdCTRGa7bS/JWALsmL/mjPp8706aG
         34VXl2dcu1ZkTj3GRVRTA4t8MF8o7/bvAZvX6Bls7baqmVu/nH+BuB8U/dgaqqcCRa
         6hS/qgQvvZW2Ti8BAYNZn8oQI/+seZT8hKbiFlCQ=
Date:   Wed, 05 Apr 2023 19:44:57 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test.patch removed from -mm tree
Message-Id: <20230406024458.42316C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: start distinguishing if vma can be removed in mergeability test
has been removed from the -mm tree.  Its filename was
     mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[vbabka@suse.cz: adjust comment as suggested by Lorenzo]
  Link: https://lkml.kernel.org/r/74f2ea6c-f1a9-6dd7-260c-25e660f42379@suse.cz
Link: https://lkml.kernel.org/r/20230309111258.24079-10-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/mm/mmap.c~mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test
+++ a/mm/mmap.c
@@ -742,12 +742,13 @@ int vma_shrink(struct vma_iterator *vmi,
 
 /*
  * If the vma has a ->close operation then the driver probably needs to release
- * per-vma resources, so we don't attempt to merge those.
+ * per-vma resources, so we don't attempt to merge those if the caller indicates
+ * the current vma may be removed as part of the merge.
  */
 static inline bool is_mergeable_vma(struct vm_area_struct *vma,
 		struct file *file, unsigned long vm_flags,
 		struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
-		struct anon_vma_name *anon_name)
+		struct anon_vma_name *anon_name, bool may_remove_vma)
 {
 	/*
 	 * VM_SOFTDIRTY should not prevent from VMA merging, if we
@@ -761,7 +762,7 @@ static inline bool is_mergeable_vma(stru
 		return false;
 	if (vma->vm_file != file)
 		return false;
-	if (vma->vm_ops && vma->vm_ops->close)
+	if (may_remove_vma && vma->vm_ops && vma->vm_ops->close)
 		return false;
 	if (!is_mergeable_vm_userfaultfd_ctx(vma, vm_userfaultfd_ctx))
 		return false;
@@ -793,6 +794,8 @@ static inline bool is_mergeable_anon_vma
  * We don't check here for the merged mmap wrapping around the end of pagecache
  * indices (16TB on ia32) because do_mmap() does not permit mmap's which
  * wrap, nor mmaps which cover the final page at index -1UL.
+ *
+ * We assume the vma may be removed as part of the merge.
  */
 static bool
 can_vma_merge_before(struct vm_area_struct *vma, unsigned long vm_flags,
@@ -800,7 +803,7 @@ can_vma_merge_before(struct vm_area_stru
 		pgoff_t vm_pgoff, struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
 		struct anon_vma_name *anon_name)
 {
-	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name) &&
+	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name, true) &&
 	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
 		if (vma->vm_pgoff == vm_pgoff)
 			return true;
@@ -814,6 +817,8 @@ can_vma_merge_before(struct vm_area_stru
  *
  * We cannot merge two vmas if they have differently assigned (non-NULL)
  * anon_vmas, nor if same anon_vma is assigned but offsets incompatible.
+ *
+ * We assume that vma is not removed as part of the merge.
  */
 static bool
 can_vma_merge_after(struct vm_area_struct *vma, unsigned long vm_flags,
@@ -821,7 +826,7 @@ can_vma_merge_after(struct vm_area_struc
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

mm-page_alloc-use-check_pages_enabled-static-key-to-check-tail-pages.patch


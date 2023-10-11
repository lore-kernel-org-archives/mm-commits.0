Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F1CCDB470
	for <mm-commits@archiver.kernel.org>; Wed, 11 Oct 2023 17:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbjJKR4b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Oct 2023 13:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbjJKR4a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Oct 2023 13:56:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72250AF
        for <mm-commits@vger.kernel.org>; Wed, 11 Oct 2023 10:56:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7D8C433C8;
        Wed, 11 Oct 2023 17:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697046988;
        bh=0KJ948vAa6/3TT76rFDn1osWCrCxmKAmW+D37OSjS3k=;
        h=Date:To:From:Subject:From;
        b=wL8LAGxwikOV8kzwxz7p76kBPF3zSQ5fWUhxZS98PNKzgXJwbdgudUyXHKp+h+Wqp
         1qeQO/QHIG8W1oCODG2lj97cFJ5tKyG4Gkw7w9d99aVD9acwEz0r8DXIe7YPImsBGT
         m/bHcbL4+RuZMbUJChf8Vfee/Ce39QyjHZ0S4j9c=
Date:   Wed, 11 Oct 2023 10:56:17 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        vbabka@suse.cz, Liam.Howlett@oracle.com, brauner@kernel.org,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-abstract-merge-for-new-vmas-into-vma_merge_new_vma.patch added to mm-unstable branch
Message-Id: <20231011175625.5A7D8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: abstract merge for new VMAs into vma_merge_new_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-abstract-merge-for-new-vmas-into-vma_merge_new_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-abstract-merge-for-new-vmas-into-vma_merge_new_vma.patch

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
@@ -2848,10 +2862,9 @@ cannot_expand:
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
@@ -3393,9 +3406,7 @@ struct vm_area_struct *copy_vma(struct v
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

mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case.patch
mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix.patch
mm-make-__access_remote_vm-static.patch
mm-gup-explicitly-define-and-check-internal-gup-flags-disallow-foll_touch.patch
mm-gup-make-failure-to-pin-an-error-if-foll_nowait-not-specified.patch
mm-gup-adapt-get_user_page_vma_remote-to-never-return-null.patch
mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch
mm-update-memfd-seal-write-check-to-include-f_seal_write.patch
mm-enforce-the-mapping_map_writable-check-after-call_mmap.patch
mm-mprotect-allow-unfaulted-vmas-to-be-unaccounted-on-mprotect.patch
mm-move-vma_policy-and-anon_vma_name-decls-to-mm_typesh.patch
mm-abstract-the-vma_merge-split_vma-pattern-for-mprotect-et-al.patch
mm-make-vma_merge-and-split_vma-internal.patch
mm-abstract-merge-for-new-vmas-into-vma_merge_new_vma.patch
mm-abstract-vma-merge-and-extend-into-vma_merge_extend-helper.patch


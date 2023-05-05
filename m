Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B501C77B7D
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 20:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbjEEUax (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 16:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjEEUaw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 16:30:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8D7421D
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 13:30:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CECC60FC7
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 20:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD56C433D2;
        Fri,  5 May 2023 20:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683318650;
        bh=Xke8jnltsZp3W9Vd6gxFaMjxmYk4HRDvUKIrscsa45I=;
        h=Date:To:From:Subject:From;
        b=mqzBOrKf+Th2rbhXqIlIt1G7pl2z7pto1F2agNO3mb+PDJa27+eRUGcPKa48/odhj
         s0lX/YGpHCMeEjhWJoq/6DWjWjfN7B3oR6uGNvVjqgVXTZigJC1C5uveLWB/Ro3sxu
         5wPs/nWi2UVkYMwRCDrwrEDyO5YDze6fwHUmvR14=
Date:   Fri, 05 May 2023 13:30:49 -0700
To:     mm-commits@vger.kernel.org, peterz@infradead.org,
        mpenttil@redhat.com, kirill@shutemov.name, jhubbard@nvidia.com,
        jgg@nvidia.com, jack@suse.cz, david@redhat.com, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-separate-writenotify-and-dirty-tracking-logic.patch added to mm-unstable branch
Message-Id: <20230505203049.DDD56C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: separate writenotify and dirty tracking logic
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-separate-writenotify-and-dirty-tracking-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-separate-writenotify-and-dirty-tracking-logic.patch

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
Subject: mm/mmap: separate writenotify and dirty tracking logic
Date: Thu, 4 May 2023 22:27:51 +0100

Patch series "mm/gup: disallow GUP writing to file-backed mappings by
default", v9.

Writing to file-backed mappings which require folio dirty tracking using
GUP is a fundamentally broken operation, as kernel write access to GUP
mappings do not adhere to the semantics expected by a file system.

A GUP caller uses the direct mapping to access the folio, which does not
cause write notify to trigger, nor does it enforce that the caller marks
the folio dirty.

The problem arises when, after an initial write to the folio, writeback
results in the folio being cleaned and then the caller, via the GUP
interface, writes to the folio again.

As a result of the use of this secondary, direct, mapping to the folio no
write notify will occur, and if the caller does mark the folio dirty, this
will be done so unexpectedly.

For example, consider the following scenario:-

1. A folio is written to via GUP which write-faults the memory, notifying
   the file system and dirtying the folio.
2. Later, writeback is triggered, resulting in the folio being cleaned and
   the PTE being marked read-only.
3. The GUP caller writes to the folio, as it is mapped read/write via the
   direct mapping.
4. The GUP caller, now done with the page, unpins it and sets it dirty
   (though it does not have to).

This change updates both the PUP FOLL_LONGTERM slow and fast APIs.  As
pin_user_pages_fast_only() does not exist, we can rely on a slightly
imperfect whitelisting in the PUP-fast case and fall back to the slow case
should this fail.


This patch (of 3):

vma_wants_writenotify() is specifically intended for setting PTE page
table flags, accounting for existing page table flag state and whether the
underlying filesystem performs dirty tracking for a file-backed mapping.

Everything is predicated firstly on whether the mapping is shared
writable, as this is the only instance where dirty tracking is pertinent -
MAP_PRIVATE mappings will always be CoW'd and unshared, and read-only
file-backed shared mappings cannot be written to, even with FOLL_FORCE.

All other checks are in line with existing logic, though now separated
into checks eplicitily for dirty tracking and those for determining how to
set page table flags.

We make this change so we can perform checks in the GUP logic to determine
which mappings might be problematic when written to.

Link: https://lkml.kernel.org/r/cover.1683235180.git.lstoakes@gmail.com
Link: https://lkml.kernel.org/r/0f218370bd49b4e6bbfbb499f7c7b92c26ba1ceb.1683235180.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Mika Penttilä <mpenttil@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Kirill A . Shutemov <kirill@shutemov.name>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 
 mm/mmap.c          |   58 ++++++++++++++++++++++++++++++++++---------
 2 files changed, 47 insertions(+), 12 deletions(-)

--- a/include/linux/mm.h~mm-mmap-separate-writenotify-and-dirty-tracking-logic
+++ a/include/linux/mm.h
@@ -2435,6 +2435,7 @@ extern unsigned long move_page_tables(st
 #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
 					    MM_CP_UFFD_WP_RESOLVE)
 
+bool vma_needs_dirty_tracking(struct vm_area_struct *vma);
 int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
 static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
 {
--- a/mm/mmap.c~mm-mmap-separate-writenotify-and-dirty-tracking-logic
+++ a/mm/mmap.c
@@ -1456,6 +1456,48 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_ar
 }
 #endif /* __ARCH_WANT_SYS_OLD_MMAP */
 
+static bool vm_ops_needs_writenotify(const struct vm_operations_struct *vm_ops)
+{
+	return vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite);
+}
+
+static bool vma_is_shared_writable(struct vm_area_struct *vma)
+{
+	return (vma->vm_flags & (VM_WRITE | VM_SHARED)) ==
+		(VM_WRITE | VM_SHARED);
+}
+
+static bool vma_fs_can_writeback(struct vm_area_struct *vma)
+{
+	/* No managed pages to writeback. */
+	if (vma->vm_flags & VM_PFNMAP)
+		return false;
+
+	return vma->vm_file && vma->vm_file->f_mapping &&
+		mapping_can_writeback(vma->vm_file->f_mapping);
+}
+
+/*
+ * Does this VMA require the underlying folios to have their dirty state
+ * tracked?
+ */
+bool vma_needs_dirty_tracking(struct vm_area_struct *vma)
+{
+	/* Only shared, writable VMAs require dirty tracking. */
+	if (!vma_is_shared_writable(vma))
+		return false;
+
+	/* Does the filesystem need to be notified? */
+	if (vm_ops_needs_writenotify(vma->vm_ops))
+		return true;
+
+	/*
+	 * Even if the filesystem doesn't indicate a need for writenotify, if it
+	 * can writeback, dirty tracking is still required.
+	 */
+	return vma_fs_can_writeback(vma);
+}
+
 /*
  * Some shared mappings will want the pages marked read-only
  * to track write events. If so, we'll downgrade vm_page_prot
@@ -1464,21 +1506,18 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_ar
  */
 int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
 {
-	vm_flags_t vm_flags = vma->vm_flags;
-	const struct vm_operations_struct *vm_ops = vma->vm_ops;
-
 	/* If it was private or non-writable, the write bit is already clear */
-	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
+	if (!vma_is_shared_writable(vma))
 		return 0;
 
 	/* The backer wishes to know when pages are first written to? */
-	if (vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite))
+	if (vm_ops_needs_writenotify(vma->vm_ops))
 		return 1;
 
 	/* The open routine did something to the protections that pgprot_modify
 	 * won't preserve? */
 	if (pgprot_val(vm_page_prot) !=
-	    pgprot_val(vm_pgprot_modify(vm_page_prot, vm_flags)))
+	    pgprot_val(vm_pgprot_modify(vm_page_prot, vma->vm_flags)))
 		return 0;
 
 	/*
@@ -1492,13 +1531,8 @@ int vma_wants_writenotify(struct vm_area
 	if (userfaultfd_wp(vma))
 		return 1;
 
-	/* Specialty mapping? */
-	if (vm_flags & VM_PFNMAP)
-		return 0;
-
 	/* Can the mapping track the dirty pages? */
-	return vma->vm_file && vma->vm_file->f_mapping &&
-		mapping_can_writeback(vma->vm_file->f_mapping);
+	return vma_fs_can_writeback(vma);
 }
 
 /*
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-mmap-vma_merge-always-check-invariants.patch
mm-mmap-separate-writenotify-and-dirty-tracking-logic.patch
mm-gup-disallow-foll_longterm-gup-nonfast-writing-to-file-backed-mappings.patch
mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings.patch


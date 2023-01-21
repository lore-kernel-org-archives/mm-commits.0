Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB3FC27C76
	for <mm-commits@archiver.kernel.org>; Sat, 21 Jan 2023 01:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjAUBGf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjAUBGd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 20:06:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5D44672E
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2023 17:06:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0DEC620A1
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 01:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE67C433D2;
        Sat, 21 Jan 2023 01:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674263186;
        bh=ud8jgPTEW/MwJdY876Nb/+jophl5YqvAFVFSTBotfOM=;
        h=Date:To:From:Subject:From;
        b=vfTyPp5sD3TRu1eZy74MiA5cWP7SaquEovpgJ/Cdlb2dBA+OCytPBJ78pAq+mVzjK
         q1dwQimp6vlal7y1CeY6utPUl/61PQQ6c/dGtVj2u09oh0cLUiSaiSGE5XXYfyQ2PU
         eAGnAwxjPk54InuWfYsA6UwpKFil0w/e5XQbRv+k=
Date:   Fri, 20 Jan 2023 17:06:25 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-temporary-vma-iterator-versions-of-vma_merge-split_vma-and-__split_vma.patch added to mm-unstable branch
Message-Id: <20230121010626.0AE67C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add temporary vma iterator versions of vma_merge(), split_vma(), and __split_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-temporary-vma-iterator-versions-of-vma_merge-split_vma-and-__split_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-temporary-vma-iterator-versions-of-vma_merge-split_vma-and-__split_vma.patch

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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm: add temporary vma iterator versions of vma_merge(), split_vma(), and __split_vma()
Date: Fri, 20 Jan 2023 11:26:15 -0500

These wrappers are short-lived in this patch set so that each user can be
converted on its own.  In the end, these functions are renamed in one
commit.

Link: https://lkml.kernel.org/r/20230120162650.984577-15-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-add-temporary-vma-iterator-versions-of-vma_merge-split_vma-and-__split_vma
+++ a/include/linux/mm.h
@@ -2843,11 +2843,20 @@ extern struct vm_area_struct *vma_merge(
 	struct vm_area_struct *prev, unsigned long addr, unsigned long end,
 	unsigned long vm_flags, struct anon_vma *, struct file *, pgoff_t,
 	struct mempolicy *, struct vm_userfaultfd_ctx, struct anon_vma_name *);
+extern struct vm_area_struct *vmi_vma_merge(struct vma_iterator *vmi,
+	struct mm_struct *, struct vm_area_struct *prev, unsigned long addr,
+	unsigned long end, unsigned long vm_flags, struct anon_vma *,
+	struct file *, pgoff_t, struct mempolicy *, struct vm_userfaultfd_ctx,
+	struct anon_vma_name *);
 extern struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *);
 extern int __split_vma(struct mm_struct *, struct vm_area_struct *,
-	unsigned long addr, int new_below);
+			       unsigned long addr, int new_below);
+extern int vmi__split_vma(struct vma_iterator *vmi, struct mm_struct *,
+	struct vm_area_struct *, unsigned long addr, int new_below);
 extern int split_vma(struct mm_struct *, struct vm_area_struct *,
 	unsigned long addr, int new_below);
+extern int vmi_split_vma(struct vma_iterator *vmi, struct mm_struct *,
+		struct vm_area_struct *, unsigned long addr, int new_below);
 extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
 extern void unlink_file_vma(struct vm_area_struct *);
 extern struct vm_area_struct *copy_vma(struct vm_area_struct **,
--- a/mm/mmap.c~mm-add-temporary-vma-iterator-versions-of-vma_merge-split_vma-and-__split_vma
+++ a/mm/mmap.c
@@ -1091,6 +1091,25 @@ struct vm_area_struct *vma_merge(struct
 	return res;
 }
 
+struct vm_area_struct *vmi_vma_merge(struct vma_iterator *vmi,
+			struct mm_struct *mm,
+			struct vm_area_struct *prev, unsigned long addr,
+			unsigned long end, unsigned long vm_flags,
+			struct anon_vma *anon_vma, struct file *file,
+			pgoff_t pgoff, struct mempolicy *policy,
+			struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
+			struct anon_vma_name *anon_name)
+{
+	struct vm_area_struct *tmp;
+
+	tmp = vma_merge(mm, prev, addr, end, vm_flags, anon_vma, file, pgoff,
+			policy, vm_userfaultfd_ctx, anon_name);
+	if (tmp)
+		vma_iter_set(vmi, end);
+
+	return tmp;
+}
+
 /*
  * Rough compatibility check to quickly see if it's even worth looking
  * at sharing an anon_vma.
@@ -2276,6 +2295,18 @@ int __split_vma(struct mm_struct *mm, st
 	validate_mm_mt(mm);
 	return err;
 }
+int vmi__split_vma(struct vma_iterator *vmi, struct mm_struct *mm,
+		   struct vm_area_struct *vma, unsigned long addr, int new_below)
+{
+	int ret;
+	unsigned long end = vma->vm_end;
+
+	ret = __split_vma(mm, vma, addr, new_below);
+	if (!ret)
+		vma_iter_set(vmi, end);
+
+	return ret;
+}
 
 /*
  * Split a vma into two pieces at address 'addr', a new vma is allocated
@@ -2290,6 +2321,19 @@ int split_vma(struct mm_struct *mm, stru
 	return __split_vma(mm, vma, addr, new_below);
 }
 
+int vmi_split_vma(struct vma_iterator *vmi, struct mm_struct *mm,
+		  struct vm_area_struct *vma, unsigned long addr, int new_below)
+{
+	int ret;
+	unsigned long end = vma->vm_end;
+
+	ret = split_vma(mm, vma, addr, new_below);
+	if (!ret)
+		vma_iter_set(vmi, end);
+
+	return ret;
+}
+
 static inline int munmap_sidetree(struct vm_area_struct *vma,
 				   struct ma_state *mas_detach)
 {
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple_tree-add-mas_init-function.patch
maple_tree-fix-potential-rcu-issue.patch
maple_tree-reduce-user-error-potential.patch
test_maple_tree-test-modifications-while-iterating.patch
mm-expand-vma-iterator-interface.patch
mm-mmap-convert-brk-to-use-vma-iterator.patch
kernel-fork-convert-forking-to-using-the-vmi-iterator.patch
mmap-convert-vma_link-vma-iterator.patch
mm-mmap-remove-preallocation-from-do_mas_align_munmap.patch
mmap-change-do_mas_munmap-and-do_mas_aligned_munmap-to-use-vma-iterator.patch
mmap-convert-vma_expand-to-use-vma-iterator.patch
mm-add-temporary-vma-iterator-versions-of-vma_merge-split_vma-and-__split_vma.patch
ipc-shm-use-the-vma-iterator-for-munmap-calls.patch
userfaultfd-use-vma-iterator.patch
mm-change-mprotect_fixup-to-vma-iterator.patch
mlock-convert-mlock-to-vma-iterator.patch
coredump-convert-to-vma-iterator.patch
mempolicy-convert-to-vma-iterator.patch
task_mmu-convert-to-vma-iterator.patch
sched-convert-to-vma-iterator.patch
madvise-use-vmi-iterator-for-__split_vma-and-vma_merge.patch
mmap-pass-through-vmi-iterator-to-__split_vma.patch
mmap-use-vmi-version-of-vma_merge.patch
mm-mremap-use-vmi-version-of-vma_merge.patch
nommu-convert-nommu-to-using-the-vma-iterator.patch
mm-switch-vma_merge-split_vma-and-__split_vma-to-vma-iterator.patch
mmap-convert-__vma_adjust-to-use-vma-iterator.patch
mm-pass-through-vma-iterator-to-__vma_adjust.patch
madvise-use-split_vma-instead-of-__split_vma.patch
mm-remove-unnecessary-write-to-vma-iterator-in-__vma_adjust.patch
mm-pass-vma-iterator-through-to-__vma_adjust.patch
mm-add-vma-iterator-to-vma_adjust-arguments.patch
mmap-clean-up-mmap_region-unrolling.patch
mm-change-munmap-splitting-order-and-move_vma.patch
mm-mmap-move-anon_vma-setting-in-__vma_adjust.patch
mm-mmap-refactor-locking-out-of-__vma_adjust.patch
mm-mmap-use-vma_prepare-and-vma_complete-in-vma_expand.patch
mm-mmap-introduce-init_vma_prep-and-init_multi_vma_prep.patch
mm-dont-use-__vma_adjust-in-__split_vma.patch
mm-mmap-dont-use-__vma_adjust-in-shift_arg_pages.patch
mm-mmap-introduce-dup_vma_anon-helper.patch
mm-mmap-convert-do_brk_flags-to-use-vma_prepare-and-vma_complete.patch
mm-mmap-remove-__vma_adjust.patch
vma_merge-set-vma-iterator-to-correct-position.patch


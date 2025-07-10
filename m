Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390C8469D
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 04:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122083; cv=none; b=eZ43hpHDYnkK1PxjD9D9jamPc3eIwrVLfsTw3ancnoCkxvjooJZpEImPsSbdc7O7nWY6kTflurmbFv6CzreMHufmbq7TrkcIiqJ/Iu3cfBY3xCLvzZwvrxkXzAJeMeRcajRKV0srcexPEmY+7ZaPBDhiJw1oDFo2xHobPHzS43A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122083; c=relaxed/simple;
	bh=WsrgJWtLGjiy93caHcN6hEX6lUqWA+y48CGuQWWayDQ=;
	h=Date:To:From:Subject:Message-Id; b=fBSAEeE6Pn7Ex3SEu1UliAWs0+fb8XeQaj/9S8dyUtx+D+3RI2x2Pi9w59T0Ah+FWkVvInpZB5Kc9AV94ffRIrrAjhPRj9lrNFYzjDFxsPbgxx9GxYsQvhPdF/6M3ags5ASHkfUm0AXsxYBThRVg/U3zl5thfL/8XYN2FU9ok08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zlx8Lrvg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zlx8Lrvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E94AC4CEE3;
	Thu, 10 Jul 2025 04:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752122082;
	bh=WsrgJWtLGjiy93caHcN6hEX6lUqWA+y48CGuQWWayDQ=;
	h=Date:To:From:Subject:From;
	b=Zlx8LrvglsKUMeBz4KjZlU7kIZzZBahayMMRrIshpezfDUH37Uv2+C4QuBZW0S5yt
	 /r2RI4oVHz49WxoodcCJZzksv6My8wv7MVPpewdkdwemKPAblE7GeFnI2vMGULQ9RM
	 3Fdv5KV8vxuiSX2megQcKywMlkuCg5OiNvRWm5ro=
Date: Wed, 09 Jul 2025 21:34:42 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,viro@zeniv.linux.org.uk,vbabka@suse.cz,shr@devkernel.io,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,david@redhat.com,chengming.zhou@linux.dev,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas-fix.patch removed from -mm tree
Message-Id: <20250710043442.9E94AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: correctly invoke late KSM check after mmap hook
has been removed from the -mm tree.  Its filename was
     mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas-fix.patch

This patch was dropped because it was folded into mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: correctly invoke late KSM check after mmap hook
Date: Fri, 20 Jun 2025 13:21:03 +0100

Previously we erroneously checked whether KSM was applicable prior to
invoking the f_op->mmap() hook in the case of not being able to perform
this check early.

This is problematic, as filesystems such as hugetlb, which use anonymous
memory and might otherwise get KSM'd, set VM_HUGETLB in the f_op->mmap()
hook.

Correct this by checking at the appropriate time.

Link: https://lkml.kernel.org/r/5861f8f6-cf5a-4d82-a062-139fb3f9cddb@lucifer.local
Reported-by: syzbot+a74a028d848147bc5931@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6853fc57.a00a0220.137b3.0009.GAE@google.com/
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/mm/vma.c~mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas-fix
+++ a/mm/vma.c
@@ -32,6 +32,9 @@ struct mmap_state {
 	struct vma_munmap_struct vms;
 	struct ma_state mas_detach;
 	struct maple_tree mt_detach;
+
+	/* Determine if we can check KSM flags early in mmap() logic. */
+	bool check_ksm_early;
 };
 
 #define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, flags_, file_) \
@@ -2320,6 +2323,11 @@ static void vms_abort_munmap_vmas(struct
 	vms_complete_munmap_vmas(vms, mas_detach);
 }
 
+static void update_ksm_flags(struct mmap_state *map)
+{
+	map->flags = ksm_vma_flags(map->mm, map->file, map->flags);
+}
+
 /*
  * __mmap_prepare() - Prepare to gather any overlapping VMAs that need to be
  * unmapped once the map operation is completed, check limits, account mapping
@@ -2424,6 +2432,7 @@ static int __mmap_new_file_vma(struct mm
 			!(map->flags & VM_MAYWRITE) &&
 			(vma->vm_flags & VM_MAYWRITE));
 
+	map->file = vma->vm_file;
 	map->flags = vma->vm_flags;
 
 	return 0;
@@ -2473,6 +2482,11 @@ static int __mmap_new_vma(struct mmap_st
 	if (error)
 		goto free_iter_vma;
 
+	if (!map->check_ksm_early) {
+		update_ksm_flags(map);
+		vm_flags_init(vma, map->flags);
+	}
+
 #ifdef CONFIG_SPARC64
 	/* TODO: Fix SPARC ADI! */
 	WARN_ON_ONCE(!arch_validate_flags(map->flags));
@@ -2592,11 +2606,6 @@ static void set_vma_user_defined_fields(
 	vma->vm_private_data = map->vm_private_data;
 }
 
-static void update_ksm_flags(struct mmap_state *map)
-{
-	map->flags = ksm_vma_flags(map->mm, map->file, map->flags);
-}
-
 /*
  * Are we guaranteed no driver can change state such as to preclude KSM merging?
  * If so, let's set the KSM mergeable flag early so we don't break VMA merging.
@@ -2636,7 +2645,8 @@ static unsigned long __mmap_region(struc
 	bool have_mmap_prepare = file && file->f_op->mmap_prepare;
 	VMA_ITERATOR(vmi, mm, addr);
 	MMAP_STATE(map, mm, &vmi, addr, len, pgoff, vm_flags, file);
-	bool check_ksm_early = can_set_ksm_flags_early(&map);
+
+	map.check_ksm_early = can_set_ksm_flags_early(&map);
 
 	error = __mmap_prepare(&map, uf);
 	if (!error && have_mmap_prepare)
@@ -2644,7 +2654,7 @@ static unsigned long __mmap_region(struc
 	if (error)
 		goto abort_munmap;
 
-	if (check_ksm_early)
+	if (map.check_ksm_early)
 		update_ksm_flags(&map);
 
 	/* Attempt to merge with adjacent VMAs... */
@@ -2656,9 +2666,6 @@ static unsigned long __mmap_region(struc
 
 	/* ...but if we can't, allocate a new VMA. */
 	if (!vma) {
-		if (!check_ksm_early)
-			update_ksm_flags(&map);
-
 		error = __mmap_new_vma(&map, &vma);
 		if (error)
 			goto unacct_error;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-use-per_vma-lock-for-madv_dontneed-fix.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
secretmem-remove-uses-of-struct-page-fix.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge-fix.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument-fix.patch
mm-update-core-kernel-code-to-use-vm_flags_t-consistently.patch
mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch
mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch
tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap-fix.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch


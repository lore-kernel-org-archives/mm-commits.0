Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED99101EE
	for <mm-commits@vger.kernel.org>; Sun, 22 Jun 2025 19:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750619975; cv=none; b=m3ppfaeUjiRKoymyUl7X1QUTBnqwNeVniuohylD3P6nmuT2LneIeEqP3aFjnpg9g+mrBvJA088+93iRwPS7zbMVkzsi+O5dG0wYmReY72FnwhaqO3ghxXlCTP/EDgzmDUpwja+AbkZI9o0hi8E41z11L498ORJI/ubpIhBstokE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750619975; c=relaxed/simple;
	bh=SNX4hd/ZZ9aOk/EJ+Vwws4ROwy9J/YhG4/fveKHcJGc=;
	h=Date:To:From:Subject:Message-Id; b=p7hn26WSUHeANeGpIjngpgnK5+GJpgqDbelPU6G+oi6Chc9/nJGGpZrbv8YgsEeI6rdzKEG54ZnwRCQLlX5lWoS4mCE09aq7pr25yy6zLZaD2hXxDzSob/Cn/e1nnu8Zv1ajZNsHzgCfjhKi1C4E/VgG48HKQ0rmTCmHOaO6ITg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z6L3DN+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z6L3DN+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFC2C4CEE3;
	Sun, 22 Jun 2025 19:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750619974;
	bh=SNX4hd/ZZ9aOk/EJ+Vwws4ROwy9J/YhG4/fveKHcJGc=;
	h=Date:To:From:Subject:From;
	b=z6L3DN+s7WDlKjOn9COqAdJ1Q3IYJyWfInhtUdV1bnX4/H1eWSIrQv8sB3MC7a1qT
	 kMeWgxJjyTlKQ1Etb1KLCW2QmvkCud6I8AJLr24lrGmypFPl3ylSRg27FFI+4+Pyqj
	 B8SQ+Gf1pmRMS9M90krqhozriXUBsRXboRuz8NKo=
Date: Sun, 22 Jun 2025 12:19:33 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,viro@zeniv.linux.org.uk,vbabka@suse.cz,shr@devkernel.io,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,david@redhat.com,chengming.zhou@linux.dev,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas-fix.patch added to mm-unstable branch
Message-Id: <20250622191934.5FFC2C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: correctly invoke late KSM check after mmap hook
has been added to the -mm mm-unstable branch.  Its filename is
     mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas-fix.patch

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

 mm/vma.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

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
@@ -2424,6 +2427,7 @@ static int __mmap_new_file_vma(struct mm
 			!(map->flags & VM_MAYWRITE) &&
 			(vma->vm_flags & VM_MAYWRITE));
 
+	map->file = vma->vm_file;
 	map->flags = vma->vm_flags;
 
 	return 0;
@@ -2473,6 +2477,11 @@ static int __mmap_new_vma(struct mmap_st
 	if (error)
 		goto free_iter_vma;
 
+	if (!map->check_ksm_early) {
+		update_ksm_flags(map);
+		vm_flags_init(vma, map->vm_flags);
+	}
+
 #ifdef CONFIG_SPARC64
 	/* TODO: Fix SPARC ADI! */
 	WARN_ON_ONCE(!arch_validate_flags(map->flags));
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

maintainers-add-missing-files-to-mm-page-alloc-section.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas-fix.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-use-per_vma-lock-for-madv_dontneed-fix.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon-fix.patch
mm-mremap-add-mremap_must_relocate_anon.patch
mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch
tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch
tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch
tools-testing-selftests-add-mremap-cases-that-merge-normally.patch
tools-testing-selftests-add-mremap_relocate_anon-merge-test-cases.patch
tools-testing-selftests-expand-mremap-tests-for-mremap_relocate_anon.patch
tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch
tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch
tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch
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


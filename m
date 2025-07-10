Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D1A469D
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 04:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122516; cv=none; b=j76Y/MOHWrrMHjvT0wEQP0HlJsg4vjctvqNx28qAEjFjZ5DmS2n555RuOKO7cUyNbx4slOw70wP0LdMEI7jZn/WMp46ciquxzLgkLKAFcOtHb27/5jDORWa6/NpLJldzFaEHn+il6sNuinguyMxnu3zIO7N9bUEfPjtnGMTyISY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122516; c=relaxed/simple;
	bh=1VfTmGcaPXMPRSgd3lVxtlH8Ld3yUm32sSuWNig4c/s=;
	h=Date:To:From:Subject:Message-Id; b=EuHc+VPLb5Hs9xrKVAlvcZvGy0TE3qqqKhnJAFmaNs6rIDQWv8IiWpOFWev0D49RxtW4jEHzmE46mVm6U+nFC0dbo+gJ5cgaabb45FGpXbEvZQXu2GNmIpeguDzhKQ4eLPZcM7I20rsjFSSQ4sdbK553dWHVUX11SBHKoQKw8Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=th08SjKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="th08SjKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED5DC4CEE3;
	Thu, 10 Jul 2025 04:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752122516;
	bh=1VfTmGcaPXMPRSgd3lVxtlH8Ld3yUm32sSuWNig4c/s=;
	h=Date:To:From:Subject:From;
	b=th08SjKvq/wA/SckRBlQU8L4ILZVWQgg1plHfaMpIN0B4C1bcQ6TuVpd/KYl5RArR
	 3mKr1FNT7OEgWVcdhmRFCFZEBN3SJXkUg9IblWVOljas7NtCvi2st2Ly+VpRxHtpLT
	 g51OrLc5zqRf3aQtcnan01otIRaTYhhN5PcDciqk=
Date: Wed, 09 Jul 2025 21:41:55 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,liam.howlett@oracle.com,kees@kernel.org,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge-fix.patch removed from -mm tree
Message-Id: <20250710044156.3ED5DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make comment consistent in vma_expand()
has been removed from the -mm tree.  Its filename was
     mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge-fix.patch

This patch was dropped because it was folded into mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: make comment consistent in vma_expand()
Date: Thu, 19 Jun 2025 15:32:57 +0100

The VMA merge structure contains a pointer to mm_struct so we don't need
to determine it from an input VMA's vm_mm field.  Update the comment to
reflect this and make it consistent with vma_merge_new_range() and
vma_merge_existing_range().

Link: https://lkml.kernel.org/r/c54f45e3-a6ac-4749-93c0-cc9e3080ee37@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vma.c~mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge-fix
+++ a/mm/vma.c
@@ -1114,7 +1114,7 @@ struct vm_area_struct *vma_merge_new_ran
  * Returns: 0 on success.
  *
  * ASSUMPTIONS:
- * - The caller must hold a WRITE lock on vmg->target->mm->mmap_lock.
+ * - The caller must hold a WRITE lock on the mm_struct->mmap_lock.
  * - The caller must have set @vmg->target and @vmg->next.
  */
 int vma_expand(struct vma_merge_struct *vmg)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330DA27FB2B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 04:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122278; cv=none; b=U6y6/Fo05eAv7eC1CTajW0awFIOpqo9PlBGpY009P3OBekjD8DcQsv8rNdJgHqY1DdKDUU6FtSwcXDuFGcQOLbvxLEuWcaOZdvdmMNqZKmXhdq77y0Q8Zmbq3DW+r3UD+sikKwWiaQW2g9wGc6TRT6YvXriQCkQvqJsdo/OtSFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122278; c=relaxed/simple;
	bh=7ygMwKekYBgK1T6aWU/jhrvg3+qh5s1YFU1AsvXP6sI=;
	h=Date:To:From:Subject:Message-Id; b=uqxz2Np+bJgJZvvfq9kNdX3rb1IvJ3QorQrD0Io7zCHGhHs/fgYNm/VVCnU8M39SRX2V7woeEDjcIAl7XFSyXqxGz5xl9rOZwJErEifbDAkhbreid/Hdc8V7jlPgdQMZ6W1USh4tX+WFrYFXn3vyC9PeRMEfOzzApjSD518fQyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N2SqfD1T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N2SqfD1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057E3C4CEED;
	Thu, 10 Jul 2025 04:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752122278;
	bh=7ygMwKekYBgK1T6aWU/jhrvg3+qh5s1YFU1AsvXP6sI=;
	h=Date:To:From:Subject:From;
	b=N2SqfD1Tl3tZ+BkNXS+kAHhv3+ppXPDP9Lir7iM9DLoyqlLViiHCAmMsEKn17S9cg
	 UKWMJsWCIjNdHU36sABrPPirptHkUFcKAhn1FpGaPsSY2FNw0qUh49hsmCRs56nGcZ
	 jva9TvVKGPvumEFWgn+1kyfr4VvDCwkl8J01X8Jc=
Date: Wed, 09 Jul 2025 21:37:57 -0700
To: mm-commits@vger.kernel.org,zhengtangquan@oppo.com,zhengqi.arch@bytedance.com,v-songbaohua@oppo.com,vbabka@suse.cz,surenb@google.com,lokeshgidra@google.com,Liam.Howlett@oracle.com,jannh@google.com,ioworker0@gmail.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-use-per_vma-lock-for-madv_dontneed-fix.patch removed from -mm tree
Message-Id: <20250710043758.057E3C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: avoid any chance of uninitialised pointer deref
has been removed from the -mm tree.  Its filename was
     mm-use-per_vma-lock-for-madv_dontneed-fix.patch

This patch was dropped because it was folded into mm-use-per_vma-lock-for-madv_dontneed.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/madvise: avoid any chance of uninitialised pointer deref
Date: Tue, 17 Jun 2025 14:35:13 +0100

If we were to extend madvise() to support more operations under VMA lock,
we could potentially dereference prev to uninitialised state in
madvise_update_vma().

Avoid this by explicitly setting prev to vma before invoking the visit()
function.

This has no impact on behaviour, as all visitors compatible with a VMA
lock do not require prev to be set to the previous VMA and at any rate we
only examine a single VMA in VMA lock mode.

Link: https://lkml.kernel.org/r/309d22ca-6cd9-4601-8402-d441a07d9443@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Lance Yang <ioworker0@gmail.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tangquan Zheng <zhengtangquan@oppo.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/madvise.c~mm-use-per_vma-lock-for-madv_dontneed-fix
+++ a/mm/madvise.c
@@ -1320,6 +1320,8 @@ static int madvise_vma_behavior(struct v
 		return madvise_guard_remove(vma, prev, start, end);
 	}
 
+	/* We cannot provide prev in this lock mode. */
+	VM_WARN_ON_ONCE(arg->lock_mode == MADVISE_VMA_READ_LOCK);
 	anon_name = anon_vma_name(vma);
 	anon_vma_name_get(anon_name);
 	error = madvise_update_vma(vma, prev, start, end, new_flags,
@@ -1536,6 +1538,7 @@ int madvise_walk_vmas(struct mm_struct *
 	if (madv_behavior && madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK) {
 		vma = try_vma_read_lock(mm, madv_behavior, start, end);
 		if (vma) {
+			prev = vma;
 			error = visit(vma, &prev, start, end, arg);
 			vma_end_read(vma);
 			return error;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-use-per_vma-lock-for-madv_dontneed.patch
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


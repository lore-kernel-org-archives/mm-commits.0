Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4751C863B
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 03:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750391357; cv=none; b=AEUbvUBFn+j8yrQNB9t1yjbIc13j/J5SDjQvsoiu9lRZLxgfJzgLJ0u69B6q2ny4hYAYFdPnZD/uXKtn7M/Cnpy6t7qDj7PwSKpubZBI8ddUemleChE7BaxhBsK3oxRkpEMF2VH62X4oA8cH1wS7pOTGIdQfQe6x3MJlPigZLEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750391357; c=relaxed/simple;
	bh=0X6iV336+Pr1bRyE+bhmeYNDuG1yuM9mGsZtpcBOi38=;
	h=Date:To:From:Subject:Message-Id; b=tHcxjdQRUTo3bnhoDUPB5I7+5r5oAs892ae5VuOWdwesdLNGDg1m16m9eQOJhuEPQbmobeAbzRlh7neKYjp/zhE3SDJCxZOooYvjJ6DUNNxruNHA4VGd/SSpWqlKJnag6lvxhW+Ao5xqStTuaAxY0xqbJHm0gHH9mbKL43LRP0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EL+jPNLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EL+jPNLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6EAC4CEE3;
	Fri, 20 Jun 2025 03:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750391357;
	bh=0X6iV336+Pr1bRyE+bhmeYNDuG1yuM9mGsZtpcBOi38=;
	h=Date:To:From:Subject:From;
	b=EL+jPNLx5ITg+0+TRPkvpu5nB9MPH7ZhCsZNphTALM/GQ9q6HuW65iSw8V7t4zz5J
	 rxSoKidRRSZx2Di9cugSVgYtdVXuLxhQxAyfggHHjKb2F2Pj/fOwBReUkpL8nGIvLg
	 kl+nVEs0N6Eh/uPXaJjWMbZadHuOqjGV/+vEP6bI=
Date: Thu, 19 Jun 2025 20:49:17 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,shakeel.butt@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section.patch removed from -mm tree
Message-Id: <20250620034917.9B6EAC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add missing mm/workingset.c file to mm reclaim section
has been removed from the -mm tree.  Its filename was
     maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add missing mm/workingset.c file to mm reclaim section
Date: Mon, 16 Jun 2025 21:16:43 +0100

The working set logic belongs very much to the reclaim section and is
otherwise not assigned to any other MAINTAINERS section so add it here.

Link: https://lkml.kernel.org/r/20250616201643.561626-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section
+++ a/MAINTAINERS
@@ -15871,6 +15871,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/pt_reclaim.c
 F:	mm/vmscan.c
+F:	mm/workingset.c
 
 MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
 M:	Andrew Morton <akpm@linux-foundation.org>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-files-to-mm-page-alloc-section.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
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


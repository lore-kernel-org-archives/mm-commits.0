Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F21E1411EB
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 20:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727382754; cv=none; b=Zhg+CLhvvzrDZSTB4jIYoK2keAYxYzAysVIANhLxsnC92XqioA+20e3G3921w2zkpigF7JkC1Nqf4bayFnIzIZqDg7zD1IJ9mbLFrjAKepSf78Lwpox75dVQTDzC0o624zO6GgrwvMw+DPjyFCM0s4T51T9rRyRAexQVc6J6gy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727382754; c=relaxed/simple;
	bh=aghIuqkeW8yTJBN6IxXsPLYCkNLTmZgSQRxp7n4KHd4=;
	h=Date:To:From:Subject:Message-Id; b=lBP0J0HV+OQiCkhB5Az42tCbeQQAVnjYQRdRqZ8ummixLn1UDaOvqnx+jeDhvQxZG/7CVo5yKNOg84Zji8nymwM4VkCILJuM8rE3vf6qS1vpVF8nvObZyfDhjEf5rhtoYMLftSIGr9/kcovJ3gJGqWnhp4AHU3cs30OSqS4g69E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uLfQ9tFf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uLfQ9tFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1DCC4CEC7;
	Thu, 26 Sep 2024 20:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727382753;
	bh=aghIuqkeW8yTJBN6IxXsPLYCkNLTmZgSQRxp7n4KHd4=;
	h=Date:To:From:Subject:From;
	b=uLfQ9tFf1+qdyMzBMO19LxLJmKfzu7pq/aNpTh8OC0FzYJ+im4Z7A/2QGD6WTfInj
	 Ls5e49kM3gVLsvCHpdqi7GqJJ9XuGZ++MB/yCulWdyMon5tei1aykZGcH6rdBSifIt
	 Rl4s8Ml8HVIpalI+b+skmKEUbHGPHdClsAxiaTI8=
Date: Thu, 26 Sep 2024 13:32:32 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-assert_pte_locked-use-pte_offset_map_ro_nolock.patch added to mm-unstable branch
Message-Id: <20240926203233.8E1DCC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc: assert_pte_locked() use pte_offset_map_ro_nolock()
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-assert_pte_locked-use-pte_offset_map_ro_nolock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-assert_pte_locked-use-pte_offset_map_ro_nolock.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: powerpc: assert_pte_locked() use pte_offset_map_ro_nolock()
Date: Thu, 26 Sep 2024 14:46:15 +0800

In assert_pte_locked(), we just get the ptl and assert if it was already
held, so convert it to using pte_offset_map_ro_nolock().

Link: https://lkml.kernel.org/r/42559e042eb6fc3129a40f710d671712030646b4.1727332572.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/pgtable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/pgtable.c~powerpc-assert_pte_locked-use-pte_offset_map_ro_nolock
+++ a/arch/powerpc/mm/pgtable.c
@@ -398,7 +398,7 @@ void assert_pte_locked(struct mm_struct
 	 */
 	if (pmd_none(*pmd))
 		return;
-	pte = pte_offset_map_nolock(mm, pmd, addr, &ptl);
+	pte = pte_offset_map_ro_nolock(mm, pmd, addr, &ptl);
 	BUG_ON(!pte);
 	assert_spin_locked(ptl);
 	pte_unmap(pte);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-pgtable-introduce-pte_offset_map_rorw_nolock.patch
powerpc-assert_pte_locked-use-pte_offset_map_ro_nolock.patch
mm-filemap-filemap_fault_recheck_pte_none-use-pte_offset_map_ro_nolock.patch
mm-khugepaged-__collapse_huge_page_swapin-use-pte_offset_map_ro_nolock.patch
arm-adjust_pte-use-pte_offset_map_rw_nolock.patch
mm-handle_pte_fault-use-pte_offset_map_rw_nolock.patch
mm-khugepaged-collapse_pte_mapped_thp-use-pte_offset_map_rw_nolock.patch
mm-copy_pte_range-use-pte_offset_map_rw_nolock.patch
mm-mremap-move_ptes-use-pte_offset_map_rw_nolock.patch
mm-page_vma_mapped_walk-map_pte-use-pte_offset_map_rw_nolock.patch
mm-userfaultfd-move_pages_pte-use-pte_offset_map_rw_nolock.patch
mm-multi-gen-lru-walk_pte_range-use-pte_offset_map_rw_nolock.patch
mm-pgtable-remove-pte_offset_map_nolock.patch


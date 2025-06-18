Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B0027F01E
	for <mm-commits@vger.kernel.org>; Wed, 18 Jun 2025 23:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750288635; cv=none; b=S2LyCZxFRXyAtJIVOvOIOAQk6mYvGKnDjQvCWV2VTS8VTnCs0o/Gyulm2LCoFnS3NhwXL6MOw+pzUqGaUmSATOGKzfZ5QvZkDRCBaFxJzx8Vb6mC27mCpuz6TXyTbMwRhKNoqhSH6xHs3OksYZVSJVJJrib5Z15J9CVoVofdmsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750288635; c=relaxed/simple;
	bh=1hlkIg7NTWcTMZzkAR2hi8flg7mkLseHov5kLp2DuGA=;
	h=Date:To:From:Subject:Message-Id; b=W9bkFttOjGNGzp4d2hy75qdSg/4i/2wmtXxPs1jy4+H2kkG48oKVn63QC0tRyoYQf9FVSJ19ZMxFYCfVB1y9SE5upgEYqYBYXr7opT74gaJdB0fSL97gnrZejGZbSgUkohhBa9fx4ZBqigKxytLc3h+Zr4l//VxiCSfJdwmbKck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nU3UBGJZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nU3UBGJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB014C4CEE7;
	Wed, 18 Jun 2025 23:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750288634;
	bh=1hlkIg7NTWcTMZzkAR2hi8flg7mkLseHov5kLp2DuGA=;
	h=Date:To:From:Subject:From;
	b=nU3UBGJZ0t0ypZHicZEd9LYzI3eLtjRU+c9Bo1MdRhKJ22m6QIyCjpitGwFGCUrc3
	 UaCHEeHqnmT2Kf8JTRl7nQ0UGDCMyLsohb0Ps3OCeGAoVsEOX5kj9/i+FzW93XYpCb
	 bF1rUFq8GIaAGQIIGBgQfc1MB12ICK2nITFvyohs=
Date: Wed, 18 Jun 2025 16:17:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@kernel.org,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-missing-files-to-mm-page-alloc-section.patch added to mm-hotfixes-unstable branch
Message-Id: <20250618231714.AB014C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add missing files to mm page alloc section
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-missing-files-to-mm-page-alloc-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-missing-files-to-mm-page-alloc-section.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: MAINTAINERS: add missing files to mm page alloc section
Date: Wed, 18 Jun 2025 11:59:53 +0100

There are a number of files within memory management which appear to be
most suitably placed within the page allocation section of MAINTAINERS and
are otherwise unassigned, so place these there.

Link: https://lkml.kernel.org/r/20250618105953.67630-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Brendan Jackman <jackmanb@google.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/MAINTAINERS~maintainers-add-missing-files-to-mm-page-alloc-section
+++ a/MAINTAINERS
@@ -15877,8 +15877,17 @@ F:	include/linux/compaction.h
 F:	include/linux/gfp.h
 F:	include/linux/page-isolation.h
 F:	mm/compaction.c
+F:	mm/debug_page_alloc.c
+F:	mm/fail_page_alloc.c
 F:	mm/page_alloc.c
+F:	mm/page_ext.c
+F:	mm/page_frag_cache.c
 F:	mm/page_isolation.c
+F:	mm/page_owner.c
+F:	mm/page_poison.c
+F:	mm/page_reporting.c
+F:	mm/show_mem.c
+F:	mm/shuffle.c
 
 MEMORY MANAGEMENT - RECLAIM
 M:	Andrew Morton <akpm@linux-foundation.org>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section.patch
maintainers-add-missing-test-files-to-mm-gup-section.patch
maintainers-add-further-init-files-to-mm-init-block.patch
maintainers-add-hugetlb_cgroupc-to-hugetlb-section.patch
maintainers-add-stray-rmap-file-to-mm-rmap-section.patch
maintainers-add-memfd-shmem-quota-files-to-shmem-section.patch
maintainers-add-additional-mmap-related-files-to-mmap-section.patch
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
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch
mm-update-core-kernel-code-to-use-vm_flags_t-consistently.patch
mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch


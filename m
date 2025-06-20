Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A1E322E
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 03:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750391367; cv=none; b=AWKK7cAV5tSYm2Y9AK9arehfSvqcavjmmWN18o3n5mOLARVV8YVmJVy1A9ygG0ZG2mGqr4+FSUs50Q2Q8ScMyLiOKbokkzvA6RmwWYDgm90OLgq9mg0v77r+IqXe1I2wy/kBVFoN/EYsS/ixvVtHYKC+KLzxZIbbgjzQ3pOmlyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750391367; c=relaxed/simple;
	bh=T8L68gfa/riT9kNiPF11bdLEBUQ4r2FU+z6h5Rmexe8=;
	h=Date:To:From:Subject:Message-Id; b=uWACieXO3nImYOroAjGr7j2H6q/Wwewko4LSdHYszfhX7X1qEfaN9RNrSenzY2rCPO++JFtraMxpaZkYbnBk+xLlLP805VikXoLjBODPX5qMzxutC6YRLilGcy7E+whm5Z1fO76HkcawitezpRwQPhchYWaMiqev3UhdrUGiKx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iliWFfQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iliWFfQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA58EC4CEE3;
	Fri, 20 Jun 2025 03:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750391367;
	bh=T8L68gfa/riT9kNiPF11bdLEBUQ4r2FU+z6h5Rmexe8=;
	h=Date:To:From:Subject:From;
	b=iliWFfQSe3qyTms/SS+PFumACujf1Pl3Mt4ELVfF1D7oV9hDN2Xul63J45uOiVfmX
	 iIgurJ1aov8gAiNb9xNGV/RVsQwOONNu1bJ/pHvzVXDTaciosFQX5xxhRRLEwX1SRm
	 pADfA7Pce3TwAH6AXtISbQVDiv+4L7kyk7IajqMg=
Date: Thu, 19 Jun 2025 20:49:26 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-additional-mmap-related-files-to-mmap-section.patch removed from -mm tree
Message-Id: <20250620034926.EA58EC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add additional mmap-related files to mmap section
has been removed from the -mm tree.  Its filename was
     maintainers-add-additional-mmap-related-files-to-mmap-section.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add additional mmap-related files to mmap section
Date: Tue, 17 Jun 2025 15:41:30 +0100

msync and nommu are directly related to memory mapping, mincore is less so
but all are roughly speaking operating on virtual memory mappings from the
point of view of the user so this seems the most appropriate place for
them.

Link: https://lkml.kernel.org/r/20250617144130.147847-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

--- a/MAINTAINERS~maintainers-add-additional-mmap-related-files-to-mmap-section
+++ a/MAINTAINERS
@@ -15985,11 +15985,14 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/trace/events/mmap.h
+F:	mm/mincore.c
 F:	mm/mlock.c
 F:	mm/mmap.c
 F:	mm/mprotect.c
 F:	mm/mremap.c
 F:	mm/mseal.c
+F:	mm/msync.c
+F:	mm/nommu.c
 F:	mm/vma.c
 F:	mm/vma.h
 F:	mm/vma_exec.c
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


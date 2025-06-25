Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B9D1EA7EC
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 22:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750892154; cv=none; b=cxOhlOcrNFYLHjU6GZn1SNVecUKq2z2NJQy2fQ+XC1Ey6+OgnfwpkbhLmdHup5blhbHNvzYj9g0BhNHqDBikgdYKRe6Eh9kvmpjknjM/Bc91FssogMVLidWfD7+BwICG0Sn+MJDmkmwsNzEWww+0s5SsBMCwHAhtr/BHU3KlYgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750892154; c=relaxed/simple;
	bh=Vqj1zROcXayhS8sEh951uPvpzcqdjlEMNq58iz9D3bQ=;
	h=Date:To:From:Subject:Message-Id; b=fRqwFTDI8wQBDDPpzib8c8Q16cSeWHQNt8Z3bqqVxAOdNnqT5JfD/454p07ziXp3ed5NtFPo4Mt1c0/7j9DE8SsALH/Q9CxLy9iRHhRVeEVKcnodHwxt9AL3cOH50NazGhI1m59hC1E/iP/PyGKjIpwNi/aBUsfMgNDMQdtUPxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ie8dRY3c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ie8dRY3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74413C4CEEA;
	Wed, 25 Jun 2025 22:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750892153;
	bh=Vqj1zROcXayhS8sEh951uPvpzcqdjlEMNq58iz9D3bQ=;
	h=Date:To:From:Subject:From;
	b=ie8dRY3cVL5I2bS+1xWOCiTkmG840Z55zmMECoNf7IPPiQhC6R/3EvUj0kssfA/aM
	 jdiIPt5bd/vsQbZgdEtPoK5ybivGI2bKYvJefjwbxr8/Se4BUBGbHTAlytRBQR9mbw
	 nM1CFYnJxfH+20zuBaYEeWgz7NKBTvkgFjyhAngk=
Date: Wed, 25 Jun 2025 15:55:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@kernel.org,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-missing-files-to-mm-page-alloc-section.patch removed from -mm tree
Message-Id: <20250625225553.74413C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add missing files to mm page alloc section
has been removed from the -mm tree.  Its filename was
     maintainers-add-missing-files-to-mm-page-alloc-section.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -15875,8 +15875,17 @@ F:	include/linux/compaction.h
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

docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas-fix.patch
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
mm-maps-read-proc-pid-maps-under-per-vma-lock-fix.patch


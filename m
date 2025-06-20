Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F86322E
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 03:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750391364; cv=none; b=UxGGKuzJU7V+DgIpNY+okt48hP4TmVLSu26WCUUtoUa6P/z2C8dpcdHvhiK2dV19thG6mDudh1RDcsbNr6pwnzjWoIbQvxcMRfjMcPBvJnkjrTG65syJSm6OXhOI8/khCMJRF8aC68mE2T6Iium/GECokYjz09WC7p4//e4mPgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750391364; c=relaxed/simple;
	bh=OUBL71ipOwQAe9QkelgvJnYupoWNsm1Me8qk8CAS7VU=;
	h=Date:To:From:Subject:Message-Id; b=l9DCkhT+nSW9D5a9XTrt/kqYyvQwLpq8ziFr/RCe97XF6lYw7+n9mUX8gUUcA1lrEBWTkK29wMOuWTcEOWvZAvQ6KbNOfRB6wU+PVURaR97bBUZnU6ONZmF/7kXZ809yT2QEJpjHk9LWbv6jZqtnAYQWeeUb6RGVsEQxA8gagVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cW/QjThZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cW/QjThZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899D9C4CEE3;
	Fri, 20 Jun 2025 03:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750391363;
	bh=OUBL71ipOwQAe9QkelgvJnYupoWNsm1Me8qk8CAS7VU=;
	h=Date:To:From:Subject:From;
	b=cW/QjThZ8z5gvnrpi7qiwPB6YDWOxxrebmvu6Hg0XMceFUJ3hBSjITMSZG1XkMZrF
	 3Imvrzgx6r1b4XJlEZJPgOvnDmzBS/1Ol4vzjaKlaZx0uZyJIZTLsO3NkOwOrusCaV
	 d/rVfsy6dQ7SBAowgLfW+UaKANXvMvVkkeEPfyWI=
Date: Thu, 19 Jun 2025 20:49:23 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-hugetlb_cgroupc-to-hugetlb-section.patch removed from -mm tree
Message-Id: <20250620034923.899D9C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add hugetlb_cgroup.c to hugetlb section
has been removed from the -mm tree.  Its filename was
     maintainers-add-hugetlb_cgroupc-to-hugetlb-section.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add hugetlb_cgroup.c to hugetlb section
Date: Tue, 17 Jun 2025 18:15:38 +0100

This file is clearly specific to hugetlb so this seems the most
appropriate place for it.

Link: https://lkml.kernel.org/r/20250617171538.178042-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-hugetlb_cgroupc-to-hugetlb-section
+++ a/MAINTAINERS
@@ -11169,6 +11169,7 @@ F:	fs/hugetlbfs/
 F:	include/linux/hugetlb.h
 F:	include/trace/events/hugetlbfs.h
 F:	mm/hugetlb.c
+F:	mm/hugetlb_cgroup.c
 F:	mm/hugetlb_cma.c
 F:	mm/hugetlb_cma.h
 F:	mm/hugetlb_vmemmap.c
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521D540856
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 01:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753406189; cv=none; b=W/rLLfBvtj2Gp0m3G+0o1TLVbEIa3DWmjzijdIbmT9a6cCVJrOMLGHuL1DhS3n4C79jdtwNeW8Axemrof+Ka1TpplnAuJuv0KBNTTf/Y0b3s3aj6j1z5Gv/8FpEvalJ4/z7/H+YYmGMwEK+3cuBHxit4mEstGCA7rmB9iiThTdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753406189; c=relaxed/simple;
	bh=k9xMz527XX6dj9mxrsh1ZGmgnzFnwJ+2BG5n6BWKlhs=;
	h=Date:To:From:Subject:Message-Id; b=btqcSPyWkLAZsvIUFUx/eBRbsEncfom+ZcGEp07HUj0Z5jwI5i4ZqvhZx+Htje5f86/j2STwRpn0kQDpGKME7skaKPcjoVd5XREH2cYb4/TTx6VMp8+Nf8X43YCKmJyfy8YXoDcxpPOYkZiVa8vfDcxL0cJZgu+RZ3qCUQtS+y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0QF131nN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0QF131nN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065C7C4CEED;
	Fri, 25 Jul 2025 01:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753406189;
	bh=k9xMz527XX6dj9mxrsh1ZGmgnzFnwJ+2BG5n6BWKlhs=;
	h=Date:To:From:Subject:From;
	b=0QF131nN87Req6B4oO/h5QxCBK2CLyHP7lHVjCfr5SGcu7gvo8ykiAbAulMAQR4Ju
	 r4owMdZaOtJ9xwl5GAtemWfU9ijhue6JXdqGPhze5+N0HZy1slyYuswIVnvcVSg7wh
	 /DOWU7gY5NrkvbowjQrsvSkgj7K503AG4ZfcBIcE=
Date: Thu, 24 Jul 2025 18:16:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sj@kernel.org,ryan.roberts@arm.com,npache@redhat.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] docs-update-thp-documentation-to-clarify-sysfs-never-setting-fix.patch removed from -mm tree
Message-Id: <20250725011629.065C7C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: update admin guide transhuge page to mention MADV_COLLAPSE everywhere
has been removed from the -mm tree.  Its filename was
     docs-update-thp-documentation-to-clarify-sysfs-never-setting-fix.patch

This patch was dropped because it was folded into docs-update-thp-documentation-to-clarify-sysfs-never-setting.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: docs: update admin guide transhuge page to mention MADV_COLLAPSE everywhere
Date: Tue, 22 Jul 2025 06:32:18 +0100

We previously missed a couple places where the 'never' mode was described,
put the caveat regarding MADV_COLLAPSE in these locations also.

Link: https://lkml.kernel.org/r/d54d1dfb-f06d-4979-983b-73998f05867e@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~docs-update-thp-documentation-to-clarify-sysfs-never-setting-fix
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -385,7 +385,9 @@ always
     Attempt to allocate huge pages every time we need a new page;
 
 never
-    Do not allocate huge pages;
+    Do not allocate huge pages. Note that ``madvise(..., MADV_COLLAPSE)``
+    can still cause transparent huge pages to be obtained even if this mode
+    is specified everywhere;
 
 within_size
     Only allocate huge page if it will be fully within i_size.
@@ -441,7 +443,9 @@ inherit
     have enabled="inherit" and all other hugepage sizes have enabled="never";
 
 never
-    Do not allocate <size> huge pages;
+    Do not allocate <size> huge pages. Note that ``madvise(...,
+    MADV_COLLAPSE)`` can still cause transparent huge pages to be obtained
+    even if this mode is specified everywhere;
 
 within_size
     Only allocate <size> huge page if it will be fully within i_size.
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch
tools-testing-selftests-add-mremap-shrink-test-for-multiple-vmas.patch
tools-testing-selftests-test-mremap_dontunmap-on-multiple-vma-move.patch
tools-testing-selftests-explicitly-test-split-multi-vma-mremap-move.patch
docs-update-thp-documentation-to-clarify-sysfs-never-setting.patch
mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch
maintainers-add-missing-percpu-internalh-file-to-per-cpu-section.patch
maintainers-add-missing-interval_treec-to-memory-mapping-section.patch
maintainers-add-missing-mm_sloth-file-thp-section.patch
maintainers-add-missing-mm_sloth-file-thp-section-fix.patch
maintainers-move-memremap-to-hotplug-section.patch
maintainers-add-missing-shrinker-files.patch
maintainers-add-missing-files-to-page-alloc-section.patch
maintainers-add-missing-zsmalloc-file.patch
maintainers-add-mm-misc-section-add-missing-files-to-misc-and-core.patch
maintainers-add-missing-file-to-cgroup-section.patch


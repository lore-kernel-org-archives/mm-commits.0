Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522353BB44
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115084; cv=none; b=XhiT9iMsJq392mIVTbeHhV5z0NU03SRdDliIpX4noF7RjLhnL1TVwpJSdVsIrlUBFhEVs0dEcmDWfVc6T9SvAVly5X50HiYD4wryUxejORdtzl/W0KpmAICWEozusqTCwdHppz5bp7fPOxEWtDC3eDNVs4vL401rLusGTSu8gOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115084; c=relaxed/simple;
	bh=kXjZonipXRrZLc3hs3wB31P8coY7GAhNW8sjt0khTfo=;
	h=Date:To:From:Subject:Message-Id; b=fp7Zss64OVCobsuaOjk4xCjcJqdkVmDq2u+R7XAcy3CkHKpXoogf8++vaitN+92noxH+s0X+zgxrdhbqkaqNJnADHe1zt8Bwmzofm7s0GFvk1DNSsSaYyeb6FwI58lFkJRRMJPFbU+/ZqqcZsuybl2SfRGK5xaqHuNbD8tAraKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uj21BYYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uj21BYYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A565C4CEEA;
	Mon, 16 Jun 2025 23:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750115084;
	bh=kXjZonipXRrZLc3hs3wB31P8coY7GAhNW8sjt0khTfo=;
	h=Date:To:From:Subject:From;
	b=Uj21BYYbBojIwgpdFMrRWUaYDrFpYXhrsffRdz6uWpSEVv+RknKVTxpbZHLGPnmDr
	 ljee4TDUtObAjyFFbatvj6lAkbGcyzJEQyNHI81V1zGcdYjIKjYfzpql2y+orLtga9
	 7YizEy6Bmxr5iRgAzfoZScqpy8bOwnuKSb7AW/VE=
Date: Mon, 16 Jun 2025 16:04:43 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,jhubbard@nvidia.com,jgg@nvidia.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-missing-test-files-to-mm-gup-section.patch added to mm-hotfixes-unstable branch
Message-Id: <20250616230444.1A565C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add missing test files to mm gup section
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-missing-test-files-to-mm-gup-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-missing-test-files-to-mm-gup-section.patch

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
Subject: MAINTAINERS: add missing test files to mm gup section
Date: Mon, 16 Jun 2025 21:08:44 +0100

We previously overlooked GUP test files that sensibly should belong to the
GUP section, include them now.

Link: https://lkml.kernel.org/r/20250616200844.560225-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++++
 1 file changed, 4 insertions(+)

--- a/MAINTAINERS~maintainers-add-missing-test-files-to-mm-gup-section
+++ a/MAINTAINERS
@@ -15795,6 +15795,10 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	mm/gup.c
+F:	mm/gup_test.c
+F:	mm/gup_test.h
+F:	tools/testing/selftests/mm/gup_longterm.c
+F:	tools/testing/selftests/mm/gup_test.c
 
 MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
 M:	Andrew Morton <akpm@linux-foundation.org>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section.patch
maintainers-add-missing-test-files-to-mm-gup-section.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
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


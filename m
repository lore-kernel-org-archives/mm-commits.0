Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826D019924D
	for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2025 22:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753138080; cv=none; b=Z6GX16xdCYeX1S+lv3caRS0Iv3SyjaKP6ZTUHYeblkEpbmQzey/VZs/JhdXrWHKe3O9XDya8rJ+R6S/d5NoTQdStt0W6GJ2+oO2qixDg1wa0NW5ehyljXyrN7MNGrhV/5fMmkb7IyXe5LAo7fxuYHa/FWgrVYR8sRFtXLRbe0F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753138080; c=relaxed/simple;
	bh=HC08tuwmocruZZv9uwFXOPjN0eF/5bQZ0KhODx/dwgg=;
	h=Date:To:From:Subject:Message-Id; b=AHHdZ7+sCl00SqDjYWJzE2oRtqchuxHTmsoz/WrAH/qqFEkaCZUXF2QrKlfeRY6kMkRk+cv1g1Y6GW/xAqmmATw+5qa+g/RrJaF6bnK7XTE+bHdWbN5kV8lqV2ex8VLmanUdJgP/xsG53jdNx33FbCCe1Lv71eG+cQg/hrHupYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sLD/GF5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sLD/GF5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CBCC4CEED;
	Mon, 21 Jul 2025 22:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753138080;
	bh=HC08tuwmocruZZv9uwFXOPjN0eF/5bQZ0KhODx/dwgg=;
	h=Date:To:From:Subject:From;
	b=sLD/GF5BKx6sGDWU0uuLtEiIdv83ohAQLGIjslHHWKxYbWVwfQmyi+KCNPUu611Mo
	 ZW18kqlNfGCBdkEBtACoR6J9tgr4/ywK5/Poq9UOnx6LytTLM5ZTlUfPxGMs6/bfqH
	 e2LUoNny2RcTAAz8RHH8Joyx9uz06SxguNK3Cp78=
Date: Mon, 21 Jul 2025 15:47:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sj@kernel.org,ryan.roberts@arm.com,npache@redhat.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-update-thp-documentation-to-clarify-sysfs-never-setting.patch added to mm-unstable branch
Message-Id: <20250721224800.53CBCC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: update THP documentation to clarify sysfs "never" setting
has been added to the -mm mm-unstable branch.  Its filename is
     docs-update-thp-documentation-to-clarify-sysfs-never-setting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-update-thp-documentation-to-clarify-sysfs-never-setting.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: docs: update THP documentation to clarify sysfs "never" setting
Date: Mon, 21 Jul 2025 16:55:30 +0100

Rather confusingly, setting all Transparent Huge Page sysfs settings to
"never" does not in fact result in THP being globally disabled.

Rather, it results in khugepaged being disabled, but one can still obtain
THP pages using madvise(..., MADV_COLLAPSE).

This is something that has remained poorly documented for some time, and
it is likely the received wisdom of most users of THP that never does, in
fact, mean never.

It is therefore important to highlight, very clearly, that this is not the
case.

Link: https://lkml.kernel.org/r/20250721155530.75944-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~docs-update-thp-documentation-to-clarify-sysfs-never-setting
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -107,7 +107,7 @@ sysfs
 Global THP controls
 -------------------
 
-Transparent Hugepage Support for anonymous memory can be entirely disabled
+Transparent Hugepage Support for anonymous memory can be disabled
 (mostly for debugging purposes) or only enabled inside MADV_HUGEPAGE
 regions (to avoid the risk of consuming more memory resources) or enabled
 system wide. This can be achieved per-supported-THP-size with one of::
@@ -119,6 +119,11 @@ system wide. This can be achieved per-su
 where <size> is the hugepage size being addressed, the available sizes
 for which vary by system.
 
+.. note:: Setting "never" in all sysfs THP controls does **not** disable
+          Transparent Huge Pages globally. This is because ``madvise(...,
+          MADV_COLLAPSE)`` ignores these settings and collapses ranges to
+          PMD-sized huge pages unconditionally.
+
 For example::
 
 	echo always >/sys/kernel/mm/transparent_hugepage/hugepages-2048kB/enabled
@@ -187,7 +192,9 @@ madvise
 	behaviour.
 
 never
-	should be self-explanatory.
+	should be self-explanatory. Note that ``madvise(...,
+	MADV_COLLAPSE)`` can still cause transparent huge pages to be
+	obtained even if this mode is specified everywhere.
 
 By default kernel tries to use huge, PMD-mappable zero page on read
 page fault to anonymous mapping. It's possible to disable huge zero
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-check-remap-conditions-earlier-fix.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch
mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch
tools-testing-selftests-add-mremap-shrink-test-for-multiple-vmas.patch
tools-testing-selftests-test-mremap_dontunmap-on-multiple-vma-move.patch
tools-testing-selftests-explicitly-test-split-multi-vma-mremap-move.patch
docs-update-thp-documentation-to-clarify-sysfs-never-setting.patch


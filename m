Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B5321CA04
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409746; cv=none; b=Ru8Mm9fdHKv9o+Kkj1CFCzV2U9tFssTpSr06cOCQldcPWebJ6Ad1Mrd0SSA5Rmo+PkYEqmPzs7mwpfAHXBOQypSEQ9X8BQ1fc7dZJEytdHaRx32pfKnRDG46utv6bgjrCgWFstMo/BAcbVUv03OuLONBBUXMjEslPVTIh9ssgdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409746; c=relaxed/simple;
	bh=Y9kYOKO5NQvReMYFoXf/yc929N9Ak7waBOm/qUayiN0=;
	h=Date:To:From:Subject:Message-Id; b=E1Ae0A2wSQg3+UFim1o1c9x88HPxJ1Gd1bIzi8trsZ6MN9lNtVZwel8vfGRfm4F5rlJqZvls9eD3BllyfE1U88/TvSYfhjOOXE8WhGbb793U1nEXl+qTn+K9GUsh7zJonegudW/K5a7l9CUEJyElxBo+rpqxgHShlK+5Ov795wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mup0zunb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mup0zunb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD0EC4CEED;
	Fri, 25 Jul 2025 02:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409746;
	bh=Y9kYOKO5NQvReMYFoXf/yc929N9Ak7waBOm/qUayiN0=;
	h=Date:To:From:Subject:From;
	b=mup0zunbLRVOVMkUoXlgErTrcoR/C2jRpDaXrlpsnwKYKgAXnxoSeAEn+IoC+S/pu
	 KI16NE46Sx4FNLDCFP67FdlM+0WYjWqAmgFGgeG+yNshur3utUX+mhgNFBG956PSRt
	 fjM/ls9zTZojsZp7z0UiRNObK84X+33V3Qap6Gkk=
Date: Thu, 24 Jul 2025 19:15:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sj@kernel.org,ryan.roberts@arm.com,npache@redhat.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-update-thp-documentation-to-clarify-sysfs-never-setting.patch removed from -mm tree
Message-Id: <20250725021546.9BD0EC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: update THP documentation to clarify sysfs "never" setting
has been removed from the -mm tree.  Its filename was
     docs-update-thp-documentation-to-clarify-sysfs-never-setting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[lorenzo.stoakes@oracle.com: update transhuge page to mention MADV_COLLAPSE]
  Link: https://lkml.kernel.org/r/d54d1dfb-f06d-4979-983b-73998f05867e@lucifer.local
Link: https://lkml.kernel.org/r/20250721155530.75944-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

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
@@ -378,7 +385,9 @@ always
     Attempt to allocate huge pages every time we need a new page;
 
 never
-    Do not allocate huge pages;
+    Do not allocate huge pages. Note that ``madvise(..., MADV_COLLAPSE)``
+    can still cause transparent huge pages to be obtained even if this mode
+    is specified everywhere;
 
 within_size
     Only allocate huge page if it will be fully within i_size.
@@ -434,7 +443,9 @@ inherit
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


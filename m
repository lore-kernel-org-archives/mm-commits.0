Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC13018DB34
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011052; cv=none; b=sUpinlpI/PszffmiK8Klo/M9s5TJhsaqjTZEkJJvSEodXVjQSPVuehNNTeC7FOXsU5LxdS2MqJ2bUiAo1MD/Ke7bPQscVwQS/2hcDHPBjxi75U9MC30tPFL2C2bB3Vcr8TUnA2mn2mASpIL+Jj8gORdVxUorSPl1t1qlIzLJRuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011052; c=relaxed/simple;
	bh=5GRIKbYoRdZHGDTh9zvLDGYnjpGseU57aPfTcbC9gL8=;
	h=Date:To:From:Subject:Message-Id; b=JAXgJS2TSnjTbfn+rFIxXCv5FaNrsL8HXIG8tug1/vN1vhp0fcPpJNj4oIUd7BzlV0tk7QvE6SdRmb30Mb+T+olijejct19Zh5UXbz2ff1466cRR770UWtT/FzSv5k1vVDQ6o59rCwcrDeqcvGLu0vahVn8Pyi8S4TJxjQX/0R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n7q6zSQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n7q6zSQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C137EC4CEE4;
	Mon, 12 May 2025 00:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011051;
	bh=5GRIKbYoRdZHGDTh9zvLDGYnjpGseU57aPfTcbC9gL8=;
	h=Date:To:From:Subject:From;
	b=n7q6zSQyCQNxWbo+CFnd/6OENsV6cS6NsBLM9AkOyiPnyspBG8OEN2hvGavI6efs4
	 5JEXT6ZDoQfcG6Krp2fxZmDXB3L4MxbhVDg3dx/Dus7l0RMaMOJRyPcBfoEDdjQ01J
	 gvOEHkGvo0eQwsN4VYKN4oCa1lwaeEAIyFnSa1v0=
Date: Sun, 11 May 2025 17:50:51 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,lorenzo.stoakes@oracle.com,david@redhat.com,corbet@lwn.net,avagin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-extend-the-pagemap_scan-ioctl-to-report-guard-regions.patch removed from -mm tree
Message-Id: <20250512005051.C137EC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc: extend the PAGEMAP_SCAN ioctl to report guard regions
has been removed from the -mm tree.  Its filename was
     fs-proc-extend-the-pagemap_scan-ioctl-to-report-guard-regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrei Vagin <avagin@gmail.com>
Subject: fs/proc: extend the PAGEMAP_SCAN ioctl to report guard regions
Date: Mon, 24 Mar 2025 06:53:26 +0000

Patch series "fs/proc: extend the PAGEMAP_SCAN ioctl to report guard
regions", v2.

Introduce the PAGE_IS_GUARD flag in the PAGEMAP_SCAN ioctl to expose
information about guard regions.  This allows userspace tools, such as
CRIU, to detect and handle guard regions.

Currently, CRIU utilizes PAGEMAP_SCAN as a more efficient alternative to
parsing /proc/pid/pagemap.  Without this change, guard regions are
incorrectly reported as swap-anon regions, leading CRIU to attempt dumping
them and subsequently failing.

The series includes updates to the documentation and selftests to reflect
the new functionality.


This patch (of 3):

Introduce the PAGE_IS_GUARD flag in the PAGEMAP_SCAN ioctl to expose
information about guard regions.  This allows userspace tools, such as
CRIU, to detect and handle guard regions.

Link: https://lkml.kernel.org/r/20250324065328.107678-1-avagin@google.com
Link: https://lkml.kernel.org/r/20250324065328.107678-2-avagin@google.com
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/pagemap.rst |    1 +
 fs/proc/task_mmu.c                       |   17 ++++++++++-------
 include/uapi/linux/fs.h                  |    1 +
 3 files changed, 12 insertions(+), 7 deletions(-)

--- a/Documentation/admin-guide/mm/pagemap.rst~fs-proc-extend-the-pagemap_scan-ioctl-to-report-guard-regions
+++ a/Documentation/admin-guide/mm/pagemap.rst
@@ -250,6 +250,7 @@ Following flags about pages are currentl
 - ``PAGE_IS_PFNZERO`` - Page has zero PFN
 - ``PAGE_IS_HUGE`` - Page is PMD-mapped THP or Hugetlb backed
 - ``PAGE_IS_SOFT_DIRTY`` - Page is soft-dirty
+- ``PAGE_IS_GUARD`` - Page is a part of a guard region
 
 The ``struct pm_scan_arg`` is used as the argument of the IOCTL.
 
--- a/fs/proc/task_mmu.c~fs-proc-extend-the-pagemap_scan-ioctl-to-report-guard-regions
+++ a/fs/proc/task_mmu.c
@@ -2087,7 +2087,8 @@ static int pagemap_release(struct inode
 #define PM_SCAN_CATEGORIES	(PAGE_IS_WPALLOWED | PAGE_IS_WRITTEN |	\
 				 PAGE_IS_FILE |	PAGE_IS_PRESENT |	\
 				 PAGE_IS_SWAPPED | PAGE_IS_PFNZERO |	\
-				 PAGE_IS_HUGE | PAGE_IS_SOFT_DIRTY)
+				 PAGE_IS_HUGE | PAGE_IS_SOFT_DIRTY |	\
+				 PAGE_IS_GUARD)
 #define PM_SCAN_FLAGS		(PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC)
 
 struct pagemap_scan_private {
@@ -2128,12 +2129,14 @@ static unsigned long pagemap_page_catego
 		if (!pte_swp_uffd_wp_any(pte))
 			categories |= PAGE_IS_WRITTEN;
 
-		if (p->masks_of_interest & PAGE_IS_FILE) {
-			swp = pte_to_swp_entry(pte);
-			if (is_pfn_swap_entry(swp) &&
-			    !folio_test_anon(pfn_swap_entry_folio(swp)))
-				categories |= PAGE_IS_FILE;
-		}
+		swp = pte_to_swp_entry(pte);
+		if (is_guard_swp_entry(swp))
+			categories |= PAGE_IS_GUARD;
+		else if ((p->masks_of_interest & PAGE_IS_FILE) &&
+			 is_pfn_swap_entry(swp) &&
+			 !folio_test_anon(pfn_swap_entry_folio(swp)))
+			categories |= PAGE_IS_FILE;
+
 		if (pte_swp_soft_dirty(pte))
 			categories |= PAGE_IS_SOFT_DIRTY;
 	}
--- a/include/uapi/linux/fs.h~fs-proc-extend-the-pagemap_scan-ioctl-to-report-guard-regions
+++ a/include/uapi/linux/fs.h
@@ -361,6 +361,7 @@ typedef int __bitwise __kernel_rwf_t;
 #define PAGE_IS_PFNZERO		(1 << 5)
 #define PAGE_IS_HUGE		(1 << 6)
 #define PAGE_IS_SOFT_DIRTY	(1 << 7)
+#define PAGE_IS_GUARD		(1 << 8)
 
 /*
  * struct page_region - Page region with flags
_

Patches currently in -mm which might be from avagin@gmail.com are



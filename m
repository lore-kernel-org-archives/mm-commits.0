Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1692D185B4C
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 05:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744002150; cv=none; b=uDS5nelzL1qadBECO+GMrAeZ8PFuBaaHFR7KvP+VHoB5eVBtrz6cpk31pSb37rEUOtQ6QJthH0hI3ACBYlcb+V31qbl+lg1eVW6ymrFtgygebj06bjL3VqTyVocKJw9D/tVC4sM8a5Xi8BrRFCzxc8aXrLMdbZ2js89Obhrbz2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744002150; c=relaxed/simple;
	bh=nZnIFMonDnCCqCJw5wdFqVWsxYJGQfpu49yu+FH9mWE=;
	h=Date:To:From:Subject:Message-Id; b=J4Vbdb+i9YIcHIdoiAdlXgDUPVl8Fd3s7mzI75uR+Vgq1WGJFqp+RCyQ1bFmIv/s6bS2+IN4YVSbUDUinNU2A4oOua8p/ppxJRhhN0M22A4LRBm98nH0LiYWVS+d/OMVYFyIY0yVwDcJ4TTEP2P2TnOiGVYrhssMuD6q9dvUvzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F30zC1UZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F30zC1UZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CC0C4CEDD;
	Mon,  7 Apr 2025 05:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744002149;
	bh=nZnIFMonDnCCqCJw5wdFqVWsxYJGQfpu49yu+FH9mWE=;
	h=Date:To:From:Subject:From;
	b=F30zC1UZej2JdfAdko6Cy8SSqj3VG6uTdY4MTC0hIqpHmsIUjkgdXnjISjGl6oG9W
	 8D4EWQXxZbV+03FYMOhZBZat15uwgEgmv5nSoTzKsmeO4kQvqr9IxzZsGN0e0/MWyV
	 k95z0fJPUQ2nzSHLDfJETqvcIf0rmUYDA8JQIExc=
Date: Sun, 06 Apr 2025 22:02:28 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,lorenzo.stoakes@oracle.com,david@redhat.com,corbet@lwn.net,avagin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-extend-the-pagemap_scan-ioctl-to-report-guard-regions.patch added to mm-new branch
Message-Id: <20250407050229.61CC0C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc: extend the PAGEMAP_SCAN ioctl to report guard regions
has been added to the -mm mm-new branch.  Its filename is
     fs-proc-extend-the-pagemap_scan-ioctl-to-report-guard-regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-extend-the-pagemap_scan-ioctl-to-report-guard-regions.patch

This patch will later appear in the mm-new branch at
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

fs-proc-extend-the-pagemap_scan-ioctl-to-report-guard-regions.patch
tools-headers-uapi-sync-linux-fsh-with-the-kernel-sources.patch
selftests-mm-add-pagemap_scan-guard-region-test.patch


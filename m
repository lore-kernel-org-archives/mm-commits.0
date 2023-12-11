Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD3123B8
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hCxN7ghV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6799CC433C7;
	Mon, 11 Dec 2023 00:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256047;
	bh=KPF5CiObSDokdFMDCfJEd2c9XxKuP6SbVGzipHMYcWY=;
	h=Date:To:From:Subject:From;
	b=hCxN7ghVcVzcxSMHzh3zPkvHkcde0lYqL8OGYf2aHzaklTuE6lIr0bmuAdso7qEYB
	 XN33uZ5vgWpEpWhjJZ6BpMlV170a9FTg7i8ahn2ahwBuP81VjpMxcrxZuo2eS2ftcQ
	 /h5PvUOuQxdaJx7ofIvp1beV1ncoPo48rSC1uFVY=
Date: Sun, 10 Dec 2023 16:54:06 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,mirq-linux@rere.qmqm.pl,avagin@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl.patch removed from -mm tree
Message-Id: <20231211005407.6799CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: report SOFT_DIRTY bits through the PAGEMAP_SCAN ioctl
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrei Vagin <avagin@google.com>
Subject: fs/proc/task_mmu: report SOFT_DIRTY bits through the PAGEMAP_SCAN ioctl
Date: Mon, 6 Nov 2023 14:09:58 -0800

The PAGEMAP_SCAN ioctl returns information regarding page table entries. 
It is more efficient compared to reading pagemap files.  CRIU can start to
utilize this ioctl, but it needs info about soft-dirty bits to track
memory changes.

We are aware of a new method for tracking memory changes implemented in
the PAGEMAP_SCAN ioctl.  For CRIU, the primary advantage of this method is
its usability by unprivileged users.  However, it is not feasible to
transparently replace the soft-dirty tracker with the new one.  The main
problem here is userfault descriptors that have to be preserved between
pre-dump iterations.  It means criu continues supporting the soft-dirty
method to avoid breakage for current users.  The new method will be
implemented as a separate feature.

[avagin@google.com: update tools/include/uapi/linux/fs.h]
  Link: https://lkml.kernel.org/r/20231107164139.576046-1-avagin@google.com
Link: https://lkml.kernel.org/r/20231106220959.296568-1-avagin@google.com
Signed-off-by: Andrei Vagin <avagin@google.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/pagemap.rst |    1 +
 fs/proc/task_mmu.c                       |   17 ++++++++++++++++-
 include/uapi/linux/fs.h                  |    1 +
 tools/include/uapi/linux/fs.h            |    1 +
 4 files changed, 19 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/pagemap.rst~fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl
+++ a/Documentation/admin-guide/mm/pagemap.rst
@@ -253,6 +253,7 @@ Following flags about pages are currentl
 - ``PAGE_IS_SWAPPED`` - Page is in swapped
 - ``PAGE_IS_PFNZERO`` - Page has zero PFN
 - ``PAGE_IS_HUGE`` - Page is THP or Hugetlb backed
+- ``PAGE_IS_SOFT_DIRTY`` - Page is soft-dirty
 
 The ``struct pm_scan_arg`` is used as the argument of the IOCTL.
 
--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl
+++ a/fs/proc/task_mmu.c
@@ -1761,7 +1761,7 @@ static int pagemap_release(struct inode
 #define PM_SCAN_CATEGORIES	(PAGE_IS_WPALLOWED | PAGE_IS_WRITTEN |	\
 				 PAGE_IS_FILE |	PAGE_IS_PRESENT |	\
 				 PAGE_IS_SWAPPED | PAGE_IS_PFNZERO |	\
-				 PAGE_IS_HUGE)
+				 PAGE_IS_HUGE | PAGE_IS_SOFT_DIRTY)
 #define PM_SCAN_FLAGS		(PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC)
 
 struct pagemap_scan_private {
@@ -1793,6 +1793,8 @@ static unsigned long pagemap_page_catego
 
 		if (is_zero_pfn(pte_pfn(pte)))
 			categories |= PAGE_IS_PFNZERO;
+		if (pte_soft_dirty(pte))
+			categories |= PAGE_IS_SOFT_DIRTY;
 	} else if (is_swap_pte(pte)) {
 		swp_entry_t swp;
 
@@ -1806,6 +1808,8 @@ static unsigned long pagemap_page_catego
 			    !PageAnon(pfn_swap_entry_to_page(swp)))
 				categories |= PAGE_IS_FILE;
 		}
+		if (pte_swp_soft_dirty(pte))
+			categories |= PAGE_IS_SOFT_DIRTY;
 	}
 
 	return categories;
@@ -1853,12 +1857,16 @@ static unsigned long pagemap_thp_categor
 
 		if (is_zero_pfn(pmd_pfn(pmd)))
 			categories |= PAGE_IS_PFNZERO;
+		if (pmd_soft_dirty(pmd))
+			categories |= PAGE_IS_SOFT_DIRTY;
 	} else if (is_swap_pmd(pmd)) {
 		swp_entry_t swp;
 
 		categories |= PAGE_IS_SWAPPED;
 		if (!pmd_swp_uffd_wp(pmd))
 			categories |= PAGE_IS_WRITTEN;
+		if (pmd_swp_soft_dirty(pmd))
+			categories |= PAGE_IS_SOFT_DIRTY;
 
 		if (p->masks_of_interest & PAGE_IS_FILE) {
 			swp = pmd_to_swp_entry(pmd);
@@ -1905,10 +1913,14 @@ static unsigned long pagemap_hugetlb_cat
 			categories |= PAGE_IS_FILE;
 		if (is_zero_pfn(pte_pfn(pte)))
 			categories |= PAGE_IS_PFNZERO;
+		if (pte_soft_dirty(pte))
+			categories |= PAGE_IS_SOFT_DIRTY;
 	} else if (is_swap_pte(pte)) {
 		categories |= PAGE_IS_SWAPPED;
 		if (!pte_swp_uffd_wp_any(pte))
 			categories |= PAGE_IS_WRITTEN;
+		if (pte_swp_soft_dirty(pte))
+			categories |= PAGE_IS_SOFT_DIRTY;
 	}
 
 	return categories;
@@ -2007,6 +2019,9 @@ static int pagemap_scan_test_walk(unsign
 	if (wp_allowed)
 		vma_category |= PAGE_IS_WPALLOWED;
 
+	if (vma->vm_flags & VM_SOFTDIRTY)
+		vma_category |= PAGE_IS_SOFT_DIRTY;
+
 	if (!pagemap_scan_is_interesting_vma(vma_category, p))
 		return 1;
 
--- a/include/uapi/linux/fs.h~fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl
+++ a/include/uapi/linux/fs.h
@@ -316,6 +316,7 @@ typedef int __bitwise __kernel_rwf_t;
 #define PAGE_IS_SWAPPED		(1 << 4)
 #define PAGE_IS_PFNZERO		(1 << 5)
 #define PAGE_IS_HUGE		(1 << 6)
+#define PAGE_IS_SOFT_DIRTY	(1 << 7)
 
 /*
  * struct page_region - Page region with flags
--- a/tools/include/uapi/linux/fs.h~fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl
+++ a/tools/include/uapi/linux/fs.h
@@ -316,6 +316,7 @@ typedef int __bitwise __kernel_rwf_t;
 #define PAGE_IS_SWAPPED		(1 << 4)
 #define PAGE_IS_PFNZERO		(1 << 5)
 #define PAGE_IS_HUGE		(1 << 6)
+#define PAGE_IS_SOFT_DIRTY	(1 << 7)
 
 /*
  * struct page_region - Page region with flags
_

Patches currently in -mm which might be from avagin@google.com are



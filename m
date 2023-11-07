Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83976C4167B
	for <mm-commits@archiver.kernel.org>; Tue,  7 Nov 2023 15:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbjKGPoh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Nov 2023 10:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235056AbjKGPoh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Nov 2023 10:44:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1173394
        for <mm-commits@vger.kernel.org>; Tue,  7 Nov 2023 07:44:35 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CA3C433C7;
        Tue,  7 Nov 2023 15:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699371874;
        bh=P3szUhl1y+bHamn3Kp46brhUmLGZjOQB+3J+Or8UFIs=;
        h=Date:To:From:Subject:From;
        b=OEDzxJMOTpAl7EEL2jPiCuGXdf28tT8DHYMb9mNxfGP9X9fKjk2FEWXmjNBRSyRFD
         9GBYDlbcZHNkjT2H7dtYCtZCJuvGhX5nnAJXWgYZmZyiA9og4eW8YjvTR0YQn1uADT
         Y/dxqOVvNq5m9TYbv1XA2BuinlMuyOExXmt/RAr0=
Date:   Tue, 07 Nov 2023 07:44:34 -0800
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        mirq-linux@rere.qmqm.pl, avagin@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl.patch added to mm-unstable branch
Message-Id: <20231107154434.97CA3C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu: report SOFT_DIRTY bits through the PAGEMAP_SCAN ioctl
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl.patch

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

Link: https://lkml.kernel.org/r/20231106220959.296568-1-avagin@google.com
Signed-off-by: Andrei Vagin <avagin@google.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/pagemap.rst |    1 +
 fs/proc/task_mmu.c                       |   17 ++++++++++++++++-
 include/uapi/linux/fs.h                  |    1 +
 3 files changed, 18 insertions(+), 1 deletion(-)

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
@@ -1991,6 +2003,9 @@ static int pagemap_scan_test_walk(unsign
 	if (vma->vm_flags & VM_PFNMAP)
 		return 1;
 
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
_

Patches currently in -mm which might be from avagin@google.com are

fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl.patch
selftests-mm-check-that-pagemap_scan-returns-correct-categories.patch


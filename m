From: akpm@linux-foundation.org
Subject: [merged] smaps-show-vm_softdirty-flag-in-vmflags-line.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:38:46 -0800
Message-ID: <5283e356.WOjTHsE21w5dB1QQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42645 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab3KMUir (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, gorcunov@openvz.org, fengguang.wu@intel.com, n-horiguchi@ah.jp.nec.com

Subject: [merged] smaps-show-vm_softdirty-flag-in-vmflags-line.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,fengguang.wu@intel.com,gorcunov@openvz.org,xemul@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:46 -0800


The patch titled
     Subject: /proc/pid/smaps: show VM_SOFTDIRTY flag in VmFlags line
has been removed from the -mm tree.  Its filename was
     smaps-show-vm_softdirty-flag-in-vmflags-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: /proc/pid/smaps: show VM_SOFTDIRTY flag in VmFlags line

This flag shows that the VMA is "newly created" and thus represents
"dirty" in the task's VM.

You can clear it by "echo 4 > /proc/pid/clear_refs."

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    1 +
 fs/proc/task_mmu.c                 |    3 +++
 2 files changed, 4 insertions(+)

diff -puN Documentation/filesystems/proc.txt~smaps-show-vm_softdirty-flag-in-vmflags-line Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~smaps-show-vm_softdirty-flag-in-vmflags-line
+++ a/Documentation/filesystems/proc.txt
@@ -460,6 +460,7 @@ manner. The codes are the following:
     nl  - non-linear mapping
     ar  - architecture specific flag
     dd  - do not include area into core dump
+    sd  - soft-dirty flag
     mm  - mixed map area
     hg  - huge page advise flag
     nh  - no-huge page advise flag
diff -puN fs/proc/task_mmu.c~smaps-show-vm_softdirty-flag-in-vmflags-line fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~smaps-show-vm_softdirty-flag-in-vmflags-line
+++ a/fs/proc/task_mmu.c
@@ -561,6 +561,9 @@ static void show_smap_vma_flags(struct s
 		[ilog2(VM_NONLINEAR)]	= "nl",
 		[ilog2(VM_ARCH_1)]	= "ar",
 		[ilog2(VM_DONTDUMP)]	= "dd",
+#ifdef CONFIG_MEM_SOFT_DIRTY
+		[ilog2(VM_SOFTDIRTY)]	= "sd",
+#endif
 		[ilog2(VM_MIXEDMAP)]	= "mm",
 		[ilog2(VM_HUGEPAGE)]	= "hg",
 		[ilog2(VM_NOHUGEPAGE)]	= "nh",
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch


From: akpm@linux-foundation.org
Subject: + smaps-show-vm_softdirty-flag-in-vmflags-line.patch added to -mm tree
Date: Mon, 07 Oct 2013 17:51:36 -0700
Message-ID: <52535718.A+lP5T9OYwAQa5UN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab3JHAvh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Oct 2013 20:51:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, gorcunov@openvz.org, fengguang.wu@intel.com, n-horiguchi@ah.jp.nec.com

Subject: + smaps-show-vm_softdirty-flag-in-vmflags-line.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,fengguang.wu@intel.com,gorcunov@openvz.org,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Mon, 07 Oct 2013 17:51:36 -0700


The patch titled
     Subject: /proc/pid/smaps: show VM_SOFTDIRTY flag in VmFlags line
has been added to the -mm tree.  Its filename is
     smaps-show-vm_softdirty-flag-in-vmflags-line.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/smaps-show-vm_softdirty-flag-in-vmflags-line.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/smaps-show-vm_softdirty-flag-in-vmflags-line.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 fs/proc/task_mmu.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/proc/task_mmu.c~smaps-show-vm_softdirty-flag-in-vmflags-line fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~smaps-show-vm_softdirty-flag-in-vmflags-line
+++ a/fs/proc/task_mmu.c
@@ -562,6 +562,9 @@ static void show_smap_vma_flags(struct s
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

mm-hugetlb-correct-missing-private-flag-clearing.patch
mm-remove-obsolete-comments-about-page-table-lock.patch
mm-memory-failurec-move-set_migratetype_isolate-outside-get_any_page.patch
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
smaps-show-vm_softdirty-flag-in-vmflags-line.patch
page-typesc-support-kpf_softdirty-bit.patch


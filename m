From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
 removed from -mm tree
Date: Wed, 31 Jan 2018 15:53:50 -0800
Message-ID: <5a72570e.oh92YvZbx2lBLoxC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56908 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752775AbeAaXx5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 18:53:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, yang.s@alibaba-inc.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix
has been removed from the -mm tree.  Its filename was
     mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch

This patch was dropped because it was folded into mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix

tweak comment

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Yang Shi <yang.s@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/khugepaged.c~mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix mm/khugepaged.c
--- a/mm/khugepaged.c~mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix
+++ a/mm/khugepaged.c
@@ -1674,8 +1674,8 @@ static unsigned int khugepaged_scan_mm_s
 
 	mm = mm_slot->mm;
 	/*
- 	 * Not wait for semaphore to avoid long time waiting, just move
- 	 * to the next mm on the list.
+ 	 * Don't wait for semaphore (to avoid long wait times).  Just move to
+	 * the next mm on the list.
  	 */
 	if (unlikely(!down_read_trylock(&mm->mmap_sem)))
 		goto breakouterloop_mmap_sem;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch
tools-vm-new-option-to-specify-kpageflags-file-fix.patch


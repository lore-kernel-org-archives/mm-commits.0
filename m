From: akpm@linux-foundation.org
Subject: +
 mm-export-find_extend_vma-and-handle_mm_fault-for-driver-use.patch added to -mm tree
Date: Thu, 13 Nov 2014 13:58:25 -0800
Message-ID: <54652981.C57LDGYFbrGtUIOU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934261AbaKMV60 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Nov 2014 16:58:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbarnes@virtuousgeek.org, jroedel@suse.de, oded.gabbay@amd.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: export find_extend_vma() and handle_mm_fault() for driver use
has been added to the -mm tree.  Its filename is
     mm-export-find_extend_vma-and-handle_mm_fault-for-driver-use.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-export-find_extend_vma-and-handle_mm_fault-for-driver-use.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-export-find_extend_vma-and-handle_mm_fault-for-driver-use.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: mm: export find_extend_vma() and handle_mm_fault() for driver use

This lets drivers like the AMD IOMMUv2 driver handle faults a bit more
simply, rather than doing tricks with page refs and get_user_pages().

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Oded Gabbay <oded.gabbay@amd.com>
Cc: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 mm/mmap.c   |    2 ++
 2 files changed, 3 insertions(+)

diff -puN mm/memory.c~mm-export-find_extend_vma-and-handle_mm_fault-for-driver-use mm/memory.c
--- a/mm/memory.c~mm-export-find_extend_vma-and-handle_mm_fault-for-driver-use
+++ a/mm/memory.c
@@ -3380,6 +3380,7 @@ int handle_mm_fault(struct mm_struct *mm
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(handle_mm_fault);
 
 #ifndef __PAGETABLE_PUD_FOLDED
 /*
diff -puN mm/mmap.c~mm-export-find_extend_vma-and-handle_mm_fault-for-driver-use mm/mmap.c
--- a/mm/mmap.c~mm-export-find_extend_vma-and-handle_mm_fault-for-driver-use
+++ a/mm/mmap.c
@@ -2359,6 +2359,8 @@ find_extend_vma(struct mm_struct *mm, un
 }
 #endif
 
+EXPORT_SYMBOL_GPL(find_extend_vma);
+
 /*
  * Ok - we have the memory areas we should free on the vma list,
  * so release them, and do the vma updates.
_

Patches currently in -mm which might be from jbarnes@virtuousgeek.org are

mmu_notifier-add-mmu_notifier_invalidate_range.patch
mmu_notifier-call-mmu_notifier_invalidate_range-from-vmm.patch
mmu_notifier-add-the-call-back-for-mmu_notifier_invalidate_range.patch
iommu-amd-use-new-invalidate_range-mmu-notifier.patch
mm-export-find_extend_vma-and-handle_mm_fault-for-driver-use.patch
iommu-amd-use-handle_mm_fault-directly-v2.patch
linux-next.patch


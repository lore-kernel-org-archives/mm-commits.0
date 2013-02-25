From: akpm@linux-foundation.org
Subject: [merged] mm-export-mmu-notifier-invalidates.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:55:47 -0800
Message-ID: <20130225205547.F042C31C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:35764 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830Ab3BYUzu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:55:50 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so138qcs.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:55:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cpw@sgi.com, holt@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: export mmu notifier invalidates
has been removed from the -mm tree.  Its filename was
     mm-export-mmu-notifier-invalidates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cliff Wickman <cpw@sgi.com>
Subject: mm: export mmu notifier invalidates

We at SGI have a need to address some very high physical address ranges
with our GRU (global reference unit), sometimes across partitioned machine
boundaries and sometimes with larger addresses than the cpu supports.  We
do this with the aid of our own 'extended vma' module which mimics the
vma.  When something (either unmap or exit) frees an 'extended vma' we use
the mmu notifiers to clean them up.

We had been able to mimic the functions
__mmu_notifier_invalidate_range_start() and
__mmu_notifier_invalidate_range_end() by locking the per-mm lock and
walking the per-mm notifier list.  But with the change to a global srcu
lock (static in mmu_notifier.c) we can no longer do that.  Our module has
no access to that lock.

So we request that these two functions be exported.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Acked-by: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/mmu_notifier.c~mm-export-mmu-notifier-invalidates mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mm-export-mmu-notifier-invalidates
+++ a/mm/mmu_notifier.c
@@ -172,6 +172,7 @@ void __mmu_notifier_invalidate_range_sta
 	}
 	srcu_read_unlock(&srcu, id);
 }
+EXPORT_SYMBOL_GPL(__mmu_notifier_invalidate_range_start);
 
 void __mmu_notifier_invalidate_range_end(struct mm_struct *mm,
 				  unsigned long start, unsigned long end)
@@ -187,6 +188,7 @@ void __mmu_notifier_invalidate_range_end
 	}
 	srcu_read_unlock(&srcu, id);
 }
+EXPORT_SYMBOL_GPL(__mmu_notifier_invalidate_range_end);
 
 static int do_mmu_notifier_register(struct mmu_notifier *mn,
 				    struct mm_struct *mm,
_

Patches currently in -mm which might be from cpw@sgi.com are

origin.patch


From: akpm@linux-foundation.org
Subject: + mm-export-mmu-notifier-invalidates.patch added to -mm tree
Date: Tue, 12 Feb 2013 14:00:38 -0800
Message-ID: <20130212220038.B086C31C1CF@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:57449 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab3BLWAj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Feb 2013 17:00:39 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so59117yhz.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Feb 2013 14:00:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cpw@sgi.com, holt@sgi.com


The patch titled
     Subject: mm: export mmu notifier invalidates
has been added to the -mm tree.  Its filename is
     mm-export-mmu-notifier-invalidates.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
mm-export-mmu-notifier-invalidates.patch


From: akpm@linux-foundation.org
Subject: - mm-fault-feedback-more-fixes.patch removed from -mm tree
Date: Wed, 18 Jul 2007 22:50:17 -0700
Message-ID: <200707190550.l6J5oHep016431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54901 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933174AbXGSFu0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 01:50:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: fault feedback more fixes
has been removed from the -mm tree.  Its filename was
     mm-fault-feedback-more-fixes.patch

This patch was dropped because it was folded into mm-fault-feedback-2.patch

------------------------------------------------------
Subject: mm: fault feedback more fixes
From: Nick Piggin <npiggin@suse.de>


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm26/mm/fault.c |    8 +++-----
 arch/ppc/mm/fault.c   |    4 ++--
 2 files changed, 5 insertions(+), 7 deletions(-)

diff -puN arch/arm26/mm/fault.c~mm-fault-feedback-more-fixes arch/arm26/mm/fault.c
--- a/arch/arm26/mm/fault.c~mm-fault-feedback-more-fixes
+++ a/arch/arm26/mm/fault.c
@@ -225,13 +225,11 @@ int do_page_fault(unsigned long addr, un
 	/*
 	 * Handle the "normal" case first
 	 */
-	if (unlikely(fault & VM_FAULT_SIGBUS))
-	case VM_FAULT_MINOR:
-	case VM_FAULT_MAJOR:
+	if (likely(!(fault & VM_FAULT_ERROR)))
 		return 0;
-	case VM_FAULT_SIGBUS:
+	if (fault & VM_FAULT_SIGBUS)
 		goto do_sigbus;
-	}
+	/* else VM_FAULT_OOM */
 
 	/*
 	 * If we are in kernel mode at this point, we
diff -puN arch/ppc/mm/fault.c~mm-fault-feedback-more-fixes arch/ppc/mm/fault.c
--- a/arch/ppc/mm/fault.c~mm-fault-feedback-more-fixes
+++ a/arch/ppc/mm/fault.c
@@ -259,9 +259,9 @@ good_area:
 		BUG();
 	}
 	if (fault & VM_FAULT_MAJOR)
-		tsk->maj_flt++;
+		current->maj_flt++;
 	else
-		tsk->min_flt++;
+		current->min_flt++;
 
 	up_read(&mm->mmap_sem);
 	/*
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-fault-feedback-1.patch
mm-fault-feedback-2.patch
mm-fault-feedback-more-fixes.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch

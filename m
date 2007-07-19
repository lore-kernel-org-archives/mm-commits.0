From: akpm@linux-foundation.org
Subject: - mm-fault-feedback-2-fix-2.patch removed from -mm tree
Date: Wed, 18 Jul 2007 22:50:15 -0700
Message-ID: <200707190550.l6J5oFt0016428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52032 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756149AbXGSFuZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 01:50:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm-fault-feedback-2-fix-2
has been removed from the -mm tree.  Its filename was
     mm-fault-feedback-2-fix-2.patch

This patch was dropped because it was folded into mm-fault-feedback-2.patch

------------------------------------------------------
Subject: mm-fault-feedback-2-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/fault.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/ia64/mm/fault.c~mm-fault-feedback-2-fix-2 arch/ia64/mm/fault.c
--- a/arch/ia64/mm/fault.c~mm-fault-feedback-2-fix-2
+++ a/arch/ia64/mm/fault.c
@@ -157,10 +157,10 @@ ia64_do_page_fault (unsigned long addres
 		 */
 		if (fault & VM_FAULT_OOM) {
 			goto out_of_memory;
+		} else if (fault & VM_FAULT_SIGBUS) {
 			signal = SIGBUS;
 			goto bad_area;
-		} else if (fault & VM_FAULT_SIGBUS)
-			goto do_sigbus;
+		}
 		BUG();
 	}
 	if (fault & VM_FAULT_MAJOR)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-fault-feedback-2.patch
mm-fault-feedback-2-fix-2.patch
readahead-split-ondemand-readahead-interface-into-two-functions-fix.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
add-sys-kernel-notes-fix.patch
lockstat-core-infrastructure.patch
lockstat-human-readability-tweaks-fix.patch
lockdep-various-fixes.patch
lockstat-measure-lock-bouncing.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
dequeue_huge_page-warning-fix.patch
lguest-the-host-code.patch
lguest-the-net-driver.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver-fix.patch
drivers-edac-new-i82975x-driver-fix.patch
